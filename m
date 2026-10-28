Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212212;
	b=0WOryFPTb3RQToOm5NzWMIoUYJ3c9lgbmbpM9s/pxut6QDWdzW+PnDoqDI5uLn2GU244
	 ZqLgpbizOJehL17LZb/SKcHLV6fnNRSAGpci9NvRnqLXVSflEH2mpPWCLYkYg3FeRexL6
	 0GhwgNpRdnx0pztlxlphjwsHERhpr/AAptw1mmLj6hbXxYEv7+tYTK1rbbGqLn1nskjfx
	 +AVYpoNa/OgcBGFxbIXp7eIoN0flewMZBr5g9+WVj72vYy0okwGAXM/MXeoYuuzBQ0iIT
	 Vofp3dfrM+Ut6QQdThhFApbu6O3wbdfYb7+L6S9E9a4HjLO9QciA6O8L2BsQxlyA6Ww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212212;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=H6nn5DxvYGQE2APB5ax1ZucJOtlHsk09OFJ+S3jMwI4=;
	b=jrOnxnAwR7GoSimlC2y4v5ukv5mXuUQ6fYzEHgkVDSmDRtZGzLa35BYoYZO9q85Nnb46
	 OZzhNzCrEe3/TrOWpl/yOjn2KqC8wDqtqg+t3Sgp9zgVaqe5UxWXR48I4sRf+LKGyf1uO
	 3B3HyciBDEjM/Wd2dS6iJzWIqb0CBilMW/89LEiMhCseBhOd5orvWOxz5qeOcFoJUpJ4y
	 drw5imer81l5u/IDMdea+TFff4R0pecu11nyloh+cdBSATXiYYBjzEutCwdOvLr/vK42e
	 krwzTlqcalg7OMMyzyeO7uJFYgkLERAhGLVWN5WuSUvlM1NYOF+MTeZkuzV/dWmiL6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F73vFQjY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F0B4606A31A;
	Wed, 28 Oct 2026 18:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F73vFQjY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DD421F01825;
	Wed, 28 Oct 2026 18:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212212;
	bh=H6nn5DxvYGQE2APB5ax1ZucJOtlHsk09OFJ+S3jMwI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F73vFQjY9dt5sCLOJQ7zqUODLn8Ly8FVNBhE1l2IlwWVqA2USiHvR4t3ioQIgp8p3
	 sbyg3GoTwOowjkPINZT79D/OgqmLijBVAZ2Z7V7xGYAPSdmSORL4PEv7+u8bYMkF5v
	 w+2oslxYJfYuqIf84OcaiSL+WLd2ZFoVMYUlPZSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luis Chamberlain <mcgrof@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0078/1887] params: Use size_add() for kmalloc()
Date: Wed, 28 Oct 2026 17:36:14 +0100
Message-ID: <20261028170501.009228486@linuxfoundation.org>
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
index 89c139e861faf..4d021ba9c677a 100644
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



