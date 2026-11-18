Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028804;
	b=LWQItG9YtHXP1PEEFSGD2LueCHiRgz3AiU8TQcokBvNH/yVYultvX2P3KrbGdW5rVxPn
	 JiG/BvjdeeGeuXCe7u2mkyVJ+t7fcD+IfjBwXsio0+GqtDgyv7bQ25RFYmS0tVhy5minX
	 NqwdaOFSMfuNmukEa9Dev/rx1pczBXMHZTQR9IHWnBSRsl19TUBSYYs3IWrqQ1yHNv4y2
	 EobPaM4n827OLa6mnOYK3GQLt9kPzsMUCODtRWzGR9btT1aIt7nl1bs0AdzvXXRMfcx9v
	 mT2Lu1EdwET0yQiwARmKmwgAtgUtzGUGGOmP6Hpd8mXKK5z0Ec9RRT0IzqNe92mmsiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028804;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/2TWDZMPdKqtGvKDBSsk70iWgIAItDuYGmv1oxMokds=;
	b=hDVh2XeB6j1uXQNBkY/OLS7NyjJCITTWOeEtDn0MIb7CXvZguyd4RuDxqeihy1CMIoMy
	 M0Ywu+WKz8OsM7+z8qh1FZrdEHiRpXLe9lhVBos1EBKZniaFiQRL4aYY8ipj3uH4s9xXA
	 dzyoSILqn4G4fCkLC7eZb7Yno5sp7nMjB3SbcEMLOkIykBfcxcLQISx53cfW+KEECrrI0
	 ABqXSVfUEcmV8q4YBy2ssnkVlg81EJek3wi/wzvwEHCHH5N35nxpa3i6/Zq8+3kfKU7Pl
	 8AAyL6iGKQg2wUGvsLK83kbrCPeCghoWb1nteV1YC36scD7Hc8ioned3LyTpvUa44zw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SD+ATzVM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89210606A31C;
	Wed, 18 Nov 2026 19:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SD+ATzVM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D76621F000C4;
	Wed, 18 Nov 2026 19:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028804;
	bh=/2TWDZMPdKqtGvKDBSsk70iWgIAItDuYGmv1oxMokds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SD+ATzVMqwvmGhE0CNe3UKPIfMvwbDPDgwryHagk5jIhQkiJvBoUWl1EIYmp60C/0
	 rqw+y1Ye28GPxnH8fX/0eJgW6WAwnXyzT5FX/FynsuwqUGORbSHUGrRdVLYu6oFxQr
	 a7ZAYuIn5Yzpxzif8ysH6+zWfvrjJygeFsCRmTWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a4cedab706d0a8a3f988@syzkaller.appspotmail.com,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0126/1756] comedi: dt2811: fix shift-out-of-bounds in IRQ check
Date: Wed, 18 Nov 2026 15:37:33 +0100
Message-ID: <20261118150013.220472692@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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



