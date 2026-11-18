Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036408;
	b=yFgWplfQnip8F8g/ePo4mZLRvojThbXyI7ZrKX7Pj6718JEZjffNY7a8CyVvpiNVdG//
	 3ZBBfKHKdarbYGKoYUqzhmAKjYkX2q5XNmbTJlqrXXlC4868WZaXMSZoq8QO8Jq8QKOBk
	 ql0FCfcq+qjys9UFe+80Al3IHwinXgrX67HBnM9tM36TTBN4Dn0LU6cQuN8TaH3Zrm8cT
	 E10nOenKBhSKpX1UYQMNUwU3g2g0N/ZIvUzyNSWkXSvMhneaFxE7qNpDP778TwPKtoPjN
	 8u6Zt1mqb1L3a6jJu7bE+vmsDNuMnRMay4B1QjtV9r/1bqsFCuakt1SNNXeXLjgbOrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036408;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5FXZ52Ep6Bfl+L6VF/jczUKyva2RnpIJXSGIgsie8tU=;
	b=f3J1jIJLy3PwqB3F9HrRBgxx/cxsm0l1+NPcskp5psWz9FoZkeUmLEJjI2em7xYMC8pi
	 6kxiCL7yYouQ5451z85a39XW0aPgGmsFLYvQSZs9WksLZ3Dt+mrFAQSiwZZhuqzd5pDyD
	 MhkLd4OzoLnJUPJ4JhZlyvnofvKfX81gbexZHMBGF2u+7rYIB3IE5H8nI466fwtRoIIS9
	 W9x2rDpG8UYDMolw4qhjgpg6Kr2WEUpE8NuaXU+HPVbPpOwWUAtLpdXvoq5pM04hom3aX
	 8/XZmiyU/2owkboq7Vh6HPNTsFd+xHrzFcEg1CxHx6otdFN63NsITGCebN1wVivVjjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jRWHRVck;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBC5F606A32A;
	Wed, 18 Nov 2026 21:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jRWHRVck
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BB591F000C4;
	Wed, 18 Nov 2026 21:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036408;
	bh=5FXZ52Ep6Bfl+L6VF/jczUKyva2RnpIJXSGIgsie8tU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jRWHRVckAzpQfjzh3YyFxbLPvzpsYpvn1a4dCrVTa1mYF9+ww4xD4H4HqyJjVrkU7
	 yiAQUpeJFLIe/cqp3lduymZHQ1tKajQWUqVTZ2A08W05W6dfiqLPie7KfC5nIH9Mwb
	 pPbbU9UvCx2QNqU3EwdGKqipUm7Au0MdX0217Mec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1048/3318] soc: fsl: dpio: Fix cleanup on IRQ registration failure
Date: Wed, 18 Nov 2026 15:27:50 +0100
Message-ID: <20261118150351.359515828@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 9e3fddd8f5a91..7dc65f38d2fdb 100644
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



