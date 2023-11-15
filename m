Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A39B92EAEC
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cBqoYGQQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36961C433C8;
	Wed, 15 Nov 2023 19:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077238;
	bh=5Xswr+DQ8MwNwkjSNvkHYbsq6vLw7BLknaxL/PHqNHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cBqoYGQQ5cR+U9aqQh0Do6ORm7K+EWmX9JRAYWS+HmsUAfn9NgQ1aryhWXbxw6fcm
	 26+NkN+sJdDvjYmwTOUNKvnutUH7oTGkxr/2ZWGVGLmbe66wJvNgESJKEfwWNcvzGU
	 79IuxZG07hrhNUNw+17XdM6FJOqpwOwTpI1zcNlc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Han Xu <han.xu@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 181/603] spi: nxp-fspi: use the correct ioremap function
Date: Wed, 15 Nov 2023 14:12:06 -0500
Message-ID: <20231115191625.768851157@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Han Xu <han.xu@nxp.com>

[ Upstream commit c3aa5cb264a38ae9bbcce32abca4c155af0456df ]

AHB memory as MMIO should be mapped with ioremap rather than ioremap_wc,
which should have been used initially just to handle unaligned access as
a workaround.

Fixes: d166a73503ef ("spi: fspi: dynamically alloc AHB memory")
Signed-off-by: Han Xu <han.xu@nxp.com>
Link: https://lore.kernel.org/r/20231010201524.2021340-1-han.xu@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-nxp-fspi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-nxp-fspi.c b/drivers/spi/spi-nxp-fspi.c
index c964f41dcc428..168eff721ed37 100644
--- a/drivers/spi/spi-nxp-fspi.c
+++ b/drivers/spi/spi-nxp-fspi.c
@@ -759,7 +759,7 @@ static int nxp_fspi_read_ahb(struct nxp_fspi *f, const struct spi_mem_op *op)
 		f->memmap_len = len > NXP_FSPI_MIN_IOMAP ?
 				len : NXP_FSPI_MIN_IOMAP;
 
-		f->ahb_addr = ioremap_wc(f->memmap_phy + f->memmap_start,
+		f->ahb_addr = ioremap(f->memmap_phy + f->memmap_start,
 					 f->memmap_len);
 
 		if (!f->ahb_addr) {
-- 
2.42.0



