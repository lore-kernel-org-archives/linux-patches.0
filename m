Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 830803BE643;
	Sat, 12 Sep 2026 12:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216005; cv=none; b=BQ+ChdLCxEZ1cu+KpTkyXlwPiUJ2CKmNF5//4Xv0WhPknOq1c+EuOaZc6kQvwOBsx/CCQlfH4Puf7QUGKpT29qu3+A9deuywvFofrdoRLRVhU3exMfUWk2ABuJvGBTAMaeeWQy/9A3kJfood3CYXb4rqrbmxdmBKi51sRXJtkhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216005; c=relaxed/simple;
	bh=1jSrmNVWXTI9kMa7S2zXCBjtoo/wEkIk1zg388cYofo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bwCq8153r4Y+iduxPHSiqwIdvzA2r3J5Q2cJWpbmJn7dwJ5p8at2UJDhFVth+uc1Gjww3pPWPA/hMTr6ko91Qm3PiGf6xfOhzS7IZcSInB0drmDhXGWStRVnmKgGm3my+dkIPc2FCXPzFq5cRqK4+UGoHdcpqod5Xhf343mo1lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RQocJMoQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RQocJMoQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E7891F000FF;
	Sat, 12 Sep 2026 12:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216004;
	bh=oZV+4M2OpyeYI9dg8kB0p1kYYr4Bpo/TwKnqihYbWqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RQocJMoQB+NYehPbKr0kWDkBiID9a0olB+u3V79d7DCrXlPJ/7Dtg+e1S1vddVHiE
	 tU6fUvx/PBjgsohRdObXVgHWSEDYdH18XFjekFK9PBiaWNe+5+byv+7ZIlXgbs07zD
	 P1bl2qDj9KUk+qyMs2Z19WilRQ53NJ4V4IbVK2Io=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0646/1376] wifi: ath11k: Correctly copy the hint BSSID in WMI scan request
Date: Sat, 12 Sep 2026 08:51:12 +0200
Message-ID: <20260912065621.940515298@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
index 5f15f7acd5132..2f70541461d8e 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -2411,8 +2411,8 @@ int ath11k_wmi_send_scan_start_cmd(struct ath11k *ar,
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



