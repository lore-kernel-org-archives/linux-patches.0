Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043873;
	b=PPIQVfCX+aJC8hB9Gv0ZYs8gGF5wvGHuJmj3wceQDcBzNx1Vz9e7prvkNGSH45fiyaCq
	 K88eDCcyj49G2FgBk8FOQoL1BRq7BADAdOGRpd8dwJfKof+8WgGQJ4eh7EsB7iWf+YXW1
	 Fs4Xu+2QyxGQAtO62EJGC68hYucP56SGXoNlpKr83g/yh2zME8ECQsWwsRdJ89aJrws/F
	 NP0bW5T6G2i3aUPNsDbiQDkpqSSedndhIJ44bqN9b81PPDTokYQxWAtbk6Un4AQYgTP+K
	 jbMgPT1YsAYdJAIPwVHP9jxETccdEj2vLCRqb/MHYq2I9S+gKLvppJOirHfFaYEZ4BA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043873;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VPyCqtQNMxPeEkM2ogO/PbssOCpO1tEmGJ/YZ0M1rBc=;
	b=5jmuZttvOg6IqfDp7WBnsM6hOJtTolJQuHc08JEKFVWudtsWd4PfDXtf/rkgeDvr87We
	 IVXnJaZoNQclgOFhp1fZKTBCF4xKkXU+VHjxR29hTkwiJVj325WVYuJkPbWv/uOqOdA4N
	 2k4X9FaGbl1XW1N3zqSmZon8YeUI0ks4hp3+j/Dhy2YokU0TKsbg5ZDE8OAhlLyCv2kVM
	 KASdhU/yZs462+uDIdWTxVlrbEHryKzVDZ00c8meFRHjtOGW+z/tZWHYgcT7yRnV5IYTj
	 +SbyjrZdKcUuDBQs2YsGnSYQsOokYi9lO2CPjb0Uu5ZLqYG73SDY7Rclr6h+xnJmomA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LzFILrNs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90E69606A325;
	Wed, 18 Nov 2026 23:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LzFILrNs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FFA11F000C4;
	Wed, 18 Nov 2026 23:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043873;
	bh=VPyCqtQNMxPeEkM2ogO/PbssOCpO1tEmGJ/YZ0M1rBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LzFILrNsKJqRi1PgsCy0Yq7lQ9sB6EmdPsjNYfH2RQez6YJjOkvg0Khz0Vt5grZnM
	 1NmeIxhZ6zyx/CbHJNDhNVEIzV69EGpINNG+nDW4fb3etJDHs6ufxlmcnxsz6XsHlV
	 eMcfHdBaRSL7k+0sm7RMLxt2AEfvZ5WKJsEjWris=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Scian <andrea.scian@dave.eu>,
	"Miquel Raynal (DAVE)" <miquel.raynal@bootlin.com>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0325/2857] mtd: rawnand: pl353: Make sure we use the monolithic helpers for raw accesses
Date: Wed, 18 Nov 2026 15:22:39 +0100
Message-ID: <20261118150213.143337276@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
index 929dc759c6b24..1c23ad74b225c 100644
--- a/drivers/mtd/nand/raw/pl35x-nand-controller.c
+++ b/drivers/mtd/nand/raw/pl35x-nand-controller.c
@@ -916,7 +916,6 @@ static int pl35x_nand_init_hw_ecc_controller(struct pl35x_nandc *nfc,
 	chip->ecc.steps = mtd->writesize / chip->ecc.size;
 	chip->ecc.read_page = pl35x_nand_read_page_hwecc;
 	chip->ecc.write_page = pl35x_nand_write_page_hwecc;
-	chip->ecc.write_page_raw = nand_monolithic_write_page_raw;
 	pl35x_smc_set_ecc_pg_size(nfc, chip, mtd->writesize);
 
 	nfc->ecc_buf = devm_kmalloc(nfc->dev, chip->ecc.bytes * chip->ecc.steps,
@@ -983,7 +982,6 @@ static int pl35x_nand_attach_chip(struct nand_chip *chip)
 	case NAND_ECC_ENGINE_TYPE_NONE:
 	case NAND_ECC_ENGINE_TYPE_SOFT:
 		dev_dbg(nfc->dev, "Using software ECC (Hamming 1-bit/512B)\n");
-		chip->ecc.write_page_raw = nand_monolithic_write_page_raw;
 		break;
 	case NAND_ECC_ENGINE_TYPE_ON_HOST:
 		dev_dbg(nfc->dev, "Using hardware ECC\n");
@@ -997,6 +995,9 @@ static int pl35x_nand_attach_chip(struct nand_chip *chip)
 		return -EINVAL;
 	}
 
+	chip->ecc.read_page_raw = nand_monolithic_read_page_raw;
+	chip->ecc.write_page_raw = nand_monolithic_write_page_raw;
+
 	return 0;
 }
 
-- 
2.53.0



