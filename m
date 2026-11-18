Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017732;
	b=3VZxNM/gazp4fqLFwDmEuGcUtDEpMDWYmg82FRUSgTruFUVglZ7mrhEspXeQhjUe4kVs
	 Z+nD96l+895t/OwZb3SStLK33SJ2jOUgabGvMbd5rzXFKlQsuj3DvflRt9BNdlbTQCMck
	 f7pg5CkzHwk3Mves9d9A/SC0KDrjzlMHAqAJEgeMAtaQP+KLz8xxm0jwW1CHvPmlRtJOS
	 wNyMApjEkrG+noKl4Qk104v1PEHEV86kH7646ZSc/kCGPxUP19nNb2CPwBgmItxGknRFn
	 iUDEDP7H+mW6u5QQ0sQRkVdVbV/+ZBWkTEzzqcX0mChc3uUJDA8oQpVq5W5XqFGM/OA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017732;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=K0MNhl+MHLTqk99RyfkX7jhOCynkOjL3J4zomgONkk0=;
	b=M2BouqmKhtHv/OlAbJs/hFyyDZazifSyDqFsdaCPp/jUfW26sN8yhxl5Xkf+s+1lryIq
	 yxAMAZuN1hh5skeU+8UuXz+Nskr6ovccYRBULtJhMMFRXH+yl/cuLu5K7oD2oHXZWIEs+
	 cMm66OO4+ZdZsA7X7ghMJ0EC9qklTXadRqO3+8TCzHupPg/0t/oZJjO8+PG8+VV5UGpQm
	 xZphcmWBxFL20J0fJeQwb5/0DIJv8lWqO3mURcQjjuJJ2UXUjTAdFfmmDzvgdUvM0WKEy
	 UUEF5n88JiWFvq0WbRVs5YZ4+2Cg1OfRyexz4pq2YzVFeGAEkbCpK0yAltcd3lXqnJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G8qAq0HG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2B12606A31C;
	Wed, 18 Nov 2026 16:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G8qAq0HG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E6421F000C4;
	Wed, 18 Nov 2026 16:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017731;
	bh=K0MNhl+MHLTqk99RyfkX7jhOCynkOjL3J4zomgONkk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G8qAq0HGgEo9CUESgiokS8TptEOw/nAmO+8pGYeC+520C+1tfBDTLpI7PYzNDQ/UW
	 XXTMjTc8N3k7VoACUZkdBWZ1+3eet9WabYDh+skA7odKRcmlRfdP8nm7WZWHzmcXY6
	 pbzi72sZG916J0raXIPx6k55G+O3dd3CTUe229qY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabor Juhos <j4g8y7@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0988/2651] spi: spi-qpic-snand: fix read location register usage in qcom_spi_config_cw_read()
Date: Wed, 18 Nov 2026 15:37:08 +0100
Message-ID: <20261118150323.471158048@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index ae4a3f2a35e1c..684c3b9486b77 100644
--- a/drivers/spi/spi-qpic-snand.c
+++ b/drivers/spi/spi-qpic-snand.c
@@ -506,15 +506,14 @@ static void qcom_spi_set_read_loc(struct qcom_nand_controller *snandc, int cw, i
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



