Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034463;
	b=pqlcm0xT1rYGYZevAw+dJBecDXeTSn77y01LcpEUz2ly7juA4+QILZFYFHvd84kpkzFF
	 IOQKJv6G21YH//ZqENGhpfnrvPEVG3+Gt5UprLeKXMUOSI7LJhfnoqBZSmuZ2t8P6FMcC
	 LavKU7PTGzZKoZifhsVBN2+a6CUriA69UJ4urJOH09ipkrJkuct21dstt2IyzAB+xhzaE
	 8lNmeCTE21Brfn69OW3FMI4Ud7IEekNl7IWjlLekK7BveJfUDtfsEl3A/M9kyYB3hgard
	 22FgEISafaS/rb2YqFGfSN1AiYE5LLueu7FEeBnTVRsN7HqvUOipALk9Ap4eXYqGwaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034463;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=impEYo/aNsAF+xoNYzLxDT28aKv4kc/CH0YFUEvKD+k=;
	b=EHBPbH7A2gV8zkvsqh5GL4AXoLove6a0ajNYIFbGKN6SJQ1zWJM/+lH3wxOuKmLCPJRI
	 6P0oiRh1vTOmrfTDOx6s4PHfxY+K8OsRHd3myZa4S0DUdXWBVZaQmeO7EvVzSjAy7S8Mv
	 VpE230V8sSTFpIdArGwXfQS0RKv8hmq0/btvRDY8pWuEZx4mCBiayrH2iER0T4Ii/+nwb
	 KWy9BwQKFETTUf+WsEk8tRlpOHoBca+3yQfiueUcVcIOfxNJFq599p1CQCXl6TncMxw+M
	 LfCSH842QnIeNLiy3Cn0jRiKUcr5AA/ekKj5WAPoxzaL16wYQ/XGfV4ptzyNeB8XiPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IO5DyCwC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E4B606A31C;
	Wed, 18 Nov 2026 20:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IO5DyCwC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEB711F000C4;
	Wed, 18 Nov 2026 20:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034462;
	bh=impEYo/aNsAF+xoNYzLxDT28aKv4kc/CH0YFUEvKD+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IO5DyCwCoDfn5tMyeRi1RQVEqsxUnDDPndlW0eZX9J2TWNmcK+EksZh8VlpwppuZn
	 +gUBf52hh3gx3BruZgetg5hjhzzrg3gRhoxvB1s66bmiWZgLSz97Qhdi5QYZiXI/dt
	 qSk5P9XUKKlEn7DfmySk/Gk986K84do6nWnPxWj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Scian <andrea.scian@dave.eu>,
	"Miquel Raynal (DAVE)" <miquel.raynal@bootlin.com>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0376/3318] mtd: rawnand: pl353: Make sure we use the monolithic helpers for raw accesses
Date: Wed, 18 Nov 2026 15:16:38 +0100
Message-ID: <20261118150327.512183912@linuxfoundation.org>
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

From: Miquel Raynal (DAVE) <miquel.raynal@bootlin.com>

[ Upstream commit 80ecacd054ffeb60cd28e46ed5cd6bd0d2de318b ]

Any access not using the hardware ECC engine should be monolithic
because the controller has its very own way of handling the end of a
transaction during operation configuration, so we cannot easily make
repeated reads.

This has the side effect of fixing support for software ECC engines.

Suggested-by: Andrea Scian <andrea.scian@dave.eu>
Cc: stable@vger.kernel.org
Fixes: 08d8c62164a3 ("mtd: rawnand: pl353: Add support for the ARM PL353 SMC NAND controller")
Signed-off-by: Miquel Raynal (DAVE) <miquel.raynal@bootlin.com>
Acked-by: Michal Simek <michal.simek@amd.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/pl35x-nand-controller.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/nand/raw/pl35x-nand-controller.c b/drivers/mtd/nand/raw/pl35x-nand-controller.c
index 56c789ab8c1a1..771bda7612864 100644
--- a/drivers/mtd/nand/raw/pl35x-nand-controller.c
+++ b/drivers/mtd/nand/raw/pl35x-nand-controller.c
@@ -914,7 +914,6 @@ static int pl35x_nand_init_hw_ecc_controller(struct pl35x_nandc *nfc,
 	chip->ecc.steps = mtd->writesize / chip->ecc.size;
 	chip->ecc.read_page = pl35x_nand_read_page_hwecc;
 	chip->ecc.write_page = pl35x_nand_write_page_hwecc;
-	chip->ecc.write_page_raw = nand_monolithic_write_page_raw;
 	pl35x_smc_set_ecc_pg_size(nfc, chip, mtd->writesize);
 
 	nfc->ecc_buf = devm_kmalloc(nfc->dev, chip->ecc.bytes * chip->ecc.steps,
@@ -981,7 +980,6 @@ static int pl35x_nand_attach_chip(struct nand_chip *chip)
 	case NAND_ECC_ENGINE_TYPE_NONE:
 	case NAND_ECC_ENGINE_TYPE_SOFT:
 		dev_dbg(nfc->dev, "Using software ECC (Hamming 1-bit/512B)\n");
-		chip->ecc.write_page_raw = nand_monolithic_write_page_raw;
 		break;
 	case NAND_ECC_ENGINE_TYPE_ON_HOST:
 		dev_dbg(nfc->dev, "Using hardware ECC\n");
@@ -995,6 +993,9 @@ static int pl35x_nand_attach_chip(struct nand_chip *chip)
 		return -EINVAL;
 	}
 
+	chip->ecc.read_page_raw = nand_monolithic_read_page_raw;
+	chip->ecc.write_page_raw = nand_monolithic_write_page_raw;
+
 	return 0;
 }
 
-- 
2.53.0



