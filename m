Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062519;
	b=pfU7J9RGPWmzG/vZRPrGoAcBJQy1Z+bwtoDD0uCLRB7N7UkHY+9rt+NiY4MH/CJeYLi9
	 WIst6PUP5olrXYT05iBI8nV5qHPA0ZpptZg4sIQDDvmEua/S6brKGbTUNYdjYjUGhgxVD
	 wjlsf8DX5XZ8hweCsgAoZnE9P2132x20f66yARytcc1OJr4HNv1UyN5Zw4GNVJJneRWF0
	 A1pczmLgMY7Yal4JZRGhrTi/JVVaaCWKNzhdrpqLAUdJvEV4N1WRp3/rYuN7MnfQs6N4s
	 vFqHk4L53J1OAEw0Ttb16Rr3hOdZX8FmEA3OKEClOOajHXVSSvLqR8E9CHvAuim2Pxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062519;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gm3dlfXAIRsHFNff713m/IGsXEQq7XZbJ+b0+dY4tCQ=;
	b=h8uxfmCwzC7tDxbaAT1wbWs9lkmNpKfJEt1jWcaLfC6+4ulrl9Q/yTrbGxxsSg5H0lUq
	 qKrUFlh8iULagV/lywrSNGTO64afK5yoGAonCJBQFSQzXX8XP3nI+BNfJK5f5MYOkJCfx
	 kLoSX12U/NUWKNBirYydg62DJUvj5VZshp61hvhnWZUehuZCS7tSAc02b6/1iDyMocy1U
	 JFhyHj5nwVIM+Gx54BsUPr1PiVlYRqVvAYm7/97bktumGInu+9N8EVbkTMORQJIOVu7nb
	 suzs9aNdEVkt6AG2/2RIS7imiyjA7lH1c3/Ph0CeIq9ZQJ6s9CUwbtVJmXz8j0j40FQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zLX6QeXV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D30D5606A33A;
	Sat,  7 Nov 2026 14:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zLX6QeXV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6819D1F0089F;
	Sat,  7 Nov 2026 14:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062518;
	bh=gm3dlfXAIRsHFNff713m/IGsXEQq7XZbJ+b0+dY4tCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zLX6QeXVh8JhzF4reZZayoxwACQgqIOpEUjiCJbegLnPzd9E26oLys9871QRsB5iV
	 rUx8cL8rA6n+cbGbVV/eft1wbTwcRNnI20ydrJal8x0ha9QIJ5giSJ3wKkhqiV8eQq
	 RzkaeY4nZ5zGcSdK2Z/Paw69L2BrCmk9P/OG6e3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nickolai Zeldovich <nickolai@csail.mit.edu>,
	Alexey Gladkov <legion@kernel.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1414/1536] ucount: take the rlimit reference before checking the limit
Date: Sat,  7 Nov 2026 08:57:10 -0500
Message-ID: <20261107135037.541214432@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Nickolai Zeldovich <nickolai@csail.mit.edu>

[ Upstream commit b14fcabd34e02c40f72d3cd1e9bd4fd18df40ff1 ]

inc_rlimit_get_ucounts() takes the reference that pins a ucounts level
while its rlimit count is non-zero only in the walk whose increment is
the 0 -> 1 transition, and only after that walk passed the limit check.
A walk that raises the count from zero and then fails the limit backs
out without the reference, while a concurrent walk that raised it past
one keeps its increment and never takes one either:

  CPU0 (obeys the limit)              CPU1 (overrides it)
  new = add_return(1) -> 1
                                      new = add_return(1) -> 2
                                      new != 1, no get_ucounts()
  new > max -> dec_unwind
  sub_return(1) -> 1   (no put)

The count is 1 with no reference held. When CPU1 drops its charge,
dec_rlimit_put_ucounts() takes the count to 0 and puts a reference
nobody took, which frees the live struct ucounts, and the user_namespace
it pins, with kfree_rcu(). The mirror interleaving leaks the reference
instead.

An unprivileged user reaches this on a kernel with CONFIG_USER_NS=y: in
a user namespace with RLIMIT_SIGPENDING 0, one process taking
synchronous SIGSEGVs (forced, so override_rlimit is set) races a second
process in the same namespace and uid that queues real-time signals,
which obey the limit. The two hold different sighand->siglock but charge
the same per-namespace SIGPENDING ucounts. Unpatched, with rcuref
debugging:

  rcuref - imbalanced put()
  WARNING: lib/rcuref.c:266 at rcuref_put_slowpath+0xf4/0x120
   put_ucounts+0x5a/0x180
   do_dec_rlimit_put_ucounts+0x70/0x90
   __sigqueue_free+0x33/0xc0
   get_signal+0x56f/0xd20
   arch_do_signal_or_restart+0x87/0x380
   irqentry_exit+0x243/0x650
   asm_exc_page_fault+0x26/0x30

Take the reference on the 0 -> 1 transition before the limit is checked,
so the walk that raises the count from zero owns that level's reference
even when its request is rejected, and unwind a rejected level through
do_dec_rlimit_put_ucounts(), which releases the reference when the count
returns to 0. The get_ucounts() failure path is unchanged. With the
patch the same interleaving, forced some 80000 times in a KASAN build,
produces no warning and no KASAN report.

Fixes: 15bc01effefe ("ucounts: Fix signal ucount refcounting")
Cc: stable@vger.kernel.org
Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
Link: https://patch.msgid.link/20261019185913.805378-1-nickolai@csail.mit.edu
Acked-by: Alexey Gladkov <legion@kernel.org>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/ucount.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/kernel/ucount.c b/kernel/ucount.c
index 8340f767c1aea..b731d13e6b766 100644
--- a/kernel/ucount.c
+++ b/kernel/ucount.c
@@ -317,23 +317,26 @@ long inc_rlimit_get_ucounts(struct ucounts *ucounts, enum rlimit_type type,
 
 	for (iter = ucounts; iter; iter = iter->ns->ucounts) {
 		long new = atomic_long_add_return(1, &iter->rlimit[type]);
-		if (new < 0 || new > max)
+		/*
+		 * Take the extra reference on the 0 -> 1 transition before the
+		 * limit check: a rejected walk must not leave a concurrent one
+		 * holding the surviving increment with no reference.
+		 */
+		if (new == 1 && !get_ucounts(iter))
 			goto dec_unwind;
+		if (new < 0 || new > max) {
+			/* undo iter too, releasing the reference taken above */
+			do_dec_rlimit_put_ucounts(ucounts, iter->ns->ucounts, type);
+			return 0;
+		}
 		if (iter == ucounts)
 			ret = new;
 		if (!override_rlimit)
 			max = get_userns_rlimit_max(iter->ns, type);
-		/*
-		 * Grab an extra ucount reference for the caller when
-		 * the rlimit count was previously 0.
-		 */
-		if (new != 1)
-			continue;
-		if (!get_ucounts(iter))
-			goto dec_unwind;
 	}
 	return ret;
 dec_unwind:
+	/* get_ucounts() failed for iter: undo iter without a put */
 	dec = atomic_long_sub_return(1, &iter->rlimit[type]);
 	WARN_ON_ONCE(dec < 0);
 	do_dec_rlimit_put_ucounts(ucounts, iter, type);
-- 
2.53.0



