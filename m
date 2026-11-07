Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061953;
	b=Y3Dtq3mT1oG0Z+iLcmIdoRuZ5PGg+kMMfDw7zCsx2vjrehvjUSazSwaGzlwQCmqeo6RX
	 XOAaN1xc75YoI4vq0q9w+LgIVI/c2fzNDup+fjGcC4+1EVVSiodmMpfmAJ2BcAHkCUquk
	 WbKwFknB4ikzXO3whAs95XWSQZAuiFvmshKWIZ/dLlR2pbDOZrnI+V/14Y9dKxMCwqnTI
	 NUZEeCcJIsy6bjyETwPMzqa6IipNb0MCndw9wYKKcMnEiHaFfYRsS8nFFOA5HsTa6h+Co
	 YROHR5aw9E691qf6+Sh+1qKtp+kiDFUMdKvNFUNZH2G5mjCKWRk14DO/zm7+6OljDXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061953;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=nWCnd1Rz1dqT7OT1KHTmy/973LT7cwkMNAPcuSYdIDw=;
	b=ukpgqx4o9ktnZ3aHRLjused+9Pi1IZ1OhBXDFdOReptngAmRrxx5aonyR4XWWKtSlBHA
	 5+3pnNF10NXv3ZNwe0VE0axTC32LAEovu/MZHUt9so4DKfvms52lTbpn+YHUwxlSRLDnk
	 PQ84l6mX6GubG/WYARpz2bUuHZAAImlValooKEbWDlO1G7MMKIUInKEJg0x5R89Fsa6rx
	 uAbpFKeIlW3GO3s0N3myc6msjvOAHMbA8ihFWicVLMdywMyQjUGBLHic5aa5DAmUVDbko
	 pcb3H7WwNv6d22L7UtSpwzTcxl3eyQy9CyBr52o1vCuCrhPYU9OnOxViEW3DlclsFqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pjHKNufn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4AC2606A32E;
	Sat,  7 Nov 2026 14:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pjHKNufn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 902991F0089F;
	Sat,  7 Nov 2026 14:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061952;
	bh=nWCnd1Rz1dqT7OT1KHTmy/973LT7cwkMNAPcuSYdIDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pjHKNufn8crogY8/9XJ/Zu1wmD06JcRa3nOZ/4PH2i/gXujOVbLHJDIC1zfpMk8XY
	 oCD/EOz/wJmR/hocJLUXWMekum7nBJc4rMuTVN8gfpcQALNzc62f8SfprGh1JzeRME
	 5jnBBuwSzJgMVVAPgG+NmCVLQUABRt23x7wLlOds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=E3=82=A4=E3=83=A0=E3=83=86=E3=82=A3=E3=83=A4=E3=82=BA?= <reza1234khan1234@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0912/1536] wifi: rtw88: fix out-of-bounds CAM write when key table is full
Date: Sat,  7 Nov 2026 08:48:48 -0500
Message-ID: <20261107135023.251981418@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: イムティヤズ <reza1234khan1234@gmail.com>

[ Upstream commit 10d58823cb44681466c022054030b8e68d94ce2f ]

In rtw_ops_set_key(), when the CAM table is full,
rtw_sec_get_free_cam() returns RTW_MAX_SEC_CAM_NUM (32) because
find_next_zero_bit()/find_first_zero_bit() return the bitmap size
when no free slot exists. The bounds check compares the returned
index with ">" against total_cam_num (32), so the invalid index 32
passes the check.

rtw_sec_write_cam() then indexes cam_table[32], an array declared
with RTW_MAX_SEC_CAM_NUM (32) entries, causing an out-of-bounds
write that corrupts the cam_map allocation bitmap. The write also
sets bit 32 of cam_map, which overruns the bitmap as well.

Fix the off-by-one by rejecting indices >= total_cam_num.

Tested on: RTL8821CE (PCIe) on kernel
7.2.0-rc6-rtw88test-00059-g0d8395707651. The patched module loaded
and associated to a WPA2 network; ping traffic passed with 0% packet
loss. Reassociation and disconnect/reconnect cycles completed
without errors, and the CAM table (debugfs dump_cam) showed valid
key entries. The CAM-full boundary (28+ pairwise keys) requires an
access point with 28+ clients and is not reachable in a
single-client setup, so that path was verified by code inspection.

Fixes: e3037485c68e ("rtw88: new Realtek 802.11ac driver")
Cc: stable@vger.kernel.org
Tested-by: イムティヤズ <reza1234khan1234@gmail.com>
Signed-off-by: イムティヤズ <reza1234khan1234@gmail.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260805210941.75136-1-reza1234khan1234@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/mac80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/mac80211.c b/drivers/net/wireless/realtek/rtw88/mac80211.c
index b39e90fb66b41..910431591420f 100644
--- a/drivers/net/wireless/realtek/rtw88/mac80211.c
+++ b/drivers/net/wireless/realtek/rtw88/mac80211.c
@@ -595,7 +595,7 @@ static int rtw_ops_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		hw_key_idx = key->keyidx;
 	}
 
-	if (hw_key_idx > sec->total_cam_num) {
+	if (hw_key_idx >= sec->total_cam_num) {
 		ret = -ENOSPC;
 		goto out;
 	}
-- 
2.53.0



