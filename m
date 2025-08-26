Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB9A13FD86;
	Tue, 26 Aug 2025 13:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215061; cv=none; b=XmovIkZro6gtTk/3keqDCAxqd1wNXAjQjurA2f6KBle10QPt4eCc4eY/7y+Z0nxXvfFCjY+f0XmFfQC8t4bJ5EqPg/I9SIXumFRfsBfuQzI68MiJmdRK2swJSvi091YPTBnBbh2cppibKp4LeArOsCqjL38omFliSkDFpJsiWnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215061; c=relaxed/simple;
	bh=0DnmUkWyfHloBFje0X90vrzZG5ixcyKxRK86UD94aWo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cZqOWfiDKeCoIKDuLNhuYvmMlz600YQSKeGNa9wVNU+1FFLduXoaMpd4sxswWnbn6fTQ3H+7BL7oa56PL2nBg+jwc41c6HZ5o+PPYGzSOokHo5CQUI2k7jeBg2b6RbMyGBTk/GVOSeyw7o2zHpAllSHoLXOSihouUaensYT1RbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J2G4cmd+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J2G4cmd+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5554C4CEF1;
	Tue, 26 Aug 2025 13:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215061;
	bh=0DnmUkWyfHloBFje0X90vrzZG5ixcyKxRK86UD94aWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J2G4cmd+gwyxCgGehN038XM3JsQ5OmtSJB9ecZ8kr4esa4FhF5c9teP3R0a79Hq5A
	 xhnp7RHO6e/1PVeVxflp1a+zMY9vcXBOTCuWi8bUyNLADrpIkIbTjEHZUfIg/TZGes
	 pJjSaE+lCthEFphJYnv97TmvvZ7YgYu/OdJ7hQ7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <groeck@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 372/482] platform/chrome: cros_ec: remove unneeded label and if-condition
Date: Tue, 26 Aug 2025 13:10:25 +0200
Message-ID: <20250826110940.023691065@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tzung-Bi Shih <tzungbi@kernel.org>

[ Upstream commit 554ec02c97254962bbb0a8776c3160d294fc7e51 ]

Both `ec_dev->ec` and `ec_dev->pd` are initialized to NULL at the
beginning of cros_ec_register().  Also, platform_device_unregister()
takes care if the given platform_device is NULL.

Remove the unneeded goto-label and if-condition.

Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Reviewed-by: Guenter Roeck <groeck@chromium.org>
Link: https://lore.kernel.org/r/20230308031247.2866401-1-tzungbi@kernel.org
Stable-dep-of: e23749534619 ("platform/chrome: cros_ec: Unregister notifier in cros_ec_unregister()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/chrome/cros_ec.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/drivers/platform/chrome/cros_ec.c
+++ b/drivers/platform/chrome/cros_ec.c
@@ -205,7 +205,7 @@ int cros_ec_register(struct cros_ec_devi
 	err = cros_ec_query_all(ec_dev);
 	if (err) {
 		dev_err(dev, "Cannot identify the EC: error %d\n", err);
-		goto destroy_mutex;
+		goto exit;
 	}
 
 	if (ec_dev->irq > 0) {
@@ -217,7 +217,7 @@ int cros_ec_register(struct cros_ec_devi
 		if (err) {
 			dev_err(dev, "Failed to request IRQ %d: %d\n",
 				ec_dev->irq, err);
-			goto destroy_mutex;
+			goto exit;
 		}
 	}
 
@@ -229,7 +229,7 @@ int cros_ec_register(struct cros_ec_devi
 		dev_err(ec_dev->dev,
 			"Failed to create CrOS EC platform device\n");
 		err = PTR_ERR(ec_dev->ec);
-		goto destroy_mutex;
+		goto exit;
 	}
 
 	if (ec_dev->max_passthru) {
@@ -295,7 +295,6 @@ int cros_ec_register(struct cros_ec_devi
 exit:
 	platform_device_unregister(ec_dev->ec);
 	platform_device_unregister(ec_dev->pd);
-destroy_mutex:
 	mutex_destroy(&ec_dev->lock);
 	lockdep_unregister_key(&ec_dev->lockdep_key);
 	return err;
@@ -312,8 +311,7 @@ EXPORT_SYMBOL(cros_ec_register);
  */
 void cros_ec_unregister(struct cros_ec_device *ec_dev)
 {
-	if (ec_dev->pd)
-		platform_device_unregister(ec_dev->pd);
+	platform_device_unregister(ec_dev->pd);
 	platform_device_unregister(ec_dev->ec);
 	mutex_destroy(&ec_dev->lock);
 	lockdep_unregister_key(&ec_dev->lockdep_key);


