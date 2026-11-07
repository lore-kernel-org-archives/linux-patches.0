Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062093;
	b=hKOYsaPB4w4KSfZY7Y6doyUQsCVv+rVLnyfY3p2sWk9o84doPEctjsKG2djM5n05VRin
	 jrTs0nSs9MlCjQCYD6viHftvUKZvrUsKD1sKCK3T8aE1QmRdVFEoIB4Cg5C+7hnEsWDA9
	 xJPwiTGSchnHbCp7mK0XDjX0y1i1u8693Ea/6DHqPFg/XIqJfEni0OLVLhpEeio0ghkNM
	 UuVrAjba8ku2K/vCIEHTcKyBtZgPuC+ybf/kuEGq/vua0iNAqLLZ++JzcLrzfkPpeGrMx
	 MdS5vKt1Pi+T0BAIc7MmsqU63hvY4MZF8AA/BOYh5xb7ufwHMjzfnz9TKBXP9MKsWwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062093;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zMLpLdTj0jI5/9iDO6tSZKMda+NDZwAK+1mMP3e/eRU=;
	b=Aw/A7j+IXoVK6/9PmQ0vhVbjcRte8V8fDGgELjrLotLz7JEyYDLG4VjaUOpa/E8/+fDG
	 N0uIfcrD54u4jln0866af/Ja5aAZKh+L+nQ8jZBmpYygpWNw2O67w8VadVl1a1GMGGFYu
	 JMih54pbzAeySCQ/UJNNC4urNL9urzW+nohXBU54Zg5MUSiULfKffMnOMFEkcqO20E0Rk
	 FPae0GIPgJ2T3xT1r0s7dfsYinWk7uu11IyThvnLsDqMSS9VlJ8t/mQWdtBMa5LejyGCv
	 eBZZJ1BGVLDSUMubYBG2KM702glTiTUQ3U6vvROB/frSKbQjp4Sn2/O9iXzUWpolyug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ciu0dhxU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09D646083615;
	Sat,  7 Nov 2026 14:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ciu0dhxU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC0511F008A1;
	Sat,  7 Nov 2026 14:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062092;
	bh=zMLpLdTj0jI5/9iDO6tSZKMda+NDZwAK+1mMP3e/eRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ciu0dhxUe7mMKdh5eDVgTWRZsqH4IiGEBzVwTd8NJIEpor5OaMIwuHPbGfGFY5QHs
	 kIwDho70VPjL4tJhIy6SKrVVNbJnZUmfHEuhAYZR+Pv0RaRxNC0i3MBZA6m65ezfrV
	 mf9MV11BnNlQLKQh6XzaHfpmIQAPFEaa9JDoV2Bw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1066/1536] mtd: rawnand: atmel: Fix MCK clock leak in atmel_nand_controller_init()
Date: Sat,  7 Nov 2026 08:51:22 -0500
Message-ID: <20261107135027.627610976@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 543a0be9dc645..a6a621b3da782 100644
--- a/drivers/mtd/nand/raw/atmel/nand-controller.c
+++ b/drivers/mtd/nand/raw/atmel/nand-controller.c
@@ -2081,7 +2081,7 @@ static int atmel_nand_controller_init(struct atmel_nand_controller *nc,
 	if (!np) {
 		dev_err(dev, "Missing or invalid atmel,smc property\n");
 		ret = -EINVAL;
-		goto out_release_dma;
+		goto out_put_mck;
 	}
 
 	nc->smc = syscon_node_to_regmap(np);
@@ -2089,11 +2089,13 @@ static int atmel_nand_controller_init(struct atmel_nand_controller *nc,
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



