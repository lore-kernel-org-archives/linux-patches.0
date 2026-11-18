Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033859;
	b=ZOHfNyOjjSGSq3viUfuTeToya1bdgjNadmlUsVjcMbLOhhUSvKBeTWr9lgMZbRfCTYOT
	 Qo54AzmBW2k72DPtPelUQ9UaEvEXToKJDg/3xEn5nGqFu9BNN41bdiSXJqhJ1n85I7him
	 VeRm5wd7XpLF+3JN7pB+wX7yo3x6cSuo3j9JQGungP1u0Y/AXfeqvSwkENYWy+Bj032+E
	 yy35k/3w33rzS/F7QJdvvyJDsH3xJjFp0v1fIckHDsUMcKAQolAPR/Aoa7Szw250aPDyw
	 Z+LJwXSzJU/KXA65AmqV9to/RLeT65LqSfvQan22YRo60Q8PpR3LxQFM/RQkCWxbW0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033859;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UsWQk8TTAOmELpaPtLjV+173kXJ0ptRUqo/UNBKFQpM=;
	b=lBIG/fl1zWDyVFmecwPBxN7TrZCAUmyw/17zCDDw81ZsHIiK6ohNF9rjKGbDDmqRz/qX
	 hFxKYQIxXXqFdHDD9akLi8M9TpXRY7YPV+GMdBXh3q2Gh1xaZb+hz+HFXf3GUNGnUzX8R
	 OMmfN/o4Q+YQC9QtpBaCJjgtle3vSBtVr9ob4s8733xmfmF2QE7YpgtEI1lehVoCBDeTm
	 wKvA6W70gh8tvbQXD/xviE8lUPhzLqYP0QCSrtQdQ8a2zSSRsjUBwOQNYfWniM+5vgcQ5
	 AUXHPjhYqGhpwbwJaYglTDxEu51+i6vCGa83AeEW3WzRAZsHjlEcp9Z1b7NpDPh3qGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VBUBho8t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 703A660A260E;
	Wed, 18 Nov 2026 20:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VBUBho8t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92AA11F000C5;
	Wed, 18 Nov 2026 20:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033859;
	bh=UsWQk8TTAOmELpaPtLjV+173kXJ0ptRUqo/UNBKFQpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VBUBho8tMZVcnmMrYN/MVjJXmiKSbzqpgdpAoHjWXg4gVp/SOYtxkxXoEveAdFqBt
	 n3R3uzbdSZdnn7YZFvNvibEmcO2DWkgeOC1MF/YDVhCVmNOOKx0ILnWkgUsWYSYWor
	 VPGB7z31XuNwcbfWqjHZHjJmAtw1meppLALNqNQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0123/3318] comedi: ni_at_a2150: Fix sanity check in interrupt handler
Date: Wed, 18 Nov 2026 15:12:25 +0100
Message-ID: <20261118150318.033213720@linuxfoundation.org>
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

From: Ian Abbott <abbotti@mev.co.uk>

[ Upstream commit e7356cdc7077a4f30fc5232a18e9fc6a4d404581 ]

The driver requests an interrupt handler for the device before it is
fully set up.

For safety, the interrupt handler checks the dev->attached flag to
ensure the device is fully set up, but it currently does that after
dereferencing various pointers which may be NULL if dev->attached is
false.  Move the check to avoid the possible null pointer dereferences.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://patch.msgid.link/20260618102949.26607-5-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/comedi/drivers/ni_at_a2150.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/comedi/drivers/ni_at_a2150.c b/drivers/comedi/drivers/ni_at_a2150.c
index df8d219e67234..cc106437de3c3 100644
--- a/drivers/comedi/drivers/ni_at_a2150.c
+++ b/drivers/comedi/drivers/ni_at_a2150.c
@@ -132,11 +132,11 @@ static irqreturn_t a2150_interrupt(int irq, void *d)
 	struct comedi_device *dev = d;
 	struct a2150_private *devpriv = dev->private;
 	struct comedi_isadma *dma = devpriv->dma;
-	struct comedi_isadma_desc *desc = &dma->desc[0];
+	struct comedi_isadma_desc *desc;
 	struct comedi_subdevice *s = dev->read_subdev;
-	struct comedi_async *async = s->async;
-	struct comedi_cmd *cmd = &async->cmd;
-	unsigned short *buf = desc->virt_addr;
+	struct comedi_async *async;
+	struct comedi_cmd *cmd;
+	unsigned short *buf;
 	unsigned int max_points, num_points, residue, leftover;
 	unsigned short dpnt;
 	int status;
@@ -145,6 +145,11 @@ static irqreturn_t a2150_interrupt(int irq, void *d)
 	if (!dev->attached)
 		return IRQ_HANDLED;
 
+	desc = &dma->desc[0];
+	async = s->async;
+	cmd = &async->cmd;
+	buf = desc->virt_addr;
+
 	status = inw(dev->iobase + STATUS_REG);
 	if ((status & INTR_BIT) == 0)
 		return IRQ_NONE;
-- 
2.53.0



