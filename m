Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033766;
	b=ZNov7nJ1/4ovWuGd6DSojWtVI3EGNbhbCU0NGkR+HQDpS3WymID9HD4Cuhkoz0ei8A0z
	 wN3yv+x/zT8lBdT+G7HvfouyO49FNLRCya2hkaOCXLT0FMl1RyTmRJNBzcacA/ARF1Rqn
	 O/ojR3cLLmK6e6gUg3h5/ptbkCbkYbeM5dG6be1FGETiX7gWrAOKGyzct15MuoomlUWgf
	 cMNGVVtTfQ04w2W72cAFdgBxG/jkmo7UzrsMdaRiKOscIgDL/ekHNN6Umo1RgK7DNZTQz
	 2ojhZS331ZlUh3MAsX0Il+y0aU04aM8uqTz3JCwd4B3FsPEGmkyx3W9UCkq/cz1U3HQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033766;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UGNmZuQ3rIb6S9F0GDrP7aGUIyjhwdFqhBOyOsY4z3U=;
	b=NbgWGuAnpZiCmzIbgNOFnEf4QqrPb2/zZa98vng/L7LQyD6vM8dXrZnnlj1DHGi97mak
	 CEEH4ZnNJQuu0ejhnEv3R5lrebzL5y9ULULi50X2LW51l8ZYHhDKsos12QmnloLw9cAOf
	 +eXAIfoatfd2vKzyDisNfTUYsWJ3LuoQ+gnJsN5CQr3HTS0Znv2ZMjqF2Z2MgHwfWGTO2
	 CaYr4+2wUksU0R18VQ++Y8F4cNq9UkNDPlLnfQ6cTUA/t4m8LCObjhzEdTWscH5wcfObI
	 FiyaB+XKsmT+NlUhE06ibl8c3B1gJZUFQvMaGhJTG/Gtjen8yv6BFaspcm5F1aU1uNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xc7zHLEf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DEF3606A320;
	Wed, 18 Nov 2026 20:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xc7zHLEf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E6661F000C4;
	Wed, 18 Nov 2026 20:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033766;
	bh=UGNmZuQ3rIb6S9F0GDrP7aGUIyjhwdFqhBOyOsY4z3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xc7zHLEf+6klyLMltFORJcfPPIzvILqpneVLdbs9YcA44ggXYUVJ76lpXaVUT9+4p
	 +ru/DcTNsPObi+gjeJAAQraq8mf8wfuwPqAgANxmUHchupwrJZ2RKHAQ5qvklcEj0I
	 WE40Kd5nI8g3J5/jW+bgdWFltgWVM5vAaKVuOh+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0132/3318] comedi: pcmuio: Add sanity check to interrupt handler
Date: Wed, 18 Nov 2026 15:12:34 +0100
Message-ID: <20261118150318.358305020@linuxfoundation.org>
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
index 33b24dbbb9199..1c5fe065a91f5 100644
--- a/drivers/comedi/drivers/pcmuio.c
+++ b/drivers/comedi/drivers/pcmuio.c
@@ -362,12 +362,15 @@ static irqreturn_t pcmuio_interrupt(int irq, void *d)
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



