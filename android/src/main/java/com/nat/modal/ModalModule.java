package com.nat.modal;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.view.Gravity;
import android.widget.EditText;
import android.widget.Toast;

import java.util.HashMap;

/**
 * Created by xuqinchao on 17/2/7.
 *  Copyright (c) 2017 Instapp. All rights reserved.
 */

public class ModalModule {
    private Toast mToast;

    private static volatile ModalModule instance = null;

    private ModalModule(){
    }

    public static ModalModule getInstance() {
        if (instance == null) {
            synchronized (ModalModule.class) {
                if (instance == null) {
                    instance = new ModalModule();
                }
            }
        }

        return instance;
    }

    public void alert(Activity activity, HashMap<String, String> param, final ModuleResultListener listener) {
        String title = "";
        String message = "";
        String okButton = "OK";

        if (param != null) {
            title = param.containsKey("title")?param.get("title"):title;
            message = param.containsKey("message")?param.get("message"):message;
            okButton = param.containsKey("okButton") ? param.get("okButton") : okButton;
        }

        AlertDialog.Builder builder = new AlertDialog.Builder(activity);
        builder.setTitle(title)
                .setMessage(message)
                .setPositiveButton(okButton, new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        listener.onResult(null);
                    }
                }).create();
        builder.show();
    }

    public void confirm(Activity activity, HashMap<String, String> param, final ModuleResultListener listener) {
        String title = "";
        String message = "";
        String okButton = "OK";
        String cancelButton = "Cancel";

        if (param != null) {
            title = param.containsKey("title")?param.get("title"):"";
            message = param.containsKey("message")?param.get("message"):"";
            okButton = param.containsKey("okButton") ? param.get("okButton") : "OK";
            cancelButton = param.containsKey("cancelButton") ? param.get("cancelButton") : "Cancel";
        }

        AlertDialog.Builder builder = new AlertDialog.Builder(activity);
        builder.setTitle(title)
                .setMessage(message)
                .setNegativeButton(cancelButton, new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        listener.onResult(false);
                    }
                })
                .setPositiveButton(okButton, new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        listener.onResult(true);
                    }
                }).create();
        builder.show();
    }

    public void prompt(Activity activity, HashMap<String, String> param, final ModuleResultListener listener) {
        final HashMap<String, Object> result = new HashMap<>();

        String title = "";
        String message = "";
        String text = "";
        String okButton = "OK";
        String cancelButton = "Cancel";
        if (param != null) {
            title = param.containsKey("title")?param.get("title"):title;
            message = param.containsKey("message")?param.get("message"):message;
            text = param.containsKey("text")?param.get("text"):text;
            okButton = param.containsKey("okButton") ? param.get("okButton") : okButton;
            cancelButton = param.containsKey("cancelButton") ? param.get("cancelButton") : cancelButton;
        }

        final EditText editText = new EditText(activity);
        editText.setText(text);
        AlertDialog.Builder builder = new AlertDialog.Builder(activity);
        builder.setTitle(title)
                .setMessage(message)
                .setView(editText)
                .setNegativeButton(cancelButton, new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        result.put("result", false);
                        result.put("data", editText.getText().toString().trim());
                        listener.onResult(result);
                    }
                })
                .setPositiveButton(okButton, new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        result.put("result", true);
                        result.put("data", editText.getText().toString().trim());
                        listener.onResult(result);
                    }
                })
                .create()
                .show();
    }

    public void toast(Activity activity, HashMap<String, String> param, ModuleResultListener listener) {
        if (mToast != null) {
            mToast.cancel();
        }
        int duration  = 0;
        String message = "";
        String position = "bottom";

        if (param != null) {
            message = param.get("message") == null ? "":param.get("message");
            try {
                duration = Integer.parseInt(param.get("duration"));
            } catch (Exception e) {
                e.printStackTrace();
            }
            position = param.containsKey("position") ? param.get("position") : "bottom";
        }

        mToast = Toast.makeText(activity, message, duration > 3000? Toast.LENGTH_LONG:Toast.LENGTH_SHORT);
        switch (position) {
            case "top":
                mToast.setGravity(Gravity.TOP, 0, (int) Util.dp2px(activity, 96));
                break;
            case "middle":
                mToast.setGravity(Gravity.CENTER, 0, 0);
                break;
            default:
                mToast.setGravity(Gravity.BOTTOM, 0, (int) Util.dp2px(activity, 48));
                break;
        }
        mToast.show();
        listener.onResult(null);
    }
}
