Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774626;
	b=VUHFeZYlhWvN76VllLMumTI59yhJ8ht2TKInZo1yGzxsW+ToL0q3hOd+lz9VqAW0WQ8P
	 o1JgCRYIhWpyUCglk1D/uKi+aCQKkTIgpA/0Mp92pczUcXGtffct+J3X4i/g2jqvSwGhJ
	 zmhTws4UL27EGx88/aK6+Z2+WUuWouwdYbetH7wrb2HAq5kdgzLMIhMl2aKYdjp4FDB/K
	 GnB14Tbznde85Wsk6hpMPPUthNmWbOAQUzYkCiEu3d1CRqK48GzaxftXJSNu2DQVAf6jI
	 Js3eZzpEyOjJpIJ4Zq6PtZn2PYzrTs53TCmHD5AsmcgmpRfkFgprJNaKOqs6Q/hCsOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774626;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XRFpqZpKUmoEPvlL8drYBIzyYrIAlsQ/vOBUaQUE+2c=;
	b=MikKa7qT/5zuO3sCfv7CJ4C9Z4uCoUhbRAgDrvKqOnF1xPpFMqkt74uUhXHP9RqDxzIi
	 AXi70Guguf3BqmOaZX4CSGd482J2hHBW1NjsEk3AZq2nSdqgQuw7c9gnY9PzlK+IxxPT2
	 OlKr0ku06/7v/67KEFZxMDXUyMjhBEARzveZwEC9QIV1RafMvIE/0Qbcx5AUHCwXZvect
	 A6RzQoHopP/xJnK+zwNcmnaC5pWv995tAIcNjAeXBnCdoBOy6IXdXwuFYDhQ5GiVOB776
	 eQ3GICoibs5dAAREMnFzP2UMWcbxj+YY7Fxvz2fd/5Jqq59htsx4BU6be+fGqnB+w4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E1vTE8AT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FA66606A31B;
	Fri, 23 Oct 2026 16:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E1vTE8AT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D187B1F01825;
	Fri, 23 Oct 2026 16:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774626;
	bh=XRFpqZpKUmoEPvlL8drYBIzyYrIAlsQ/vOBUaQUE+2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E1vTE8ATEKRBVSyIbeLAKpAfovhKT8q85bZxrypRlf4udRPD4Ukqds8mfipV782gQ
	 l2VG0KcnhXM8p0Hd4ztLe8lT534KvMHjMd79JHg56w9k9gabRTO5i8B391wn0OZ7Gw
	 hU86E7327FcKwVkX5aC5mhLnAh33R3lKtfklozWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sung Byeongchan <tjdqudcks0424@naver.com>,
	Ian Kent <raven@themaw.net>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.2 105/242] autofs: ignore notification errors from a replaced pipe
Date: Fri, 23 Oct 2026 18:39:07 +0200
Message-ID: <20261023163716.265120756@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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


