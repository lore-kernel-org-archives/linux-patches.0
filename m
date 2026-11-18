Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033763;
	b=E4xFSyr2ngiDfcupAOpa6O3xqtnGU8VM+gkgcSFWZ9Oo15fZxtGRiFVNHefpHGKaZ+3E
	 c2UKRYAT1g3ToXYoWP/fRsR4DMfHFFIthRqLX1TTdnqKqIO63DIVGZbP+BFaaKAJqIffY
	 umsNDFUcssNU7T2M2f9igbbErHWUokVpf/N5ClPS/H1ei1O2f6N1mjVQLcvy+0TdlHryB
	 ZI15ZYIznSber1rfSBr5Ce9pLRSPnFcMYOEZu56Fl/lzm4RtjHXGXdL/vQAjTlWgxofBS
	 lbiiKYg1eoG/sV4XygEKFXHveM7P8gJLAr3Szue6Fl94JMJLdTbeTiclvFKXgOYcXnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033763;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PSJPV/rDbRHCesE4+W/d7Hw5CADridF2wdwJq4mS4z4=;
	b=jJkrvWjXwA53P3FSinMPd0I5GNcfn1eEkNLUX2LtUi8ITjeKzke6KvKdWwDl4bflXtMd
	 69H2VsjSYNK5Osi/ug9jcUKDYzv7TEK/PX2PQoP6joZexOdNA+TUXYbNod5eA+zf2UvIG
	 i3XJfVRBWQiQkX+hNgkjHaMatInD9PNJU5rNSeFidFwJLzTIDvl0ZrCeONMIFw3yGI0/T
	 xoQnKaxsL8IXx2uhvL6uHoEJlvJzFOa/ZImjYoxqVtY5zshjCkG0HXTnv573cYLSdzzCh
	 wk8bReg8j/XoJXt4cQQYvwF5JSrQh5l6Mw9EZvY2QKmR0uwoSAlirqnIH4C/aFpJ0lQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aW4A0D+K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C9F060A2600;
	Wed, 18 Nov 2026 20:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aW4A0D+K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD0481F000CB;
	Wed, 18 Nov 2026 20:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033763;
	bh=PSJPV/rDbRHCesE4+W/d7Hw5CADridF2wdwJq4mS4z4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aW4A0D+KvSTkSyzRE8+tmdV83X0bhoXjcQwLJL4QSomuSPrtuBBxAwS9n6XNmj20E
	 sDRidy3B3dhjQqMIsUq4tNcuPgKrqvGUjIc5xRu6wH7R/LtLqTsFn8QzQ18TARrdm1
	 9o+SrfQMniFh0HK2cimSOSK6DAbAiLzcYIbijd6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0131/3318] comedi: pcm816: Fix sanity check in interrupt handler
Date: Wed, 18 Nov 2026 15:12:33 +0100
Message-ID: <20261118150318.319485746@linuxfoundation.org>
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
index a5e5320be648c..fc7b4ece9d115 100644
--- a/drivers/comedi/drivers/pcl816.c
+++ b/drivers/comedi/drivers/pcl816.c
@@ -242,7 +242,7 @@ static irqreturn_t pcl816_interrupt(int irq, void *d)
 	struct comedi_subdevice *s = dev->read_subdev;
 	struct pcl816_private *devpriv = dev->private;
 	struct comedi_isadma *dma = devpriv->dma;
-	struct comedi_isadma_desc *desc = &dma->desc[dma->cur_dma];
+	struct comedi_isadma_desc *desc;
 	unsigned int nsamples;
 	unsigned int bufptr;
 
@@ -257,6 +257,7 @@ static irqreturn_t pcl816_interrupt(int irq, void *d)
 		return IRQ_HANDLED;
 	}
 
+	desc = &dma->desc[dma->cur_dma];
 	nsamples = comedi_bytes_to_samples(s, desc->size) -
 		   devpriv->ai_poll_ptr;
 	bufptr = devpriv->ai_poll_ptr;
-- 
2.53.0



