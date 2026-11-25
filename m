Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619775;
	b=S6CR7SvmO8gzZr152Doq1s67avZ9MOH9XCTQPSm0CvZ2MIB9DblOA1QBuZcEtf0UJzUB
	 xuPdWU8CxHvKjQrrWRrTqCkHeM8KYx1v/QMJi3BRQmIU/MYCm5/XE2VQJ0kAidi6PX30J
	 QOAy1LfoF2zYf05QzEmlUceiwdcSoSQnLReRdjer3nKiZE78hrTRjjNkVYBQzRarkqAm/
	 +fm9oLkp71eufF5tqroHMFk+yOBC7lzOhV89LR+xcrarDr7n14utukutkU8bBUBFRnXRo
	 BXqpfe1bOZ0mixD6rT5O+8NiIh/DjFsH6F5Kv+LqvVchJoCgLq4tbbdL9FsWuXWFj8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619775;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rnRajMKRTCA7ap43Wt9RJfkTCd1y6623Efpbea5/V6w=;
	b=AUE5yDpXd+emcAIg6jnYGgJuc0WvD53jmaWxg4ycLRBZty1AMNwjJdc/CLJNGdZgIJnq
	 1B+Io+G1elGYGYHyzluhjWxBiA6RGT0eeUcOxgvxr9p323xbeYNk8RqddNB97nBmfl2S1
	 tz1VfcFVfnJ8u9UumU5dtGcjw3Md2TooF0RXI9OlxJ7QKxPJjwG3GFQzG8fA9QoUCSo0d
	 E3pZCUNDErR9YqlDkSE172vWb6+Ro0S51+YaOf8yBkVx28lyBK4NGasV0QKl5pmugsgcw
	 nBYBwnuHlK5srQDlyu0+wF8rjZK/SZ36zS/MRbTzCS6pL6zy+/HWjHLQ0ieKEuMUMZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rqcdaFGR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F351606A31E;
	Wed, 25 Nov 2026 15:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rqcdaFGR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C112C1F000C0;
	Wed, 25 Nov 2026 15:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619775;
	bh=rnRajMKRTCA7ap43Wt9RJfkTCd1y6623Efpbea5/V6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rqcdaFGRoIDoo0A9XVUzLahC1UyxVcFuRWx/ewIp2xHoC6piUp2Tzfr8Cv0GXbXds
	 gtw8zY/AjjuZ3SgaQ17XNRP7veoNdBTl6LVw2C0c61OfV6weXJCmf1ytHOK44gg6Nh
	 o9fLxYabOyY1DRXrLkI1TUxkWppgdt/oCCbpbiXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.3 0705/1005] arm64/gcs: Ignore attempts to change GCS mode during signal return
Date: Wed, 25 Nov 2026 15:34:03 +0100
Message-ID: <20261125143838.274645874@linuxfoundation.org>
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

From: Mark Brown <broonie@kernel.org>

commit d395db3dcd4c590d26a2f3d581d8d5b7ddbfa478 upstream.

If userspace tries to update the GCS mode as part of signal return then
we update the thread state but don't update GCSCRE0_EL1, meaning the
change does not take effect.  We may also get issues for other tasks on
context switch since we suppress writes of the register if the two tasks
have the same mode.

Since no currently known userspace tries to use this functionality close
this by ignoring any attempt to change the mode through signal return.
The GCS mode for the current thread can be changed using the prctl()
interface and will be preserved on signal return, allowing updates to
the mode from the signal handler.

Reported-by: Catalin Marinas <catalin.marinas@arm.com>
Link: https://lore.kernel.org/r/as-8IqsbMbOBo5Oq@arm.com
Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
Fixes: 16f47bb9ac8a ("arm64/signal: Expose GCS state in signal frames")
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/arch/arm64/gcs.rst |   13 ++++---------
 arch/arm64/kernel/signal.c       |   22 +---------------------
 2 files changed, 5 insertions(+), 30 deletions(-)

--- a/Documentation/arch/arm64/gcs.rst
+++ b/Documentation/arch/arm64/gcs.rst
@@ -179,9 +179,8 @@ intended to be exhaustive.
 
 When returning from a signal handler:
 
-* If there is a gcs_context record in the signal frame then the GCS flags
-  and GCSPR_EL0 will be restored from that context prior to further
-  validation.
+* If there is a gcs_context record in the signal frame then GCSPR_EL0
+  will be restored from that context prior to further validation.
 
 * If there is no gcs_context record in the signal frame then the GCS
   configuration will be unchanged.
@@ -190,12 +189,8 @@ When returning from a signal handler:
   point to a valid GCS signal cap record, this will be popped from the
   GCS prior to signal return.
 
-* If the GCS configuration is locked when returning from a signal then any
-  attempt to change the GCS configuration will be treated as an error.  This
-  is true even if GCS was not enabled prior to signal entry.
-
-* GCS may be disabled via signal return but any attempt to enable GCS via
-  signal return will be rejected.
+* The features_enabled in the signal return context will be ignored; any
+  changes made using the prctl() in the signal handler will be preserved.
 
 
 6.  ptrace extensions
--- a/arch/arm64/kernel/signal.c
+++ b/arch/arm64/kernel/signal.c
@@ -741,36 +741,16 @@ static int preserve_gcs_context(struct g
 
 static int restore_gcs_context(struct user_ctxs *user)
 {
-	u64 gcspr, enabled;
+	u64 gcspr;
 	int err = 0;
 
 	if (user->gcs_size != sizeof(*user->gcs))
 		return -EINVAL;
 
 	__get_user_error(gcspr, &user->gcs->gcspr, err);
-	__get_user_error(enabled, &user->gcs->features_enabled, err);
 	if (err)
 		return err;
 
-	/* Don't allow unknown modes */
-	if (enabled & ~PR_SHADOW_STACK_SUPPORTED_STATUS_MASK)
-		return -EINVAL;
-
-	err = gcs_check_locked(current, enabled);
-	if (err != 0)
-		return err;
-
-	/* Don't allow enabling */
-	if (!task_gcs_el0_enabled(current) &&
-	    (enabled & PR_SHADOW_STACK_ENABLE))
-		return -EINVAL;
-
-	/* If we are disabling disable everything */
-	if (!(enabled & PR_SHADOW_STACK_ENABLE))
-		enabled = 0;
-
-	current->thread.gcs_el0_mode = enabled;
-
 	/*
 	 * We let userspace set GCSPR_EL0 to anything here, we will
 	 * validate later in gcs_restore_signal().


