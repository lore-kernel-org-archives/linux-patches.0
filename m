Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829588;
	b=TZgYJpJZydbp2603dZ5f7/hUcWbu9n1FAcjuTC8sX/7dIbPLYFWAfMAIBaB+3hoL/Eo0
	 CQ+WYbJ79B8tWG3mv1hVq+qWKHsvGkO4OgdXxZ57xoVVTrQdZzWgrVbvuWXBXAZAmQ6U2
	 KfOhD3/NiAuzY+gumrlmWkmfquFHMGn7k3dQvcGP9AwZ9/Moys2sN1uX9EGltDvG9Q5FU
	 P4eo4BNmmO06aunKgrW3xUR1we41MXmrcecrEc7W/BjKZq9RNylfb6LD7x3j47ifoTzi8
	 FNJ48u9SP7S/KIkQohTST6vftYLGubctv+CId/KA+t02tVPuq5oDtP0kNpKNHru9UMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829588;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4hX1ECn4Gz1bgo18Ti5ckwohdlX4qywwuLnsm88YT88=;
	b=bkIf2UHTWPxAG6BEAL+zWFmtGAiKGXtWY42g+E6IyGivofDUv6gvdO+XA+6mzdVEUEgg
	 ri7050yH37wXYGiaJq/0XcL142941Sjkldn3RK4jWJ4ph5sQY6//lEuIlYxuYVNFg4iIT
	 F1MoR4WqLSlXEtpv/gJXRFf7w+UvbbzW2Z5lAhvszn47GIgdEPCzm6aiIJku2GxMzK4Ji
	 mM/TrZI7EBVrRprdSJN27KZ/04coYrU3lgyd/Lr3IXYRudaSwPRVi5qVvFxOq+JZJjmbH
	 35jy5dXIk1+wrZqU4g7YjzvA3npHH/zxA53FVLty5DeLU2oNSyIH//5K1FUxrCxtz0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ugcJHhv/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F385607527E;
	Wed,  4 Nov 2026 21:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ugcJHhv/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEE7F1F00A18;
	Wed,  4 Nov 2026 21:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829588;
	bh=4hX1ECn4Gz1bgo18Ti5ckwohdlX4qywwuLnsm88YT88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ugcJHhv/OmTLEtjp6nn+eYzzYYQ6oIN+xzJ0lY1hoKXoHB+fyJXOfeu+0I9GeIt6K
	 PAR0iro6KKB6dKVB2DFyy5XpqF9IcfDOavPURmJ9umraHyKbBmYgxMyRp0J3Tm7Psp
	 xczptKq9IQVOzOVSL+Qr7qWDh7VdAR9jUylgSHCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0181/1005] comedi: dt2811: Fix sanity check in interrupt handler
Date: Wed,  4 Nov 2026 15:58:34 -0500
Message-ID: <20261104211048.852842565@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



