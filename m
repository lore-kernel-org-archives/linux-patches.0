Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FCC7204F7C
	for <patches@lists.linux.dev>; Thu,  9 Jan 2025 22:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736460421; cv=none; b=bwmutUmkAPNVrY9xwCvr/IwBGryWwYuXdnNRfNI8LwALRj5/6lnfqTRJRKoKEODf8USogUenEEyWedHaGJFy3LXEtyH1b+lVpgrFefekSkkFd+kT+4DZk5Y3+iHPUvTR3aTzekJ/dMK/aB5HyiG7WKZsCHDNbfyY01uzVEQIKK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736460421; c=relaxed/simple;
	bh=691TqzGyV4dZ3erdSQoQB9mOFtSofyCtfYUX2KRcl7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bEiQOgSQCQ3Be+tHfAIV0tdgG0rqJQxwWuE5DYuJajkDIubaE08toWykyqpuaDv3O/vFdtLzex0GfTAtXsjKisxFiLt8aoY/ckoSpNXTJ6GYGDh5Udh3RQ6wb//nR70xKgAN95XxfE2aCPQQlJWTkkE5u8Dc55oJph/qC/CcvoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=K2vpyulW; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="K2vpyulW"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-2f4448bf96fso1920333a91.0
        for <patches@lists.linux.dev>; Thu, 09 Jan 2025 14:06:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1736460419; x=1737065219; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z+eJFfeJOCQC8B0IGpcCvXtjQAJSXPizwns60bTTIB0=;
        b=K2vpyulWQMGtlE0kdx+GfHppK0QcgLREoF6Flf2PoS91ife8O4uUDiFqE7mx4UqN3h
         RjJ+oX3WmiFTzNHo2McYvLptbgoHa1IpsEcsuIbWBlL1bFxrsJmYevgVLV7xuiL10LoI
         IKaoeWMXov9oaYwS6zY3keTMTAtNdA+so3jF0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736460419; x=1737065219;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z+eJFfeJOCQC8B0IGpcCvXtjQAJSXPizwns60bTTIB0=;
        b=ME7EtmDhcYmyedZerVwc5jVX8Vyq1aFTg4KE/HJSrEAAdhKSoUiSmsvczq/CA7+S14
         hfy7pXmRDPMnjN1R556Cr0wzfuniQJQcYZWMSyqYvYf7M/rufugzAaBIPWoCaOsxIGMq
         /3z56iLbbRKEbS7fFmDAeJEfU7U6Af6FZj0cztMcm/IhZKwyBjENaC6taXsS96rZvtR3
         eIW98G8a61zAc2DlO696ajgNuOKgTZ5NZsJk4+P/H4F7ze5OjsMrPPjosPD7y47SRAr+
         Nn6LGeFk/qanBjGkrEQh7eGdgnd+qJ5n1e6fRKWdTe018tMuoVyE7K7B04hhvhsFwWLj
         TiyA==
X-Forwarded-Encrypted: i=1; AJvYcCUOX8rVczdRWc+o+nzLOEqx5b9PdCtm86W0qhZo2+4ZTSH7mcbLeAz2lwiy1BfwLmfIMJdjkYn0@lists.linux.dev
X-Gm-Message-State: AOJu0YzkCxNXc9pAMp2x+aysjTVu04soJ/1FbOYqgE59nUMIvTLE35tr
	qQb5e7eU3mkfDHoaeHv+0Mb/bhjuGBD7+CeYgPZP33R4VxI7Vz8eWO4CdFhiKg==
X-Gm-Gg: ASbGncsGtHkNQw2YBsgRlNjZ2t1tf4/g2jabzg4Ld5LwUeRHTebQgF9ZjUyE+uDYD+K
	KfecgETDN9i9s7eEIQhBGjRw37DoWVluLek4X5hCOuzOM/icgyJcaQ+Og8eVmuBfhu3aRNr3whF
	BWWWOl4B/tt/6+q8tv8AnfDcVrfCY1qPYdfEwVO+3FgJR2VfydHpfcxrU7Ut9Fp4X06171ehUkJ
	vv6HJX4D/ZqrGc5ThuemU5L7yMbaG/Z/zBjCWknZlgaxjRVa0LeoszZU/jkMCkYfP6RiwAB/QnL
	RLvBOdYnDsjSmk5lP/Fi
X-Google-Smtp-Source: AGHT+IHzMYBCU9fhbsnYh9NWeAdMwj9Nwk1H7/x3TSzmEP5o6kwN3Jz62wlfhHKZZQXr7JP3SQG5ag==
X-Received: by 2002:a17:90a:d64b:b0:2ee:8aa7:94a0 with SMTP id 98e67ed59e1d1-2f548f42490mr10734733a91.32.1736460419093;
        Thu, 09 Jan 2025 14:06:59 -0800 (PST)
Received: from localhost (129.135.125.34.bc.googleusercontent.com. [34.125.135.129])
        by smtp.gmail.com with UTF8SMTPSA id 98e67ed59e1d1-2f54a2ad2e4sm4177805a91.28.2025.01.09.14.06.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jan 2025 14:06:58 -0800 (PST)
From: Stephen Boyd <swboyd@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Benson Leung <bleung@chromium.org>,
	chrome-platform@lists.linux.dev,
	linux-usb@vger.kernel.org,
	Pavan Holla <pholla@chromium.org>,
	Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
	=?UTF-8?q?=C5=81ukasz=20Bartosik?= <ukaszb@chromium.org>
Subject: [PATCH 1/2] usb: typec: cros-ec-ucsi: Add newlines to printk messages
Date: Thu,  9 Jan 2025 14:06:52 -0800
Message-ID: <20250109220655.1677506-2-swboyd@chromium.org>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
In-Reply-To: <20250109220655.1677506-1-swboyd@chromium.org>
References: <20250109220655.1677506-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

These printks need newlines. Add them and convert to dev_err_probe() in
cros_ucsi_probe() to simplify code.

Cc: Pavan Holla <pholla@chromium.org>
Cc: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Cc: Łukasz Bartosik <ukaszb@chromium.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/usb/typec/ucsi/cros_ec_ucsi.c | 28 ++++++++++++---------------
 1 file changed, 12 insertions(+), 16 deletions(-)

diff --git a/drivers/usb/typec/ucsi/cros_ec_ucsi.c b/drivers/usb/typec/ucsi/cros_ec_ucsi.c
index db8324b71ee9..75646a8d55be 100644
--- a/drivers/usb/typec/ucsi/cros_ec_ucsi.c
+++ b/drivers/usb/typec/ucsi/cros_ec_ucsi.c
@@ -58,14 +58,14 @@ static int cros_ucsi_read(struct ucsi *ucsi, unsigned int offset, void *val,
 	int ret;
 
 	if (val_len > MAX_EC_DATA_SIZE) {
-		dev_err(udata->dev, "Can't read %zu bytes. Too big.", val_len);
+		dev_err(udata->dev, "Can't read %zu bytes. Too big.\n", val_len);
 		return -EINVAL;
 	}
 
 	ret = cros_ec_cmd(udata->ec, 0, EC_CMD_UCSI_PPM_GET,
 			  &req, sizeof(req), val, val_len);
 	if (ret < 0) {
-		dev_warn(udata->dev, "Failed to send EC message UCSI_PPM_GET: error=%d", ret);
+		dev_warn(udata->dev, "Failed to send EC message UCSI_PPM_GET: error=%d\n", ret);
 		return ret;
 	}
 	return 0;
@@ -99,7 +99,7 @@ static int cros_ucsi_async_control(struct ucsi *ucsi, u64 cmd)
 	ret = cros_ec_cmd(udata->ec, 0, EC_CMD_UCSI_PPM_SET,
 			  req, sizeof(ec_buf), NULL, 0);
 	if (ret < 0) {
-		dev_warn(udata->dev, "Failed to send EC message UCSI_PPM_SET: error=%d", ret);
+		dev_warn(udata->dev, "Failed to send EC message UCSI_PPM_SET: error=%d\n", ret);
 		return ret;
 	}
 	return 0;
@@ -161,7 +161,7 @@ static void cros_ucsi_write_timeout(struct work_struct *work)
 
 	if (cros_ucsi_read(udata->ucsi, UCSI_CCI, &cci, sizeof(cci))) {
 		dev_err(udata->dev,
-			"Reading CCI failed; no write timeout recovery possible.");
+			"Reading CCI failed; no write timeout recovery possible.\n");
 		return;
 	}
 
@@ -173,7 +173,7 @@ static void cros_ucsi_write_timeout(struct work_struct *work)
 					      msecs_to_jiffies(WRITE_TMO_MS));
 		else
 			dev_err(udata->dev,
-				"PPM unresponsive - too many write timeouts.");
+				"PPM unresponsive - too many write timeouts.\n");
 
 		return;
 	}
@@ -208,7 +208,7 @@ static int cros_ucsi_event(struct notifier_block *nb,
 	if (!(host_event & PD_EVENT_PPM))
 		return NOTIFY_OK;
 
-	dev_dbg(udata->dev, "UCSI notification received");
+	dev_dbg(udata->dev, "UCSI notification received\n");
 	flush_work(&udata->work);
 	schedule_work(&udata->work);
 
@@ -237,10 +237,8 @@ static int cros_ucsi_probe(struct platform_device *pdev)
 	udata->dev = dev;
 
 	udata->ec = ec_data->ec_dev;
-	if (!udata->ec) {
-		dev_err(dev, "couldn't find parent EC device");
-		return -ENODEV;
-	}
+	if (!udata->ec)
+		return dev_err_probe(dev, -ENODEV, "couldn't find parent EC device\n");
 
 	platform_set_drvdata(pdev, udata);
 
@@ -249,24 +247,22 @@ static int cros_ucsi_probe(struct platform_device *pdev)
 	init_completion(&udata->complete);
 
 	udata->ucsi = ucsi_create(dev, &cros_ucsi_ops);
-	if (IS_ERR(udata->ucsi)) {
-		dev_err(dev, "failed to allocate UCSI instance");
-		return PTR_ERR(udata->ucsi);
-	}
+	if (IS_ERR(udata->ucsi))
+		return dev_err_probe(dev, PTR_ERR(udata->ucsi), "failed to allocate UCSI instance\n");
 
 	ucsi_set_drvdata(udata->ucsi, udata);
 
 	udata->nb.notifier_call = cros_ucsi_event;
 	ret = cros_usbpd_register_notify(&udata->nb);
 	if (ret) {
-		dev_err(dev, "failed to register notifier: error=%d", ret);
+		dev_err_probe(dev, ret, "failed to register notifier\n");
 		ucsi_destroy(udata->ucsi);
 		return ret;
 	}
 
 	ret = ucsi_register(udata->ucsi);
 	if (ret) {
-		dev_err(dev, "failed to register UCSI: error=%d", ret);
+		dev_err_probe(dev, ret, "failed to register UCSI\n");
 		cros_ucsi_destroy(udata);
 		return ret;
 	}
-- 
https://chromeos.dev

