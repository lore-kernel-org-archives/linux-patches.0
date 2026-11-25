Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618504;
	b=gmyjjETo3zZMIiu5GxzVMDGmAZXxRFsksqA2nfw3q6el0QP835aTU9leda8itGa+H2KO
	 CagfNb9CvfjsDuRZ8lpReXe7e97KMv6XKBl8gGAaFOI5Xau97lfxxtdh1jAQErbERMivY
	 lo/fitXzTMKWHFY482Ism/jeLocy8B9ciXTFQEgrBs7Cea0ioDh+S5a8PlkpWCDIgSoOy
	 fAZE6aJHAOQjZT74q+Lsoxzmqyiy+HCwScsqwAcVrui31mW4gg9TZ4JJNZWcgaLxNSjGV
	 zS+LIkqzaXg31wuC5lzh0YZcz9ctZViVGXs8Yz5ekVWRO4xTf+KjpC9p5TCvS3LtqQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618504;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gSRUwQfzKo292GX6RS5dgZLPF2blfGIYeoVFPvOCc7c=;
	b=GSJI6oTMMqTDLUkTWF58G97FCY1NUxYPwkA3ovP1icg6ObuT2FxMpvLd/8uR2OzkD/W2
	 STPGpAsJCdOjFtpQiugvnlj+A1TJd9Pq/zE/4l9HHkNp9E6NlJ2bx5lrhxN8HKCzUuqte
	 FiXUkp3z6z4CfMHn5nYKxQd2GDfmHNI3zVuqAx3oXDHzxvOlebo4RUw9JWfXZ9SPgih8e
	 rRvlg/2ibqjypm9nRRqWvmyXlCQOvrAOGEhLygbT6mc0FH2zmQ6qgVuXmh2e2jYsZtF9K
	 6K7DvvL13e4eo/NEVuCGnB0e95kjhwYn5CqPGSe/TEroPqrlAiIaER6dWbHQGbO9e9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kv2vFZI8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58376606A31E;
	Wed, 25 Nov 2026 14:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kv2vFZI8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A91981F000C4;
	Wed, 25 Nov 2026 14:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618504;
	bh=gSRUwQfzKo292GX6RS5dgZLPF2blfGIYeoVFPvOCc7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kv2vFZI8yZxFt2+0ut+zVuvLRIGAsranTnvFBYDPWEO6+ih5s1PPomoondcTMyRtx
	 jp0hGLE0EguCbPvSevhoDnDtfXz1Wq/Kq8gVGPHWAWrHwYaohT4P7PvJWbdftPjaDt
	 Ee9C82G46awgAKcUd42b732LibehV4Vg3BXzcezc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jude Gyimah <jude.gyimah87@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0264/1005] ASoC: rockchip_i2s_tdm: select REGMAP_MMIO
Date: Wed, 25 Nov 2026 15:26:42 +0100
Message-ID: <20261125143827.924149593@linuxfoundation.org>
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
index d7ec1fbe17a57..0f8ef68683568 100644
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



