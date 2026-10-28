Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208557;
	b=mjsILOIVYTEW45dE1kFlcv9If++5Tp8o9/lVLSsKTM+nHLfoxc1n0Wn3oUlRHkIbo1Tz
	 ejoFYduQR9uE+mQAlkHHq/5aLH4OqA294WUK+iThjTjlclmA9pWz4o5dPcgTYd3FZqib0
	 yJAuar842ZpubaE9bhkwQ4SzLcXK27q+fG+Bns5nJD5neqKPgNiO7EEvCxfqbAyk2VedL
	 +hSVSEmJQr7UQ/C6JO6wVpoPK5pgvYe99qTuiuSjBVXQIC74I91m4sa/6J6ukweCs4/2h
	 JQ35sP9UfZ4S7BQYBtM0A7ZAQuWdnAsQ7cxl+N28hHb/II/sn4mbYrxHA/wnYuVlP1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208557;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ruDnsJDz8Rv6kkDcP4ynYHRxnOlvqCDzVNjsuxokZUg=;
	b=RWahOGedUkofnSScofQoARU7O8M+3WavrN1BHbCvWxpMvUXgeoDxCEC5ILjTv/8uLHIl
	 xI9XTZveqs9LRVBqjggj7i5qvbY8fGEXt7jn8MgnQi8VVSBGanshkgdwBbVsi7nJ+lkBN
	 lfYFAnwO241LAugEzWAn6IOq0CalGU7BbXvjLkx5UkEc40bNU3eFdQop7atJ0ZLjSk3re
	 QYRFIKRG5Lc2WOExSBiLYGXyVZuHvTjXsfZr5Gm8qe1Rvq9D9mhKRA8dWkHKX+ALeuSeh
	 B+opvEL7VG15bWkmwkG4q/wIt1ea5rYonVszFssrOKPdZ8qEu0NMHifPZsx87p11BBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="C/xCHm+n";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9AD7606A31C;
	Wed, 28 Oct 2026 17:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C/xCHm+n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2C021F01825;
	Wed, 28 Oct 2026 17:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208556;
	bh=ruDnsJDz8Rv6kkDcP4ynYHRxnOlvqCDzVNjsuxokZUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C/xCHm+nguPL7JWvh4j7Hf+YsUdUN45+rzYvGRQj5sUZLlmgU4HNw+iwb8WSQyvcn
	 rZceXHpqe3aju++P8+sKmr7Clou+yQsPY7zlmTBmUFgJiTSUHmO8BucmQH/Q3Dafd1
	 4BvovXEQNrIRZHV0IBBJUWGsAJ70G+5QgiRLVjOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Escande <nico.escande@gmail.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 161/516] wifi: ath11k: reset ar->num_stations on hardware start
Date: Wed, 28 Oct 2026 17:55:13 +0100
Message-ID: <20261028170007.319825825@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Escande <nico.escande@gmail.com>

[ Upstream commit 7e0ad05ebc72fffba2bdf2400400902d94ed7272 ]

When (multiple) hw restart occurs, we end up in a situation where we
cannot accept new stations / mesh peers. This seems to be the
'num_stations' in 'struct ath11k' that did not get reset properly in
this case. In ath11k_mac_op_start(), it was indeed the only accounting var
that did not get reset so let's clear it too.

This avoids problems like those:

	[1248828.088023] WARNING: CPU: 0 PID: 12281 at net/mac80211/util.c:1682 ieee80211_reconfig_stations+0x98/0xc0
	[1248828.088115] Call trace:
	[1248828.088116]  ieee80211_reconfig_stations+0x98/0xc0 (P)
	[1248828.088119]  ieee80211_reconfig+0x774/0x1438
	[1248828.088123]  ieee80211_restart_work+0x10c/0x178
	[1248828.088127]  process_one_work+0x178/0x3c0
	[1248828.088130]  worker_thread+0x280/0x440
	[1248828.088133]  kthread+0xe0/0xf8
	[1248828.088137]  ret_from_fork+0x10/0x20
	[1248828.088141] ---[ end trace 0000000000000000 ]---
	[1248836.686604] ath11k_pci 0000:04:00.0: refusing to associate station: too many connected already (128)
	[1248836.686609] ath11k_pci 0000:04:00.0: Failed to add station: xx:xx:xx:xx:xx:xx for VDEV: 1

Tested-on: QCN9074 hw1.0 PCI WLAN.HK.2.9.0.1-01977-QCAHKSWPL_SILICONZ-1

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Signed-off-by: Nicolas Escande <nico.escande@gmail.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Link: https://patch.msgid.link/20260812-num-station-v3-1-871d20e043f6@gmail.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/mac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index b66b6a7072d82..f09b926df9033 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -4242,6 +4242,7 @@ static int ath11k_mac_op_start(struct ieee80211_hw *hw)
 	ar->num_started_vdevs = 0;
 	ar->num_created_vdevs = 0;
 	ar->num_peers = 0;
+	ar->num_stations = 0;
 	ar->allocated_vdev_map = 0;
 
 	/* Configure monitor status ring with default rx_filter to get rx status
-- 
2.53.0



