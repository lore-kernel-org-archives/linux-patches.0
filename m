Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618540;
	b=zQysJpeuC7Ma6zI1zaAx90pWR/BSJe4ckjKImbMM0Jx8+iKi3/bYA3dPHHK4HlIFs2EQ
	 OtaNUYIYd6NCbPb+92jH9bGnziieA6LjcQs2Byx1A7vumJortIyRm/GgcmWU6eye5AGuz
	 feeY8b3GsORXl4X8pAo662ciYLS6bDqozKQyBastd0UVNUwfK/iM8/zaFVWo3IZmHnyNz
	 JuV/xikuSx2yl/R4D7UdEGK4MSJ520sZC3rlA3KEV5Lm+2tdPtgI5aZf/MAILIckdinZv
	 GaC2oZZJ8pLVXcXToCro63CH09hOBdTNzohnEIv3940ZwRzlkPmpKW5Z26iiVwEuHXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618540;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=P6tZJvAUl1CEfSvP0fLCbLgqoEFhbVleO2oGdhc8K40=;
	b=LSIj0lR8SYn+YDUw2oIW6DCPKQbopXUW0Mt3f+bLXDdLFQ3J5fAMzC1FVMRzrgowgF7l
	 s91eTK6/vA95A9/ZsFHKJ1e/JmiWvDd1PFHHtnbb2GBX5JEnB8acfIXrDQy2BkmpXYx3b
	 ilTMYsv1W4zm9JJXsZ48ChD4aNcZOO3GKHvg85x0M7/deqdNdAu22OwV/6ygca/gtQjDe
	 m5YbeK5oX12kS5G0kmXZ1Y4r0EF/z2/dy18dednmU3STdw5L2CYsiIhHvkOQ0c/lxgZxw
	 f989fhezXSPwYtn0eNPGpVB/zfJfA/l1AiSRgH8R07eWSFEOU7mtEuGRdfSyfH7xD4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AQAp1aRE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5827D606A335;
	Wed, 25 Nov 2026 14:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AQAp1aRE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C6841F000CF;
	Wed, 25 Nov 2026 14:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618539;
	bh=P6tZJvAUl1CEfSvP0fLCbLgqoEFhbVleO2oGdhc8K40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AQAp1aRE8ChR0ZDXI/Xx2ZUAkDEO6cgflSnt06mQmmJeD53a3HRYqmY5K2zp2q7Fh
	 +efP0/vkLCcD6zJUQw+hE6A/XmDdFlcWTQFcBo9APLtj7i0mST8S376TiXDxlV8700
	 txTX2B694t8MFvoOKLQblFTH976gtyxv/SzfXDuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jude Gyimah <jude.gyimah87@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0267/1005] ASoC: rockchip_spdif: select REGMAP_MMIO
Date: Wed, 25 Nov 2026 15:26:45 +0100
Message-ID: <20261125143827.994111404@linuxfoundation.org>
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



