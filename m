Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829206;
	b=16BEW5IEGvbJ4nswgkFEtbDMi55rkZVsXQgzVP0GD5dsP63nek8WpTe4+tzW5e3i9Wkb
	 0b3DfjfexyhEOnjDBP3FBWTDc8xawBReHMo+zDU/l1u8gDtPGsN1M2mtR3TX8CITHmrT3
	 2awLs5zbHbpeDkAxXaL5K4jrsgKRuCpy8sUcN5TcLBgRIBXo7L8vy/CFHYt3TW0GPm6+p
	 +dRpweXsILnu7LOiDGcU6PgePseJURLHNcFKs7Eck6YfB/v55BcCZ0Ce2uk9VZ0JiAC08
	 sZEJ/N/A4J0bRWtjrg4D+owm9FdCzESr2Na/6NTnAjlivKqOmthrqK+tsIlzzxEX6Zw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829206;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4PiDUfVyuFVuFSON2/m5DovdXYZkxlUqqQRoyJXq3EI=;
	b=wr+nd5qwn6o08faTOzh7LaqnNIhKtDRj7xQ3PVZGA7oe46otBkrGBIlPZ7JGcR1HDoBT
	 VANhz/UGDbo1snM+B9bMVUOEtD9jHOZg+N7d5sIDhnQKJdpCXUD22wjj3lBO8fuSxlXn1
	 wUGLFmtqqsfK8j5F/sDLCTNCdx+cUzMC7/eK88JwmwS+ZvI5O2HyifOK5qEDprCkQrmoF
	 fAoY1YzDDNuntiJa/CPUIRXqCy/SPwIXf5vPlQm5TBjT898filo/Dn2Hq3zY4JV4aogdo
	 I+nWwVorSvL2dsWxc2yUHXVRM+MK0MfDOeyzNbvnTkT7WepKRDm4Or7lyO6EijI60dg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lKs7yff1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DABF60A261E;
	Wed,  4 Nov 2026 21:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lKs7yff1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AE271F000C1;
	Wed,  4 Nov 2026 21:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829206;
	bh=4PiDUfVyuFVuFSON2/m5DovdXYZkxlUqqQRoyJXq3EI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lKs7yff1A2WjrAq2avSICm6VbCRGSIFFKqPv0u1BCKdFbNIjoaWnlc5gCyw2FuY7I
	 nK5At2yqYXEkMiZzs7JlUSGeOTw+ZNNPx2VI4CF9OR2aZqOZvRrXJSy3DzC28vvCMl
	 qpJYY3m7OyZQpzOG3qLYJx3KuNh3UHdFVXSMkt8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Derek J. Clark" <derekjohn.clark@gmail.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 7.3 512/547] HID: hid-lenovo-go-s: Move attribute init to after device query
Date: Wed,  4 Nov 2026 16:11:36 -0500
Message-ID: <20261104211052.937077223@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Derek J. Clark <derekjohn.clark@gmail.com>

commit 8f456881ba40a04494440663231ba773a06588f3 upstream.

Currently this driver registers attributes before the MCU is ready to
accept commands. This can lead to attribute access that blocks the MCU
in some rare cases.

Move attribute construction to gos_cfg_setup, after the device has been
queried. Gate creation to drvdata.gp_registered and
drvdata.rgb_registered so a resume before setup has run doesn't prevent
attribute creation or attempt to re-register the same attributes.

Fixes: a23f3497bf208c59ad ("HID: hid-lenovo-go-s: Add Lenovo Legion Go S Series HID Driver")
Cc: stable@vger.kernel.org
Signed-off-by: Derek J. Clark <derekjohn.clark@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-lenovo-go-s.c | 68 +++++++++++++++++++++++------------
 1 file changed, 45 insertions(+), 23 deletions(-)

diff --git a/drivers/hid/hid-lenovo-go-s.c b/drivers/hid/hid-lenovo-go-s.c
index 6d98fff6d987..f1a0bcfcdb71 100644
--- a/drivers/hid/hid-lenovo-go-s.c
+++ b/drivers/hid/hid-lenovo-go-s.c
@@ -1452,6 +1452,7 @@ static struct led_classdev_mc gos_cdev_rgb = {
 
 static void cfg_setup(struct work_struct *work)
 {
+	bool gp_registered, rgb_registered;
 	int ret;
 
 	/* MCU */
@@ -1497,10 +1498,53 @@ static void cfg_setup(struct work_struct *work)
 		return;
 	}
 
+	/* Pairs with smp_store_release from below */
+	gp_registered = smp_load_acquire(&drvdata.gp_registered);
+	if (gp_registered)
+		goto try_rgb;
+
+	ret = sysfs_create_groups(&drvdata.hdev->dev.kobj, top_level_attr_groups);
+	if (ret) {
+		dev_err(&drvdata.hdev->dev,
+			"Failed to create gamepad configuration attributes: %i\n", ret);
+		goto try_rgb;
+	}
+
 	/* Pairs with smp_load_acquire in attribute show/store functions */
 	smp_store_release(&drvdata.gp_registered, true);
+	gp_registered = true;
+
+try_rgb:
+	/* Pairs with smp_store_release from below */
+	rgb_registered = smp_load_acquire(&drvdata.rgb_registered);
+	if (rgb_registered)
+		goto update_kobjects;
+
+	ret = devm_led_classdev_multicolor_register(&drvdata.hdev->dev, &gos_cdev_rgb);
+	if (ret) {
+		dev_err(&drvdata.hdev->dev,
+			"Failed to create RGB device: %i\n", ret);
+		goto update_kobjects;
+	}
+
+	ret = devm_device_add_group(gos_cdev_rgb.led_cdev.dev, &rgb_attr_group);
+	if (ret) {
+		dev_err(&drvdata.hdev->dev,
+			"Failed to create RGB configuration attributes: %i\n", ret);
+		goto update_kobjects;
+	}
+
+	drvdata.led_cdev = &gos_cdev_rgb.led_cdev;
+
 	/* Pairs with smp_load_acquire in attribute show/store functions */
 	smp_store_release(&drvdata.rgb_registered, true);
+	rgb_registered = true;
+
+update_kobjects:
+	if (gp_registered)
+		kobject_uevent(&drvdata.hdev->dev.kobj, KOBJ_CHANGE);
+	if (rgb_registered)
+		kobject_uevent(&drvdata.led_cdev->dev->kobj, KOBJ_CHANGE);
 }
 
 static int hid_gos_cfg_probe(struct hid_device *hdev,
@@ -1510,30 +1554,8 @@ static int hid_gos_cfg_probe(struct hid_device *hdev,
 
 	hid_set_drvdata(hdev, &drvdata);
 	drvdata.hdev = hdev;
+
 	mutex_init(&drvdata.cfg_mutex);
-
-	ret = sysfs_create_groups(&hdev->dev.kobj, top_level_attr_groups);
-	if (ret) {
-		dev_err_probe(&hdev->dev, ret,
-			      "Failed to create gamepad configuration attributes\n");
-		return ret;
-	}
-
-	ret = devm_led_classdev_multicolor_register(&hdev->dev, &gos_cdev_rgb);
-	if (ret) {
-		dev_err_probe(&hdev->dev, ret, "Failed to create RGB device\n");
-		return ret;
-	}
-
-	ret = devm_device_add_group(gos_cdev_rgb.led_cdev.dev, &rgb_attr_group);
-	if (ret) {
-		dev_err_probe(&hdev->dev, ret,
-			      "Failed to create RGB configuration attributes\n");
-		return ret;
-	}
-
-	drvdata.led_cdev = &gos_cdev_rgb.led_cdev;
-
 	init_completion(&drvdata.send_cmd_complete);
 
 	/* Executing calls prior to returning from probe will lock the MCU. Schedule
-- 
2.56.0



