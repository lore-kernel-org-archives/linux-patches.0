Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA66F25B0AA;
	Sat, 12 Sep 2026 10:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208049; cv=none; b=Uq2liV4OhIe/9Q8da+j0BTrMyixq1DuAMw4RkQmHMwwIxFIBZPzWfsvmvuZB7cc5X5vX7dyT5J4pcgJkEJYqHgA5Cdw7cVeC879PeeixNDGmyNH3RzfwoDrATj02Eq6SQyzdGRIEt+uLoYVKNNDOcFKeGnL3vqqMM2EnXm/kJdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208049; c=relaxed/simple;
	bh=+Sx7X0IM5Z399r3M4yY3lmrKumF24aSds6/KK45oe98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rBS8BppgRIGQZ2KzHP5OXbXuAp5w6k9y5l6eOPo3HKt47a5OdOxTsSc8uMLBtHZE5fUTSG9dvsi7rSNzWF1c36Fi4JwRNltcpQnTPyhvhg9q7YGdvKt0CLDqEgyjZYx0NZWder9iBZZqxi1vxIPYMLTzyCxDw8DZ02ZED89kftY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V918yjco; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V918yjco"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DA591F000FF;
	Sat, 12 Sep 2026 10:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208048;
	bh=SC3HPYsyhS45sWn0v145LUqDiyPb2wMkMRK/DZDe2BY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V918yjcotDitEuwP37q/gcmOBgAxGGElqD0PK0MOnbpE7duWA3yKjdqNsdkz5JeeJ
	 d3EOCiRQ5UTZJebxIboK6GjXQ06z0BC45s5OM37iyKiW/CThUBqbOQ0GsECTQ6kpJ0
	 3MKVTN0ep6THPZqwQoEliwppdfzxUZrDd62Ev1Kk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0537/1518] wifi: ath11k: Correctly copy the hint BSSID in WMI scan request
Date: Sat, 12 Sep 2026 08:45:06 +0200
Message-ID: <20260912065635.592088597@linuxfoundation.org>
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
index e1b00dc811e7b..fd38069c962a2 100644
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



