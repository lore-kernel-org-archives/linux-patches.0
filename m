Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031641;
	b=UJEIxMGFsIUqYPlJgx1W3i882lsuI7ztWFyJd6GAHW+JCVju5JMpbWdF6L/KJIQ2jEFC
	 qVTCYVXGNVVu4CnSuQGRGJ0c0Y3JOqOF59hMRDjgDsFo6SMSAtcg4Sfh4EpTL7CORLdsd
	 nnLQnzn06HVlIva6oWDu8gTOt08g9+dkkM6z/Sr6Cbti58As3L0kMx67y3owXzBgSBUGd
	 ChqIJS21XVanWESLUr/2/HY5PvCRBOgc/5rbjmBJSK4SV1YvKdmkKN30YqueLsut5OQqJ
	 E2t9XhyUtMbYXt5wyNmhEfeOD53d57SwJHnyhOFlKmxFGPsTNIWwyj3HNcaS76YF9qg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031641;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DXvHOOm0c8tR3sAOf1PaJHXTYgShFDpqTn1voe1wiCU=;
	b=RW+qhSVJzBFlfZMLT3otBkRIeBx4WkSmn+baoyf+s5a8qZwE6jr568J0ar+r0/lRZ2v5
	 TnLmeCLDBP8o9KLqeMoHfn4QBXELks6sSe4gQKLOGE0UeKkEwsDnwjGFyFZGvcv/yGkKn
	 zmRGxW7Lg8QGfCVMyd3ZuXRPNBpiLuD3mRcAydGxaIlhsodn2O95aynRg0p+hOeEfFo3A
	 9ECtKhWkqCCKQrs/jSbofKMYxqPlloxSrJJqcU0BVFsGkwr85F9pLX3y53SotFCEmCBxK
	 gkVA2cMfKjywEqHLZmTBjaZDdwJTiQWf/vYLkKUVViKLGyx/Ny501POKAlZaAmIL/nw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="1/t8sXSm";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B822606A31C;
	Wed, 18 Nov 2026 19:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1/t8sXSm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 977661F000C4;
	Wed, 18 Nov 2026 19:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031641;
	bh=DXvHOOm0c8tR3sAOf1PaJHXTYgShFDpqTn1voe1wiCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1/t8sXSmkAE/tkkqoNF0SrmyQ9iKahOe9B2KyjL+ArdHhJH0VPtwrRLX0O0WsXh+5
	 MU27TdREyLbxrfPs6dyuEFdwC6NkrsPG1YCJV8pmEET2z2rhf7v28nZcgrUmXMPq8e
	 n50maMKhDCDv8t2Qxzlh9jaKZVr9S01nIV35REOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yogesh Gaur <yogeshgaur.83@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1129/1756] comedi: pcmuio: validate the IRQs supplied by userspace
Date: Wed, 18 Nov 2026 15:54:16 +0100
Message-ID: <20261118150055.030895422@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Yogesh Gaur <yogeshgaur.83@gmail.com>

[ Upstream commit 9c325b21bba99e597771137fc11b9427c86618d8 ]

comedi boards are configured through the COMEDI_DEVCONFIG ioctl, so
it->options[1] is a number chosen by userspace. pcmuio passes it to
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

This board takes two interrupts, one per ASIC, so options[1] and
options[2] both need the check. The existing options[2] == dev->irq case
is left alone: it covers both ASICs sharing one interrupt and neither
having one, and by then options[1] has already been validated.

Fixes: 6baef150380d ("Staging: comedi: add pcmmio and pcmuio drivers")
Assisted-by: LLM
Signed-off-by: Yogesh Gaur <yogeshgaur.83@gmail.com>
Link: https://patch.msgid.link/20260909104848.1763-7-yogeshgaur.83@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/comedi/drivers/pcmuio.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/comedi/drivers/pcmuio.c b/drivers/comedi/drivers/pcmuio.c
index 1c5fe065a91f5..84bbfdcd0953d 100644
--- a/drivers/comedi/drivers/pcmuio.c
+++ b/drivers/comedi/drivers/pcmuio.c
@@ -545,7 +545,8 @@ static int pcmuio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	pcmuio_reset(dev);
 
-	if (it->options[1]) {
+	/* only ISA interrupts are valid on this board */
+	if (it->options[1] >= 1 && it->options[1] <= 15) {
 		/* request the irq for the 1st asic */
 		ret = request_irq(it->options[1], pcmuio_interrupt, 0,
 				  dev->board_name, dev);
@@ -557,7 +558,7 @@ static int pcmuio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		if (it->options[2] == dev->irq) {
 			/* the same irq (or none) is used by both asics */
 			devpriv->irq2 = it->options[2];
-		} else if (it->options[2]) {
+		} else if (it->options[2] >= 1 && it->options[2] <= 15) {
 			/* request the irq for the 2nd asic */
 			ret = request_irq(it->options[2], pcmuio_interrupt, 0,
 					  dev->board_name, dev);
-- 
2.53.0



