Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035753;
	b=DhX3jt7kkA9q0KDk9McdG3/F/EYrlcYevfi226gaP+yCQATyg2vbjFQnrFW3qq0p8qW5
	 2Hkh0TcsnA3wIyzmvqwaCLdoGzKe5h+plTiKtYgw8KUuDZOy751wxPy4KOOfW1Ycoc297
	 kxilAqBPINOTKamb3U45qBbky06fya4FDgMONdwHUiXAb65F1aLDT3kunsdt9CgrE7Zyv
	 xo4MRov1BLTE+dB9qaPFdkFfsxZZbPp/HgEI3PH4mB1LC+B2sB1SC//TJsdpNv47Ns6S2
	 o53oTuec26G+wscUQ4NNzAcbkQ9iq0iOvl0i/wJyPysjai28/GWaPshm9ZuO+zfsbLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035753;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=EkQNlRkZnQHuMKSl1PBvoc3jwFH/fOuN9oe+cnTY2Z8=;
	b=UI48OIu5hqbe8plkrsRAb/dMBfwF8FWpAi6AJ1K8oZC/p6WAJQt+M/U9J1ECDvh8ewIr
	 Hm0cgGVWj0wuHPCPN1PsP7uDHCZduXK1GLSUX4yOjnPD0mmJ/qxd0Smx6NIfu6Cx2gzYm
	 aXb5Evt5WCv2ucK/LJibXRgV3+VHdpIq06y36Vu+qR31Q3Y+pLt1Z8bBMKGtNt4+Qpj2j
	 iqbcs3VHY9lCIkGch8tXpvQz4WapvtVZJWTJTyOKs88khvAZoQiSE5LvUjCi6llwmDb1k
	 qiw0b8v9TcxIWDL/RTHqMnVMCEOZjyCzqbVcUIhdPMT8Wp53cHQi0He77wMvVoWWBRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dDCZ7MtT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DADC8606A31C;
	Wed, 18 Nov 2026 21:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dDCZ7MtT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A2D31F000CE;
	Wed, 18 Nov 2026 21:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035753;
	bh=EkQNlRkZnQHuMKSl1PBvoc3jwFH/fOuN9oe+cnTY2Z8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dDCZ7MtTw9jGeORDuv8PSvpiEryduPgbEBBm0TCEdU8Z+2M+tScTRfRVh4ccPoQrF
	 cVdrJb22vkVSY0P2Dhec4w852Z9dgw6zSBoXHCq4unrC5+iFliJA9amPdswf4oIuB2
	 Vj8SKcn56y885i2Yef+Spv+/tJO6qY/mAJ9+TBc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=E3=82=A4=E3=83=A0=E3=83=86=E3=82=A3=E3=83=A4=E3=82=BA?= <reza1234khan1234@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0815/3318] wifi: rtw88: fix out-of-bounds CAM write when key table is full
Date: Wed, 18 Nov 2026 15:23:57 +0100
Message-ID: <20261118150343.477921447@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d8d68f16014e3..1c3b0f1e93db5 100644
--- a/drivers/net/wireless/realtek/rtw88/mac80211.c
+++ b/drivers/net/wireless/realtek/rtw88/mac80211.c
@@ -584,7 +584,7 @@ static int rtw_ops_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		hw_key_idx = key->keyidx;
 	}
 
-	if (hw_key_idx > sec->total_cam_num) {
+	if (hw_key_idx >= sec->total_cam_num) {
 		ret = -ENOSPC;
 		goto out;
 	}
-- 
2.53.0



