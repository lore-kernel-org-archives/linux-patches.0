Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213243;
	b=oQOM6zRlpxUCyRUimGdmzoyDjIga/yvIQvih9CeHv8x+Iw6ZZzEqhyLaGS0vyCwvqkuz
	 xWmJ95M81jTBFJ+9RWAYrV5qddjHYcz+YulfhQphh6n8B1+/uLgDlitf1hfbT7Lj/BiKJ
	 dD2cGKXrpWmR6cvxlTB44Qasq2H0RJC/4+hTsWuEcqbke0IRnrkA/pqIPyRsBVJcjco13
	 ZHKJj+Ob5askjqmV7payHSqYIFWh9AabqfdKivcbIlrH2T4N7j4UmY2wkBuHIFgwWeGhc
	 KbFLJhmlwjU+2f81oJDkKnMwOPxeUYctkop6Jp8Qt47fMgmLZMREBHRHYDNtsjY2m6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213243;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=BI6ydF/DOVCjYkIBO63YCm12Pu8wzA09IOKPb8qkmew=;
	b=FWW42L4sYIs1bea7//hto6xiiYONlVLyf2KnDri1hoV6r5fJ1azilzr+2NMfZT32SK8L
	 kyioF4I0BOQIt9DA1T0I0NvpWhvHEobnpG1dtXjly9GLOYih613EvqrLZBaicUvf0qqmf
	 mukeoBwvQr++DUYo503362YOd6AatYahdpLdFii0IgSqZYkQXwE+5KLF3OJwN8UvTDF6n
	 UBSmJbkkzDRMoAJHxQK+3oCD3ocyeEhzn4YGaolXFPN49mujjOW+kKfVhjEwRXMSRycTX
	 MSTZMiHt9vCOhOypGa3G1zzsVG/If03X/pIszj6X86K4Z9BRhUkcOkamYXWlXFCMiYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AG5xLl3p;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87D64606A31A;
	Wed, 28 Oct 2026 18:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AG5xLl3p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B3441F01825;
	Wed, 28 Oct 2026 18:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213243;
	bh=BI6ydF/DOVCjYkIBO63YCm12Pu8wzA09IOKPb8qkmew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AG5xLl3p7DJqOak7ZrAKpUBPidE5gSQuen1K166o/kFSwXvL60g18LbQe4Q35tZ6Q
	 GRCo2aGWf/FaRL0nCIb4+Ai93bVKH2ujoKazBilLQJc2WXEEQ9BzokZ+9y5dec1eRH
	 cCohWmldVq4OzmQ/6/FHRlcKjg5om0FVZykyJ2Ug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0393/1887] mtd: spinand: fix NULL pointer dereference with no ECC engine
Date: Wed, 28 Oct 2026 17:41:29 +0100
Message-ID: <20261028170508.177717340@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nuno Sá <nuno.sa@analog.com>

[ Upstream commit b890e6163761ddb580cc74f43e15f8bbde15647e ]

When "nand-no-ecc-engine" is set in DT, nanddev_get_ecc_engine() takes
the NAND_ECC_ENGINE_TYPE_NONE path and returns success while leaving
nand->ecc.engine NULL. The SPI-NAND code nevertheless dereferences it
unconditionally to test for a pipelined engine, so probing such a
device oopses immediately.

Rather than open-coding the test three times, add a
nand_ecc_is_pipelined() helper to the NAND core that folds the NULL
check into the integration comparison, and use it everywhere. Future
callers then cannot reintroduce the problem.

Fixes: f9d7c7265bcf ("mtd: spinand: Create direct mapping descriptors for ECC operations")
Cc: stable@vger.kernel.org
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
[ sashal: replaced the new nand_ecc_is_pipelined() helper with an inline NULL check in spinand_create_dirmap() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/spi/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/spi/core.c b/drivers/mtd/nand/spi/core.c
index 39f9826342966..15c54d61cedbd 100644
--- a/drivers/mtd/nand/spi/core.c
+++ b/drivers/mtd/nand/spi/core.c
@@ -884,7 +884,8 @@ static int spinand_create_dirmap(struct spinand_device *spinand,
 
 	spinand->dirmaps[plane].rdesc = desc;
 
-	if (nand->ecc.engine->integration != NAND_ECC_ENGINE_INTEGRATION_PIPELINED) {
+	if (!nand->ecc.engine ||
+	    nand->ecc.engine->integration != NAND_ECC_ENGINE_INTEGRATION_PIPELINED) {
 		spinand->dirmaps[plane].wdesc_ecc = spinand->dirmaps[plane].wdesc;
 		spinand->dirmaps[plane].rdesc_ecc = spinand->dirmaps[plane].rdesc;
 
-- 
2.53.0



