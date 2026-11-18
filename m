Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051115;
	b=Afu7W4Ibw/ixSM22FPeJN4PGvvT2W33FMwf6ZJVHK/d6F/EVA209GVu+qGhhPO2FOMdE
	 p2zB6uBu64CXQZ4Ebhk9EiZElKxm+3wZE7XIMZ+bZav1NxqliA/zr8MKn7vR68gh63J6k
	 hOM+WOuZ4AsstPHh9tHyipbVss+j4CdgPT+puwCxFfYsLmX7yFNRB5oJT4r1Hh6+O/Yvw
	 ZG2SicUvpqg5V+3L+VriKQ6+t0fhg26RLGTMQ/r5hDBPzcL2tmUq25bM/fOzzQKVXjrCs
	 S++MBtUfljDu1i+zgwPl3eeXan1upEJy4WeukyjPIpu/XjYONTvJqnuDgbTKfi+z9JQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051115;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YO9BqM10Ho64o+p1cN2HIohJeOTcr4FtXq41RCWD8tA=;
	b=BmuiK5GloTijVGS64wFlvYg3zixWkwupYRVH7S86v50TZFkiClqtVYbSew/UXMZrOZuC
	 ph4aNCZ6Gu9nMrNUr1OR3yFdwWMlMStNn801+aAYLthwxCdjGY2avrOwWBDVkEwA5/RQ2
	 T2MGdDwWzujJxMdG+nWOVq2JWH+qjPTA1S+E2T4foJu2m9GGcsYIVdaxhr6sTWFj0+4jz
	 quCkL1UC/Vqah7ZlqRFGkPbSGiXD6IQ+0JjSwUOQ4zgKXnXbort7w5xzAD+L1xqzYgNzv
	 D6IGVBFmu0obfd/+Fp+lHjabo+FbFotqTj1pGTFOJTySgvszf4SJYEivu+huDT2T6fw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EUmR7YKy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B83C2606A31C;
	Thu, 19 Nov 2026 01:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EUmR7YKy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 152C81F000C4;
	Thu, 19 Nov 2026 01:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051115;
	bh=YO9BqM10Ho64o+p1cN2HIohJeOTcr4FtXq41RCWD8tA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EUmR7YKy5j5uOLhYoIVUUR0pbs/06w65vzFym8UvmgfbB8ou45lsNqWwq+VE6d+7o
	 OwMZT5+vI1q9Fx/tRRQy/h+5uVIQouGDF6lVkJBdsYpkp9xeRSQLdH/jlNM5L/yOwd
	 W7TGyazSlMyEpB7qPT5n12rwddEVhvafkmmgAQn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0095/2214] comedi: ni_at_a2150: Fix sanity check in interrupt handler
Date: Wed, 18 Nov 2026 15:29:31 +0100
Message-ID: <20261118150013.757636759@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 10ad7b88713e9..c3dae81fa8234 100644
--- a/drivers/comedi/drivers/ni_at_a2150.c
+++ b/drivers/comedi/drivers/ni_at_a2150.c
@@ -134,11 +134,11 @@ static irqreturn_t a2150_interrupt(int irq, void *d)
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
@@ -147,6 +147,11 @@ static irqreturn_t a2150_interrupt(int irq, void *d)
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



