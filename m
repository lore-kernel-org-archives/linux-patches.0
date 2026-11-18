Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057326;
	b=TkIU+q8NavSzMlbFle/vFURzmzZoKvW6/wvRqnIG8HFsRec7Q0R2P+70idTZh7X/iEZy
	 cj0kZ1mF0nIImoh1j9SGvKShQSCg6QT/PE72OgOHoydKcNw6aSnG61pddM0lOMjgS8Ykc
	 PPDn9boTB0m23Sf1d4/KAkJHP22FhXYOwB/JSsvS94cC17EUesNCZX/VPaCpDR2nWXiGb
	 R204p6iJP+kR/hqyJF0tc3lbm2q8QIzc55grcpfUQ2sfzHvh0xBpqJdZp/y4BG7hoHIls
	 dwZ3Rz2mmSFoAbX9iqGLhWZ6ATM3pR7Yuy9xZ9bEExJ6/1XOB4h10Pn+zbl26lZfksQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057326;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fr7eIAQvrrF39eOpv6lf7VW71ANz3ab8fbmlBFDzbs8=;
	b=hurPH1suLTD8721nY3dTCxTGXjgWFSHbAOJG2MEJVK6OtrNXXx/Xhraz2txvczlFdxx0
	 t0uRmf+7zfAtM1+Mr8lNLT83wOJ65/n9l0TZcHns3YCwzjKZInJOUCtQhE5DHwMLyBNW7
	 iPefsC2rofmKBFqDWjTe+4xw4crvfRAzn0U57qLutJE4sMNOMJGmzUjdiK/gnWzWq21qo
	 UveArPRbyH1q60/gtZ0U19ma58ms5o51tTkfkO/oFTZucQPBTtuGhhYhlzdiR+uhs6kU+
	 WHS+36y4i6C0mg25Prb6ukcMMQxaB7RZIpVQYu+M5RpTtEeB7cSXQ6/9m5Prw/m5xJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EvGN4fVc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2CDB60A380B;
	Thu, 19 Nov 2026 03:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EvGN4fVc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B49F91F000C4;
	Thu, 19 Nov 2026 03:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057326;
	bh=fr7eIAQvrrF39eOpv6lf7VW71ANz3ab8fbmlBFDzbs8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EvGN4fVc5orPvgFBzZ2v6cl3+nGtEP4U8cLn3WcrvEZj6d9Sf7H1WhHoqxQLYVjzd
	 bS1f6F8rDluL7VxGAVuxQbHZa0lHHxbtInMtz3Ikl+aqtbbGEuwZiaTdgMYeiP5IgU
	 e8j5thci2fXmI0lQaQZbs1u9tMTztx1Kyd1idx2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaeyoung Chung <jjy600901@snu.ac.kr>,
	Sangyun Kim <sangyun.kim@snu.ac.kr>,
	Kyungwook Boo <bookyungwook@gmail.com>,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0089/1848] comedi: pcmmio: Add sanity check to interrupt handler
Date: Wed, 18 Nov 2026 15:35:27 +0100
Message-ID: <20261118145914.859002707@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/staging/comedi/drivers/pcmmio.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/staging/comedi/drivers/pcmmio.c b/drivers/staging/comedi/drivers/pcmmio.c
index 24a9568d33788..d1cd4bc7f36e8 100644
--- a/drivers/staging/comedi/drivers/pcmmio.c
+++ b/drivers/staging/comedi/drivers/pcmmio.c
@@ -363,6 +363,9 @@ static irqreturn_t interrupt_pcmmio(int irq, void *d)
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



