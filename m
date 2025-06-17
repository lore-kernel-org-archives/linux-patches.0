Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F41B92F234D;
	Tue, 17 Jun 2025 15:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175521; cv=none; b=NK9B06rtcf1s5tIs1mzbos0CVtJ5KwKzMX+xV+bKtRzEm6WK4SYxS9bENidx11e20MVvWdxEUL4ZVjlVZmZdxTNj85x40Rxy1+xlbGwlsalWg7zV4DPZq0SxOGPdatkYvBPsnzazP7M/emnqnxn5vqXeLotm1ecph+LsVbNikps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175521; c=relaxed/simple;
	bh=dxD78C73D95QvKOH/VCOMq23gzw4YGUSGE0v/AB7nQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VwATPz27re9sTuoD2Ktp2vQFNxiwryDRmWPDVm55lj4OYRCAAy4S5INKjUI4t9w51XnYkuV/A8x7LV9k61gvqgdg0G5UsTo/R8UmWLo1/JBk/ui2D3MOHdt25GbQ9zRLMoxxoec5NXy3+O0/cIPoJZI9SQ4SrZJncljpYIuSZs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H3Jj3Rwv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H3Jj3Rwv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C112C4CEE3;
	Tue, 17 Jun 2025 15:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175520;
	bh=dxD78C73D95QvKOH/VCOMq23gzw4YGUSGE0v/AB7nQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H3Jj3RwvQNREnHikSY5jqfp+2BiPKlC3byk0D1pKX1qqWrrWDlZyX8HJo6sCQ+mtk
	 2wGSaGyhnH2Q2WR56lKjDKgXDnmKrdZ9K7HaASY3rXoP41iw9+bbTi3y2NTo4tjXbU
	 Fl5yXR/744Nbn3J9+eFomZc0Y+nYE+ZOI+B/HwsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ramya Gnanasekar <ramya.gnanasekar@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 116/512] wifi: ath12k: Fix WMI tag for EHT rate in peer assoc
Date: Tue, 17 Jun 2025 17:21:22 +0200
Message-ID: <20250617152424.287413861@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ramya Gnanasekar <ramya.gnanasekar@oss.qualcomm.com>

[ Upstream commit 1a0e65750b55d2cf5de4a9bf7d6d55718784bdb7 ]

Incorrect WMI tag is used for EHT rate update from host to firmware
while encoding peer assoc WMI.

Correct the WMI tag used for EHT rate update from WMI_TAG_HE_RATE_SET
to the proper tag. This ensures firmware does not mistakenly update HE rate during parsing.

Found during code review. Compile tested only.

Fixes: 5b70ec6036c1 ("wifi: ath12k: add WMI support for EHT peer")
Signed-off-by: Ramya Gnanasekar <ramya.gnanasekar@oss.qualcomm.com>
Link: https://patch.msgid.link/20250409152341.944628-1-ramya.gnanasekar@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/wmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/wmi.c b/drivers/net/wireless/ath/ath12k/wmi.c
index 30836a09d5506..b2e586811858e 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.c
+++ b/drivers/net/wireless/ath/ath12k/wmi.c
@@ -2157,7 +2157,7 @@ int ath12k_wmi_send_peer_assoc_cmd(struct ath12k *ar,
 
 	for (i = 0; i < arg->peer_eht_mcs_count; i++) {
 		eht_mcs = ptr;
-		eht_mcs->tlv_header = ath12k_wmi_tlv_cmd_hdr(WMI_TAG_HE_RATE_SET,
+		eht_mcs->tlv_header = ath12k_wmi_tlv_cmd_hdr(WMI_TAG_EHT_RATE_SET,
 							     sizeof(*eht_mcs));
 
 		eht_mcs->rx_mcs_set = cpu_to_le32(arg->peer_eht_rx_mcs_set[i]);
-- 
2.39.5



