Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214252;
	b=T4QjZZOSWmtFySKP0F3TJ2pwkLnhgyzQOR3Yvggfld+FzXsUfDziRfmdf1zvJ6hjRAQq
	 wnjT2TztG0/zrTgJCNUu5di5zg8ia9Maj4PbEOFbURW5/2i77cfVHu5t2Gdf9u75bP1vR
	 ux/GEurzr5pfdTYJ5mTShza1wfdmu6gIRHRZIzXzHziiq1e/39TWRMsJOmJ/NkWqBo/Kd
	 4kO5zBLLn1c2Rlm1O3Gd63ohPL0KVomSefU5BZ7gVXW2YzD/+jHma26kPp8dB3qIP68qW
	 naCNhAzTPK3VC1tmz9yetS096LPFtjXvzPAs6kpAxm3EeLzl3K1w8V+5NfsB8YVmN8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214252;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=d6ZT0vjC0nqD12SqDsMkXgiqYzjXY6fuY7/ecGpHciQ=;
	b=pZn3nM/31x2Zq2rXm8FWXUDI6KDjzxnlrG3pEhoT238Gs/04oc9piFyXBabzv1YAhlrj
	 /xULDlNcCG+LGfVTZolKaD0i0kE7jKB5eWvzNhAyPYiNNvy3xb8EGa+SNzjkxQDU/kivu
	 u7bnUo+5OJP0O4wtf6rFxTTvbW5GJA6VFcVNu3Hu6HTqQSfLpZ5eWCnydzjKj7vT9mIg/
	 vLy1qsW/B4uqZmqjdj9i2gkgvqmL0Cz47pzI22UVsvNbPAii0cAv/ab9P4dPjcH6Ifw98
	 CXHlGPDKsoEkjWyo8Mi4OpW9TbGq5FiEK18GWmTh8xkcXg6Fjz2oetUcMuk+w3PI7Dg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LvnsQkzg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81C18606A32F;
	Wed, 28 Oct 2026 19:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LvnsQkzg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C86241F01825;
	Wed, 28 Oct 2026 19:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214252;
	bh=d6ZT0vjC0nqD12SqDsMkXgiqYzjXY6fuY7/ecGpHciQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LvnsQkzg8WVZKVeZe1ZdiIWfyZKF1W0/LTGdKCZDvjE1l4diL8MdKpGTj1hGHWFBm
	 nZFL89/kYief3EPbN42sujF1GRPfQEd+hkjUVDFuWy+kcnLL+53pj33lwoTxlN4FpC
	 0ObzbA3tIoc0/VHtxQdlb1yWdcHgaf2wAqcZS/aU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luis de Arquer <luis.dearquer@inertim.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0792/1887] spi-rockchip: Fix register out of bounds access
Date: Wed, 28 Oct 2026 17:48:08 +0100
Message-ID: <20261028170517.456747440@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luis de Arquer <luis.dearquer@inertim.com>

[ Upstream commit 7a874e8b54ea21094f7fd2d428b164394c6cb316 ]

Do not write native chip select stuff for GPIO chip selects.
GPIOs can be numbered much higher than native CS.
Also, it makes no sense.

Signed-off-by: Luis de Arquer <luis.dearquer@inertim.com>
Link: https://patch.msgid.link/365ccddfba110549202b3520f4401a6a936e82a8.camel@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-rockchip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-rockchip.c b/drivers/spi/spi-rockchip.c
index c38d515e4399e..ccf6025229735 100644
--- a/drivers/spi/spi-rockchip.c
+++ b/drivers/spi/spi-rockchip.c
@@ -541,7 +541,7 @@ static int rockchip_spi_config(struct rockchip_spi *rs,
 	cr0 |= (spi->mode & 0x3U) << CR0_SCPH_OFFSET;
 	if (spi->mode & SPI_LSB_FIRST)
 		cr0 |= CR0_FBM_LSB << CR0_FBM_OFFSET;
-	if (spi->mode & SPI_CS_HIGH)
+	if ((spi->mode & SPI_CS_HIGH) && !spi->cs_gpiod)
 		cr0 |= BIT(spi->chip_select) << CR0_SOI_OFFSET;
 
 	if (xfer->rx_buf && xfer->tx_buf)
-- 
2.53.0



