Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 161DE345EB5;
	Sat, 12 Sep 2026 19:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242721; cv=none; b=MS7fXZU3kkzl419JMFCfe9FJJrILlhkBWPXN1+P/R4CieX5BVqxmjnopRDRtPtBVhuKCV0KOHs0YjGNChJ617A62csFq/EPdECOkbWQx2PneK51bY2irXZARL+R3eMV5+b9GzkNSgy+fLn5lCCPxvqmVgn3TeDmeQhe0o0BtlcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242721; c=relaxed/simple;
	bh=1ll7aovH0Rs9vQPuXiKRycjTuCzlw1RF/K6rfr7I+so=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MiC0GO+6/ZBd+za32+yRctzNAxXjRgqtvWIZcjvXA3uNoy9S24sTQncnZPHeZYjmJC3zaH/rpZsaO8FC1MxlJyWV2GNor3iJf0zsJ76TGzZKVRqm4J47bkBhRGB0xs2pd9UqgdKkGMDwsiGBGdID49+CbFlYyE/A2CRYH4BHm28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H/qEwdVK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H/qEwdVK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FA851F000FF;
	Sat, 12 Sep 2026 19:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242720;
	bh=/Biz+21jgsE/cc0E04MJ7uZX5GxHup/11zaxnspSseg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H/qEwdVK7R/oIlRfn9y2Dt54xDOwgASnN+VwugDUdp0nQr42OD9zx1/87oj+he9Yd
	 +OF4aDp81By1XS8avcc3s2gwcDVSZG9CtNocz6VYr635zgQhJ3aR0k3DOgAgvow3wX
	 M0F/AAN9v20jmCInMMuZsVuEb5ivxaLjRZylHW/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 502/798] wifi: ath11k: Correctly copy the hint BSSID in WMI scan request
Date: Sat, 12 Sep 2026 09:02:10 +0200
Message-ID: <20260912065528.641685817@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 7c2d74533521f..e4d3a76c610f7 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -2194,8 +2194,8 @@ int ath11k_wmi_send_scan_start_cmd(struct ath11k *ar,
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



