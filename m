Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029740;
	b=MpUPylh4WoN8Wv5foCFZenie8FDGfj9rWa6Nn5wzxwVMf/LuX/+/tNGODql/IExpfGox
	 /2B0L8Bf2jP20EMlZJV5d+Swgrc11CB0u2F4UNqoiIrElRfbDyVCsLOZnYb3fcd2aVsN2
	 InOYIpaPe+CrBjTUaHlbQ40bSk579NoPFl3srvf0dvo9pJtOiVTLSM0uDaiC+3Z559Ct1
	 5bxMTY0YfQMPl6bH3UJo3m2mnpan2FZMKyAQtdBy9I9On3RMd0q6Dn3iyfsKgGwY03q4F
	 V3my8TLRk3tgFfkL2ggQiM4Tg8xoW4b8NhJxASnqpPc64EnLs+MM6eHFPaudkXJeEtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029740;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4grSnu5+LnRpBhWomfcoTVHBH2k8RAA1a8XdcMcTHPw=;
	b=hZMj8Ek7M1Vy8qNu7exZmtHGVfWgTF5ve3Qn4IyareQJxXWgWj5VX5is9HBOPCIUgvmm
	 eU9p6mQoPGCgZPIB5K3u5Zgd7qRzKUjYpXVS40priDFpC7+YngHFxrvcFDHyAzVloBlgj
	 ULrOMsfTHUIpCxMLnnMObBWH5TsSKEQv7qcB6HxS8f2GpE7Zt3+YHkZ31ESPjn/NtN57V
	 UGjl+meEGYP8WJAvy0J6U8KDwnVC08WOnoJQGNC7EMpuWjYHCUK7ABAkmzKByjrhMl7Zw
	 9hIYA7QdtzbRjq39JIwYUFl9aBi/TMbuEMj6jhAGtdjL7PuB9+ZEWhpAw9KJ2KdI3Cw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ic3ISyDn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CB09606A32F;
	Wed, 18 Nov 2026 19:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ic3ISyDn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B0851F000C5;
	Wed, 18 Nov 2026 19:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029739;
	bh=4grSnu5+LnRpBhWomfcoTVHBH2k8RAA1a8XdcMcTHPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ic3ISyDnz0lQRd4ZXVDxmzRSYGsQ+KAIQkF0/3CbOQadN8/yT21o/1jxxq2kMDQm/
	 OBq/ViUHkw0UXOIgzWvSghsC8kAIlWzLGLfisf1FduFSILmFcPu1lPuE+bpca40MWy
	 Wq3H5GtwEW3SCLjoisqDMeOfvS8DnYdSziBi711g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guixin Liu <kanie@linux.alibaba.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0456/1756] cxl/pci: Skip reset detection for DVSEC emulated decoders
Date: Wed, 18 Nov 2026 15:43:03 +0100
Message-ID: <20261118150026.934338629@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Guixin Liu <kanie@linux.alibaba.com>

[ Upstream commit 17ff3a9fd8669ea53fe83a7013871f30214d5537 ]

HDM decoders are emulated from the DVSEC range registers in two cases:
(a) the component registers expose no HDM decoder capability, or (b) the
capability is present but the DVSEC ranges were the ones in use at driver
load.

After an FLR or SBR, __cxl_endpoint_decoder_reset_detected() reads the HDM
decoder Committed bit for every decoder marked enabled, emulated ones
included. In case (a) regs.hdm_decoder is NULL and the read oopses. In case
(b) the Committed bit was never set, so a reset gets reported that never
happened.

Use the absence of cxld->commit to elide the check for emulated decoders.

Case (b) tested under QEMU: a reset on an endpoint driven down the DVSEC
emulation path no longer reports a reset or strips the decoder flags.

Fixes: 934edcd436dc ("cxl: Add post-reset warning if reset results in loss of previously committed HDM decoders")
Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Link: https://lore.kernel.org/linux-cxl/20260811113608.2815625-1-kanie@linux.alibaba.com/
Link: https://patch.msgid.link/20260831110449.719086-1-kanie@linux.alibaba.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/pci.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/cxl/core/pci.c b/drivers/cxl/core/pci.c
index 6a3f2fe772bef..17157238b3156 100644
--- a/drivers/cxl/core/pci.c
+++ b/drivers/cxl/core/pci.c
@@ -700,6 +700,15 @@ static int __cxl_endpoint_decoder_reset_detected(struct device *dev, void *data)
 	if ((cxld->flags & CXL_DECODER_F_ENABLE) == 0)
 		return 0;
 
+	/*
+	 * Decoders emulated from the DVSEC range registers have no commit
+	 * callback and no HDM decoder registers to consult.
+	 */
+	if (!cxld->commit) {
+		dev_warn(dev, "DVSEC emulated decode may have been cleared by reset\n");
+		return 0;
+	}
+
 	cxlhdm = dev_get_drvdata(&port->dev);
 	hdm = cxlhdm->regs.hdm_decoder;
 	ctrl = readl(hdm + CXL_HDM_DECODER0_CTRL_OFFSET(cxld->id));
-- 
2.53.0



