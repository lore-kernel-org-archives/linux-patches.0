Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CF693D9025;
	Wed,  8 Apr 2026 18:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673725; cv=none; b=ETlWtdysAu0F1svC77c5+JV0dKw4aiRLFUtLYpOHutzFm6LHAxJIziKnoqeqr4cVm1RHWSzpCCZpT+hC/4E4Q3TYNdN2z6WKL6OsasSR9M/yBaQjfwhPCUDTj3Nw4k1lEhtYoeH41KK7ViMb2u61bQ1p1iLy4b4BOq2Ax2t5/i0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673725; c=relaxed/simple;
	bh=ZDRQlG8FvU+U/l/MSbQVold6YziuSPJoDbD0hMwFeWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=skw0BLoep6msW2dmCjAsHNw3NTJSgiSuvBBF2bgZa1EfzMUazkzR6j6Nb/a3Fg7s5M0rGUijxSOB0nUbsMBlteqC+QgI41zsD6v29AuD3RPC4N0tsRA9doAF0BACroy8kP6HtxjY6SFOlDyiV0XGVmS4V/sNid9WWvqN4H1Wyco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kMVRTap5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kMVRTap5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90D06C19421;
	Wed,  8 Apr 2026 18:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673724;
	bh=ZDRQlG8FvU+U/l/MSbQVold6YziuSPJoDbD0hMwFeWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kMVRTap5kNqlA78517pAid9YlBp4W/qPesymPplZ/tGfrI7+asmDYXYw3kajGB777
	 ndOEdZ9brWn5W9S6nz6aAcl9mqasYAsDXrA8ZpwKse2r/4q3fRbNE2zPLogvZ1C0ts
	 8L9IWVnp07c2fZiGPRtA4jLlf0upxgGkDVkZ8lrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suraj Gupta <suraj.gupta2@amd.com>,
	Sean Anderson <sean.anderson@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 064/242] net: xilinx: axienet: Correct BD length masks to match AXIDMA IP spec
Date: Wed,  8 Apr 2026 20:01:44 +0200
Message-ID: <20260408175929.477079729@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suraj Gupta <suraj.gupta2@amd.com>

[ Upstream commit 393e0b4f178ec7fce1141dacc3304e3607a92ee9 ]

The XAXIDMA_BD_CTRL_LENGTH_MASK and XAXIDMA_BD_STS_ACTUAL_LEN_MASK
macros were defined as 0x007FFFFF (23 bits), but the AXI DMA IP
product guide (PG021) specifies the buffer length field as bits 25:0
(26 bits). Update both masks to match the IP documentation.

In practice this had no functional impact, since Ethernet frames are
far smaller than 2^23 bytes and the extra bits were always zero, but
the masks should still reflect the hardware specification.

Fixes: 8a3b7a252dca ("drivers/net/ethernet/xilinx: added Xilinx AXI Ethernet driver")
Signed-off-by: Suraj Gupta <suraj.gupta2@amd.com>
Reviewed-by: Sean Anderson <sean.anderson@linux.dev>
Link: https://patch.msgid.link/20260327073238.134948-2-suraj.gupta2@amd.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xilinx/xilinx_axienet.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h b/drivers/net/ethernet/xilinx/xilinx_axienet.h
index d64b8abcf0186..cbdca0fb89454 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet.h
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet.h
@@ -104,7 +104,7 @@
 #define XAXIDMA_BD_HAS_DRE_MASK		0xF00 /* Whether has DRE mask */
 #define XAXIDMA_BD_WORDLEN_MASK		0xFF /* Whether has DRE mask */
 
-#define XAXIDMA_BD_CTRL_LENGTH_MASK	0x007FFFFF /* Requested len */
+#define XAXIDMA_BD_CTRL_LENGTH_MASK	GENMASK(25, 0) /* Requested len */
 #define XAXIDMA_BD_CTRL_TXSOF_MASK	0x08000000 /* First tx packet */
 #define XAXIDMA_BD_CTRL_TXEOF_MASK	0x04000000 /* Last tx packet */
 #define XAXIDMA_BD_CTRL_ALL_MASK	0x0C000000 /* All control bits */
@@ -130,7 +130,7 @@
 #define XAXIDMA_BD_CTRL_TXEOF_MASK	0x04000000 /* Last tx packet */
 #define XAXIDMA_BD_CTRL_ALL_MASK	0x0C000000 /* All control bits */
 
-#define XAXIDMA_BD_STS_ACTUAL_LEN_MASK	0x007FFFFF /* Actual len */
+#define XAXIDMA_BD_STS_ACTUAL_LEN_MASK	GENMASK(25, 0) /* Actual len */
 #define XAXIDMA_BD_STS_COMPLETE_MASK	0x80000000 /* Completed */
 #define XAXIDMA_BD_STS_DEC_ERR_MASK	0x40000000 /* Decode error */
 #define XAXIDMA_BD_STS_SLV_ERR_MASK	0x20000000 /* Slave error */
-- 
2.53.0



