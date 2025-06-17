Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2E1620F090;
	Tue, 17 Jun 2025 15:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174734; cv=none; b=oEMNEtnjxixtFqD1aDrUV76Tf77o5aABk1h8yyo1hoS+r7jEHKlN/AXWa+FbhfTdX0Yf6ucfPKgJQNBGF0TQWRSGkRyVq7LNXh5VlXjWJFWlWB+ymbFzKSpHYomCOHxwLqGaE6N8QGoU8CKFlz911jinPapvAdRqFlAzrSGsAtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174734; c=relaxed/simple;
	bh=Giwj7tgBNfpVgg63r6gX4J+3Tk2BW1We9mrLyPPA0ak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bGnR8FZSRyuPvYwvslyBbjh3rkJZcWAXFijOQM/kgeAKzyROZ4JdZFxNx+Zri3F524Ay8EjRiZwh+JpjZn51Q94Lp+JGtNya6aERRORPJjI94qNxR+soZmRG9hsR01ntjuGX1bWDYd7LEcfL9RWG4ydDfGlbQkkLMX4qBFkymJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lijAD1fG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lijAD1fG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5430EC4CEE3;
	Tue, 17 Jun 2025 15:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174733;
	bh=Giwj7tgBNfpVgg63r6gX4J+3Tk2BW1We9mrLyPPA0ak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lijAD1fGXGZZ7AqSrN9nJJn/nRuqu5OIGz++bDwYqV++Ayt9wHOeI/RBU/OWR4AWa
	 4sb29NRzAHI5p9e3YELLKlMEotTFscK0SCqpapdv7t0nMaXvnCkRKjex9RaI5vAtVf
	 RIwE0vwwQlruS/SCZ5XS1FSdQLstu7i9x4evWjDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ramya Gnanasekar <ramya.gnanasekar@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 086/356] wifi: ath12k: Fix WMI tag for EHT rate in peer assoc
Date: Tue, 17 Jun 2025 17:23:21 +0200
Message-ID: <20250617152341.681652977@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d87d5980325e8..a96bf261a3f75 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.c
+++ b/drivers/net/wireless/ath/ath12k/wmi.c
@@ -2066,7 +2066,7 @@ int ath12k_wmi_send_peer_assoc_cmd(struct ath12k *ar,
 
 	for (i = 0; i < arg->peer_eht_mcs_count; i++) {
 		eht_mcs = ptr;
-		eht_mcs->tlv_header = ath12k_wmi_tlv_cmd_hdr(WMI_TAG_HE_RATE_SET,
+		eht_mcs->tlv_header = ath12k_wmi_tlv_cmd_hdr(WMI_TAG_EHT_RATE_SET,
 							     sizeof(*eht_mcs));
 
 		eht_mcs->rx_mcs_set = cpu_to_le32(arg->peer_eht_rx_mcs_set[i]);
-- 
2.39.5



