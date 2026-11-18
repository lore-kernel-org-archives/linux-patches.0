Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025885;
	b=g+pHDBY0qUDQFibrwFXGH218QcdnWwfcp/cvzmdtcLxwI4KmrLDNMnKquahJkOeQsUgw
	 pVH+R2Lv4xPOFflm0R4SCOFHNlIioX1nMjVgi1Cp/MjiYZPgjKspZYa/n84jT/BHFWt/W
	 WtgRX8TzWHmRaswD747RKowFYHclSOQy57umNHTSlCI3ygrTkVxgQmmufIyfq4Fx0w3IV
	 7hC3WK5d0V4vPnrw8edtk8KCFZh+qcBONqrD5PpEmfwSqBDN6NNQ90k3aru2BJkLxkYkZ
	 xz6Yd+wJaQl3tGJK+S+4T9GQC/8EQLQ21wIMmOwHVi8yWGM9w7FYvIsc41S9n8JkBNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025885;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=54yJS8m+iS0MtMS2fwOZ/V+pefcoM2Vf5wpZ1GRK5+8=;
	b=sHfMNqmnoFoYFZdKgD4lc/nA+nKBvbsYhP3qvATDhIvQa6TViYobVe0p2E+qKp5Lylbg
	 6qj0P3bowoFnnd/JIAeeLwt1GkB7Sw3qHNl5dUHbw/aaMQsHKD7KM619rszZ9Y+YD7Bsc
	 CPEOcKuRWsL+EG1A/GZoB5exqo2/fREViUenF9VGuhGpBS8nDQ8AI3V7+L6mRGacSkKWw
	 otI96XW636JvmmAemSyzDHJ6UOVR4SK7kEpoT/n5jUa5mUFfCJP3iDIyC7hmflHnQCQC7
	 1XByRR0OL2sQQam2X2BRXD2zbpbcsGrWsy2zfyFXuMYVUBDy6QID4wxG50QK8FrUUwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0pnv1yTm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B20B2606A31C;
	Wed, 18 Nov 2026 18:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0pnv1yTm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF5291F000C4;
	Wed, 18 Nov 2026 18:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025885;
	bh=54yJS8m+iS0MtMS2fwOZ/V+pefcoM2Vf5wpZ1GRK5+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0pnv1yTmdawhlZUao8pkUP+gh+tiK3RAtfM3Mv6T6Sb2AAICD/ZWAToMBtbxudGgJ
	 HgnMxdw+Et+Qd2XdmAgbgUDh3QWZshab/b8t3WSggk0hMzs4EStJuA8CLf8+RanAP4
	 cm7uncqZIS3n71xt5r0bA+M74cQ8uofPO/LCF8RQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1236/2151] ASoC: rockchip: rockchip_i2s: Handle runtime PM resume failures in set_fmt
Date: Wed, 18 Nov 2026 15:49:31 +0100
Message-ID: <20261118150207.202872217@linuxfoundation.org>
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
index 0a0a95b4f5204..6b0d8eb5fa3c1 100644
--- a/sound/soc/rockchip/rockchip_i2s.c
+++ b/sound/soc/rockchip/rockchip_i2s.c
@@ -244,7 +244,9 @@ static int rockchip_i2s_set_fmt(struct snd_soc_dai *cpu_dai,
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



