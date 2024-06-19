Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80EF21459F2;
	Wed, 19 Jun 2024 13:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803305; cv=none; b=X5elt3VZRz3JVWcT1xvh1ec2BfS5UyuxZ9Hn8Ddp1q6jTnzjZG1raM+Z8Buc5KWpx34RZtr1gq/sKrgdDdO23wKpfSnfUIwgSTEnWBqgVue2cFEwgejoPLKxnUnhCaOkqRNo0kWXG+YAS03ey9eqL7trbQWgEhFOIzxf0oi9zSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803305; c=relaxed/simple;
	bh=xg0tZFPh6UotqL88FLNXRPHb5h/Xt72IjgekniJdkmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vGMLqU5VOtNP+IDNxks4ZKN8caGJgg0SvN5sfg2kFiDby8vWzms0bT1/BfeUQp8g9b1o80LR5V+nOplpCutGhJa9BzW7w2it/LQmMIdzoNPq8Uikdk62YdMwFAX0/USBWEp+bfkoMB9gC92GIBywLdbcz1qNt2uXQA5lBEf3/aE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s4WSu++X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s4WSu++X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96EB0C2BBFC;
	Wed, 19 Jun 2024 13:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803305;
	bh=xg0tZFPh6UotqL88FLNXRPHb5h/Xt72IjgekniJdkmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s4WSu++XudW4NtX7o9ILkSv/95Fe25v326PSQk5iCO4YGcpyh45SDG3TX/v6ib2W3
	 z1omeAaB/k9QwzGhg0AQIsGNb0pzytwGPjTwoG9Rv/RQltiwJsdT4pJbiTUSSL9Wlu
	 0ov0WizPzFFLGZG59xlwad8i03+RuTYBRymRof/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Carlos Llamas <cmllamas@google.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Kees Cook <keescook@chromium.org>
Subject: [PATCH 6.9 223/281] locking/atomic: scripts: fix ${atomic}_sub_and_test() kerneldoc
Date: Wed, 19 Jun 2024 14:56:22 +0200
Message-ID: <20240619125618.540842573@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carlos Llamas <cmllamas@google.com>

commit f92a59f6d12e31ead999fee9585471b95a8ae8a3 upstream.

For ${atomic}_sub_and_test() the @i parameter is the value to subtract,
not add. Fix the typo in the kerneldoc template and generate the headers
with this update.

Fixes: ad8110706f38 ("locking/atomic: scripts: generate kerneldoc comments")
Suggested-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20240515133844.3502360-1-cmllamas@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/atomic/atomic-arch-fallback.h |    6 +++---
 include/linux/atomic/atomic-instrumented.h  |    8 ++++----
 include/linux/atomic/atomic-long.h          |    4 ++--
 scripts/atomic/kerneldoc/sub_and_test       |    2 +-
 4 files changed, 10 insertions(+), 10 deletions(-)

--- a/include/linux/atomic/atomic-arch-fallback.h
+++ b/include/linux/atomic/atomic-arch-fallback.h
@@ -2242,7 +2242,7 @@ raw_atomic_try_cmpxchg_relaxed(atomic_t
 
 /**
  * raw_atomic_sub_and_test() - atomic subtract and test if zero with full ordering
- * @i: int value to add
+ * @i: int value to subtract
  * @v: pointer to atomic_t
  *
  * Atomically updates @v to (@v - @i) with full ordering.
@@ -4368,7 +4368,7 @@ raw_atomic64_try_cmpxchg_relaxed(atomic6
 
 /**
  * raw_atomic64_sub_and_test() - atomic subtract and test if zero with full ordering
- * @i: s64 value to add
+ * @i: s64 value to subtract
  * @v: pointer to atomic64_t
  *
  * Atomically updates @v to (@v - @i) with full ordering.
@@ -4690,4 +4690,4 @@ raw_atomic64_dec_if_positive(atomic64_t
 }
 
 #endif /* _LINUX_ATOMIC_FALLBACK_H */
-// 14850c0b0db20c62fdc78ccd1d42b98b88d76331
+// b565db590afeeff0d7c9485ccbca5bb6e155749f
--- a/include/linux/atomic/atomic-instrumented.h
+++ b/include/linux/atomic/atomic-instrumented.h
@@ -1349,7 +1349,7 @@ atomic_try_cmpxchg_relaxed(atomic_t *v,
 
 /**
  * atomic_sub_and_test() - atomic subtract and test if zero with full ordering
- * @i: int value to add
+ * @i: int value to subtract
  * @v: pointer to atomic_t
  *
  * Atomically updates @v to (@v - @i) with full ordering.
@@ -2927,7 +2927,7 @@ atomic64_try_cmpxchg_relaxed(atomic64_t
 
 /**
  * atomic64_sub_and_test() - atomic subtract and test if zero with full ordering
- * @i: s64 value to add
+ * @i: s64 value to subtract
  * @v: pointer to atomic64_t
  *
  * Atomically updates @v to (@v - @i) with full ordering.
@@ -4505,7 +4505,7 @@ atomic_long_try_cmpxchg_relaxed(atomic_l
 
 /**
  * atomic_long_sub_and_test() - atomic subtract and test if zero with full ordering
- * @i: long value to add
+ * @i: long value to subtract
  * @v: pointer to atomic_long_t
  *
  * Atomically updates @v to (@v - @i) with full ordering.
@@ -5050,4 +5050,4 @@ atomic_long_dec_if_positive(atomic_long_
 
 
 #endif /* _LINUX_ATOMIC_INSTRUMENTED_H */
-// ce5b65e0f1f8a276268b667194581d24bed219d4
+// 8829b337928e9508259079d32581775ececd415b
--- a/include/linux/atomic/atomic-long.h
+++ b/include/linux/atomic/atomic-long.h
@@ -1535,7 +1535,7 @@ raw_atomic_long_try_cmpxchg_relaxed(atom
 
 /**
  * raw_atomic_long_sub_and_test() - atomic subtract and test if zero with full ordering
- * @i: long value to add
+ * @i: long value to subtract
  * @v: pointer to atomic_long_t
  *
  * Atomically updates @v to (@v - @i) with full ordering.
@@ -1809,4 +1809,4 @@ raw_atomic_long_dec_if_positive(atomic_l
 }
 
 #endif /* _LINUX_ATOMIC_LONG_H */
-// 1c4a26fc77f345342953770ebe3c4d08e7ce2f9a
+// eadf183c3600b8b92b91839dd3be6bcc560c752d
--- a/scripts/atomic/kerneldoc/sub_and_test
+++ b/scripts/atomic/kerneldoc/sub_and_test
@@ -1,7 +1,7 @@
 cat <<EOF
 /**
  * ${class}${atomicname}() - atomic subtract and test if zero with ${desc_order} ordering
- * @i: ${int} value to add
+ * @i: ${int} value to subtract
  * @v: pointer to ${atomic}_t
  *
  * Atomically updates @v to (@v - @i) with ${desc_order} ordering.


