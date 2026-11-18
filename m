Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043268;
	b=f6rIbqNC9YUxDw9osF65Ai8q5YXwZg6h9FNcQ+zykrJMK/SgQ1nRwn+Na4aZdpHDYV94
	 3mQBrhNCwE3VrMNoMP7OmcFyN6F2hqJQep5h1G/Q/BYUgPfcAPM2m9+U57tn+Lf21LjOe
	 FTG95KEFT1pDsQGyx41iRVo5lWdixEvXz5J8G1T8n/UncxVtkltcOTeud5WEZZuM5EsIf
	 NCMnUM6rKlUk/ve6MkM59ksHKhFixhgoschowaM7s9MLBHhl2xM+QhJ0yp78AekgjUPc1
	 0AdqjjKGtQRtp9hNzZ9h3V93nguLCvGoEgaX6z93eTvo19oBnbK610+U+HAWAf1IMcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043268;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Vs18XJsuPjCJq9duNPzsmO4LsPXZjK9C0yw8KBwcfPE=;
	b=4STAjGGC+eCoOnTAuFDbfW83AbYCzZYuK0GvQHSFX+0e/i05lwvryFrMF6v28/5AjVCv
	 9sRPtT8ilQWFVrit2e6sLwbItorUxyGahRuUUk1uJN5sUlJlPJGEF3pOlg/rmS6YQPZpQ
	 GpWq2N74jG6vKkVO7iTc1RYEuo76aG7obv1taf2RzpatUKL9s5/8/8cxPb5QvAssBJuey
	 uEE6JtXIhfgEInP98A/KgtrH01Gz+mhg9ppp3BfdVvG/6tPgv/663ZEX3wg3oicaQzKw6
	 3YdcGYkKJVj7qKO6XvW0+sk8XR7d3tz0iG3a7Hc7QhHHFAMm4X6tIzmI57Fdt6bf09g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M6jgb+Jd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E533C606A32A;
	Wed, 18 Nov 2026 23:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M6jgb+Jd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43EB51F000C4;
	Wed, 18 Nov 2026 23:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043267;
	bh=Vs18XJsuPjCJq9duNPzsmO4LsPXZjK9C0yw8KBwcfPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M6jgb+JdtlIgIh8TUQ/KFpbgVUuc+wV9SfgwzwzHAEMMuTSlLZfkmXrfJyS0A4rWP
	 I/2aR/1+yt27PCEoLz1gWEE3etbn66zSwCLS0S8SgMYYWr4UXKmJu+u18B+Fybst9l
	 2vZnxmZMbhtX4DsIuowC6Cw1yfbsZYmtGmzMD80k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0109/2857] comedi: dt2811: Fix sanity check in interrupt handler
Date: Wed, 18 Nov 2026 15:19:03 +0100
Message-ID: <20261118150205.181114436@linuxfoundation.org>
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



