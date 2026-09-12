Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF7E3E5A14;
	Sat, 12 Sep 2026 10:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208044; cv=none; b=Vh8oY9V6bROCL+QO9F4EepztdAaRUEUbtaum8iKYGtW4zvny1SMHBaQTRzSI8+/iIdPAg5cRUT3yMYa9YM25pmHd/PuJk2oTRLRXhOVStQEMbvIo8I4TMwuXvdKtKR0ZrupneBuTUyzyR3mnCIPnRXUW3KBgvxbHwLN7yDiEf1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208044; c=relaxed/simple;
	bh=j+qfrXm88/EaU6aCXHaFmekeLdCgumEKQtH9E9jsXvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nej5x4vjAn4O1XeUmhqVb0q9Z6vYToVKDRCp/e3Fg7vGogFPv+iqtkhTRWM84Ze/8M5KkCgnJdE6PRrh7CCl4ADX22rCVdtl26AcDgA8ZnOvbi/vOKm5Cex7TsaxEyNLc8Jhxk2e9eQR3ya3UDV0Wfj/CejIY7+iDXcnag++F3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YF6wzsOd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YF6wzsOd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CA691F000FF;
	Sat, 12 Sep 2026 10:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208043;
	bh=5zzWoF/9bwn0QfBMDhJ3tJDAASjPcHKlo0XAAYQRwIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YF6wzsOd/Fv3cO9gGP7LWJHkyl66DHXtymKoU2R/mUJa8GmyvnVwBhArSF7F3tQrS
	 F7I8dDSF3Kt+k5pRIvYq112kTc/SJE5CliNu5izoACMzw/DHNsmlbxStQWSwjrQvk6
	 f5jGihLkRLbNt2vQ0ZAo3DG+WEbq0LN3b978kFew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0536/1518] wifi: ath12k: Correctly copy the hint BSSID in WMI scan request
Date: Sat, 12 Sep 2026 08:45:05 +0200
Message-ID: <20260912065635.569299131@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index f3474a13e32aa..aa99e07226103 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.c
+++ b/drivers/net/wireless/ath/ath12k/wmi.c
@@ -2816,8 +2816,8 @@ int ath12k_wmi_send_scan_start_cmd(struct ath12k *ar,
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



