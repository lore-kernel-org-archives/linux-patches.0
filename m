Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC0CB414A36;
	Thu, 16 Jul 2026 13:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209025; cv=none; b=T/3S5ndii1zNzwqPP2IkgDy0VYq6nUK9LRTzw/OwOjsynHhtVZBgTZT8NcG1rCe86vFbyYuSnIVs0ZIUwMs9fqFLNdDr9yNy7ZrnM+AvhCFGmroIrvuRjTIrY7X0pRnBh/qaUC48vqozs/PT5MqVPSfjRKelhQhI2wVTbXzqDa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209025; c=relaxed/simple;
	bh=F7YZ1a/B4Fq4PDyFayN9XF+/dG0xGfol0dY9U1Ijnkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e3gKrD7xCYr+X8AtShPfEuPfsF2M/dp9kBcdtlUIYKUwCWC0YEJ+tMZ6XeaN/wMu/udZN/8/uRsCd5jSAHHNh/MHCI5dipQUE1e3/U+xd0DR/QZwLpvg6EFQR6HQMMaZD8WkaGz+ijRahazois9IFo8+a1AbiK81RDCmEDRIL+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JmCisyGF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JmCisyGF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 176EC1F000E9;
	Thu, 16 Jul 2026 13:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209023;
	bh=gpfFV3V5XB3Jd52wLluXX/JRgEvz06CGfInlwMX0UKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JmCisyGFyA1rqsKBCTT1SG//KSzF4T8GDb+0QuD5Iw4+gG4Av8OGWXMCQUpYIltdV
	 bGMTt4ImAOfd1M/P3bKOAnIkskvFqnkwqVxO5K3JGJsKDBuaDnku/+qO9I34YcypyU
	 YUG00CeLe12iyVbc/7swiY57bpeKLgH6TISGt9Qg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	"Harry Yoo (Oracle)" <harry@kernel.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 7.1 006/518] slab: recognize @GFP parameter as optional in kernel-doc
Date: Thu, 16 Jul 2026 15:24:34 +0200
Message-ID: <20260716133047.917597710@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1000,7 +1000,7 @@ void *kmalloc_nolock_noprof(size_t size,
 /**
  * kmalloc_obj - Allocate a single instance of the given type
  * @VAR_OR_TYPE: Variable or type to allocate.
- * @GFP: GFP flags for the allocation.
+ * @...: optional GFP flags for the allocation (GFP_KERNEL when not specified).
  *
  * Returns: newly allocated pointer to a @VAR_OR_TYPE on success, or NULL
  * on failure.
@@ -1012,7 +1012,7 @@ void *kmalloc_nolock_noprof(size_t size,
  * kmalloc_objs - Allocate an array of the given type
  * @VAR_OR_TYPE: Variable or type to allocate an array of.
  * @COUNT: How many elements in the array.
- * @GFP: GFP flags for the allocation.
+ * @...: optional GFP flags for the allocation (GFP_KERNEL when not specified).
  *
  * Returns: newly allocated pointer to array of @VAR_OR_TYPE on success,
  * or NULL on failure.
@@ -1025,7 +1025,7 @@ void *kmalloc_nolock_noprof(size_t size,
  * @VAR_OR_TYPE: Variable or type to allocate (with its flex array).
  * @FAM: The name of the flexible array member of the structure.
  * @COUNT: How many flexible array member elements are desired.
- * @GFP: GFP flags for the allocation.
+ * @...: optional GFP flags for the allocation (GFP_KERNEL when not specified).
  *
  * Returns: newly allocated pointer to @VAR_OR_TYPE on success, NULL on
  * failure. If @FAM has been annotated with __counted_by(), the allocation


