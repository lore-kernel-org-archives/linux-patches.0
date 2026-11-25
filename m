Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618682;
	b=aWCJAqQ1FooD1ZdbTAat8Zy6rVdSNmx7PX8G6FPRYOQsnnMVlQ/aMLqXS0aijqjf/t6L
	 n769ZYtmzFFLNkuGqxQfamsrVbtkrG1uWphyl7DlX+WKPsPbXqJ+xLWT6B+Mlsyr/+LVz
	 0CCR9HGHBK0DZW4r5VNZkozVSqnIogX+aPcy1m1UwO4ZbyDuc1SemDWu8VPu5LerW18cS
	 LKJJrHSOkk5O1zom0t0Yk9hG0zcecSR7QC5Yg+6dXLexc9OiVsLiZcrRsv30/CZoihDON
	 90g2TZkFFwACnQzeVmEJrwDVIgUxbzrTxfhejPaETjV4NLQ0fkjRd7CCCsgnIYHS+pA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618682;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lnXW2oGs5LyltAWulZ/avxjRy5wXJksQX+GmqmtIlv4=;
	b=GcSOfcmBaLiGhQE5xQd9Si6mhHy9aeacU04ZP+5n7VExirzt5aH6OQzvpx5Ap07jFlKP
	 f+cMemcX5SGz94Fkc59pPBJ2jmqnXOoAVdGQvvQZp0KK3hMc9nsT6NbuhhfsNqgEpDMpy
	 gOoLhaK9PDlxKi8JGUs/nc2H7Zm5+6Pu02Hc6E19GNEwyHwIS5BUQL39QfkrnX9nu/5k5
	 ruQmGv8EooBnJCWyTE8xZiVRK53Rps9i5WQTnkYFRG5KARW7jrcxX1k8ipJ2IcJvhYchS
	 BaSy4ystTB7X1ExGGJo7f6D6C/7nkitMh320Xl+8wYbRZOoI2memssJpYaiOL3sE20g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=leWkOoYW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C9FB606A321;
	Wed, 25 Nov 2026 14:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=leWkOoYW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3102B1F000CA;
	Wed, 25 Nov 2026 14:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618681;
	bh=lnXW2oGs5LyltAWulZ/avxjRy5wXJksQX+GmqmtIlv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=leWkOoYW8Y0Q4NkCkloWmVy96nIhGtqa/HaNOT6UuRqSUrqEvzjEv8O0b22JRvbkr
	 ieCb8aDLa/8QzyGG2dVLk5jVr70KHAzSjjDZq0FahxULWfS4Bjg2CKwwsjLlQapBb7
	 JNqJkN40jqersI6RbBkdJRbs4QXAUs9avm4wZpj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Laight <david.laight.linux@gmail.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Waiman Long <longman@redhat.com>,
	linux-kernel@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0354/1005] locking/osq: Switch osq_wait_next()/atomic_cmpxchg() ordering
Date: Wed, 25 Nov 2026 15:28:12 +0100
Message-ID: <20261125143830.027616340@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 1b9e01fcc47aff00d2fd64693c5dcd620eff5865 ]

The atomic_cmpxchg() in osq_wait_next() removes the current CPU's node
from the tail of the queue and puts @old_cpu back.

This is very much like an 'unlock', which is RELEASE, rather than
ACQUIRE.

Additionally, on success (the only case where the ordering is
effective), this returns NULL which means both callsites will do nothing
more, there are no subsequent operations to order against.

Furthermore, the osq_lock() caller will then return false, indicating
failure to acquire -- the mutex must go block. Again, not making a case
for ACQUIRE.  Neither atomics nor locks provide ordering on failure.

Since ACQUIRE makes no sense, while RELEASE makes it more symmetric with
osq_unlock(), switch the ordering. This then makes osq_unlock()
consistently RELEASE.

Fixes: c55a6ffa6285 ("locking/osq: Relax atomic semantics")
Suggested-by: David Laight <david.laight.linux@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Waiman Long <longman@redhat.com>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/locking/osq_lock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/locking/osq_lock.c b/kernel/locking/osq_lock.c
index b4233dc2c2b04..98b12d7b79964 100644
--- a/kernel/locking/osq_lock.c
+++ b/kernel/locking/osq_lock.c
@@ -59,7 +59,7 @@ osq_wait_next(struct optimistic_spin_queue *lock,
 
 	for (;;) {
 		if (atomic_read(&lock->tail) == curr &&
-		    atomic_cmpxchg_acquire(&lock->tail, curr, old_cpu) == curr) {
+		    atomic_cmpxchg_release(&lock->tail, curr, old_cpu) == curr) {
 			/*
 			 * We were the last queued, we moved @lock back. @prev
 			 * will now observe @lock and will complete its
-- 
2.53.0



