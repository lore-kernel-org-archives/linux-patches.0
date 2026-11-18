Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055903;
	b=XSv9EsbhVC+Qy06GGVGJdiH8QVVgA1zjaYfp4p7ApGZ5l2OqP2n32ruiUs1TOrCIToO+
	 iJLT/Phe2XecBxmhhAVVkt5yDDdpfeSHwhzLfojwI1gl01+HLbKJwqYZbkwtCddo3sctc
	 C4i4sNMkc4bUS18xXNBRGfUBgbRMqnxhUZAdhVktWku/nGPQ/PKHxzY676N/tu57pxXiB
	 flxYv6wBx6UelnxPgF0vShP7VKYJ1G2Qr58y69EuRD3eXfW6fa37+U24Cb8nm7YI70Ozk
	 lKxUx2Y1cTTXNv0GArE2uvOxDKjVyHhXHahyCkatkx7/CiFcZzfHn2GRd2lM+Jgeefw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055903;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QjcagNDdmvQI9oQjYfoATgWRZhRd/i9sUZ7Ke3Pg8Mk=;
	b=BGRAZMuo7bl8+VYDqJwnvKEfbD2E8KJLxjQvUNYetphkEDX1siYvdnnUeYr7QhmJ3Gwk
	 CY6jw2/LZ7dIJ409acUDaxiHdnND+tPm1A73GAEfHLFHgcqK0Axe3GLYXqe42GQazLAL5
	 ihc1OmvD9watuQ6q07KMFLuWj+WCjLsjdReFpf1zm9af08GA+utAdiXapujpOnYbZw7wn
	 tUUsuIL1P4qxtu4eoA6wncoZcs/HFdk87tEKJ33ZpyPOzpbFqxooUgEqafZMc+YVLb2u/
	 ZlSc57mtUpJjtk2dA9NCT2iuyuVV7m6EZlTuHptJSmWDNrv7Bd+RMsGqilNrsjt7cDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E3chKhZV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABC5C606A31C;
	Thu, 19 Nov 2026 02:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E3chKhZV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DDB01F000C4;
	Thu, 19 Nov 2026 02:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055903;
	bh=QjcagNDdmvQI9oQjYfoATgWRZhRd/i9sUZ7Ke3Pg8Mk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E3chKhZVcknuVcJRugztyhEq1Oo05eiW6NHsrS3+S08NXntYpOcI3pZs157shRto6
	 xq53zl4TYoCW02C96myKyR3dwQl/1pchvcaS32nt5T7XjObi+45o8DAQtaWajAjwqf
	 vVhdHY/dM1kDyjP9NOpgmL1br9RrMpZlkZhX2V/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1797/2214] ASoC: rockchip: rockchip_i2s: Handle runtime PM resume failures in set_fmt
Date: Wed, 18 Nov 2026 15:57:53 +0100
Message-ID: <20261118150123.389127184@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 2880a05376469..b5183e311cbde 100644
--- a/sound/soc/rockchip/rockchip_i2s.c
+++ b/sound/soc/rockchip/rockchip_i2s.c
@@ -198,7 +198,9 @@ static int rockchip_i2s_set_fmt(struct snd_soc_dai *cpu_dai,
 	unsigned int mask = 0, val = 0;
 	int ret = 0;
 
-	pm_runtime_get_sync(cpu_dai->dev);
+	ret = pm_runtime_resume_and_get(cpu_dai->dev);
+	if (ret)
+		return ret;
 	mask = I2S_CKR_MSS_MASK;
 	switch (fmt & SND_SOC_DAIFMT_MASTER_MASK) {
 	case SND_SOC_DAIFMT_CBS_CFS:
-- 
2.53.0



