Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064018;
	b=WjMuk9mK2kaB/3mVjMrD/fDauo0mYYF7A2m6uLv62YsykuMQH2rPq9FlR/VPsSd6PjRB
	 cVq5fnMrLdtRvlK7MNwaKBV2WZ434hgz6kzAmttztA3OPR7VxDXsnBm3dZ5A9JsNKgNDf
	 TBiyhYX03ZUYLa3FU9RFJNQmeoQ7NOdqnr4Bu6EtBF6LMsaehxwKtI1cKiY48AJEK+2km
	 E2m3RuuOBtLt84yWV46KOipgD1wk9jaN0A9B8LpBRwRCZCnHEXY2yOJOxQ2NlWeb+ZweC
	 tOkeOGaaoqe9OirWIBpq3xLNdNKcIH9Ycqt9I9e2CwHcSvVZ66vhUWpTHhAYZVrAnJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064018;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0GPtgS8tT8TH1RQltBK0X9I0eABezy3HmmvrIiWpFJA=;
	b=wg7tcSwOXILaZ8eJTzgahTx6kInl6OD92DgXg0M3bOsRKTcvedEy/M4Wn/xAXdFA44ic
	 VrnF2kzaNGMMpgs7cQnMhY2DfTa9qH3IrMI9bClV9iZyImdltowJS88Ki28twT4BcxPcE
	 COGI0XF2epDVggqDSGdDTfuADj40Xg1erQ7blbOqYDJZySt7U5GL0OnxQMccTUmMxUKtp
	 6gwWxI3QB4fKkcMwomS8fBQD+dt1LYnYFYAyODZkERsW6KgskFtwsJFtZJKF5ifz4KDxs
	 dUGO2bftepVegd98Fk8iFPvD+A1LGtfcWyRhFf4q/ncxqednSnkIZJBSLc+2GbDB3KA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Gr0m5N0/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A5F606A334;
	Sat,  7 Nov 2026 15:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gr0m5N0/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64C941F0089F;
	Sat,  7 Nov 2026 15:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064017;
	bh=0GPtgS8tT8TH1RQltBK0X9I0eABezy3HmmvrIiWpFJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gr0m5N0/1lFqCLClY+9UunIwc5d+LC5bhl4WZPuqAAKB7zF0PeRkPPfY571LlcIYT
	 wPdpv9wI2uqUrHWZ34sq0iOT99uKCQktclStWn39HfkJic8ayEFkywDYifuP2hB/6x
	 wd4D6LFuG1xVo3+NCRaql9COJakuAsvaLi68wKm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabor Juhos <j4g8y7@gmail.com>,
	Johan Alvarado <contact@c127.dev>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0195/1257] spi: spi-qpic-snand: publish the ECC context to snandc->qspi
Date: Sat,  7 Nov 2026 08:41:31 -0500
Message-ID: <20261107134944.841067382@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Alvarado <contact@c127.dev>

[ Upstream commit f94c9b68bb5fdbef9f841da493d5305ff634ebb5 ]

qcom_spi_ooblayout_ecc() and qcom_spi_ooblayout_free() read the ECC
configuration through snandc->qspi->ecc. qcom_spi_probe() points it at a
zeroed scratch struct and only qcom_spi_ecc_prepare_io_req_pipelined(),
which runs on page I/O, ever updates it. qcom_spi_ecc_init_ctx_pipelined()
installs the ooblayout but does not publish the context it just
allocated, and qcom_spi_ecc_cleanup_ctx_pipelined() frees that context
without clearing the pointer.

spinand_init() calls mtd_ooblayout_count_freebytes() right after the ECC
context is created and before any page I/O, so the ooblayout always runs
against a pointer that does not describe the current context:

  - On a first probe it reads the zeroed struct from qcom_spi_probe(),
    so steps, bytes and bbm_size are 0. The count then returns 0 rather
    than an error, so the probe continues with mtd->oobavail set to 0.

  - On a probe retry it reads the ecc_cfg the previous attempt freed.

A retry is easy to hit. On IPQ5018 with the qcom,smem-part parser the
partition parse returns -EPROBE_DEFER until SMEM has probed, so the
first spi-nand probe defers. It defers inside
mtd_device_parse_register(), after mtd_otp_nvmem_add() has already read
the factory OTP - that read goes through prepare_io_req and leaves
snandc->qspi->ecc pointing at the context that spinand_cleanup() then
frees. The second probe allocates a new context, never publishes it, and
computes the OOB layout from the freed one. Once the slab has been
reused, qecc->steps holds garbage and

  oobregion->length = qecc->steps * 4;

goes negative. qcom_spi_ooblayout_free() only reports -ERANGE for
section 1 and later, so mtd_ooblayout_count_bytes() sums the regions and
returns that negative length as the byte count. The -512 below is
steps * 4 with steps == -128. It is a byte count that happens to
collide with -ERESTARTSYS, not an error the driver returned.
spinand_init() takes it as an error, and because it is not
-EPROBE_DEFER the driver core never retries and the NAND never appears:

  spi-nand spi0.0: ESMT SPI NAND was found.
  spi-nand spi0.0: probe with driver spi-nand failed with error -512
  UBI error: cannot open mtd rootfs, error -2
  Waiting for root device /dev/ubiblock0_1...

On a Mercusys MR80X (IPQ5018, ESMT F50D1G41LB) about half of the boots
failed to mount the rootfs, the outcome depending on whether the freed
memory had been overwritten yet.

Publish the context when it is created and clear the pointer when it is
destroyed. Clearing leaves snandc->qspi->ecc NULL after cleanup, which
is safe: the mtd is unregistered before cleanup_ctx runs, so no
ooblayout callback can follow.

Fixes: 7304d1909080 ("spi: spi-qpic: add driver for QCOM SPI NAND flash Interface")
Cc: stable@vger.kernel.org
Tested-by: Gabor Juhos <j4g8y7@gmail.com>
Signed-off-by: Johan Alvarado <contact@c127.dev>
Link: https://patch.msgid.link/20260911184416.109790-2-contact@c127.dev
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-qpic-snand.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/spi/spi-qpic-snand.c b/drivers/spi/spi-qpic-snand.c
index 05efe6313b7fe..ae4a3f2a35e1c 100644
--- a/drivers/spi/spi-qpic-snand.c
+++ b/drivers/spi/spi-qpic-snand.c
@@ -411,6 +411,8 @@ static int qcom_spi_ecc_init_ctx_pipelined(struct nand_device *nand)
 	dev_dbg(snandc->dev, "ECC strength: %u bits per %u bytes\n",
 		ecc_cfg->strength, ecc_cfg->step_size);
 
+	snandc->qspi->ecc = ecc_cfg;
+
 	return 0;
 
 err_free_ecc_cfg:
@@ -427,6 +429,7 @@ static void qcom_spi_ecc_cleanup_ctx_pipelined(struct nand_device *nand)
 
 	kfree(snandc->qspi->oob_buf);
 	snandc->qspi->oob_buf = NULL;
+	snandc->qspi->ecc = NULL;
 	kfree(ecc_cfg);
 }
 
-- 
2.53.0



