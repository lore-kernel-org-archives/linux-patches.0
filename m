Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023838;
	b=Jo3Wz3w/FHZf6KKqbcsZJpiFPmsvKNt0zEqkSQiSpqkDHhuT+vKwLgNcmLjrBTs/pmZ0
	 g70QTbbYIRwYLI1FIH0qjOb3zsj9mTDsAoNhe2wtF0dpgU7Tmj53j7j/9ilSV75qQYRX0
	 jSoaFaXhNixDj7atbH5dolsc6jdbNbcl3e3K4epcv7g7hEZPOwjVdPDtuZAfkiddVMu6l
	 UQ8FmB5qM9pGWuYtI4vyK4Yns7+eer+jCzbtmhiA5DMp5H021Np3VneVttnbTMJVs3Lsx
	 cv4XTthdUzmklNmcF4GhsT/IFIrLheiywmA623VYer2iqNZtJWBXS9sSV8PqlFrj0cg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023838;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NzYgi4a2ETds4vU6CwMbQ2GqOvmoJ9CSsXie/ZlzMcE=;
	b=fO96pNyis0OYMaX37Aykx4WbTp3ST65Ewj45SBhP4bXne2FZGTGSO5PjOUuNmZ9y0Fcq
	 V4T2khc7P4d4uRTLb2jtrA97I/ZmIpE+EfgcUDvnmiTGNcOyhoW0XNYLF7wLK0Tfphq6G
	 /A3y+BuW6dfd/gXtVb6uXBbtPV9l9hHX1mNyFpkOEx1hOxDNZ9Yv7ExpJq7LadqqVXXyB
	 ZwEnaDgeUxb9FB9+ELrydV5qHul5A8uQk8bKZY1Cjp8FHRmc6+8vKojZOL/TuHO1sjuue
	 MtOsAEYr3FHOCLhZqqZFQ7523WfkbX7TfBPbSDo1l5GJRVopbgoU3ZkUDOMN73EMFAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s5AEE2O6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BCBD606A31C;
	Wed, 18 Nov 2026 17:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s5AEE2O6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6D921F000C5;
	Wed, 18 Nov 2026 17:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023838;
	bh=NzYgi4a2ETds4vU6CwMbQ2GqOvmoJ9CSsXie/ZlzMcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s5AEE2O6Fu3zZM0Pf5aflyemDpAmPwpJV9CKFoSrM0MUFOAaenHAlOywaJw1DX95j
	 qaeLoxWPRBTRpfzcNQ6BLvdWcS9vGsErVwe9Jvkd10C7hDpPCPfbSggdxmOKo+DuPt
	 QcxhUA5kRkeTLAR3FBqiFOxk7xWst1FZ8mDWSM20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guixin Liu <kanie@linux.alibaba.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0510/2151] cxl/pci: Skip reset detection for DVSEC emulated decoders
Date: Wed, 18 Nov 2026 15:37:25 +0100
Message-ID: <20261118150140.629480548@linuxfoundation.org>
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
index d2ee7d853f1fd..e1c2e30069fcc 100644
--- a/drivers/cxl/core/pci.c
+++ b/drivers/cxl/core/pci.c
@@ -761,6 +761,15 @@ static int __cxl_endpoint_decoder_reset_detected(struct device *dev, void *data)
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



