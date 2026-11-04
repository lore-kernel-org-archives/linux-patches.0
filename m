Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829529;
	b=Me1OdnY9DnXBLBwD6Labb8A/FJZUdc6hJJpiVMgkstR6UhbV3gtkIWGgoi9m1N9USyeX
	 EH0bHgUGd2Sbn+zBtW90DtWvgvJ+5ss+aKWVxPAJjEnnlTjkTwqIV8PNv7wK8HN2TESGX
	 7oNR7/3+C1RR62Ccq0TG266TYfVkzyp+x8p8WeZXzXTqLj5TRlSARO9HPPpwpJgvWfKdT
	 EESV7HqobVh4dmw0UtmLTlJQPTBjgiW3AhvhyC/DTbwIsMWcy+f7Q6JW67yp1/OHUXq/V
	 CPjkjfi69xJdOGUzCH9fJ1p1hgPwM3G2NDwJafdif21//mqPAMQV0tgLZaG+RpHrteA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829529;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VV86nxHXSIEoKeXnqr0UnhdUOf7dPxFMNMeAKD1JZFA=;
	b=IP1vaO5lul0MPx3ku1TC73XehKJTfJPbsoL3mwNoztxZ99t2pTAjc4TzTkAfIr+jY32X
	 6SmMVy9ljgMh7Ic/yUfrs/tkmyFQeyrUyba35Xorc+LPmTTVqodwdqDshpbc9WWMl7c+s
	 5R6UM1IYdH1LMwlEyrf+26TmzG888ZkS/upwYMcZogYOSHW8ysM0xHA9G80qDntLVUbuT
	 tthP5J882lTFHpqtA9x1t5BMUdgC/dCgrtW7fEoR/pVLSdtoR4gCldp2QQFW6j4TrTDsm
	 UBV+OQOspe+EPo/9dVrsx4p4bZuEVsIW6XQZPPNeoVRcdkB2ESUAd+urrgV/j7v/u+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cQriLhcp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 501A0606AB38;
	Wed,  4 Nov 2026 21:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cQriLhcp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E14151F00A15;
	Wed,  4 Nov 2026 21:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829529;
	bh=VV86nxHXSIEoKeXnqr0UnhdUOf7dPxFMNMeAKD1JZFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cQriLhcp+sC3dfaYN+QWGYX/fLSN408yzj6C6HCDlNLPO/OyyD0qDGYgcAkgqtTvU
	 1SfVy8sADYGDfl1cK8gctZVbqewwcPItWcUDlN1UZt3hNPh+DwfQUaq7+HWTtcFbql
	 YqVeSk4PRAsKTbWkzKeN+TdMSL6UzHJP/NkY79pk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaeyoung Chung <jjy600901@snu.ac.kr>,
	Sangyun Kim <sangyun.kim@snu.ac.kr>,
	Kyungwook Boo <bookyungwook@gmail.com>,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0176/1005] comedi: ni_atmio16d: Add sanity check to interrupt handler
Date: Wed,  4 Nov 2026 15:58:29 -0500
Message-ID: <20261104211048.708083921@linuxfoundation.org>
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

[ Upstream commit 13f4796223489a5349b466ce54bb868f46c9fefd ]

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
Link: https://patch.msgid.link/20260618102949.26607-6-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/comedi/drivers/ni_atmio16d.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/comedi/drivers/ni_atmio16d.c b/drivers/comedi/drivers/ni_atmio16d.c
index b057b3b3582e1..bf7fb6704710f 100644
--- a/drivers/comedi/drivers/ni_atmio16d.c
+++ b/drivers/comedi/drivers/ni_atmio16d.c
@@ -223,6 +223,9 @@ static irqreturn_t atmio16d_interrupt(int irq, void *d)
 	struct comedi_subdevice *s = dev->read_subdev;
 	unsigned short val;
 
+	if (!dev->attached)
+		return IRQ_NONE;
+
 	val = inw(dev->iobase + AD_FIFO_REG);
 	comedi_buf_write_samples(s, &val, 1);
 	comedi_handle_events(dev, s);
-- 
2.53.0



