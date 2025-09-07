Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24F6F4315A;
	Sun,  7 Sep 2025 20:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277707; cv=none; b=GuXkZHrlTfoQZof0tA08ZoZolBmEFII/EUpLp5Jnb2H46DEQttzEBG/wOUw4E7UQalv7N9KTEBrYJ9gVkJO6X0itaiXFlwlqVFW1LVRRBbdKikWQV6EhiVNAfySyG+tZ0JLMyYfMNYuNL1c4DyQJ1g5CTgT7bLNpshuTJxWYISU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277707; c=relaxed/simple;
	bh=oyisxrotvDbvtPWvpmRoiqAt6q7w4rhpeoQLT++dUmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CnGHQUZDC+6wHAfxzJ2saeP2tNxh/NMZ3m79KY5aitC7mu3ZJyQUgGlONZxut5Z8En7qYhPaOtKc9L8iGlxwaCT0am1Akc/cFr27jD+O0rG42RDQSRkr+ZgRcsBvEBPkkhcBDiB85sJ+Osa64BTzRFsF2i1gxZTheXy8HfLylEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZaV8mMOS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZaV8mMOS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C051C4CEF0;
	Sun,  7 Sep 2025 20:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277707;
	bh=oyisxrotvDbvtPWvpmRoiqAt6q7w4rhpeoQLT++dUmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZaV8mMOSZj9fi7c1OEhmJvcJDWJZ45vGAT5IOgBi9bS8iAWHpZTQ1xqsEX1YsbS89
	 WOhhsQViutJhf1ckG7hyrwuvCDIQCIFzKLx7Yx2wQk2Fnb/A3vmWYRYktuVI5hF5U4
	 FSvPnjFOCcC+D4ZmPwJmwDLesfd3fKCGhS/yOBw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ramya Gnanasekar <ramya.gnanasekar@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 071/183] wifi: ath12k: Set EMLSR support flag in MLO flags for EML-capable stations
Date: Sun,  7 Sep 2025 21:58:18 +0200
Message-ID: <20250907195617.484688191@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ramya Gnanasekar <ramya.gnanasekar@oss.qualcomm.com>

[ Upstream commit 22c55fb9eb92395d999b8404d73e58540d11bdd8 ]

Currently, when updating EMLSR capabilities of a multi-link (ML) station,
only the EMLSR parameters (e.g., padding delay, transition delay, and
timeout) are sent to firmware. However, firmware also requires the
EMLSR support flag to be set in the MLO flags of the peer assoc WMI
command to properly handle EML operating mode notification frames.

Set the ATH12K_WMI_FLAG_MLO_EMLSR_SUPPORT flag in the peer assoc WMI
command when the ML station is EMLSR-capable, so that the firmware can
respond to EHT EML action frames from associated stations.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.4.1-00199-QCAHKSWPL_SILICONZ-1

Fixes: 4bcf9525bc49 ("wifi: ath12k: update EMLSR capabilities of ML Station")
Signed-off-by: Ramya Gnanasekar <ramya.gnanasekar@oss.qualcomm.com>
Signed-off-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20250801104920.3326352-1-rameshkumar.sundaram@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/wmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath12k/wmi.c b/drivers/net/wireless/ath/ath12k/wmi.c
index 1d0d4a6689464..eac5d48cade66 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.c
+++ b/drivers/net/wireless/ath/ath12k/wmi.c
@@ -2370,6 +2370,7 @@ int ath12k_wmi_send_peer_assoc_cmd(struct ath12k *ar,
 
 	eml_cap = arg->ml.eml_cap;
 	if (u16_get_bits(eml_cap, IEEE80211_EML_CAP_EMLSR_SUPP)) {
+		ml_params->flags |= cpu_to_le32(ATH12K_WMI_FLAG_MLO_EMLSR_SUPPORT);
 		/* Padding delay */
 		eml_pad_delay = ieee80211_emlsr_pad_delay_in_us(eml_cap);
 		ml_params->emlsr_padding_delay_us = cpu_to_le32(eml_pad_delay);
-- 
2.50.1



