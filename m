Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043164;
	b=0KP0xWS1P3J2V2ma5/co+9qqxQem14bjqzdEglTHztA5YVSgH+Hjf/EdCqFqZawnZ0uq
	 BFg4nbsPLKrVSl25HZnT4bJHLUTti7gAPoQehUZCaXS7yUtyiaINKMsgTpLNeoR7Bx4Ax
	 4vMKbe2B9GW867eQBQiA++KpyrXHucaIz+7DZH2N4Hktkp7Bc4Ps2I5RD1ahwvvSMRSMj
	 PxAlRbpNlUMEaRIj/WSDBfHSr92B2bJs6fcijWCccyaC8JjJI1H3JRITd7yXn4ARUGLEa
	 7d3ZgpotQyE5I6HUjRIb3s+Z+m6zQHdA503Y2/bNRLFibIiD3mxSjrUxbqD1mM9hnRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043164;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uUoKP7Gg0tLDqdp7MGPL//Mwo4KUX1YtYeYFEzNt5qE=;
	b=nitzI7JcJaVju1KPP2U8ZFVtoNkBrJg11BQciL1xaZ0TtHXzQgnEbm4g/L5FjIuDnQP6
	 CFW/ynmalmQRCNmeN6LIi/T4+2W9veZmxyo00hieTkXMxNuCRmBB5SGdw9sDL7I65SNIw
	 /OqWDUNRrlI3vd0os9FpsQIq9KxlSW0uJIny0h458l6LJcgi4pg0XIM+X25jreCZmGGWR
	 EFheWTusE4t1v/PAEVXBeK/xpVLfXtvRinm1uF+/Gmg5U/GIeqIh1xfijl+5EiJU2OPOY
	 P1uufq36wpt/2lKQAEJ6HjCam6jJeFZfLfccsOrBnfRI3WnvfdozsMbv6oa6b7sO+ww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AEadJgEe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96C03606A32C;
	Wed, 18 Nov 2026 23:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AEadJgEe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1DCD1F000C4;
	Wed, 18 Nov 2026 23:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043164;
	bh=uUoKP7Gg0tLDqdp7MGPL//Mwo4KUX1YtYeYFEzNt5qE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AEadJgEeXEL4lPgr4svx6lRTI/iVDcB0/iNkRCj6nOigLWAhFvHMi+0nAthFPgtG2
	 aTvBhCAZSXegDyK68uWXW1MzIhtGxKImuJgjxtDmZpGxmzp1ha06QWeOkQ1JEzRA8v
	 KURhus6GoUl9NJmn0vvap9e32kL6eMPxHIiC7nV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0114/2857] comedi: pcmuio: Add sanity check to interrupt handler
Date: Wed, 18 Nov 2026 15:19:08 +0100
Message-ID: <20261118150205.466505031@linuxfoundation.org>
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



