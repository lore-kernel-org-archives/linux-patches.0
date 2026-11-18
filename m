Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061698;
	b=StFiLbE/cW3pTrJB6rz2z03txo9EGck7LTxmG8PBvYcSSHv9xQVpiVAcMhDXRLL6r4aQ
	 Nl23jLUo6VJ/7vOPuZ00B0Y+azF8EKEM/pP+hWi5M9wod3alB9Gk7TRSUAx+3bmlwkLzO
	 Dy25dPW6Tju3CZ1vkkNqhx9h0Jis0TQBkKadoWVJ1TUuSiA9Fyx3fjYJNv8uJLXlGR0/p
	 X+bniIQ7Wxa8IhOBmRdqhDDjozYCR9Pc5K1bQOayXYXauBKxlVMZLEd3Vl+aBsF74LI8q
	 Ftem+1d7MJ7Ss8B6VGhwvPt6193lZILw0WNujOu/J7Zv0eleR20xikIv3fUUT4GE8sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061698;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=p8bJlezZ/KqyXDCeKMP+P+Uk/QuauGhIyLpYdsin+lE=;
	b=Tz4trTtoYjzSK7LpRHVDQC3SQnERB7JVMFB0wZCrMnjRPqW3HdK3tL5f3mA/VRe1rtlE
	 QYSn3Xtgm+xwcBQS/EMLRkrYb/TUlZw1nKHt3974kBau/HeruIm0PyijTaS6p5r3abiGy
	 xV7DOKhrXAw4Tqv3IAttdFzkj4B+HPnLpPOJX/IBll9BB7pDNcrmMV4uAK81i0q0X6YUK
	 j8guCeFZuJ7gHswkK31aBLGLLR2trT8SAlUi3PVf5QrFP/UngRKnt/8npuWu07P1aUm7m
	 21SL8b79+XQhMHVeEHiDVXIco5WUPnbA0oX01qIDX0kUqicfxHbWKwTMawYlGT0zaMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ssqKQEOQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2A1C606A320;
	Thu, 19 Nov 2026 04:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ssqKQEOQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 044141F000C5;
	Thu, 19 Nov 2026 04:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061698;
	bh=p8bJlezZ/KqyXDCeKMP+P+Uk/QuauGhIyLpYdsin+lE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ssqKQEOQM0pFUdxg6IToyilzH/14Hd8Tk/usIHYfaqWPC4rBnljHdoX5NHc5+zCl/
	 Ji6nz4V2IMUmDV6DcmmGiK0YD33/mcU4ZWVATaL8j5+gEobLcsGbrwV8YEST62BoL9
	 /8xDAjfxIZ7mHg9I/30I/Iv/DuVFef792Vap1CHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yogesh Gaur <yogeshgaur.83@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1595/1848] comedi: dt2814: validate the IRQ supplied by userspace
Date: Wed, 18 Nov 2026 16:00:33 +0100
Message-ID: <20261118150026.266843565@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yogesh Gaur <yogeshgaur.83@gmail.com>

[ Upstream commit 81026c2b3f9096cdfdfa02918f94865629fb7f90 ]

comedi boards are configured through the COMEDI_DEVCONFIG ioctl, so
it->options[1] is a number chosen by userspace. dt2814 passes it to
request_irq() without checking it first, which lets an interrupt owned by
another irqdomain -- a PCI device's IO-APIC GSI, for instance -- be
claimed for this board. When the owner of that interrupt is later
released the descriptor is freed while this driver's handler is still
installed on it.

Every interrupt this board can assert is a legacy ISA one, so the ISA
range is the right bound; it is also sufficient, because
mp_chip_data->isa_irq is set only by alloc_isa_irq_from_domain() and
mp_unmap_irq() returns early when it is set.

Bound the value before requesting it, as das16m1.c already does. An
out-of-range value is ignored rather than rejected, so the board still
attaches without interrupt support, exactly as it does today when
request_irq() fails.

Fixes: a211ea977a41 ("Staging: comedi: add dt2814 driver")
Assisted-by: LLM
Signed-off-by: Yogesh Gaur <yogeshgaur.83@gmail.com>
Link: https://patch.msgid.link/20260909104848.1763-4-yogeshgaur.83@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/comedi/drivers/dt2814.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/dt2814.c b/drivers/staging/comedi/drivers/dt2814.c
index bcf4d5444fafa..174253f15645a 100644
--- a/drivers/staging/comedi/drivers/dt2814.c
+++ b/drivers/staging/comedi/drivers/dt2814.c
@@ -244,7 +244,8 @@ static int dt2814_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	i = inb(dev->iobase + DT2814_DATA);
 	i = inb(dev->iobase + DT2814_DATA);
 
-	if (it->options[1]) {
+	/* only ISA interrupts are valid on this board */
+	if (it->options[1] >= 1 && it->options[1] <= 15) {
 		ret = request_irq(it->options[1], dt2814_interrupt, 0,
 				  dev->board_name, dev);
 		if (ret == 0)
-- 
2.53.0



