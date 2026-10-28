Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212275;
	b=YLKWwSD9BLIsvI0bQNUxKP+YCquh3kIF5XQ3H6OoDEKX5K+V1RE4vsKXV9pB/oHQHkpW
	 T7cpHLDk3D05BGCofdIc4PVMhjHAIIfd2RO8nSmKih2SNvIwkKPPI3GGGPta8/ZxYSvBI
	 lV2i4fcYWCXfFEDlKr6n0AqCLlhh4D1ACEWsJH0GPAaojIZPzyV1+wDAQzbliPWWYek80
	 Nd2Or0m8X4V+5Wp8gHLLhuN8PnMN7epu9IV2QgA97NBTL5ZqBKveKaPzki3XX2n4RaIFw
	 Zmmik61NuYRJoMJSdf1qjDysJJhDRYV8xBxVcrhga0g2NOmW9oCsc0YmXml/SZiWJJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212275;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sbkjhc/tDFXmy84LTQfGEUJISIcdzH+YYsFhDRKBLYs=;
	b=oJysam1GBn72WJCc7oAKc2hTdAvvMOc0t7QExD9itLc436rwJnrFOV/xa4+89yJilGvY
	 ICYtw1x2ilgpp4VXd6jKnQwQRInsEZofWxwbu4rTasipteTVi9wUaXtWkxTYWP4nMKcXt
	 M2flnJ2knk3LEBCfGXxzAU7Y14QyPIcy7n+2H19sElmPh0TE11yCgL1WmaSs/eIh1YE6W
	 OEIB2nMt0JxrjqpI/QdGvt6kO6mp7JOhhpBdBIyWJjrrA3LhQegc8oehcp3z3jPO21Rh0
	 U8tA0oKY3PdPRR0NR8IsNCK3WqwYQmqlf/uAXoz7u2HsE/ZLkXmriVMwTWUY09F8J4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xz7wn6Bc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C88A606A31A;
	Wed, 28 Oct 2026 18:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xz7wn6Bc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7276C1F01825;
	Wed, 28 Oct 2026 18:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212275;
	bh=sbkjhc/tDFXmy84LTQfGEUJISIcdzH+YYsFhDRKBLYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xz7wn6BcDDlUThJKwFyypuu95vsTHHQb08Qcnm2TzkZqMJntgJ3nJdK2v6TVytARb
	 1JDYpnJwOEMOvhx9YFau1qqeNUa5dGH3MX1HVAX4wqlS7gflfiJoSqdwrKJUe/OgrL
	 eeQR/MBALulhmZF1mEIE0pXQRwYnZOjwkHhQfcbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0098/1887] ftrace: Synchronize the initialization of ftrace_ops
Date: Wed, 28 Oct 2026 17:36:34 +0100
Message-ID: <20261028170501.463725678@linuxfoundation.org>
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

From: Steven Rostedt <rostedt@goodmis.org>

[ Upstream commit 4617721c502b2ddaa4e324e86da4997edf738fa5 ]

There's some internal state that ftrace_ops needs to have set, but since
it can be declared outside of the ftrace.c code, it calls
ftrace_ops_init() on the ops in every global function. The issue is that
if two tasks call it on the same ops at the same time it is possible to
have the initialization of one corrupt the initialization of the other
call.

Create a ops_mutex to use to synchronize every initialization of the
ftrace_ops. The mutex is taken within checking the ftrace_ops flag that
states it was initializied but the flag is checked again after the mutex
has been taken. Checking first outside the mutex allows it to shortcut
having to take the mutex. But then the check needs to be done again after
the mute is taken in case of races.

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260902095501.6b59af20@gandalf.local.home
Fixes: f04f24fb7e48d ("ftrace, kprobes: Fix a deadlock on ftrace_regex_lock")
Reported-by: sashiko-bot@kernel.org
Close: https://lore.kernel.org/all/20260829025528.49A831F000E9@smtp.kernel.org/
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
[ adjusted INIT_OPS_HASH macro context for the missing subop_list member. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/ftrace.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index eee7bb2843940..359cea3478b65 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -71,6 +71,8 @@
 #define INIT_OPS_HASH(opsname)	\
 	.func_hash		= &opsname.local_hash,			\
 	.local_hash.regex_lock	= __MUTEX_INITIALIZER(opsname.local_hash.regex_lock),
+/* Used only to synchronize the initialization of ftrace_ops */
+static DEFINE_MUTEX(ops_mutex);
 #else
 #define INIT_OPS_HASH(opsname)
 #endif
@@ -128,10 +130,17 @@ void ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip,
 static inline void ftrace_ops_init(struct ftrace_ops *ops)
 {
 #ifdef CONFIG_DYNAMIC_FTRACE
-	if (!(ops->flags & FTRACE_OPS_FL_INITIALIZED)) {
+	unsigned long flags = smp_load_acquire(&ops->flags);
+
+	if (!(flags & FTRACE_OPS_FL_INITIALIZED)) {
+		guard(mutex)(&ops_mutex);
+		/* Could have been initialized before lock taken */
+		if (unlikely(ops->flags & FTRACE_OPS_FL_INITIALIZED))
+			return;
 		mutex_init(&ops->local_hash.regex_lock);
 		ops->func_hash = &ops->local_hash;
-		ops->flags |= FTRACE_OPS_FL_INITIALIZED;
+		flags = ops->flags | FTRACE_OPS_FL_INITIALIZED;
+		smp_store_release(&ops->flags, flags);
 	}
 #endif
 }
-- 
2.53.0



