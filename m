Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057301;
	b=40gWRNDwwzMy1AGJGL98db22mj3BsRmg8L37AU3usHQDGGTnexnVqEGaGReAurUaf4Zu
	 PHUz3L4oiNzHzVFBwNr+45Gb+EesZ0l8npimILGQdw4puiwrEFOJP2H6BeL2Eqlx3w+29
	 C6Rv23muQuFEnQREkFpGuKuR7y8isNDAOoFvulcjwTKAW5jilhbW0Renz4q9fui+Yd+Vw
	 iYTe/3Pgy9bCl0DO/7Aglta5WJ2pnkyuRiBcreL7jvaq9lfLFaA/JCE/eXnWUsMwNRfbn
	 LZEw1HVRkLC4iFRp8vx7TV3bcjTLBvLIpYCxx1MYLNgB0N8YUVm3BEIx4rKneAJ+VCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057301;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+ZrYW+N55AYhPLyvXCghsVw9DYl12IWIn4CdyXLZEAs=;
	b=xasd+DCZs4FnSYDJiQr5gwyaLJVgOnTOAhgifW2dncxzwufPcBK6uMNEUGzfk6MvtJq0
	 NQo7Hqnp3zTX5MrdJzH/gf5L3+E3BaP8sH/TA2tpQraXoiE754UGDVwoFcoSUjbU3jLC3
	 Yky+8tpy3LW+paHYbU63cr8UJEq9s7FiDyUYRGbQhRbI2hZGPwcqcB+4Cu4CS/TBO0TAN
	 mYQ5lNM5OlMxvm3CD/36tvDs7lpP0V5lzapVOgsSRIK9V2Fz7v7eOK0lVQcX2viUqo9oS
	 g375Z5WFOx/HOpvCE/YRJeXy/Qf0VBccDc0j6xBxxSu6ChIaXLe1omzD9boI5sh4leQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A1qdMkxX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42C4660A2618;
	Thu, 19 Nov 2026 03:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A1qdMkxX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99BB21F000C5;
	Thu, 19 Nov 2026 03:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057301;
	bh=+ZrYW+N55AYhPLyvXCghsVw9DYl12IWIn4CdyXLZEAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A1qdMkxX2NR8SDn/OSVre09YmnhaacAG5/e6glNEkiF66KtMJvLnj9gnLiuT67C2N
	 PZvLp8kU+ar3mjwZ5nV5vRiWICrR7Jn/TMkyYuh0dMKKLyCohP5aaOjIE7NiiTTDfi
	 foe28KND1YjTYpEWmCefuPHBHAEvFYPO29AMaOFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaeyoung Chung <jjy600901@snu.ac.kr>,
	Sangyun Kim <sangyun.kim@snu.ac.kr>,
	Kyungwook Boo <bookyungwook@gmail.com>,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0081/1848] comedi: ni_atmio16d: Add sanity check to interrupt handler
Date: Wed, 18 Nov 2026 15:35:19 +0100
Message-ID: <20261118145914.513402069@linuxfoundation.org>
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
 drivers/staging/comedi/drivers/ni_atmio16d.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/staging/comedi/drivers/ni_atmio16d.c b/drivers/staging/comedi/drivers/ni_atmio16d.c
index b347878b13592..3b2e714b47249 100644
--- a/drivers/staging/comedi/drivers/ni_atmio16d.c
+++ b/drivers/staging/comedi/drivers/ni_atmio16d.c
@@ -224,6 +224,9 @@ static irqreturn_t atmio16d_interrupt(int irq, void *d)
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



