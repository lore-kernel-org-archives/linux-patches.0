Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1CE7149C4C;
	Tue, 25 Jun 2024 09:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309207; cv=none; b=iK7QR7iQl7a9FBAXIeizdFcGKVPiL/it3fOl/D+ApYWTXbX2KcOlLKoGsxABSPtWApsqaRfhwkQP15wpidbtOTmwn8YH3E00Ui/xhRVpX9eY5LQK2/mkcIBVTFuyW3yOVZnhMvckuED1KdUVORchDPbVDwP9k/PkexrldHk/ohs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309207; c=relaxed/simple;
	bh=RBx75681xPHp2gYdTn3ZJ+vaAopKazXUwJG6NOBMGXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ku/Zqs8ikpaHCnva25KOLv7pw/SIsy0qz1NJyYRbFOCXp4sXAk/+lHOj1/AI7lAzBqQwM6CrGQNxOInhFRUQbBiqFYwTEnPnvVZXig9NIsN1CaGAmtH+oLDdRocrLIPtBAzSrRc8XW8dJe060EF8Grf8f+L3FvnM96I9aiwxC/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tECSVXza; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tECSVXza"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6742CC32786;
	Tue, 25 Jun 2024 09:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309206;
	bh=RBx75681xPHp2gYdTn3ZJ+vaAopKazXUwJG6NOBMGXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tECSVXzaQPFhJHPZjcNecN0JwPFzxgyHY4nisxlFtbttV1jkhSZNlrS9cl+FO+vc4
	 J1ysZBClfyh1foFPvH8u4Y2PF0qV/Pj9KZBXEGD3XBIThDKovMSORNlbABZLs2hJP9
	 +fxFoudRi+6/NvH+WxOxdLkkc3DYdCbFPolSh3mQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Carlos Llamas <cmllamas@google.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Kees Cook <keescook@chromium.org>
Subject: [PATCH 6.6 132/192] locking/atomic: scripts: fix ${atomic}_sub_and_test() kerneldoc
Date: Tue, 25 Jun 2024 11:33:24 +0200
Message-ID: <20240625085542.226398642@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[cmllamas: generate headers with gen-atomics.sh]
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/atomic/atomic-arch-fallback.h |    6 +++---
 include/linux/atomic/atomic-instrumented.h  |    8 ++++----
 include/linux/atomic/atomic-long.h          |    4 ++--
 scripts/atomic/kerneldoc/sub_and_test       |    2 +-
 4 files changed, 10 insertions(+), 10 deletions(-)

--- a/include/linux/atomic/atomic-arch-fallback.h
+++ b/include/linux/atomic/atomic-arch-fallback.h
@@ -2221,7 +2221,7 @@ raw_atomic_try_cmpxchg_relaxed(atomic_t
 
 /**
  * raw_atomic_sub_and_test() - atomic subtract and test if zero with full ordering
- * @i: int value to add
+ * @i: int value to subtract
  * @v: pointer to atomic_t
  *
  * Atomically updates @v to (@v - @i) with full ordering.
@@ -4333,7 +4333,7 @@ raw_atomic64_try_cmpxchg_relaxed(atomic6
 
 /**
  * raw_atomic64_sub_and_test() - atomic subtract and test if zero with full ordering
- * @i: s64 value to add
+ * @i: s64 value to subtract
  * @v: pointer to atomic64_t
  *
  * Atomically updates @v to (@v - @i) with full ordering.
@@ -4649,4 +4649,4 @@ raw_atomic64_dec_if_positive(atomic64_t
 }
 
 #endif /* _LINUX_ATOMIC_FALLBACK_H */
-// 2fdd6702823fa842f9cea57a002e6e4476ae780c
+// f8888b25626bea006e7f11f7add7cecc33d0fa2e
--- a/include/linux/atomic/atomic-instrumented.h
+++ b/include/linux/atomic/atomic-instrumented.h
@@ -1341,7 +1341,7 @@ atomic_try_cmpxchg_relaxed(atomic_t *v,
 
 /**
  * atomic_sub_and_test() - atomic subtract and test if zero with full ordering
- * @i: int value to add
+ * @i: int value to subtract
  * @v: pointer to atomic_t
  *
  * Atomically updates @v to (@v - @i) with full ordering.
@@ -2905,7 +2905,7 @@ atomic64_try_cmpxchg_relaxed(atomic64_t
 
 /**
  * atomic64_sub_and_test() - atomic subtract and test if zero with full ordering
- * @i: s64 value to add
+ * @i: s64 value to subtract
  * @v: pointer to atomic64_t
  *
  * Atomically updates @v to (@v - @i) with full ordering.
@@ -4469,7 +4469,7 @@ atomic_long_try_cmpxchg_relaxed(atomic_l
 
 /**
  * atomic_long_sub_and_test() - atomic subtract and test if zero with full ordering
- * @i: long value to add
+ * @i: long value to subtract
  * @v: pointer to atomic_long_t
  *
  * Atomically updates @v to (@v - @i) with full ordering.
@@ -5000,4 +5000,4 @@ atomic_long_dec_if_positive(atomic_long_
 
 
 #endif /* _LINUX_ATOMIC_INSTRUMENTED_H */
-// 1568f875fef72097413caab8339120c065a39aa4
+// 5f7bb165838dcca35625e7d4b42540b790abd19b
--- a/include/linux/atomic/atomic-long.h
+++ b/include/linux/atomic/atomic-long.h
@@ -1527,7 +1527,7 @@ raw_atomic_long_try_cmpxchg_relaxed(atom
 
 /**
  * raw_atomic_long_sub_and_test() - atomic subtract and test if zero with full ordering
- * @i: long value to add
+ * @i: long value to subtract
  * @v: pointer to atomic_long_t
  *
  * Atomically updates @v to (@v - @i) with full ordering.
@@ -1795,4 +1795,4 @@ raw_atomic_long_dec_if_positive(atomic_l
 }
 
 #endif /* _LINUX_ATOMIC_LONG_H */
-// 4ef23f98c73cff96d239896175fd26b10b88899e
+// f8204cfa718c04a01e3c7a15257ac85bbef54c23
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


