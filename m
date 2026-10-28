Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213991;
	b=wbWJWBt2/ULlAeBB94Xrv8wrPBPYFX7YHk2ouMOh3NwHMUvTiHRGyWp3QyN6/wLCkmPr
	 XJqREHgl5ZRtZG4CWQmsSX8m83jpvBcnmBp8zgvy5NhR3f4hkIxpsZHWAjhgxKWAth+Ed
	 XZo7apMM2Wa0tJuL5JrcC6lChl3NAUFBq7QF6eXnjheX42E3FsNKe0a62t1AmQPqoUvse
	 olpBXkBXHdOpjBQX4WE7UjOir69l/OmdyLwwoFTr6lJjknFqEMFVqIBEhhJCoU5nXOByq
	 R1MqanIB4ltlec71SG2930lIEegsexp/hRn50YiIzOaUIJMw55hQjW5oqLkwPY63L5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213991;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HjHTnW2/4Pp+u/Xv3wamsu3r31fM8ITT/VARhfNZ0+w=;
	b=Vw+Bq9xIM7Ky8uG0tY347L7HJol1XRmaU04pOUpAfOEjigddvYJgbTe4W/g/g/OOs/P1
	 iyO+ITn5fM6soIIrW+MOnRx9lH7jgX8fx7DLeHPmO0J6NfxL8NPxKFyWz0eziGlFzCtD5
	 +I2aNs7ekXqw4p9e2L1Bpp81cROIR34gnBupUg9qwHOE1Fo+Pr30TnfhVn1YdBP50Xp54
	 mV9pjjnPx3m8N7pZW/aTyAOdcas2JGRmQ52OVT/Rjl+XfHPjK0JUkiu/llneqRl2BmfeD
	 zB4opn4kWcqpDZeLw295wPNf6g4okxuX45dfw+TAjRDLFHGOMs2m429urWITJ9zttAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JA9jo8lq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01D0C606A31F;
	Wed, 28 Oct 2026 18:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JA9jo8lq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 506F71F01825;
	Wed, 28 Oct 2026 18:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213990;
	bh=HjHTnW2/4Pp+u/Xv3wamsu3r31fM8ITT/VARhfNZ0+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JA9jo8lqbWhLP1r//h1QDcAN2n3vkNGdlOiEsL1PI9NO6KCh5qlz6K6XRcYnCBEMN
	 nU1GPKPZtsKQ8iRDbSBFiy7mPXGeNeoLSDuCreYXTygXhbqwbi22JEApERBiZWsq6t
	 0Y7SXgRJFQGGpj9FDDR6Z76ZiLFNQFSoTl+Xe1SY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+2159cbb522b02847c053@syzkaller.appspotmail.com,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0700/1887] io_uring: check for overflows in io_pin_pages
Date: Wed, 28 Oct 2026 17:46:36 +0100
Message-ID: <20261028170515.339457875@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 0c0a4eae26ac78379d0c1db053de168a8febc6c9 ]

WARNING: CPU: 0 PID: 5834 at io_uring/memmap.c:144 io_pin_pages+0x149/0x180 io_uring/memmap.c:144
CPU: 0 UID: 0 PID: 5834 Comm: syz-executor825 Not tainted 6.12.0-next-20241118-syzkaller #0
Call Trace:
 <TASK>
 __io_uaddr_map+0xfb/0x2d0 io_uring/memmap.c:183
 io_rings_map io_uring/io_uring.c:2611 [inline]
 io_allocate_scq_urings+0x1c0/0x650 io_uring/io_uring.c:3470
 io_uring_create+0x5b5/0xc00 io_uring/io_uring.c:3692
 io_uring_setup io_uring/io_uring.c:3781 [inline]
 ...
 </TASK>

io_pin_pages()'s uaddr parameter came directly from the user and can be
garbage. Don't just add size to it as it can overflow.

Cc: stable@vger.kernel.org
Reported-by: syzbot+2159cbb522b02847c053@syzkaller.appspotmail.com
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/1b7520ddb168e1d537d64be47414a0629d0d8f8f.1732581026.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/rsrc.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index ac658cfa89c63..1c5abe2dcd5e3 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -983,7 +983,12 @@ struct page **io_pin_pages(unsigned long ubuf, unsigned long len, int *npages)
 	struct page **pages = NULL;
 	int i, pret, ret = -ENOMEM;
 
-	end = (ubuf + len + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	if (check_add_overflow(ubuf, len, &end))
+		return ERR_PTR(-EOVERFLOW);
+	if (check_add_overflow(end, PAGE_SIZE - 1, &end))
+		return ERR_PTR(-EOVERFLOW);
+
+	end = end >> PAGE_SHIFT;
 	start = ubuf >> PAGE_SHIFT;
 	nr_pages = end - start;
 
-- 
2.53.0



