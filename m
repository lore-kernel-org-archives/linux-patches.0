Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063848;
	b=Q0lDYlYrHQcFALvyVcNn13j/RQr29xwC+IsBtFSzITvBK1kloHWpPb5NVKtNlqRq1M00
	 aaX8yA+FqWfwkjPtCXCgouinc3JJpOr2FAstAH64dEc52h3UOwJTcUY8FjOYgJ4eZ5PQf
	 2NdruERqgX3xiiAyojixsBmEOETOD7dwPti16FIm08qfo71H5HOfozJOvQ13TW8CqIzCl
	 ++dFzKuGQ82Jz8IS6GxSt2EeMkwZcSGQhq9ANlXu96wuU9bNOgA/0XDupAZtUuDx1JfZs
	 1B03W1I6G0LktBkloh3Ng3M4HhAZ1WZDsIF4WNvnU/vD0msLfN2HvJ6pyf4TUg9Pj1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063848;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aBvG670oc1AqTJ9JJmw6iw7lCvcbHfHtTwU/4Y75mRM=;
	b=crlkyhvZ/nBF5AV2RqOTDp3ZnK9J9nBgrPPqP8sjkkJ8Hhlsz7OT32NPDWksHTktjcTT
	 FakjJOmJCL75l7CsFPcj5IeqDRbuc/tF5imn9+URhFmqkVAIXeWdI0A/wzmJtUzjrjeyH
	 CQWoNNDL1m4OQio1BQFiK7850zGzrbkPa8Rp7VFFXnQYeT+G35jF+TgzdksXPBB/T6dAg
	 oUfA0Q9/L66cRpn6M5QXeOqlO61HpsvsCHwb5JusjZVlk7jOscvP2ENodPvD4I97a0fBc
	 C5MdnjqLQYyDca6n0TUeHi+XhvS5YyoP1X58nRxDrbjoaa5DEniZW97d41Rw4d/5qhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oW1NKWx2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7BEF60A6F7F;
	Sat,  7 Nov 2026 15:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oW1NKWx2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 564EA1F0089F;
	Sat,  7 Nov 2026 15:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063847;
	bh=aBvG670oc1AqTJ9JJmw6iw7lCvcbHfHtTwU/4Y75mRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oW1NKWx2g+MnG3oCVjAZrX1y/jrACpqH8mqmUJVwXts1pFPwYWaOiZ9q9anJQt/6v
	 +KwxaACzmY+9FP5/F4c/MF1EtXt2pS7YZI3dcAvuDFavmzkP+DyiAGomuCT6en0nva
	 BFi63d6O3FtihDmBgGO2nACjn4bhoLs0ZQ5dpUvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Cong <yicong@kylinos.cn>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0058/1257] wifi: rtw89: 8851b: fix swapped DPK channel/bandwidth backup fields
Date: Sat,  7 Nov 2026 08:39:14 -0500
Message-ID: <20261107134941.005980617@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index c63f0e6364dad..71342461f2b30 100644
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



