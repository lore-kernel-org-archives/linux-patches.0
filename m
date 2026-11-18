Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022747;
	b=4TuCefmMNC/ZiZve0Jy1LjD4emCB7p4D+Ohh9ARZXRF7TN3Mq7Vvrkhk6Uq0VpKJ6QrK
	 +jMBWxD5nqErIF0Ra4OGddXCS+Wy2/WsGpvXEryzfGsxkEooj2ICae6rSDW3JnEACImxi
	 1Ks8uEWXWnYUkAltb0qibJdvVFs19Hwl8MMM971vUfDSnjCThFR9ejmomJtYEE/6cUhoK
	 00925OeqDOVt1n9ng+BzOp2xMv39fOFRQe5fRuyOwy+YKQ9Vus2rFbiwJZD7yMappBJpk
	 wyPObQHlE1zRtf36SNFwaHGuDPdbwlGLCz3VZeqgJyn1YB1Q76Xn7RiR2g6meySZrcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022747;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OArW19O96+GTc1b+v25k3aEPUFECWV0a/LfrUDd9Cy0=;
	b=JHDetLY1VOM18Y0I4j/yFU3R0iLAtGOtr8oZSggbXIOgVcsrGMo27J2Vtv/Oi/Lavmtv
	 o7MC0+6FIE+bkeHu3lFc4Z3DrWNHMGyB8Sw46NKm2MeOi9G6XDM3yg9NPp7ecvmEKzlQi
	 y1VxS2oG3Aq4RX77PnmpX2akeEIYvNf3tp+9MLewT+O1QtZLmaNImZoCMU5gYpqMOwPIx
	 ebFb6r1xj95iZcjdj2SW6d+wJUexg6vHVb6vHilQohlpVLZqWLkRJ85DLvj61z2nMVaCI
	 zV88MJWEXBZ6IEYHHvNZde6YMB+Saf6O9/omZtSaoPVJFx4Du/jhdC1hdDIipsCebdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PybBfLrD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E587560A261D;
	Wed, 18 Nov 2026 17:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PybBfLrD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 438F21F000D1;
	Wed, 18 Nov 2026 17:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022746;
	bh=OArW19O96+GTc1b+v25k3aEPUFECWV0a/LfrUDd9Cy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PybBfLrDY1hMtC3HseiBG6qvLYEE7Nu2KgSKMdqD7AXUsnDFwo97o1FRrhlKIFuc5
	 LirC2X6U5mmsiVncZvmP57Iv9tiSd6w9P0eAqbFoMK/KOzaTGOJVTFZEMjRFuwbPJU
	 u7HSkjbDdUGuz9x5oCyXQvJ++YD9ROmq4Ct3SEFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a4cedab706d0a8a3f988@syzkaller.appspotmail.com,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0122/2151] comedi: dt2811: fix shift-out-of-bounds in IRQ check
Date: Wed, 18 Nov 2026 15:30:57 +0100
Message-ID: <20261118150126.233814990@linuxfoundation.org>
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

From: Pei Xiao <xiaopei01@kylinos.cn>

[ Upstream commit 471ce96a9c415b8a67bd5081ac2089a458cacc2f ]

The IRQ number passed via comedi_devconfig->options[1] is a signed int
that comes from userspace.  The check `it->options[1] <= 7` does not
reject negative values, so a negative IRQ number reaches
`BIT(it->options[1])`, which is undefined behavior and triggers a UBSAN
shift-out-of-bounds warning:

  UBSAN: shift-out-of-bounds in drivers/comedi/drivers/dt2811.c:570:31
  shift exponent -251 is negative

Add an explicit lower bound check (`it->options[1] >= 0`) so that only
valid IRQ numbers 0..7 are accepted before the shift.

Fixes: f2975a9b2ab9 ("staging: comedi: dt2811: add async command support for AI subdevice")
Reported-by: syzbot+a4cedab706d0a8a3f988@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/6ab21240.e548f532.1ca396.0018.GAE@google.com/#R
Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
Reviewed-by: Ian Abbott <abbotti@mev.co.uk>
Tested-by: syzbot+a4cedab706d0a8a3f988@syzkaller.appspotmail.com
Link: https://patch.msgid.link/02c46315293a26169d2a3862a2047959a1651ef4.1790061387.git.xiaopei01@kylinos.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/comedi/drivers/dt2811.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/comedi/drivers/dt2811.c b/drivers/comedi/drivers/dt2811.c
index c2ec5e4fb689f..c422317ef1398 100644
--- a/drivers/comedi/drivers/dt2811.c
+++ b/drivers/comedi/drivers/dt2811.c
@@ -566,7 +566,7 @@ static int dt2811_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	dt2811_reset(dev);
 
 	/* IRQ's 2,3,5,7 are valid for async command support */
-	if (it->options[1] <= 7  && (BIT(it->options[1]) & 0xac)) {
+	if (it->options[1] >= 0 && it->options[1] <= 7 && (BIT(it->options[1]) & 0xac)) {
 		ret = request_irq(it->options[1], dt2811_interrupt, 0,
 				  dev->board_name, dev);
 		if (ret == 0)
-- 
2.53.0



