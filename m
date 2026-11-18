Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032157;
	b=UA9zgqRs+feesmjLYPJAYkVNCldEaEfuJldm675BxrZPsy9UCgr/65aQElKZ12RAKEMW
	 H6AvqcERgcsPnrCcPUh3E1W7IMI71s8do0VYldU0DwehnRjZEhDdZfmbjXBHBRR7/q+2L
	 /hJ8CZIk21rztPbr6r7MihdhJPqgTseRguFjPJx2AcSQK+Rcfv55KUmH70cgS7dNcTqnA
	 fbd5wkaLbmDGK9f9gek+8phLUkyawKkGuT3PHa7KMVFjMh0/BQcB4UWGfKjBDwUKM03pM
	 qe9oJ+lEFXv3r1Tacfy98o0nSWFaTaEdPSHA99TVemwP2XIuQQTNzMVJik/m+sda3KA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032157;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hTHhmN35sjC0OKFgsp+A1Z9fsb9s7lfEuSOVXw1qX70=;
	b=F5Lox99GndLpZu9IC9emGpwggMrgg1LLy4b2xdF0LpSYXDEk7cL8KuNRKlJzlrUetw4c
	 /078F53vj+dEpJDbCwithpz2uEXmLT8W24D1V7bfmgcCLNnjr3BHCVB5M1eeKUgt31WE+
	 BmprVhCy/IwwEAEWE6q6yo72bTm/oy49QQeAvfLOzwg5Q3VtDRw1D+YiBgOb63H38GxYQ
	 ArqhEP5IpWWmOBtAgDrH/NyQMdNybpjwk9V6Rxhg3LrylvhDibfjefRw6sO97rDR07Vp1
	 SVJkSybDBHm/g9ovJwWF194PD36nwuaN8OBao+prYtEo1bqHKFYSRz9pcQUeFsN5Uig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="T/4008YJ";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 941BF606A320;
	Wed, 18 Nov 2026 20:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T/4008YJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99A241F000C4;
	Wed, 18 Nov 2026 20:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032157;
	bh=hTHhmN35sjC0OKFgsp+A1Z9fsb9s7lfEuSOVXw1qX70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T/4008YJwnYZASnS4PbZOduQ+tQhlJdsb4mrUab4rMvtbnh74h/FCOVkG43cAGVJ/
	 TSBiDqJFHL+nmJjTfZTTFL5WkzfoHF/9Pu91EKPILcUVB6BkzFemTdR8dksByhQXxW
	 eHEeEJfG4f8WdvbaXOu4QLjBSuvcgqX+4b9bUIG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ajay Kumar Nandam <ajay.nandam@oss.qualcomm.com>,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1311/1756] ASoC: mediatek: mt8195: Fix ETDM MCLK error handling
Date: Wed, 18 Nov 2026 15:57:18 +0100
Message-ID: <20261118150101.664783564@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 91dce9c7eec25e95b5ca32e17e60e2c27333d411 ]

Propagate errors from mt8195_afe_enable_clk() when enabling the
ETDM MCLK instead of always returning success.

This allows callers to properly handle failures when enabling the
MCLK.

Fixes: 1de9a54acafb ("ASoC: mediatek: mt8195: support etdm in platform driver")
Reviewed-by: Ajay Kumar Nandam <ajay.nandam@oss.qualcomm.com>
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261014112752.683032-13-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8195/mt8195-dai-etdm.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/sound/soc/mediatek/mt8195/mt8195-dai-etdm.c b/sound/soc/mediatek/mt8195/mt8195-dai-etdm.c
index fd4f9f8f032de..db84f9e34114c 100644
--- a/sound/soc/mediatek/mt8195/mt8195-dai-etdm.c
+++ b/sound/soc/mediatek/mt8195/mt8195-dai-etdm.c
@@ -1554,9 +1554,7 @@ static int mtk_dai_etdm_enable_mclk(struct mtk_base_afe *afe, int dai_id)
 	if (clkdiv_id < 0)
 		return -EINVAL;
 
-	mt8195_afe_enable_clk(afe, afe_priv->clk[clkdiv_id]);
-
-	return 0;
+	return mt8195_afe_enable_clk(afe, afe_priv->clk[clkdiv_id]);
 }
 
 static int mtk_dai_etdm_disable_mclk(struct mtk_base_afe *afe, int dai_id)
-- 
2.53.0



