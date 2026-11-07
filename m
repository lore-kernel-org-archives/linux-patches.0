Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064958;
	b=XR5pbU1f3i4h/IeHFHIgNBBH07Oi63tK055RagLtG1oGo7ISBJwQpiD0+TBeMFy3ejDq
	 78CPV/bD/JzGVOubrrDMwZfGu3gOGSLhG6Ht6NdQfSC9RFs+rVWtSKP1n8RkuJ2SJdRUX
	 ukbYyHNcGoB5k989FqYDStTWuw7SqyFvCGosN0LIxxNeKjPj2X3E6x4mrzjsk+eLNlrCf
	 V/qHsQBqm2meQGmqibTi8oX00tXOBTTtVLE28oGrERHgRP77LqNNevVwJELPWJu7Ih2y9
	 oN8mS4h8C8hiuaUg/kIxfS71Lt0GBEEO0bwmYfsmm1CLWjZx+fDYC8mNW3eziA4+Neg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064958;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=basHaUeP+E0uVyVtPvnwNtrtQmeWjl1OiSjdzx9YrEQ=;
	b=ya8FyrQ2tH99aIhYhj7Kv8isRXc2CyutG1B0VY/2IlXNlE9jHg853ok1nZ8pv8w7h/qG
	 7zxQSaTbXJVuYAyd9h/5C5VSfs+3bLQ9KxlZendYoKi8l/xLXwAQCQC7kJy8ePrpciukl
	 1m4z8BX6jEeS5zNMlUdl1yzWXgl6tB6KW8IiKO0kWiPxw3U1O7KdrPtom3dDz+bOaSOY7
	 pAwPUAo5Kl7vUkwzBVN8qtDvdy2G2syYa9mDMFHUhNpfaCUqpLDzkbv6BBa2MdPcxQEtM
	 0yaygt5UwHrI7TkEiOexs0k2qN9kXdFmuCUBj5kVTGUcADXkSkL+mZwUrrgz2db7AmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VWiH31sJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF744606A9C1;
	Sat,  7 Nov 2026 15:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VWiH31sJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DA961F0089F;
	Sat,  7 Nov 2026 15:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064957;
	bh=basHaUeP+E0uVyVtPvnwNtrtQmeWjl1OiSjdzx9YrEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VWiH31sJW6xR7akGI4AxZyAzlSm3ZseYRhgmOGHHPPOj5lKLnG2ykBCBXk5Hg5lAb
	 21WFBrukenOrH0Tq7KalelvzQrvhfDPQDofNSR7BJv1n5VhwI72Lb+LYYNgqKAIs9c
	 T4E/2hdLmKviFlwZ0mii4lcAHNX6LPJDuiQAop0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	"Harry Yoo (Meta)" <harry@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0843/1257] ipc, msg: Account msg_msg allocations with GFP_KERNEL_ACCOUNT again
Date: Sat,  7 Nov 2026 08:52:19 -0500
Message-ID: <20261107135002.607260224@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index e28f0cecb2ec9..12663a40e9ae6 100644
--- a/ipc/msgutil.c
+++ b/ipc/msgutil.c
@@ -58,7 +58,8 @@ static struct msg_msg *alloc_msg(size_t len)
 	size_t alen;
 
 	alen = min(len, DATALEN_MSG);
-	msg = kmem_buckets_alloc(msg_buckets, sizeof(*msg) + alen, GFP_KERNEL);
+	msg = kmem_buckets_alloc(msg_buckets, sizeof(*msg) + alen,
+				 GFP_KERNEL_ACCOUNT);
 	if (msg == NULL)
 		return NULL;
 
-- 
2.53.0



