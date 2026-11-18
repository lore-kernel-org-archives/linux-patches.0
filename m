Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030356;
	b=iDw7f573JSrFU5G+wt2VBOi3f2o4kkQj2ciHjT1KmMzff2VKX+3lGMKUteivYGM+ZlNW
	 MtEaM9146znhPQWy8kn83DxN0M/oE8OZZfRdCKjl6GwHHhlOwdG1FoC7NNHURJWL0pD/a
	 zbI8NPITXldp3Ru3HPIAmtAEfiYz6WqYyYIIx+W06XP3XQT2le+H9hMSgfPLSToM9pTUk
	 A0DjTwilbGZGyx4SHgT2kfaiZ9ihw05pvJrNS7WNm0AsdYZ6YWaCEeHGqEyxwqnBY/L2s
	 8WC5FeF2mSpAT0LtotON1QboALOQbX7yYMb2k3F3QUMaamsgUf1E8hMaMp2+oXQrAHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030356;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MXl2zq8HtZ8MIhINa/lCIT4CfZ0DcDT4MjaZkv1q1tg=;
	b=2g/X3gk/H7wFKEwvgE19egnkDzlPG4ySk5erPRigoDk4l6V8wMsABA4HaV2UGqosVzab
	 zk639jCueUYicmELzJW5e/nbao1HhUjiv2Tg0V4PR07C5QfAnmEo3Gfe0SmQz3k5gzVO+
	 8I13Dq7oSXTisejcy0HsFpk5ZcKUxTsgQ7wGtLt/uOcNUKTrqwc0XuLHMUOOm8lV9leVw
	 qeCPMAkVTL7NoOhdMSD6GBgIQKIywNEg7sUKklgGhravQCpD1rMzWQrNSMa/YnXd0/akt
	 Wf/dLo06pzCpDbMw1HvVFsAm1KzwTEp519tIf2cbXItwe/apLXsanxBDdTha1iLAQoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D2VpsGs3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BDFD606B101;
	Wed, 18 Nov 2026 19:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D2VpsGs3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BCA01F000C4;
	Wed, 18 Nov 2026 19:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030356;
	bh=MXl2zq8HtZ8MIhINa/lCIT4CfZ0DcDT4MjaZkv1q1tg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D2VpsGs3wiHN1c1zrb+/jMkDqEqKKsaaN+IQJi0UQN6TBTorFrI/dDYMrTOsmmYJt
	 TG3xorpWZnBv1URCSkwbjHPGS1mZl3PCtfbWVmuL2JMiEFURUA0OesdNtWLUJm80Et
	 Gkjj/jHDWMzly44I5D+Opu8vMZsqQO6hpFhiO0v0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0648/1756] ASoC: mediatek: mt8192: fix MCK clock error handling
Date: Wed, 18 Nov 2026 15:46:15 +0100
Message-ID: <20261118150034.614217109@linuxfoundation.org>
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

[ Upstream commit 4a0ab266cb1594f8c6aef3c79726476ad99618c5 ]

If an error occurs after enabling 'm_sel_id' or 'div_clk_id' in
mt8192_mck_enable(), the function returns directly without disabling
the previously enabled clocks, leading to a resource leak.

Fix this by jumping to proper cleanup labels to unwind enabled clocks on
failure paths.

Fixes: 125ab5d588b0 ("ASoC: mediatek: mt8192: add platform driver")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260918133912.133799-5-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8192/mt8192-afe-clk.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/sound/soc/mediatek/mt8192/mt8192-afe-clk.c b/sound/soc/mediatek/mt8192/mt8192-afe-clk.c
index 118dd48196828..77f596cab92da 100644
--- a/sound/soc/mediatek/mt8192/mt8192-afe-clk.c
+++ b/sound/soc/mediatek/mt8192/mt8192-afe-clk.c
@@ -619,7 +619,7 @@ int mt8192_mck_enable(struct mtk_base_afe *afe, int mck_id, int rate)
 			dev_err(afe->dev, "%s(), clk_set_parent %s-%s fail %d\n",
 				__func__, aud_clks[m_sel_id],
 				aud_clks[apll_clk_id], ret);
-			return ret;
+			goto err_disable_m_sel;
 		}
 	}
 
@@ -628,17 +628,25 @@ int mt8192_mck_enable(struct mtk_base_afe *afe, int mck_id, int rate)
 	if (ret) {
 		dev_err(afe->dev, "%s(), clk_prepare_enable %s fail %d\n",
 			__func__, aud_clks[div_clk_id], ret);
-		return ret;
+		goto err_disable_m_sel;
 	}
 	ret = clk_set_rate(afe_priv->clk[div_clk_id], rate);
 	if (ret) {
 		dev_err(afe->dev, "%s(), clk_set_rate %s, rate %d, fail %d\n",
 			__func__, aud_clks[div_clk_id],
 			rate, ret);
-		return ret;
+		goto err_disable_div_clk;
 	}
 
 	return 0;
+
+err_disable_div_clk:
+	clk_disable_unprepare(afe_priv->clk[div_clk_id]);
+err_disable_m_sel:
+	if (m_sel_id >= 0)
+		clk_disable_unprepare(afe_priv->clk[m_sel_id]);
+
+	return ret;
 }
 
 void mt8192_mck_disable(struct mtk_base_afe *afe, int mck_id)
-- 
2.53.0



