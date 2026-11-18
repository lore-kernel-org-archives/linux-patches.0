Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052358;
	b=QXq6DYRjPXgN0CjWVYh1oB0OLvZgCljj8hP6Fc56JSTApz0G64HG7/qpTxaxKYi0JdK0
	 QWkB45Hdqr8bG/v4mJAmoaxsLvpCkeXz8MJL/dltaoOaK9k9mjh+VcsiAsmje1Xow+DU8
	 rbIkyNndt5MuQ5hiTFk1XdgBif43eW1Th/Z0iHcv28VpEfLWitmyX5+d5MN/Cmeyqz1T0
	 1VjJcRnhI71WV8NU5oeb3fefNpKqpDhUol69Ux5Oboao+fPwwI59TPuuy4baGK/rOwkXt
	 /4olf9fU/AFz20/QKv+W0ZDYYEjkc5npv/8HgGQivPmmxufcxptamOZC/QKmlhwSCFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052358;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SU1E+7i9X1rr2DGA5aI4yQYuUPdJhkcfKOiGNQ+N9m4=;
	b=bRqpbsIj4cVxSe9zNT8gIM4c0UiIt9KwhnV+TWWcfmh2+8wn7SVg7LR+VJkcrUoYkVmY
	 4D12HI8PsJPv7AeixNXUhw9DHYsOkGc5yPsfg0w9TRNCfh9RDrOymfDkBmiLUJqkFG5hw
	 7ELtQuA4xa6DpvxxDl7DfYYkwwz1/FAy4N5SHjc9++WxGLr14BHb61TkW4cwj1+KhfS0o
	 ZxHHLaYK+4t4rDXGXfK0rwuQS+ji0v+/nTbbJe16Lk5wLKvKMW8ip1TUr6dLJzS2Z4xV1
	 tE8r5wELTBdSYkyP669HEQ26cxNoGIU0DQBvzCWGSupcMQLHYunvUDKHCXGWj0mjpSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aYWKkIyS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8277A606A320;
	Thu, 19 Nov 2026 01:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aYWKkIyS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D60A91F000C9;
	Thu, 19 Nov 2026 01:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052358;
	bh=SU1E+7i9X1rr2DGA5aI4yQYuUPdJhkcfKOiGNQ+N9m4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aYWKkIyS/uNNGPNhPQtV0FjFeIgkkPONYHDxQagf4O3LQuu/Y25SlAjUaz/47oSWS
	 3SWlWsfKVfDPAETvT6QG/g6Ztn3JU0Wo2kLu4Haog76Jvsx0EgbwxEgQVK3JarOBrl
	 BcRlz24/cRg3LP9TjDMR2nQYacGFKw/IYG7v9W2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0536/2214] mtd: rawnand: atmel: Fix MCK clock leak in atmel_nand_controller_init()
Date: Wed, 18 Nov 2026 15:36:52 +0100
Message-ID: <20261118150032.479721505@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 81f834547c60f..4aaa12252db84 100644
--- a/drivers/mtd/nand/raw/atmel/nand-controller.c
+++ b/drivers/mtd/nand/raw/atmel/nand-controller.c
@@ -2079,7 +2079,7 @@ static int atmel_nand_controller_init(struct atmel_nand_controller *nc,
 	if (!np) {
 		dev_err(dev, "Missing or invalid atmel,smc property\n");
 		ret = -EINVAL;
-		goto out_release_dma;
+		goto out_put_mck;
 	}
 
 	nc->smc = syscon_node_to_regmap(np);
@@ -2087,11 +2087,13 @@ static int atmel_nand_controller_init(struct atmel_nand_controller *nc,
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



