Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28AF53148C2;
	Thu, 16 Jul 2026 13:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210388; cv=none; b=PzoFbxxN6LzU7n0np5iS84Zlj80SAjmh6RRpDfzgDWkSsYeApjxcM1CrwPJNjwGB4kvzS0FVGe+kHzop2TcuDQEe94DYriterm4RlU/pngUWjRzWFMa1xY1VFdkIK0AKLQKvPW/+Rfn9i6j5BqtJwyfM18r7CA0Vy3jY+JhLhUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210388; c=relaxed/simple;
	bh=qeEbnxAQ3ZvKkbBNlM6Qpi/Sm69KMPhyrD1EGTHdVuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O9idnQL4p8/00qA2XkSJskhiblNRJExpcSvvWX2ewG/xlF3kIWnzPwojFdhpWa7vMjtV5vCZsRuj7l73dG0A2BGVvwpY3xkaUwpA5U2C8iXADvRJw7Chg/8MarfRgy2+vVw0GU8ZhEStBttjzseBZ/psNOcW38Zp3kN1lr8kdwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1KF8WXxU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1KF8WXxU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E9EE1F000E9;
	Thu, 16 Jul 2026 13:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210387;
	bh=CINwCD6wtzwAMaWcL+tWf5ZfZRb9KiRhZpHwrQ72UP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1KF8WXxUI9cQwS70tK33jzufsycTArsCVF4DbcAP/Qb6D+TFJ1nqCVkt5gsNP2UBq
	 89bMK63LoqpgM8FfLyQa3tYcsQebs8w7NnEr94JIwiklKtHS4pF7r+D1LBjJRcsQ/m
	 9DBEml1bSChpg4Z1h5Lt+HHH72p6V57+zdQPE26E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	"Harry Yoo (Oracle)" <harry@kernel.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.18 028/480] slab: recognize @GFP parameter as optional in kernel-doc
Date: Thu, 16 Jul 2026 15:26:15 +0200
Message-ID: <20260716133045.304862935@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Randy Dunlap <rdunlap@infradead.org>

commit 7b5f5865fb11e60edd03c5e063e2d228b7062317 upstream.

Since the @GFP parameter in kmalloc_obj() etc. is now optional, change
the kernel-doc to indicate that it is optional. This avoids kernel-doc
warnings:

WARNING: include/linux/slab.h:1101 Excess function parameter 'GFP' description in 'kmalloc_obj'
WARNING: include/linux/slab.h:1113 Excess function parameter 'GFP' description in 'kmalloc_objs'
WARNING: include/linux/slab.h:1128 Excess function parameter 'GFP' description in 'kmalloc_flex'

Fixes: e19e1b480ac7 ("add default_gfp() helper macro and use it in the new *alloc_obj() helpers")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Harry Yoo (Oracle) <harry@kernel.org>
Link: https://patch.msgid.link/20260617163125.2716279-1-rdunlap@infradead.org
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/slab.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -1006,7 +1006,7 @@ void *kmalloc_nolock_noprof(size_t size,
 /**
  * kmalloc_obj - Allocate a single instance of the given type
  * @VAR_OR_TYPE: Variable or type to allocate.
- * @GFP: GFP flags for the allocation.
+ * @...: optional GFP flags for the allocation (GFP_KERNEL when not specified).
  *
  * Returns: newly allocated pointer to a @VAR_OR_TYPE on success, or NULL
  * on failure.
@@ -1018,7 +1018,7 @@ void *kmalloc_nolock_noprof(size_t size,
  * kmalloc_objs - Allocate an array of the given type
  * @VAR_OR_TYPE: Variable or type to allocate an array of.
  * @COUNT: How many elements in the array.
- * @GFP: GFP flags for the allocation.
+ * @...: optional GFP flags for the allocation (GFP_KERNEL when not specified).
  *
  * Returns: newly allocated pointer to array of @VAR_OR_TYPE on success,
  * or NULL on failure.
@@ -1031,7 +1031,7 @@ void *kmalloc_nolock_noprof(size_t size,
  * @VAR_OR_TYPE: Variable or type to allocate (with its flex array).
  * @FAM: The name of the flexible array member of the structure.
  * @COUNT: How many flexible array member elements are desired.
- * @GFP: GFP flags for the allocation.
+ * @...: optional GFP flags for the allocation (GFP_KERNEL when not specified).
  *
  * Returns: newly allocated pointer to @VAR_OR_TYPE on success, NULL on
  * failure. If @FAM has been annotated with __counted_by(), the allocation


