Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792773959;
	b=2qehXHMktLl0bPURZ3law8YaLLHbAw9hxKC2X2WLQKtcijZyGC4YTeUxZKDQdTiOHgaY
	 U+uCXrvvW/im8Gm6WVUAV127nNhN+t6c3JWPb+TRWUjd1Qobb2e2p1HauHeAX/kMSoT4N
	 GEVneikJYXpTLx8yhRDUKoh2KWiTnRclf/Qhl9/U54ydy289Mz0lu0M2cCP/Sp4P1kxzd
	 2R89f5Z1qEo9c1u7NTrkNrX2b/aisPE/1VBJelC9Qh6WLCgtAnmJfDK3GnND8gWvPGm8K
	 OgCdhTFf53dONaGY+IybYOsuqvc1NQG69hFswZq3MNB50rJofcBS6PPpQb/RnSe/ixQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792773959;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=02EhcXhkLPQLZ+mro3BC2OjImTHOn7ekF7gf+MHmTVM=;
	b=12yaUt2bvNseZuKx0mSbAfESRCmk0E1S2mt2lMTZLepEW79EJUDbKYehx3Ryhr7c+Vz9
	 00WwMe1h5+UP0FKCiCgs998Hz5HA8u6xINiUxclDNlAFv5dOGo99BcHsydempqAYQDyeM
	 yJJrfl6daaGevJSZmcL8bJ+/NrCpdTI/AFu7e3BYxGtiN0y7B5jfMmYzdhzvk7lIpsHfA
	 jTGJyenlpLz3SU7PpqCMrCBpi39GjxRSm+z4gaMu+8XbNYdFt6gaa2swRFqJntmqmTf7N
	 qASSKd71YuMhn0BuOWUoIdSpm//rRl4c7wQdL8vPAn2CH+n25eZC42bpaVQvfgylSIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="xN/f7bYA";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1843C606A31D;
	Fri, 23 Oct 2026 16:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xN/f7bYA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 680831F01825;
	Fri, 23 Oct 2026 16:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792773959;
	bh=02EhcXhkLPQLZ+mro3BC2OjImTHOn7ekF7gf+MHmTVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xN/f7bYATmLHQvr3U8oWGwLAZH6lKKt28FzIBYe7bbkr873vanQTUhsma7oXIED18
	 Z545uAgE1RVJZpAzoxooboMrTHVoMHP23/SxeHM959FOJUgABJ90S6/RSItm0V8VUW
	 z9I60pXcrS+N5rcDypirFg+ZckaCCWUEgtYw3Kis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sung Byeongchan <tjdqudcks0424@naver.com>,
	Ian Kent <raven@themaw.net>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.18 073/193] autofs: ignore notification errors from a replaced pipe
Date: Fri, 23 Oct 2026 18:35:50 +0200
Message-ID: <20261023163715.930549918@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sung Byeongchan <tjdqudcks0424@naver.com>

commit 65676cd4203c0e41a94caf54080a7f0a95434bda upstream.

autofs_notify_daemon() takes a reference to the current notification
pipe under wq_mutex, then drops the mutex before writing the request. The
write can block while the daemon enters catatonic mode and installs a
replacement pipe.

If the old pipe's reader is then closed, the delayed write returns -EPIPE
and the generic error path enters catatonic mode again. That transition
acts on the current superblock state, closes the replacement pipe, and
releases the new daemon generation's wait queues.

Only enter catatonic mode when the pipe which failed is still the current
pipe. Factor the already-locked transition so the identity check and state
change are atomic with respect to another replacement.

This was reproduced on v7.3-rc5-337-gff47652a4b66c in a local QEMU guest.
An unprivileged UID 65534 lookup filled the old packet pipe before a
normal CATATONIC/SETPIPEFD restart. On the unmodified kernel, the new pipe
received HUP and both a pending victim lookup and a later lookup failed
with ENOENT in two out of two fresh-mount runs.

With this change, the new pipe remained active, received an intact
304-byte request, and both victim lookups completed in two out of two
runs. Normal lookup and restart-without-a-blocked-writer controls passed.
No KASAN, oops, refcount, or lock diagnostic was observed. A source
reproducer and complete local logs are available privately on request.

The demonstrated impact is limited to denial of a shared autofs service
during a legitimate daemon restart. No memory corruption, information leak,
privilege escalation, or code execution primitive was observed.

Fixes: 8d7b48e0bc5fa ("autofs4: add miscellaneous device for ioctls")
Cc: stable@vger.kernel.org
Signed-off-by: Sung Byeongchan <tjdqudcks0424@naver.com>
Link: https://patch.msgid.link/20261007173542.593624-1-tjdqudcks0424@naver.com
Acked-by: Ian Kent <raven@themaw.net>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/autofs/waitq.c |   25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

--- a/fs/autofs/waitq.c
+++ b/fs/autofs/waitq.c
@@ -12,15 +12,13 @@
  */
 static autofs_wqt_t autofs_next_wait_queue = 1;
 
-void autofs_catatonic_mode(struct autofs_sb_info *sbi)
+static void autofs_catatonic_mode_locked(struct autofs_sb_info *sbi)
 {
 	struct autofs_wait_queue *wq, *nwq;
 
-	mutex_lock(&sbi->wq_mutex);
-	if (sbi->flags & AUTOFS_SBI_CATATONIC) {
-		mutex_unlock(&sbi->wq_mutex);
+	lockdep_assert_held(&sbi->wq_mutex);
+	if (sbi->flags & AUTOFS_SBI_CATATONIC)
 		return;
-	}
 
 	pr_debug("entering catatonic mode\n");
 
@@ -40,6 +38,21 @@ void autofs_catatonic_mode(struct autofs
 	fput(sbi->pipe);	/* Close the pipe */
 	sbi->pipe = NULL;
 	sbi->pipefd = -1;
+}
+
+void autofs_catatonic_mode(struct autofs_sb_info *sbi)
+{
+	mutex_lock(&sbi->wq_mutex);
+	autofs_catatonic_mode_locked(sbi);
+	mutex_unlock(&sbi->wq_mutex);
+}
+
+static void autofs_catatonic_mode_for_pipe(struct autofs_sb_info *sbi,
+					   struct file *pipe)
+{
+	mutex_lock(&sbi->wq_mutex);
+	if (sbi->pipe == pipe)
+		autofs_catatonic_mode_locked(sbi);
 	mutex_unlock(&sbi->wq_mutex);
 }
 
@@ -170,7 +183,7 @@ static void autofs_notify_daemon(struct
 		autofs_wait_release(sbi, wq->wait_queue_token, ret);
 		break;
 	default:
-		autofs_catatonic_mode(sbi);
+		autofs_catatonic_mode_for_pipe(sbi, pipe);
 		break;
 	}
 	fput(pipe);


