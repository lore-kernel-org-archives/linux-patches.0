Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024767;
	b=NwPc0ZjcbcIs9bt1cMZvqJF0gR14V60Rki0tHQWZI7Jw9aM5uLOyedCVYdynqDAhx3AF
	 KWbNEeWHmesN1PRwHyXXUtHi3KgoPTzmHtfo9neB9Twx6cXf4J3JojbSbt7E3beBDPX41
	 Vf4t7ToeCnZr62T2oc0KYe+sS5YCusOQF3ZotE2aRIwHPzd+CcDkMrdyuRl7njcdnLRQ9
	 QNRZhqaqgUO6BMoEuBaWbi6udJYoLxwd4FyJiLw2A+qei8QuIHRCrDFxUoi7dkuKX+rUm
	 tJ/66M9O+4/6bkmt8TA9l3ddt8ePE4wJIQYfdB4awg5tNgqpQ5De3a5PVksVSk3+QOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024767;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YvszQhPJtB5pWc8zRrQZ3fc9cpk3xO6hAhBvXM04blA=;
	b=AWFksZBb0IW8xWf2vacRQZ1ZOkrMBGLLbM3wrKDlwStsf+xLnG7JGVE7XmvKfaNl3SdP
	 cJlyYYj9dcPm20azLOHcETkY00gTEnRsFvKNO54cgjvT3MtC4u8RaVdSYGq0O8jynEfPB
	 6YRDj2TtYNYbDglDnW81raRgX/C9/ql1qehD6q5lcxYULlOjovFUUWxHpSdPh5lK+prka
	 dO5G92M6IaorydxOwN0pcmAJhNvUaQ7xvwWtXfts4lrSonNQR7oCPNo70Sx1hTt8Kg7no
	 Fhzhm4iEqrG0UzeeMgjx3CWpfEkwKxPHnpnOBzhH+7lLyFnfPNRbGOmV98jaPIG75PA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NsZghNeN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0618D606A32C;
	Wed, 18 Nov 2026 17:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NsZghNeN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CEB21F000C9;
	Wed, 18 Nov 2026 17:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024766;
	bh=YvszQhPJtB5pWc8zRrQZ3fc9cpk3xO6hAhBvXM04blA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NsZghNeN07sEnycq7gdRljQ+3c955a6jU4Fqmm1kR1YXV8zqnCZPPIGcrtqX3c8hP
	 PqJEhkgb5o3Ou86mgDz8O4xLqDe1ZjrytTJIE8xU2AbvRsthEv+ThFe5mu3XIesNAy
	 K3F+fJbYUKGYziaeedIw+lsLe6RtxABczO8f/agY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabor Juhos <j4g8y7@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0842/2151] spi: spi-qpic-snand: fix read location register usage in qcom_spi_config_cw_read()
Date: Wed, 18 Nov 2026 15:42:57 +0100
Message-ID: <20261118150152.924416315@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Gabor Juhos <j4g8y7@gmail.com>

[ Upstream commit f3c0a2b557ea87cbd802b278783c32484a063ded ]

While configuring a codeword read, the com_spi_config_cw_read()
function unconditionally schedules writing of the regular read
location registers. However these registers should be written
only if the actual codeword is not the last one.

Change the function to schedule writing of the registers corresponding
to the acual codeword only.

While at it, also drop the single-use 'reg' and 'num_cw' local variables
and use the respective values directly in order to make the code easier
to understand.

Fixes: 7304d1909080 ("spi: spi-qpic: add driver for QCOM SPI NAND flash Interface")
Signed-off-by: Gabor Juhos <j4g8y7@gmail.com>
Link: https://patch.msgid.link/20260922-qpic-snand-fix-cw_read-readloc-v1-1-67f6819fb3d7@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-qpic-snand.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/spi/spi-qpic-snand.c b/drivers/spi/spi-qpic-snand.c
index 567485785ec96..2f279516de4a9 100644
--- a/drivers/spi/spi-qpic-snand.c
+++ b/drivers/spi/spi-qpic-snand.c
@@ -486,15 +486,14 @@ static void qcom_spi_set_read_loc(struct qcom_nand_controller *snandc, int cw, i
 static void
 qcom_spi_config_cw_read(struct qcom_nand_controller *snandc, bool use_ecc, int cw)
 {
-	__le32 *reg = &snandc->regs->read_location0;
-	int num_cw = snandc->qspi->num_cw;
-
-	qcom_write_reg_dma(snandc, reg, NAND_READ_LOCATION_0, 4, NAND_BAM_NEXT_SGL);
-	if (cw == (num_cw - 1)) {
-		reg = &snandc->regs->read_location_last0;
-		qcom_write_reg_dma(snandc, reg, NAND_READ_LOCATION_LAST_CW_0, 4,
+	if (cw == (snandc->qspi->num_cw - 1))
+		qcom_write_reg_dma(snandc, &snandc->regs->read_location_last0,
+				   NAND_READ_LOCATION_LAST_CW_0, 4,
+				   NAND_BAM_NEXT_SGL);
+	else
+		qcom_write_reg_dma(snandc, &snandc->regs->read_location0,
+				   NAND_READ_LOCATION_0, 4,
 				   NAND_BAM_NEXT_SGL);
-	}
 
 	qcom_write_reg_dma(snandc, &snandc->regs->cmd, NAND_FLASH_CMD, 1, NAND_BAM_NEXT_SGL);
 	qcom_write_reg_dma(snandc, &snandc->regs->exec, NAND_EXEC_CMD, 1, NAND_BAM_NEXT_SGL);
-- 
2.53.0



