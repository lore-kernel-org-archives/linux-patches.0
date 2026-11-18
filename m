Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033749;
	b=MyWu/VbCGukOcO/rRHg9P9z141nQNZBfdtH50MOPi2ZRqCAg3JKTUEpDqqMqasUEA2ia
	 93ssZO5jUueyCpBDiTJ4BrAxoKvJ7zKsaIjDtDx2Ps4EaN4BzQXT8ggtlm8kWDybTGmUc
	 M2XvO8IFtMih7sz+od3s1Yb7OcUyx2vagoUKfG9grweCs91IH6NkZuZVQ5cleWOhWDX/4
	 dJiOQ+/ZznwVzqjOTe/a89xbm4x+kQ5YeYi/oBn9LrMs5sdOvNULFVey6/qGi8b5ny6Oh
	 g7IaCWegtg9bzVgn3MimpYb6P3bprDRCf6Xd+oSyXHHUsavGRzzLtJhDHstz07pVxEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033749;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VRFUJ7lNBWbtUvRq+aXvSiKFX/kqRQuO4TzUYAyuI6U=;
	b=PNjoWCoNFwRSuyRDQ+7xC1aQQqQ9Wp1yeAhoRTbwlIIKo51JICgq3hXE2R4oqxiTQuJI
	 q8EghGsPVCIn7ykVznssxOXkYzrzBKEQLXOgMhSYvlSvhnokIJJGXtrIv60m6jTi413zc
	 AsM5os6DVhAAgmoP5kYx5njhulXyGfwcDROO93NOsSoy7R7KrIZsd5hs3NH7j6ts+t0Pl
	 uFfibTomDZeDxdOd7COdN+T8xbhUVLmDA1w+TJ3f1Dm3Krptd1B1YSG/1IJUtwwEc0bNI
	 2t/81O6q7qsx49JMP4sRv7vWlGbFIKNF2ebu16BVNwp6068dI2EByEiVCJiFLezEK2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oAguEC3v;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A752606A32A;
	Wed, 18 Nov 2026 20:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oAguEC3v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E96C1F000C4;
	Wed, 18 Nov 2026 20:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033749;
	bh=VRFUJ7lNBWbtUvRq+aXvSiKFX/kqRQuO4TzUYAyuI6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oAguEC3vw3yZVrctmNCvJavhSv+oqqhTdvPVUlPBGpFH2N4sEEhjF7Wfzz/0bXryh
	 LtBABh7ZlaKqiMtYAurg1y36GDVN6eTUkSmp3N0wHPddkNff7aV/D4QkjmsFpLN/eK
	 dINvWcyZ6dBEKPXiREYwQKSxuGlhWzqMA3FheaZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaeyoung Chung <jjy600901@snu.ac.kr>,
	Sangyun Kim <sangyun.kim@snu.ac.kr>,
	Kyungwook Boo <bookyungwook@gmail.com>,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0126/3318] comedi: das6402: Add sanity check to interrupt handler
Date: Wed, 18 Nov 2026 15:12:28 +0100
Message-ID: <20261118150318.140411007@linuxfoundation.org>
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

[ Upstream commit e90d0550c5b3056c8821f5cd714f80902de0fca6 ]

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
Link: https://patch.msgid.link/20260618102949.26607-3-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/comedi/drivers/das6402.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/comedi/drivers/das6402.c b/drivers/comedi/drivers/das6402.c
index e730668236c26..c6d28ff45725e 100644
--- a/drivers/comedi/drivers/das6402.c
+++ b/drivers/comedi/drivers/das6402.c
@@ -173,10 +173,16 @@ static irqreturn_t das6402_interrupt(int irq, void *d)
 {
 	struct comedi_device *dev = d;
 	struct comedi_subdevice *s = dev->read_subdev;
-	struct comedi_async *async = s->async;
-	struct comedi_cmd *cmd = &async->cmd;
+	struct comedi_async *async;
+	struct comedi_cmd *cmd;
 	unsigned int status;
 
+	if (!dev->attached)
+		return IRQ_NONE;
+
+	async = s->async;
+	cmd = &async->cmd;
+
 	status = inb(dev->iobase + DAS6402_STATUS_REG);
 	if ((status & DAS6402_STATUS_INT) == 0)
 		return IRQ_NONE;
-- 
2.53.0



