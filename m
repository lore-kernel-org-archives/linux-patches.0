Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060725;
	b=AhNPBO3PLB+MRRHQk9gvkXiwFo/NVZkivv05CufFJkqF2Abr6ybtWCnwIaHfuGhypYty
	 0IHfTLnq9i7tGMDznKv3Dy0oxewy+m/EI5U0rS6T7ZzONL4UM61fazjbHf6jOUDRrlVM5
	 B5+m1AP8Mgy+EsrNf+LsOt1AP6BLGORVvRquKCL8n3CiIo+fG+0qIZPBsuFoK1YIWSQEO
	 TcMrMOlLoz193dafuR33q9Ztv718C0KGRXR29/RZP0RT1SAy9qFH2DWCy9S7ZRlIo+gI9
	 X+2TcXqOcdI+KZ4iEZWANMNM4bTH8b+1Gq6mksgbypNg51n7WKHCAviqZf0XEcgrW7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060725;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tR0F9FGg+cSZZyGqPdExwcBW4KyniPQedKp1wa36uhQ=;
	b=Dvc+FgELrPPEQ+soVvamgjHLz0ywoVfYFs9zEPUOh9XYs3hKXQXUjUAgcwbYJGjbHmNL
	 DK65ZarX8x4+jurqFSdbq2xTIXftYlaCTsT6EDBvjCeQFFI0SlluDl14xwykmRbWcb1NB
	 8E+TNON7uIzkqbBYPzT5UBo2vnu/C3lO0PFFoPX3xSYNArq8pMGq7hYRUTrAHH4HkndRN
	 88WC++JFJwdoazBVuRoIwgZJ18bgoVhUZc+j99nmdPBN4tIwPR9FRWWyVAQI5Q9h4HCKH
	 Ye2tRlNPpLvx4iVCN794pxBtX2e+vL9/sNyXt8CyWOrAbJ3GOokKGFVYTiFQeA3/H4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KqJ0GMV3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22DD8606A333;
	Sat,  7 Nov 2026 14:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KqJ0GMV3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2B951F008A1;
	Sat,  7 Nov 2026 14:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060725;
	bh=tR0F9FGg+cSZZyGqPdExwcBW4KyniPQedKp1wa36uhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KqJ0GMV3gepX1c+kHcZbivwC/R6bxKQqk6BYcvsQv9ZKF8C1cWo81YeNd3Y0aqURG
	 WDxY8HroOQH/swb6TgKUurPXkIb5AO+rrxzmwpq4MtWHba6YOyzfThRsOpQ7c8QPMr
	 3NgNHTOx/mwHGo32SjF8LXfdb8R4BfOIDVy+/pTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0145/1536] comedi: ni_at_a2150: Fix sanity check in interrupt handler
Date: Sat,  7 Nov 2026 08:36:01 -0500
Message-ID: <20261107135001.762635179@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index e4e5a0ebd195a..93e9591f5dd4c 100644
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



