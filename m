Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044887;
	b=rVpkhd8c41Dq93vxzN66IMbyIE2cIgDmsoBpasLEb74MCSK/5iCdLAiimuoWs5kXPbzG
	 nQ5WJHdxUSffsk5qjVg5jb6SUhqlhlhFiWWoHNqzsr/l0l9vyhhbB9oj9SWn7IGLGSggO
	 go68jaUam2iTR3sl5gE4Hg7qqp7HhF3Lj6FwfY5wZtmXB3pkACrbZRtOSnxTtAlmodfhH
	 h3Vr7kU1zXhoB+KQd8JCqaOCTGBE2slyPiPqxhxQpp3jKP7YFDNvwaX3+t9nH4G+BWfpL
	 Jpgl59xeVhZSjS5GuKM999Zlhb3w/AjO1Z1C2GEIHCpPgnXrD/L9pu12BtrNN822wbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044887;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Vo7Ba6lHp/C6sCr9KXxNUILVskr3hLl4wwsPYot3kSU=;
	b=44ejn5UinyJFCY6MRvIH8nvn+8lGFcQDVw3Vum1Oz7zDjcG6E4Sq1hGR4kvPgcbawnog
	 nNCn2ryi3yczziqWrUKf3c5Eck/TOcBMxfG8b2Kp55vjiBeG1sXCk9sH5MbhDEkDk2FqF
	 SZZe9/5j8vpYkFZm1EQL7qru5kcaaR3PXTDMnzYPxw5FFsyN1rOD1Q4zzdNjdD6U9XH3E
	 p8vjN5EdpAZq0kDlYVIi2OD1MkyhNVU46ia2QnOZyLuCCMNQxbBwv7TQyA7j4kHBAnSFd
	 KNhetn8vwuNOLmH4ujJklHc3EBSkb+aW4lo1hFnOGwQu+vmScU2nvr8Z8BAl9Kcst/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mMyrdROW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6A98606A338;
	Wed, 18 Nov 2026 23:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mMyrdROW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18A7D1F000C4;
	Wed, 18 Nov 2026 23:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044887;
	bh=Vo7Ba6lHp/C6sCr9KXxNUILVskr3hLl4wwsPYot3kSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mMyrdROW9NhEmsTioxrBHACVGMdKUtKimOpIQJPkY2ui6g8AHaQqfEZO16MgSFRwI
	 B3CYDz1LJbE10HlokkLGahA9rlU2uJZrl4bMXspO4tNwR10386GN+ntOryrEsU/dy4
	 SaS2TFbXE6FC8wlYE4DxRytfEFTOJGb9N3Sgrbgc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=E3=82=A4=E3=83=A0=E3=83=86=E3=82=A3=E3=83=A4=E3=82=BA?= <reza1234khan1234@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0725/2857] wifi: rtw88: fix out-of-bounds CAM write when key table is full
Date: Wed, 18 Nov 2026 15:29:19 +0100
Message-ID: <20261118150227.649845955@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 0970d6bcba439..664c863011406 100644
--- a/drivers/net/wireless/realtek/rtw88/mac80211.c
+++ b/drivers/net/wireless/realtek/rtw88/mac80211.c
@@ -550,7 +550,7 @@ static int rtw_ops_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		hw_key_idx = key->keyidx;
 	}
 
-	if (hw_key_idx > sec->total_cam_num) {
+	if (hw_key_idx >= sec->total_cam_num) {
 		ret = -ENOSPC;
 		goto out;
 	}
-- 
2.53.0



