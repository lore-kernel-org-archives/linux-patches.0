Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051113;
	b=cSn7PqEvVC7qgEcBOqxWTWevbdncMM9mraodXK+GsIKKl9nYfu0cX3EMIPFNyvkVIbwi
	 3r3Z0n6D6FTi+dZKxuUDTpeWPOfTDFyD30NlaqkjCKQlHV42Pf+/od4AsYcp7eP342VB6
	 Dz3wbwyKK9G24Tx/FddVPCl8QhWJ0O488sX9nPFxUgv7BRQ8oIN/JJPFuVv7bIddTGImR
	 DB5VUvTTMQiqVXJW83Kd7u5jixWrpdWduVGvCIMr4ttXKM3CY7aDUf3XkhI7d23puoDx8
	 1BsdD7Gs1fnIRt3MhdTDY+0InlTTMmb5+XqXlAnqGZxa65M/5Gm1a6gAxG9RdQyIGiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051113;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tIcU7+dL+1rZVfIKQXQtAli0fZB9nCy8mD5vidPvtyg=;
	b=VbRYsL5ZHxH4O5fSPr+G5lDRbG3izKMrsdSdePRpUCdYwH4Zjcm7WWlq/ABo0XEvYA8+
	 Fdo7mCw3VwqLFnSKJ51sV05MdbnLRXA8em0JBvPmf1enD+nIwIDx88yJMhaGBuJ0vNlCj
	 NAfMTU4zD/cOjdwb9syOU5KhQP02YEMxVKda5sTQXjPbRfHJ4P6NXGec7aQqjzp4g1gtt
	 uDW5BpUuqZwV924cJ6fePqEAO4Y3CkcEVQDNScfZfZ5mQLvsPdARszOu8ic8kjTRHCtHc
	 Vqjq3hIVvh5TE+07cGYDA/rR8KoXYNgbqvzLADfm9Ctc9ce22582IDhoHzT9BImNrug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xZPp+iMp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1D06606A31C;
	Thu, 19 Nov 2026 01:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xZPp+iMp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 454CF1F000C4;
	Thu, 19 Nov 2026 01:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051112;
	bh=tIcU7+dL+1rZVfIKQXQtAli0fZB9nCy8mD5vidPvtyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xZPp+iMpBfut6R+ng8dS4nR25rawH4nUuzbNbRWw4QzRwqUNeQ0T4hHGvj7zyMJOO
	 livEkZoVRW0v+QewKGhuO/KUvxTPZXVuuvanRsSFwSFgTnNpuNlqYOiS3DyvByDVUJ
	 1eERrZtzY2VdeWQHyBJbAI28HVz96fwgIRJigbiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaeyoung Chung <jjy600901@snu.ac.kr>,
	Sangyun Kim <sangyun.kim@snu.ac.kr>,
	Kyungwook Boo <bookyungwook@gmail.com>,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0094/2214] comedi: ni_atmio16d: Add sanity check to interrupt handler
Date: Wed, 18 Nov 2026 15:29:30 +0100
Message-ID: <20261118150013.722429346@linuxfoundation.org>
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

[ Upstream commit 13f4796223489a5349b466ce54bb868f46c9fefd ]

The driver requests an interrupt handler for the device, after setting
device registers to disable interrupt generation.  The interrupt handler
should not be called prematurely unless the user-configured I/O port
base address and/or IRQ number are incorrect or the hardware is bad.

For safety, check the dev->attached flag in the interrupt handler to
ensure the device has been fully set up, avoiding a possible null
pointer dereference of dev->read_subdev.

Reported-by: Jaeyoung Chung <jjy600901@snu.ac.kr>
Link: https://lore.kernel.org/lkml/20260610115912.780131-1-jjy600901@snu.ac.kr/
Reported-by: Sangyun Kim <sangyun.kim@snu.ac.kr>
Reported-by: Kyungwook Boo <bookyungwook@gmail.com>
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://patch.msgid.link/20260618102949.26607-6-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/comedi/drivers/ni_atmio16d.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/comedi/drivers/ni_atmio16d.c b/drivers/comedi/drivers/ni_atmio16d.c
index b347878b13592..3b2e714b47249 100644
--- a/drivers/comedi/drivers/ni_atmio16d.c
+++ b/drivers/comedi/drivers/ni_atmio16d.c
@@ -224,6 +224,9 @@ static irqreturn_t atmio16d_interrupt(int irq, void *d)
 	struct comedi_subdevice *s = dev->read_subdev;
 	unsigned short val;
 
+	if (!dev->attached)
+		return IRQ_NONE;
+
 	val = inw(dev->iobase + AD_FIFO_REG);
 	comedi_buf_write_samples(s, &val, 1);
 	comedi_handle_events(dev, s);
-- 
2.53.0



