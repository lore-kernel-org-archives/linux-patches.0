Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061954;
	b=Zj2cCVpSRRd90yHjfJSXKD+wjnGgNDAYd4kygL0MmfM1BzMdOLLD7owJ1GKQawKbX2ji
	 /aT3sZ7I5J+TZCS7VKGEaO1rSp6JzQ14GpRLA2rYMsmZQg8I/Xtk1Dglf0TlORC1G17iX
	 /3+qe12P6DVRgOF0uQHt6hpRvgf17k76HOuhNv8mmxY/bRWh5xrFPkEKKngDjZSr45GqL
	 g+jMZUT0I/YSPPVMs6LQElUD+B3BWOfUXKagD1FmlOfA9YA71na6BzUcdopfeI6qooD6U
	 +AF9GF+mSVt5ZiDrhAyDy80/z0eMkSD/bC7h6AWL3Cr2WFPHCTFbtiTh/eB3EMD1JhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061954;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WQmaAOTZLHs3dw9/4cQTnWOsAgoYTQOnPgRXksowesE=;
	b=mEmcSwOodT7ktrMpPcQ9MRzXQXOdP3qotO9jAdxs8Y9amjrzG1lEy5u9q614IyqD3S0n
	 3t0H76cNzzsGPggEJNR18/DTYEmNjVCr+ojTKb3RF/7yIqZzdOEYlseTDiHqStSEvK/tZ
	 lcuq9YZhKh3YZZ9VdVru6gsl1ORem+thW04qf0zxWywtp3RsQjHjWiuFae+khAyhatTtX
	 m5i5cmPGwkaPnmAvkfU7ty5Zmlqn4y9IbV6D+TH5K5a7/Pz7mcuvZ92CFm5b9zLbPwWTb
	 qcJAy1PyykC1Q3tPJQZ+aSA0vA6EvGbCWDNPvywu8Un6YTRwpbfSCXiXhsUDY4xIrZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="lMjKzc/b";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D200606A32E;
	Sat,  7 Nov 2026 14:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lMjKzc/b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFDE41F0089F;
	Sat,  7 Nov 2026 14:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061954;
	bh=WQmaAOTZLHs3dw9/4cQTnWOsAgoYTQOnPgRXksowesE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lMjKzc/bLy9Dcz2cTRZVW8jVnXAyKDYyogQlYqxsuZRLJEImbqPURIH2ft1jVh5PC
	 DsScvKn0W0JQIDTDS1+SFJF7EvOJesGd558qRHt9HAa36DOlDJT7GLlbzJlQZr5OXX
	 AV0Bl3Fmhh16CDYkhkRBrCBqeugLDlIVgfzj/VHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Cong <yicong@kylinos.cn>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0913/1536] wifi: rtw89: 8851b: fix swapped DPK channel/bandwidth backup fields
Date: Sat,  7 Nov 2026 08:48:49 -0500
Message-ID: <20261107135023.279849365@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 364e363542256..694a4f806f6b7 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8851b_rfk.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8851b_rfk.c
@@ -1758,8 +1758,8 @@ static void _dpk_information(struct rtw89_dev *rtwdev, enum rtw89_phy_idx phy,
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



