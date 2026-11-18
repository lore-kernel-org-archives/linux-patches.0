Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058301;
	b=hTsNt1ExR7MaKXDZ0x5TzjLlQTM0qHpcgM6ijJeWg2SsK2lN9Z7UxnGH/z/NFPO/RSfN
	 3NcIl/mQY8AAfLA6aAaOUwdIuh8qsGg8kzxAphjZYx/n+zFlzD8xiiPHNdLAq/cGYhZ5r
	 WKLo/dllGeT9S0ujXe9FDa6gKTeT0IkaiVEKdU/OPCDujeHi2Z2IazRYNYwzFdaP6GnyB
	 5BnW5yaZkLku2p1qEqml3Y5cyJJeypssdGoX7iUJB1yJ+nP3SY2Vzs6Z/X1x6KpiaV1Eq
	 seA/dv2zXtXiyM/KqcpmyOgxtr8iM1W5HFU8bYSiFW6CjyCasSkILrY2lUdCTnTICZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058301;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2OoYocbOTqa65vary8EWQ3s+oeATa9mXDmFYwV7z3Qc=;
	b=zNFQpESaRffQD2E56u5bttJUE/eD4OEEhyPJycFE07gcryNf0KmkmzF6NO16o9DG8Iot
	 quIouhLkcUPKwxbdNGYxNA+098J1tuV2cbbsaX3H6QY14RgjB3Uuawi8W9lVx9Bz+Xtjf
	 4fSdkXgvCseJjOGX/FrufcAYP9B5qgDasfKnwWSUJ3xNKnLXg89+4aXjMavPowI6Zw+yK
	 n2MFhzwrcYRWZeIm10G5q9U9zt1rAWy6GzJnopJvJhCPf91/P5wl1bhy7rjBEb93ggdfE
	 2T1Vj+I9w8k2hEspBAAe42o0q07etWyYSE8zuGdvme4VmKx8VBchp/ZGZMMQ+z5ddhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o7f3hVyC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FB95606A31C;
	Thu, 19 Nov 2026 03:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o7f3hVyC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E46A11F000C4;
	Thu, 19 Nov 2026 03:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058301;
	bh=2OoYocbOTqa65vary8EWQ3s+oeATa9mXDmFYwV7z3Qc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o7f3hVyCqu6qa3NExcCsneufgOqwOitKKiq6cNkmC/nxJHYCsKXVQ0QP2RHigMZFq
	 J6QcNpqQKAdyJoa0esMlJhRuZcgvHj7uDYb5c9NVgwIUaklReqEgybEn4MGN8CN25p
	 FhFP2b9tYLrfa2g8MDplqk77Eo4XNLpV8okmBI0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0435/1848] mtd: rawnand: atmel: Fix MCK clock leak in atmel_nand_controller_init()
Date: Wed, 18 Nov 2026 15:41:13 +0100
Message-ID: <20261118145932.325009278@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 94edcda45d888c3bb1310de11e10e4537c166f00 ]

atmel_nand_controller_init() takes a reference to the MCK clock with
of_clk_get() and keeps it in nc->mck for the lifetime of the
controller.  If the "atmel,smc" phandle is missing or the SMC regmap
cannot be obtained afterwards, the error path jumps to out_release_dma
which only releases the DMA channel, so the clock reference is leaked.
The callers return the error directly and never run
atmel_nand_controller_cleanup(), where the clock is normally put.

Release the reference on those error paths.  The path on which
of_clk_get() itself fails keeps jumping to out_release_dma, as nc->mck
only holds an error pointer there.

Fixes: f9ce2eddf176 ("mtd: nand: atmel: Add ->setup_data_interface() hooks")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/atmel/nand-controller.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/nand/raw/atmel/nand-controller.c b/drivers/mtd/nand/raw/atmel/nand-controller.c
index 179696ea6f573..ec5bcc3f6cf77 100644
--- a/drivers/mtd/nand/raw/atmel/nand-controller.c
+++ b/drivers/mtd/nand/raw/atmel/nand-controller.c
@@ -2076,7 +2076,7 @@ static int atmel_nand_controller_init(struct atmel_nand_controller *nc,
 	if (!np) {
 		dev_err(dev, "Missing or invalid atmel,smc property\n");
 		ret = -EINVAL;
-		goto out_release_dma;
+		goto out_put_mck;
 	}
 
 	nc->smc = syscon_node_to_regmap(np);
@@ -2084,11 +2084,13 @@ static int atmel_nand_controller_init(struct atmel_nand_controller *nc,
 	if (IS_ERR(nc->smc)) {
 		ret = PTR_ERR(nc->smc);
 		dev_err(dev, "Could not get SMC regmap (err = %d)\n", ret);
-		goto out_release_dma;
+		goto out_put_mck;
 	}
 
 	return 0;
 
+out_put_mck:
+	clk_put(nc->mck);
 out_release_dma:
 	if (nc->dmac)
 		dma_release_channel(nc->dmac);
-- 
2.53.0



