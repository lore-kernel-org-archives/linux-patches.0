Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060737;
	b=uMSldVEF1wYZaNEyyv9T5clDNqnUFjd/YCZM4S9c63XGsdAm/hkWV7EJIA9R3jvIdeH1
	 Ex7FdZV13hNdDzPb+v5p93VzZue7fcPIvK4lHSUVImSpK4RTy84mAgHOSwq9i4nhNR3T+
	 of8RKWGr2oup+xnws24Bg9pD1YBbljXfvXiJQ/ikM7g0SXx/uZwpEbJa8a4pUCyxSmOUA
	 jyxkMJaFGoWwwBTX7futmZZSZSmOqyR/MgNkt+r6RVPjaoyKF1Dg7IrzGj61742fzn37L
	 l/mcMKpEuXhwbCG691S14wqDv/sSYYuFJPnQJKJUyPtT4McUGxZLXWHLZawfhj5m3jw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060737;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Vpxj6pRw4X+t1F0t9KMPNhD+ayz2eO3Lr6JxJqG3LVk=;
	b=D5jATsVT9ao+v+SZ8F+VbGQisoYY36Nb6z8SbzXt4eUa88UYLDjGPjtRCcECk0tt2PXR
	 7XtwGQzOC1mQLHjSnI4FfCfuySVpu2OHNqWHMQ7vuJMtcXBwOgeVoG7je3g3ZWvD4K/1e
	 3Q6DyVMBVVYj8S9qY41gwyCKL2YwVeOB4rRQm7O7/gxaQqRPTIz1zwLrk+NOtPc7zqkZH
	 WMfio/3QQhuKW2sOcEAiAqT0W+cpbGkw/P4OTmXDS6AkBR9Ujfq2TSgoxvUKaIEH/zFKG
	 S5N3mp6SE8+3HcDzdntE4sTwyUbSaQg5PEZ8xDDfbfbOYT6eVzY89eTQtqqLwv6nZfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RVlNzx+X;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9976C606A326;
	Sat,  7 Nov 2026 14:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RVlNzx+X
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47CA71F0089F;
	Sat,  7 Nov 2026 14:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060737;
	bh=Vpxj6pRw4X+t1F0t9KMPNhD+ayz2eO3Lr6JxJqG3LVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RVlNzx+XfnpTSaa0MkkX61zS5JdA08HWN0rmU443fpU8ejyCPR8TvRbDLsV90bc73
	 TRn04u9i14iGAEEOgnYHop2sLelHTN4xnFwphsr2383qZimcvEoc3EkJqEq5xO7PEd
	 a1dDWjv/O09KFrc/Ovb5AdcwYvRcl0IQaOOv864U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0154/1536] comedi: pcmuio: Add sanity check to interrupt handler
Date: Sat,  7 Nov 2026 08:36:10 -0500
Message-ID: <20261107135002.006418899@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



