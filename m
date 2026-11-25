Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621505;
	b=5SvRIGYVewT+MIgyIsnZJ3k4U+7gj4uRkkmYVoExOxeiDSLfgSIXRWxsUfxUw+mkv44K
	 I6FrX4eenxNg34pDahOUn6fpYK51MuJgLf4Ha0q35t5kcZOunrKhfwHlQMWFIdyHjLe+U
	 SMFDyktasjhzsmVWRAhMc/2uFbEUdyqsk9wwvv4P6DrBRhkbiQKpY8/3nqAJ/m+GyA+xj
	 eGZ3gg0z/rkI6rB9fvMJBq4USOWTm/yxk7ICJD+ov24VOE/Vd+RV1S+LEQiyoB0RllBod
	 Mll99Fptp3ii5HuKui1J8meJE7kOFFbmSaIY0ENf3NMnKldusa0JQcHGttsYZ6EAm6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621505;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eWORu4u62JvTamPKjAx4Ji2rhiLyTxCHiQ435i+y21A=;
	b=3EEqGWjyhdykKxVt716C8ML6+TltAR/7yphU6V1G30mD/IpTtR5FZ8NN7+qvPecHOgsX
	 QZcGIqXMwaSIpt7OCrWOh4Qzbg8UPa0YgyaxYWMRyvE8WuqMD58mK7Mgzl4vXQVFNHISd
	 k7SnUTXWtc4tDSVNtqCyZR5WZGMAqMG6QAbzpC/DastHoyonkZOjqbu5r6p3aF0hEV6x4
	 wXEk+L5ijhioie6KM2nKkmGoBXQyNiLs+i2sMauuio564u4VWOTs2YReH6W5drR5nDzWh
	 JabKxS2RWME8uuX6V1e/70PJNI5Sb9pQoS8XoxYOQjVhxmXcSDtCkwO6EoUGl2ccv2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZZ+UEWzt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86D0C606A329;
	Wed, 25 Nov 2026 15:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZZ+UEWzt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 255F71F000C4;
	Wed, 25 Nov 2026 15:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621504;
	bh=eWORu4u62JvTamPKjAx4Ji2rhiLyTxCHiQ435i+y21A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZZ+UEWztohmCqBVDDg2mRvTS99uZUqgrtiOY7QoVLGNpzH1a12whu0hjikSa8Xhfn
	 cTK30SCJK2w7rUmpBcRRr2rOsOdsuSSxZghQYZKpO8xvsJs9ipO/+HaMC9OwxOjYPx
	 04Jm6VFeqttXviL3HHNsTn1tpWOU0V9XsqAEobzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jude Gyimah <jude.gyimah87@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 245/990] ASoC: rockchip_pdm: select REGMAP_MMIO
Date: Wed, 25 Nov 2026 15:26:52 +0100
Message-ID: <20261125143827.828967873@linuxfoundation.org>
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
index 4df880cc4b319..e96d1a95bb10c 100644
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



