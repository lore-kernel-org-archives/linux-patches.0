Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 886E27C6E9;
	Wed, 21 Feb 2024 14:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524954; cv=none; b=EnVVlSCgGK3FIshlOk3RnSb3TdxnpFn5/eg3kXXX8W5AZ9U78JD4uCLRsgZQ0p5NDxU8kLsqlL5yKb+LNmGv9smq+sxmpm45fApcTFWkmKoSR8JMv0gNuzXgL6ETwYsdeQguYUWST43vQ74ZuAZDVkCsyzQAWyMTzArNEqEjPWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524954; c=relaxed/simple;
	bh=c/BjF3T+yrK6ezmNPoH/FM6dwO9HTFKPG5nm7fMRSAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xv1/oPQATTzYlknDEVOf05kfkpHpJBNfFBVou0qaq+Ay8HutS6BERU9sPXp0LHyrztBN6+l0s5BRHAP3qanrTP3Sb4IOUv0EldDdQ2Z3/EiDPE2DOnrAsSC4t/Ks6h1hJFYCb775cfgGMp6slzjNFBcnrqi6qLDHqp4rTpBk078=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zU/rl8xc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zU/rl8xc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9E5DC433C7;
	Wed, 21 Feb 2024 14:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524954;
	bh=c/BjF3T+yrK6ezmNPoH/FM6dwO9HTFKPG5nm7fMRSAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zU/rl8xcQeIvClI8QhAG/Fxo06ygobUL2YDBIIcOgbiTc1C/ghhuJbaK53smGRRnJ
	 6VBg5i/WbQNUMp0Guj/v48iWLlLxrI6Vp27hijtfUFrBPx2ZlNkGNJszNjNMl0Ixie
	 ly2aBj8Zqw32MHIP3jNNiNBtyYQMSpGRD7OtF90A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 007/267] spi: introduce SPI_MODE_X_MASK macro
Date: Wed, 21 Feb 2024 14:05:48 +0100
Message-ID: <20240221125940.296120342@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleksij Rempel <o.rempel@pengutronix.de>

[ Upstream commit 029b42d8519cef70c4fb5fcaccd08f1053ed2bf0 ]

Provide a macro to filter all SPI_MODE_0,1,2,3 mode in one run.

The latest SPI framework will parse the devicetree in following call
sequence: of_register_spi_device() -> of_spi_parse_dt()
So, driver do not need to pars the devicetree and will get prepared
flags in the probe.

On one hand it is good far most drivers. On other hand some drivers need to
filter flags provide by SPI framework and apply know to work flags. This drivers
may use SPI_MODE_X_MASK to filter MODE flags and set own, known flags:
  spi->flags &= ~SPI_MODE_X_MASK;
  spi->flags |= SPI_MODE_0;

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://lore.kernel.org/r/20201027095724.18654-2-o.rempel@pengutronix.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 6d710b769c1f ("serial: sc16is7xx: add check for unsupported SPI modes during probe")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/spi/spi.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/spi/spi.h b/include/linux/spi/spi.h
index 7067f85cef0b..ca39b33105bd 100644
--- a/include/linux/spi/spi.h
+++ b/include/linux/spi/spi.h
@@ -152,6 +152,7 @@ struct spi_device {
 #define	SPI_MODE_1	(0|SPI_CPHA)
 #define	SPI_MODE_2	(SPI_CPOL|0)
 #define	SPI_MODE_3	(SPI_CPOL|SPI_CPHA)
+#define	SPI_MODE_X_MASK	(SPI_CPOL|SPI_CPHA)
 #define	SPI_CS_HIGH	0x04			/* chipselect active high? */
 #define	SPI_LSB_FIRST	0x08			/* per-word bits-on-wire */
 #define	SPI_3WIRE	0x10			/* SI/SO signals shared */
-- 
2.43.0



