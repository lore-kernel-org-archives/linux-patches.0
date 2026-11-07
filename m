Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062423;
	b=qqT1XzuE0ZxKBXFnN+dwHtLkZoVmK+ileD9m/YdE3tZ+KxYWKpCRaTut5aJ/KZSNCYUL
	 AJa6Z2cnevLCtF3OHeNd8K+Pk1NsfigKmJBEHQcoJG+Ddv1rKXxwA9ld8oZRYuU4RdecL
	 0c6nJdrZZzvPsJSjAvf3etufK6UmVA9iDFnVlNiCpYRuISkUoz8eRMT2yygfwbM4KYaKr
	 kvn7VnXxFV5twNRzOAJ4kClmItQWt6jwoV3fGqgAxW3H0DqSg4GXhl7BZ4kn001nZpEJG
	 YFs/7qwuUsWjpJ4XzNkLd7jJ3gMbCbK+4CfZzECBY23SxY+L7lyUENZ3Q+CTZKZFBXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062423;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zosh0abQ5NaEAOQv2pCOTPKGSkGy04ntsjCWTMwILuU=;
	b=WtPZcfm/4JgAqQLMbwUp2OMkxoDYlXjr2bAY6smMTUw2fkMDqY3i2o2KCSspIWMA2P45
	 JI3EIfSPooIWI4JZM4MQnn2A20DGrbvRZuved5YCdPa1u7mBQq25YSg+/CnF+wMw9nS93
	 OAr1PuKFGuCVgde4MJGK50gdhTzUtua4F1BWCZEIxGxijdWxnICpBS5kDx4o9yjWluUAU
	 cT5tfm2rnXe/By+TxA6d98RvOKAbLPO+QuPup/i1qS7ueRWlo/dXHzG1YrilLFgG/LrAW
	 EklTE428VU15DKzWGf48hK4ClqV53PxTyXhsmnot27CmTb5kWjq8MHBQmgon61u8OCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O1Wm3q18;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F420060A261B;
	Sat,  7 Nov 2026 14:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O1Wm3q18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A038B1F0089F;
	Sat,  7 Nov 2026 14:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062422;
	bh=zosh0abQ5NaEAOQv2pCOTPKGSkGy04ntsjCWTMwILuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O1Wm3q185AJPwn+C+rv3ovxrnQoAeXz58JSJu+zDJ4bdutHVjPdzf5pe510zi0TfY
	 WVgwD35ORBiUVmG6TG7/jrWQU3gLbP8slmDeJlNyX+kScSVjArfNaRTH6FAxxOiQ8g
	 rJXjvWKEyx0n5v3GuBj+RMYQhLPGHkT4rzgjZoqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	"Harry Yoo (Meta)" <harry@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1337/1536] ipc, msg: Account msg_msg allocations with GFP_KERNEL_ACCOUNT again
Date: Sat,  7 Nov 2026 08:55:53 -0500
Message-ID: <20261107135035.369403326@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <kees@kernel.org>

[ Upstream commit c57fbbe42e907fa26c5ffada52d913d4ca5fa66e ]

Since commit 734bbc1c97ea7 ("ipc, msg: Use dedicated slab buckets for
alloc_msg()"), alloc_msg() allocates with GFP_KERNEL, and a msg_msg is
accounted only through SLAB_ACCOUNT on its bucket caches. With
CONFIG_SLAB_BUCKETS=n, kmem_buckets_create() creates no caches and
kmem_buckets_alloc() is a GFP_KERNEL kmalloc() from the general caches,
which do not account it; the same happens when kmem_buckets_create()
fails. Either way, the allocation is not charged to the sender's memory
cgroup.

Allocate with GFP_KERNEL_ACCOUNT again, as before that commit, so the
allocation is charged whichever cache serves it.

Build tested ARCH=x86_64 defconfig with GCC 16.2.0, with
CONFIG_SLAB_BUCKETS as y and n.

Fixes: 734bbc1c97ea7 ("ipc, msg: Use dedicated slab buckets for alloc_msg()")
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <kees@kernel.org>
Link: https://patch.msgid.link/20261014052344.384723-2-kees@kernel.org
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 ipc/msgutil.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/ipc/msgutil.c b/ipc/msgutil.c
index c7be0c7926476..7d5fb92e6f2e3 100644
--- a/ipc/msgutil.c
+++ b/ipc/msgutil.c
@@ -61,7 +61,8 @@ static struct msg_msg *alloc_msg(size_t len)
 	size_t alen;
 
 	alen = min(len, DATALEN_MSG);
-	msg = kmem_buckets_alloc(msg_buckets, sizeof(*msg) + alen, GFP_KERNEL);
+	msg = kmem_buckets_alloc(msg_buckets, sizeof(*msg) + alen,
+				 GFP_KERNEL_ACCOUNT);
 	if (msg == NULL)
 		return NULL;
 
-- 
2.53.0



