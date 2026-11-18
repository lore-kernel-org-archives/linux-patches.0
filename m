Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033856;
	b=EPQgpMV0Q0nh4SXWTey2yIFK8mYtlfmvNomrWo4ZL6xB3DOKPMQSOh//bkWD9UrH3d3p
	 z8x2nJbd+SZn6uL3OsBOLVil9zqyo+ZuQE5wCQYE5OzL/rwjZFuhY8Fv6WidioBD1A0jU
	 AWvKPA12NEbtxXOj9eyB9J+OHorQmuQ35DWEt19hWweJU7WYFC2IWYRkBmMK+/7XV89cD
	 ASZCwSBxq+YgKwNMgNIdVPKKiXH17nXlaGUQsqmFUvp7NKjb+w4rEHIJZdldFZjTbcQIQ
	 FsvVI4v0HxXObEPQrGzOYhyHjgwXGuyG+DmMH8BM5AfX3uy64ANGb5ETdF7KaXWOc4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033856;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MJlX0q6kQ6wBls8+KC8r4fMqgue61L7Mz7pUGAfvRaY=;
	b=3JCgjp4UNASh9n88OVAYTJoMOCe/DT7mafh/tj3Vf+XRc3kLcZGfiJXNU/RoPHjQREDH
	 esyTPN3gBIEq00af+XnW57/T2a70dTZBDoE6NBzRPMHFyIt1Zj/9S7+2kD7mqEGXywkam
	 Bl6Oz9rNP5X3FGFgOpvcsE+5CCErvadSYWOHUSHCqTctRJieKnFZPAJUGOU8i0QihwH0n
	 +O7vRODwP1kqq0pPbSfQLEmYRkwRt2cLnuX626IzFcA3Evn0/dPGqXmomu7Pn66n0oS5h
	 c8SywJlr+5vJSikP0xF0JScoM2q07Wm2g6YQFX3MRqFdxDQ/FX9+IMQxrBmFvKzMBXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YAFz+Kb1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 791F1606A320;
	Wed, 18 Nov 2026 20:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YAFz+Kb1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3CCA1F000C5;
	Wed, 18 Nov 2026 20:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033856;
	bh=MJlX0q6kQ6wBls8+KC8r4fMqgue61L7Mz7pUGAfvRaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YAFz+Kb1hJ0SjFmWBHfZSBDVDCwVmLKiyDgz3Bi43vOnj8zntMVoBxITPIuncf9DJ
	 KDgotleMaGK7M1x7N+nufMuHPLBTMqTf4huC2cQbARDswiywB/H77789nHgV6tbVMT
	 A9jev80uo6/g1OdZSM3qlsBvaPFc4DzhGoBfFKmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaeyoung Chung <jjy600901@snu.ac.kr>,
	Sangyun Kim <sangyun.kim@snu.ac.kr>,
	Kyungwook Boo <bookyungwook@gmail.com>,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0122/3318] comedi: ni_atmio16d: Add sanity check to interrupt handler
Date: Wed, 18 Nov 2026 15:12:24 +0100
Message-ID: <20261118150317.998095536@linuxfoundation.org>
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
index e01ab5311d235..b4c25a8b8d40e 100644
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



