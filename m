Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212209;
	b=aiq/prv7yfo8FBGZwaGKeXnPfDsCKwwKl0Av21WV3FgCXR7tMXeyQzKGQdSWE8ETkCda
	 xoj1FHne4fosxI+QtvLPCAxuv0PrwBoVJeFKoFdJP6KSo8SHPNuuAyUoZT46qUs7tY+32
	 3HEXFgx2UWk+wmFu2l9ew+GwNZAneD2jBBfIweDM+NemBrl8vEntVcyWeSrkE/CPtv6g5
	 7myEYBxsBPLGaZM4zpnLzsEJghMYcTzJOahRFYAd3z4GnBgF5sA5kxghNZhHHivuHiK9K
	 MIq9m0nG4/BmGDuDlyLxk5vGJPU+NlPDUwjY7TjvNfzg2fAzy09knacNSkom8QHvpkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212209;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s2eSCJ7SLow10u0YdapddpUVBPUUzT5zlOgYzvbw/dU=;
	b=AaFc7VSvzgBsmPLvJj3+3ii7hNEf+1762nDc+j7XSgQKD9cIi4xMK+SIEXWeoBgTn6wC
	 hf2baBUTWqcpveB69rwvRJbqtb1ODvXG/0OCBFJZeawjiZR+kXNTxwxqasjN2lMIYAK57
	 oskKWtRU4i96h5o7kdqYbrGP1N3hreu6vV4CFB/F8aQ4NNMl7YJ6aBsrG2MlpusN+Z9OH
	 AgCLiOnwZtAyBfyVeXbTHJDiidE0HRZbxV3BzKs31nS7tCmhNKRbgdrrOTpnuzxuqK91Y
	 yiNug3E71/jqrmVURgEHaIaS00S6DV04KunkdLqwhHUcdPQs38vgKL5IE70+oBNoeCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Kkwiphqs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7346A606A31A;
	Wed, 28 Oct 2026 18:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Kkwiphqs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D08D1F01825;
	Wed, 28 Oct 2026 18:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212209;
	bh=s2eSCJ7SLow10u0YdapddpUVBPUUzT5zlOgYzvbw/dU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KkwiphqsICuKFSDqPnLfsvNXK79gYZ1piczkSOHjH22bN7khVzZZSgihhS0bPBNLD
	 higk7ewdCdpHKmA8cZnXWuP6IC7VIFM/XiN2DxnPqZH1RARLFRiG0/y6u81BnVuqJ/
	 BQa2IK81NbxgSGCyEKZgL6Pv7OZhpnjoBUysqZfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luis Chamberlain <mcgrof@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0077/1887] params: Do not go over the limit when getting the string length
Date: Wed, 28 Oct 2026 17:36:13 +0100
Message-ID: <20261028170500.986159152@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit fd0cd057a1b7351604daa6ffc91dfe28adf7225d ]

We can use strnlen() even on early stages and it prevents from
going over the string boundaries in case it's already too long.

Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20231120151419.1661807-3-andriy.shevchenko@linux.intel.com
Signed-off-by: Kees Cook <keescook@chromium.org>
Stable-dep-of: 3dfaae04243c ("params: fix charp corruption on allocation failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/params.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/kernel/params.c b/kernel/params.c
index e6df4c2ef097c..89c139e861faf 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -264,7 +264,10 @@ EXPORT_SYMBOL_GPL(param_set_uint_minmax);
 
 int param_set_charp(const char *val, const struct kernel_param *kp)
 {
-	if (strlen(val) > 1024) {
+	size_t len, maxlen = 1024;
+
+	len = strnlen(val, maxlen + 1);
+	if (len == maxlen + 1) {
 		pr_err("%s: string parameter too long\n", kp->name);
 		return -ENOSPC;
 	}
@@ -274,7 +277,7 @@ int param_set_charp(const char *val, const struct kernel_param *kp)
 	/* This is a hack.  We can't kmalloc in early boot, and we
 	 * don't need to; this mangled commandline is preserved. */
 	if (slab_is_available()) {
-		*(char **)kp->arg = kmalloc_parameter(strlen(val)+1);
+		*(char **)kp->arg = kmalloc_parameter(len + 1);
 		if (!*(char **)kp->arg)
 			return -ENOMEM;
 		strcpy(*(char **)kp->arg, val);
@@ -512,7 +515,7 @@ int param_set_copystring(const char *val, const struct kernel_param *kp)
 {
 	const struct kparam_string *kps = kp->str;
 
-	if (strlen(val)+1 > kps->maxlen) {
+	if (strnlen(val, kps->maxlen) == kps->maxlen) {
 		pr_err("%s: string doesn't fit in %u chars.\n",
 		       kp->name, kps->maxlen-1);
 		return -ENOSPC;
-- 
2.53.0



