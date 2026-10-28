Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210848;
	b=XXr1u0DYyMj8W4GcuWmQmUWhy+h/Zzj1uHQFw8Ph/G5e8xoNw4opifwiglG4QQOuV4M0
	 S+6UVKRrBlrfwo+t+drF5eX3mtUtoj0Ca/DFTR6nZ9y6UqxgjFcUc/J8wrjnVL0xwEJaS
	 XpCqOD5tvtbpplyBnAc+HIx3jUHSG++mtILB3Okssz31/Hd4FYRV7gnCYXRVeLSJi+mDW
	 zc10mVq3hrR2ku4ZkD2ywZzgIcy13Z/K1YHrx7Nexa/XcQX3wm4yUdmEXncNVsDTw4798
	 ooqvBhgCGASimhmJh2O5DYrnw9zFPWwXC9KDlWTuJxcturYUrxujUeJ2gS0V+BtKs2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210848;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ezbr2I8ee8663XIS1SUEk1O+46m0w6mCYZDn12J4Gnc=;
	b=QbcAEPN/f3c50Ye1TyyWX2hNw8XgtqTbfw980pIPOQNRLsZTEzoFcHX/B0ybQ+S6thE0
	 upFF0S3VTKoYLYM9Dv/MINxDBjZ2IRl/vE0y3VUH0nzy/A31aMAWWX0Fq7zh+4bIeYQvI
	 FR4P6kRQYVfY0aHKhTbnDUqZ1BHDIz4Av3rPHcQCSCZKXllAbiVuGCwmN3iMmL1hOyd5/
	 EzIxkUh85LUGCkDdfHzbYfAnQY2MBk0h+y6maJCYGNa0W69d3Q2Crwezsy+mLdbxXgqHp
	 Hdak4hUNC8GByibk0iOZsZuY3sAQbk6w3ttDNRSmnQcR86el8UKGZxobKisdjPoL38Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ma7oMG9d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AB0C606A324;
	Wed, 28 Oct 2026 18:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ma7oMG9d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC51F1F01829;
	Wed, 28 Oct 2026 18:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210848;
	bh=Ezbr2I8ee8663XIS1SUEk1O+46m0w6mCYZDn12J4Gnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ma7oMG9dqhnTy2rV0R7UhHjVf9Mbpl18ZuzvffAOmCNmchyDvkSQg/z4DGzi2qGWZ
	 nmL090abIWqDLWqypylyNJlY32S3DWWB4JIWu/txRIT19quHGRYYdkfuU2Cca49Wge
	 CtUk6EAJ10601zTP6UDoAjPArmbnYJktnrsci7OY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Escande <nico.escande@gmail.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 168/571] wifi: ath11k: reset ar->num_stations on hardware start
Date: Wed, 28 Oct 2026 17:55:15 +0100
Message-ID: <20261028170012.001256211@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 81a8e1102d72b..a13252fd16b86 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -4500,6 +4500,7 @@ static int ath11k_mac_op_start(struct ieee80211_hw *hw)
 	ar->num_started_vdevs = 0;
 	ar->num_created_vdevs = 0;
 	ar->num_peers = 0;
+	ar->num_stations = 0;
 	ar->allocated_vdev_map = 0;
 
 	/* Configure monitor status ring with default rx_filter to get rx status
-- 
2.53.0



