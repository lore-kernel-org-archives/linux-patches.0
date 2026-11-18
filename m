Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061607;
	b=Gx6Ga0/dCepJQjYN8nciGAjtk1NESAS+pr1ovpkF+lczcqCwLow3rLcL8pRXObIDJ99l
	 xvJJSkpN7YsacItGLt399E6AZe9t0Oa2Rjw8WmjECH2i7Itg665p29kir+MRALaRJfYC1
	 0SmbnsOH+Oc49xmVKojwNTUwwJJzFJDjndiAkEdwY8HWu5AsDutkkm8S5BBBIs9SSLBsc
	 fXMYz9EuyPk1GdUPH+yRkcOt3UFzRiKRz2A4zIAyRy1Tq8DUUnUHXB2PXVbesYPEVKKbS
	 rvBDEguT/DyIHFW12xtz5biAHZ2TKEp40j3sYZtaPbuNsuP94jC8jzJASc8OhnEAU2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061607;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zE1erYweEYTfu6mNM7reSgcVuNWJiFC7qnuS55WHBc0=;
	b=sCaDLhMw2iPlCmwt/OCkccCWozoe4TVXNMozlj+nTvbSKCj+EPz9APb1uVribAppgvwO
	 ioGe8bQCIAZWUZsGA2rQedlo2Q7jMMuF0o08l+kRJAL9SnPajfR5YDiDsjU1od3MZ/TQ3
	 l0usmTAYN+t+r/xh42ZdoRa01ck67F4IFm2KqMM9QMSICTX9iI241P37/5NXznNwSPVcJ
	 6yMw8VJPdRIvffBWKDh25fvpJfgLtau9IdKi/X34t0W5oC0Mv5xOArbRPg2E0/lPdmY+i
	 ZEU247vDYNyzAS6gkQXeyPf678DlNNNt7y2aB01rtPb6igSRrS2bQZ7MwosHwAkFoMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cZsN4VKt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 194D1606A33E;
	Thu, 19 Nov 2026 04:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cZsN4VKt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3221A1F000C4;
	Thu, 19 Nov 2026 04:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061606;
	bh=zE1erYweEYTfu6mNM7reSgcVuNWJiFC7qnuS55WHBc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cZsN4VKtDANBo/3y6xlgxpsX6hG9QMwoHFf0TVXd/qJPvaJG3p+F1chNDzHgq7A69
	 JY8nyTiTSSVHQ8A10FiDhW8o+VQaCcuCdFAwu+lLX8eU2YyaaRM4Nxv2IxdPvyKflh
	 6wlEs1nUsg/3tO3dvuKif4ZaNk1LeqQo8HL4zWPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1614/1848] ASoC: atmel-i2s: do not warn if muxclk is missing
Date: Wed, 18 Nov 2026 16:00:52 +0100
Message-ID: <20261118150027.104847970@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>

[ Upstream commit f4bf1f4d1385b7cb61a3fc811bb4912d49aa394a ]

Besides the fact that muxclk is optional, muxclk can be set using
assigned-clocks, removing the need to set it in driver. The warning is
thus unneeded, so we can transform it in a debug print, eventually to just
reflect that muxclk was not set by the driver.

Signed-off-by: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
Link: https://lore.kernel.org/r/20201103100554.1307190-1-codrin.ciubotariu@microchip.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: be952abd69c1 ("ASoC: atmel-i2s: use optional API for muxclk")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/atmel/atmel-i2s.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/atmel/atmel-i2s.c b/sound/soc/atmel/atmel-i2s.c
index d133bfeca496b..8f0d517b8facf 100644
--- a/sound/soc/atmel/atmel-i2s.c
+++ b/sound/soc/atmel/atmel-i2s.c
@@ -594,8 +594,8 @@ static int atmel_i2s_sama5d2_mck_init(struct atmel_i2s_dev *dev,
 		err = PTR_ERR(muxclk);
 		if (err == -EPROBE_DEFER)
 			return -EPROBE_DEFER;
-		dev_warn(dev->dev,
-			 "failed to get the I2S clock control: %d\n", err);
+		dev_dbg(dev->dev,
+			"failed to get the I2S clock control: %d\n", err);
 		return 0;
 	}
 
-- 
2.53.0



