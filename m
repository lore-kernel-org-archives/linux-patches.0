Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051127;
	b=XR2+341HMHAlil4nk8jjdqH4uMkiY/8xyLI7CB1CD5UUbCthEid7bnTh0htVTG0IUJpl
	 Vd/SL+oZhvRH/SPa4dWLFdEGMUknnzUNblA4KNpdSYH+LeSKX7NfI4spmxD3GFeYPbKtW
	 v9wlqcZEZFCiOB2IWYYlmmLDn4pAiArau3wIitmWs2hFo3nTncXwCuw7QMsTBgv5LZZd+
	 Gf4RiI1ZuHkdgwsB0s3fnhIIHemSE/30/gH+FHJ+pAHig1TleiNkwON6gRX1wHWn4rGPK
	 YGAF8Jxjpnw2gnZD0+yb3gvNeR1bjhow8fBSVnJG0uYEnAzUF4pDCO97zSUA/5QOPBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051127;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=W3R/tMYKPqWMksA7mOfD5rPzukBpi7zqvVegOd/d/LM=;
	b=xBTQla+TEjqnCWXMmghwsyNB6SiT1SdgSgWe4LWsQE997AJhDiCEWP8AwR9bJkMJEuD1
	 pquBeq8IbD28EI9y7z3iHfAbmV9U0p24ofH5WWc/a0FVTrVkV+G0KhRLmVZIP1RH8TDMx
	 QCLMQPlsLuaqPmEG3QL+x2bnzNsEs8VZIq4wW2Li47vgelAqSQTzS2wYycNICTBLjeUx0
	 eX9K2Y6iovxkS80v8vHFmhYEbgpOJy+4Nk2wAAhz53eHjSbUQmm9VRrFv9PEiPGxemIts
	 CjvnpgwlusBJ1HmRedKV3Os1qNa4jaXuMFW4dOMSq/ZkmoCkO9QbsISkwl2r+Z58GwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AaSpiQD5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1036606A32C;
	Thu, 19 Nov 2026 01:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AaSpiQD5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 521DC1F000C4;
	Thu, 19 Nov 2026 01:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051126;
	bh=W3R/tMYKPqWMksA7mOfD5rPzukBpi7zqvVegOd/d/LM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AaSpiQD5jtUvKM7Z75M4LncU8CivlUSwg5Zi1mRbUyrOmE/JaRXduowl83grzZoe1
	 TIu38ibfj/fomT+CqZuQErCSUureZyNLsbyV1QG4te2McF97RGFyFcHJtxZf+zc+Zu
	 ZDiSemgClbcl3YwEdlH+pLT/4gryBEMiLDxmAiLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0099/2214] comedi: dt2811: Fix sanity check in interrupt handler
Date: Wed, 18 Nov 2026 15:29:35 +0100
Message-ID: <20261118150013.902780738@linuxfoundation.org>
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
index 0eb5e6ba69160..d94d3c64e264b 100644
--- a/drivers/comedi/drivers/dt2811.c
+++ b/drivers/comedi/drivers/dt2811.c
@@ -194,13 +194,16 @@ static irqreturn_t dt2811_interrupt(int irq, void *d)
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



