Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035849;
	b=np1BubkMg3DpZoFs2b2AEj1MapKezaXsNiARADnvjopBxvnezuO4tGbwagwEaKnN2z2M
	 pe5cElqOH7Av1mDh/jswGJOJp9tx7eItuj+p+IkgyANysUr1p3X5WvqzVcr7MSlmR5MMw
	 joMeqiM2Qr55lCg7amo6pyktfbtSqrICWS8uSemon8LL1PFy/fzxsjMt0xCSCb4JBizBx
	 /8g4JvpdWn+22zv6oCPY3Cf0KVyEGlqv+ZUPkfB/Nmiaf0pXMgvBNnm2pfAolYZdhr7q4
	 7pL/fZQTQZsREy1KpGs+1KO6U7MgBr0cK6uPGyn6w1d9vGLWCnQ/DwN4AxMTMTdOgww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035849;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=N/+pqrx9jJHhewlUJXwkB+D+PJ37zjog03IfZmjkItM=;
	b=zs0EcriqOiizslm+xikdSJK23pV0cOuLJLMjwNvPPLu3/cXHEcPqQ1jdAioeuy89jhJo
	 dEISqneJNgzzboW8byBxGwALA42s5lf1f6d4w3ExjUZcd0V1mKAl2PnShm54WXN0SS8Hg
	 FPC//Q9Mm6zma5DA0Q2e7pvEPqZH3WsXLU6XmxXiAOxdjqNFr4Z2jGOtR1eFw0+Yh2G05
	 qUlmH+yy9Yfk6r3keoZLgQ2d5ZwVV9j8zhw6d5zSu83ZMxN0ltNNEH5oSN+3DhiOHZ8CW
	 zrKjuFNF40Lk5xQdoxctXmv/CfKPnuSgoZaG2JzbRwBmalOXAcrqtkSRtUjCebZSjnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qHwC3HJW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4107E606A922;
	Wed, 18 Nov 2026 21:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qHwC3HJW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 924AC1F000C5;
	Wed, 18 Nov 2026 21:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035849;
	bh=N/+pqrx9jJHhewlUJXwkB+D+PJ37zjog03IfZmjkItM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qHwC3HJWa5QA0Qt+PyC69T+0PteuvuhsTgOy4XwcJ32JEL98WHzHkqxpRXiB8yB0t
	 tOaBYxNQ2cW40wxZxZWdD5AGqmlMGysVR1VymnrBrClkSeJmLzgFEKrF3qPsSSI7Qa
	 BeX//xis4lGqrsNrGudsf6lv4BYxljn0UOxlxVrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Hilliard <james.hilliard1@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0850/3318] mtd: rawnand: sunxi: reject ECC maximization on small pages
Date: Wed, 18 Nov 2026 15:24:32 +0100
Message-ID: <20261118150344.718517869@linuxfoundation.org>
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

From: James Hilliard <james.hilliard1@gmail.com>

[ Upstream commit a3c84084a73e170374b7dd493947efdef4ee57bc ]

When nand-ecc-maximize is set, the driver selects a 1024-byte ECC step
and divides the available OOB bytes by the resulting number of steps. A
NAND with a smaller page therefore produces zero steps and a division by
zero.

The older controllers also provide a 512-byte ECC block mode, but the
hardware documentation describes that as an ECC block size within NAND
pages whose supported sizes start at 1024 bytes. It does not document a
512-byte NAND page mode.

Reject pages smaller than 1024 bytes before deriving the step count. This
prevents the division by zero at the point where the incompatible
maximized geometry is selected without changing explicitly configured
512-byte ECC block handling.

Fixes: 4796d8655915 ("mtd: nand: sunxi: Support ECC maximization")
Cc: stable@vger.kernel.org
Signed-off-by: James Hilliard <james.hilliard1@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/sunxi_nand.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/mtd/nand/raw/sunxi_nand.c b/drivers/mtd/nand/raw/sunxi_nand.c
index 8d31cb0133acc..ca90d5c42dc4f 100644
--- a/drivers/mtd/nand/raw/sunxi_nand.c
+++ b/drivers/mtd/nand/raw/sunxi_nand.c
@@ -1631,6 +1631,9 @@ static int sunxi_nand_hw_ecc_ctrl_init(struct nand_chip *nand,
 	if (nanddev->ecc.user_conf.flags & NAND_ECC_MAXIMIZE_STRENGTH) {
 		int bytes;
 
+		if (mtd->writesize < 1024)
+			return -EINVAL;
+
 		ecc->size = 1024;
 		nsectors = mtd->writesize / ecc->size;
 
-- 
2.53.0



