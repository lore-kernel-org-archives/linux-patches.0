Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214204;
	b=DqUNSdNJdCsOYGmx+gYJTKScRVHp68zbVvuU2a4PzV/RXP4TShgBqj+FtoJ7nQcxByl7
	 HQwHuyK/0swUbJ+4WGNIQrHaKR2lCS66ypbKZCTJB1txOn3uaro/VExGJzKG3/0sJW8Tc
	 1eocAY+j9x9txwncJl0ttgRLouh/OwpZ5+mvsrG9ETHblscXsLQsgBTp7GegZtENpRTE9
	 yKc5N48jf3d+0jBbJKnLWmJ7s/6d5WHuycActxVgm1YSsw36i+tr2DND23opG7ZVJQmLv
	 sg2BrAUsqnPXbiEndVxdd+U8CaX1vXh0g9I7JYqUG7C8h4ULna6HFGdr+rUqeMlAFfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214204;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GYBpHWPOVID0UbA4U/vcMsRhp+ufO+UUeEi+hPObSs0=;
	b=0VT9IpaTxHcsID9mfqugJuAO7XlwmRTmXEApjdqkwNGHk6uKpSIvGeoaFnyp8SvMMW5Q
	 VOO4NKyQFW1pjwEUV1aHGDgVYUqHACFeL8/mjQfX0Pm1VAz7BJRGYWOtdMovlFHWFSxAG
	 iLbth/h7SXwQjy5/yVesoLzCFlN3FfIy5+w1nPmptuWeNbKz36zZWzLEI3wdTTxRCNw75
	 al/vyZQpY/Lo0v+fOLFivOImbEN0CCSgP5DRSsYw6JZiRmFZSwXIrOJiXm6YNtyJ2zIPe
	 dTM06cBBr48yIeSFjW7u9HdRjY/4Tjs+xnuPH6E7EjolGFoiKVMHyaJSdiI0cLNhVrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gkRLFYAw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33BC9606BFA5;
	Wed, 28 Oct 2026 19:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gkRLFYAw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86AA41F013CB;
	Wed, 28 Oct 2026 19:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214204;
	bh=GYBpHWPOVID0UbA4U/vcMsRhp+ufO+UUeEi+hPObSs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gkRLFYAwJTgYIF5Q40KuOxZp0T629zCXGcXmOOekt4BZMYWyOGb9Myy49EDMTKfqp
	 rxi6h3FxFG4NtSUEjf9SoyaKx9yZ2nSNvjYaQlImnIQGAiGH2TcTu7HW+Y5WJTBYU9
	 vjdhjVXiN7g0hVGWo2y4ohEVT93wvLRSaTJiVIEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0777/1887] um: fix time-travel syscall scheduling hack
Date: Wed, 28 Oct 2026 17:47:53 +0100
Message-ID: <20261028170517.120622028@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 381d2f95c8aa575d5d42bf1fe0ea9a70c4bec0cf ]

The schedule() call there really never did anything at
least since the introduction of the EEVDF scheduler,
but now I found a case where we permanently hang in a
loop of -ERESTARTNOINTR (due to locking.) Work around
it by making any syscalls with error return take time
(and then schedule after) so we cannot hang in such a
loop forever.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Stable-dep-of: 887c5c12e80c ("um: work around sched_yield not yielding in time-travel mode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/kernel/skas/syscall.c | 34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/arch/um/kernel/skas/syscall.c b/arch/um/kernel/skas/syscall.c
index 9ee19e566da3b..b09e85279d2b8 100644
--- a/arch/um/kernel/skas/syscall.c
+++ b/arch/um/kernel/skas/syscall.c
@@ -12,23 +12,13 @@
 #include <sysdep/syscalls.h>
 #include <linux/time-internal.h>
 #include <asm/unistd.h>
+#include <asm/delay.h>
 
 void handle_syscall(struct uml_pt_regs *r)
 {
 	struct pt_regs *regs = container_of(r, struct pt_regs, regs);
 	int syscall;
 
-	/*
-	 * If we have infinite CPU resources, then make every syscall also a
-	 * preemption point, since we don't have any other preemption in this
-	 * case, and kernel threads would basically never run until userspace
-	 * went to sleep, even if said userspace interacts with the kernel in
-	 * various ways.
-	 */
-	if (time_travel_mode == TT_MODE_INFCPU ||
-	    time_travel_mode == TT_MODE_EXTERNAL)
-		schedule();
-
 	/* Initialize the syscall number and default return value. */
 	UPT_SYSCALL_NR(r) = PT_SYSCALL_NR(r->gp);
 	PT_REGS_SET_SYSCALL_RETURN(regs, -ENOSYS);
@@ -41,9 +31,25 @@ void handle_syscall(struct uml_pt_regs *r)
 		goto out;
 
 	syscall = UPT_SYSCALL_NR(r);
-	if (syscall >= 0 && syscall < __NR_syscalls)
-		PT_REGS_SET_SYSCALL_RETURN(regs,
-				EXECUTE_SYSCALL(syscall, regs));
+	if (syscall >= 0 && syscall < __NR_syscalls) {
+		unsigned long ret = EXECUTE_SYSCALL(syscall, regs);
+
+		PT_REGS_SET_SYSCALL_RETURN(regs, ret);
+
+		/*
+		 * An error value here can be some form of -ERESTARTSYS
+		 * and then we'd just loop. Make any error syscalls take
+		 * some time, so that it won't just loop if something is
+		 * not ready, and hopefully other things will make some
+		 * progress.
+		 */
+		if (IS_ERR_VALUE(ret) &&
+		    (time_travel_mode == TT_MODE_INFCPU ||
+		     time_travel_mode == TT_MODE_EXTERNAL)) {
+			um_udelay(1);
+			schedule();
+		}
+	}
 
 out:
 	syscall_trace_leave(regs);
-- 
2.53.0



