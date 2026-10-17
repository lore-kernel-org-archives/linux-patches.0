Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0AEB3939A2;
	Sat, 17 Oct 2026 16:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255151; cv=none; b=RcakkJHRgs16cDpDxKcIf4TMNdJlWb2TwP2SkZXQqUkwAVCu8dzv3ctFg2JJjKNf1nuhwDGcAtaWvjm2nDq4Roo2CVVpB/aieaCVTlN6yznIQQdP3JczYUhqCP7XMz0sBb82jpNJNE0qbzR2/rqnTcw3uwHYAes5kitWDbiSalE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255151; c=relaxed/simple;
	bh=gTeo7UEgzhDDyFubfXSGbomdUGPAPikOTFbbOIp1SAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NkapHlVXKCzldQZYdbx1MLytqLi1myqFTPJ+z7aTvZ5PlfzCPjLr35KjM9w+/c5m5CzcpOLY6/GBjp4r5hLf97fCzolj2vBFEFnkzj/es3ru6i/KJwo630Nr7NoCQfPFRE+W8Z/E33a+NqvqQztQW070Tf1GNiR/SeMUpgaLfY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q9a70JhA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q9a70JhA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 463051F000C7;
	Sat, 17 Oct 2026 16:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255149;
	bh=f0c/J5XEtOl53ztCf8nOiIlger4QEvAcYia5CGuUKjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q9a70JhA6Y1m1PJbph1hiaXCW/0gTA8gAcA4trw3CgOEzdRskge7Nmf/O8qN11fnD
	 629BaCuEFEKheRWzYdQ+yR4Li2mBuZAG34HzpLKGR+w1nn2Xn4pnmF6yeC2btttUpH
	 byhNcb6HdqahAhq/mTXr1aqnL+fGpm4KYYViZN4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-hardening@vger.kernel.org,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 681/869] drm/i915: document range_overflows() and range_end_overflows() macros
Date: Sat, 17 Oct 2026 17:58:42 +0200
Message-ID: <20261017160054.437893487@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

[ Upstream commit 59bf37add1d2223d699d1855354277b7330765e4 ]

Document the macros in preparation for making them more generally
available.

Cc: Kees Cook <kees@kernel.org>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: linux-hardening@vger.kernel.org
Reviewed-by: Jouni Högander <jouni.hogander@intel.com>
Link: https://lore.kernel.org/r/20250829174601.2163064-2-jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Stable-dep-of: 985f5e12f3cd ("drm/panthor: Add vm_bind region with kbo range overlap check")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/i915_utils.h | 46 +++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/drivers/gpu/drm/i915/i915_utils.h b/drivers/gpu/drm/i915/i915_utils.h
index 61e561d6996d6..a53d8a59ce19a 100644
--- a/drivers/gpu/drm/i915/i915_utils.h
+++ b/drivers/gpu/drm/i915/i915_utils.h
@@ -69,6 +69,18 @@ bool i915_error_injected(void);
 		drm_err(&(i915)->drm, fmt, ##__VA_ARGS__); \
 })
 
+/**
+ * range_overflows() - Check if a range is out of bounds
+ * @start: Start of the range.
+ * @size:  Size of the range.
+ * @max:   Exclusive upper boundary.
+ *
+ * A strict check to determine if the range [@start, @start + @size) is
+ * invalid with respect to the allowable range [0, @max). Any range
+ * starting at or beyond @max is considered an overflow, even if @size is 0.
+ *
+ * Returns: true if the range is out of bounds.
+ */
 #define range_overflows(start, size, max) ({ \
 	typeof(start) start__ = (start); \
 	typeof(size) size__ = (size); \
@@ -78,9 +90,32 @@ bool i915_error_injected(void);
 	start__ >= max__ || size__ > max__ - start__; \
 })
 
+/**
+ * range_overflows_t() - Check if a range is out of bounds
+ * @type:  Data type to use.
+ * @start: Start of the range.
+ * @size:  Size of the range.
+ * @max:   Exclusive upper boundary.
+ *
+ * Same as range_overflows() but forcing the parameters to @type.
+ *
+ * Returns: true if the range is out of bounds.
+ */
 #define range_overflows_t(type, start, size, max) \
 	range_overflows((type)(start), (type)(size), (type)(max))
 
+/**
+ * range_end_overflows() - Check if a range's endpoint is out of bounds
+ * @start: Start of the range.
+ * @size:  Size of the range.
+ * @max:   Exclusive upper boundary.
+ *
+ * Checks only if the endpoint of a range (@start + @size) exceeds @max.
+ * Unlike range_overflows(), a zero-sized range at the boundary (@start == @max)
+ * is not considered an overflow. Useful for iterator-style checks.
+ *
+ * Returns: true if the endpoint exceeds the boundary.
+ */
 #define range_end_overflows(start, size, max) ({ \
 	typeof(start) start__ = (start); \
 	typeof(size) size__ = (size); \
@@ -90,6 +125,17 @@ bool i915_error_injected(void);
 	start__ > max__ || size__ > max__ - start__; \
 })
 
+/**
+ * range_end_overflows_t() - Check if a range's endpoint is out of bounds
+ * @type:  Data type to use.
+ * @start: Start of the range.
+ * @size:  Size of the range.
+ * @max:   Exclusive upper boundary.
+ *
+ * Same as range_end_overflows() but forcing the parameters to @type.
+ *
+ * Returns: true if the endpoint exceeds the boundary.
+ */
 #define range_end_overflows_t(type, start, size, max) \
 	range_end_overflows((type)(start), (type)(size), (type)(max))
 
-- 
2.53.0



