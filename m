Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829564;
	b=oZurqc34E7aVlByxfKL/WFXzSHahZjTRW/AIjhjvIkwQX8hUkm9dcQF+tu3x4kHV6gAS
	 USK+3b6EZJbsHPaeMlJwFTdjF0+wvdadh4Fwg4ZX4/iUytphSbyNIiew8qatFW1c+tgaN
	 BW1gIKLO38Nkp65rezEdAo8OyA4AJil4PRg1GkP7lCsuQPXJF3WyEaIUzhjnircRhuD0O
	 O/aljxIWhtO+t1K0n4kvQSmDC3G9YILAFZy0aNiKp4VQJWif+Lq+MO9sGiCnc1NmenBAK
	 ScZk8cUD7pKne+53B/9L5hX8OXVs7mwALpBVLiBJTfdcFmZpERHto/YgS4Ay4cZGDNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829564;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qJ8YSbv4QI+ZxUIiiWeYJj/6ZlJHBZJAHga+kCDwPvo=;
	b=fgzHp/uJcN305BMz1BT9sFTtKjJ9tWVOSZbSfEbjg591TGtiVcnRZuI55KMPfIRPMnal
	 VXavLP8MulWcooMv6F7B2MHxAYAQzhoTt/ixyPTGLs/Crd+0gz9CRG+WUgIXGNGwD2Wvu
	 ZJWmFAcVnO7NIQ5tqiZYMPFUvehUiDHliCC4h/BXaGHsR7+fP4OCXsB3GheDfaAW46auC
	 Z0mc8nVDcTyj9a2iNrXMj85oYXohGY6j+gH+C9PkTNaJWYwdidF2HOWbfjVSqSRHNPvOM
	 LIG7bz0yr0Eo66C1kCljW+qOuRWvnOq7Wt4WQFopJ15H6e2bgD/TOI8L/9+LJSl9aJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uLxNDDUe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53776606A33E;
	Wed,  4 Nov 2026 21:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uLxNDDUe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7E4C1F00A17;
	Wed,  4 Nov 2026 21:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829564;
	bh=qJ8YSbv4QI+ZxUIiiWeYJj/6ZlJHBZJAHga+kCDwPvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uLxNDDUe47huViGV+AYwA4hz0W2ET99JBvA0Agedw+oicAnZY1ugXDNt3vsj2ySIW
	 9FFXHosxd4jBo97Uft5UCPBOGoAw/x8y4j85rvCh6HDmA0X3TikoqLY423m++UTPyv
	 oL0CmmjJIeZvQ+14rJ/RrqOsRBjeMi8TGvmczZ8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0178/1005] comedi: pcm818: Fix sanity check in interrupt handler
Date: Wed,  4 Nov 2026 15:58:31 -0500
Message-ID: <20261104211048.766294412@linuxfoundation.org>
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

[ Upstream commit 956e8478261a575d1e87490f2e5db1788b8c209d ]

The driver requests an interrupt handler for the device before it is
fully set up.

For safety, the interrupt handler checks the dev->attached flag to
ensure the device is fully set up, but it currently does that after
dereferencing the dev->read_dev pointer which may be NULL if
dev->attached is false.  Move the check to avoid the possible null
pointer dereference.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://patch.msgid.link/20260618102949.26607-9-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/comedi/drivers/pcl818.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/comedi/drivers/pcl818.c b/drivers/comedi/drivers/pcl818.c
index 06fe06396f23a..e8ce34840050a 100644
--- a/drivers/comedi/drivers/pcl818.c
+++ b/drivers/comedi/drivers/pcl818.c
@@ -534,13 +534,14 @@ static irqreturn_t pcl818_interrupt(int irq, void *d)
 	struct comedi_device *dev = d;
 	struct pcl818_private *devpriv = dev->private;
 	struct comedi_subdevice *s = dev->read_subdev;
-	struct comedi_cmd *cmd = &s->async->cmd;
+	struct comedi_cmd *cmd;
 
 	if (!dev->attached || !devpriv->ai_cmd_running) {
 		pcl818_ai_clear_eoc(dev);
 		return IRQ_HANDLED;
 	}
 
+	cmd = &s->async->cmd;
 	if (devpriv->ai_cmd_canceled) {
 		/*
 		 * The cleanup from ai_cancel() has been delayed
-- 
2.53.0



