Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 244CC33468F;
	Thu, 27 Nov 2025 14:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255535; cv=none; b=jnCJRimZz/+AhhTSLc85zHC3niAVqeLKr54qz2GSHcNQPm3UHzVmskLFlwTGOMKj6hRJcDtRp8xfwjJ/MlMB1vf6DdffiZTnxmOfRrVs+BmT76tfJze/cZ4BZdEL4+UBJo/oAdjtRcwmrwwuS5xeG8oauw/SBAhEZmuMsuebGVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255535; c=relaxed/simple;
	bh=SwLnWqjnuZfnPlQUicjyBtday1pfhl+DbQMWbpnPEeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Agxfo4qkuCXr4CmqxQaVHFJrYpxrcLcpieKaEVLB3iISz6URe7jC85hmhrsrrSQTNqM0dM6RLLseg0pAlTfhJkDahdIWHDR5XRH1OuDkDWMxbQICWUa9ZPnV6SI+fOUHE3oQYXWfH2OE9IyKpcEDSOzHgSPkoOsK2AW7Xq3y0Nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MSG8k241; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MSG8k241"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6908C4CEF8;
	Thu, 27 Nov 2025 14:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255535;
	bh=SwLnWqjnuZfnPlQUicjyBtday1pfhl+DbQMWbpnPEeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MSG8k241R69tsUNuBe7h7riT0tuUAWZykINfJft+rYNNP0TGxaVuZN6i6fceh7FfP
	 YnesUr/xUmE9j7SJMIBmUEuohaPEwN9xwHiTFqZGy2z2/9NTGmf3tffWBYyIbhgEPo
	 CarLvLBFxa+WJ/TK+bjatX/uw7+h9N0e/dXwf+3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	staffan.melin@oscillator.se,
	Terry Junge <linuxhid@cosmicgizmosystems.com>,
	Zhang Heng <zhangheng@kylinos.cn>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.17 005/175] HID: quirks: work around VID/PID conflict for 0x4c4a/0x4155
Date: Thu, 27 Nov 2025 15:44:18 +0100
Message-ID: <20251127144043.146753134@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Heng <zhangheng@kylinos.cn>

commit beab067dbcff642243291fd528355d64c41dc3b2 upstream.

Based on available evidence, the USB ID 4c4a:4155 used by multiple
devices has been attributed to Jieli. The commit 1a8953f4f774
("HID: Add IGNORE quirk for SMARTLINKTECHNOLOGY") affected touchscreen
functionality. Added checks for manufacturer and serial number to
maintain microphone compatibility, enabling both devices to function
properly.

[jkosina@suse.com: edit shortlog]
Fixes: 1a8953f4f774 ("HID: Add IGNORE quirk for SMARTLINKTECHNOLOGY")
Cc: stable@vger.kernel.org
Tested-by: staffan.melin@oscillator.se
Reviewed-by: Terry Junge <linuxhid@cosmicgizmosystems.com>
Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-ids.h    |    4 ++--
 drivers/hid/hid-quirks.c |   13 ++++++++++++-
 2 files changed, 14 insertions(+), 3 deletions(-)

--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -1543,7 +1543,7 @@
 #define USB_VENDOR_ID_SIGNOTEC			0x2133
 #define USB_DEVICE_ID_SIGNOTEC_VIEWSONIC_PD1011	0x0018
 
-#define USB_VENDOR_ID_SMARTLINKTECHNOLOGY              0x4c4a
-#define USB_DEVICE_ID_SMARTLINKTECHNOLOGY_4155         0x4155
+#define USB_VENDOR_ID_JIELI_SDK_DEFAULT		0x4c4a
+#define USB_DEVICE_ID_JIELI_SDK_4155		0x4155
 
 #endif
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -915,7 +915,6 @@ static const struct hid_device_id hid_ig
 #endif
 	{ HID_USB_DEVICE(USB_VENDOR_ID_YEALINK, USB_DEVICE_ID_YEALINK_P1K_P4K_B2K) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_QUANTA, USB_DEVICE_ID_QUANTA_HP_5MP_CAMERA_5473) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_SMARTLINKTECHNOLOGY, USB_DEVICE_ID_SMARTLINKTECHNOLOGY_4155) },
 	{ }
 };
 
@@ -1064,6 +1063,18 @@ bool hid_ignore(struct hid_device *hdev)
 					     strlen(elan_acpi_id[i].id)))
 					return true;
 		break;
+	case USB_VENDOR_ID_JIELI_SDK_DEFAULT:
+		/*
+		 * Multiple USB devices with identical IDs (mic & touchscreen).
+		 * The touch screen requires hid core processing, but the
+		 * microphone does not. They can be distinguished by manufacturer
+		 * and serial number.
+		 */
+		if (hdev->product == USB_DEVICE_ID_JIELI_SDK_4155 &&
+		    strncmp(hdev->name, "SmartlinkTechnology", 19) == 0 &&
+		    strncmp(hdev->uniq, "20201111000001", 14) == 0)
+			return true;
+		break;
 	}
 
 	if (hdev->type == HID_TYPE_USBMOUSE &&


