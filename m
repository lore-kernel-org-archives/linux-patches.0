Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75634307AE5;
	Tue, 30 Sep 2025 15:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245948; cv=none; b=a9WbmCLLCWvMWHncXdhF2Go+C5wwObvCRHUgq6scsXjv7sATn73bTJG6xTqimWEGvMt6wPqyQfPrglD70vBanlMbEo86lTw0H9SEUcuEXV4BMSk/R8f1Rkp5tiZUWPRkyfUUMTpfYMXoU7oO1eL8clEl9y2edJv/NtPaDCNfeik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245948; c=relaxed/simple;
	bh=7s990RIa1oyl+1+95eeFSORrgkM18SDfgRb3J//snp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W0IDrdWE85HjcbmfGNoxfP/Q5vGgetFHAOOq5ITn+QmqbjSlPat1fKOqXUW+p1XC20bt8i5tU+6RVmc6FNb4rnMw7KF3wIf4X0ZqCvhTBwc5xiR4+h5/vRAWhcixjZ415AF/ELDupskCtQJwTBDmjAk1XrflN2J1Q+o97DvH5m0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ASSqyt9B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ASSqyt9B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA9FEC4CEF0;
	Tue, 30 Sep 2025 15:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245948;
	bh=7s990RIa1oyl+1+95eeFSORrgkM18SDfgRb3J//snp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ASSqyt9BFV3c+tw8+TeHeS6XZaABC6SX3Yfs/obsrw4IcSZr+zsji9Q6zjJuaaxvj
	 8d4wuVp50fjYL6U3iO0l08cbs8qZ6U1SE1fZ2KPKzvDFgymVOs4SnZlVxcou6ElzKJ
	 2k8FHBcroaiWXqF3GUyYj1qQyHUcVGjwZAKah3qI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Laight <david.laight@aculab.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Arnd Bergmann <arnd@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Jens Axboe <axboe@kernel.dk>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Matthew Wilcox <willy@infradead.org>,
	Pedro Falcato <pedro.falcato@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Eliav Farber <farbere@amazon.com>
Subject: [PATCH 6.6 90/91] minmax.h: simplify the variants of clamp()
Date: Tue, 30 Sep 2025 16:48:29 +0200
Message-ID: <20250930143824.915925907@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.118938523@linuxfoundation.org>
References: <20250930143821.118938523@linuxfoundation.org>
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

From: David Laight <David.Laight@ACULAB.COM>

[ Upstream commit 495bba17cdf95e9703af1b8ef773c55ef0dfe703 ]

Always pass a 'type' through to __clamp_once(), pass '__auto_type' from
clamp() itself.

The expansion of __types_ok3() is reasonable so it isn't worth the added
complexity of avoiding it when a fixed type is used for all three values.

Link: https://lkml.kernel.org/r/8f69f4deac014f558bab186444bac2e8@AcuMS.aculab.com
Signed-off-by: David Laight <david.laight@aculab.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Arnd Bergmann <arnd@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Pedro Falcato <pedro.falcato@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/minmax.h |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -183,29 +183,29 @@
 #define __clamp(val, lo, hi)	\
 	((val) >= (hi) ? (hi) : ((val) <= (lo) ? (lo) : (val)))
 
-#define __clamp_once(val, lo, hi, uval, ulo, uhi) ({				\
-	__auto_type uval = (val);						\
-	__auto_type ulo = (lo);							\
-	__auto_type uhi = (hi);							\
+#define __clamp_once(type, val, lo, hi, uval, ulo, uhi) ({			\
+	type uval = (val);							\
+	type ulo = (lo);							\
+	type uhi = (hi);							\
 	BUILD_BUG_ON_MSG(statically_true(ulo > uhi),				\
 		"clamp() low limit " #lo " greater than high limit " #hi);	\
 	BUILD_BUG_ON_MSG(!__types_ok3(uval, ulo, uhi),				\
 		"clamp("#val", "#lo", "#hi") signedness error");		\
 	__clamp(uval, ulo, uhi); })
 
-#define __careful_clamp(val, lo, hi) \
-	__clamp_once(val, lo, hi, __UNIQUE_ID(v_), __UNIQUE_ID(l_), __UNIQUE_ID(h_))
+#define __careful_clamp(type, val, lo, hi) \
+	__clamp_once(type, val, lo, hi, __UNIQUE_ID(v_), __UNIQUE_ID(l_), __UNIQUE_ID(h_))
 
 /**
- * clamp - return a value clamped to a given range with strict typechecking
+ * clamp - return a value clamped to a given range with typechecking
  * @val: current value
  * @lo: lowest allowable value
  * @hi: highest allowable value
  *
- * This macro does strict typechecking of @lo/@hi to make sure they are of the
- * same type as @val.  See the unnecessary pointer comparisons.
+ * This macro checks @val/@lo/@hi to make sure they have compatible
+ * signedness.
  */
-#define clamp(val, lo, hi) __careful_clamp(val, lo, hi)
+#define clamp(val, lo, hi) __careful_clamp(__auto_type, val, lo, hi)
 
 /**
  * clamp_t - return a value clamped to a given range using a given type
@@ -217,7 +217,7 @@
  * This macro does no typechecking and uses temporary variables of type
  * @type to make all the comparisons.
  */
-#define clamp_t(type, val, lo, hi) __careful_clamp((type)(val), (type)(lo), (type)(hi))
+#define clamp_t(type, val, lo, hi) __careful_clamp(type, val, lo, hi)
 
 /**
  * clamp_val - return a value clamped to a given range using val's type
@@ -230,7 +230,7 @@
  * type and @lo and @hi are literals that will otherwise be assigned a signed
  * integer type.
  */
-#define clamp_val(val, lo, hi) clamp_t(typeof(val), val, lo, hi)
+#define clamp_val(val, lo, hi) __careful_clamp(typeof(val), val, lo, hi)
 
 /*
  * Do not check the array parameter using __must_be_array().


