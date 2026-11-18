Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015099;
	b=GNxYcnocxedP+GcrPkJj9vRB+UwkbSkwNAsVEFcD4Y83x3FoKdQCkTHHh6Y84ADAivqA
	 IuSR0ZCfux6RLWi6SZiPHFXCQpw4jNs/nwvh8fxgNjz349w4pu2utOkKaDJmRcUgMacT2
	 rzH1q/B8+yPgILp6fA0ezkGJDf4Iz2d4yxWW7TctnrTIKx3L/7IyJTzD7aBTEwbPSJXiB
	 4ogEpLYJg5xFKAXxjnIJg/MC/Bfkfmg9Ltvuh4S3UdAtK1tCG6vm3irkUzwnR9Sb9orlq
	 wOW3nLs8l7gqGqSTOwoNzPm7kE2h9Ykq3vPMb+M0KgptXK0L0+eUd/SWLNUFeicnXyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015099;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QrYDYJ/Wa/l8PhXKIOxKRh/i0Dl9gfDI9V7aXD+WgjI=;
	b=uMbScSM3NIN9kYmzbyTOyLnG1/j3xrQ8b0YMYyd/M+6hEgWaXtkqAK8NQATMicenYD2f
	 HU5YgTyKyMIsEaTyU13xpstrVUeUhUlU7Mrvj8du9Wa6jsn4rP0S9peP0Vi6G2huICdzK
	 ook1LgMj6g2dIS8tQgj6e8PVGBegQsv2lkXlA/YrpEW7gc61Tr2d4zozxCycxi32eY2H5
	 KXW24FofFWXZGz3UzEX0KBimpiXLtB5oiH+BeloOkTWdajGhyWuJlM6OyWMQ29y7bz18T
	 Ao20TXmm9dpkQMQ/Hmndaw7mUj/sWS3MXv6TbZB6dIJyQEhnQ+CXPKO3kG+smERu11Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0AlLRMQm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D31160A263F;
	Wed, 18 Nov 2026 15:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0AlLRMQm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAB061F000CA;
	Wed, 18 Nov 2026 15:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015099;
	bh=QrYDYJ/Wa/l8PhXKIOxKRh/i0Dl9gfDI9V7aXD+WgjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0AlLRMQmlipLAzpzIUFGm+0VbvNIrlWkuXIOhiTymcs3TqpYVgXfzxC08K8trwd/3
	 U1UAVi44a90lNwpbaQzrBTxU5cPNttbp9JUmHk9CKghwxCwoCjIMzxfdrm+BWnC5M2
	 rGhBvy2fesc1HROtTp6V41+HKtMQMjxF9TRHspew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a4cedab706d0a8a3f988@syzkaller.appspotmail.com,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0052/2651] comedi: dt2811: fix shift-out-of-bounds in IRQ check
Date: Wed, 18 Nov 2026 15:21:32 +0100
Message-ID: <20261118150249.831300253@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 0438b8c90e441..53cb17993ae79 100644
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



