Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37B7828312F;
	Mon,  9 Feb 2026 14:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648786; cv=none; b=nEWmPVMOFyG4DbveUeRSyzSNyjaqcMgONBJhxW3d5r+nTr/HsK2VMTBEZuJ4zDXaPBJRPAc/jAlA0xX818N/bOz8+o2wI08PHRMO0ahGlcns2VjXShB5DdXbf73nUSZZeF568GxkG4LjBoOuODbD6D73m2HAx3NKCJh+3TSlRVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648786; c=relaxed/simple;
	bh=Vd3WtmNhiVsPlFLtKjXyh2QIuDmJRxrC/oSIPckFLaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a3jO2kbQF+GSn6qd3w7GQDNKEqp/bHZRb/0bsA4q+JB/VmrN1QI6JR21S788IjhXE02nTEo1iz/PiW351MJ2PkmAQU3HJZKGmkTO5uw9dAWKMWxwucJzvOL6S/cNXQ54D8k6na6GFRsdB7YXSmJQZh7A64PluIlfMX80BmwxUl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X65gCf1/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X65gCf1/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CCE1C116C6;
	Mon,  9 Feb 2026 14:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648786;
	bh=Vd3WtmNhiVsPlFLtKjXyh2QIuDmJRxrC/oSIPckFLaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X65gCf1/ZJQkxnA/cOGMVcgUOxbSLpTdJWPANSrcaPbBs7Yus77yO5tPyZcsKSGiE
	 834Zy6UluF2+lPS/iM7cWG9w/h7VgklC1UvmPpD4nTgz09JcsZU+OHiUNxOl0zsriG
	 XYeb9VEadaSLlFFlENP39bPum6tN2yGIRnShJcnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Rostedt <rostedt@goodmis.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Jeongjun Park <aha310510@gmail.com>
Subject: [PATCH 5.15 15/75] Documentation: Replace del_timer/del_timer_sync()
Date: Mon,  9 Feb 2026 15:24:12 +0100
Message-ID: <20260209142302.393321610@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142301.830618238@linuxfoundation.org>
References: <20260209142301.830618238@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 87bdd932e85881895d4720255b40ac28749c4e32 ]

Adjust to the new preferred function names.

Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Anna-Maria Behnsen <anna-maria@linutronix.de>
Link: https://lore.kernel.org/r/20221123201625.075320635@linutronix.de
Signed-off-by: Jeongjun Park <aha310510@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/RCU/Design/Requirements/Requirements.rst      |    2 +-
 Documentation/core-api/local_ops.rst                        |    2 +-
 Documentation/kernel-hacking/locking.rst                    |   11 +++++------
 Documentation/timers/hrtimers.rst                           |    2 +-
 Documentation/translations/it_IT/kernel-hacking/locking.rst |   10 +++++-----
 Documentation/translations/zh_CN/core-api/local_ops.rst     |    2 +-
 6 files changed, 14 insertions(+), 15 deletions(-)

--- a/Documentation/RCU/Design/Requirements/Requirements.rst
+++ b/Documentation/RCU/Design/Requirements/Requirements.rst
@@ -1858,7 +1858,7 @@ unloaded. After a given module has been
 one of its functions results in a segmentation fault. The module-unload
 functions must therefore cancel any delayed calls to loadable-module
 functions, for example, any outstanding mod_timer() must be dealt
-with via del_timer_sync() or similar.
+with via timer_delete_sync() or similar.
 
 Unfortunately, there is no way to cancel an RCU callback; once you
 invoke call_rcu(), the callback function is eventually going to be
--- a/Documentation/core-api/local_ops.rst
+++ b/Documentation/core-api/local_ops.rst
@@ -191,7 +191,7 @@ Here is a sample module which implements
 
     static void __exit test_exit(void)
     {
-            del_timer_sync(&test_timer);
+            timer_delete_sync(&test_timer);
     }
 
     module_init(test_init);
--- a/Documentation/kernel-hacking/locking.rst
+++ b/Documentation/kernel-hacking/locking.rst
@@ -970,7 +970,7 @@ you might do the following::
 
             while (list) {
                     struct foo *next = list->next;
-                    del_timer(&list->timer);
+                    timer_delete(&list->timer);
                     kfree(list);
                     list = next;
             }
@@ -984,7 +984,7 @@ the lock after we spin_unlock_bh(), and
 the element (which has already been freed!).
 
 This can be avoided by checking the result of
-del_timer(): if it returns 1, the timer has been deleted.
+timer_delete(): if it returns 1, the timer has been deleted.
 If 0, it means (in this case) that it is currently running, so we can
 do::
 
@@ -993,7 +993,7 @@ do::
 
                     while (list) {
                             struct foo *next = list->next;
-                            if (!del_timer(&list->timer)) {
+                            if (!timer_delete(&list->timer)) {
                                     /* Give timer a chance to delete this */
                                     spin_unlock_bh(&list_lock);
                                     goto retry;
@@ -1008,8 +1008,7 @@ do::
 Another common problem is deleting timers which restart themselves (by
 calling add_timer() at the end of their timer function).
 Because this is a fairly common case which is prone to races, you should
-use del_timer_sync() (``include/linux/timer.h``) to
-handle this case.
+use timer_delete_sync() (``include/linux/timer.h``) to
 
 Locking Speed
 =============
@@ -1337,7 +1336,7 @@ lock.
 
 -  kfree()
 
--  add_timer() and del_timer()
+-  add_timer() and timer_delete()
 
 Mutex API reference
 ===================
--- a/Documentation/timers/hrtimers.rst
+++ b/Documentation/timers/hrtimers.rst
@@ -118,7 +118,7 @@ existing timer wheel code, as it is matu
 was not really a win, due to the different data structures. Also, the
 hrtimer functions now have clearer behavior and clearer names - such as
 hrtimer_try_to_cancel() and hrtimer_cancel() [which are roughly
-equivalent to del_timer() and del_timer_sync()] - so there's no direct
+equivalent to timer_delete() and timer_delete_sync()] - so there's no direct
 1:1 mapping between them on the algorithmic level, and thus no real
 potential for code sharing either.
 
--- a/Documentation/translations/it_IT/kernel-hacking/locking.rst
+++ b/Documentation/translations/it_IT/kernel-hacking/locking.rst
@@ -998,7 +998,7 @@ potreste fare come segue::
 
             while (list) {
                     struct foo *next = list->next;
-                    del_timer(&list->timer);
+                    timer_delete(&list->timer);
                     kfree(list);
                     list = next;
             }
@@ -1011,7 +1011,7 @@ e prenderà il *lock* solo dopo spin_unl
 di eliminare il suo oggetto (che però è già stato eliminato).
 
 Questo può essere evitato controllando il valore di ritorno di
-del_timer(): se ritorna 1, il temporizzatore è stato già
+timer_delete(): se ritorna 1, il temporizzatore è stato già
 rimosso. Se 0, significa (in questo caso) che il temporizzatore è in
 esecuzione, quindi possiamo fare come segue::
 
@@ -1020,7 +1020,7 @@ esecuzione, quindi possiamo fare come se
 
                     while (list) {
                             struct foo *next = list->next;
-                            if (!del_timer(&list->timer)) {
+                            if (!timer_delete(&list->timer)) {
                                     /* Give timer a chance to delete this */
                                     spin_unlock_bh(&list_lock);
                                     goto retry;
@@ -1034,7 +1034,7 @@ esecuzione, quindi possiamo fare come se
 Un altro problema è l'eliminazione dei temporizzatori che si riavviano
 da soli (chiamando add_timer() alla fine della loro esecuzione).
 Dato che questo è un problema abbastanza comune con una propensione
-alle corse critiche, dovreste usare del_timer_sync()
+alle corse critiche, dovreste usare timer_delete_sync()
 (``include/linux/timer.h``) per gestire questo caso.
 
 Velocità della sincronizzazione
@@ -1380,7 +1380,7 @@ contesto, o trattenendo un qualsiasi *lo
 
 -  kfree()
 
--  add_timer() e del_timer()
+-  add_timer() e timer_delete()
 
 Riferimento per l'API dei Mutex
 ===============================
--- a/Documentation/translations/zh_CN/core-api/local_ops.rst
+++ b/Documentation/translations/zh_CN/core-api/local_ops.rst
@@ -185,7 +185,7 @@ UP之间没有不同的行为，在你�
 
     static void __exit test_exit(void)
     {
-            del_timer_sync(&test_timer);
+            timer_delete_sync(&test_timer);
     }
 
     module_init(test_init);


