Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829593;
	b=35oeDqRQ4QAmZd2GAzKUKWo3D4eHIvlJgrt7/O0sQvS71owq+IA8wXttj0tAVs0DBlbU
	 4Lzf9Ws6h14OYoqdgtbX9BFjfcoqPE5e7Sm35eku+XUpYEWeOm8zoxEk+IZeWs5ykH28O
	 IXvOSGwzPtcEsEPhI1tsh3//eoSLvL1U1nqZvcmBZxLiaL0YXGAkHwrItB9rcvBek6zM2
	 Yu49mrLH4jP7UpZMfAqKkAguuRuF0iYRhe04DiFpQPRztlOsXNwkuNVWAeLifDKRqeL7Z
	 3fDjcw1TQ3mLiW+7Sku5QhQLnq7qkCSoqGxeQQXXhzNsTEzIPDX71ysU8OQvP7B3luQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829593;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O3XXSUEfvzGnk/OHxcCr468qTjThTChg915nHHwkonE=;
	b=1PoVGyc/uj0sybgba7MV92c07dMkHDw/jeic6q6oY08LA80ANRF9yqXIjpHkuIAhSOfm
	 Pbf8ljpm4IRz448GjUGqzRex0ve5aX9JZ57ZtRi7dhEunT4nK5FkfYPBk1Cki0xZ4U4TD
	 H1isyB7Hupgw7hV3neOW+mbvjR+rM92+Dv6lxDKGJyZYLXqG9+oF8sBx1Jpdv2s7x5m77
	 5Z+APliP6/60PcKygnxkWDsbdSQH86p1i7pHHacFPGceIaVobsIM5oSPsLjs4TIgEp1CR
	 rViEXGVV3Jx5vPnsB8JUgGAWFGhBg+iGRlprOOKmSjR/P5fptxgzp5QZMu0LNvq0Fzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jQMRV5Vf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1672D606B3B9;
	Wed,  4 Nov 2026 21:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jQMRV5Vf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F60E1F000C1;
	Wed,  4 Nov 2026 21:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829592;
	bh=O3XXSUEfvzGnk/OHxcCr468qTjThTChg915nHHwkonE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jQMRV5VfJOIXUsoGJMwUVyzIhU6RYVtKkff4lY8AvPNMvUCLGwARpjz30oGjiP1d1
	 eQKrD3bNcShb4II1IC3q7G9dMkoS7UmkPccfCl/EJafBiHmROxeCP2fmsybh1Ef0ub
	 rHX4XSpsG2LULV586FwPAGTiJ6cc7huFK2wILSOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaeyoung Chung <jjy600901@snu.ac.kr>,
	Sangyun Kim <sangyun.kim@snu.ac.kr>,
	Kyungwook Boo <bookyungwook@gmail.com>,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0184/1005] comedi: pcmmio: Add sanity check to interrupt handler
Date: Wed,  4 Nov 2026 15:58:37 -0500
Message-ID: <20261104211048.935778095@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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



