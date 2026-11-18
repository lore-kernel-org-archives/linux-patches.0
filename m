Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049613;
	b=uNlR8pavc6V0M6GTouxVTY71XGTrvh6qUCzw9ttz1LbBr6dKlZfdAKl1UVLGZbekg100
	 04kE4FtzVJ57H3hSflxPhleX8s+id2vqoyP0GjKMvlTfrZniBeGOVKzav9/vX2+WWDr9j
	 1aaPK+jO4uHuu9zXcgwVFcFlA48Rxmg1sQ04T470lmF1eXeZFUKepOPJTk2PX9z1noWq0
	 +ldp8bN5nvFjxPHSefAdrtG/1rJIQ0E0cCsrbm+nxRM18sDLn7EcrO4nQrOSxmLJvq9n6
	 hmzVB5acjTo3UBMS1Ln5dYK9L/5+aTSRGLO0poQuYY8qI9XjWHfi19Yw+6RojndFZuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049613;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HdYrls9OWShTnu4CpS74rMcpP9LVYqMPd9DrZXFcpTY=;
	b=q6tnCWG4qmMSlzSNTxhmmOl24vSCV3saRKXbnmLDAA7CDF+cyU35VJB8Oe0RIEFsLHiI
	 ONKUO3JAzaAOqMNoT4qsADS8n0tQEEXAESOfNqQZcN6n2unUfjLDun1ktOIegOBr75QR4
	 xTG1Lek5TXWwLgmFfSxCE7/N4VOu/Nu9bIPPyzJVAqhbeF/zDnFKYr2opFFC+pGnLY9Nj
	 uWZYJtyjeh+zAxEBMHdMmuMFa7Olzpt1ZHYppKYxYYlyFMUcV4sBR+nG+JLV1cBxIrrMp
	 2ANapwFupddyWunY77eX3hktzjSdmxtd36iyTszGmSEVqsMaXoqA7g1dlGuAwHPYiwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b2KnKHep;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88ACB606A320;
	Thu, 19 Nov 2026 00:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b2KnKHep
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBE7E1F000C4;
	Thu, 19 Nov 2026 00:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049613;
	bh=HdYrls9OWShTnu4CpS74rMcpP9LVYqMPd9DrZXFcpTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b2KnKHepJDm+hKjm+q5JT2cYk9E8mvjFNZU3e0kZEf6fetoN6H7NoOrF0Pu4pgaM1
	 N2VbXmZrzaqLhXJEwNb7w6Pyw2TZ7M3gX2WKxzEOz7PeZwugPHkjr7JUdUMWGDoEvi
	 bIxteTgA3wDmlr4/jhLY/1Uok80iRcG7K37PgXi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yogesh Gaur <yogeshgaur.83@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2415/2857] comedi: dt2814: validate the IRQ supplied by userspace
Date: Wed, 18 Nov 2026 15:57:29 +0100
Message-ID: <20261118150328.506689599@linuxfoundation.org>
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
 drivers/comedi/drivers/dt2814.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/comedi/drivers/dt2814.c b/drivers/comedi/drivers/dt2814.c
index c98a5a4a7aecf..3e734e343431b 100644
--- a/drivers/comedi/drivers/dt2814.c
+++ b/drivers/comedi/drivers/dt2814.c
@@ -315,7 +315,8 @@ static int dt2814_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		return -EIO;
 	}
 
-	if (it->options[1]) {
+	/* only ISA interrupts are valid on this board */
+	if (it->options[1] >= 1 && it->options[1] <= 15) {
 		ret = request_irq(it->options[1], dt2814_interrupt, 0,
 				  dev->board_name, dev);
 		if (ret == 0)
-- 
2.53.0



