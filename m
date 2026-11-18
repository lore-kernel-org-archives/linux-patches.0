Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035782;
	b=E/CVRkm4uJ5zOtWzWnBjFytEs75nuBqzJWpfyHceTR4PNK9WSWfxDYTpmU3qOYV7yTms
	 Erwg96nRft6V3tIlY+t/oaYmAZD8RUlVXlMtv/eHTqVic6X7Sf8A8Y3fA8TUsfd40lxaR
	 wvGJ23raprWJaoyexfWtmp7NjUttnT4G4BEbr8IY19vNaLUKaX0VEeCkBtUDAkRCNWpl8
	 WCqzzx8rO+qRvuHxZpyOcKpiCXwKn+1ONX60XiyLlRgoRagMKj0uwWl8EwyIAsVaZss2w
	 syNVcEjVUhcPltbqk88YeZwOUafJqtcmTkx/MkIFW/G2/J7spGap9Uluttw50eiOVGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035782;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gr2BUQkbb1+t+0T0WPfCTqCrP4oDKIhhncSOPeBkW6Y=;
	b=TvAfL3zJEVl0t910l4kad0dqoVS8rgEWe6R/MPg02QXKLxgNxUh6l2K/grEw9V4tUB0f
	 XaVVA1wCgy+Oai3dD5Sjeni2Or5/YDCJDjVQgt8LZ99Y6pJZ3bUkDmDIqYHYDow3msJ0N
	 cND+trWKzHNUTge/8qpO3wd3/rjT2rhWfh0chFXdBc+jKZITKeMxB8ejEGiGYl2x42811
	 on27stSSNe8Z7xU/BsUF7HvF4u11TPLia8SQD6GcN0KgNKetLN05UyLV0oXztbeLtyHS8
	 CLRvvYohyqsQgut/dCw1qy+GuP2XMAcC2YEyYtYNBliqMMMY81NF0iosQCKLzn4xuQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YtHsb9UZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28DC2606A31C;
	Wed, 18 Nov 2026 21:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YtHsb9UZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79ED81F000C4;
	Wed, 18 Nov 2026 21:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035782;
	bh=gr2BUQkbb1+t+0T0WPfCTqCrP4oDKIhhncSOPeBkW6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YtHsb9UZ2MdQlDNAzEcDHQywOZ2J/bBwET55CYMuKl6u5UjuSakPmch2LUGOCeCaX
	 Hep4oxo57XR8rElpP+lrQl2eEmcCY2nYoj2FXQXLnrwkrJMoCKVCggI5PYb6Uln4Ec
	 0+kcInmzMMqtmAPaFkhShMqGAEVzZZeLiT6nN9BU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Michael Walle <mwalle@kernel.org>,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0824/3318] mtd: spi-nor: Unprepare legacy controllers upon RWW wait interruption
Date: Wed, 18 Nov 2026 15:24:06 +0100
Message-ID: <20261118150343.790899184@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit f594a33f9721f08facd98d0a31adc14ff6da9d70 ]

All the parallel locking helpers (spi_nor_prep_and_lock(),
spi_nor_prep_and_lock_pe() and spi_nor_prep_and_lock_rd()) call
spi_nor_prep() then wait with a killable sleep. If the sleep gets
killed, we leave the controller in its prepared state.

Call ->unprepare() in these cases.

Fixes: 74df43b3f626 ("mtd: spi-nor: Enhance locking to support reads while writes")
Cc: stable@vger.kernel.org
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Reviewed-by: Michael Walle <mwalle@kernel.org>
Acked-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Signed-off-by: Michael Walle <mwalle@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/spi-nor/core.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/mtd/spi-nor/core.c b/drivers/mtd/spi-nor/core.c
index 6f8a9c6253205..6fecfaadd2a64 100644
--- a/drivers/mtd/spi-nor/core.c
+++ b/drivers/mtd/spi-nor/core.c
@@ -1284,6 +1284,9 @@ int spi_nor_prep_and_lock(struct spi_nor *nor)
 		ret = wait_event_killable(nor->rww.wait,
 					  spi_nor_rww_start_exclusive(nor));
 
+	if (ret)
+		spi_nor_unprep(nor);
+
 	return ret;
 }
 
@@ -1361,6 +1364,9 @@ static int spi_nor_prep_and_lock_pe(struct spi_nor *nor, loff_t start, size_t le
 		ret = wait_event_killable(nor->rww.wait,
 					  spi_nor_rww_start_pe(nor, start, len));
 
+	if (ret)
+		spi_nor_unprep(nor);
+
 	return ret;
 }
 
@@ -1440,6 +1446,9 @@ static int spi_nor_prep_and_lock_rd(struct spi_nor *nor, loff_t start, size_t le
 		ret = wait_event_killable(nor->rww.wait,
 					  spi_nor_rww_start_rd(nor, start, len));
 
+	if (ret)
+		spi_nor_unprep(nor);
+
 	return ret;
 }
 
-- 
2.53.0



