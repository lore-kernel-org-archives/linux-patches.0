Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061377;
	b=sWIYSS085aReTLwXqOfhry04/U65aY+892bUlMwS3tu5DfRoXexmmccQzUiBB/9jJtfA
	 4res3+jzzHN3W/+LtSRSt4BAuO60lrB1hPB2JKnGq5TyOH0ENGnyPPv2E/4wTymgSLeM2
	 fpXi55t96Nwxv+2+XFks2o+H2AfIo/DfQsUHU1NyvrIAgJ5yldmQm86hyJvmA92JkI5O8
	 k6jjGM1AgSwuW6kaJ1miV5bSpo0L8z2K1cOV4DoYYl0ccYlKwp/+3ZuE/wfpSCE+iJWNX
	 s9TPjUAXBZ6XIIpv5SO1bqBGtVabftzxbHUoeb0c+AKmQe0NZSBtROPs9+IVTAN4/Lw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061377;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SLFzbsgcx9Qk/jdgRHPZNOBQ7n1DrEsygdlFD2hJLRE=;
	b=QlJ/Zr+k8KNc/12GIgy00P1qPy7Q2irCyx19AZuAm4/VntUWUkaa4HFEX13iF0LL3iTg
	 Es6elQEl3G38jvofi+wOwvgDUSrnF5KK29bC6AfEIOe+GDqfAoBAZqjzKWICqec/JPDcf
	 PbEB5i3Zr6DdzImpYay6Upbl7gsoO/fXqfQPslofmKHJLjNdRkknGWL8AWTKWe//dBf6B
	 vyQodq8b2/Hy9rB1O+ExBV8nWcyyL1x4Es9rObw8XPs9w1M6juEzWX7yMTE5onzuxG8Cl
	 PpnQ2qOgOjjdOdvODZw1w8i7Cj8FiGyQYfS4CorVmbofMmhQchJLJr3sKpSrQUp0yiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dk09tf2z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDEBB606A32F;
	Thu, 19 Nov 2026 04:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dk09tf2z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22F911F000C4;
	Thu, 19 Nov 2026 04:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061377;
	bh=SLFzbsgcx9Qk/jdgRHPZNOBQ7n1DrEsygdlFD2hJLRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dk09tf2z/KBerdDbepZLjC77iblay8xQKw0I8ekkmMnI4AY05FW7QqSSGu7xcKaLm
	 1HLmuUMXttps/NVzxQB0oAvsXQgkI2gphE7+b7NDLiBixqrAI6uI0fA+ej2m+C7rhZ
	 EWHrMK099ptmEKaNZl6oNELm5/+0eT07IDJRuBD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1531/1848] ASoC: rockchip: rockchip_i2s: Handle runtime PM resume failures in set_fmt
Date: Wed, 18 Nov 2026 15:59:29 +0100
Message-ID: <20261118150023.474896308@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 785baf98f9da2..d1894d5b382d4 100644
--- a/sound/soc/rockchip/rockchip_i2s.c
+++ b/sound/soc/rockchip/rockchip_i2s.c
@@ -188,7 +188,9 @@ static int rockchip_i2s_set_fmt(struct snd_soc_dai *cpu_dai,
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



