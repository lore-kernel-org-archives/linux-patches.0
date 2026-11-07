Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062876;
	b=kTZUH8C+tZnvxxVm/JnoQ2Awd9Nw2K5TjtfOLrv86KPunFFJbvU/tmsCN3gVAgJqdeow
	 TZq+xYEE+awjV1gnZsbe4BRSkxrNVSZOYBYrSmBqo5A/rmji05Pzg7Ttc2CHrLVQtsD27
	 mWAjpF6gSbX5EbBw2tmsDqa1Y7gUG/DY0M325DE5bpA6nekHdIgorD+aO518ucHU5TOEe
	 Q/C1UPr+YAsgJV+11fChRDZYLDIkV6g6h3jIoOzgFSnab+/1xZfCCaWQAVxjAX2IBOL6+
	 fIqDAoF5Ib9Eq6li0KJ+UFADokLCJNxN0FfGHzFZfqtKofrKW2K9FxSV3xIKcBDyinA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062876;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=byWd/+B0hbO5fGMboAq7x41t3IVHRFbwHGNtZKZDQHc=;
	b=1I4fHZUtKZ0lMwLwA5FJV/AByzaZjliDVZHdnSL69HpxjwPmrNVBWf9erSeFkvBlLah2
	 Y2D8JxE4Ti/aF+sX9pGOFxiqtc+9QAc24/JoGNCyhUpiUgPYwhybSGZHP2FUQRub6ytZ3
	 LS1XnuuNNzDLBmdV9SOM9cNXbPzy8cEOpgCAZq0Aesj7g25FZFvTQIJwFahIQuQ5lGoAS
	 1cqll+L4g/KusY63MI2ZsX5kM/ke20tawfph489CIn04WpEHwav75H9oOO7/bkMRYYU7E
	 fcbxT1gqmFE2DSGL87kVh1lWI6HTfFbgdOSxMenaOoH6m6Z25wB3VNhoJ8sSNC0eWmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="tpHYjM/K";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE4C7606A334;
	Sat,  7 Nov 2026 14:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tpHYjM/K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C8711F0089F;
	Sat,  7 Nov 2026 14:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062875;
	bh=byWd/+B0hbO5fGMboAq7x41t3IVHRFbwHGNtZKZDQHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tpHYjM/Kc+PMUzGbLK74kZxcEO2wNdKLeWNBARycNKQag2lrNno32BfgNi+mf7gHx
	 P5He6Wvy69mDQ0ICq+xKiiSP0mHKm3jSl5+Jryp+5ZSMWugU+C71wjJpqB0H65LOqG
	 rtu/cyW9RsC2R8WW62jSJ3KHwZn0k2VWZCAkTvBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabor Juhos <j4g8y7@gmail.com>,
	Johan Alvarado <contact@c127.dev>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 158/869] spi: spi-qpic-snand: publish the ECC context to snandc->qspi
Date: Sat,  7 Nov 2026 08:47:20 -0500
Message-ID: <20261107134857.653931579@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 919e847c061db..567485785ec96 100644
--- a/drivers/spi/spi-qpic-snand.c
+++ b/drivers/spi/spi-qpic-snand.c
@@ -391,6 +391,8 @@ static int qcom_spi_ecc_init_ctx_pipelined(struct nand_device *nand)
 	dev_dbg(snandc->dev, "ECC strength: %u bits per %u bytes\n",
 		ecc_cfg->strength, ecc_cfg->step_size);
 
+	snandc->qspi->ecc = ecc_cfg;
+
 	return 0;
 
 err_free_ecc_cfg:
@@ -407,6 +409,7 @@ static void qcom_spi_ecc_cleanup_ctx_pipelined(struct nand_device *nand)
 
 	kfree(snandc->qspi->oob_buf);
 	snandc->qspi->oob_buf = NULL;
+	snandc->qspi->ecc = NULL;
 	kfree(ecc_cfg);
 }
 
-- 
2.53.0



