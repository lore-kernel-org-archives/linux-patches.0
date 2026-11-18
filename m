Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051141;
	b=Yn/B57dGpOo+F8iNQnz75gAg1ITGsQP/PVGaLPmnwD6+GGm3XUPP4fnFjzT65CZGAs+m
	 uJyRcXwMMCCSp+KMQBc0aB66nZ9K5A4gwzfDRpT366k9pF4ARBG/wPm9CO7ZXWaJLnzlr
	 5q3fP+cVm/TlPfxdiVF0gOVJ99xBuMoCM7iD4Y6oJT1IfXlVnJjsOoL1cd4ZR2Wqo4Jl9
	 HP/TuiXE9GJ88r2NCg81hIdxw+LM+7oRhtLJCE/lUl1wpkn8z7VVuld/12IMPiekvaz3C
	 QDW1zaA2K8jZgKbLkrxMrSoeXkDmZAwcMTPbYVJhrgFSyeNs+t2rAAbfM7iiuN5PDdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051141;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GfxinZixV1GbSWtYIiT6tH3m7yHRQ0ZGB7nLr10JbP8=;
	b=xUov7bdGyZVw5SjvRGSv7YxOKcB8PtmmizpYQ/TYEEHOX7tbg4jkOn9m/KlsSLUl4fIO
	 Q0qtZLUd1a3H0ZhJEl6sZncKd2VbFFpKfMyocw3gwHLZte32jd4v7Riq5y8h/sHwlmllR
	 F+81vdMo4lLMwx/ow/Nor+60NTl6QsHPinb3BPoCqARptcAUcGP1yL9Orw/mmwNfjSXQW
	 c8niJM9t4mx3vgKXsDNAr6P/lPVmf/uQKK2zMoVn86mbuFNIE5N+peBin5MUfGa3fqI2L
	 SkSCTdStCLtrtCrjdnWfdfjG6Dzzwi3ougsxJMWr+GlTYcZ9tywIqveA0AR+ZbweSgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QzrrC1ZF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05A16606A32C;
	Thu, 19 Nov 2026 01:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QzrrC1ZF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5376C1F000C4;
	Thu, 19 Nov 2026 01:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051140;
	bh=GfxinZixV1GbSWtYIiT6tH3m7yHRQ0ZGB7nLr10JbP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QzrrC1ZFlRLCMIwI7v8+dQ3lGf1EwHFBnRV7QeXwcIlW/fQGhxurcY/PnJSfHZ59Q
	 TMGF0+WSAhFsnsrOYiCb4wXYCS2iSPEekqcXkw24SAghLLQOz/2pqYN7nEL/Ip8Pna
	 1fyFe1qOtb+ITZZHfggl88ILvSj6pEm0apkWbTwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0103/2214] comedi: pcm816: Fix sanity check in interrupt handler
Date: Wed, 18 Nov 2026 15:29:39 +0100
Message-ID: <20261118150014.050058408@linuxfoundation.org>
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

From: Ian Abbott <abbotti@mev.co.uk>

[ Upstream commit 4fdac5090ce3616283216d9a1d2b9664e8e20747 ]

The driver requests an interrupt handler for the device before it is
fully set up.

For safety, the interrupt handler checks the dev->attached flag to
ensure the device is fully set up, but it currently does that after
dereferencing the devpriv->dma pointer which may be NULL if
dev->attached is false.  Move the dereference of the devpriv->dma
pointer after dev->attached has been checked to avoid the possible null
pointer dereference.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://patch.msgid.link/20260618102949.26607-8-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/comedi/drivers/pcl816.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/comedi/drivers/pcl816.c b/drivers/comedi/drivers/pcl816.c
index c368a337a0ae0..85299d659ee8d 100644
--- a/drivers/comedi/drivers/pcl816.c
+++ b/drivers/comedi/drivers/pcl816.c
@@ -244,7 +244,7 @@ static irqreturn_t pcl816_interrupt(int irq, void *d)
 	struct comedi_subdevice *s = dev->read_subdev;
 	struct pcl816_private *devpriv = dev->private;
 	struct comedi_isadma *dma = devpriv->dma;
-	struct comedi_isadma_desc *desc = &dma->desc[dma->cur_dma];
+	struct comedi_isadma_desc *desc;
 	unsigned int nsamples;
 	unsigned int bufptr;
 
@@ -259,6 +259,7 @@ static irqreturn_t pcl816_interrupt(int irq, void *d)
 		return IRQ_HANDLED;
 	}
 
+	desc = &dma->desc[dma->cur_dma];
 	nsamples = comedi_bytes_to_samples(s, desc->size) -
 		   devpriv->ai_poll_ptr;
 	bufptr = devpriv->ai_poll_ptr;
-- 
2.53.0



