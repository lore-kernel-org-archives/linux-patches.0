Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051124;
	b=WIFR9xXXG8Lgkz6TzXdrn6cZ21Hn3t98LVNhSA3iwK583tSoqC+ByS83E7tfkxgSpatc
	 B0IOJnP6+B6hxE8XA4IPIczYb+WU7RgmV7hBQRMYsFZmMLfX5Epj853Ox7xFmXb/66NjZ
	 eDr1jSQ5XqhONp2FPEka1XaQbLZ+TNXtmO9+XrZ9KaXx63g/fB5bDhcXkKuMDTGI0tfZJ
	 kMNJ9RxJJwCtNDqr9wkPwNIrVW8+FAhLWGl8kRbSR5UmF1/YE2TXytt816QRwC6EVFc1C
	 CGjiVDDyypIB26cKVAEAHeGKSmF/J27CxsMsBKC65uxNFYF/1E8keWBAAdgPQmGSbuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051124;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rKlEAzmnOhxLY9N/IihJbzahUQ/wfEh9Vw1MplyQ1lw=;
	b=SZhzFKAd+odx5Jv9JpwBAc3QZe9MvF6AG+zXnow5D9UXU5kIKsoqx1nGquB3037jDyQn
	 EClIQYsgEh9uTn1EpBUm4uvCJEpXJb65w7m3z0ybpFNAFq7BPEqIpDciXRZyYQQB3b56v
	 j8785lDtgGMMlJ4gBdqhGP0fPgebPIgqT6giUG8keaXvL7JIDcc4NP404Wg7GZYVPb7i0
	 W4f+isQEi6wLlNgTpnNbM3thREpc2gX91kLjQcHaUJY6goSIEmsj82yKv6PtxNKxlk7zw
	 lYUc138q/qhGolbI1/NzQuRBo9JoTtceFLr0nLuTGucKyM7c4bLYmig6jINbFyDZbhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fud6mjM0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D63A606A325;
	Thu, 19 Nov 2026 01:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fud6mjM0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 947591F000C4;
	Thu, 19 Nov 2026 01:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051124;
	bh=rKlEAzmnOhxLY9N/IihJbzahUQ/wfEh9Vw1MplyQ1lw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fud6mjM0tAS6KUVVElgOauNmJnudQI2G5ke/JOHVyGFMLkRAPzP5SqDDkzN4gyLlF
	 B94iz2x/T8PVtyJGW6jlsd0+kA6o8izDJ/o29WUivMgxtZ9gOxA/KOGluGe1RmJCuS
	 uEp91yzb+z/XPB2dJ6nelhYQgd7kWFe44UCzu6Gs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaeyoung Chung <jjy600901@snu.ac.kr>,
	Sangyun Kim <sangyun.kim@snu.ac.kr>,
	Kyungwook Boo <bookyungwook@gmail.com>,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0098/2214] comedi: das6402: Add sanity check to interrupt handler
Date: Wed, 18 Nov 2026 15:29:34 +0100
Message-ID: <20261118150013.867233916@linuxfoundation.org>
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

[ Upstream commit e90d0550c5b3056c8821f5cd714f80902de0fca6 ]

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
Link: https://patch.msgid.link/20260618102949.26607-3-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/comedi/drivers/das6402.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/comedi/drivers/das6402.c b/drivers/comedi/drivers/das6402.c
index 927d4b832ecc6..fee77c5b0e097 100644
--- a/drivers/comedi/drivers/das6402.c
+++ b/drivers/comedi/drivers/das6402.c
@@ -175,10 +175,16 @@ static irqreturn_t das6402_interrupt(int irq, void *d)
 {
 	struct comedi_device *dev = d;
 	struct comedi_subdevice *s = dev->read_subdev;
-	struct comedi_async *async = s->async;
-	struct comedi_cmd *cmd = &async->cmd;
+	struct comedi_async *async;
+	struct comedi_cmd *cmd;
 	unsigned int status;
 
+	if (!dev->attached)
+		return IRQ_NONE;
+
+	async = s->async;
+	cmd = &async->cmd;
+
 	status = inb(dev->iobase + DAS6402_STATUS_REG);
 	if ((status & DAS6402_STATUS_INT) == 0)
 		return IRQ_NONE;
-- 
2.53.0



