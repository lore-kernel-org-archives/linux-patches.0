Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033752;
	b=b+YCf6EmBl8kyKhuRcbEUfTfZbgYWakUIbfhKFbdL8gSJGZuRIHAy0xN4PgScY/3EUEf
	 xpNb+v+ntotEGoS9eqrMo2gBPVkfG7vetXuizGfy16W9DH8bLzEtfX+u6daPgP6dTxHYI
	 PwjRUWjeOqpV6zKksruMP30qdcvmTOQVEbjRn9HiXxXQ7gGr+BCe3GMf0pHZKOy5L57uZ
	 IeQuWbNx8WEmb8SXN1oFmNrwvlHuB/pkVK6ncLdoSILOAhfY57yVRuCr1nrXChqTAwgr9
	 kLqKSo3mqVsJ0eu0nPqNmbceX6jRaNr4/zB/4EVkMx6DUlcaAg2R6yMmEXigDLgAk/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033752;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yENQpGMATBusCzWvgRGSZtlC4bjYCEprVrN1n/NZXSw=;
	b=4Yu9vTNJ5T6Y3De1RMsotGO5FQiaw4zLoniz7AeQNQ1V9lW1Keplb0SN6sCC3MzpISxU
	 g3hSNc9VhBZ0PX4ABDTx241sdvZ41S6VG9bXhsigYfZPfU8M/dhPSFJYJCKFA6tmGuU2f
	 rRTGyAHhp4aIpHmdqfnRxpktgBceChaBNcXy1RonaQXJr2YHM5pVYI4RMN6eVOR4fSZ5M
	 teWR9acfadBt77NubsY/CRkkPQ8hLwFlWqKi20M94IPqGAhhlzRvI3ytJdcc3U5IpMXZV
	 1VjuvsPQrZUKh9jdzl+5fZ0PLooN8nnHL12+OA614udY/rMb8vpNpRFslh+skVTqGZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mKSAwMU7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FFCA606A320;
	Wed, 18 Nov 2026 20:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mKSAwMU7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 642901F000C4;
	Wed, 18 Nov 2026 20:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033751;
	bh=yENQpGMATBusCzWvgRGSZtlC4bjYCEprVrN1n/NZXSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mKSAwMU7k2C5NGT3jgJE+mO+yFl4Q4xgTduzIqI9fM+tc/RCqxWcYp8IIN8wWYj5K
	 eTgiJLjKCcsilEEShvFKRvk/XA0wvPlZ+/b8S5wJlQNXHrG9WkdDWGqMi66WM9aaOc
	 PcWGzeXj52gmQ1PiSTIsSt661rDwVM+Ppu/ETt5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0127/3318] comedi: dt2811: Fix sanity check in interrupt handler
Date: Wed, 18 Nov 2026 15:12:29 +0100
Message-ID: <20261118150318.174479176@linuxfoundation.org>
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

[ Upstream commit 8dda63825752ab19fcbc2a19ecab91d128112415 ]

The driver requests an interrupt handler for the device, after setting
device registers to disable interrupt generation.  The interrupt handler
should not be called prematurely unless the user-configured I/O port
base address and/or IRQ number are incorrect or the hardware is bad.

For safety, the interrupt handler checks the dev->attached flag to
ensure the device is fully set up, but it currently does that after
dereferencing dev->read_subdev, which may be NULL if dev->attached is
false.  Move the check to avoid the possible null pointer dereference.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://patch.msgid.link/20260618102949.26607-4-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/comedi/drivers/dt2811.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/comedi/drivers/dt2811.c b/drivers/comedi/drivers/dt2811.c
index dbb9f38da2898..c2ec5e4fb689f 100644
--- a/drivers/comedi/drivers/dt2811.c
+++ b/drivers/comedi/drivers/dt2811.c
@@ -193,13 +193,16 @@ static irqreturn_t dt2811_interrupt(int irq, void *d)
 {
 	struct comedi_device *dev = d;
 	struct comedi_subdevice *s = dev->read_subdev;
-	struct comedi_async *async = s->async;
-	struct comedi_cmd *cmd = &async->cmd;
+	struct comedi_async *async;
+	struct comedi_cmd *cmd;
 	unsigned int status;
 
 	if (!dev->attached)
 		return IRQ_NONE;
 
+	async = s->async;
+	cmd = &async->cmd;
+
 	status = inb(dev->iobase + DT2811_ADCSR_REG);
 
 	if (status & DT2811_ADCSR_ADERROR) {
-- 
2.53.0



