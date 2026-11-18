Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036092;
	b=ng5LZexx9qvbSDcvICaGOy+F0ao06ATO79gif5eg7Q64jUYb/aNAZaQzwnT+zTOsnBqv
	 L5ILiY3yOkXXftfOa1/OcQ3LV9jdQ7lYKlkAKKcZYd8xxhengt6T7/Cz9hJxUjk3GTlwr
	 o3VN25w++syFICd/+HMlR9CC5TdSossZkjZZHrOe6ehiPvtCDWZBcQcWLq5qjwUBm1mL4
	 YtqVoUSpj9VLzkBEhsVootAdHKJ3++BGlZOsHvwcTzn5+DPsPWlqxk5TFDs+9QPcpZkfl
	 Ki8noFYHG37cI7pn/NKkskXI8NmrG+QGtuMg2GtqLybzy//PAicawBCYLlLIOi2WIhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036092;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VFpkufiFa/rmhN0L881z3GgmLpqRc26OvtBrJdRDTwQ=;
	b=FsJHNe8uHhqzk19Ee/Iz5BWgeUYf+WcGdhWKnvV+s4Z/qfHFl48gDoubYmpv62PmVn27
	 zEZ5BKqN/P62De69DufAUjgQg2juIsoFOFZfsTiPhWOAjZakCw0aNjmVI9Ozvx+sMcDp8
	 gPiS8n5+Yi+yOhrsaDSjucf+W6MNxkPVmIjkzHL3F4VWcFSn853thskyDS7n/2p8mRuBU
	 iqEx8t3httkvhkciNY9suzzl5MH27Fha0ccXRGek3P7pK4uygEqBP288dnyNLWrl7PxuM
	 rBdtGg/R1P7B6JWLQ10G1Z1S5kCV6BDpmQAZRRdC8U9LaUgLiyVbLAASvnZjGGoJj8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HUV5XSO9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D882606A31C;
	Wed, 18 Nov 2026 21:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HUV5XSO9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF9FE1F000C4;
	Wed, 18 Nov 2026 21:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036092;
	bh=VFpkufiFa/rmhN0L881z3GgmLpqRc26OvtBrJdRDTwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HUV5XSO95COrEtVmDmoKtK0L9QGCDAiR/xSeARkpVE6Pq57v/Yd6ZUItTNAVsGwF4
	 mr6KGXfvBpcMCWjzYcOuDFc8dh6kwAGo3jgT3iXXI2G3D21C3VzNCqywUP12CXK6ze
	 DtI9cg2oOVT85RbKkaTBQ1xCYM0DpwHlWAg9DVKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0937/3318] mtd: rawnand: atmel: Fix MCK clock leak in atmel_nand_controller_init()
Date: Wed, 18 Nov 2026 15:25:59 +0100
Message-ID: <20261118150347.674843559@linuxfoundation.org>
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
index 14a09285f1551..3fa14fd312488 100644
--- a/drivers/mtd/nand/raw/atmel/nand-controller.c
+++ b/drivers/mtd/nand/raw/atmel/nand-controller.c
@@ -2078,7 +2078,7 @@ static int atmel_nand_controller_init(struct atmel_nand_controller *nc,
 	if (!np) {
 		dev_err(dev, "Missing or invalid atmel,smc property\n");
 		ret = -EINVAL;
-		goto out_release_dma;
+		goto out_put_mck;
 	}
 
 	nc->smc = syscon_node_to_regmap(np);
@@ -2086,11 +2086,13 @@ static int atmel_nand_controller_init(struct atmel_nand_controller *nc,
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



