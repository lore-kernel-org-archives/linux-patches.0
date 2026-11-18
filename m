Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019820;
	b=jVQ/H96FS/q6B4CdltIFjR7LTriuQlxp9Y4DbvREFYMa7Vy6sVUpoq1s8jvxptMKoiDm
	 jtwkNgcqoMYBEWSPtmZFHKSIT+lYb9uoojcVy5O6yR5JatV3PVkSdOz+iLjQgWlv+I4kb
	 sAPqcIYVdKkxOIhxIk7YMzw3lQcZI/riZk5M+EbpO3FYlys0k5ikNKT2aPCf/RbK8lgvw
	 5i5FAiNlfnfuW7jsNS3q9PpRjLGteKibQv1bsUQFy5yN66Cn2sXBsu+SlEZnQqUO20yhG
	 T7zJVh1lUiJWgHcFJbQLM/uWCGj8ce4qF6pHZCTfixDofgTNuBqoK3My8iW+j/Jk8rw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019820;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5M/p3dZYdIUsEtDc0grw4XLE6nIf4vr6x5i8kDX3mYQ=;
	b=PRpAWrC8XoYjjyOxw6zrvbXpBbW71BfzcuuT4glII/0wEWLuAiWLDzuNgG94ylQWswiC
	 1YSWWtvchVJ8yH3pbd/skcjnA58BXQV+0kTj3Lx2obucK1GGHoqe6pfaVHVMDQnsczfA0
	 Z30rbdP/evlHecDFxLvGrhGiBT6sWKqxqUJV6S+HlTdwpaTF16RrQO4q26M2TBYf291KC
	 rW09b2Yqig33FzA3yJJqfYKuVTxlsS2jJIvAdatMkwpzx6gfUvn91JQTLq6M/NyyVNKD7
	 wvLupxyiJFPcc2+nS+PNXsczoyWjoMcqZ42zEWVGEfJ5VubQbj+pIr7s5rGV/yhRiwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ymp3MK/g";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2263160A2623;
	Wed, 18 Nov 2026 16:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ymp3MK/g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7206B1F000C4;
	Wed, 18 Nov 2026 16:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019820;
	bh=5M/p3dZYdIUsEtDc0grw4XLE6nIf4vr6x5i8kDX3mYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ymp3MK/gqvWAkTuT2RssmQgjp3JKBaOXyUkFaTwG4LbaoS98Th/eZ+mFyH2WVtbUC
	 40v9/L+AqsN/2/QraVHDMP0fQB9CgXBI0DIM0N1HcH9eDrKjuGbo8jayt1fQXP15Mi
	 G5y1xk/Vg8lblp0hzSCyWQTrhWrKBWocMppB5H3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yogesh Gaur <yogeshgaur.83@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1731/2651] comedi: pcmuio: validate the IRQs supplied by userspace
Date: Wed, 18 Nov 2026 15:49:31 +0100
Message-ID: <20261118150349.938296468@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index d9995cbeecb62..da80bca0bb55e 100644
--- a/drivers/comedi/drivers/pcmuio.c
+++ b/drivers/comedi/drivers/pcmuio.c
@@ -546,7 +546,8 @@ static int pcmuio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	pcmuio_reset(dev);
 
-	if (it->options[1]) {
+	/* only ISA interrupts are valid on this board */
+	if (it->options[1] >= 1 && it->options[1] <= 15) {
 		/* request the irq for the 1st asic */
 		ret = request_irq(it->options[1], pcmuio_interrupt, 0,
 				  dev->board_name, dev);
@@ -558,7 +559,7 @@ static int pcmuio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
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



