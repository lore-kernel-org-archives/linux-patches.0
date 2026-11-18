Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052221;
	b=OAKwRyoJsM4zvaP6noimNFhBMVHj1FAKpds/+L3BHuXcph4QtQmorYQO9a6dzPyzGIwQ
	 cv7tfMlWXynN88tQmYL7oSvFRvMQiYQaTrDWmcZ2yVMQdiwiqwy6Wt80iaAkFkV9kMLGS
	 GvvKf9DM8/8+iY9a0pxN/vaHAMQiylIm+oyaQpOBAJGF7rEQ6c2C/HXj5/EBD9A8k1a0X
	 C15bqh7Ou56o018LdzFccn31oJuuMy20536e2iMIppnVFraO6SSaBl6hZLFbj0a1h3tXK
	 +d6OZXsJluPL2Z0H4Tldnj1HYnW2ltJss+T2GiqblutqAUB4x32PRmVGOYBdIf63kgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052221;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ehPOm6bW1AKN44XzLjGmgrmtOIUyOwT5sTnUQiXxoLc=;
	b=EX/1OK7WibIVtMy6du7mgGmnHaMA9jXluNLdpYWA3WfbVSVx7+6vzYqJDt+D+KxZSyHw
	 UeiOZH8aVxU2RJongkisySNvuk3uxpRVDfEyPd5u5CIqszDl6whLErXhvOlGctWysVAfh
	 gaLVQrGnezdoxIbgVfl49pI9knktALeqgT4bSJOFD6akHlEL+GBNqjPZuMXFhV+Glwm+c
	 kVbXGDzQWNpuoGSJETY7sxMckU6w4pwrNeqzuqHO7b7fXGYZ2eeaX+VhjgsOMnk+VAnHW
	 C7QozVVB7RD15OlPAFrRJhMXFbqAIMj1VTUpbWiAi3YUeCzGD1DODKiiV+yr+tpe6+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="YOHp/dvC";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C127C606A325;
	Thu, 19 Nov 2026 01:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YOHp/dvC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFC9A1F000C4;
	Thu, 19 Nov 2026 01:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052221;
	bh=ehPOm6bW1AKN44XzLjGmgrmtOIUyOwT5sTnUQiXxoLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YOHp/dvCAVZd8Y3BSosoTigIeASQ7y/RdCACrntKa44xkR8I2ZKGsrQH1sRtHNFyj
	 tZPGejboM3qLxeLiaJwx1JkFpy2xbjV879bINIQAnT/30SR5lbGmBNmzfp7t+va9zS
	 zP7esw4imct40N0E4DTQMoJmk0up2rfmx1qUlVXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bradley Morgan <include@grrlz.net>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0487/2214] PM: CPU: Restore synchronize_rcu() to cpu_pm_unregister_notifier()
Date: Wed, 18 Nov 2026 15:36:03 +0100
Message-ID: <20261118150030.683194825@linuxfoundation.org>
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

From: Bradley Morgan <include@grrlz.net>

[ Upstream commit 61f7eee7d4664079fbce821576891c3ee5ccf597 ]

cpu_pm_notify() walks the notifier chain lockless under only
rcu_read_lock(). That only works if a removed notifier block is not
freed until every concurrent walker is done with it.

The chain used to be an atomic_notifier, whose unregister ends in
synchronize_rcu(). Commit b2f6662ac08d ("PM: cpu: Make notifier chain
use a raw_spinlock_t") switched it over to a raw_notifier, and in
doing so replaced that with raw_notifier_chain_unregister(), which
does not synchronize. The grace period quietly went away, so a driver
that frees the memory holding its notifier block right after
cpu_pm_unregister_notifier() returns can race with a concurrent
walker:

  cpu1 (idle exit)                  cpu2 (driver remove)
  ----------------                  --------------------
  cpu_pm_notify(CPU_PM_EXIT)
    rcu_read_lock()
    nb = rcu_dereference_raw(*nl)
                                    cpu_pm_unregister_notifier(&od->nb)
                                      unlink, no grace period
                                      remove() frees od (devm)
    nb->notifier_call(nb, ...)
      /* use after free */

The rcu_read_lock() on cpu1 does not stop cpu2 from freeing the
block, and nothing else does. The read side is the idle exit path,
so this can hit on any system where a driver with a cpu_pm notifier
gets unbound.

Add the grace period back. It is only needed when a notifier was
actually removed, so wait on success and return -ENOENT without
waiting otherwise. The kerneldoc gets back the "may sleep" note that
the same commit dropped.

Fixes: b2f6662ac08d ("PM: cpu: Make notifier chain use a raw_spinlock_t")
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Bradley Morgan <include@grrlz.net>
[ rjw: Subject tweak ]
Link: https://patch.msgid.link/20260813074343.26460-3-include@grrlz.net
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cpu_pm.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/kernel/cpu_pm.c b/kernel/cpu_pm.c
index 246efc74e3f34..9cb5c666682b9 100644
--- a/kernel/cpu_pm.c
+++ b/kernel/cpu_pm.c
@@ -10,6 +10,7 @@
 #include <linux/cpu_pm.h>
 #include <linux/module.h>
 #include <linux/notifier.h>
+#include <linux/rcupdate.h>
 #include <linux/spinlock.h>
 #include <linux/syscore_ops.h>
 
@@ -85,7 +86,8 @@ EXPORT_SYMBOL_GPL(cpu_pm_register_notifier);
  *
  * Remove a driver from the CPU PM notifier list.
  *
- * This function has the same return conditions as raw_notifier_chain_unregister.
+ * This function may sleep, and has the same return conditions as
+ * raw_notifier_chain_unregister.
  */
 int cpu_pm_unregister_notifier(struct notifier_block *nb)
 {
@@ -95,6 +97,11 @@ int cpu_pm_unregister_notifier(struct notifier_block *nb)
 	raw_spin_lock_irqsave(&cpu_pm_notifier.lock, flags);
 	ret = raw_notifier_chain_unregister(&cpu_pm_notifier.chain, nb);
 	raw_spin_unlock_irqrestore(&cpu_pm_notifier.lock, flags);
+
+	/* Wait for the rcu_read_lock() walkers in cpu_pm_notify(). */
+	if (!ret)
+		synchronize_rcu();
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(cpu_pm_unregister_notifier);
-- 
2.53.0



