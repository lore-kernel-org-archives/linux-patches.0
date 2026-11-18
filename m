Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054552;
	b=pseox8FVRSWDv3YcJlB99Fj3t4PmoRm3XLS/5xQjd6aWOkCGsU4CW3X1AZ+2O4d3UtPX
	 b36NI5Qz9AYHqrvvQBIH7HBssRMK+nIFIJDc5Cu/VyD1T+CMAwiQhDPUiN8KgNCq2dqIo
	 PVa25prAgq3ymozV0I4hN9uXer7z6jO1ydGpOtoLGpYzvDFYaBs+uD4Ip0GYWkxd378bk
	 QrjdkOdVadWImJSPEKFeVrspukHzKpSwFjBaV7ca1oKlpZWCHiWAQH+N0uaNS8D2284Il
	 2adeclreZecJq5mI9wQyfWNyDBFS8JZzsERFpqIt7D/3dUBIf19J4M4S/4svXaHwKvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054552;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t8jcoFm+j1uRrXwx0Fj/t7LOpmsPmzVqegT1wKl14TA=;
	b=Gk9XIMOuHGg8pcIo0FkDcLfjn61YLacfqJ9IMCajiy+rxPLossbvCxN+GYU2h4boCtFL
	 b2iR4vUuFwHVw1OMRYgsdUW9rxaHLKPIS/U/bJ84imNvUjkp4MSJ4awRHU+4PelXUa5Wm
	 a7pAXopOitd5f8v3rfT52j4Cech5wcq5NbAEcdadBL+KPr3ShVUumee0RP/fh6sDXOBQZ
	 P3mNGHmMCIb5y0CgTsnAskdz0/1m+1g7rpufh8570UR6RA6BcdvQ2qKTl72YgFdzYmRpR
	 1rgpzOwjUDYyPEALEsR2iz6QHF0uerNI85Hp0TXG52ejbUy3pmYvUR5QUYLAi3S81dw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r+vKP3ME;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DF1E606A325;
	Thu, 19 Nov 2026 02:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r+vKP3ME
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7EB31F000C4;
	Thu, 19 Nov 2026 02:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054552;
	bh=t8jcoFm+j1uRrXwx0Fj/t7LOpmsPmzVqegT1wKl14TA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r+vKP3MEu/Ec/Jr6/W3qT1ziW2O4ZbfXMX81/O8E1djILSEFqyCGlJknDvii/oube
	 rGCXQQUa0/Bkr8Bem39pmamxY+vaFtZB1WXrxxLBxiZJO9DSKZn1gji+n86BjvJ20+
	 lYTLWBmTggFd1cBx2AK9+Rj6HSYqm25yY2VZ8xlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a4cedab706d0a8a3f988@syzkaller.appspotmail.com,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1315/2214] comedi: dt2811: fix shift-out-of-bounds in IRQ check
Date: Wed, 18 Nov 2026 15:49:51 +0100
Message-ID: <20261118150104.089925351@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index d94d3c64e264b..4b9ce083e189f 100644
--- a/drivers/comedi/drivers/dt2811.c
+++ b/drivers/comedi/drivers/dt2811.c
@@ -567,7 +567,7 @@ static int dt2811_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	dt2811_reset(dev);
 
 	/* IRQ's 2,3,5,7 are valid for async command support */
-	if (it->options[1] <= 7  && (BIT(it->options[1]) & 0xac)) {
+	if (it->options[1] >= 0 && it->options[1] <= 7 && (BIT(it->options[1]) & 0xac)) {
 		ret = request_irq(it->options[1], dt2811_interrupt, 0,
 				  dev->board_name, dev);
 		if (ret == 0)
-- 
2.53.0



