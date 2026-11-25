Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618303;
	b=PaJqjxipY5KPyOmtwBnJGvCZONl6PENwLiAEHyLqRBcfZXue53vVkXYjpdoLMvutorOe
	 vJTkKdR56OB9L4CFAKKJhfmiVMxR342P4+t31WlUMcO2OZ7ijtiLYwjx9e52W3auDzpUS
	 EaI63JVQs/GkpwO3MuSW/pdBzqPbUJVffW4FBK6fA1UpH+kdyTPpbObDnBei2x4v5E62/
	 G4KcsqlNDbTiO6pc+acHhF8HBcqtM4mGJfpsTMHu3swUM5x5JgkB7qrI+ACq9V5OV8SEI
	 bUu6lJ/099Y/WAmpBfghD7N+whXZiYNBnvKdqcPwhfxrh4Cc8vkQbJkLnGJ3sGyhSMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618303;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BMVkQ3lGj3Yx1IQhNuymCu6Q1oVzvKWK2WMs3XuhOR8=;
	b=nVO2MzgzYtcHb3bh/qgfKQSSfJWi+tP4KK9Dqm4Tf1/lOt1B+pS+sRjCukuGOXZmh2ec
	 fQSZC5SgxPhNg3TEhKs+JUwJC56OeKFnwbtRmTt/d0jcuUp9dp9V9PxRvu17mmNSjje2f
	 de0vf+6zBYQdAL8Xs2ZQd9rdJhg35lmngPMBAnFSEl24MKKNyKl9sUHmwjtAMGUAIHyX6
	 GQoUXGnC0zXNCl2Lq5v33ywfq2LNVzdcGYAc94SfO2TU1AkEHo7MLmwfaYu/mtP/j/XID
	 0DmAGnjEOu+V554msTDiv4JlS67GUKNallmLEaA88uzWaWEeAe5uXvHN+ZoWJUfVF3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="iRQFDZD/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57962606A31E;
	Wed, 25 Nov 2026 14:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iRQFDZD/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82BA71F000C0;
	Wed, 25 Nov 2026 14:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618303;
	bh=BMVkQ3lGj3Yx1IQhNuymCu6Q1oVzvKWK2WMs3XuhOR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iRQFDZD/pavhRqoIoPvr+7PwWfQRSE+Sg4XMDKAOyTrbXVXn5dvYsr7jOAZs6ifAm
	 P9R7nU6nVhp7fluak1w8FkrHyCPLf5dVXxIwqkq7fqEcPXGbPD42QuMrI7fYdmaOn6
	 FO9xW8PH8ht8P+IiUaOastk0JrJ3W4o+aeQwa4Sc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	John Ogness <john.ogness@linutronix.de>,
	Petr Mladek <pmladek@suse.com>,
	Derek Barbosa <debarbos@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0237/1005] printk: Avoid multiple unregistration in unregister_console_locked()
Date: Wed, 25 Nov 2026 15:26:15 +0100
Message-ID: <20261125143827.290749519@linuxfoundation.org>
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

From: John Ogness <john.ogness@linutronix.de>

[ Upstream commit 8a7f26aa072a4e63bc3b1adfe649546709db722e ]

unregister_console_locked() is called from within
hlist_for_each_entry_safe(console_list) loops. This would be safe if
unregister_console_locked() only unregistered the specified console. After
all, that is what the _safe variant is for.

However, unregister_console_locked() calls printk_kthreads_check_locked(),
which can unregister _multiple_ consoles if kthreads fail to start. This
could lead to hlist_for_each_entry_safe() use-after-free scenarios because
not only was the list entry removed, but possibly the following entry as
well (the @n temporary storage of the next entry).

Move the call to printk_kthreads_check_locked() outside of
unregister_console_locked(). Add comments to both functions to clarify
if they are safe to be used in hlist_for_each_entry_safe(console_list)
loops.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/lkml/87ik31iz4x.fsf@jogness.linutronix.de
Fixes: 76f258bf3f2a ("printk: nbcon: Introduce printer kthreads")
Signed-off-by: John Ogness <john.ogness@linutronix.de>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Tested-by: Derek Barbosa <debarbos@redhat.com>
Link: https://patch.msgid.link/20261030135802.663893-1-john.ogness@linutronix.de
Signed-off-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/printk/printk.c | 34 ++++++++++++++++++++++++++++++----
 1 file changed, 30 insertions(+), 4 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index bc3b9f6e404bc..a14ab648ee9bc 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -3790,6 +3790,13 @@ static struct syscore printk_syscore = {
  * If appropriate, start nbcon kthreads and set @printk_kthreads_running.
  * If any kthreads fail to start, those consoles are unregistered.
  *
+ * Called after consoles are registered or unregistered.
+ *
+ * This MUST NOT be called within an hlist_for_each_entry_safe(console_list)
+ * loop because it can unregister multiple consoles if any kthreads fail to
+ * start. That would lead to use-after-free scenarios within the
+ * hlist_for_each_entry_safe(console_list) loop of the caller.
+ *
  * Must be called under console_list_lock().
  */
 static void printk_kthreads_check_locked(void)
@@ -4228,7 +4235,20 @@ void register_console(struct console *newcon)
 }
 EXPORT_SYMBOL(register_console);
 
-/* Must be called under console_list_lock(). */
+/*
+ * Unregister the specified console.
+ *
+ * This can be called safely from within an
+ * hlist_for_each_entry_safe(console_list) loop because it unregisters
+ * _only_ the specified console.
+ *
+ * Afterwards the caller should call printk_kthreads_check_locked() since
+ * unregistering a console may require printer threads to start/stop. Note
+ * that printk_kthreads_check_locked() cannot be called safely from within
+ * an hlist_for_each_entry_safe(console_list) loop.
+ *
+ * Must be called under console_list_lock().
+ */
 static int unregister_console_locked(struct console *console)
 {
 	bool use_device_lock = (console->flags & CON_NBCON) && console->write_atomic;
@@ -4320,9 +4340,6 @@ static int unregister_console_locked(struct console *console)
 	if (console->exit)
 		res = console->exit(console);
 
-	/* Changed console list, may require printer threads to start/stop. */
-	printk_kthreads_check_locked();
-
 	return res;
 }
 
@@ -4331,7 +4348,12 @@ int unregister_console(struct console *console)
 	int res;
 
 	console_list_lock();
+
 	res = unregister_console_locked(console);
+
+	/* Changed console list, may require printer threads to start/stop. */
+	printk_kthreads_check_locked();
+
 	console_list_unlock();
 	return res;
 }
@@ -4455,6 +4477,10 @@ static int __init printk_late_init(void)
 			unregister_console_locked(con);
 		}
 	}
+
+	/* Changed console list, may require printer threads to start/stop. */
+	printk_kthreads_check_locked();
+
 	console_list_unlock();
 
 	ret = cpuhp_setup_state_nocalls(CPUHP_PRINTK_DEAD, "printk:dead", NULL,
-- 
2.53.0



