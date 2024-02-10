Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C758839846
	for <patches@lists.linux.dev>; Sat, 10 Feb 2024 07:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707549003; cv=none; b=n+40p31Buqa32FWDYwOtaIUTUssPO7TWpHMzQSKHX+EiKxw42k5blQCCV3ltpVwE9Nyelv5Dn398jr+PVLJ7cN2ScNyv7u7kabDjN1WTQQulQRoWrvEmiqVhDOgBtDzwDXtEubiJjalxiFsCEp7uwgDQkxoNAbtWCvF76z2Gi24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707549003; c=relaxed/simple;
	bh=t7tvQJG6YlEt+ycy0C88MvbSQbeNL2T8HNinf+f8mhU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t7IW0CAiKeseXsc4jemFxznuMqsrJXcwzUW+slfQKWCb0yInlPP5FpvyycCH7W7RwItmLKzUkI/lDZGsDixF5m42PKLHt0lVXFQ6P35NaPJqdadxwb5qE13a0R4GSHKJ79QIxqexMOGl8uu3SR0n2mRG9hJKQkVRe9NSv04qZX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=S3cUE1W/; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="S3cUE1W/"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1d7881b1843so15517215ad.3
        for <patches@lists.linux.dev>; Fri, 09 Feb 2024 23:10:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1707549000; x=1708153800; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7RRDNZyVj04t5JHoAjAOJhQ0Jr4YTOazbyEccudCdmM=;
        b=S3cUE1W/EHO+Z2YJn0FxLFzONKwb23eZf79y4NZrNvFjivm78S7FwUxg2rblKmmGt4
         BsFrrS07MWVE+ff0ROSQb6sufNtUTNmc2gyFDrBoiykynavWJW1Oo2umR2uSgkHclF5J
         mFLuDtn8BlYQBT12BxPCNjTxacIdq09yz9mnM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707549000; x=1708153800;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7RRDNZyVj04t5JHoAjAOJhQ0Jr4YTOazbyEccudCdmM=;
        b=w/zMIKwP9PTQnmHDjaZkBU55HjRw4a4E8vF5Ug7ssRj8USm0u7533i/KT7waNu90fO
         yZsxkk6k28l/cFPInIdQzicJwTkpQEfWWrMsx3q2ArXemnKXhblR3LVgH24Ef37GNixt
         6V3zGXxsFIG3EnTKH0iZYW929YYcun3nIK3QU9+TdLru2jbeXNJmoAkrmjjYim52Rjvt
         afKrvtZjv5DohaOkT0e7uhUgacT+NCtZUEdUOr1xGa0WqAZrjX6KXaSdWcigGm9CRJOe
         zS4xtaKru0xEBWRUdKBqjl7QQz+CBFVMROI1tGfiIG2zZsHqmCFujYmQpGRXShPHaNxB
         mj3Q==
X-Forwarded-Encrypted: i=1; AJvYcCXRDyCcrCuxB2Iaz+UHjxAf3L8vf5vA2kkAIGHLDD5vsDXNC2a6vgjYOzJEARmcpl+vA/Uf4vaMLP8rZ30Ib7WOsIs4E+Db/g==
X-Gm-Message-State: AOJu0YyEWLQjIEcaCNx7q3kIRwQc5Jow256MsKmwmnTTkxf5xhhfq0UH
	e70N2DVqJgp9xr3keBBUNywc8F3r80cESQoTHvwccyg5f5SRVeNQY/gfqVEqSjrvREJlmxro8BU
	=
X-Google-Smtp-Source: AGHT+IH18BL+v1/eWB00jAhbCH1MDFkNv9w/KlvOVehkJbrbvpOewOqpcto8HNZ+VsYssctW+PUIzg==
X-Received: by 2002:a17:902:ed0d:b0:1d8:f106:cb92 with SMTP id b13-20020a170902ed0d00b001d8f106cb92mr1839715pld.10.1707549000129;
        Fri, 09 Feb 2024 23:10:00 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCU0h1bRFaEg+rFVuvzPvT72dcm+HAwsdsZCtHAhkEgEg7ayFRJauNl11VSY6YyDygPUNI2UG6VppFLvyEcP1cUA7q4TWT/wBEpaKTuLlo1sFWBgnfseptqeqG6Hg1IkRQ9dNwDd4lqNtxcY52R6emzrYCP7HCrScCjDEWljoS6c7AOh87gnSGt5+hp5SlsPjSsnpQtKieFzEbu0EOef+qB5OGN6nxsB9GMlCKqB/j68OVjeK744K3lk0ESlRGxMYhNXMCSKFgk8Elqiyq2vZevQj+KQpmzXdYRkOfd+wDBcyqvMIwCuM9ETiJeHyCkeUomMvvZov9KbLZH8a3E6K5cRdwkpph2vzwvMDbKrzGVewJpz8y0J7g==
Received: from localhost (175.199.125.34.bc.googleusercontent.com. [34.125.199.175])
        by smtp.gmail.com with UTF8SMTPSA id kw3-20020a170902f90300b001d9fc6cbc51sm2487629plb.244.2024.02.09.23.09.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Feb 2024 23:09:59 -0800 (PST)
From: Stephen Boyd <swboyd@chromium.org>
To: chrome-platform@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	devicetree@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	Douglas Anderson <dianders@chromium.org>,
	Pin-yen Lin <treapking@chromium.org>,
	Prashant Malani <pmalani@chromium.org>,
	Benson Leung <bleung@chromium.org>,
	Tzung-Bi Shih <tzungbi@kernel.org>
Subject: [PATCH 12/22] platform/chrome: cros_typec_switch: Use dev_err_probe()
Date: Fri,  9 Feb 2024 23:09:23 -0800
Message-ID: <20240210070934.2549994-13-swboyd@chromium.org>
X-Mailer: git-send-email 2.43.0.687.g38aa6559b0-goog
In-Reply-To: <20240210070934.2549994-1-swboyd@chromium.org>
References: <20240210070934.2549994-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use dev_err_probe() helper so we can get better diagnostics when driver
probes fails for any reason.

Cc: Prashant Malani <pmalani@chromium.org>
Cc: Benson Leung <bleung@chromium.org>
Cc: Tzung-Bi Shih <tzungbi@kernel.org>
Cc: <chrome-platform@lists.linux.dev>
Cc: Pin-yen Lin <treapking@chromium.org>

Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/platform/chrome/cros_typec_switch.c | 36 +++++++--------------
 1 file changed, 12 insertions(+), 24 deletions(-)

diff --git a/drivers/platform/chrome/cros_typec_switch.c b/drivers/platform/chrome/cros_typec_switch.c
index 373e0e86ebfc..769de2889f2f 100644
--- a/drivers/platform/chrome/cros_typec_switch.c
+++ b/drivers/platform/chrome/cros_typec_switch.c
@@ -219,31 +219,23 @@ static int cros_typec_register_port(struct cros_typec_switch_data *sdata,
 	if (adev)
 		prop_name = "_ADR";
 
-	if (!adev) {
-		dev_err(fwnode->dev, "Couldn't get ACPI handle\n");
-		return -ENODEV;
-	}
+	if (!adev)
+		return dev_err_probe(fwnode->dev, -ENODEV, "Couldn't get ACPI handle\n");
 
 	ret = fwnode_property_read_u32(fwnode, prop_name, &index);
-	if (ret) {
-		dev_err(fwnode->dev, "%s property wasn't found\n", prop_name);
-		return ret;
-	}
+	if (ret)
+		return dev_err_probe(fwnode->dev, ret, "%s property wasn't found\n", prop_name);
 
-	if (index >= EC_USB_PD_MAX_PORTS) {
-		dev_err(fwnode->dev, "Invalid port index number: %u\n", index);
-		return -EINVAL;
-	}
+	if (index >= EC_USB_PD_MAX_PORTS)
+		return dev_err_probe(fwnode->dev, -EINVAL, "Invalid port index number: %u\n", index);
 	port->sdata = sdata;
 	port->port_num = index;
 	sdata->ports[index] = port;
 
 	if (fwnode_property_present(fwnode, "retimer-switch")) {
 		ret = cros_typec_register_retimer(port, fwnode);
-		if (ret) {
-			dev_err(dev, "Retimer switch register failed\n");
-			return ret;
-		}
+		if (ret)
+			return dev_err_probe(dev, ret, "Retimer switch register failed\n");
 
 		dev_dbg(dev, "Retimer switch registered for index %u\n", index);
 	}
@@ -252,10 +244,8 @@ static int cros_typec_register_port(struct cros_typec_switch_data *sdata,
 		return 0;
 
 	ret = cros_typec_register_mode_switch(port, fwnode);
-	if (ret) {
-		dev_err(dev, "Mode switch register failed\n");
-		return ret;
-	}
+	if (ret)
+		return dev_err_probe(dev, ret, "Mode switch register failed\n");
 
 	dev_dbg(dev, "Mode switch registered for index %u\n", index);
 
@@ -269,10 +259,8 @@ static int cros_typec_register_switches(struct cros_typec_switch_data *sdata)
 	int nports, ret;
 
 	nports = device_get_child_node_count(dev);
-	if (nports == 0) {
-		dev_err(dev, "No switch devices found.\n");
-		return -ENODEV;
-	}
+	if (nports == 0)
+		return dev_err_probe(dev, -ENODEV, "No switch devices found\n");
 
 	device_for_each_child_node(dev, fwnode) {
 		ret = cros_typec_register_port(sdata, fwnode);
-- 
https://chromeos.dev

