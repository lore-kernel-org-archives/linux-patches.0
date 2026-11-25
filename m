Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621502;
	b=wv12v/UYG7BSNc8+myxVS3+58MKI3Db2fWDP7owTuC5xbbcSk5lSIf0Kt78UUJv+FvZd
	 Xn/rvgeQYMvvAggkxoZ5/cRmvT30Rk6mccz3Sq4+pwT5JuTFWeNxbkB0y2ZxenMVnfd1x
	 UayMpryU8LTiSNu/osqbWQji1wvLdlllL+o/VW/CATGcE3mXy10baodNehPSX53vJcUII
	 MQ6VmMqjHE3UVs407V9u33zqvZledEFPnDYz0puR8OxNwWh8BRGqfYJgcl2/l9NDK9a3d
	 /lYH2TLey4ZGePYo6phIIVwVA2l9JTXM9hf31KjZYLOurkCVtYv7WHxdTSjmCeuVGqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621502;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3s4G+OHnDrxjN+LrF0hMgjt+mTmwyCdisrSo207qHnw=;
	b=tMaErCWRlknsQF4OSeNQikGnOR5deLGMjLBw5edF6iQxFcgADqDxlkpWScZH7Ogko89e
	 i5VzWilwdbYcDRoIQv88W59b0UM29nZC5gUlOyEC0veg9IhOqtkw8mgu+cuzEc1jJL9E4
	 Xxs8X2eM7EOgnayi7C/L5HYhtdBqGDRTnIUmKEzOndMjwGSM/H5HQkt8XjnxX2HtMAxn5
	 jTIC8s2ltOQVRu3nqbuvgYuMbN8K0viXYZ3yXUD0d01trhShdI2hKregoO309BLXDYPyh
	 Ck+RP4us667uyt1MlJW6TBExN6tMsaAlQa0cQobO3YPOnMOch/HjlQ2Wq7DvV6Ee8pA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mUx8hdfP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CB31606A321;
	Wed, 25 Nov 2026 15:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mUx8hdfP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 117161F000C4;
	Wed, 25 Nov 2026 15:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621501;
	bh=3s4G+OHnDrxjN+LrF0hMgjt+mTmwyCdisrSo207qHnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mUx8hdfPrfwKhg8Nmpu/n3XiHiU9lzjBkkP7xzwyMDg0bkstxCSby6TGZI8DtMJiX
	 Nuc71z2FgSh7h4ICm7/OcTPlxhdDfx2IuBQSk99nOTcvTdEPH9aKLj3eSNSTVetCZE
	 QJSPgVHEhiOF9SM9ZL0iOj4ICh35tXEa8fI/z/cM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jude Gyimah <jude.gyimah87@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 244/990] ASoC: rockchip_i2s_tdm: select REGMAP_MMIO
Date: Wed, 25 Nov 2026 15:26:51 +0100
Message-ID: <20261125143827.805703868@linuxfoundation.org>
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

[ Upstream commit b8284f2b73f8de157be52b48d9968645f4ad6f7c ]

rockchip_i2s_tdm calls __devm_regmap_init_mmio_clk, which
drivers/base/regmap/regmap-mmio.c provides under REGMAP_MMIO.

  rockchip_i2s_tdm.c:1304:(.text+0x14b1b6): undefined reference to
    `__devm_regmap_init_mmio_clk'

The driver can be built into vmlinux while REGMAP_MMIO is a module, in
which case the symbol is not there at link time.

Select rather than depend on: REGMAP_MMIO has no prompt of its own and is
only ever enabled by a select, so a depends on would leave
SND_SOC_ROCKCHIP_I2S_TDM unselectable.

Reproduced on v7.3, x86_64, with CONFIG_SND_SOC_ROCKCHIP_I2S_TDM=y and
CONFIG_REGMAP_MMIO=m.

Found with kreach, a static check that compares what Kconfig allows
against the symbols the compiled objects actually reference.

Fixes: 081068fd6414 ("ASoC: rockchip: add support for i2s-tdm controller")
Signed-off-by: Jude Gyimah <jude.gyimah87@gmail.com>
Link: https://patch.msgid.link/20261103132537.3717496-3-jude.gyimah87@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/rockchip/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/rockchip/Kconfig b/sound/soc/rockchip/Kconfig
index e09325aaba534..4df880cc4b319 100644
--- a/sound/soc/rockchip/Kconfig
+++ b/sound/soc/rockchip/Kconfig
@@ -14,6 +14,7 @@ config SND_SOC_ROCKCHIP_I2S
 
 config SND_SOC_ROCKCHIP_I2S_TDM
 	tristate "Rockchip I2S/TDM Device Driver"
+	select REGMAP_MMIO
 	select SND_SOC_GENERIC_DMAENGINE_PCM
 	help
 	  Say Y or M if you want to add support for the I2S/TDM driver for
-- 
2.53.0



