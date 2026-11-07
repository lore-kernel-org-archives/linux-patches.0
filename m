Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063459;
	b=awJJE0pqSvFSgJxX+GNeekPhvvfX6a3JXs+iuCZogsMReYWsDsWsns4NC7AsTXSqUjuR
	 8lvN7gmFP4dH5URX6gvt6mPNL/Ll4G4nYLqyC/WV5t9cRcLWI2tTEZo+GrjWT+ECxrFVS
	 fsVmTeLPuS1DWmLafp82ZbG/rs7OmtfV51/4vJGiIpGcX77gufxgKL9L946G9cSCj5qdp
	 nBFkpp/TJ6H2b9lF5bh9+0kVFPY9SJGBRiFC3cgsp0F5/l9InjsP/CBlpA3qBfhutwBhO
	 DItaOjpp8yFaUkkw2dW6c+q3jPKOuNyNByWbSWvJ6sWXdvYAjW7jjIcE08R80r+PBnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063459;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UGvHhFboszppVhJYHHEe6qaRK8Rj2XbNeMySqZyOuls=;
	b=s4FpocYtB5dgDQnKU+PpqI1vcCWpb31Ly/DtuZhEkQv33pXzoP7t12ubq1Tvjxhbkl9Q
	 dYl+KwQki2TbJLRgcVl6cEeepGwfTgXoeKZOf/253RzIRVw3CzhBBmAHnvOmyFOYLtpuc
	 dO4Q6cYSjaHLZitUm7rAQAfQt+Hm100gJGxopITj09J2QiY9OsfHAemgdMNQJHc+Rr+eH
	 I9D+FwFd83gZbedVHaAlhp6KAMjJFmBNw3egapIHrjbSrp+b8vORYREl2X9uXWiF8o4fd
	 642u0EeeEom+VHbrHRP/EW75gN7TXyyvU4V0yvw3lo6gcZXLnT16YfHbCmsYdoy/Wew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=urvRmNZF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C38BF606EE9B;
	Sat,  7 Nov 2026 14:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=urvRmNZF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72E3B1F008A3;
	Sat,  7 Nov 2026 14:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063458;
	bh=UGvHhFboszppVhJYHHEe6qaRK8Rj2XbNeMySqZyOuls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=urvRmNZF1xBx98HmSMwPBX3ArYs1BX3k58pwH5fzVKt0P6LFI/ywTR3o1b5m+Sqm1
	 w1d83VvFQJPp18BzmCOnVHP+Qgqg/O4v/G8azn7oQLVB1uHBxB2P32+UTj7LIuVWa1
	 K0qnYNmBMPX76m3ylLnqeg0XGmebzvu6iTiMA3mw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	"Harry Yoo (Meta)" <harry@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 615/869] ipc, msg: Account msg_msg allocations with GFP_KERNEL_ACCOUNT again
Date: Sat,  7 Nov 2026 08:54:57 -0500
Message-ID: <20261107134913.907510167@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 7a03f6d03de3a..2b93abb808e7b 100644
--- a/ipc/msgutil.c
+++ b/ipc/msgutil.c
@@ -63,7 +63,8 @@ static struct msg_msg *alloc_msg(size_t len)
 	size_t alen;
 
 	alen = min(len, DATALEN_MSG);
-	msg = kmem_buckets_alloc(msg_buckets, sizeof(*msg) + alen, GFP_KERNEL);
+	msg = kmem_buckets_alloc(msg_buckets, sizeof(*msg) + alen,
+				 GFP_KERNEL_ACCOUNT);
 	if (msg == NULL)
 		return NULL;
 
-- 
2.53.0



