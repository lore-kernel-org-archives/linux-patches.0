Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015721;
	b=QUBJ0HZbuUMBFUVj6C9uh4PplYiXNQIhrU+GGKL4U/u9qc5Q1qbTrhFqqqmBf0o3n4CE
	 3dIf28b+HUHDpEDWZyPToI9jpIPySalTyx4a8rhTHA1XrJ7/d1AX2z6evcUjxJPHpY+Qh
	 V84ZUq3u1NkD5p47wpG/YrlMfgMcwWNgrJ6A/ciOhaNFisEf3sDC/kG0rX0tJHCgrbr18
	 FkeBa/SB7EJ1Q4DyhJnBrvRt5vAj1MZixN+9Bq1ATyYjt2eGCYSQ9SPnpz7+0c3Ear+eo
	 MX4NbnLAGykl4KhOGODHKDQNtDe+0TgFXYGhhk9Cv1GFtSUpHoa2uzOcnlzUzOEIAZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015721;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SCcor2+jT1sJZ99t7QLJDAKi4y3Rf1ye+EQ6Ui94VC0=;
	b=WSbxAWOD6PzKtOnfZQDTw3Vo66NlEzNFA9Oqj3ON2EwC/ALcQB+lCTA7EP9guSjCIGl9
	 xpY99FUYCRLwJ0NzP2bzGcEoMcEhUKu77qaOoo9mhx/uvGTs0wcV92l24Oak/ZQFXTR5K
	 XhSv9Aue/t/zODH9+h2cyuyfYAp+5b316RRN0et0nC26BTB4/1e/F/5RcEkWI0TgWic/y
	 jnLaMicIxJ6SKgulgDkoBZs5b2k4Fld78PrXKyjPTFApi8hwOQ8VMH7hI5mPM/gz29Rxx
	 JLV5eUGV+p9aDttNb57KiXbd0TNFpgkg/bI9kQHW4cyz+Nrn5Kc+vVzU+s2WszupvTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VZLfSzRe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 267E1606A33D;
	Wed, 18 Nov 2026 15:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VZLfSzRe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E9BD1F000C4;
	Wed, 18 Nov 2026 15:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015721;
	bh=SCcor2+jT1sJZ99t7QLJDAKi4y3Rf1ye+EQ6Ui94VC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VZLfSzResBVvjmaGTW7o4L/ud+nDRPgF46AH0caDXGbH2TTZInTaPatLGrZ7JM3Or
	 /ogqGHBtpxK4KeYgHB2dCHeOHbnFBCuZvwOhygsJPeRfhqRh0KgOFGMGbbNtLbdV3A
	 hv7VbEVQlPoAFFX/9+TCOSnU97EOZVhzgO4vJd0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0274/2651] ASoC: mediatek: mt8186: Fix MCK error handling
Date: Wed, 18 Nov 2026 15:25:14 +0100
Message-ID: <20261118150257.770337862@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 996469c1092e8fa81fac98d819174ce56baff821 ]

The mt8186_mck_enable() function returns immediately when a clock
operation fails, leaving previously enabled clocks active.

Add error paths to disable previously enabled clocks before returning
the error.

Fixes: 55b423d5623c ("ASoC: mediatek: mt8186: support audio clock control in platform driver")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260903051150.178057-6-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8186/mt8186-afe-clk.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/sound/soc/mediatek/mt8186/mt8186-afe-clk.c b/sound/soc/mediatek/mt8186/mt8186-afe-clk.c
index 77a0cbc8ee241..62b008b7caca2 100644
--- a/sound/soc/mediatek/mt8186/mt8186-afe-clk.c
+++ b/sound/soc/mediatek/mt8186/mt8186-afe-clk.c
@@ -520,7 +520,7 @@ int mt8186_mck_enable(struct mtk_base_afe *afe, int mck_id, int rate)
 		if (ret) {
 			dev_err(afe->dev, "%s(), clk_prepare_enable %s fail %d\n",
 				__func__, aud_clks[m_sel_id], ret);
-			return ret;
+			goto ERR_ENABLE_MCLK;
 		}
 		ret = clk_set_parent(afe_priv->clk[m_sel_id],
 				     afe_priv->clk[apll_clk_id]);
@@ -528,7 +528,7 @@ int mt8186_mck_enable(struct mtk_base_afe *afe, int mck_id, int rate)
 			dev_err(afe->dev, "%s(), clk_set_parent %s-%s fail %d\n",
 				__func__, aud_clks[m_sel_id],
 				aud_clks[apll_clk_id], ret);
-			return ret;
+			goto ERR_SELECT_MCLK;
 		}
 	}
 
@@ -537,16 +537,25 @@ int mt8186_mck_enable(struct mtk_base_afe *afe, int mck_id, int rate)
 	if (ret) {
 		dev_err(afe->dev, "%s(), clk_prepare_enable %s fail %d\n",
 			__func__, aud_clks[div_clk_id], ret);
-		return ret;
+		goto ERR_ENABLE_MCLK_DIV;
 	}
 	ret = clk_set_rate(afe_priv->clk[div_clk_id], rate);
 	if (ret) {
 		dev_err(afe->dev, "%s(), clk_set_rate %s, rate %d, fail %d\n",
 			__func__, aud_clks[div_clk_id], rate, ret);
-		return ret;
+		goto ERR_SET_MCLK_RATE;
 	}
 
 	return 0;
+
+ERR_SET_MCLK_RATE:
+	clk_disable_unprepare(afe_priv->clk[div_clk_id]);
+ERR_ENABLE_MCLK_DIV:
+ERR_SELECT_MCLK:
+	if (m_sel_id >= 0)
+		clk_disable_unprepare(afe_priv->clk[m_sel_id]);
+ERR_ENABLE_MCLK:
+	return ret;
 }
 
 void mt8186_mck_disable(struct mtk_base_afe *afe, int mck_id)
-- 
2.53.0



