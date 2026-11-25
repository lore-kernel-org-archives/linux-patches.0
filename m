Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618536;
	b=AV7BbZj0I3vswJYwfwrFHrVuPO+SFpzFEO41Cv/iDlFarTuTT0cLEH85LrPaxQkigb95
	 Tc4OeVi5DtpRw+rz1nwvbSWMpXOoCfHW508O5iC+C7YFQiFhr8UoFgqiI5lzwbAO0Jdvb
	 j6qfqaVL1v0vV5CTE4xREpbXgwupLfLqYuTnw3b6ZzVyNT0c+VIJo+a14NIwIvlmHmoQv
	 yXDs12HnuQnXCeCyEct9iXiK6qVpLd8IVUZt3VHXFIPFn+HV3uW8ZgTB7qDoPBGryuaoO
	 BKgnpwtCzczgh4OOEWLELsv8jxUMTEh+VZlIPQJj3afVphkGLrMXsgF96zKmmrqQMaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618536;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UcY15JrQOWiFCx51xt+/z7hm4Nu8xm79gMonjsaAuv8=;
	b=0SZpZOs2iGgyZVr1SdQvFRsALISBx7kGFcXebXgc1x/qI5N+NpHDvHu3w8MqGPx485uE
	 rB1QnWD7NHwM5s6Sgpby7jpxHjZQFmPV/PXlwTprMPnj0fjwj6L9nPPukPvFHULFr0ezu
	 AxhPqA1HXC0QniFQjnf3X3/+HlVjjAcBljR+G9ETtffRcusbGqGfTpGUhdNLTCo3G0kBj
	 dT3CDPiYL5hyxnt9kyhYv9CrHrFQBQwvXbR4qvK0gF7TbqbABLu5teKB4TGLLSk3i57Xo
	 09elN46ofUGGFK9Hin2L4j4R0rlYB8quBpQKLwoFD/968r1koBQqBh5BVHcJfvJDk7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZJiMYPc2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A84E3606A33F;
	Wed, 25 Nov 2026 14:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZJiMYPc2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4AB21F000EC;
	Wed, 25 Nov 2026 14:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618536;
	bh=UcY15JrQOWiFCx51xt+/z7hm4Nu8xm79gMonjsaAuv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZJiMYPc2RediQ/8hEQWdrWocOixOTaSpgbDXUrE0VnaG77T4Tw27UUEo/666F6go4
	 1nTRZS2sr7t29vfh4UZpSGoqoV5EEdytGLA48MVZVxqFPCGkwIK4zW6hSd4CcW2Mw6
	 i9g5uVhiOjKbfG0L8gxjdFh1KPzLiyVJjJVpqhF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jude Gyimah <jude.gyimah87@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0266/1005] ASoC: rockchip_sai: select REGMAP_MMIO
Date: Wed, 25 Nov 2026 15:26:44 +0100
Message-ID: <20261125143827.970290484@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Jude Gyimah <jude.gyimah87@gmail.com>

[ Upstream commit 829904994e7a54fa89cf550e50dbcd58a09602eb ]

rockchip_sai calls __devm_regmap_init_mmio_clk, which
drivers/base/regmap/regmap-mmio.c provides under REGMAP_MMIO.

  rockchip_sai.c:1424:(.text+0x153060): undefined reference to
    `__devm_regmap_init_mmio_clk'

The driver can be built into vmlinux while REGMAP_MMIO is a module, in
which case the symbol is not there at link time.

Select rather than depend on: REGMAP_MMIO has no prompt of its own and is
only ever enabled by a select, so a depends on would leave
SND_SOC_ROCKCHIP_SAI unselectable.

Reproduced on v7.3, x86_64, with CONFIG_SND_SOC_ROCKCHIP_SAI=y and
CONFIG_REGMAP_MMIO=m.

Found with kreach, a static check that compares what Kconfig allows
against the symbols the compiled objects actually reference.

Fixes: cc78d1eaabad ("ASoC: rockchip: add Serial Audio Interface (SAI) driver")
Signed-off-by: Jude Gyimah <jude.gyimah87@gmail.com>
Link: https://patch.msgid.link/20261103132537.3717496-5-jude.gyimah87@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/rockchip/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/rockchip/Kconfig b/sound/soc/rockchip/Kconfig
index e0ded1fa4da5d..aba9a518d3b26 100644
--- a/sound/soc/rockchip/Kconfig
+++ b/sound/soc/rockchip/Kconfig
@@ -35,6 +35,7 @@ config SND_SOC_ROCKCHIP_PDM
 
 config SND_SOC_ROCKCHIP_SAI
 	tristate "Rockchip SAI Controller Driver"
+	select REGMAP_MMIO
 	select SND_SOC_GENERIC_DMAENGINE_PCM
 	help
 	  Say Y or M if you want to add support for the Rockchip Serial Audio
-- 
2.53.0



