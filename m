Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0AE33D7D74;
	Wed, 20 May 2026 16:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294559; cv=none; b=ARrRRMTREbjhk0qsdpKEfLwB9vCsbzMT/T4xcs9sl7rUs5pafigQA5apOUuolBqyfB1YVTI7UXFP/9LtiufLupSSF84y7QCgzuue60i31AAWrJFNbZWbn5L03xWhrvQQi3fqQ1hY7XtiEx3V4HOS7NpJraPOiPXLd736SSILsLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294559; c=relaxed/simple;
	bh=JCuWA7cx9jWKHt02t2hJO6NGZFiaPYhJkG5AoExHcYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E86bVhA+ltGT/I/kA96ncPwVkREITXR2L3BFIClwIAD0jxGububBuZOPiCCb9hfTCUw9oVOqR8/Ruod+DZhGa6rREdPFjbJLBTDqMfcmG7wm553rw85cX2eRXm7IRrVR3e/oifi0NaKRV807fEzD96xwpavNvLNf1YUJE7EMU3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gQY9KGvN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gQY9KGvN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1138C1F000E9;
	Wed, 20 May 2026 16:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294558;
	bh=PFVMN5XiWuyNCN2e9/hW937DaFwVuS52VZveJ4RJ7Os=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gQY9KGvN6wDBAc5/llaVYLpcY3Rv0pCxA+c/RoUTgFAD8Ysqn+PnZh1law3ECBr4h
	 jisi0Tg+HbDZGUZdGpZ8Vp+kwQP/9AqkjMu9IAesOYM/LvRek6gqOlNO3mLh6lEou/
	 IQ/YT6clOS8qX7138pXaKyPGQDnVvISo+csEOvqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Davidlohr Bueso <dave@stgolabs.net>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0044/1146] locking/mutex: Fix wrong comment for CONFIG_DEBUG_LOCK_ALLOC
Date: Wed, 20 May 2026 18:04:54 +0200
Message-ID: <20260520162149.377834566@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Davidlohr Bueso <dave@stgolabs.net>

[ Upstream commit babcde3be8c9148aa60a14b17831e8f249854963 ]

... that endif block should be CONFIG_DEBUG_LOCK_ALLOC, not
CONFIG_LOCKDEP.

Fixes: 51d7a054521d ("locking/mutex: Redo __mutex_init() to reduce generated code size")
Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20260217191512.1180151-3-dave@stgolabs.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mutex.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/mutex.h b/include/linux/mutex.h
index 8126da9590886..f57d2a97da57f 100644
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -146,7 +146,7 @@ static inline void __mutex_init(struct mutex *lock, const char *name,
 {
 	mutex_rt_init_generic(lock);
 }
-#endif /* !CONFIG_LOCKDEP */
+#endif /* !CONFIG_DEBUG_LOCK_ALLOC */
 #endif /* CONFIG_PREEMPT_RT */
 
 #ifdef CONFIG_DEBUG_MUTEXES
-- 
2.53.0



