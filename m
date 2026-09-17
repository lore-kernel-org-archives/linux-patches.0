Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 273C54B44C4;
	Thu, 17 Sep 2026 18:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671342; cv=none; b=iJUDq5azrD/iVfWsGp2ctftQKTxk24hUTDrosqY0pVTjKjq2UI/U9y+dbAuixLcp8fBSgQqtoMbwYcuZ6pLrpS9iQVqcqOnNI+NVJnXY9KrdCYeKdNQIW/fBN42/ify6gIMweQo1Tu1Bt7exEn29r2ySNam58mw6FktY6hq1TLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671342; c=relaxed/simple;
	bh=harMmec8mPLEtX/79yqR8shETQRGy0hkOAnp+IbDudU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lw2u4SI/JO8pDLWLyMMhJXZ9b39zZhLGcZzSDaCUtvo49yPB7ClHW8PcVRTYG5ij0OgA3taXVgfMqI8chotXOG4CCxCLr+RhrjyXecxTBOFNXpw9avqpTC3TzYDIyyUdsuITCmxn+gEnOd9+4wPJSN2N9mv6nmq4/QoUlpQQELM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LfeGsxUj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LfeGsxUj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DD1C1F000FF;
	Thu, 17 Sep 2026 18:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671340;
	bh=I1VKHGPu5YcMXM0U2gCfYxBAZbgGevk8/lJ+L2lMq4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LfeGsxUjiTmZVEipJos3ao4ZK8/hEnefxDWpeTSp7LeKb0CxTTAV3rDAeQTiCv5aC
	 cxK4M4Sdh/rwcqN2AQUPSsTDnJw+S92W7QbQiv6n/jOLrZCJLN14aC77DknIetYS3J
	 9l4vqmz9uEn6AcJ8HfD8qPH5V1hHCSKBglOCHmBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gary Guo <gary@garyguo.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0944/1102] wifi: ath9k_htc: dont store usb_device_id
Date: Thu, 17 Sep 2026 16:14:47 +0100
Message-ID: <20260917151604.347181491@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gary Guo <gary@garyguo.net>

[ Upstream commit 14d2ac442d660e112efc0ce87ad10085013ed2b1 ]

usb_device_id is not guaranteed to live longer than probe due to presence
of dynamic ID. All information apart from driver_data can be easily
retrieved from usb_device, so just store driver_data.

Signed-off-by: Gary Guo <gary@garyguo.net>
Link: https://patch.msgid.link/20260707-usb_dyn_id_uaf-v2-1-632dcf3adfba@garyguo.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c | 12 ++++++------
 drivers/net/wireless/ath/ath9k/hif_usb.h |  2 +-
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index dbf94333664ec..f9396bf30a617 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -1097,7 +1097,7 @@ static int ath9k_hif_usb_download_fw(struct hif_device_usb *hif_dev)
 	}
 	kfree(buf);
 
-	if (IS_AR7010_DEVICE(hif_dev->usb_device_id->driver_info))
+	if (IS_AR7010_DEVICE(hif_dev->id_info))
 		firm_offset = AR7010_FIRMWARE_TEXT;
 	else
 		firm_offset = AR9271_FIRMWARE_TEXT;
@@ -1192,7 +1192,7 @@ static int ath9k_hif_request_firmware(struct hif_device_usb *hif_dev,
 	if (MAJOR_VERSION_REQ == 1 && hif_dev->fw_minor_index == 3) {
 		const char *filename;
 
-		if (IS_AR7010_DEVICE(hif_dev->usb_device_id->driver_info))
+		if (IS_AR7010_DEVICE(hif_dev->id_info))
 			filename = FIRMWARE_AR7010_1_1;
 		else
 			filename = FIRMWARE_AR9271;
@@ -1208,7 +1208,7 @@ static int ath9k_hif_request_firmware(struct hif_device_usb *hif_dev,
 
 		return -ENOENT;
 	} else {
-		if (IS_AR7010_DEVICE(hif_dev->usb_device_id->driver_info))
+		if (IS_AR7010_DEVICE(hif_dev->id_info))
 			chip = "7010";
 		else
 			chip = "9271";
@@ -1265,9 +1265,9 @@ static void ath9k_hif_usb_firmware_cb(const struct firmware *fw, void *context)
 
 	ret = ath9k_htc_hw_init(hif_dev->htc_handle,
 				&hif_dev->interface->dev,
-				hif_dev->usb_device_id->idProduct,
+				le16_to_cpu(hif_dev->udev->descriptor.idProduct),
 				hif_dev->udev->product,
-				hif_dev->usb_device_id->driver_info);
+				hif_dev->id_info);
 	if (ret) {
 		ret = -EINVAL;
 		goto err_htc_hw_init;
@@ -1381,7 +1381,7 @@ static int ath9k_hif_usb_probe(struct usb_interface *interface,
 
 	hif_dev->udev = udev;
 	hif_dev->interface = interface;
-	hif_dev->usb_device_id = id;
+	hif_dev->id_info = id->driver_info;
 #ifdef CONFIG_PM
 	udev->reset_resume = 1;
 #endif
diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.h b/drivers/net/wireless/ath/ath9k/hif_usb.h
index b3e66b0485a56..02655ed4e66ff 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.h
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.h
@@ -115,7 +115,7 @@ struct cmd_buf {
 struct hif_device_usb {
 	struct usb_device *udev;
 	struct usb_interface *interface;
-	const struct usb_device_id *usb_device_id;
+	int id_info;
 	const void *fw_data;
 	size_t fw_size;
 	struct completion fw_done;
-- 
2.53.0



