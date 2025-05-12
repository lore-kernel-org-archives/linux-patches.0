Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03E7B297105;
	Mon, 12 May 2025 17:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071781; cv=none; b=lvkrdzH1xCOZJrjRD2ruvNa8ckz723Ips+MmCImOTP89hf9RNKYZoul4gn6S5rBl1fZZCH+5xVGrDmEs3Sbq5XkY9xoZqcJd1iWVRT8L4eWv4gON0HQXUV+eM60QZKNtDYayFyjDDcL3onAvtPkXEBYGqfeKjSRfqEr4+DUU1Oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071781; c=relaxed/simple;
	bh=ddbb87P3F5YCzIfxsHCczLheR5BScPNX+H4v/lbNdn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a03joEUtluNd8GvTv0Lu2flC+lbL2HqGahammUKVq6fINGY07aXwlpXYUergKGFbkKY3KxbXc5orBdadJptKWd7xQCiehr29mkqDPXtzQZ3o6DCP6i3rWGFl31ORyN95zhHX5kq9zCG8jJTDiVnkZV7dD6YRvFdfXQ2qThJd5HQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uRLatgnL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uRLatgnL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1716BC4CEE7;
	Mon, 12 May 2025 17:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071780;
	bh=ddbb87P3F5YCzIfxsHCczLheR5BScPNX+H4v/lbNdn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uRLatgnLSN4+IOQp6zrJ0dc1pZHMER6EnDmXRaJM4RQ7RUXOT3u09entHVilcGpic
	 yzk4hvI4RPm7DadyCMF3hvLrVDcCFWFiPoQotZXFrrCx7EhOBS6RLMKZ2WOO70OLU1
	 uCfrhxO05cf//L/GHlAe2dJXq2y468osfK2t+m80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Wunderlich <frank-w@public-files.de>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 024/197] net: ethernet: mtk_eth_soc: do not reset PSE when setting FE
Date: Mon, 12 May 2025 19:37:54 +0200
Message-ID: <20250512172045.336945938@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Wunderlich <frank-w@public-files.de>

[ Upstream commit e8716b5b0dff1b3d523b4a83fd5e94d57b887c5c ]

Remove redundant PSE reset.
When setting FE register there is no need to reset PSE,
doing so may cause FE to work abnormal.

Link: https://git01.mediatek.com/plugins/gitiles/openwrt/feeds/mtk-openwrt-feeds/+/3a5223473e086a4b54a2b9a44df7d9ddcc2bc75a
Fixes: dee4dd10c79aa ("net: ethernet: mtk_eth_soc: ppe: add support for multiple PPEs")
Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
Link: https://patch.msgid.link/18f0ac7d83f82defa3342c11ef0d1362f6b81e88.1746406763.git.daniel@makrotopia.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index bf6e572762413..341def2bf1d35 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -3427,9 +3427,6 @@ static int mtk_open(struct net_device *dev)
 			}
 			mtk_gdm_config(eth, target_mac->id, gdm_config);
 		}
-		/* Reset and enable PSE */
-		mtk_w32(eth, RST_GL_PSE, MTK_RST_GL);
-		mtk_w32(eth, 0, MTK_RST_GL);
 
 		napi_enable(&eth->tx_napi);
 		napi_enable(&eth->rx_napi);
-- 
2.39.5



