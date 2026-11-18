Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041391;
	b=Kdqsglqt1CUuwqtPENhRqdCsLVO6p4xV82ZPZh5BLA5uqTiSH2HdCwUMzzFKrREyeXFf
	 ezb7Frg8+RhV/UdB4vWrCwFTtOW5os1DfIehcFAW4lHmTq9uvdIhMpsFpsJdOIswF2BuJ
	 YqXzZsry3ba1xHdqYpzJnuMJzSppDmv/AhbVnTVjquPCmovFP530ytc0G7i1HQLa/mRFu
	 Pg46ttAAI8TYvoGQfOpQYEmzLdaUAK61ii3Fi8Uppwprqh8z5dZB5NT9c6JZXoa9tr906
	 vuLi1/O+NYNsmfUr47eflU2bhXOMtxJMTO/Qtpw9zAlBFXOJ9ymAMJIPlphq8zyW3Rw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041391;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CjdP6LIuUH3lj8C9Mh0YbLKWF/BXjIqX6xdWDPXF6KE=;
	b=CQ15nsVCkhgMcLX5q92flp1e1NGSVxqNhXdTZdjp6EbvvqffKF/4eUYVitWoLfG83PWU
	 aQPw71P2P442l4PBLCyMp9lmHMjMnZ61xoFm81IAeuSwDkRQ/hDA1mGzG2k6ghmNaQYv+
	 zpZGGp0V/PvJ0VXhYOvkL11EYvKJIvIWKud+RBCB4k96rJl1c7YJBGup///wUFn143JUq
	 PEeGsDd7OsvIVzJxvCltNBWmuRhHi9xMbwDxMvn7u3jmvafAZIs+PnLht+Ke3fQvzMnWf
	 FRWa9LL+RnKbQiSRIfm6qiLnMt1VnN0uV0QhKv8j3XRrNxEkA1E0kOTojTi+/uBUpsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=twxlOMFl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A19CB606A338;
	Wed, 18 Nov 2026 22:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=twxlOMFl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD3B81F000C4;
	Wed, 18 Nov 2026 22:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041391;
	bh=CjdP6LIuUH3lj8C9Mh0YbLKWF/BXjIqX6xdWDPXF6KE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=twxlOMFlsztwD1ts/iUbl6ury+odzp+26PAFt1xiiu1rJffsugJHZql1OSTgjwwdq
	 oGW78TvEEBvV1nXaw1yBGdsz/Loe1tkZNnHCPHRd630sG2WM7j7UeaagBisAnVj3RY
	 YA9nvG5jsHRHYnq8LXX50g5GKAIbfhkrwrCqiOAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yogesh Gaur <yogeshgaur.83@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2796/3318] comedi: dmm32at: validate the IRQ supplied by userspace
Date: Wed, 18 Nov 2026 15:56:58 +0100
Message-ID: <20261118150444.564524045@linuxfoundation.org>
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

[ Upstream commit 797d56d7f90864e67424f8e82639a9b3aedf37e0 ]

comedi boards are configured through the COMEDI_DEVCONFIG ioctl, so
it->options[1] is a number chosen by userspace. dmm32at passes it to
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

Fixes: 3c501880ac44 ("Staging: comedi: add dmm32at driver")
Assisted-by: LLM
Signed-off-by: Yogesh Gaur <yogeshgaur.83@gmail.com>
Link: https://patch.msgid.link/20260909104848.1763-5-yogeshgaur.83@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/comedi/drivers/dmm32at.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/comedi/drivers/dmm32at.c b/drivers/comedi/drivers/dmm32at.c
index d17cba93578c6..f9900df7ec955 100644
--- a/drivers/comedi/drivers/dmm32at.c
+++ b/drivers/comedi/drivers/dmm32at.c
@@ -584,7 +584,8 @@ static int dmm32at_attach(struct comedi_device *dev,
 		return ret;
 	}
 
-	if (it->options[1]) {
+	/* only ISA interrupts are valid on this board */
+	if (it->options[1] >= 1 && it->options[1] <= 15) {
 		ret = request_irq(it->options[1], dmm32at_isr, 0,
 				  dev->board_name, dev);
 		if (ret == 0)
-- 
2.53.0



