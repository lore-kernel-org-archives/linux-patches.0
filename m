Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 219F93A8F7
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HLZOkuDl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7816C433CB;
	Wed, 15 Nov 2023 19:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078073;
	bh=niiykFlum0R1koeaVXDucOdnA7GhEGf/pMJMWyEq7nM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HLZOkuDluvi5LaynaL2BSap3xK3BzYSps1n+qWi18/cV0YFNrJAn84fjfGV0+4wyd
	 B9A42g0tfn2EvJwBK2RVYCQPlrIgH+Ldznk2qH5ytISXkDohetB6sENRXBKazrLsSq
	 s5GOgqdN5B+Oq+rfAby1YBQshklNg3LLvWNI58f0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Han Xu <han.xu@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 094/379] spi: nxp-fspi: use the correct ioremap function
Date: Wed, 15 Nov 2023 14:22:49 -0500
Message-ID: <20231115192650.701004649@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
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
index c7a4a3606547e..afecf69d3ceba 100644
--- a/drivers/spi/spi-nxp-fspi.c
+++ b/drivers/spi/spi-nxp-fspi.c
@@ -708,7 +708,7 @@ static int nxp_fspi_read_ahb(struct nxp_fspi *f, const struct spi_mem_op *op)
 		f->memmap_len = len > NXP_FSPI_MIN_IOMAP ?
 				len : NXP_FSPI_MIN_IOMAP;
 
-		f->ahb_addr = ioremap_wc(f->memmap_phy + f->memmap_start,
+		f->ahb_addr = ioremap(f->memmap_phy + f->memmap_start,
 					 f->memmap_len);
 
 		if (!f->ahb_addr) {
-- 
2.42.0



