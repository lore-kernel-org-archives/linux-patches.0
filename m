Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212632;
	b=ppnl1zRg/p9jPd1YIT6eK9W1B7TfwJ0zkYkeZH+0FYjeNLiIg9YchnKtfQ8ZwO9G5sNA
	 bzhuacPzB7Y4bZSxHCD/PfSzXdOTP5w+9tpCNE9YCL7CEhN10WCAy0gy/iIn8fQZR2N2+
	 qJZELRcR7pLvuPw1VH67RHPJ/bPERs256J20OqwSawEHSIln+OPbV9nuEhk4V4oKX+v45
	 GLIfzuASO9Dz/peaVCRCS5m7yL/BxVMCYdWgBEYjFcE+0s95+7q7JlEFuVjFBCxK+2/B1
	 7+2Z73GObjbZHKQuzDi/iLrZv7DQhIFUj/b3SaWyRFT1qBDupHkwrO7ZmKHqXiqmPbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212632;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zCJnasV4KCmZewR0luDI3AHhRN9osk3QXWSZlvRAS4M=;
	b=yIZWr258+0e7KldJVtmnKRpVhrGMYcpOOPO8jhaYW9wci/L7ya5SPth/FGCXzWliRcI/
	 zCPgQVsqxBwlYxPwPOcNdUBaPsWEQ42z573ojYf+N7s313dvrZOsQlvU1pIgqD0OR3LCS
	 NUZBs7xLiOc24NiPCSnk0Qt/F9k/S7rdy+C3ltMZvkWOifl2ShLu2m6QPnzGE3/ktvvHS
	 INjBnWW6HtLxgCw7scL3Kzls9ajccL0E8DY9DQb8PYn7n9uOsvISZrKZDdGcaqLDXIBxg
	 fSsDiiHQIVpvEb4sLl13xTYDKdgg2IDqAk3uNbEL+1ecSAIFlUE1bivlMbAsADgFnUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uQsZYOs6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F579606A31A;
	Wed, 28 Oct 2026 18:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uQsZYOs6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 925E51F01825;
	Wed, 28 Oct 2026 18:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212632;
	bh=zCJnasV4KCmZewR0luDI3AHhRN9osk3QXWSZlvRAS4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uQsZYOs61bmv0m7tdXMfS4Fbqq5YFMlAn4vVwotvQGqSDr4evmtOxeALC55SB+UDr
	 Hsvr02fkWljetX98xYJvNoHzUyyqRDmqnfWXzbRwamL9DWmGNbkU+NTnR/J+VfNXdf
	 SafPOBM7OyE4ATjxIix9MKnlSdSqQMZZdMRvFnYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Escande <nico.escande@gmail.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0222/1887] wifi: ath11k: reset ar->num_stations on hardware start
Date: Wed, 28 Oct 2026 17:38:38 +0100
Message-ID: <20261028170504.284954246@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2ef03ad1c9051..8565a7031fae4 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -5879,6 +5879,7 @@ static int ath11k_mac_op_start(struct ieee80211_hw *hw)
 	ar->num_started_vdevs = 0;
 	ar->num_created_vdevs = 0;
 	ar->num_peers = 0;
+	ar->num_stations = 0;
 	ar->allocated_vdev_map = 0;
 
 	/* Configure monitor status ring with default rx_filter to get rx status
-- 
2.53.0



