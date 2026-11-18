Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057131;
	b=jyXCK0ApbrgLNi8oVHBGPi/IQ8U7sG8qoI7m5MQa5BE3gIGcP0nkeiDMRONS7bYHFT+i
	 kfynLuHZxlyblLurR85SRsRXCPYVGl0s8F+kCrQHNl1ozjIrc/8M1PWNAFesnHNGBUgK6
	 HE5UmPtSzQPYAmlGlP1nUT2KlnMgkzQ9BEkGQe5+U1wUf78De4EM5Kz3pZjSiw/ChBMZT
	 aZ7C/pL9GyiILn5y2lMC0th8EWkBrVxqf18NPlS8j0IFwGsDlhkOLmiUO/v2nahzcv2wl
	 /9lbVRAPOtuQH9eo6FZy/rYOo+OEPFXQMTUec6FKwjmM9ktQE9Z41hlntPv1/h4XKzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057131;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=a4iYoG27R7C7/PR81vHBt83sb0Q1DjvzKDtaN4GKMss=;
	b=IzE9Ptl6FwythmVnaAtti1bUgEwctIYWU4Mk0I+XHWUQzZXmToV7381TscWz+XGKnj9N
	 9b95tCYmSFJEwhp/L+6rKtPPlcdH4N0ca+MjJwGID48r5gw9ymD5eLn1EeYiV2Pkc12fy
	 HgRPcTqu4Zq3gMiaXU6MzbcRMRnRRDsAWqKerGHxSl724IqkcnKOgY846g8vM8o6oHLlp
	 psIbvQgS5x7pdpFF81HdhiFxzKDF/2nNHulhrV+vsEPcxpYaeWW5nsF79lFPkMA/R4YIb
	 14+veG9htTH/4CFgSB+uZp7+RQ5gnLyZOXiaKHrziZKMiGkdKkGcI7O81GnBcTf8luQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HFBmpAes;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 534EC606A325;
	Thu, 19 Nov 2026 02:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HFBmpAes
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE0471F000C4;
	Thu, 19 Nov 2026 02:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057131;
	bh=a4iYoG27R7C7/PR81vHBt83sb0Q1DjvzKDtaN4GKMss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HFBmpAesiYekM5wrWZXw/+ShnTkJ1nTTQBdFachPINyOVJQZ6kmTc9HnGSYco3u+E
	 M0s3RBf17Gf4FKnLRC1xs1neCcNirZAPrGbohF5T6I2uWvHqqFX+IenAzjzpg3/Elj
	 MBS1YR+TjCA9Hh68mOxzNE+WnuMBn8JeAQrUDxxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Airlie <airlied@redhat.com>,
	Philipp Stanner <pstanner@redhat.com>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Kees Cook <keescook@chromium.org>,
	Zack Rusin <zackr@vmware.com>,
	Roman Demidov <roman.demidov.nn@gmail.com>
Subject: [PATCH 5.10 0023/1848] string.h: add array-wrappers for (v)memdup_user()
Date: Wed, 18 Nov 2026 15:34:21 +0100
Message-ID: <20261118145912.038834989@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philipp Stanner <pstanner@redhat.com>

commit 313ebe47d75558511aa1237b6e35c663b5c0ec6f upstream.

Currently, user array duplications are sometimes done without an
overflow check. Sometimes the checks are done manually; sometimes the
array size is calculated with array_size() and sometimes by calculating
n * size directly in code.

Introduce wrappers for arrays for memdup_user() and vmemdup_user() to
provide a standardized and safe way for duplicating user arrays.

This is both for new code as well as replacing usage of (v)memdup_user()
in existing code that uses, e.g., n * size to calculate array sizes.

Suggested-by: David Airlie <airlied@redhat.com>
Signed-off-by: Philipp Stanner <pstanner@redhat.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Zack Rusin <zackr@vmware.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230920123612.16914-3-pstanner@redhat.com
Stable-dep-of: c833d6c7199c ("drm/amdgpu: Limit BO list entry count to prevent resource exhaustion")
Signed-off-by: Roman Demidov <roman.demidov.nn@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/string.h |   40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -5,6 +5,8 @@
 #include <linux/compiler.h>	/* for inline */
 #include <linux/types.h>	/* for size_t */
 #include <linux/stddef.h>	/* for NULL */
+#include <linux/err.h>		/* for ERR_PTR() */
+#include <linux/overflow.h>	/* for check_mul_overflow() */
 #include <stdarg.h>
 #include <uapi/linux/string.h>
 
@@ -13,6 +15,44 @@ extern void *memdup_user(const void __us
 extern void *vmemdup_user(const void __user *, size_t);
 extern void *memdup_user_nul(const void __user *, size_t);
 
+/**
+ * memdup_array_user - duplicate array from user space
+ * @src: source address in user space
+ * @n: number of array members to copy
+ * @size: size of one array member
+ *
+ * Return: an ERR_PTR() on failure. Result is physically
+ * contiguous, to be freed by kfree().
+ */
+static inline void *memdup_array_user(const void __user *src, size_t n, size_t size)
+{
+	size_t nbytes;
+
+	if (check_mul_overflow(n, size, &nbytes))
+		return ERR_PTR(-EOVERFLOW);
+
+	return memdup_user(src, nbytes);
+}
+
+/**
+ * vmemdup_array_user - duplicate array from user space
+ * @src: source address in user space
+ * @n: number of array members to copy
+ * @size: size of one array member
+ *
+ * Return: an ERR_PTR() on failure. Result may be not
+ * physically contiguous. Use kvfree() to free.
+ */
+static inline void *vmemdup_array_user(const void __user *src, size_t n, size_t size)
+{
+	size_t nbytes;
+
+	if (check_mul_overflow(n, size, &nbytes))
+		return ERR_PTR(-EOVERFLOW);
+
+	return vmemdup_user(src, nbytes);
+}
+
 /*
  * Include machine specific inline routines
  */


