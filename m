Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B52EB1DFF7;
	Thu, 25 Jul 2024 14:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721919323; cv=none; b=lVEorA1OxA68XwFKlXSUtDBxjBstlwXWRB6sjxfRPwKyc+3giYcLXZYnFNmVGUVRNnZfbbDCkQj/6k6H+hv573/kgX1IatiP4oUVuGBzcDGy1zOKx44KbgiVi1KuMmfjdEuSn4MHrfJ2w81YqoQMUTeSBSkJmqUCKUGc923h0YA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721919323; c=relaxed/simple;
	bh=cWH2yR97IGQaQmklwSmftqP/bgDqNnU2PS2rh/umo2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nYN4etRq8Ob/k+OGkukc43+N+BAJQdm089UVygSGxPGN8T6XDNNiWvFv80Gxg8n6g2eTNZyZyGbjcv2FoWpmKhovoGsz2Xe4TX1lhqY6KFarFfeHEH7JwDjBqeGT5XQFF0A3kFhEA7RuY0A4/n/gpafCG/bJlOxUmFaRAo3AJhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0r6wAwlh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0r6wAwlh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AB04C116B1;
	Thu, 25 Jul 2024 14:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721919323;
	bh=cWH2yR97IGQaQmklwSmftqP/bgDqNnU2PS2rh/umo2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0r6wAwlhhi8hFEqN+l/pIbDSpp04QSgoIM+RlvemhCyIgkBZTR4uhwHpXX9Ry0ZIz
	 N0ah1C9dbZmN4BzdWBg3dqZ8JEzvy5kF0VvB0mB5Sv6J40i/3FO9IMKo0HfJfnCRXA
	 86HLWKXf6z6WlxvJIhm+r64r4jQb8oq/IeorvJUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Laight <david.laight@aculab.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Christoph Hellwig <hch@infradead.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	SeongJae Park <sj@kernel.org>
Subject: [PATCH 5.15 70/87] minmax: relax check to allow comparison between unsigned arguments and signed constants
Date: Thu, 25 Jul 2024 16:37:43 +0200
Message-ID: <20240725142741.075359047@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142738.422724252@linuxfoundation.org>
References: <20240725142738.422724252@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Laight <David.Laight@ACULAB.COM>

commit 867046cc7027703f60a46339ffde91a1970f2901 upstream.

Allow (for example) min(unsigned_var, 20).

The opposite min(signed_var, 20u) is still errored.

Since a comparison between signed and unsigned never makes the unsigned
value negative it is only necessary to adjust the __types_ok() test.

Link: https://lkml.kernel.org/r/633b64e2f39e46bb8234809c5595b8c7@AcuMS.aculab.com
Signed-off-by: David Laight <david.laight@aculab.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
(cherry picked from commit 867046cc7027703f60a46339ffde91a1970f2901)
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/minmax.h |   24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -9,13 +9,18 @@
 /*
  * min()/max()/clamp() macros must accomplish three things:
  *
- * - avoid multiple evaluations of the arguments (so side-effects like
+ * - Avoid multiple evaluations of the arguments (so side-effects like
  *   "x++" happen only once) when non-constant.
- * - perform signed v unsigned type-checking (to generate compile
- *   errors instead of nasty runtime surprises).
- * - retain result as a constant expressions when called with only
+ * - Retain result as a constant expressions when called with only
  *   constant expressions (to avoid tripping VLA warnings in stack
  *   allocation usage).
+ * - Perform signed v unsigned type-checking (to generate compile
+ *   errors instead of nasty runtime surprises).
+ * - Unsigned char/short are always promoted to signed int and can be
+ *   compared against signed or unsigned arguments.
+ * - Unsigned arguments can be compared against non-negative signed constants.
+ * - Comparison of a signed argument against an unsigned constant fails
+ *   even if the constant is below __INT_MAX__ and could be cast to int.
  */
 #define __typecheck(x, y) \
 	(!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))
@@ -25,9 +30,14 @@
 	__builtin_choose_expr(__is_constexpr(is_signed_type(typeof(x))),	\
 		is_signed_type(typeof(x)), 0)
 
-#define __types_ok(x, y) 			\
-	(__is_signed(x) == __is_signed(y) ||	\
-		__is_signed((x) + 0) == __is_signed((y) + 0))
+/* True for a non-negative signed int constant */
+#define __is_noneg_int(x)	\
+	(__builtin_choose_expr(__is_constexpr(x) && __is_signed(x), x, -1) >= 0)
+
+#define __types_ok(x, y) 					\
+	(__is_signed(x) == __is_signed(y) ||			\
+		__is_signed((x) + 0) == __is_signed((y) + 0) ||	\
+		__is_noneg_int(x) || __is_noneg_int(y))
 
 #define __cmp_op_min <
 #define __cmp_op_max >


