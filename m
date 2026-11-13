Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585637;
	b=Szg+Q6UMS93BdtDGn/3v+hCwfcd/3dlPQh9VfAoEnwVZZKjTp1Xt8xjgDXhpdTmfF9Rp
	 F2H4SxnCfx7xJx/bHy2y0L0j5f9tn+d8Aq/WrATEAFDp9rYpmrbxgtZt7VCJmbKXTEWAn
	 946fp4hrWI3NnTUHuxmgGxV0MXpy+heEi/wOhwL1CoHWik8EVhjBD7vUaikwHoV+ePM5U
	 cl2LJRKdWP2LiOwvPSq6U/QDWwenxntZdZrBvFz2I3tqgej1qAKkrzxYD/fXj5CSw57wA
	 JDksXVjwipFY28P1Fh4//PUR71LgxILDN+5JKAR06k4ucg0gpLYKUxJ4iatEafvDV0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585637;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6b/BZArax8QYmPC07I9KKkuoOYw81m7vdDmHAOYICHM=;
	b=HUcuZ1Zg9PjOrz6ied9/HZq9a+vg+AHxU0RhesYsvp4//xEZiU/fyTh9KLQaJUk+4O9b
	 2umMGxNMy9DZq1qm0zxzfHO0iy7vccquRm5WSBh75IESeWfEbLOST1rjblGAOjWvNQkQN
	 hTcZvwlZsM6ONK8SxLsPn9KjzOAyvUWeXF1hRzI2PVbGpWT3v+cQMYU2kL1vlAByZWO5R
	 UOoGB517v7wuroUkev7R0Ka9ulRwiGE/KfH3oSvmlDmL6XakDIZozW4UdNHuh7thpH9mp
	 TBieYmvNgbIsqL8/xPwLLIktYmN17uRdpbgjzX7uUzPntSmk/CTSyk+GoLWwAT6m5eQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=avIbB8tY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D3A66072317;
	Fri, 13 Nov 2026 16:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=avIbB8tY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E51001F000C4;
	Fri, 13 Nov 2026 16:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585637;
	bh=6b/BZArax8QYmPC07I9KKkuoOYw81m7vdDmHAOYICHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=avIbB8tYR42sFcnxXXjfv3pDl5+hz1NBAxBixKRvzAZyWMo5Epj1/575/M7akjcbc
	 3JmMkARVE9vdVKGoMvdC03cZVFyjJ+pRQrHeCKySfnxOZ9WhPHKMoBsy9javgT3K98
	 iBFCxOttvDHjs2XGqH5FpjGJ92ymOoDxQidvkTkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nickolai Zeldovich <nickolai@csail.mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bradley Morgan <brads@mainlining.org>,
	Petr Mladek <pmladek@suse.com>,
	Rio <rioo.tsukatsukii@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 256/507] panic: zero the dynamically allocated taint buffer
Date: Fri, 13 Nov 2026 10:49:20 -0500
Message-ID: <20261113153803.230823864@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

From: Nickolai Zeldovich <nickolai@csail.mit.edu>

[ Upstream commit 723982e7052e65c3b31e8e8c815ffaf2ecfeaa8f ]

A %s read of print_tainted()'s string can run past the end of the taint
buffer while another CPU rebuilds a longer string in it, reading slab
memory out of bounds into the kernel log (a KASAN slab-out-of-bounds
report at taint_buf + size).  A warning or an unhandled-signal dump on
another CPU reaches print_tainted() through dump_stack_print_info().

alloc_taint_buf() sizes the buffer for the longest taint string and
allocates it with kmalloc(), so the bytes past that string are never
written and the object holds no permanent NUL terminator.
_print_tainted() rebuilds the string in place without locking and writes
the terminator last, so a reader that overtakes a writer extending the
string past the previous high-water mark finds no terminator inside the
object and walks off its end.  print_tainted()'s kernel-doc promises the
string is "always NULL terminated", a guarantee the previous zero-filled
static buffer kept.

Allocate the buffer with kzalloc() so its trailing bytes stay NUL and
every reader stops inside the object.

Reproduced on QEMU riscv64 under KASAN by growing the taint set while
processes took unhandled-signal dumps on several CPUs: the unpatched
kernel reports a slab-out-of-bounds read at taint_buf + size, the patched
one is clean.

Link: https://lore.kernel.org/20261024020153.830459-1-nickolai@csail.mit.edu
Fixes: a9dff0d0d11c ("kernel/panic: allocate taint string buffer dynamically")
Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Bradley Morgan <brads@mainlining.org>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: Rio <rioo.tsukatsukii@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/panic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/panic.c b/kernel/panic.c
index cec2716019355..f08453f0d8b4d 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -893,7 +893,7 @@ static __init int alloc_taint_buf(void)
 
 	size += 1; /* For NULL terminator */
 
-	buf = kmalloc(size, GFP_KERNEL);
+	buf = kzalloc(size, GFP_KERNEL);
 
 	if (!buf) {
 		panic("Failed to allocate taint string buffer");
-- 
2.53.0



