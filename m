Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058180;
	b=10B9oBP/C3Ic2m/87UuAgRcXRVvbhabK/wiWIcWnWsAwvwFdqWLBtacNeldO1nSEVDKx
	 GtylSBu3DwkDJDQAIQPctkf6hZe1ehpts5f0jsc+H/rCpQpu9w/En8iVceCBIOqY0EOZg
	 Ufmy2VSOKTW89qJeZrJcbYhcOqDwSVBZ6DBV0wC7TQ2fiK6tjdpBlJfewOxXEos2M1Acl
	 nVExRoNqDAmlTi2WO0jhZ2I4Esi/7CrL7c71iJHhFVeUQkpvmeL2uXC6SWEaDbmHlAHFZ
	 RhAP8zGn9B3CbgsSZddiqSqkBpwm05y7Pl1KTtWci5bSgJsLHWcbyaQCPVHW/tDw65A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058180;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Oiwt0LYxAcnZjxHMgCwskYtB6mmqMb12bti2gMh4kIo=;
	b=y1qET63V2f+23HT1l7hu1X4EQ1zYYknaq5uljZP3186mZ+R4VN23m0qQtDUNIMe2XdtL
	 iSuQrXgHizlPuFI/VqzBHP5WztMacwMiKTTPSPKKaVpjfsYaXz7+rZrRYbtDFrMK+BbmA
	 odbVAL1evuz1UuLFR1ildGM7mM18rgo+edP9//99vwIuvoeyPYEFZiyjc4qrE2YJm8PYg
	 EnMTEot5xfsTz0wSj+FqRqXpa+IC8z6xvDstLSwU36+EM1I2cIrm43J5o/XlKaKyqVtjK
	 hZTNzxO2BPqAUMN339kSwGacpNhH+eq39wFswX1rrj20y4+DiWPsZ5aV3jmPNEbJY/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o0RH6sFP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD819606A320;
	Thu, 19 Nov 2026 03:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o0RH6sFP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 204FC1F000C4;
	Thu, 19 Nov 2026 03:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058180;
	bh=Oiwt0LYxAcnZjxHMgCwskYtB6mmqMb12bti2gMh4kIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o0RH6sFPrJVUUady9+9Y7FnZw7U6ImeqnbNbOMMhqUc7yQN/zKUfnoDFIEe/wp/5C
	 pFDroC+VwCGOFiOJLlGupYdqZs4OOrD/fHSesa/fZkgGNV02hfDbAswPAQhMtcM4nB
	 IyU3jRFG+KXGUBJF7LaKpxcQ0Xn69RT5J5ucmcHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bradley Morgan <include@grrlz.net>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0392/1848] PM: CPU: Restore synchronize_rcu() to cpu_pm_unregister_notifier()
Date: Wed, 18 Nov 2026 15:40:30 +0100
Message-ID: <20261118145930.152376239@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



