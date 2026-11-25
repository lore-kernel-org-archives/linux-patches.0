Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621511;
	b=IvCSyaG8rnuy1ZbE09TfnxKG531r8z55k/LpiktmHC7CWz+TyPz1V5mOlgrFtpU5ZPap
	 XyioO4JSFZwip1qghx5EYJnqyyRbIJOHBNW4AGVE5nAqthzoNPJaDxc+MNc6XxQpP3fXO
	 Iw7v36iktBheeTxvGdYAuDOgUDxdy9ryohgA2pdpNcXux9fZFlSUGIT12fdIw3VeoK7m4
	 TVwi3QWGAroB6PYXTIo1+9UVnVmau8diCskQN9ld8tqHQl47l5fhVdwmwOUnvq+BmZCRl
	 Th6LKbPsHD52eHJXWbaOKe10IxaRqti3gJHgjrsQxKFji3l8nTi5/U+pXTLhfkN3/4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621511;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cOUX6RtkzM+e507ETTDeuzRpk4zti2ABl1TC5J3DYPQ=;
	b=RnfJW8+CXpVLSh3cvJzqLPckM+aAEOJBD8sWgZZphvJiZapXwMWIxOmAv2TXYtvELKr5
	 iCtBhcG3rdlmsfWVPnKAXOsvUmnUCJaM86EE14JGoAN1eDD7EEnWbxITh6jq4k4DelMZB
	 5+akjVSps4aw2RMKjbKXft0soPoU0npru27n352cVXQ+QINszocrNyQK0yCG/3FGzYu2h
	 xtdDhGs7ztEFSMDoixmYbnWYt+GpzDCV3fRQYh/mZhiTU+RUMOYISPKBAbbKw5e1QLjuN
	 XcDNxq2FXoB4VRYxNgweY/gGsTUYzixOZhv/ZTrn59lzu2zDArXx3ikRkU0nX2mtoZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tnKXbeHo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3F10606A326;
	Wed, 25 Nov 2026 15:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tnKXbeHo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94FB01F000C6;
	Wed, 25 Nov 2026 15:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621511;
	bh=cOUX6RtkzM+e507ETTDeuzRpk4zti2ABl1TC5J3DYPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tnKXbeHoWHmL5N/lWRYge20+92uqznCYXp49Yoryh6t8dTAaXnDO7niTplN69xGFw
	 +dRoes1EkeBLN3rFJA+CSNVG/A/oSPySGN6uAkzqvf/AeFNYv5u7Ych/V/cU6j9xAr
	 1XKzUQiTYH+NS/ovpL8rU58k8w8IItxB/hNHXIWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jude Gyimah <jude.gyimah87@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 246/990] ASoC: rockchip_sai: select REGMAP_MMIO
Date: Wed, 25 Nov 2026 15:26:53 +0100
Message-ID: <20261125143827.852880341@linuxfoundation.org>
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
index e96d1a95bb10c..625390ee4ad6f 100644
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



