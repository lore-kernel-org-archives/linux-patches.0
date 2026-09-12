Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F3EF28B4FA;
	Sat, 12 Sep 2026 07:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199543; cv=none; b=Ej5HU8bvH0uuxPVRbqUesAz7ANt0iCctH6rinbrHf8DX0qYySYgR+JSf4tr1KR3TK+igSa/5G6GlxsrZ5wfUu7BUFMtBB/dwHz951F4t7/ICNBu3RaRDwQ2tAGwtUfz7Mk4IKRQUPex2hD/ddVBi8SI2GrCZe1iH4ML5V9E2cHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199543; c=relaxed/simple;
	bh=aW3PjrbfOfxmM5mZNbavl9hfwS9jCN59x7nVnSrfUZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kPVNWdjyoYzlur3eyDWFJB1TM3WOrZAGzublCYWkd9tXcM/xAzfwxoXfxOYe5Mj3J5cdqScehDHSIxVXeYRuN3Q4xC6h1wx7m/NJdN/A33uzettdyAuo/imKwQVrcvYLrwHgLUqpkYfrz0/H/QzUDq+kPL6jjpHVClx9544jR7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sQOyliwL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sQOyliwL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3D4E1F000FF;
	Sat, 12 Sep 2026 07:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199542;
	bh=Q0rcSlOWU6rnF+QF7mIydeKWCiMYhqorxLzpEMa5iAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sQOyliwLNiiddL98MMcMHe2bto+BVdcY1zQiJTT99//S6HcpTz3wxluBlpVL++h0Q
	 iUhNpRqPp6sigt77JAP4VJjlKKKpfKa/uscjKxL+e64JVM4eTWeHxDDRY5iHvrKT5X
	 AFKtU0j76qOD4Qh1Ny5OAKjsnqSrWJyTrVNWSpfE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0607/1815] wifi: ath11k: Correctly copy the hint BSSID in WMI scan request
Date: Sat, 12 Sep 2026 08:39:17 +0200
Message-ID: <20260912065703.129585550@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>

[ Upstream commit 6fe2dddf59bbb2a96be0fcf23a205807b25ac173 ]

Currently, in ath11k_wmi_send_scan_start_cmd(), the logic to populate
the hint_bssid copies the BSSID in the wrong direction, from the
firmware message to the argument buffer. Swap the parameters so that
the BSSID is correctly populated in the firmware message from the
argument buffer.

This issue was reported on ath12k, but exists in ath11k as well.

Compile tested only.

Reported-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Closes: https://lore.kernel.org/linux-wireless/afbff608-a005-43c4-af76-968a58bf0cc3@oss.qualcomm.com/
Fixes: 74601ecfef6e ("ath11k: Add support for 6g scan hint")
Assisted-by: Claude:claude-sonnet-4-6
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Link: https://patch.msgid.link/20260713-ath12k_wmi_send_scan_start_cmd-bad-hint_bssid-v1-2-4ffc4a472992@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/wmi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/wmi.c b/drivers/net/wireless/ath/ath11k/wmi.c
index dca6e011cc40e..c54f50b98a133 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -2423,8 +2423,8 @@ int ath11k_wmi_send_scan_start_cmd(struct ath11k *ar,
 		for (i = 0; i < params->num_hint_bssid; ++i) {
 			hint_bssid->freq_flags =
 				params->hint_bssid[i].freq_flags;
-			ether_addr_copy(&params->hint_bssid[i].bssid.addr[0],
-					&hint_bssid->bssid.addr[0]);
+			ether_addr_copy(&hint_bssid->bssid.addr[0],
+					&params->hint_bssid[i].bssid.addr[0]);
 			hint_bssid++;
 		}
 	}
-- 
2.53.0



