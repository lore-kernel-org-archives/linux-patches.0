Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062739;
	b=bPvffsLCU9B7SYJdTezt7TgPdVml7PRcnCkiO9RxVHJBz4p7j6whoWuKz9vsby4xoqrq
	 SXVu2VTrkJp3OAQDVTwO2Rj8klU+z+c2zaL+grgHOcG885krnL2wHZv3I8/Hw3kfvkaSp
	 JE64jO9Rf6zuxRbTYYpxqbYsUULRMfvmXC16x6r4uAnjI6JXJhe5zt7idN7Etttez6mEg
	 pSc8mAEdAuULG0G0oAWA3fBlIqojUjmNtuJXrDhBBS4wdfcHqnnk5hOEPEmKTu7h0N9CV
	 7UVINvlCufNKaVUUsTFr+T/ycaIFH7CH2GGv4311TZKCszJtHKFfEIWWD8KV3kRPESw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062739;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Eg6aTEwIuk+DY4o7RGW3aZojaxty5HD5JUeY5d3K5dU=;
	b=l4I7dlg816fdhMJQDdTOwZVN610O3KCGdVOr+7J6baN96a9a1LgmljK5zthXIvhvkbIr
	 2AeDc00ClgA7Oh5dg/gV14AHokLDQLk/zhMjouNhn+/CKOFVuH5tsq0uMp6rItKCCInbd
	 e2P1uZM00qn1Rsi8tn5151KOdDeAkFVzmsGCbHu1geeWzdM7XEtoMUHUsvxMu92Y2rPDM
	 Ypli4hxjOI9UhlAYTSigGwGy+hRC+1r/tUqjkDGPSWq97hkDP9YIfCBt5y4PKZO4UlI4X
	 ROSjLUJ+q+5WLj3e+l4x5RVa8t3Cs097YH51TBb1DIDH4TtUI7FAf1z1Fuu5skLPxbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e+MPKEz1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42EC1606A32E;
	Sat,  7 Nov 2026 14:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e+MPKEz1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E58D31F0089F;
	Sat,  7 Nov 2026 14:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062739;
	bh=Eg6aTEwIuk+DY4o7RGW3aZojaxty5HD5JUeY5d3K5dU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e+MPKEz1ztC0J8D+g+PnKYNuAiYcTg9o0SEZAgowU8Yfh6ekdkwvOON0uvz1uZ5JK
	 vawMqiL21dp+2yLZgzie1QHslg3dy5x1v8Bo9RQppoyAFPnCI+o2FK/tlAucWkDA8k
	 EIyXLkkYlBzu5CAXPjAHHP+jz9JQSui+BCr4dNbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=E3=82=A4=E3=83=A0=E3=83=86=E3=82=A3=E3=83=A4=E3=82=BA?= <reza1234khan1234@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 056/869] wifi: rtw88: fix out-of-bounds CAM write when key table is full
Date: Sat,  7 Nov 2026 08:45:38 -0500
Message-ID: <20261107134853.991120914@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 766f22d31079e..3b6302f14de03 100644
--- a/drivers/net/wireless/realtek/rtw88/mac80211.c
+++ b/drivers/net/wireless/realtek/rtw88/mac80211.c
@@ -597,7 +597,7 @@ static int rtw_ops_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		hw_key_idx = key->keyidx;
 	}
 
-	if (hw_key_idx > sec->total_cam_num) {
+	if (hw_key_idx >= sec->total_cam_num) {
 		ret = -ENOSPC;
 		goto out;
 	}
-- 
2.53.0



