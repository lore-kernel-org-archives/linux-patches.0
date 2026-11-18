Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052557;
	b=icQ5v2QapphAM2jKDGDgWFIIlt3Eu4AZcXgCL2dkgpqWcoGk7f+Rlk1P7+XWBbEU9jEt
	 7YoSYQ/sWwCejfxKIDwvKJJHzSYT2OgdgPd2bMzv88gIL5pD2NbN1UHmqRBOveqc4jcCo
	 +YM748gaiG/HJKK8T5/xBl9Ys3WweGYFJ2V0kK3/RZPnEo8UZgFJHt7+oxmuNX/KnyI4L
	 +71/WxvdhPqKR3YqnBZZ61HMBarrkj+Rf7n+TpPc3xyoF5Rr9SfSzqGCoy1SbjHDCgows
	 gjMD9i3JdGWSG+mAgvumyZN4UrTnfrcVudX8hh4ghZ3wlwAt8v1wSYmKg8oyqgyLZhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052557;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WocL6YHS4W0MJSsy7M4SKiRgd5GoFDW2vLj7+MoPlco=;
	b=a14qKJ05X7gbyB4ugt0PpRgpTnY9+Le3dnWScDfmUnnr1tDH/TMIgQBSQw/yc95SLOKn
	 6H1yZc99JSDXEoUX7LFnC/8fmEqt3SEO2DzGj6jQ5ApLHFvCpIr5WOlM6Slejal+vpFhO
	 WKP5Y2gxPaBeIHnCNb3p5xNh2VSm3fLVwsdWXn87OOzYFA71dnSVKpXPBYGoqdlDrnmFv
	 DBXl+qwfhzMztShUwob/j9WvH1nz+P4NV+hA2GVsy7uzrFl4hv9WMRd+dcQLijeH40YNG
	 uwRQjDOAAMrdNGoAXwU3iuRLoldouYYWA5mWPDZcShz3F6MuTJnvriLA8Dfqeagaruw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JOfk3yVW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD495606A31C;
	Thu, 19 Nov 2026 01:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JOfk3yVW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0455E1F000C4;
	Thu, 19 Nov 2026 01:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052557;
	bh=WocL6YHS4W0MJSsy7M4SKiRgd5GoFDW2vLj7+MoPlco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JOfk3yVWkAT+VMOtYZ82fosiY8OnFeHDVkk89KsFcg4x4u6MXMTnMut1ik+9aCpQb
	 QkM4wBwJ1lQtMALQLu4A2pwcYj/B8zOca/xCxDBJ30sBzqCCumVKV9u4X6nazUXmtY
	 FQvLXs4BXEXJ03UogsoT41ighKEih2pB159qp+oE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0605/2214] soc: fsl: dpio: Fix cleanup on IRQ registration failure
Date: Wed, 18 Nov 2026 15:38:01 +0100
Message-ID: <20261118150035.273990149@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit 45ecea8c55521d424513178fb612cefffb09a9f5 ]

IRQ registration happens after dpaa2_io_create(), but its failure path
only releases the IRQ resources and the MC portal. The I/O object stays
allocated and published in the service list and per-CPU lookup table,
while devres unmaps its portal registers after probe fails.

Call dpaa2_io_down() on IRQ registration failure to remove the object
from those lookup structures and free it. Reorder the error labels so
that a failed dpaa2_io_create() still skips this cleanup.

Remove unregister_dpio_irq_handlers() from the probe error path, since
no IRQ handler or affinity hint has been installed when registration
fails.

This issue was identified during our ongoing static-analysis research
while reviewing kernel code.

Fixes: fe8fe7723a3a ("soc: fsl: dpio: register dpio irq handlers after dpio create")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Link: https://lore.kernel.org/r/20261002194802.375497-2-mhun512@gmail.com
Signed-off-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/fsl/dpio/dpio-driver.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/soc/fsl/dpio/dpio-driver.c b/drivers/soc/fsl/dpio/dpio-driver.c
index 7f397b4ad878d..e1dd4cc0702da 100644
--- a/drivers/soc/fsl/dpio/dpio-driver.c
+++ b/drivers/soc/fsl/dpio/dpio-driver.c
@@ -248,9 +248,9 @@ static int dpaa2_dpio_probe(struct fsl_mc_device *dpio_dev)
 
 	return 0;
 
-err_dpaa2_io_create:
-	unregister_dpio_irq_handlers(dpio_dev);
 err_register_dpio_irq:
+	dpaa2_io_down(priv->io);
+err_dpaa2_io_create:
 	fsl_mc_free_irqs(dpio_dev);
 err_allocate_irqs:
 	dpio_disable(dpio_dev->mc_io, 0, dpio_dev->mc_handle);
-- 
2.53.0



