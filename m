Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043276;
	b=ifssae+Bnk3w2rWMC6uOzltlsEHcgxOIcz4q1CoFgjrxiQw8dBV/c6VQxV8lj43hVaFY
	 RQhAEEzk3i/JvurcWa9bms65+s6yljW5BpwSceJbxrUDvlN7uh+3iUKp7T5P2CKitQKnx
	 0iExE0ENcEQOIVRFlUi8mqC6KjoK5LyjOquRGk5FFGYdHLY+4QU4HOrDDxJwcNlGgJ4H2
	 ZYvWWYKhFKxHNsWvEvJ4tiuNpqiwFM+Umu0yoAbDSy1v27JA0XbaxduZGxDg4MHJCZDBi
	 idnShhI0ZcsmzBSxk7EQ5/edsGdA5yLEWKw8ql7CDfW//SKSO213OuGEXjR8Oqft4Cg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043276;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=I+7HBKtB/9A85C2gREHLS32pF5FEbl7STiZVP9ykfKM=;
	b=hygJSZIJaGv6cP6vVwtMbMq9DIFuCUxdL1n9meTnXu7KdU/ggloWwLIN11v/TZ1eWl6l
	 nMhmnk7XIijBOIsRQyMByNqTACr9DGMAWPKMpEfygsfYuqmexV7qTtWbxRp2G5oe1Rd0d
	 hhl4RE7o/DPOiOm1V5o02o5Hze37uiBHZuf45wjx/rdRUt/KybF5fRoPeba0hPWbkynNp
	 /Xbly2eTqHcJ/vqxk7cW6SaVySDkHdD30xc6wVBdSHJp1Hu35FaxzZmAe6pcGGAiCJXtB
	 KbmX76Vml3exaVouZ75SV8VqM3SjLRT7BlAOcNr+LpobukUUH/pzSQXxDjIiS/KGhtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="yOpWSPd/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64DC3606A32F;
	Wed, 18 Nov 2026 23:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yOpWSPd/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2AD41F000C4;
	Wed, 18 Nov 2026 23:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043276;
	bh=I+7HBKtB/9A85C2gREHLS32pF5FEbl7STiZVP9ykfKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yOpWSPd/Z+Q1dkcwtmjVfa7uQinyazR7G6qg9yg97Zm7iLkybpzSdS6IDEwfMCHLG
	 IGyQZEVkM25mwp9wD+NDqe4m9UiXLBjSWgOy1HphgOc7X3Nxej0FsCAoUIMZOztDhC
	 sI5RIHMh5he/LL9Vq0p4lDMOWHnlWFqIwh0m/hKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaeyoung Chung <jjy600901@snu.ac.kr>,
	Sangyun Kim <sangyun.kim@snu.ac.kr>,
	Kyungwook Boo <bookyungwook@gmail.com>,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0112/2857] comedi: pcmmio: Add sanity check to interrupt handler
Date: Wed, 18 Nov 2026 15:19:06 +0100
Message-ID: <20261118150205.364331249@linuxfoundation.org>
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

[ Upstream commit ea72e2fc9026f375314421ddfa4dbdc49432a899 ]

The driver requests an interrupt handler for the device, after setting
device registers to disable interrupt generation.  The interrupt handler
should not be called prematurely unless the user-configured I/O port
base address and/or IRQ number are incorrect or the hardware is bad.

For safety, check the dev->attached flag in the interrupt handler to
ensure the device has been fully set up, avoiding a possible null
pointer dereference of dev->read_subdev.

Reported-by: Jaeyoung Chung <jjy600901@snu.ac.kr>
Link: https://lore.kernel.org/lkml/20260610115912.780131-1-jjy600901@snu.ac.kr/
Reported-by: Sangyun Kim <sangyun.kim@snu.ac.kr>
Reported-by: Kyungwook Boo <bookyungwook@gmail.com>
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://patch.msgid.link/20260618102949.26607-10-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/comedi/drivers/pcmmio.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/comedi/drivers/pcmmio.c b/drivers/comedi/drivers/pcmmio.c
index c2402239d5513..db9cb3fedb48d 100644
--- a/drivers/comedi/drivers/pcmmio.c
+++ b/drivers/comedi/drivers/pcmmio.c
@@ -362,6 +362,9 @@ static irqreturn_t interrupt_pcmmio(int irq, void *d)
 	unsigned int triggered;
 	unsigned char int_pend;
 
+	if (!dev->attached)
+		return IRQ_NONE;
+
 	/* are there any interrupts pending */
 	int_pend = inb(dev->iobase + PCMMIO_INT_PENDING_REG) & 0x07;
 	if (!int_pend)
-- 
2.53.0



