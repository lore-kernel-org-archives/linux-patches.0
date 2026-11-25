Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619740;
	b=PXmYriCQsro1FpXO9cX354vWZuVoVbU4Gc0AZKqjQmt+wMoj/TUAMWEnoUkj2taMkhhE
	 igsrd3c0u/+ugLVT8rU51QcZc/94i0bf+OxWGx/NoB0kU27mUwIbw+LMNqQ47sbYQEjBi
	 0MyBL5Xjtj0JCoaNAO/05cZYe2GZ1rFAVGEYPBip8LtNu7aJHRpurcC657Ai25+xAFkP2
	 CwazFYJOtyNaT7vZa2zxNEZDwxvyLnLeTLxUD09VE1Lo0jjDiJz28fsNZ+0+jE3jycoui
	 zSJPpGZl9mDoZf9G4P+z6KUJSVaj0ux5IgjWWHTZ8mtxaL96bYvUxUlGRYGZ24o0Z+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619740;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6e4V7Q1uli9eDJVLgGmiGcBfgLpI1CDjTm3aBE34EuA=;
	b=p0J7XF87vFqikL7gHlwyCfvwX5gplhaW8HURRGy6vlOWOm8Fu+Z/u5qAxxmLVsPZuckf
	 1SqKBruiK2KWrowvhHnNfyztAkYVDZ8Om00tW2DgAb9sxkL9FM+zrBMtBe2F2Khfes6aL
	 6KMMWaGy6oShWyPJlAoFJpUMCHYqUJrP2MEuUO/7ExpqAgnSSVC4dRpKWNiX+dYksVdSi
	 ZrESXNN+vZf/vZSjKY8lCP1T1MHg7biUPpXcFs+VdS248umm5czub9rBdZO5KcZSeIM7L
	 4S2/ywrpZumbV/Z4n2dSZUhUASqJfVLC62o41onBG81sYWVk+ktSO3pueyEsu3mWYFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eUNB6y8q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B9B9606A323;
	Wed, 25 Nov 2026 15:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eUNB6y8q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0C241F000D4;
	Wed, 25 Nov 2026 15:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619740;
	bh=6e4V7Q1uli9eDJVLgGmiGcBfgLpI1CDjTm3aBE34EuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eUNB6y8qVAY826xaB6RSCvsUWtEOCLa/sHpRZqLzM8JF6BuWmiDXU04k0MiogN0JD
	 WidZ2xU6Y0Z6+6t/35UnEWGxuvTpTcVzI1rUOtOk6YXWybID26GwkR9KYw7JMQhcD6
	 CL98sLRLgNE4rJfWvSjSEgKtaHsA1ONbUKAfVbg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mani Tofigh <mt4022@columbia.edu>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 7.3 0691/1005] cgroup: arm the notify timer only while the file exists
Date: Wed, 25 Nov 2026 15:33:49 +0100
Message-ID: <20261125143837.941260284@linuxfoundation.org>
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

From: Mani Tofigh <mt4022@columbia.edu>

commit fffbdad76a57eed26cff1be19f4cbb407f0b6e7c upstream.

cgroup_rm_file() clears cfile->kn under cfile->lock and then deletes the
notify timer.  Since commit 4616120fca7f ("cgroup: add lockless
fast-path checks to cgroup_file_notify()"), cgroup_file_notify() checks
kn and arms the timer without that lock and can arm it right after it
was deleted:

  Task A (memcg charge)                  Task B (subtree_control write)
  cgroup_file_notify()
    READ_ONCE(cfile->kn) != NULL
                                         cgroup_rm_file()
                                           cfile->kn = NULL
                                           timer_delete_sync()
    timer_reduce(&cfile->notify_timer)
      /* timer queued again */

If the css is only hidden, showing it again runs timer_setup() on the
still queued timer and corrupts the timer wheel:

  [   14.324093] ODEBUG: init active (active state 0) object: 0000000009e526fd object type: timer_list hint: cgroup_file_notify_timer+0x0/0x10
  [   14.324123] WARNING: lib/debugobjects.c:629 at debug_print_object+0x1a4/0x3b0, CPU#1: cgnotify/64
  [   14.329806] CPU: 1 UID: 0 PID: 64 Comm: cgnotify Tainted: G        W            7.3.0-17087-gd865f2677c44 #1 PREEMPT
  [   14.335109] RIP: 0010:debug_print_object+0x1ae/0x3b0
  [   14.354351] Call Trace:
  [   14.354927]  <TASK>
  [   14.356650]  __debug_object_init+0x203/0x3c0
  [   14.361799]  timer_init_key+0x2c/0x240
  [   14.362682]  cgroup_addrm_files+0x754/0xc40
  [   14.366744]  css_populate_dir+0x12e/0x440
  [   14.368636]  cgroup_apply_control_enable+0x2f3/0xb60
  [   14.371769]  cgroup_subtree_control_write+0x740/0xc10
  [   14.376924]  cgroup_file_write+0x19e/0x700
  [   14.381809]  kernfs_fop_write_iter+0x337/0x510
  [   14.382818]  vfs_write+0x545/0x1250
  [   14.386491]  ksys_write+0xfa/0x200
  [   14.390144]  do_syscall_64+0xfb/0x590
  [   14.390994]  entry_SYSCALL_64_after_hwframe+0x77/0x7f

If the css is freed instead, the timer can fire on freed memory.

Arm the timer under cfile->lock after checking kn again and keep only
the kn and timer_pending() checks outside the lock.  With the fix, the
timer stays idle once the file is removed.

This bug was identified and confirmed with the help of a deterministic
hypervisor currently under development.  The C reproducer below however
hits it within a minute.

Fixes: 4616120fca7f ("cgroup: add lockless fast-path checks to cgroup_file_notify()")
Cc: stable@vger.kernel.org
Signed-off-by: Mani Tofigh <mt4022@columbia.edu>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cgroup/cgroup.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -4810,19 +4810,21 @@ void cgroup_file_notify(struct cgroup_fi
 	if (!READ_ONCE(cfile->kn))
 		return;
 
-	last = READ_ONCE(cfile->notified_at);
-	next = last + CGROUP_FILE_NOTIFY_MIN_INTV;
-	if (time_in_range(jiffies, last, next)) {
-		timer_reduce(&cfile->notify_timer, next);
-		if (timer_pending(&cfile->notify_timer))
-			return;
-	}
+	if (timer_pending(&cfile->notify_timer))
+		return;
 
 	spin_lock_irqsave(&cfile->lock, flags);
 	if (cfile->kn) {
-		kn = cfile->kn;
-		kernfs_get(kn);
-		WRITE_ONCE(cfile->notified_at, jiffies);
+		last = cfile->notified_at;
+		next = last + CGROUP_FILE_NOTIFY_MIN_INTV;
+
+		if (time_in_range(jiffies, last, next)) {
+			timer_reduce(&cfile->notify_timer, next);
+		} else {
+			kn = cfile->kn;
+			kernfs_get(kn);
+			cfile->notified_at = jiffies;
+		}
 	}
 	spin_unlock_irqrestore(&cfile->lock, flags);
 


