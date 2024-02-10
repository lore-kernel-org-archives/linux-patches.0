Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EDA339FD0
	for <patches@lists.linux.dev>; Sat, 10 Feb 2024 07:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707548999; cv=none; b=NNCTGW5hSRC/AL/0/ClCGXFDS11I1TfWuKFop/55/orrOKOSnHWThg0U2BEEH8OPeiOCqD/k3/6Qt2kv57tV80qyG+RML2eTV/v5kkK4oxULpp+QxgcFOxRQV1K0ttrLU4aonPS3WxdqOG8JjTKlljUPTGDWlNEkDFz9fVl2a9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707548999; c=relaxed/simple;
	bh=GwUq4JCcVzOBtEc3gN3wYan172xsmr2kIqhpahEGCT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hRfix0PMu43cj9HBHA7tQ4NJ29bgqH5oqplZ0dAnqJnWeZC1iXPJ9Sw9Jy+7ygoVd7Ele8782TcUMyNjVZ88fcg13irdXCCICrjqAcfq4lE/aWoosf2JI61bVIHsdZ5+XTyjcFG5V1jxgiRzhBUI/z3JumdrihOzOzsrOgSZkHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=oLV87Be9; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="oLV87Be9"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1d9b2400910so11870665ad.0
        for <patches@lists.linux.dev>; Fri, 09 Feb 2024 23:09:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1707548997; x=1708153797; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cLa98sn79mVMdRvO7elcd3rFtE2dKbRCTOlf+cCBAQk=;
        b=oLV87Be9CpI4Pq3nT6G1aN2PQMKjdZU0E7UxB2p1N9/+MB/dTlmiUsAx4axnH9mwhb
         tvh5lP203DxDL4fm3VuJUsD5GcU3nYa285UPaRnkbAc81u0jzQobP3Pby8V+v3h7JRad
         6vOuWPFKjFXYEwdm8uC8WYv75Q4kk4SteNl+M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707548997; x=1708153797;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cLa98sn79mVMdRvO7elcd3rFtE2dKbRCTOlf+cCBAQk=;
        b=KLS6Ekvy7vGJlx7Ig0He+NuAzhoSlxfOyBK45ck6nCqGa2QKeGABlcPbsZ3AzoHllp
         aUy6UAE8IoG9YgfowoJ5gQc9CE5Pwl6DLc1RK6QVRlxFEFMg2nuFH+5FDdQlg8iYVoFh
         BKkb7CBZw/9m0JVlLaTN7RvVTlFmNIq8hgO5IAOpB6qxY3GC8p+F2BCi7n0ws1S1XBC/
         HO4eP0yZlaNcvqtwoRwBIYhPWeXRBudESU0lCKXBX24zPznTn7Kx1HHxP++0G4O+GSI+
         Yz/16sQsNtXz3Cn2VJ/lF5MaRIg9Q/kt14fHVjw3HwzUQrBo/A3mt6/Klfbh6nMDXrTp
         R0Ww==
X-Forwarded-Encrypted: i=1; AJvYcCXxlXh7i7D/Jd5eUL6ObEOnPhfLGCjpN3klDwCbe8VroCuvjcM1ANfYHDHPPeNxuVYAsbyexwG2Rzr+OfWBheCzkRVA75D7JA==
X-Gm-Message-State: AOJu0YwT5VDBQAAdbp5F5uKszFH6jssc4eViPXy0lYrZ/7CRzhh6VUT5
	aoA48ny7sdLBP+OkxlmozFDYornttIilolg8jEVXh7NmIH1TRGhbELkV/kQZzA==
X-Google-Smtp-Source: AGHT+IF6Obhfaezt84euwognmHLhoystIjlBnFk4gq1ZlYgduARMLgwtIe7tncABPqYe8saWNFsTHA==
X-Received: by 2002:a17:903:1d2:b0:1d9:4143:5fe1 with SMTP id e18-20020a17090301d200b001d941435fe1mr2369262plh.0.1707548996758;
        Fri, 09 Feb 2024 23:09:56 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCX+9S47JyY4gdCNtKq6p6Q6R+TDCHy2IVHoHTOc3nq7FC2K4H+Qinp22boBPl2v6yZ3Q4nfK7yLXXNWHe0/UTHmWNVaY/x9pnV6ASHZjzlnHxUq/8MIEm+7/wUgodRVAn/yDQml5JspzkxJ78jfbivxNH9PUZJYbHMO0JQsxmgvSDNgkoUCsh5a+HE/+D7s3CmQJalrJlAc8t8MMidr7MP8A4QvVyfbaYvDJvKdvLo32/1Gr8tkoxt77ColNbqnY/a/7yQvf+M78QElBKweLeuDALe465OoJDkDM8V/8O/PiPQQAlZWfuKn/H6RPamx7SvzoEjD3ONViFyUaucVVRZ5bniRH6uPktTYY0H9qt3tU/QN1jh9xQ==
Received: from localhost (175.199.125.34.bc.googleusercontent.com. [34.125.199.175])
        by smtp.gmail.com with UTF8SMTPSA id ko13-20020a17090307cd00b001d88d791eccsm2507677plb.160.2024.02.09.23.09.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Feb 2024 23:09:56 -0800 (PST)
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
Subject: [PATCH 10/22] platform/chrome: cros_typec_switch: Move port creation code to sub-function
Date: Fri,  9 Feb 2024 23:09:21 -0800
Message-ID: <20240210070934.2549994-11-swboyd@chromium.org>
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

This driver will soon support devicetree firmwares. Extract the struct
cros_typec_port creation part of cros_typec_register_switches() into a
sub-function so that we can extend it for DT, where a graph is used
instead of child nodes.

Cc: Prashant Malani <pmalani@chromium.org>
Cc: Benson Leung <bleung@chromium.org>
Cc: Tzung-Bi Shih <tzungbi@kernel.org>
Cc: <chrome-platform@lists.linux.dev>
Cc: Pin-yen Lin <treapking@chromium.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/platform/chrome/cros_typec_switch.c | 113 +++++++++++---------
 1 file changed, 62 insertions(+), 51 deletions(-)

diff --git a/drivers/platform/chrome/cros_typec_switch.c b/drivers/platform/chrome/cros_typec_switch.c
index a23fe80d9d4b..1a718b661203 100644
--- a/drivers/platform/chrome/cros_typec_switch.c
+++ b/drivers/platform/chrome/cros_typec_switch.c
@@ -201,13 +201,69 @@ static int cros_typec_register_retimer(struct cros_typec_port *port, struct fwno
 	return PTR_ERR_OR_ZERO(port->retimer);
 }
 
-static int cros_typec_register_switches(struct cros_typec_switch_data *sdata)
+static int cros_typec_register_port(struct cros_typec_switch_data *sdata,
+				    struct fwnode_handle *fwnode)
 {
 	struct cros_typec_port *port;
 	struct device *dev = sdata->dev;
-	struct fwnode_handle *fwnode;
 	struct acpi_device *adev;
 	unsigned long long index;
+	int ret;
+
+	port = devm_kzalloc(dev, sizeof(*port), GFP_KERNEL);
+	if (!port)
+		return -ENOMEM;
+
+	adev = to_acpi_device_node(fwnode);
+	if (adev) {
+		ret = acpi_evaluate_integer(adev->handle, "_ADR", NULL, &index);
+		if (ACPI_FAILURE(ret)) {
+			dev_err(fwnode->dev, "_ADR wasn't evaluated\n");
+			return -ENODATA;
+		}
+	}
+
+	if (!adev) {
+		dev_err(fwnode->dev, "Couldn't get ACPI handle\n");
+		return -ENODEV;
+	}
+
+	if (index >= EC_USB_PD_MAX_PORTS) {
+		dev_err(fwnode->dev, "Invalid port index number: %llu\n", index);
+		return -EINVAL;
+	}
+	port->sdata = sdata;
+	port->port_num = index;
+	sdata->ports[index] = port;
+
+	if (fwnode_property_present(fwnode, "retimer-switch")) {
+		ret = cros_typec_register_retimer(port, fwnode);
+		if (ret) {
+			dev_err(dev, "Retimer switch register failed\n");
+			return ret;
+		}
+
+		dev_dbg(dev, "Retimer switch registered for index %llu\n", index);
+	}
+
+	if (!fwnode_property_present(fwnode, "mode-switch"))
+		return 0;
+
+	ret = cros_typec_register_mode_switch(port, fwnode);
+	if (ret) {
+		dev_err(dev, "Mode switch register failed\n");
+		return ret;
+	}
+
+	dev_dbg(dev, "Mode switch registered for index %llu\n", index);
+
+	return ret;
+}
+
+static int cros_typec_register_switches(struct cros_typec_switch_data *sdata)
+{
+	struct device *dev = sdata->dev;
+	struct fwnode_handle *fwnode;
 	int nports, ret;
 
 	nports = device_get_child_node_count(dev);
@@ -217,60 +273,15 @@ static int cros_typec_register_switches(struct cros_typec_switch_data *sdata)
 	}
 
 	device_for_each_child_node(dev, fwnode) {
-		port = devm_kzalloc(dev, sizeof(*port), GFP_KERNEL);
-		if (!port) {
-			ret = -ENOMEM;
-			goto err_switch;
-		}
-
-		adev = to_acpi_device_node(fwnode);
-		if (!adev) {
-			dev_err(fwnode->dev, "Couldn't get ACPI device handle\n");
-			ret = -ENODEV;
-			goto err_switch;
-		}
-
-		ret = acpi_evaluate_integer(adev->handle, "_ADR", NULL, &index);
-		if (ACPI_FAILURE(ret)) {
-			dev_err(fwnode->dev, "_ADR wasn't evaluated\n");
-			ret = -ENODATA;
-			goto err_switch;
-		}
-
-		if (index >= EC_USB_PD_MAX_PORTS) {
-			dev_err(fwnode->dev, "Invalid port index number: %llu\n", index);
-			ret = -EINVAL;
-			goto err_switch;
-		}
-		port->sdata = sdata;
-		port->port_num = index;
-		sdata->ports[index] = port;
-
-		if (fwnode_property_present(fwnode, "retimer-switch")) {
-			ret = cros_typec_register_retimer(port, fwnode);
-			if (ret) {
-				dev_err(dev, "Retimer switch register failed\n");
-				goto err_switch;
-			}
-
-			dev_dbg(dev, "Retimer switch registered for index %llu\n", index);
-		}
-
-		if (!fwnode_property_present(fwnode, "mode-switch"))
-			continue;
-
-		ret = cros_typec_register_mode_switch(port, fwnode);
+		ret = cros_typec_register_port(sdata, fwnode);
 		if (ret) {
-			dev_err(dev, "Mode switch register failed\n");
-			goto err_switch;
+			fwnode_handle_put(fwnode);
+			goto err;
 		}
-
-		dev_dbg(dev, "Mode switch registered for index %llu\n", index);
 	}
 
 	return 0;
-err_switch:
-	fwnode_handle_put(fwnode);
+err:
 	cros_typec_unregister_switches(sdata);
 	return ret;
 }
-- 
https://chromeos.dev

