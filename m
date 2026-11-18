Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043251;
	b=vC+bBQr6vOtTq27EjsjXiff2vafnA7RVrI15N/JHgOwMIDUDVYzltZSP/AlsoaqB8d6h
	 q7xmCN/IQLhgbmA736t+nFfNxt2caM53Rw4adXxw25EbTBZbr2pjTHs2wFu3/kV9r8wBc
	 4VjN7BGB74PkCXeKbCmTrSfnC6djv7y5ujuxkl3BrVv3UF8I1Uj3efUOXzPSRBWufD/po
	 tWaPJSFm7C3uVogSVDu5tU9AkOjUkJXLddJGFh2ex3tvFaziSFDytDWbXdO/Jk3OWfCRZ
	 NEPVR5mLqe8+NyK6E2kKnbgHpV6KSVqg5Wn4NaKeWFLwBHrMiDqltmzyJl35zBI6W2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043251;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EGWsWiBAGje+G4ppYIvYgTzC95O7h+/jTwNhkw+IIs0=;
	b=lnq5R9hqqO95qIRTGwepQ3X/YobQ6Z2MgPlK7iJ7ZC9DWw2FP6EUa5MdbopDaQHaAglJ
	 +BBuoRYA/mz7uafeZ+UthMDskGpfkl4FMG5HCYyZT+VuGml/hE+QvUoYujWYeexMpsTv0
	 d8VJtaYqdWxyB/H5+88y/wH1eti5nqezJpzzuS8PVTgOUKYANn3sgPtx//lQJzAyorFEi
	 zt2vicD1Ih9ggDv4bxF+e547v+TG0Zl992T8fq7pSXo//Tl9/YIAkZ2t+y98FXhB4sAQO
	 8YwFdSms7SOWe1jVrT8mA8gxILZQHsS0qomO2cn0oHvJRwa5Ns0u9U7Y+unpJP7hl7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IRDP0piq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 471EC606A333;
	Wed, 18 Nov 2026 23:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IRDP0piq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 540611F000C4;
	Wed, 18 Nov 2026 23:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043250;
	bh=EGWsWiBAGje+G4ppYIvYgTzC95O7h+/jTwNhkw+IIs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IRDP0piqs8obDZefJkh1B1/C5AxJBUOL86AvCMxmj/Yw5sASrdr33JYz+v5Hi8pKZ
	 s2zgQ5Oy3NUAV3CK2EcxXyZ5/UUCXIWQ2lDG1vWFpfSOCDN1rkiyGryb8Yl+TLGekg
	 kSM6mJxSnmgWKdI9LxTJLuOwrTo3ITk3o8Az5Wp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0107/2857] comedi: quatech_daqp_cs: Fix sanity check in interrupt handler
Date: Wed, 18 Nov 2026 15:19:01 +0100
Message-ID: <20261118150205.112564679@linuxfoundation.org>
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

[ Upstream commit 1bc9538df6be8dac8727179d8bcc0d880648361b ]

The driver requests an interrupt handler for the device before it is
fully set up.

For safety, the interrupt handler checks the dev->attached flag to
ensure the device is fully set up, but it currently does that after
dereferencing the dev->read_dev pointer which may be NULL if
dev->attached is false.  Move the check to avoid the possible null
pointer dereference.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://patch.msgid.link/20260618102949.26607-12-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/comedi/drivers/quatech_daqp_cs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/comedi/drivers/quatech_daqp_cs.c b/drivers/comedi/drivers/quatech_daqp_cs.c
index 2a76c75c513b8..d5e3e213e233b 100644
--- a/drivers/comedi/drivers/quatech_daqp_cs.c
+++ b/drivers/comedi/drivers/quatech_daqp_cs.c
@@ -211,13 +211,15 @@ static irqreturn_t daqp_interrupt(int irq, void *dev_id)
 {
 	struct comedi_device *dev = dev_id;
 	struct comedi_subdevice *s = dev->read_subdev;
-	struct comedi_cmd *cmd = &s->async->cmd;
+	struct comedi_cmd *cmd;
 	int loop_limit = 10000;
 	int status;
 
 	if (!dev->attached)
 		return IRQ_NONE;
 
+	cmd = &s->async->cmd;
+
 	status = inb(dev->iobase + DAQP_STATUS_REG);
 	if (!(status & DAQP_STATUS_EVENTS))
 		return IRQ_NONE;
-- 
2.53.0



