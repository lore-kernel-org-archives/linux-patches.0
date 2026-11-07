Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060642;
	b=VgvK9CR/3vLZCmzB4jHE7yeyOLuDx8WnHZN+xMM0UerMW+Ya9h3n2yLbJhutPO246jOY
	 FR656nVQiAeaWAVpohRHJiEJfzWCigN5X2rXngVhy7Yl2FE3hW2UpyTFDPVDlldJ/mqLZ
	 a2amG1MQAK/TbZbNMajld+2Tt+qiEGckfgk0Qbj5Ew9SpBD5xFkL1snIktAshYMuxguUs
	 lP5gkO79WlAG1jmKmlYgDDZVN8+XrECmpRA54Lw1LxW5lZkbCAiIAtXFH25VdEatB31ez
	 jejED4P4kZFQdzytPe6L1Cbvlnn22MevtLOhN4cIvFnIw0fyn7s901HOmWauXTM4iBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060642;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zzliOqJ2d1GN4FDeEc1v7lCHOOAH1eiwBa74etFUveE=;
	b=Jyg7S1FFXJ9G5v37P0Df8qhX1za4dcHSkWRl+hLM986WcT6Zgyi5UtLIXupBG0BM+rZi
	 taLy4nLfbkwCmTx0AXzKsnUo8RsV2QTYZrbDvwHGgiRwF//J4lMQL2sNOjWwgq5vzj0X8
	 E36Q1KEgi/JhpngyqUE37DIp3IqvgQItS5kBvzNoWsExsw0FvX8xBE6oYvdsb2fJy3o1K
	 N6MHMX3S+qvKCj8qM9WljGP/tLmvpu69lTQQIRbCaVteTc0iv1xnAAyfgp6o1hz6B2Doo
	 jdzUOs79NDonDjDsmGJLxgWROBOzXzVFxg+MDDDIJsrAnVx/0vUX4snP+QTAYYjQaTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dRqMf80A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34FEF606A326;
	Sat,  7 Nov 2026 14:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dRqMf80A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A51AE1F0089F;
	Sat,  7 Nov 2026 14:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060641;
	bh=zzliOqJ2d1GN4FDeEc1v7lCHOOAH1eiwBa74etFUveE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dRqMf80ACvSe3kLWfowpORR7+iefrqZO261f3zb1mzgX3forj5yg41eCJO78yyxbV
	 Q25nRY/NmRUQj+8PGfYmEyjjXOKkonb5uui4pzaRA1Qdh1jYUd0hgsxg6JXA1wVFqy
	 fvqYR50Ps1gYKCf7gN/R5kNiok4j5ohcuLLW4HaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Liu <1298662399@qq.com>,
	Kamal Dasu <kamal.dasu@broadcom.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0045/1536] spi: bcm-qspi: return error from failed controller suspend
Date: Sat,  7 Nov 2026 08:34:21 -0500
Message-ID: <20261107134958.924367595@linuxfoundation.org>
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

From: Jiawen Liu <1298662399@qq.com>

[ Upstream commit 44d09ef0ba690ac46d17eb05c12a47a5dd75e231 ]

spi_controller_suspend() can fail if the SPI core cannot stop the
controller. bcm_qspi_suspend() ignored that error, disabled the
controller clock, uninitialized the hardware, and returned success.

Return the suspend error before tearing down the clock and hardware
state.

Signed-off-by: Jiawen Liu <1298662399@qq.com>
Reviewed-by: Kamal Dasu <kamal.dasu@broadcom.com>
Link: https://patch.msgid.link/tencent_21BF5F9512F56D45FD9018BAF14ED2805808@qq.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-bcm-qspi.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-bcm-qspi.c b/drivers/spi/spi-bcm-qspi.c
index cfdaa5eaec76d..ae5545be0a45c 100644
--- a/drivers/spi/spi-bcm-qspi.c
+++ b/drivers/spi/spi-bcm-qspi.c
@@ -1694,13 +1694,17 @@ EXPORT_SYMBOL_GPL(bcm_qspi_remove);
 static int __maybe_unused bcm_qspi_suspend(struct device *dev)
 {
 	struct bcm_qspi *qspi = dev_get_drvdata(dev);
+	int ret;
 
 	/* store the override strap value */
 	if (!bcm_qspi_bspi_ver_three(qspi))
 		qspi->s3_strap_override_ctrl =
 			bcm_qspi_read(qspi, BSPI, BSPI_STRAP_OVERRIDE_CTRL);
 
-	spi_controller_suspend(qspi->host);
+	ret = spi_controller_suspend(qspi->host);
+	if (ret)
+		return ret;
+
 	clk_disable_unprepare(qspi->clk);
 	bcm_qspi_hw_uninit(qspi);
 
-- 
2.53.0



