Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 262691D6DB5;
	Mon, 13 Apr 2026 16:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096228; cv=none; b=KwlmCPilCsQyOTO4erfYgWsBJQq4+g2YzBTIBtEmBCz5yG34By8l9m7t3zOH8U/2Kf1n8RkfJUs3nbPPMXCZNAEu9ULtTxcJDa8Nylc74Av6FkLD1UpxiBn3Vxqocmpn0/kkn9647oV4g17kbopYyt2d736QHM4ujYJjKHSjcy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096228; c=relaxed/simple;
	bh=Fsf1Kb4zTZiDJ7lZYR5uXeHOug8n9fDv9iFpI2hBGNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fmrjWCdhiiBvBSMNirh8VD0AZAQQQYXgGakibgNhXjwSEx47Tjm3FhAQ5m7SyWekuFuNVPJLIc/vl5paqYWcoMPUL154uMfKj6rrdq/dh6bPUHMMsOdutw+Ov1ZFLsyTjHWI+CyGL+xxYEZnwQCnILIngwdJk2+o4e273iAHYfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JBLXAkIL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JBLXAkIL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87628C2BCAF;
	Mon, 13 Apr 2026 16:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096227;
	bh=Fsf1Kb4zTZiDJ7lZYR5uXeHOug8n9fDv9iFpI2hBGNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JBLXAkILFtdTBRLAlfKiRz/lmsIK/8XDhd9eebKK/zEPjOt4uNTFsnviHCLKkBBJd
	 eBONejT2XHGyQGKCkte3IlrGx1p+mgMgBcqXhI7f86OMycc8YOipbBGrxZVsKOik82
	 tia0soRsua/pWDggyagOsPSIF2Q0fsI2cVFxnTLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anthony Pighin <anthony.pighin@nokia.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.19 17/86] i2c: imx: zero-initialize dma_slave_config for eDMA
Date: Mon, 13 Apr 2026 17:59:24 +0200
Message-ID: <20260413155732.222848327@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155731.568515178@linuxfoundation.org>
References: <20260413155731.568515178@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anthony Pighin <anthony.pighin@nokia.com>

commit 39ed7d89b973329cc5c764b65ba6302b17b1907e upstream.

commit 66d88e16f204 ("dmaengine: fsl-edma: read/write multiple registers
in cyclic transactions") causes fsl_edma_fill_tcd() to read
dst_port_window_size and src_port_window_size when building transfer
control descriptors.

Initialize the structure so unset fields are explicitly zero.

Fixes: 66d88e16f204 ("dmaengine: fsl-edma: read/write multiple registers in cyclic transactions")
Signed-off-by: Anthony Pighin <anthony.pighin@nokia.com>
Cc: <stable@vger.kernel.org> # v6.14+
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20260331182632.888110-1-anthony.pighin@nokia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-imx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-imx.c
+++ b/drivers/i2c/busses/i2c-imx.c
@@ -401,7 +401,7 @@ static void i2c_imx_reset_regs(struct im
 static int i2c_imx_dma_request(struct imx_i2c_struct *i2c_imx, dma_addr_t phy_addr)
 {
 	struct imx_i2c_dma *dma;
-	struct dma_slave_config dma_sconfig;
+	struct dma_slave_config dma_sconfig = {};
 	struct device *dev = i2c_imx->adapter.dev.parent;
 	int ret;
 


