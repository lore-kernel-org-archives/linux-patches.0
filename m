Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041167;
	b=MH3lOfVheCEPWosnoYBohhVDT0QYcwokODSuNr7l6FhPiA7GbpWlMkVb80pyEjNeWmxM
	 /5+SUj6XyCFVp4rIzhcAKBPxjb9P3yLt7m+DJWNJyE4R1f9R4NwS0vr5D7EpTXtCD4rfg
	 WmQnigV7sQR58GWOBdd0Bc3rFpn4k0TEi4u92HJX+xG22HSq7VV0koYRQAbOwwqQ8yTPL
	 14jEXl2BDQ6j9WQyZJYqCtTp8X2FESPd7Vu4R2PdjulBn0UYH37gcaViZvhjJ0Zem0vgD
	 iIje51gm/N7Mah0W7URQXAQZ4ZZtznpeZf2SzDoOawFuw8AMKOnUXMGM1RCX+F7Q+pw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041167;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kuk1jkoUW7zDlmYd65oH++Xk1ZoXK79rA+RB+GiVByU=;
	b=Ysk2yzVKPx9uffAqI3uZCCfPY8VsZM2tR2v5eZ2DY4z51xJFJpYha0ELHULjQzVOG6Ve
	 gqxXPj6kykc/ptQ+ckEhRR7tN8K07kTWo4UPPN3NLKRGoNKwcDjvPq9kELAh5qc3jXPeD
	 ZQtZjz7UtpdVDEmfGfvm/U8NpuQNA1xdakgEnxwbsJmYKgjM2b44E8hcNarb42TiLMJZp
	 GpmOCi/4Dk6FWA4dqffwy/IdOW8f8gnW0cKOks5uIz9DLSv7QxqAI7RqlS7VzKRofOiGy
	 YTHNUP/VVcTXJ6y7I4l/lyN3SlUKUlniuo5NN3zaBjauXAh9dbiYfOkOQdMyOyblLYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hATWlc9P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB65C606A31C;
	Wed, 18 Nov 2026 22:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hATWlc9P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D38FA1F000C4;
	Wed, 18 Nov 2026 22:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041167;
	bh=kuk1jkoUW7zDlmYd65oH++Xk1ZoXK79rA+RB+GiVByU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hATWlc9PFD+6rdTYVfq/bA8mOrg9/Ff62ENEYLuE6a56SWPWcdz6WJkQoukCB58qC
	 JF9wNlln8RDWd0oO39bsL3YtGvYNP2N/TKb2ARDroolC4/1nRXJtehAUUfI886Zeuo
	 Nko+fMKuzlpNTVzO8GMu54IAnC5IWbqQrDEFe+54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2676/3318] ASoC: rockchip: rockchip_i2s: Handle runtime PM resume failures in set_fmt
Date: Wed, 18 Nov 2026 15:54:58 +0100
Message-ID: <20261118150441.277827339@linuxfoundation.org>
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

[ Upstream commit e9eb1854d16136006c6fe94c927b54b2b264b429 ]

rockchip_i2s_set_fmt() calls pm_runtime_get_sync() before accessing
hardware registers, but ignores its return value.
If the runtime resume fails, the function continues to perform register
accesses while the device state is undefined.
Replace pm_runtime_get_sync() with pm_runtime_resume_and_get() and
return early on failure to avoid unpowered register accesses.

Fixes: 53ca9b9777b9 ("ASoC: rockchip: i2s: Fix regmap_ops hang")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260903112739.373621-2-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/rockchip/rockchip_i2s.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/soc/rockchip/rockchip_i2s.c b/sound/soc/rockchip/rockchip_i2s.c
index 834fbb5cf8103..f215389574013 100644
--- a/sound/soc/rockchip/rockchip_i2s.c
+++ b/sound/soc/rockchip/rockchip_i2s.c
@@ -245,7 +245,9 @@ static int rockchip_i2s_set_fmt(struct snd_soc_dai *cpu_dai,
 	unsigned int mask = 0, val = 0;
 	int ret = 0;
 
-	pm_runtime_get_sync(cpu_dai->dev);
+	ret = pm_runtime_resume_and_get(cpu_dai->dev);
+	if (ret)
+		return ret;
 	mask = I2S_CKR_MSS_MASK;
 	switch (fmt & SND_SOC_DAIFMT_CLOCK_PROVIDER_MASK) {
 	case SND_SOC_DAIFMT_BP_FP:
-- 
2.53.0



