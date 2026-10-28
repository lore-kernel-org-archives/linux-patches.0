Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212223;
	b=AJZv7hZfThBgxR9jzaKstJ3oeo0MYutuW/A32lbUwrxBXVUEGySRXGG2HGubF922+ZCQ
	 z6NKYhG0AWxvdWfOVN66RZ8aRSeDJQ1zF6VkP1GNgVwTOQFq4bzVD8MzTo4gLxpdRHxl/
	 TVkVbPgnlCcj6H6hMu1/2bMx0CVjGTb844DRbRKT9sYjePWMrC3qGI0QP3AfySaZLLI/C
	 gk+F+8c9RhNl1xG2PabWX4EyaQ0Va9Gp96lGkTVIIxdEqeb6bYFE4X76j9z8RNV2Op04Q
	 GbbpXvJID4VBULUBCpekyxTW+/GICj86e18wG9v5keh53tGoixaxTXN4QgWAboBP9+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212223;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lbAUmRzzQOXVdg4e9ntRNK4ubNvu6ioqxVlwmtpE6uQ=;
	b=XxecPgVveM2nJ6idGFk2dI4ogYiYQQGVqWUJuVeS5+8x8bBcoymzDQRYZoaF6Y72EFsd
	 WJM7xebaAnCbHFuo9ZnRwRd8VcnAHdCQyK469c544FHte+CCV9yuRY/XyTRqa9h/KPQfj
	 WL60IXVPUJXML4MWELK658CkHQnSPEAm2GYUIG3he7HKR5IeDPbYkqx2resYZKVGsKhlr
	 E87O/8mP4dkl0sHTTjXvy5xT46Oko4S/Q0OpL8HeJ+1Jf6i1BgS6iZZKi6Ikwp2lK9PC3
	 sN2rQAyHuLsBB5dOo2+V5bEbDwYV6r/aTev8h1D9fRjeG7Gsy4XLu9eSxS0+H83FSjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SYEib2l4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A1B7606A31A;
	Wed, 28 Oct 2026 18:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SYEib2l4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C79AD1F01825;
	Wed, 28 Oct 2026 18:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212223;
	bh=lbAUmRzzQOXVdg4e9ntRNK4ubNvu6ioqxVlwmtpE6uQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SYEib2l4Mzj3BIoZviuuSwurl8LCtxvYey4qU2De41GBXQan6ua1xnxZnwIaQSAEL
	 8LlT+1JENEBbJE7V4ARfiDaSBePewzCXPAeBkc62pSVKbRPNq/h91bzzLFnkzdHkMf
	 wt/jMD9gfP3zmm8huY3+R6zZ6XN1tGtd3hNndKmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiacheng Yu <yujiacheng3@huawei.com>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0081/1887] params: fix charp corruption on allocation failure
Date: Wed, 28 Oct 2026 17:36:17 +0100
Message-ID: <20261028170501.076897052@linuxfoundation.org>
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

From: Jiacheng Yu <yujiacheng3@huawei.com>

[ Upstream commit 3dfaae04243cde460d82dfc2a7dd0bb6664d20ae ]

param_set_charp() stores charp parameters in allocated memory after slab is
available, and releases the previous value when the parameter is updated.

The previous value is released before the replacement allocation succeeds.
If kmalloc_parameter() fails, the setter returns -ENOMEM with the parameter
left as NULL.

Failing zswap's compressor update before zswap is initialized can later
trigger:

  BUG: kernel NULL pointer dereference, address: 0000000000000000
  RIP: 0010:strcmp+0x10/0x30
  Call Trace:
    zswap_setup+0x3b1/0x490
    zswap_enabled_param_set+0x5b/0xa0
    param_attr_store+0x93/0xe0
    module_attr_store+0x1c/0x30
    kernfs_fop_write_iter+0x116/0x1f0

Allocate and copy the replacement first, then replace the parameter value
only after allocation succeeds.

Fixes: e180a6b7759a ("param: fix charp parameters set via sysfs")
Cc: stable@vger.kernel.org
Signed-off-by: Jiacheng Yu <yujiacheng3@huawei.com>
Reviewed-by: Petr Pavlu <petr.pavlu@suse.com>
Signed-off-by: Petr Pavlu <petr.pavlu@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/params.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/kernel/params.c b/kernel/params.c
index 03443c99496c6..1b699c7632598 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -265,6 +265,7 @@ EXPORT_SYMBOL_GPL(param_set_uint_minmax);
 
 int param_set_charp(const char *val, const struct kernel_param *kp)
 {
+	char *tmp;
 	size_t len, maxlen = 1024;
 
 	len = strnlen(val, maxlen + 1);
@@ -273,19 +274,20 @@ int param_set_charp(const char *val, const struct kernel_param *kp)
 		return -ENOSPC;
 	}
 
-	maybe_kfree_parameter(*(char **)kp->arg);
-
 	/*
 	 * This is a hack. We can't kmalloc() in early boot, and we
 	 * don't need to; this mangled commandline is preserved.
 	 */
 	if (slab_is_available()) {
-		*(char **)kp->arg = kmalloc_parameter(len + 1);
-		if (!*(char **)kp->arg)
+		tmp = kmalloc_parameter(len + 1);
+		if (!tmp)
 			return -ENOMEM;
-		strcpy(*(char **)kp->arg, val);
+		memcpy(tmp, val, len + 1);
 	} else
-		*(const char **)kp->arg = val;
+		tmp = (char *)val;
+
+	maybe_kfree_parameter(*(char **)kp->arg);
+	*(char **)kp->arg = tmp;
 
 	return 0;
 }
-- 
2.53.0



