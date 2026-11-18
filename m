Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051144;
	b=QtYiFt3QjNY2/BBHnZNNDrmV6X5qbl+s0wGFdaCjU7kzilHlqGNEIQO74RVWsCR9gnJ2
	 +CRXr/tZgxlXt2lELPq5m2xRPOQqVgF5v4+GzRFzvYMLs76GkWDoz4GtQlBtmisN4ritL
	 325cRo0vzac6hd4chMhx8x2KSmLhH4mSIUVsQHX5EG/+dfBPgxLZ8w6zMEPcbKEbNWHIT
	 jBB9urNExWpiwf8EWdflLGwhdVQmvhvbpkXplglD7jkm9x1gKiFRe8sD1pJK0pZGj5dgm
	 +rawhpjw2/4fvwFkhJmY76RSQuqTJb84dn+Msjwk/lQCStIyyLYnNwsmhmCodyMeH8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051144;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XWxnPxAhGOQ5yBbzG/qoSC0ccRM5SfoRvdfGNYgbJSI=;
	b=qPFYxrwaMn50QxKM5IgM+uHCiABhWbD1A44ZrF4e5S9KDHAI023ETSL2clseIY80oiNm
	 bmVKEf4bxsENJOsdG6FwMwhxNEAyl0yc9aYIlqA9TRdwza8kbDe/WBM1xfXFyjEkzmkrV
	 oY3QuQTr1gkjRRpTVbJyQ9KwA+ChNpBN8TbsUWvj2OeRRwfIkFLNibYpDgXLFtssOIiyv
	 /Rt0TGRSCiASP9NBuRXAEKxf+45foM4dFNUonfmnazk/Vb7hwqtMM/sEv2p1Q9jM7vRRn
	 Yn0Sd9+eKcCcLnuqDePwFzofZq6y4jVaaXMuGsbMGqkaSA57iDon/s1K9yDf8Bybuxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=am+TQNUy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 285A1606A330;
	Thu, 19 Nov 2026 01:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=am+TQNUy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35F241F000C4;
	Thu, 19 Nov 2026 01:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051143;
	bh=XWxnPxAhGOQ5yBbzG/qoSC0ccRM5SfoRvdfGNYgbJSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=am+TQNUy89W2eNnLONqQxu0Z+JVQJE/hBXF2LVVeQn+OwmbgVVaqQKng6xP66oezl
	 ADd/Mf8My9MkDX5ih/mZg5oOJbDyCYFiZKy3Li4xnruT6OHvuW8UrpklZWOduLzCPq
	 7PhhDg8xgb+cYudhbc5yRtgfL4ed7e74/vVBK2Ck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0104/2214] comedi: pcmuio: Add sanity check to interrupt handler
Date: Wed, 18 Nov 2026 15:29:40 +0100
Message-ID: <20261118150014.085852825@linuxfoundation.org>
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

[ Upstream commit 6f6f6644e011fa910db744e9978127a443b94001 ]

The driver requests an interrupt handler for the device, after setting
device registers to disable interrupt generation.  The interrupt handler
should not be called prematurely unless the user-configured I/O port
base address and/or IRQ number are incorrect or the hardware is bad.

For safety, check the dev->attached flag in the interrupt handler
pcmuio_interrupt() to ensure the device has been fully set up, avoiding
a possible null pointer dereference of dev->subdevices by
pcmuio_handle_asic_interrupt().

Also make use of the IRQ_HANDLED(x) macro for the normal return path of
the interrupt handler.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://patch.msgid.link/20260618102949.26607-11-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/comedi/drivers/pcmuio.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/comedi/drivers/pcmuio.c b/drivers/comedi/drivers/pcmuio.c
index b299d648a0eb6..ae12a70534151 100644
--- a/drivers/comedi/drivers/pcmuio.c
+++ b/drivers/comedi/drivers/pcmuio.c
@@ -363,12 +363,15 @@ static irqreturn_t pcmuio_interrupt(int irq, void *d)
 	struct pcmuio_private *devpriv = dev->private;
 	int handled = 0;
 
+	if (!dev->attached)
+		return IRQ_NONE;
+
 	if (irq == dev->irq)
 		handled += pcmuio_handle_asic_interrupt(dev, 0);
 	if (irq == devpriv->irq2)
 		handled += pcmuio_handle_asic_interrupt(dev, 1);
 
-	return handled ? IRQ_HANDLED : IRQ_NONE;
+	return IRQ_RETVAL(handled);
 }
 
 /* chip->spinlock is already locked */
-- 
2.53.0



