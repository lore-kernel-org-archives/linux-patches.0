Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619631;
	b=Sk84les7/EBxgMjYV37D5cNHtpOUGBCuX3lYEjrp1285n/orYhlKGEGWS4Tvz7KmgCHj
	 O6pUIpCKwhG5IFWwNmW8DbGUN4WcZwr1T0XoCgSm1XgwHUU38iOXJzc1y/MzbEToh6XUf
	 07ZgWqQepQL85Y3PPDTDlMht0YVw4kHdgcDSN3m/C+KlnSza9kYy/OQINUmkqCF1qr5/q
	 vVXiAAeqk11ECSwvmM2jstpSQ/hgExpeGS++mlJlkez8E8aV+53WuKC8eUpvUozCJgK/H
	 zoC2BAwvSJunJoJKX21ovIO1/dog4VNQAmeNWfrEf5mwvF2FBE2zmun28e+FHhx5PJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619631;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tR3EJJJsHJUH5QLVHzcx3VlTYbpmltngGqYBhm36YFU=;
	b=XmYHXqUsnRSD0T9V1x2CodqOXaP5oILHeP0kktvHhVFLRy8CL4O4dPM6AAsKWv0XC/Ur
	 dYqDpNI3Uz/Xxk898XdgnB29KMhR0T8+70e6loJOHjMGwhct5V27YbkBFxaVTVvdA8E32
	 FmbsUuKIUBCX+jMkbwoeLadHDCKovqHgQ6SREiFPNtpIIvEgnesca296gDNHbhy6W2PKa
	 Ec8XZLDm89eMpy/301OSSKzCAFvA5WhYrl00s5K/FWD/gyAace7TuP0WwZoAmm9VNY4EN
	 +tyOPuoX0oZ9Jch0MJ+9rL63EvZOgkJl4v0oCGGxPOwEUka8FC0u705fYgXTzWabtzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XbYEGWPq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 124D9606A321;
	Wed, 25 Nov 2026 15:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XbYEGWPq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 643071F000C0;
	Wed, 25 Nov 2026 15:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619630;
	bh=tR3EJJJsHJUH5QLVHzcx3VlTYbpmltngGqYBhm36YFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XbYEGWPq7xw4ArgBRBU2pCaqcFCzoRq1iyxw4ZQ/hVzZHq3P55KwmJkdHYTbtA4qP
	 HUyVclZPZClMeBYm8QF9uURDG6Q65ky7l9vGYtTMtiosvUGHqPVIwwvU6Dh6Kn/2Id
	 i3ZOXLJp9Vzj0hfxZMiWvyjhhxTA+kdVr9Zccj2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AutonomousCodeSecurity@microsoft.com,
	"Cen Zhang (Microsoft)" <cenzhang@linux.microsoft.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 7.3 0660/1005] netfilter: xt_recent: do not call remove_proc_entry() under recent_lock
Date: Wed, 25 Nov 2026 15:33:18 +0100
Message-ID: <20261125143837.210566752@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Cen Zhang (Microsoft) <cenzhang@linux.microsoft.com>

commit 17c2e41736b62cfe444c64d67860b1fbc1e886ac upstream.

recent_proc_net_exit() removes the /proc/net/xt_recent/<name> entries of
a dying network namespace while holding spin_lock_bh(&recent_lock).
remove_proc_entry() may sleep: proc_entry_rundown() waits until every
task that is still inside the entry's file operations has left. A reader
of such an entry is counted in by proc_reg_read() before
recent_seq_start() takes recent_lock. So if a read is in flight when the
namespace is torn down, cleanup_net() sleeps in atomic context holding
the spinlock that the reader is spinning on, and neither side can ever
make progress.

An unprivileged user can trigger this from a user namespace by adding a
rule with the "recent" match and reading its proc file while the
namespace is being destroyed. As recent_lock is global, every later
attempt to take it spins forever too: the spinning can spread to all
CPUs, and network namespace teardown stops system-wide.

  BUG: sleeping function called from invalid context at
    kernel/sched/completion.c:116
   #3: (recent_lock){+...}-{3:3}, at: recent_net_exit+0x2b/0x140
  Workqueue: netns cleanup_net
  Call Trace:
   proc_entry_rundown+0x185/0x1b0
   remove_proc_entry+0x21a/0x520
   recent_net_exit+0x7f/0x140
   cleanup_net+0x414/0x8f0
  ...
  rcu: INFO: rcu_preempt self-detected stall on CPU
  Call Trace:
   queued_spin_lock_slowpath+0x313/0xc20
   recent_seq_start+0x87/0x1b0
   seq_read_iter+0x265/0x11e0
   proc_reg_read+0x1ab/0x270

Fix by taking recent_mutex instead of recent_lock. According to
commit a0e889bb1bdc ("[NETFILTER]: recent match: fix "sleeping function
called from invalid context""), recent_mutex is the lock to use here: it
protects recent_net->tables and was introduced so that proc entries are
created and removed without recent_lock held, because those calls may
sleep. hashlimit_proc_net_exit() does the same for xt_hashlimit.

Fixes: 665e205c16c1 ("netfilter: xt_recent: fix namespace destroy path")
Cc: stable@vger.kernel.org
Cc: AutonomousCodeSecurity@microsoft.com
Signed-off-by: Cen Zhang (Microsoft) <cenzhang@linux.microsoft.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/xt_recent.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -649,14 +649,15 @@ static void __net_exit recent_proc_net_e
 
 	/* recent_net_exit() is called before recent_mt_destroy(). Make sure
 	 * that the parent xt_recent proc entry is empty before trying to
-	 * remove it.
+	 * remove it. Use recent_mutex instead of recent_lock since
+	 * remove_proc_entry() may sleep.
 	 */
-	spin_lock_bh(&recent_lock);
+	mutex_lock(&recent_mutex);
 	list_for_each_entry(t, &recent_net->tables, list)
 	        remove_proc_entry(t->name, recent_net->xt_recent);
 
 	recent_net->xt_recent = NULL;
-	spin_unlock_bh(&recent_lock);
+	mutex_unlock(&recent_mutex);
 
 	remove_proc_entry("xt_recent", net->proc_net);
 }


