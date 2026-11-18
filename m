Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045398;
	b=Rg3i08CuPOb93aUa3lCJMqM3/mdMzYHt/X3tJtGZNj9swPXwyAfototRfdpc5nzjlPcX
	 fxLtmSd5Hz9FVKFfajhA8gKS+r0OeYQG1kU93BLCCfZiBBw4icGW0xbS1nr+jhV67TOYl
	 uxkWa5iLhfLQ/PH7I/2ak5LFqShJw0PUaFD2PoxlqHYev0njzyExOdUkD4Iuv2kdV/Oe/
	 3iSaQpjI4Ra3n93clTEQug4GpuWzUJHCpvjxjWxibY0SRw3g5BVG2bOpai34S09jxyZke
	 Lf4epZDk3on1Ys1+p4gCMdg9C6Mt9DoCd578qpJL0UhevqxFfiaZ8taWKhWR49AMx4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045398;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kfj93hJvpYLXX6LTc/df5zVN/O47p8x23bj+O0VfNcc=;
	b=f5gOilXGetGt/q4Mskq5ovb5IjuMRAJxDHDzt24o1TbmaB/uq9SkxmUq29uQvGTvOJ0r
	 90CFaQf91yVba6Mfum/WW4oHGCIcmSHuHvKPBQwrhosoDPU1hZLafRLnjTTgnYJuQarqT
	 Xv2XPRQNSNGknC+NXvNU7JWJofIGM0qzEYiGTu4Iv3ZGqfsXqNjORi/vT0vEtnbTBVMhS
	 iYVeSwgd7rGi1Ajfg5oeoOYYBNuy3/b9STMN8+eDmL4aKHhWGtaewLIQgMrKb+JZ7b7a+
	 UKq61eGH/wC/LbdEJUtFAOSXohhcBpS0wkHsesebqayW8jyZCokoSWtC2CZFx+fXS2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mgXuAmKP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BB4C606A31C;
	Wed, 18 Nov 2026 23:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mgXuAmKP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80E4F1F000C4;
	Wed, 18 Nov 2026 23:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045398;
	bh=kfj93hJvpYLXX6LTc/df5zVN/O47p8x23bj+O0VfNcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mgXuAmKPpm5KImSPVWdwFuPkWXDpR58xp9WD0OO49GeQynLVjyfTVpV6wf/WQltHW
	 pOMryu2Eg5gj+j6MSX8q/Wn9Utc2/qc6aTfLnck0eYwpHnqVJ3oIe4rk9xm7QPRljQ
	 eRe4zydWc+V0ND/nRrTEQMgL+AgKQJ5x03JdOJmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0909/2857] soc: fsl: dpio: Fix cleanup on IRQ registration failure
Date: Wed, 18 Nov 2026 15:32:23 +0100
Message-ID: <20261118150234.304025228@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5a2edc48dd797..310e241020481 100644
--- a/drivers/soc/fsl/dpio/dpio-driver.c
+++ b/drivers/soc/fsl/dpio/dpio-driver.c
@@ -249,9 +249,9 @@ static int dpaa2_dpio_probe(struct fsl_mc_device *dpio_dev)
 
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



