Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618495;
	b=2OJai7mjA2+jCliV5Y9nyTCOVW4OITdBChz+vIawHQ24CBU4nn3HNslwWvE5q8Ah7TKP
	 x+FLbkQTG5hcj7Y68CL3B+4D7JzvVAdtrScW32jCgwI3r1qUU+lW5F8PqPnV7oXqQQcqF
	 sJQzq6SR4UafxvZ+wBLdK6oSp+dI4ldBaxauOJ0/MKoMlAgO+fNByouXksnpAjt0MYowW
	 Bfwuwvi41eQqShYxQT4jG5iTNNqCFlglTL1OIAJf/qtu8PXsfgBQUI/n1ytivtTqtFH7I
	 5FvmI/2Ff5xEWFy+EtNOUBSM9stogXPlPY2HOw5fcNZX19Bo7acjJNbWiDEZpHm98fw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618495;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QOpCJNm9fJ+kxdBjuZWXUwBozCfv8GtozATWVTWrQno=;
	b=wBtpHxXdY8mKmldltM4kkePI0u8TRZXOesVdTGFE3s86E8hBxnpSMXsLBoEMpVs9GWMe
	 925jYA3v4jYDQkkIiBDPHlKDGZvdkFDY6vWmdu5bDGGDwxkGBal8fSh2UGcVQjUjIcWY9
	 e0oidxG18145SMb1/a1Dk1D17NSMuop7CToFROr0gzObUcoKSoW3diC/SCp3hGeThmwZi
	 PcuwRO3cfOX+r3nct5qYYCY9GMNUKhqbmVT85eLR9QemW4qTBIS5GlJXkKaewlLyN8kwh
	 GyS6+C+OdZG3Kpo4uVqtgnQJmg7yGht9K0Ah4cIFTU7N4n6C5YBK91w8XJySHCglt5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ippLrULe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3704606A31E;
	Wed, 25 Nov 2026 14:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ippLrULe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0D941F000C4;
	Wed, 25 Nov 2026 14:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618495;
	bh=QOpCJNm9fJ+kxdBjuZWXUwBozCfv8GtozATWVTWrQno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ippLrULeGGHP7vHPPKFxxC/qGm4RsEKqudQRsdXjj0aQ7PX5KhxV5p1alQ0AiVMhV
	 io7iIk3h9vzex3cHGj9MB1wRx/glRH9aLVyr9XV5H1Drvp62Ff3N6fAPCHEW3Cgymz
	 gJ+UwwOLjUvuN3uuTyzvYbl+TYBGSir3YdNL8bxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frederic Konrad <fkonrad@amd.com>,
	Srikanth Boyapally <srikanth.boyapally@amd.com>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0297/1005] spi: cadence-quadspi: Fix race between DMA completion and transfer start
Date: Wed, 25 Nov 2026 15:27:15 +0100
Message-ID: <20261125143828.691835443@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Frederic Konrad <fkonrad@amd.com>

[ Upstream commit 059518f775baecc9803fc97787bd0b17558f8047 ]

In cqspi_versal_indirect_read_dma(), the DMA transfer is started by
writing CQSPI_REG_INDIRECTRD_START_MASK to the indirect read control
register. Under certain timing conditions, the DMA completion interrupt
may be triggered and complete the transfer before the completion
structure is reinitialized.

This creates a race where the completion event is lost, causing
wait_for_completion_timeout() to time out even though the transfer has
already completed, resulting in errors such as:

  spi-nor spi0.0: CS0: operation failed with -110

Fix this by reinitializing the completion structure before starting the
DMA transfer, ensuring that any completion event generated after the
transfer begins is correctly observed.

Fixes: 1a6f854f7daa ("spi: cadence-quadspi: Add Xilinx Versal external DMA support")
Signed-off-by: Frederic Konrad <fkonrad@amd.com>
Signed-off-by: Srikanth Boyapally <srikanth.boyapally@amd.com>
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Link: https://patch.msgid.link/20261104071958.2405117-1-radhey.shyam.pandey@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-cadence-quadspi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-cadence-quadspi.c b/drivers/spi/spi-cadence-quadspi.c
index 5a5f1a852cbe8..c31e225f240a8 100644
--- a/drivers/spi/spi-cadence-quadspi.c
+++ b/drivers/spi/spi-cadence-quadspi.c
@@ -955,11 +955,11 @@ static int cqspi_versal_indirect_read_dma(struct cqspi_flash_pdata *f_pdata,
 	writel(CQSPI_REG_VERSAL_DMA_DST_CTRL_VAL,
 	       reg_base + CQSPI_REG_VERSAL_DMA_DST_CTRL);
 
+	reinit_completion(&cqspi->transfer_complete);
+
 	writel(CQSPI_REG_INDIRECTRD_START_MASK,
 	       reg_base + CQSPI_REG_INDIRECTRD);
 
-	reinit_completion(&cqspi->transfer_complete);
-
 	if (!wait_for_completion_timeout(&cqspi->transfer_complete,
 					 msecs_to_jiffies(max_t(size_t, bytes_to_dma, 500)))) {
 		ret = -ETIMEDOUT;
-- 
2.53.0



