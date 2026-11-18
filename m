Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041397;
	b=nD2YvTckhpJNAoXvUt35xmSYMVLxlJ59oVnvGVOEXKCHmVN9L4I9WQcHbItIpF92AEUQ
	 6N4GK7ee/s0f/dNhwDIIznx9Dbcz7Lzhr7/J/FmGsEK7QZWLINygW/pljrOYytOCvdD6U
	 foUiQCyiyD23ihmwf5AHVHCYldEYhWm7gZH58Xe7ekvqc1F0aNpuz6iqUqJt3PdHGVWhQ
	 5Wm61F40v7XSyIzSD76cqcmMW6Vl9hY2oDAj98mu+HV7m8opDhbEfdHYhSNBmBdFAmdFO
	 DXje2w1LlHQtNLO3pJF4k45akqlnLYw798qK7veAgtauigDQIGROK/+V6ugPzDIKnfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041397;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=171/YKBL3bZKHrsnHW7L4OXR3dtZ8f5oSqYZ66bgxXI=;
	b=nU629ouavh3tury9AE7UnuIyBpBp2K3TbSaMO4vDY/vbAkpsDCvFIojCecESwZN7rDvB
	 73DeLIJKiHzLtLD6DXqxC0REIVvnp+pIqNHpsZv7GeUICXNs24uStJyJHgq+ayNV5BwmX
	 rNyMJsGL4EJGrfTFq2eijW3NcMxzVI2XI5QXL0ghrXmpCF9HZNk+BGtLPDZ+jC/WJsIZt
	 R7WvVcODyIRtraqGj3eH/CdCF5MgKM7ojx+EL8fGU7dw+bLBKlcU5MwwIJ4Nis0LyL6C3
	 dTQon8zQXMOSsdhiZNbF7h6hYEjwRTAjOSYHLSeAbBGKIF4WWUpPHUIJaI8zIsfS7Gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hqEs6arc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6823606A320;
	Wed, 18 Nov 2026 22:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hqEs6arc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41CB51F000CE;
	Wed, 18 Nov 2026 22:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041396;
	bh=171/YKBL3bZKHrsnHW7L4OXR3dtZ8f5oSqYZ66bgxXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hqEs6arc5ljLR1m1jT+WpApg2YLs5+53u0yN0/d6tgwvfM06dEj1F8zVj5Uw17sFP
	 RYG9dNLt0OF3sXL8T8d6glp7NKajPw8KSu9eQKUGhCVrj1O1AZrbk8sF3OaPz7ELDw
	 2sjuPb/vJ15Wk8PdQlLOyt6Yqo9fvWXiRw5xaz4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yogesh Gaur <yogeshgaur.83@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2797/3318] comedi: pcmmio: validate the IRQ supplied by userspace
Date: Wed, 18 Nov 2026 15:56:59 +0100
Message-ID: <20261118150444.592602262@linuxfoundation.org>
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

From: Yogesh Gaur <yogeshgaur.83@gmail.com>

[ Upstream commit 23c6fc62e754f8bc412ceb5c0d9aaa14f2c9ff31 ]

comedi boards are configured through the COMEDI_DEVCONFIG ioctl, so
it->options[1] is a number chosen by userspace. pcmmio passes it to
request_irq() without checking it first, which lets an interrupt owned by
another irqdomain -- a PCI device's IO-APIC GSI, for instance -- be
claimed for this board. When the owner of that interrupt is later
released the descriptor is freed while this driver's handler is still
installed on it.

The board's interrupt is routed in software rather than jumpered, and the
driver notes that "any IRQ from 1-15 is OK", so the ISA range is exactly
the right bound.

Bound the value before requesting it, as das16m1.c already does. An
out-of-range value is ignored rather than rejected, so the board still
attaches without interrupt support, exactly as it does today when
request_irq() fails.

Fixes: 6baef150380d ("Staging: comedi: add pcmmio and pcmuio drivers")
Assisted-by: LLM
Signed-off-by: Yogesh Gaur <yogeshgaur.83@gmail.com>
Link: https://patch.msgid.link/20260909104848.1763-6-yogeshgaur.83@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/comedi/drivers/pcmmio.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/comedi/drivers/pcmmio.c b/drivers/comedi/drivers/pcmmio.c
index db9cb3fedb48d..cd8b02e6ddc04 100644
--- a/drivers/comedi/drivers/pcmmio.c
+++ b/drivers/comedi/drivers/pcmmio.c
@@ -683,7 +683,8 @@ static int pcmmio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	pcmmio_reset(dev);
 
-	if (it->options[1]) {
+	/* the irq is configured in software, so any ISA irq is OK */
+	if (it->options[1] >= 1 && it->options[1] <= 15) {
 		ret = request_irq(it->options[1], interrupt_pcmmio, 0,
 				  dev->board_name, dev);
 		if (ret == 0) {
-- 
2.53.0



