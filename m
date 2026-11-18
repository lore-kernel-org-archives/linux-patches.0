Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035759;
	b=x6WCXgIQqRhMJxWNx9ZXu9cBeD2xtagmBF/J33A/hr/ptQ2MhitjvzCJEAr7T3xqE3D1
	 2X7oiN09WbRte+P9IdHoZR3+5Z/eNG/yXNEDVGPmbadKz9LQaUxuNtpwspL7iBA4CAqWb
	 bPguyIRSfjq6ExV8YQfM0NXobsvaOoblRJhZyYXhosIpMvClGZ+5X/665SQm7D66sWHf4
	 XodyJE7VzEfQN+bePmGgHuYjm6Lh1wftdM6NCst+m+4jPqqKFw91hOp57/KEyTeFdFjwm
	 6sVJgP5qgkm/Z1PDAUcyVGhmUsJ077LwmIDjwbV4j5znCvaA5gPonAH4KfiJfDasFFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035759;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0PD0USA9nrEs6lhYjKVdWex0cXMwTDj5NMQas3DAJYI=;
	b=cdZzsS48wEVpKZQwRoW1dUIHV76uWWTlozo83+KeJjxQtvoVkhx8wZBGmNBO4cEbtJRq
	 eqmgp1R+/NmnngWunmvBnBNM05+8eOte94cHISvn22PlhKRsdpqQkNWCCoXX5dMbz/kQ1
	 sNvvyDJtC5Njh8bpbQzCDayHr3BijesIou4XxVWbM/+F1WENE7/SPQEuQJbVtMS+TNrN/
	 QtdDuVOB/5VgBdYqy/oPuEQW3cwIcmjvBaIQu5LRPfRyXeh+f5IHLb+CHFS29ZH40wc5K
	 z/FfoGSXhh3Y/dEGj5AOUJnwhsK+sRlquMOda1XZnKVoHUff9S7/YYRkclX+ugtl5kw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HHlaIYlh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF73A606A320;
	Wed, 18 Nov 2026 21:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HHlaIYlh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D1A31F000C4;
	Wed, 18 Nov 2026 21:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035759;
	bh=0PD0USA9nrEs6lhYjKVdWex0cXMwTDj5NMQas3DAJYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HHlaIYlhD5uI5PWZMgFhDklSEJntA7h2IKCmQcixZbG8GBPSh5cUeiDjxiCHl2Axy
	 8RGgIeNHgqQwDnKHv48+/wF8gAqebhjB+KuGlQ/L/HIykQfgnUWo2i6/gHK5jEiKe5
	 kYFQ2n5ZUbDC6kayWmIwcX+UkyJQa59VfkTFlYDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Cong <yicong@kylinos.cn>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0816/3318] wifi: rtw89: 8851b: fix swapped DPK channel/bandwidth backup fields
Date: Wed, 18 Nov 2026 15:23:58 +0100
Message-ID: <20261118150343.513831750@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yi Cong <yicong@kylinos.cn>

[ Upstream commit 7e080e17ca38b72f6cf01e3bc750c243573e69a7 ]

The .ch and .bw backup fields are swapped; .ch should store the channel
and .bw the bandwidth, matching all other chips.

Fixes: 0194a95cbe721a ("wifi: rtw89: 8851b: rfk: add DPK")
Cc: stable@vger.kernel.org
Signed-off-by: Yi Cong <yicong@kylinos.cn>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260807081006.240450-1-cong.yi@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/rtw8851b_rfk.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/rtw8851b_rfk.c b/drivers/net/wireless/realtek/rtw89/rtw8851b_rfk.c
index a221f94627f5b..df8f05f5eae15 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8851b_rfk.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8851b_rfk.c
@@ -1754,8 +1754,8 @@ static void _dpk_information(struct rtw89_dev *rtwdev, enum rtw89_phy_idx phy,
 	u8 kidx = dpk->cur_idx[path];
 
 	dpk->bp[path][kidx].band = chan->band_type;
-	dpk->bp[path][kidx].ch = chan->band_width;
-	dpk->bp[path][kidx].bw = chan->channel;
+	dpk->bp[path][kidx].ch = chan->channel;
+	dpk->bp[path][kidx].bw = chan->band_width;
 
 	rtw89_debug(rtwdev, RTW89_DBG_RFK,
 		    "[DPK] S%d[%d] (PHY%d): TSSI %s/ DBCC %s/ %s/ CH%d/ %s\n",
-- 
2.53.0



