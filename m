Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1348E632
	for <patches@lists.linux.dev>; Tue,  3 Oct 2023 00:34:32 +0000 (UTC)
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-692a885f129so283203b3a.0
        for <patches@lists.linux.dev>; Mon, 02 Oct 2023 17:34:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1696293272; x=1696898072; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=46Gu5AeGEBG3UAx8tqJHnnJONEDjYZ4KhZYReyw4USQ=;
        b=OrM35r6z9xBXbj80Q/e8jv9+nFmkEUbvyFVZsEPei2+Npky2Hfte3lqUNpfGJbZFY7
         h/cg0krGgQMSzkBpvcN6FojxyiQccTITFUvZuqJj0lX45jVpBV3ZufWP3uO6O8x4a/WV
         Q8urGKS+Oey8hgK8/YSRvxUhoYJfuOHcv8VFA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696293272; x=1696898072;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=46Gu5AeGEBG3UAx8tqJHnnJONEDjYZ4KhZYReyw4USQ=;
        b=bI9gbFP/TMaG9O4S1/xox06lJH2UHpHxDvH31h62GYSn4S8OAhWfWFb8JlgsnZPq2v
         mZHBysamugk1+0vrlJIh+iZzDoh1tipeyVNXD7Cx9BFnK8s/oJT6f63G4/eLFgPWQ4Fq
         OLYwiPRS5gwlY6B0WKbnRK3QE8w+NzHIyYmdYRcPqHuW1nlv3lfjIR6L2QyqLcNIIj28
         sigHzU/XtVz3RmCRwkHdxgK0n34q/3BS0UtgH+fpyXYsi6dv0MbMWrhmhTqDjGA55tW+
         HzbaGekWsAYw9wBd7tC7qWPwLDAeuGlnSjtD0KyyAPuWh3z6f13nrSl3OKvpARTJKghC
         3cpg==
X-Gm-Message-State: AOJu0YzClSCnimMtELSSrJB4pi7MNVFyIwe8tlMoEQTIVWD6G3bw4qLi
	85zh6XiEcSRqXH7VWma8tnmXPLSFFu2PDbkgk1c=
X-Google-Smtp-Source: AGHT+IGvXWxh0/ki0D/u+K73heFmTNq1LtY5KXiNcaoOMuKywOlbtvVWKFfjxlyMg48n/3EW54eZxg==
X-Received: by 2002:a05:6a20:5655:b0:133:b3a9:90d with SMTP id is21-20020a056a20565500b00133b3a9090dmr9920050pzc.36.1696293272344;
        Mon, 02 Oct 2023 17:34:32 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:11a:201:f676:8db:8677:aefe])
        by smtp.gmail.com with ESMTPSA id bm2-20020a056a00320200b0068a13b0b300sm101368pfb.11.2023.10.02.17.34.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Oct 2023 17:34:31 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Benson Leung <bleung@chromium.org>,
	Tzung-Bi Shih <tzungbi@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	chrome-platform@lists.linux.dev,
	Prashant Malani <pmalani@chromium.org>
Subject: [PATCH 1/4] platform/chrome: cros_ec_typec: Use semi-colons instead of commas
Date: Mon,  2 Oct 2023 17:34:25 -0700
Message-ID: <20231003003429.1378109-2-swboyd@chromium.org>
X-Mailer: git-send-email 2.42.0.582.g8ccd20d70d-goog
In-Reply-To: <20231003003429.1378109-1-swboyd@chromium.org>
References: <20231003003429.1378109-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These should be semi-colons so that one statement is per line.

Cc:  Prashant Malani <pmalani@chromium.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/platform/chrome/cros_ec_typec.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/platform/chrome/cros_ec_typec.c b/drivers/platform/chrome/cros_ec_typec.c
index d0b4d3fc40ed..82e7d08b52c7 100644
--- a/drivers/platform/chrome/cros_ec_typec.c
+++ b/drivers/platform/chrome/cros_ec_typec.c
@@ -271,9 +271,9 @@ static int cros_typec_register_port_altmodes(struct cros_typec_data *typec,
 	struct typec_altmode *amode;
 
 	/* All PD capable CrOS devices are assumed to support DP altmode. */
-	desc.svid = USB_TYPEC_DP_SID,
-	desc.mode = USB_TYPEC_DP_MODE,
-	desc.vdo = DP_PORT_VDO,
+	desc.svid = USB_TYPEC_DP_SID;
+	desc.mode = USB_TYPEC_DP_MODE;
+	desc.vdo = DP_PORT_VDO;
 	amode = typec_port_register_altmode(port->port, &desc);
 	if (IS_ERR(amode))
 		return PTR_ERR(amode);
@@ -287,8 +287,8 @@ static int cros_typec_register_port_altmodes(struct cros_typec_data *typec,
 	 * here for now.
 	 */
 	memset(&desc, 0, sizeof(desc));
-	desc.svid = USB_TYPEC_TBT_SID,
-	desc.mode = TYPEC_ANY_MODE,
+	desc.svid = USB_TYPEC_TBT_SID;
+	desc.mode = TYPEC_ANY_MODE;
 	amode = typec_port_register_altmode(port->port, &desc);
 	if (IS_ERR(amode))
 		return PTR_ERR(amode);
-- 
https://chromeos.dev

