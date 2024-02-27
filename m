Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18B5013B2B4;
	Tue, 27 Feb 2024 14:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043346; cv=none; b=nhZ1FA9ugcHj3AwiVctzN/H6/hGrwoJu8sWVkIzlJv6/xr+RW5YP3bnXbO63XZYIniCFjWE6eRiMO8DyxTgemMKTKusJKALbCnGqawjA9uhaW3Tb12TXWYnnYvq5LZf75vnPpDTbfGdrYWuZK6jQg11t83/TWwIHcWWN8aQgRcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043346; c=relaxed/simple;
	bh=G/rxBysktIPP9tXZiOIlf2oYoro+3VKR7DgzKdtB0A4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZzRQRADzzmcCP26P9vNdn2FYJbGvj/BlUEbmlCGYqibR31mUFOLYDQydCA/5NsM+Fqt5gou9gPV49ywHxGa0WH4NeTgJdS5+SxHpQENvd0eAnmEs5Sdd+lhh12LGO/EtleYrFBoZBrRUv+SJWEro9upc7+y6AfarKlic8YSU6Bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lPPJugLh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lPPJugLh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93455C433F1;
	Tue, 27 Feb 2024 14:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043345;
	bh=G/rxBysktIPP9tXZiOIlf2oYoro+3VKR7DgzKdtB0A4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lPPJugLhXczFeu7MACqZdoUmIgvtg7o3NgG3OMM/vnzTu/KzQrw57oGBkgerkmXbM
	 SvyJ4KULSr7A6KNjCkMj1SxXjooM5M7rKy+DnZ3gRvHXO9RDF2e5prAieH4B9ahGmf
	 s0xAN+Vm+yhVRYcreVF+o8XUHGKIoGIDQRoVEU88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 036/195] spi: sh-msiof: avoid integer overflow in constants
Date: Tue, 27 Feb 2024 14:24:57 +0100
Message-ID: <20240227131611.583538232@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit 6500ad28fd5d67d5ca0fee9da73c463090842440 ]

cppcheck rightfully warned:

 drivers/spi/spi-sh-msiof.c:792:28: warning: Signed integer overflow for expression '7<<29'. [integerOverflow]
 sh_msiof_write(p, SIFCTR, SIFCTR_TFWM_1 | SIFCTR_RFWM_1);

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://msgid.link/r/20240130094053.10672-1-wsa+renesas@sang-engineering.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-sh-msiof.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/spi/spi-sh-msiof.c b/drivers/spi/spi-sh-msiof.c
index 51ceaa4857249..ec3a4939ee984 100644
--- a/drivers/spi/spi-sh-msiof.c
+++ b/drivers/spi/spi-sh-msiof.c
@@ -137,14 +137,14 @@ struct sh_msiof_spi_priv {
 
 /* SIFCTR */
 #define SIFCTR_TFWM_MASK	GENMASK(31, 29)	/* Transmit FIFO Watermark */
-#define SIFCTR_TFWM_64		(0 << 29)	/*  Transfer Request when 64 empty stages */
-#define SIFCTR_TFWM_32		(1 << 29)	/*  Transfer Request when 32 empty stages */
-#define SIFCTR_TFWM_24		(2 << 29)	/*  Transfer Request when 24 empty stages */
-#define SIFCTR_TFWM_16		(3 << 29)	/*  Transfer Request when 16 empty stages */
-#define SIFCTR_TFWM_12		(4 << 29)	/*  Transfer Request when 12 empty stages */
-#define SIFCTR_TFWM_8		(5 << 29)	/*  Transfer Request when 8 empty stages */
-#define SIFCTR_TFWM_4		(6 << 29)	/*  Transfer Request when 4 empty stages */
-#define SIFCTR_TFWM_1		(7 << 29)	/*  Transfer Request when 1 empty stage */
+#define SIFCTR_TFWM_64		(0UL << 29)	/*  Transfer Request when 64 empty stages */
+#define SIFCTR_TFWM_32		(1UL << 29)	/*  Transfer Request when 32 empty stages */
+#define SIFCTR_TFWM_24		(2UL << 29)	/*  Transfer Request when 24 empty stages */
+#define SIFCTR_TFWM_16		(3UL << 29)	/*  Transfer Request when 16 empty stages */
+#define SIFCTR_TFWM_12		(4UL << 29)	/*  Transfer Request when 12 empty stages */
+#define SIFCTR_TFWM_8		(5UL << 29)	/*  Transfer Request when 8 empty stages */
+#define SIFCTR_TFWM_4		(6UL << 29)	/*  Transfer Request when 4 empty stages */
+#define SIFCTR_TFWM_1		(7UL << 29)	/*  Transfer Request when 1 empty stage */
 #define SIFCTR_TFUA_MASK	GENMASK(26, 20) /* Transmit FIFO Usable Area */
 #define SIFCTR_TFUA_SHIFT	20
 #define SIFCTR_TFUA(i)		((i) << SIFCTR_TFUA_SHIFT)
-- 
2.43.0



