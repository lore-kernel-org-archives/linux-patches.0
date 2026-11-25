Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621524;
	b=vLkelNviIZnJGISO2TrIPOp145ThEoGUwyG61Zln1m4xPMMtxwW8WyHPZaLYvRHC6b4s
	 4cbIKd9NZRbeVIjj6L3JvXFa0e2dpx2vhy3iyF9peYzIAXe+b8Uy8vKCvto/r7xk9aKQV
	 joMJYftPPNR3uoa4JRdEdN79n3DpkkV/SuIckDKfrcw1G07VjpgMwNd5waNND2jDea4E7
	 Ptw9CUfXnA6RJQele2cUQWJWb93Gz+HpOnberh5eR2AgYqG/RPdjA4FmFKByIj/A37gA4
	 /EOm/48+wSTvXIjC3JFeaRY4jMwR1jzcPkHvJeo1FlGoSKrhuSsxfqbzR5W7HzKDDvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621524;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WbE7BeSFN7RpY49bdzcJv6nfiHoMPGoa+3h2785ZMbA=;
	b=KMZGTUGSy40cSkW2FmDxebEa5z8ChPD0bC3qIiEAEdiTDbzmzNgXDlBbjqSVkLul0JVs
	 a730rp/NVsL7LesIU5TjXkk/cbpB5PECNv7ltt6GNTIgDGB+C7bmbms4aPUa3xOojAS4a
	 HfXxegoEPR4NIAqjJLf9r+bTyNQ9W4BD33fDdVAtL56hvfIfY4ymvz2jokKvlj8Lm8SAk
	 q/yL2V0b6DMtfKbxqHUijp5y9xRqtj612Dfpsxl5NEhoUNrzG1lOLGNShElZbdLTx+FVT
	 XAcX4b+Amj94qqOTtSiJrjXWKqKKLx33bkyB2VcUu3ozLQ3OfheiAenEepWdB0mcQtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ATHVLbha;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E18F4606A326;
	Wed, 25 Nov 2026 15:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ATHVLbha
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC1391F000D1;
	Wed, 25 Nov 2026 15:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621523;
	bh=WbE7BeSFN7RpY49bdzcJv6nfiHoMPGoa+3h2785ZMbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ATHVLbhar71uGv34IEK7NTImKeHc1O97ReN2cm4yzgYPqk6jf6j8g/3y8bY7owPBS
	 BO3FZtPNRt4hPqeJ86Jeadr63SPmjCc8frwgynSfH3fZh+IXa39dgqp6yAkrJYom82
	 EJ+w3tAIrKaxKgGifnu3HVLdfVl2BjkWCqueeR2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jude Gyimah <jude.gyimah87@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 250/990] ASoC: rockchip_spdif: select REGMAP_MMIO
Date: Wed, 25 Nov 2026 15:26:57 +0100
Message-ID: <20261125143827.946648762@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Jude Gyimah <jude.gyimah87@gmail.com>

[ Upstream commit 67a7e2073909e948c3cbd86c28d17e86c2958dd6 ]

rockchip_spdif calls __devm_regmap_init_mmio_clk, which
drivers/base/regmap/regmap-mmio.c provides under REGMAP_MMIO.

  rockchip_spdif.c:(.text+0xf67): undefined reference to
    `__devm_regmap_init_mmio_clk'

The driver can be built into vmlinux while REGMAP_MMIO is a module, in
which case the symbol is not there at link time.

Select rather than depend on: REGMAP_MMIO has no prompt of its own and is
only ever enabled by a select, so a depends on would leave
SND_SOC_ROCKCHIP_SPDIF unselectable.

Reproduced on v7.3, x86_64, with CONFIG_SND_SOC_ROCKCHIP_SPDIF=y and
CONFIG_REGMAP_MMIO=m.

Found with kreach, a static check that compares what Kconfig allows
against the symbols the compiled objects actually reference.

Fixes: f874b80e1571 ("ASoC: rockchip: Add rockchip SPDIF transceiver driver")
Signed-off-by: Jude Gyimah <jude.gyimah87@gmail.com>
Link: https://patch.msgid.link/20261103132537.3717496-6-jude.gyimah87@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/rockchip/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/rockchip/Kconfig b/sound/soc/rockchip/Kconfig
index aba9a518d3b26..0e5110125c140 100644
--- a/sound/soc/rockchip/Kconfig
+++ b/sound/soc/rockchip/Kconfig
@@ -45,6 +45,7 @@ config SND_SOC_ROCKCHIP_SAI
 
 config SND_SOC_ROCKCHIP_SPDIF
 	tristate "Rockchip SPDIF Device Driver"
+	select REGMAP_MMIO
 	select SND_PCM_IEC958
 	select SND_SOC_GENERIC_DMAENGINE_PCM
 	help
-- 
2.53.0



