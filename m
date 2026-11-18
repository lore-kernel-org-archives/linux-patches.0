Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016640;
	b=a75mnUOYzeHA9dp5I7oeUkt0wVuF7ms67W+6TWddyng4tKDLkf2C6rP74OWTAE3trgNQ
	 rbu6yN/90qRnf5uwZuydjmq93u+k530rN7UaGcR1rB54+GyJ8xTRWx5LemiZmyKMTREXf
	 PCoNdxtdpIyRhHpJu0iIZmPLIN1epVeo35IGzrK+8Dn06aKAD+mE3LpZUZc4YHgHBADON
	 ZweKgT4DLTP1kozpPDkL1LzqATIrJ4Ul1Ui8ntDv4+b1BDNja5yQ0ZdsBqGakMjBwYlbE
	 z6a2/0KnvYe5mZd/80uZVoJxinDPGwvvG+nqlnuhkXB2LC5K8sXm3ON8Z+zjvYb5NbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016640;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uLuizLw4qYJj/xHrZ8lXmtoDSy6vnRK3zWaxSGfQcYw=;
	b=dV8diJlQ12uoLbPU6hVT/In/I6qxgDnEsNjddoUigd2xx7n2qKpA0178hdmjhAaxnPJE
	 SRbfdOpdaREs2ydp7ixKybhZJX2JJVddmy2l/x1IUBRsKfQHBN5JxsOP1Zn0EjJgxn/pX
	 W+rcd7qydtUJU1tGtk/72q+Nqqzc4nKyi2kPHxdWpFbQrxmrge+wV0kZzxwduYJuO+24d
	 5yPSAUvikHOrc0M58YlV1zGZlhi8ocvCKryA908ICoXhyCTYP6P8/Zsm3IGVn8KQlM5NE
	 o/+nc/megbndTN/shJfa5PQEn3oEYhvjG1O0kNHjsJve62crStT2qzyvIf94IaUwHhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XjRpo+Yv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84578606A31C;
	Wed, 18 Nov 2026 15:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XjRpo+Yv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B0811F000C4;
	Wed, 18 Nov 2026 15:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016640;
	bh=uLuizLw4qYJj/xHrZ8lXmtoDSy6vnRK3zWaxSGfQcYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XjRpo+YvOZmxY9DuKv7H8D4P97I9+P0u8+jPAm42buIhpiMDc7iMGKvN10j1M/ARX
	 uwrAEDzJskQOxZXupbn0PwqrCmFkEB7vR/n9CAaCM/7h5AlquZVOfgLCmTwhfHGIdJ
	 N4PGUqOAfIvqWf5SU63eWhvnTYFwUqXYOjAepOdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guixin Liu <kanie@linux.alibaba.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0563/2651] cxl/pci: Skip reset detection for DVSEC emulated decoders
Date: Wed, 18 Nov 2026 15:30:03 +0100
Message-ID: <20261118150308.008582437@linuxfoundation.org>
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
index bb6ad0753a421..2f90184d10689 100644
--- a/drivers/cxl/core/pci.c
+++ b/drivers/cxl/core/pci.c
@@ -683,6 +683,15 @@ static int __cxl_endpoint_decoder_reset_detected(struct device *dev, void *data)
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



