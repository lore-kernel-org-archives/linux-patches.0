Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210532;
	b=NqiG4TN2JJ3FTFvYKuyFAVXLxhfCo0ZQHl7LFc5lIXfe9iCfvSElGtMzgKOrtAR7Gxqd
	 QpEzepvxO9Ijtbo8pAr8ysyBvstuEW0E8FbEgvzPlMf8/Z7z7oPzK7h9PWJksKiIalfR4
	 u26y/XsYNcvBJ+bJNg52dahITsNQGPa7M29fbX9UcWQupm4NgTJkRqvJdf5FD41LtCpZC
	 9PJwzWxv817w3qdE/cyaOlaTYqbiZlrAxFTJmGWKANrtazy2uklmBGLOQCWP192u7v5s7
	 uTmwSpDZidvbwDbHKr/w6pJ/4MmDmm27PCxAv5IxDw8kPBKHu4S96dRGbodHoacVM/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210532;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=70zlAzhjuLnuGurE7xJWYsovYM/QZMbvkHZBGKl05fc=;
	b=smAb9NrGtqGYtAxax++jov5cVSus0n9tnNfz635AkO4OfpkByEgz+GH021anHRNXvwDz
	 0+I9wsP/Pg4s47D3Xy3f87F48GKywiXLxuoIH/kMF+fBjMyT9TyVtiDp1T9XgJ8DutmEg
	 sYmPX5FODUX9YhVS02awOl5D8fxqzJcgRmtw6mvmXbdrE0XxIUHpiJgpeElzQT8zP1lDl
	 bBfsFC7ojrmWbS9HNaQ9K3hMMx0NRtefwECleaDVR2FiPW5BToT05puvOX1z3x5SrQe+h
	 e+TI4i7DpwGQYxIjgDnsW8oMqvrBIu1t0Q9nUKMqcI5cUCMyHFVfQ4rBh9Ay31+ioVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qoak8C2D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 498A2606A31C;
	Wed, 28 Oct 2026 18:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qoak8C2D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99B961F01825;
	Wed, 28 Oct 2026 18:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210532;
	bh=70zlAzhjuLnuGurE7xJWYsovYM/QZMbvkHZBGKl05fc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qoak8C2Dh32Z2D8fci2njbNCkgY9JwrwM0FuSwN6iW7VTH6f3Gz37H8QzARDRZ85Q
	 rUfI+L4F/4qYW47u7eF84GCDfmO+ifJ4tKrhWRp750r/2N3pafVxatlD4YLNi+W9f0
	 kBnpoA1x7dPwzSwd6DPzHks4yLZkeyMX4UXdaeOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luis Chamberlain <mcgrof@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 059/571] params: Use size_add() for kmalloc()
Date: Wed, 28 Oct 2026 17:53:26 +0100
Message-ID: <20261028170009.427318269@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 0fc79cbc937f2a754a302a710a94b68c61d0a89a ]

Prevent allocations from integer overflow by using size_add().

Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20231120151419.1661807-4-andriy.shevchenko@linux.intel.com
Signed-off-by: Kees Cook <keescook@chromium.org>
Stable-dep-of: 3dfaae04243c ("params: fix charp corruption on allocation failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/params.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/params.c b/kernel/params.c
index 55541483d6d36..0139fe38d0b2a 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -11,6 +11,7 @@
 #include <linux/moduleparam.h>
 #include <linux/device.h>
 #include <linux/err.h>
+#include <linux/overflow.h>
 #include <linux/slab.h>
 #include <linux/ctype.h>
 #include <linux/security.h>
@@ -48,7 +49,7 @@ static void *kmalloc_parameter(unsigned int size)
 {
 	struct kmalloced_param *p;
 
-	p = kmalloc(sizeof(*p) + size, GFP_KERNEL);
+	p = kmalloc(size_add(sizeof(*p), size), GFP_KERNEL);
 	if (!p)
 		return NULL;
 
-- 
2.53.0



