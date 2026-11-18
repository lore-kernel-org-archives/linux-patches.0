Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057329;
	b=gaU3zX7EDLM/FB6hOh3XVbRBVCcW7oPJ5N/Lt8q9YGnauqhlwouJ+9YtDxet2P46kxDQ
	 gNjgSqcnOvuz1o+xUFxS81cvTl4nLp3GLksx72WrPIjPBhpRUkooUjowkcpwmy6fmGrAE
	 fGZ3yHZoQU+Ppn/vp+aj92HaJXZ+knxHfqEqAw4aBZY6iXbWp5Tr9gF56qNuOXrR1ttr6
	 mzK6FiOnFvvMtOzp1C6EoZ5zzleGmS/eo9B7I3mE8Q/8iNBMfcxSUpmLBXwKCb3iobmYL
	 +/Xl1b243LzJ5V59GAv4RZNanM/Ns90cHjwbZNbZqBPdnGPIrXD/s/mqenYZ0XR1zyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057329;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8Sk2x50EMS2C2uhmM/z7QnERF6fZZHBBII9KTPmYM/U=;
	b=Ozt0zYAZTnGy6cZG32UtGgLwXOAAUR6/MUyvJNkE10aiUEVU8eKqkstfrtLTijcrKjBH
	 vGcTNZek/YkpXGs/X4w1H3d8eBsi5m2VPiz90aF6mIJtX+EeDm7X6vuSuViKWDxexk8TF
	 Tqeq4uNMyCnGJqxUaGtdSKS2Sdc/+p/qF0VmmXx6jm14czC2YaaMqYlTCDpfchzdgbsLh
	 IJfBtWcfunJT6Q8DegiPAttBrovuCATTFpR90e02Ux+GtKYbOZIk3cnCzXmV4Cos2WD9E
	 DvylMkT5zd9mpP0IMA4nv3C5t9BlaKkw7Xm5JEoG/HgVuVKpyo9yHM1a4zAPbWE839w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pKZgFouB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 216AF60A2609;
	Thu, 19 Nov 2026 03:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pKZgFouB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C50C1F000C5;
	Thu, 19 Nov 2026 03:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057328;
	bh=8Sk2x50EMS2C2uhmM/z7QnERF6fZZHBBII9KTPmYM/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pKZgFouB9mGiSCGPpaTsFn6hwnbI3PT0IybJ2nAwct5N0qrFb4/Yk/uN8vqEMhOh8
	 TEsuKVjhhGeLicYj842j5XKl0eWAecy1klLIcJXQY6UJHXt17AqmVJC56PZr6xZjez
	 dTpaCJa1kqfgDyKedGzckcEKh9HBR0Hq4xmPa63A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0090/1848] comedi: pcm816: Fix sanity check in interrupt handler
Date: Wed, 18 Nov 2026 15:35:28 +0100
Message-ID: <20261118145914.901748508@linuxfoundation.org>
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
 drivers/staging/comedi/drivers/pcl816.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/pcl816.c b/drivers/staging/comedi/drivers/pcl816.c
index c368a337a0ae0..85299d659ee8d 100644
--- a/drivers/staging/comedi/drivers/pcl816.c
+++ b/drivers/staging/comedi/drivers/pcl816.c
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



