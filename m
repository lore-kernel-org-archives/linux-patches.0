Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039092;
	b=aT5/5ixD9V3DxDL6LoMpqv+qwFxUsAmcxIh4IBpLAGHO9rqhArrp+oE7SjrQpCWzxxoY
	 JRR8Bv5uuzQXxcYF9jVFQ9kmvmRNQ4cayazfBEteKAOxXh1ysOndzPpzRBI6Ce5XnbRgS
	 q1n/6ZHfDcvJzBr3gddqrawb4FYN8moOA2PN/KiYslXonV0pMsij+oNwyS/Oyo8Qlrwhw
	 21/N2itwSpN2NwFpH1O4BlsKQfFp0q2EpRjTadLiM2QpQGVVrYwqO/nkOVSDR9za4cvEo
	 BiJDcJiHGSeuavmaiPIl+YnzkX4bN1pKnBpncvWQB0UWyDjPmHbKclfFEQoWkfWWPPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039092;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LxyIY+iFpWCMr1358SMXXzK7MUd1P9pef7W0QcP/oV4=;
	b=GfqGHZWaqnLqf+7G06P8p3d9+PW4/Y5JUK1ls5VAAVbnQMC3AMx2oaRwUgw2ges2weWe
	 OCCL3BR5k5SMEBLvWEpBjOOjDxQ9wG5WoN8DwT4Ysj3TjHR9Ve5UrQfkD9hdzUEieeAYN
	 uicPJum8tjEYhOO3tZQVDiyjHsgH9MkmTHNj7inKL9OzYWVXHm0ZHpgg6g5liYmQx/HXt
	 yHAVS5gUQyETx4byVtiOI7SSAMjRGcH68udBUQQQEy1O0ORa+CSUhUt4M+sJ17N2w8mY2
	 LXa7YWbdrxnOdRduDUd/B5f8KhN2Op6WIQYuvE+9BQ/y0AEYwhjHR6PvPv8mn6aP6pA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NoLpJb4h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B2F9606A339;
	Wed, 18 Nov 2026 21:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NoLpJb4h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B6A71F000C5;
	Wed, 18 Nov 2026 21:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039092;
	bh=LxyIY+iFpWCMr1358SMXXzK7MUd1P9pef7W0QcP/oV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NoLpJb4hJZbBFpM3JYAJlKoJYuCiZwNOr7oMi8Nzu9eBDczmK7dD2o40zydZ9aOXa
	 7gUS/oSDG3IpIem38/X8fmdS0emVmd62J9vle5Ckz3o2fA8RDhemuewJ8PaY4zpwpI
	 E87ypKMVcG2D9Wj3mckmo4GoKNFb/FsoTIcHMWRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a4cedab706d0a8a3f988@syzkaller.appspotmail.com,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1977/3318] comedi: dt2811: fix shift-out-of-bounds in IRQ check
Date: Wed, 18 Nov 2026 15:43:19 +0100
Message-ID: <20261118150421.388789191@linuxfoundation.org>
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



