Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019246;
	b=EyE2VDThFeBsui9yEG4w2WkUdx78LlVpwCy3atyGolDbiB2Cxgjf5Ew+ihWmdVTbZ+0/
	 OFJhSNFn4uZzt7xTcaBJ8b753i1NeAQN2HPY9nObad4dimhcWt3NLMQhKyCoobvqVWhOT
	 6ETDVAC89T2xhQyfAiCcBQXcoQBds0tGeq7UbZCidygyIpjoWSNa9UL8nSEKJTkZHdO4B
	 qkXIZltJGKXtrWi1Sw9kM6yt01sljTKn2ajv1f6tl/pI0a9Yau6M0pyyVJ401y5gWwznY
	 k/acFmvUC/iXAtdYyD8VBcaKLP0BKRfDu3RLrlFq83LS+8GhT1dQkFsFkCKWs3gfZgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019246;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EwRNr9sPu1BonthDpUSIqJGdrQgFegm2odsVPoyzYyA=;
	b=D+p1iG8AzvJ/jffd6Qhqlr9/TurpxTLt9ldzUrs8anJzAR2muhepb/96kCKMd6Hx8RVS
	 jB7KLHLs4IAs7oXWTlPV1am/JRocOmO5YzHe3HSWfx7qR4AfTmHVYIFWMu+l2va0OMYPl
	 uKi2gQ43Yl3vFN/rYVfjpAYjG3JdgnbI1Iym3pDGgHqusNEZGyHsZmBxxhDlr207lfWSv
	 iFgWBn3umbUbO1DSdcKvlpdn4fHHNnFLi2lBN4t2TlawSz+1TqzERvWZTpGolL/EpI6gn
	 Y4FI4lCIawh8+XPdBjAKhE7OvHRbypYg1Wf6cRis1E4wMGRtyfEPgW24+OhmebQY4pQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wqXFRZj4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F815606A338;
	Wed, 18 Nov 2026 16:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wqXFRZj4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D519D1F000C4;
	Wed, 18 Nov 2026 16:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019246;
	bh=EwRNr9sPu1BonthDpUSIqJGdrQgFegm2odsVPoyzYyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wqXFRZj4JaDw+vFNUay+Tl9DnxPyj8VL5hJuao1tXc38c2Ar54q4jagKtG1cmCkBt
	 /3qt5SLgH7B2/8z43Y6SqS3GiTyxhsysW7wlOKcmvzH1Z+HsW92fqRJ/4gZHvgas8a
	 3sFyR+7q9p/Rp6uTRW6H/54bNILBp1nlI0osw2Cs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1487/2651] ASoC: rockchip: rockchip_i2s: Handle runtime PM resume failures in set_fmt
Date: Wed, 18 Nov 2026 15:45:27 +0100
Message-ID: <20261118150341.551619713@linuxfoundation.org>
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
index 261f36d4c2fd4..e7ea71783e372 100644
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



