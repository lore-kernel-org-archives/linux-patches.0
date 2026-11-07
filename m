Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060724;
	b=S4eykB2alLlRg9Zrtlj54VdiqAinGwK7aJUdOO8TLEh9FH3mWcskDbdvYy9GuPsqLWUZ
	 QawXWfGlCIBaHcR8uzMi2+6kp4J23z+2PzF5rZejm4N0wTlTfo7aHkQtNCP7GmPPIuM8I
	 l1FeKviBCFSsTo8RqIpwz9LnF/XGn8wOvBopr6b6AQAnBnQJs2rb6mU6SR8wtZQvssFdX
	 6gMPbJDMhtIadDdSmubqYm1rix42mm6JJQIG/r5mlYsdR9IY8lIwFeQ1BZK14Yg3X7G94
	 uagfE9JYMI1igy42dwDUekiSbk+DsuOAdd8JYLmue9LtqL03q4p/AEXqLI4KHxW37SQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060724;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BZWzGt9Fw1XLAiDsf9m0ZYWwER9WCrrm1bWmelCqog0=;
	b=ybkWOnm3NGud7BJECJNCZNvOM+TKAzJSK+EFgw6y5Byr93JgTMaVtdARE4ItQcvGs7yX
	 hW9JkxyvvWT2PuuSY7g0E7lIutuoJv6BbsyBuOXxNL2P+t2BexUwQGXEBVNzgpFiTVQrS
	 S05LkM1V4jdjF26E2ZaGGlWR5huJComGfLCkDVyyxclEzb5YKL73mmWub+u5AkV9JW7+c
	 QyVulXuF9iIRLYznCSw0w+snatZYZdyTAUW8onWTTPi1pafJ5+Wh35+D11Kf9mprHU/+d
	 algsD02prxWzkYUN8feZtFJaPeqs15+ispx8oTHS2M6u5ZzfPBsb8sOwhaiwbbmUAKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i848tX8x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9E24606A326;
	Sat,  7 Nov 2026 14:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i848tX8x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 842C31F0089F;
	Sat,  7 Nov 2026 14:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060723;
	bh=BZWzGt9Fw1XLAiDsf9m0ZYWwER9WCrrm1bWmelCqog0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i848tX8x4AzIhA+6IUXCR8tLeG9WFoSKXESLLDYfebaSlhEcZa/v+bKkjPX2CTmiJ
	 oXegPiRN4AB0ZtyQPWYqYqxcX918Xax3nn92fIlzXtnWR9sdZXhKdlbenwf1Vn50v6
	 z5xgFCBr3TyLT9bI4yX6lAI2AQZeBjGR2Rk0oohc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaeyoung Chung <jjy600901@snu.ac.kr>,
	Sangyun Kim <sangyun.kim@snu.ac.kr>,
	Kyungwook Boo <bookyungwook@gmail.com>,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0144/1536] comedi: ni_atmio16d: Add sanity check to interrupt handler
Date: Sat,  7 Nov 2026 08:36:00 -0500
Message-ID: <20261107135001.736378609@linuxfoundation.org>
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

[ Upstream commit 13f4796223489a5349b466ce54bb868f46c9fefd ]

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
Link: https://patch.msgid.link/20260618102949.26607-6-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/comedi/drivers/ni_atmio16d.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/comedi/drivers/ni_atmio16d.c b/drivers/comedi/drivers/ni_atmio16d.c
index b057b3b3582e1..bf7fb6704710f 100644
--- a/drivers/comedi/drivers/ni_atmio16d.c
+++ b/drivers/comedi/drivers/ni_atmio16d.c
@@ -223,6 +223,9 @@ static irqreturn_t atmio16d_interrupt(int irq, void *d)
 	struct comedi_subdevice *s = dev->read_subdev;
 	unsigned short val;
 
+	if (!dev->attached)
+		return IRQ_NONE;
+
 	val = inw(dev->iobase + AD_FIFO_REG);
 	comedi_buf_write_samples(s, &val, 1);
 	comedi_handle_events(dev, s);
-- 
2.53.0



