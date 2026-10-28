Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215198;
	b=UqjNfI//hsdAqGWMBl8TbZ2ehWZciuvb3bXvusa4lrNpvp8H0CfwRTu/2JuoC5VxE6b4
	 b3cCqENxHIUWTtnKyk6G+2xoAoSWeDRf8PJ13n46fe3YpoZtNcTgTUq74OGmEVOLAQnxj
	 GBJ1MbaOTIbQ5jCxU49EIzT7zg8/+BjVm1gco1zmU5sIQVXbK82I7P9OnSBdUxgceMcOx
	 VWG0vsvuYXQoYRx6LdcIqkyI3aA+5aQu84y97cfT0ovxy7b8JNs5RRYzxuNbDnseC+h2p
	 X7NcByCcaV1NhsKSkT7wS0z9xWKbGhOUjno9XGU33aq5ToThfI+yj/HXn4YE+N+Gpnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215198;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dUyN+pkxGw3dxM3r0wDwOtdSp3QC+/sbSsCb0hofIW8=;
	b=xHNK/1XQU9yGGWy8W3J7IgcDnO4a3oY5B9/pzn2/99Av/FZgbodPwwbtMoRWjcfUtVs9
	 bdzZOe7Iw6PHh2HGZGgZL8tPTVzWxJYGKPExAY4YXGTO3tgAjg+fvBJ8oYsjhUlQnzVvw
	 zMKEkYlVRNX7rKqlBwLbliq/cCDZkjEY+uxrk7TBEJs0jcbPU0aqAEPcaXepM4cXZpaJG
	 P3Y7tTJ3aS0ob9FgWrqfb0F+UosDQlrYaccj9B7d5IhkkFomtrAJoRa++NhaSHWW0/GZs
	 PSbS04VaAZ2h8p2kbKRG0qfPLbNePsZS2hCQ+MmnbSy4+Oku+SlXXOuP+KYsShpRKgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W7JM9Kxh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A35606A31A;
	Wed, 28 Oct 2026 19:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W7JM9Kxh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C37881F01825;
	Wed, 28 Oct 2026 19:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215198;
	bh=dUyN+pkxGw3dxM3r0wDwOtdSp3QC+/sbSsCb0hofIW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W7JM9Kxh3OWxwC9Wcj6SDh/eCYEjN0KRjSpMqp8LaRIoeMEtQYiU4c2Hr3W4YFsss
	 qqu2TmfcPLNOygkNfr+k6E5s9rwyfIPo6YbCEtUR71zxHJDoah/CQo/7PuXXNja15N
	 BPWQT5zmNywbNQmHwG90H6GcKW4wkJKHhOT/nIOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyungjung Joo <jhj140711@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1090/1887] fs/mbcache: cancel shrink work before destroying the cache
Date: Wed, 28 Oct 2026 17:53:06 +0100
Message-ID: <20261028170524.210306878@linuxfoundation.org>
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

From: HyungJung Joo <jhj140711@gmail.com>

[ Upstream commit d227786ab1119669df4dc333a61510c52047cce4 ]

mb_cache_destroy() calls shrinker_free() and then frees all cache
entries and the cache itself, but it does not cancel the pending
c_shrink_work work item first.

If mb_cache_entry_create() schedules c_shrink_work via schedule_work()
and the work item is still pending or running when mb_cache_destroy()
runs, mb_cache_shrink_worker() will access the cache after its memory
has been freed, causing a use-after-free.

This is only reachable by a privileged user (root or CAP_SYS_ADMIN)
who can trigger the last put of a mounted ext2/ext4/ocfs2 filesystem.

Cancel the work item with cancel_work_sync() before calling
shrinker_free(), ensuring the worker has finished and will not be
rescheduled before the cache is torn down.

Fixes: c2f3140fe2ec ("mbcache2: limit cache size")
Signed-off-by: Hyungjung Joo <jhj140711@gmail.com>
Link: https://patch.msgid.link/20260317054556.1821600-1-jhj140711@gmail.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/mbcache.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/mbcache.c b/fs/mbcache.c
index 2a4b8b549e934..637e307446135 100644
--- a/fs/mbcache.c
+++ b/fs/mbcache.c
@@ -406,6 +406,7 @@ void mb_cache_destroy(struct mb_cache *cache)
 {
 	struct mb_cache_entry *entry, *next;
 
+	cancel_work_sync(&cache->c_shrink_work);
 	unregister_shrinker(&cache->c_shrink);
 
 	/*
-- 
2.53.0



