Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062740;
	b=YY0OegbXSRVGD4vwnA+fSWw4cbrQZHBifL5j91GKPIDAzLwXLoe9mEvG+VMz/JegC9Zb
	 JtV3TZy+1Vo+Q4hIiMjwwVMqV4VXyvT+uTPkuQSA7aV7DuRzjugpec9W44DDpKOnewXOE
	 t+KlsxfJ2aFzJQ+7Nqh54NoSPHjOxjPa9Ty3UQbh8gfFoxkLte4TveGj7gLI6cbxpO1Kw
	 SbVPTWAD4Mog0u7p2yG+4uJFyB3v2l1dBS0tfG+P+6KIdHENS79zrIwzaPXoobRcaBEz+
	 tjTmzrDRvYDfTO2BOcNBm2Uwxx9+x+USFiPbG3uPAMJimju9IKPt8+AiNXk30RDL+6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062740;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=29JUH26zDLLd15WhB6o8R6DZgdgZx4kJHLgN91sD004=;
	b=wqtqxt6hY3y6EwWITkXww+LoVvh4Eynjtm43hUzUmQqV10HVgHHRpc0vlt7Rr9P25X2T
	 l0rDfABORvfZ5mIpEc2LioBmpA18zy4K27K5jCCDXOzmZglYx3Djr656Ks0Ur8a0bfH7Y
	 zrAs/THSbFpcU9IzZIqm71y88SkiJcCyqdhLkCs6jjDT8C7nhC/qh1UiNCJumlrqnNLco
	 C1vhgGbPgysUaEcJfNWAi1VXvtzSohpzup0NoUrA11EgHQJI5vANB31lagiPtMZ8YtG3w
	 l+c+q6Z+GA0BnoDAllz90yN+kNjrL0sU8CWZmp1AP3hkLX1Y4gpBpsNRdazUSaqHPDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k91gFEri;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93C7F606A32E;
	Sat,  7 Nov 2026 14:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k91gFEri
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 274E81F0089F;
	Sat,  7 Nov 2026 14:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062740;
	bh=29JUH26zDLLd15WhB6o8R6DZgdgZx4kJHLgN91sD004=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k91gFEriArtmdCsFPtIWMvbBYl7ms0RuhTcvwlqMP6sKrGidNRDRGskeTGQSnsZmx
	 vXDYz51kKgodOUl/WbWi7sW/lmyREdqzuOzZMV/oPgxBWtpmUEBp2u5Yx3EwpNu6H1
	 fnfL2/8yvFDwGfUlJiWUvl/c70JL+6W4WHvcL0+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Cong <yicong@kylinos.cn>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 057/869] wifi: rtw89: 8851b: fix swapped DPK channel/bandwidth backup fields
Date: Sat,  7 Nov 2026 08:45:39 -0500
Message-ID: <20261107134854.028868665@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 84c46d2f4d85e..6d2382cb5cd8c 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8851b_rfk.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8851b_rfk.c
@@ -1895,8 +1895,8 @@ static void _dpk_information(struct rtw89_dev *rtwdev, enum rtw89_phy_idx phy,
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



