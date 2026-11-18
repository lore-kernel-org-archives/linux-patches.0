Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058574;
	b=yyREwo1+w+/MbzDt5A61Ft1e9yxPaVSDUXVfMcCeVjTNtfsiFtXqZEBq/LJYTkODQtm+
	 YPvn+C7Vz9uflR2tuptM1tRAPzBLBFsEPJx8qo0DrXqfJkyBHGtrFyD+0NCUkAhwO6/WO
	 BWAHsybxl/blid7Z1rYUp7TGMx4AyF/J9BHsNeJEk4XpwZsTL03aqS3p4U7XCkGZ0pIZn
	 yBltIQTJjhD0kPLthFvJclPqoGkwm+IAfccb6yztXPCVu8c0SdWzBo678BJOPdv5RI2CA
	 TCAK0zOvOx7qnyU/mmB1a/Xigrvchx92L3zy50uSbDe6xzHXAlw94haDgNvoAygwJDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058574;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TirVivk28cbucE+Jc+lOPwbean0tKH6dTVxbHOOA6gU=;
	b=XSUb0MIRwNZ7PwynIXLmnUFdveFi1fJNhUOKUR08DUN7mrMtRUH3okQs1TLFoLQMQ1q/
	 wgCrjry0WjMhuXlZwIzt+Wmr414pRQPGC7PjZeQqyVhZi6qq3Skii7MEvn2LKQMVrTYHm
	 aCAzdlDiJVajzPKKdgrZ+M6lqSGTs6rDGRCxyjXRC81qD2kMR0EJzfNI1VBdvUq14QZWb
	 osHSRyP9jMQv/Hp44nJyTSpX/oOsqfd+TaJJLZhugOONRSlLX6ISePxRm1trO/+nQxYZe
	 EIvX74J4Olx+V4YcE3Qi3atUM3Sx+B9Jk2lVdjVW3iM/E+xtt18mVQIgjtd/6eH3Eww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oQFV+oHt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4CDF606A32A;
	Thu, 19 Nov 2026 03:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oQFV+oHt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D14671F000C4;
	Thu, 19 Nov 2026 03:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058574;
	bh=TirVivk28cbucE+Jc+lOPwbean0tKH6dTVxbHOOA6gU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oQFV+oHtkhMELpqGUZbmZ5BQGXiLuucXGh9H6jDHpKImV1OZB3tkM8uVd7CysvAuT
	 y5hhuCVKm1SPz8OV2v+kw17p7JZ1+YrFfNawSmDl7vxxeoTJd1WTd+m6Pt+pWp+pk5
	 5VG+8z+Ti3rvVdbRkBsd22uDbincMCdkiOhUufos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0494/1848] soc: fsl: dpio: Fix cleanup on IRQ registration failure
Date: Wed, 18 Nov 2026 15:42:12 +0100
Message-ID: <20261118145935.095665297@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



