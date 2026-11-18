Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026396;
	b=HaaSLoFN+uxfYyw49T3vkT/zIbwlU3ayGX6EKU9bh8nBixFc17APut6YHLKDRT3oqjZ2
	 feZ8dl52HTrrvB0yi2IHn4b0Roi3q5p/1riEY2p45uT1/7OokdYk+UIefXXN4gpLBp8Bj
	 r90bktfD0qBhHaIKWg7YxJe9Hjtmf37DcGAoMtw3kgDqs/JCqwmLj835fZATKOS83pZEo
	 djPvhpP4EsAgHFKKwDuYoCl2ZxfCoI9l5cYB00e6ItSH9Z/C1y7PZa8rqcZhq2RC2iUcU
	 9/av6Nqo0DGHadxqWYDTO/dR30Rpxni7WfEkExQdD6GDKB5nImvwgx2+pmL+k4peJEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026396;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=G+SO3Q2Futb60AwGtTjXRzaMFMVxxZWIsbgHWQ5k6eo=;
	b=MFUW/yJJkx42CfxC+aN/as1xQJwbXsfqFMAle8Vo+88NeOs7ENQ7vSSYojFEKxoKF2CN
	 Qf3PWktQ8VUm33kNloVsRGmi/GY558LyMYjsa7DPqXa6D4AtZBIqw1DUEi2kl4dWzcfJW
	 sGPtgZDoIYlKCnlD4Tr17blfXBhuFR3OdaY90+NYPNo9zKFnnFDOTzqi/nrusHjJMNhgG
	 twVjmPrwpian+y+9qNANQKtHTCAAe2FLsrcZbcGB/F0KVOCGOHNIYIkM4bIBaN+bribdW
	 IIPo6j84gqsRB/Epfv5OikOq3nCo9aOOs9fp41O2OJMpe0h0MtpFBEJtLELHZv2YNFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GIdnf9Yt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 075A5606A31C;
	Wed, 18 Nov 2026 18:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GIdnf9Yt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59F2B1F000C4;
	Wed, 18 Nov 2026 18:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026395;
	bh=G+SO3Q2Futb60AwGtTjXRzaMFMVxxZWIsbgHWQ5k6eo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GIdnf9YtgpasAUTRlaReYEZXlgiY9bJlRP2+iDBrfsKQSP4kp5dLsqJxMlbg9QmaC
	 aW1P4/nd51XMXdJBTQc8iEU0qdkjeZd1xEg5TodOAUdEjD03WduB8ylYmjzZn8dMXE
	 9D81qNNxa6Q72rY2M1r9OuizbcJN1Ii2oAGeYkqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yogesh Gaur <yogeshgaur.83@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1418/2151] comedi: pcmmio: validate the IRQ supplied by userspace
Date: Wed, 18 Nov 2026 15:52:33 +0100
Message-ID: <20261118150213.616640685@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



