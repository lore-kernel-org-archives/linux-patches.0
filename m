Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 031206135
	for <patches@lists.linux.dev>; Tue, 30 Aug 2022 22:58:34 +0000 (UTC)
Received: by mail-pj1-f50.google.com with SMTP id j9-20020a17090a3e0900b001fd9568b117so9658983pjc.3
        for <patches@lists.linux.dev>; Tue, 30 Aug 2022 15:58:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=k6LA1rNyhTjjcasNmZFLeY+W8E8y8NGMThT486iHSoY=;
        b=Ep24sHO070cnIFiiLG6kNJPWDqR2eSE+4qF+qy1Dpph5f6mj79zWGMf3QxdFk/MnWf
         S5NN4Jf7V/9x14Ed4VoZUnHArb2dtaW8KqL3LDsl17cTZoAmeNNJHhe90BGX5qkR34Gd
         UEfG8SF4TaeCxXk2M0BoSMAIfW2qddG9ZcM7Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=k6LA1rNyhTjjcasNmZFLeY+W8E8y8NGMThT486iHSoY=;
        b=IZa4CyVLaKOOF7e30dH15OyO/F1FLLBThxuE111hUgQKgModIbFy/KwgMdzpCBLl8O
         1S6y3M3SmtxoxHgFCPY9HA1T1g90cUCK3Ext1JBL6BSwuCbBf2nfpo0gfYLp/Xm3pi0c
         BH2sa4nsEVzjOPXCgz3vQt1u2eZ/NzxQV2aDIO5Qwi3vN7a0Mq/ybyFVChPGaszvPamQ
         APvx4xAJA5mdaNYHJlDofl6IIN9Y+3dKWFmZUGgsGzly46AcDaaeXrFM3SBW0kZj0hwf
         SLCz8oubvq3J32lWvxzim/d2JZwsiySjCz+5qdh32bMgTQ0jTtSmtBAvN9qMLSAR7Xc0
         R/Vg==
X-Gm-Message-State: ACgBeo3+3CbCjSG6IWF+mT82y2mkAr4hMJt/aaJMIdKVM+R4IGYP0sqF
	cneBmWQ9oWzZG8LSyTlcVZEyhA==
X-Google-Smtp-Source: AA6agR6soIRzWhUs7dOLjwua1oVBUDAFDTUzVhZQra4bxTiH3oROVieLZEHDWGIr1KvJ5tedIvAXHw==
X-Received: by 2002:a17:90a:f2cb:b0:1fd:90a0:56e3 with SMTP id gt11-20020a17090af2cb00b001fd90a056e3mr269959pjb.113.1661900314469;
        Tue, 30 Aug 2022 15:58:34 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:201:5f34:2f6:2856:188e])
        by smtp.gmail.com with ESMTPSA id bf3-20020a170902b90300b001743be790b4sm10083539plb.215.2022.08.30.15.58.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 15:58:34 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Prashant Malani <pmalani@chromium.org>,
	Benson Leung <bleung@chromium.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	chrome-platform@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>
Subject: [PATCH 1/4] platform/chrome: cros_typec_switch: Add missing newline on printk
Date: Tue, 30 Aug 2022 15:58:28 -0700
Message-Id: <20220830225831.2362403-2-swboyd@chromium.org>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
In-Reply-To: <20220830225831.2362403-1-swboyd@chromium.org>
References: <20220830225831.2362403-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We need a newline here to ensure the next printk starts fresh.

Cc: Prashant Malani <pmalani@chromium.org>
Cc: Tzung-Bi Shih <tzungbi@kernel.org>
Fixes: affc804c44c8 ("platform/chrome: cros_typec_switch: Add switch driver")
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/platform/chrome/cros_typec_switch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/chrome/cros_typec_switch.c b/drivers/platform/chrome/cros_typec_switch.c
index f85687adb594..383daf2c66b7 100644
--- a/drivers/platform/chrome/cros_typec_switch.c
+++ b/drivers/platform/chrome/cros_typec_switch.c
@@ -244,7 +244,7 @@ static int cros_typec_register_switches(struct cros_typec_switch_data *sdata)
 		}
 
 		if (index < 0 || index >= EC_USB_PD_MAX_PORTS) {
-			dev_err(fwnode->dev, "Invalid port index number: %llu", index);
+			dev_err(fwnode->dev, "Invalid port index number: %llu\n", index);
 			ret = -EINVAL;
 			goto err_switch;
 		}
-- 
https://chromeos.dev

