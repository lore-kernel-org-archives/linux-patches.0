Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BCA834D387;
	Fri, 31 Oct 2025 14:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919401; cv=none; b=Yx4LzYQN3tT7U2f9ZIgqW93vz2eTM+S2yFGL5lKweU7ILfTPYBIEttr+DGK+rLJOnXZHSVr3wfi9iWAm3pm6qvQ7TNmfGkFFxH+2HVfM1EsVG/mo9Z/JqrgaMlFpOU8S3koQ+RP8mqcCc85g+1q6+mZQuj+XL3YtRP2q2XG1XV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919401; c=relaxed/simple;
	bh=tKgupqb/LKXryb10Gv18BHbwUrMJq8a1R2B0fTyps+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cfScA+y40VyZ5Z8KUwtZW5G/K+SY1eOVXpV3wdcDGVWmlqPFcwgdPRnhrbY8zf0h0Kc8ED2MrT1fzbxXxtGIb/O4M3+1PzbVBrAAUF51NEgcEr3CDr78CmIyCYy4t2E9m1x8ihWte1waX0GmEvsV63ARUItyc1nIEpZR0rVhl/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1vYYI/um; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1vYYI/um"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C257DC4CEE7;
	Fri, 31 Oct 2025 14:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761919401;
	bh=tKgupqb/LKXryb10Gv18BHbwUrMJq8a1R2B0fTyps+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1vYYI/umTj/KSf8A8UjwKhiDfpnjH6eIt0ENSItAppBU3MltcpJZDqSA75qFWCj6/
	 evwMuqwcJ2uQIEXuJs2xFxaeN9EAJrqlUF2UQ/D1LuHw1ustzztTC9ZhC2Xps7h+vI
	 ZbCFFIeGooY+sSmrxyI8E4e1XBFFxIwIvrtQYf6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Yury Norov <yury.norov@gmail.com>,
	William Breathitt Gray <wbg@kernel.org>
Subject: [PATCH 6.6 28/32] bits: add comments and newlines to #if, #else and #endif directives
Date: Fri, 31 Oct 2025 15:01:22 +0100
Message-ID: <20251031140043.130039894@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251031140042.387255981@linuxfoundation.org>
References: <20251031140042.387255981@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

[ Upstream commit 31299a5e0211241171b2222c5633aad4763bf700 ]

This is a preparation for the upcoming GENMASK_U*() and BIT_U*()
changes. After introducing those new macros, there will be a lot of
scrolling between the #if, #else and #endif.

Add a comment to the #else and #endif preprocessor macros to help keep
track of which context we are in. Also, add new lines to better
visually separate the non-asm and asm sections.

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Stable-dep-of: 2ba5772e530f ("gpio: idio-16: Define fixed direction of the GPIO lines")
Signed-off-by: William Breathitt Gray <wbg@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/bits.h |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/include/linux/bits.h
+++ b/include/linux/bits.h
@@ -18,17 +18,21 @@
  * GENMASK_ULL(39, 21) gives us the 64bit vector 0x000000ffffe00000.
  */
 #if !defined(__ASSEMBLY__)
+
 #include <linux/build_bug.h>
 #define GENMASK_INPUT_CHECK(h, l) \
 	(BUILD_BUG_ON_ZERO(__builtin_choose_expr( \
 		__is_constexpr((l) > (h)), (l) > (h), 0)))
-#else
+
+#else /* defined(__ASSEMBLY__) */
+
 /*
  * BUILD_BUG_ON_ZERO is not available in h files included from asm files,
  * disable the input check if that is the case.
  */
 #define GENMASK_INPUT_CHECK(h, l) 0
-#endif
+
+#endif /* !defined(__ASSEMBLY__) */
 
 #define __GENMASK(h, l) \
 	(((~UL(0)) - (UL(1) << (l)) + 1) & \


