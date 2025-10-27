Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C04B31D75B;
	Mon, 27 Oct 2025 18:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591461; cv=none; b=sek7OszS+n1AjEBJElVyU3rEqLEn5trlQJA0TLT3WbRKra7JEi6+XHm6O6gvxensOmA2cF2dfzykncTTSiZUVOluDwu5XUxmDHaJNtexH3uq8wnv4p71ZxJ+rEYbUvDcEvhyVPq6QvA0B4+OraRrFPsofLZMcrLoounvVQbZKMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591461; c=relaxed/simple;
	bh=atDCiZ4S6+tOfDGeeTPC5WhzmWbm3XLA/0djUXzMjCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z45KaD7HYrWNPatFGW0IRTCmOnk8EcD1s7kBPWeuGbD/qxJcVIr9miCixDOaHeXdJJjwovprv2aqWIaV44FtmlPQd86qcXs9JntOzo3O9dRYc7foWrLdEJrWobT4b4YX6SiKEHnpye9qlDBTVXxWFwggY9Zi95rkGsoVgpP/IQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nHOL2F6q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nHOL2F6q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB10BC4CEF1;
	Mon, 27 Oct 2025 18:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591461;
	bh=atDCiZ4S6+tOfDGeeTPC5WhzmWbm3XLA/0djUXzMjCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nHOL2F6qXwCAurjtqacQTCNIwdRqUOkVqSTJiSLJv3zJqN5s0HZD73L+ZeBnJR3mf
	 8n8Q9zN02JGu+KlQgYBXojGZtWcmsiAjtO0vkzawZEPEQ7Tje+GwHFi+cMw9O1DsqV
	 pTfnIoTATfpp0Khjw8hoNb5CyokU2wvr6IxSj6vA=
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
	Eliav Farber <farbere@amazon.com>
Subject: [PATCH 5.10 205/332] minmax: relax check to allow comparison between unsigned arguments and signed constants
Date: Mon, 27 Oct 2025 19:34:18 +0100
Message-ID: <20251027183530.137899381@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Laight <David.Laight@ACULAB.COM>

[ Upstream commit 867046cc7027703f60a46339ffde91a1970f2901 ]

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
Signed-off-by: Eliav Farber <farbere@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/minmax.h |   24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -10,13 +10,18 @@
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
@@ -26,9 +31,14 @@
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


