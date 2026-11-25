Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618533;
	b=WqC+hwPhoplFZRvIvymtpjxlCQVlGpVDhzqSz4qXcc2BIYr0Uu9/E7qdD/0wv4h7Oy0z
	 st1K5CNIUCX2fAez/XbbrfVTnHdedj5oLe8S24Cu1VQJLZBf9yZGqlQaCvG22C9ViYk9T
	 a1jgzNH/3wRDhAs8amyjZOxJDXlPZhI4ZLYC99DerMF4G559U34zGYABR3YAvQb4Dx+dS
	 ymOeSExLpvHdNMvqjt/JkrdrOD6/R/CRIbDKHYa/X49QpbLQNqINzx/efTezZO76115Qf
	 vzY0SiFWO0OprGqsDPo+rh5kw374D9d+I1ALlhbCkER9NC7/ZENcnYg9fvCq9AOcs/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618533;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JMjSJtiTOdCistG1Y4RVwacr/NcFxYlECfkCCofEzgI=;
	b=dM1/OGvrioRsEpP8Zdk1i2V8Yy3mnRsr8DEV+F4XFT37s/sewDQzPfzlPNmXEYDFBdVU
	 YEwUomX10giDahsoKVMX5p9YidB7f8A8aRgsQIdf25CKZytJfm2Z757Dau8jhAU9VtaVS
	 sZXJ5ruDgmgL4M1IDPRBlo9Nb0rS27fSEMnq0Zk1JR8A/HjTy3dsrv/y7ghbULRzMUF7G
	 mm+sSsIIbg4/B35oM+sWJTWkJGrjgh7Atpu5j923g9bMHGPzehNe3KrK/UVcqkGEGixWB
	 fx9CPP7LcXce2/PSLaT068QmWIUnkoLpdOCFZsEYqPHWk8nWUGvmVUw6yxy5AxzUfCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G2FuzDAl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63517606A33C;
	Wed, 25 Nov 2026 14:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G2FuzDAl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81A631F000D3;
	Wed, 25 Nov 2026 14:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618533;
	bh=JMjSJtiTOdCistG1Y4RVwacr/NcFxYlECfkCCofEzgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G2FuzDAlKnv+XKvPo0mJlS5CBAOC3S2CSmCfgl4IejLYAOc/r2MSb4/FRdRkqc91f
	 pDhNFXp3XjEA2yjV84h64uHf13BlxIZIWRo13Kp6hOFhZxBmx97nAHdWFoKisMGRHQ
	 8t+f5JjYuDxvHcuuGDOVpCMITW5Q5625Tq/AMmM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jude Gyimah <jude.gyimah87@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0265/1005] ASoC: rockchip_pdm: select REGMAP_MMIO
Date: Wed, 25 Nov 2026 15:26:43 +0100
Message-ID: <20261125143827.946649162@linuxfoundation.org>
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

[ Upstream commit 420c7918a61b97b8cd99e402e7e5a857edb097ee ]

rockchip_pdm calls __devm_regmap_init_mmio_clk, which
drivers/base/regmap/regmap-mmio.c provides under REGMAP_MMIO.

  rockchip_pdm.c:(.text+0xef4): undefined reference to
    `__devm_regmap_init_mmio_clk'

The driver can be built into vmlinux while REGMAP_MMIO is a module, in
which case the symbol is not there at link time.

Select rather than depend on: REGMAP_MMIO has no prompt of its own and is
only ever enabled by a select, so a depends on would leave
SND_SOC_ROCKCHIP_PDM unselectable.

Reproduced on v7.3, x86_64, with CONFIG_SND_SOC_ROCKCHIP_PDM=y and
CONFIG_REGMAP_MMIO=m.

Found with kreach, a static check that compares what Kconfig allows
against the symbols the compiled objects actually reference.

Fixes: fc05a5b22253 ("ASoC: rockchip: add support for pdm controller")
Signed-off-by: Jude Gyimah <jude.gyimah87@gmail.com>
Link: https://patch.msgid.link/20261103132537.3717496-4-jude.gyimah87@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/rockchip/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/rockchip/Kconfig b/sound/soc/rockchip/Kconfig
index 0f8ef68683568..e0ded1fa4da5d 100644
--- a/sound/soc/rockchip/Kconfig
+++ b/sound/soc/rockchip/Kconfig
@@ -25,6 +25,7 @@ config SND_SOC_ROCKCHIP_I2S_TDM
 
 config SND_SOC_ROCKCHIP_PDM
 	tristate "Rockchip PDM Controller Driver"
+	select REGMAP_MMIO
 	select SND_SOC_GENERIC_DMAENGINE_PCM
 	select RATIONAL
 	help
-- 
2.53.0



