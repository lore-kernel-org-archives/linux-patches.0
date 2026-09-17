Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A3AE4E4C32;
	Thu, 17 Sep 2026 15:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660734; cv=none; b=Nv/Cop+wOc/8HVc8Z/jQ8wL8f9X11d8w9YqpIAopHwNIymvrJelKOrfrPh8QXTh4HPolL+llPpfvFBeM7hWWMvoq1q0cxORr/fmpVMRPgkpMuMwxNwIjLfbgFOOpwORf/M+tZrY8SeU50Rj6/5QNIjAh0hef5+9BSdIqBtI11+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660734; c=relaxed/simple;
	bh=5WSXQMuGgdEPMD4/Hqwir3NuqVjPkKfhlJuutXcl/gM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N0mVcG+Y+WS1xykbFu6XKuBQsY8xoxlM2fvvkxRYEr+FoG1Om6P7Vr+RBmQvCJ28xfeZhDIdP2wUz1ndtIUSRCY2Se1wFgIUF+ciUaw1/tlgIsxdXeajuYF1hR5mvDj7BaNxJuecGtayELrOLoXP6hpnYWQ3IJc26BQNJpKnMVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MvgPKEtB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MvgPKEtB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B61321F000FF;
	Thu, 17 Sep 2026 15:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660733;
	bh=BGPH4n+m0u7lnj2zyNQglM57iI1u9tKCjKUvAqS5JaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MvgPKEtBRRg+P09LuqwKLvUCt7w4VGhjtzk6uiy204f5j/5x9KLDM9D/jA+azHzIv
	 Fzl5wgAZnfvnxDypiO3kA8yWwXRQm8VsSCWE9hfjAmQlwy5sSRoG6Pu64FDoymroHp
	 9ycxebeRR3i3MoXSlRvjm+yChHVf9bIuEAyP9pn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gary Guo <gary@garyguo.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 690/733] wifi: ath9k_htc: dont store usb_device_id
Date: Thu, 17 Sep 2026 16:16:38 +0100
Message-ID: <20260917151410.003655880@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 47f904e7e6529..d3491ff08e6ef 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -1087,7 +1087,7 @@ static int ath9k_hif_usb_download_fw(struct hif_device_usb *hif_dev)
 	}
 	kfree(buf);
 
-	if (IS_AR7010_DEVICE(hif_dev->usb_device_id->driver_info))
+	if (IS_AR7010_DEVICE(hif_dev->id_info))
 		firm_offset = AR7010_FIRMWARE_TEXT;
 	else
 		firm_offset = AR9271_FIRMWARE_TEXT;
@@ -1182,7 +1182,7 @@ static int ath9k_hif_request_firmware(struct hif_device_usb *hif_dev,
 	if (MAJOR_VERSION_REQ == 1 && hif_dev->fw_minor_index == 3) {
 		const char *filename;
 
-		if (IS_AR7010_DEVICE(hif_dev->usb_device_id->driver_info))
+		if (IS_AR7010_DEVICE(hif_dev->id_info))
 			filename = FIRMWARE_AR7010_1_1;
 		else
 			filename = FIRMWARE_AR9271;
@@ -1198,7 +1198,7 @@ static int ath9k_hif_request_firmware(struct hif_device_usb *hif_dev,
 
 		return -ENOENT;
 	} else {
-		if (IS_AR7010_DEVICE(hif_dev->usb_device_id->driver_info))
+		if (IS_AR7010_DEVICE(hif_dev->id_info))
 			chip = "7010";
 		else
 			chip = "9271";
@@ -1255,9 +1255,9 @@ static void ath9k_hif_usb_firmware_cb(const struct firmware *fw, void *context)
 
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
@@ -1369,7 +1369,7 @@ static int ath9k_hif_usb_probe(struct usb_interface *interface,
 
 	hif_dev->udev = udev;
 	hif_dev->interface = interface;
-	hif_dev->usb_device_id = id;
+	hif_dev->id_info = id->driver_info;
 #ifdef CONFIG_PM
 	udev->reset_resume = 1;
 #endif
diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.h b/drivers/net/wireless/ath/ath9k/hif_usb.h
index dc0b0fa5c3257..b3e7b0fb54b84 100644
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



