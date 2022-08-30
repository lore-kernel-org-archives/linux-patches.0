Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7DB16134
	for <patches@lists.linux.dev>; Tue, 30 Aug 2022 22:58:35 +0000 (UTC)
Received: by mail-pl1-f178.google.com with SMTP id jm11so12485417plb.13
        for <patches@lists.linux.dev>; Tue, 30 Aug 2022 15:58:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=HwGs98rx5BCd9/rgNaN7+8SbaVUbF2hiZY4CVcaNvm4=;
        b=eB3MC0Tad/kB+uoOqsolA2dlwF8ySo8h9JTtZjitG+Gquo+Dyd6U0wXrnhlI9wf5fq
         JlVczQudCM5itV8dzFwRom6m3cIaoIo5oy2Ux5geWqHMWOZtyA6kqkxgfBqQeedxrt6u
         bi0PcJIDVpLWQgfcc1QRNrVY0jqV+m7v4XbbU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=HwGs98rx5BCd9/rgNaN7+8SbaVUbF2hiZY4CVcaNvm4=;
        b=4YdojsGB32JNn5oE6PDyuWe8B0bAmH/v25qyNgFvIESvRNltkpcEgzW9pVWEW82yYK
         poR8d6K+6PSaa7Pyr4IvlJww8mAPUF909T9Agxp4rj3kwf969egxOS/oQyxubzbXElHS
         tSfusOSgMfR+Xk8ePrxY429oJnyraR9Tu4UM8zQiI0oBz4Nmnw9mPhkWBqBb+LelMJfv
         JboAkN2uZrPlulnkoxu6qb2eQw246QspH6MS27EkF524/7OmyqNz3gfvfbK92Z+S9cu/
         GCEnQSuBW/AB1lU3Oy88IlKxrpYjlE9edJQsMwURH0hn/o+5s5FtleJt/gDthv5U7oNy
         cYqQ==
X-Gm-Message-State: ACgBeo3Dpis//uMoB71zVFTJ0qE7DJK6oo2O3oKnTVFRP4eUDQ7BuVb7
	qyahHwhGSoPotk7lpn/Z3AksWw==
X-Google-Smtp-Source: AA6agR45HAcVMAFaGvKD+VuQ2Xa/q4B6SQ6eo25+pm9MGhFjmFQmLdcpsmWTCIr9hw1VRWyt+jKH8Q==
X-Received: by 2002:a17:90b:4b48:b0:1fd:d2cd:896c with SMTP id mi8-20020a17090b4b4800b001fdd2cd896cmr296743pjb.120.1661900315349;
        Tue, 30 Aug 2022 15:58:35 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:201:5f34:2f6:2856:188e])
        by smtp.gmail.com with ESMTPSA id bf3-20020a170902b90300b001743be790b4sm10083539plb.215.2022.08.30.15.58.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 15:58:35 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Prashant Malani <pmalani@chromium.org>,
	Benson Leung <bleung@chromium.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	chrome-platform@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>
Subject: [PATCH 2/4] platform/chrome: cros_typec_switch: Remove impossible condition
Date: Tue, 30 Aug 2022 15:58:29 -0700
Message-Id: <20220830225831.2362403-3-swboyd@chromium.org>
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

The type of 'index' is unsigned long long, which can't possibly be less
than zero. Remove the impossible check.

Cc: Prashant Malani <pmalani@chromium.org>
Cc: Tzung-Bi Shih <tzungbi@kernel.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/platform/chrome/cros_typec_switch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/chrome/cros_typec_switch.c b/drivers/platform/chrome/cros_typec_switch.c
index 383daf2c66b7..3381d842c307 100644
--- a/drivers/platform/chrome/cros_typec_switch.c
+++ b/drivers/platform/chrome/cros_typec_switch.c
@@ -243,7 +243,7 @@ static int cros_typec_register_switches(struct cros_typec_switch_data *sdata)
 			goto err_switch;
 		}
 
-		if (index < 0 || index >= EC_USB_PD_MAX_PORTS) {
+		if (index >= EC_USB_PD_MAX_PORTS) {
 			dev_err(fwnode->dev, "Invalid port index number: %llu\n", index);
 			ret = -EINVAL;
 			goto err_switch;
-- 
https://chromeos.dev

