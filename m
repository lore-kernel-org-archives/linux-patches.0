Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FC9C9463;
	Sat, 12 Sep 2026 14:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223772; cv=none; b=hzVlOet7dBf7H5A5BwdZp2Pmsx8E9o80+ttevJr//SaGXzh2bl0fiXLFBNsm0OcUQdymgLiJEmG5rZJhRGtwQnMJV8tWYVpfpb2VfmHO9e1+jx2cbvdC4ByLsPH1SJs29XrVDY2pFm7fYE0dFB3GO8hd0lDjZiBZSPrbl5lWYJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223772; c=relaxed/simple;
	bh=bwHbDolwTKyHy3gtUv3Q5KZvaJkEDHf9tVZjZlGcIsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=otM4oNRJn4UmD99iEn/YQ7/KfCM47FNDFtxBLy+jaUusoImu9I5rW8xotw7GaftOedWqCn6L2szgFtcctYxR+uzk12pudqyDVuzfHMfVzI5/es1oLNEwkbIOt3qtDjf8I5YTG8fuJi4qQLKci3M1rnEq+SaJs0l3mPImq890KmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lIa4QIa2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lIa4QIa2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 538F91F000FF;
	Sat, 12 Sep 2026 14:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223771;
	bh=pZLZiPDtRG0cXv12T4aV4UKTJN8kzNcNUsmp816anug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lIa4QIa2y4V4vC53yOMxTVGaAcRcsgMqwrEyXYtZsZpe2xscIfLND58W73gGP/kea
	 AVaP0BXM2o530iOxGcJRY4b+h0PBNtSVgC8eyOC586Td5AQVsVHbWQ8ogr8xIC5f8t
	 8n9FEiQnzbhsCKW35to8nt8DvkxFD4Qjp2x/qxBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0855/1424] wifi: ath12k: Correctly copy the hint BSSID in WMI scan request
Date: Sat, 12 Sep 2026 08:54:47 +0200
Message-ID: <20260912065626.457273446@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>

[ Upstream commit 7b0bd40e97a00991122122d5888ae455fb2bfc7a ]

Currently, in ath12k_wmi_send_scan_start_cmd(), the logic to populate
the hint_bssid copies the BSSID in the wrong direction, from the
firmware message to the argument buffer. Swap the parameters so that
the BSSID is correctly populated in the firmware message from the
argument buffer.

Compile tested only.

Reported-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Closes: https://lore.kernel.org/linux-wireless/afbff608-a005-43c4-af76-968a58bf0cc3@oss.qualcomm.com/
Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Assisted-by: Claude:claude-sonnet-4-6
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Link: https://patch.msgid.link/20260713-ath12k_wmi_send_scan_start_cmd-bad-hint_bssid-v1-1-4ffc4a472992@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/wmi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/wmi.c b/drivers/net/wireless/ath/ath12k/wmi.c
index fe920ecd25baf..6b82e1a7f2881 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.c
+++ b/drivers/net/wireless/ath/ath12k/wmi.c
@@ -2388,8 +2388,8 @@ int ath12k_wmi_send_scan_start_cmd(struct ath12k *ar,
 		for (i = 0; i < arg->num_hint_bssid; ++i) {
 			hint_bssid->freq_flags =
 				arg->hint_bssid[i].freq_flags;
-			ether_addr_copy(&arg->hint_bssid[i].bssid.addr[0],
-					&hint_bssid->bssid.addr[0]);
+			ether_addr_copy(&hint_bssid->bssid.addr[0],
+					&arg->hint_bssid[i].bssid.addr[0]);
 			hint_bssid++;
 		}
 	}
-- 
2.53.0



