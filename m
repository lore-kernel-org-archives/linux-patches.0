Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041073;
	b=ExEcvDLeUCE2dvgm8D4f+WyssbCI4IxdBvV1E0I5fbwqbixbxUBtPKyS4tV1sLMIIROc
	 3CQQlQZsDxoaKn1t1ZjBLqotpcthKaWI4ibt9TT6bAyz8B36k1zFF2kiQdaZ/e/ksZVwm
	 ij6byZlu8u6/7ccN/hgYaDgt80yKOBeWmz8s63EDCF2vIIxzAI8QPIcjZ9huqeJuJHeQw
	 lGS1UDQv883XHSyh7eCRrheFLsW2oKcCbUeHzB8DOjRkmAPj1R2CWX3OBhMsK6K5KT6uj
	 8BRWTi79Qjt0DoHDkfS5rAXfjs8WcyYGounK1hP37SKAjR7e1sHjZQgNKeZSuvuN2Pg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041073;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TKbR3rBKDicR/MxfBjA/Xt25VsJIo9RWSdH56metXGY=;
	b=WrhMFOCFAzi442kUhl7x1cO4jvbOecENmh65sHZ8NXeMld/GZx+7RUS0cxGQr+Q+r54C
	 CCBE+u95MFvGMhEUBoLN14MCHHogyMZ9U/shL3gOwSz4S5amDfR/MUehgYdoSIKLl/Hhr
	 k5VuJ8wjuu7o3AA17Fq87NNAMjHMSYR6VE9RdayD47AgIUODsaPQf39cbLrqpGF6RaPB+
	 P5RwrRK9dy4KwNnLbqdRYXi2zs1nhWucCdgveYDO5O/iR5GTldX2aSXo47hK4nkGZdUQm
	 IjqJGRD5MFZoq45bwPq/OtTdyuZOunfOGHmbRUuGbnA1caQgUYMbeoeztcGJJ9OCKTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u4QJ1Jhp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11653606A320;
	Wed, 18 Nov 2026 22:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u4QJ1Jhp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 620151F000C4;
	Wed, 18 Nov 2026 22:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041072;
	bh=TKbR3rBKDicR/MxfBjA/Xt25VsJIo9RWSdH56metXGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u4QJ1Jhp6Bd39iFf5I/covCZ0KBFf4iI9M/SEhmK9oM2QS4X+koK5eOYljqI0plTd
	 awSSc5qLC2PMyVofOW3HlLRO0K8HAtFdDMHlqaDmtS+cnul5caq7m4MK2YX3DTaCA5
	 6lXj/7ROUbttoDUXP3SHF61I/H/0wWQ4OiRRAuck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2684/3318] ASoC: mediatek: mt8188: Handle constraint return value in FE startup
Date: Wed, 18 Nov 2026 15:55:06 +0100
Message-ID: <20261118150441.495283215@linuxfoundation.org>
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

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 71253751586b8ce37570b8e15cfbc74f0dd06c3d ]

snd_pcm_hw_constraint_minmax() may return 1, which is then returned
from mt8188_afe_fe_startup(). ASoC only treats 0 as success when marking
the DAI as started, so .shutdown() can be skipped on rollback.

Return 0 explicitly on success.

Fixes: bf106bf09376 ("ASoC: mediatek: mt8188: add platform driver")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20261007110858.509341-3-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8188/mt8188-afe-pcm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/mediatek/mt8188/mt8188-afe-pcm.c b/sound/soc/mediatek/mt8188/mt8188-afe-pcm.c
index ae2b21ac604e1..fbd2fa68e2238 100644
--- a/sound/soc/mediatek/mt8188/mt8188-afe-pcm.c
+++ b/sound/soc/mediatek/mt8188/mt8188-afe-pcm.c
@@ -320,6 +320,9 @@ static int mt8188_afe_fe_startup(struct snd_pcm_substream *substream,
 					   MT8188_MEMIF_DL7_MAX_PERIOD_SIZE);
 	if (ret < 0)
 		dev_dbg(afe->dev, "hw_constraint_minmax failed\n");
+	else
+		ret = 0;
+
 out:
 	return ret;
 }
-- 
2.53.0



