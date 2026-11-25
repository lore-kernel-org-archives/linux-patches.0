Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618470;
	b=Xn44Ml02vENHEsHrivFCDZmiES1w5Z+iqBql9xMv9r12aS/AjAAUVc8Em+KU0WLyl6RZ
	 16NuMRYwK7n9zxx256tPcFA/TIosQl9boNDoEmiwvoYnGOFFLDqEvMr05C5GYq2fTFbWZ
	 UDi8NoJVn3cRkKbfPYwQPmg1HLdKsMfHV7CeAeWgdMt4LtdfjdmM2tpy0I5FlCa49fo+v
	 UFBmWDPT6VaCW3ziNX5dbqtwuTRD5IDSKg3bVgtDHkAjH5fNEO0jpl5DOls1mWHSilrYq
	 ixPmxV2qpf9YLoBzQkjVD71pr16d4iZD9W/Vxf43UdjpejHjVkQtCaTw/57PXktJTvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618470;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uLgp6FG4sJomUdtObuBybUVpY+ojkovYYnOmbmIvRVw=;
	b=nWZm/nCWui28YyTgsZazblKW+6LYe0wkfzGGOkxPjqJ3ioBSq9f80N4vKwzr64+BHWsT
	 zt1X4q/dsrQ8Ot7xs1EmVdI0TIWAPXticxOy8fIGMExkzHtPnn8oLvV84RTGlSk0UQaoH
	 4akQbw9oK08QKHd/pbypkjNYruTPcwUvG2rRjp9KY6VCh67bsT4vMhYeyP6FzKi4j/NQD
	 hilIWITKg2XY4X3aUbEmWX5DqtO9FN72SASuxMHWEIxntXyCS5eJ/K0x22WolkGXy9I3B
	 BLJrD1OUnq5DSjvc7qmbScfeEw+ScaOROXTj1hCWg5wB2/nzlHbmBvUJwAvBAUnRgxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="lsy/9MOj";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36469606A33B;
	Wed, 25 Nov 2026 14:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lsy/9MOj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DDA01F000ED;
	Wed, 25 Nov 2026 14:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618470;
	bh=uLgp6FG4sJomUdtObuBybUVpY+ojkovYYnOmbmIvRVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lsy/9MOj5qwXWHx1J98VpARXa4sC6TZSWOBQD17ohkXo+gB0P7QOyobp+b+uYhqDV
	 IkYuh+LT4oA8jsg6TBMkep9xkv/zavIz1Hs2r+lMtsZFG77Z6Pxt4V52pgH37UVYMa
	 /BlRnsvs/RYWLNJiTYU2aGLaZ6MJwr6mYoczM7+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jude Gyimah <jude.gyimah87@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0263/1005] ASoC: rockchip_i2s: select REGMAP_MMIO
Date: Wed, 25 Nov 2026 15:26:41 +0100
Message-ID: <20261125143827.899303405@linuxfoundation.org>
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

[ Upstream commit 1c57404bf9bad3e05d5686d91c208bf4e2b733d8 ]

rockchip_i2s calls __devm_regmap_init_mmio_clk, which
drivers/base/regmap/regmap-mmio.c provides under REGMAP_MMIO.

  rockchip_i2s.c:(.text+0x418): undefined reference to
    `__devm_regmap_init_mmio_clk'

The driver can be built into vmlinux while REGMAP_MMIO is a module, in
which case the symbol is not there at link time.

Select rather than depend on: REGMAP_MMIO has no prompt of its own and is
only ever enabled by a select, so a depends on would leave
SND_SOC_ROCKCHIP_I2S unselectable.

Reproduced on v7.3, x86_64, with CONFIG_SND_SOC_ROCKCHIP_I2S=y and
CONFIG_REGMAP_MMIO=m.

Found with kreach, a static check that compares what Kconfig allows
against the symbols the compiled objects actually reference.

Fixes: 4495c89fcf26 ("ASoC: add driver for Rockchip RK3xxx I2S controller")
Signed-off-by: Jude Gyimah <jude.gyimah87@gmail.com>
Link: https://patch.msgid.link/20261103132537.3717496-2-jude.gyimah87@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/rockchip/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/rockchip/Kconfig b/sound/soc/rockchip/Kconfig
index 391ce2225fde0..d7ec1fbe17a57 100644
--- a/sound/soc/rockchip/Kconfig
+++ b/sound/soc/rockchip/Kconfig
@@ -5,6 +5,7 @@ menu "Rockchip"
 
 config SND_SOC_ROCKCHIP_I2S
 	tristate "Rockchip I2S Device Driver"
+	select REGMAP_MMIO
 	select SND_SOC_GENERIC_DMAENGINE_PCM
 	help
 	  Say Y or M if you want to add support for I2S driver for
-- 
2.53.0



