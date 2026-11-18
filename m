Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035917;
	b=eGEBOSTDUzWVRDPQ7TNSbRgfWtTudW92aTIkwEc4v3tHuiIi2HhCTLR5rBfWqFk70Vk1
	 aoVIW/uqm74j2zV0dib6smLDd14xroPhvYd2otksWSHT4Tjd7TQlMU4cg0L0eppJ6Cca7
	 ft43Twqkm6u0KGZLAm7q2Xk7KElXU1hcHu879ABPhAEt/h0sKluuBhP+Ub3yzvKrJEYmk
	 9FVjm3F9g7Zwf9FdgaOC4GDPOh3vbJphdUo4db/2rWL6FgyCSLXjdUoQiwJ3hhU7idNsN
	 L1J2v3ua39h8NVob6/aXo7FdSo2FeZE44d9sc1xMrW3YvmjeT/sfSMyRXW4/LuK6kAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035917;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=omxUFul2w7q9GtzOpvOXWo0X/A8UaU1dGt9ETxfhR8c=;
	b=S4Z0K0GUFxtOk7PcYvBKbUIj+RtbifnBS9NOmnWfRjzsV36AxaZxy/UIDdeI1xZOTI2t
	 8qSnhCMhBeibv3nP76mKQVa6Kd5DHlOfMmcv22WtMSmWtrNjD8/6gqCf0h1YP/37Qu/wi
	 Xc5ixRlCIyqRUxlb0wuwufAaeGjettN64N/dt6rp/OiTBMuhyt1pJF6PHccHGmTDH3wwA
	 GZr2teUz6snfi+qEo0S44lMcpc2G2FIPzbun4QuvlIfC4n2t9Cabhf2ZuAM/IPALEdB0D
	 pmcMXJZRmDzGtH8I7+VBIkBs/SFHUEiy9F78FKQlDouYBoNH+kfLwOBPx5y69VPPGPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vfMlFbFG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FF7F606A32A;
	Wed, 18 Nov 2026 21:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vfMlFbFG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A47841F000C4;
	Wed, 18 Nov 2026 21:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035917;
	bh=omxUFul2w7q9GtzOpvOXWo0X/A8UaU1dGt9ETxfhR8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vfMlFbFG2rkDZxgzp7zPGcMIVuV9dqIH1kUCdrcGKbOi8iwoYZYrTqVH5RNOK9ihz
	 C/dNAm7OhfgjRjxpJgEN0zqeSnc4QEgmaIzNE4eVjriYwW4JuGo6BV7PjpXDyBDvYl
	 TwS+y9pZZ1SQFuVqLYssHxopMGo2jtry1UNipARE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bradley Morgan <include@grrlz.net>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0871/3318] PM: CPU: Restore synchronize_rcu() to cpu_pm_unregister_notifier()
Date: Wed, 18 Nov 2026 15:24:53 +0100
Message-ID: <20261118150345.432250608@linuxfoundation.org>
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
index b0f0d15085db1..41d0faa93dff7 100644
--- a/kernel/cpu_pm.c
+++ b/kernel/cpu_pm.c
@@ -10,6 +10,7 @@
 #include <linux/cpu_pm.h>
 #include <linux/module.h>
 #include <linux/notifier.h>
+#include <linux/rcupdate.h>
 #include <linux/spinlock.h>
 #include <linux/syscore_ops.h>
 
@@ -76,7 +77,8 @@ EXPORT_SYMBOL_GPL(cpu_pm_register_notifier);
  *
  * Remove a driver from the CPU PM notifier list.
  *
- * This function has the same return conditions as raw_notifier_chain_unregister.
+ * This function may sleep, and has the same return conditions as
+ * raw_notifier_chain_unregister.
  */
 int cpu_pm_unregister_notifier(struct notifier_block *nb)
 {
@@ -86,6 +88,11 @@ int cpu_pm_unregister_notifier(struct notifier_block *nb)
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



