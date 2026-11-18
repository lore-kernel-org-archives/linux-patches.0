Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027934;
	b=pWOEbaOBfW5bHUlg0lhMgF4l4g+bh/6kWYcZvhyiC/uzQ5cSL0go3vOqZfGeMx8wOK6H
	 KWDKx37zRBL4Emo+g1GthWDUoFtoJsMd8E96sBQuhT2Bd8oxeT8aHVJ5HcmkJGazeTjQZ
	 1/x28QGggxzDDFfereI1dgP5WfLVCZBtAle3eKuavo/GD8s0Sxb7V0G3R+/nO60B6Aqjy
	 UkI9JpUZ+GOgpdmEWfgIbfoq2tlevv3VcPOmAuyW3Qypyk9pJOIMPDmZW/85lpS3TjFnk
	 0TVHMWdUnf79sLaSSFtQ0Kpq4CoYv/k5EFaj9z1wzdoeM5d+ZvMRRdds5izd/ScmjKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027934;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AggVhQtTQXtIZL3SFl2w6TukK5O0uWEaEatW2nVTqaI=;
	b=SRtyokF5f0YYsUeB8yejNN8j70Qx5A4jGaS+jLX8O8Mg0R72R/mbTTJ9rWyLL8/nR2MJ
	 hGLOMddcRPtqdNd2uL2k/TEN2KI1bqjLinFDoVWhMVUOvwcJx18GL2GEkrlw8SNV3AJyS
	 5qNB0/RFieUtXQdvCtxjFFyyAv5OgJSD2g1Uo3j8NEpw21qVF+2KyNeFvdVh/wghTQp9m
	 6HvlSfNA/9vkoLeSqX5vA5vkVKsbO1555a+81Q9a7f3DTKRiTceCvNXNERBV0l/kN/dah
	 ihyqJu2PwoAybM3B+DgH9sLeM3NnzHEp0RkTNUR08e3ZfWfFKcalDM+x4ubXb27Xx5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UO8YeX+3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 016E0606A31C;
	Wed, 18 Nov 2026 18:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UO8YeX+3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ED0C1F000C4;
	Wed, 18 Nov 2026 18:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027933;
	bh=AggVhQtTQXtIZL3SFl2w6TukK5O0uWEaEatW2nVTqaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UO8YeX+3Q7nMu6bQiY4GpHmI7UFTGA2E/oWhFrXTd5d6/tjcmC0yBhL0a85cX9BPP
	 BPgBoYw5USN6F27CGECsBTEA0ABmd5jcQzxwXUMnG4iofukPInOdk9WWqId4J3Uh73
	 3eFaSUT+ObNQrnW9aVSBWFLmwHTPqbTtCnppO6ak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1966/2151] ASoC: codecs: wsa884x: disable runtime PM on unbind
Date: Wed, 18 Nov 2026 16:01:41 +0100
Message-ID: <20261118150233.368724128@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>

[ Upstream commit 54c121eaeed8ee7751935db8100b6b5c57124db9 ]

Probe enables runtime PM but nothing disables it on unbind. The pending
autosuspend then runs wsa884x_runtime_suspend() after the devm-managed
regmap is freed, and dereferences NULL:

  Unable to handle kernel NULL pointer dereference at virtual address 0000000000000020
  pc : regcache_cache_only+0x18/0x80
  lr : wsa884x_runtime_suspend+0x24/0x40 [snd_soc_wsa884x]

Use devm_pm_runtime_enable() so runtime PM is disabled before the regmap
is freed.

Fixes: aa21a7d4f68a ("ASoC: codecs: wsa884x: Add WSA884x family of speakers")
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Link: https://patch.msgid.link/20261023171316.819857-5-srinivas.kandagatla@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wsa884x.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wsa884x.c b/sound/soc/codecs/wsa884x.c
index d941e9826ba00..7b8c47a6da1bd 100644
--- a/sound/soc/codecs/wsa884x.c
+++ b/sound/soc/codecs/wsa884x.c
@@ -2127,7 +2127,9 @@ static int wsa884x_probe(struct sdw_slave *pdev,
 	pm_runtime_use_autosuspend(dev);
 	pm_runtime_mark_last_busy(dev);
 	pm_runtime_set_active(dev);
-	pm_runtime_enable(dev);
+	ret = devm_pm_runtime_enable(dev);
+	if (ret)
+		return ret;
 
 	return devm_snd_soc_register_component(dev,
 					       &wsa884x_component_drv,
-- 
2.53.0



