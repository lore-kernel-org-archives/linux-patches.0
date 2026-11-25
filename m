Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618113;
	b=rNY9wJ34cfOSiMfER7mTHqGgz7S5KVByn7rsvIsZG7lIRbBZYNvSHy58ie8ExszHQC9G
	 sEAVvpGotWG/TdAbquQJkMgolrait4SvXARbZAXAduJCUwh36JUvE+iOquXLVZUuKf1E1
	 Z6NNbPPaVPjAf4pK9kLjztHP2Ew4NkNHGpe9BJYRee7MC82gX5C0N/rGuZqyArbuJBDPS
	 BNyWt9o1Zvs1NHTqgvGvWxMxzDCbM5wnwF/TdoqvGF91dCeVGp+K+suUU5jhjZ4ANx5Fc
	 tbzLDAr/Avzgl122HIW0roOEDN5I8uSD9EeC9qyho2OJIqXU9fmOJS8fmIwMoqP9l/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618113;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=18/ki7LNbCDrsuRMAJOeyPMM2ipi6hh6pIxlnfpQ6P8=;
	b=2buUkEmFYpvYtWHHY09foDZ1uSNkX4nRo5KkLm+9SE4a/uVRspIxkJAqj88MCLcDzc/Y
	 CmYJ2bb6cfDM8JkKSny8SGov69CaE2P/OffB5Jj+FL4xrhJGkcfYydMQ1K+hE0jvws+MO
	 ynX8lsHZt5LjwURRtTxp5HCplUmuSQifBO6fME/P8RMZM5AicnlHVLh9vOhScLxRaXMmh
	 lZFgnMxCbtOF082MtyEeoPbBJYxgBBTZRKWVHcbX5i7INWEX7XSxAvCNXz+Cjepx+mNTQ
	 3zKSC5k4YVRbmMkAzoccNIgiRoPAyfI+3pKe/ptmc4qkLDom2H1cRRdAXANUWyuqrig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="jT/qyZLd";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DABC606A323;
	Wed, 25 Nov 2026 14:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jT/qyZLd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4067D1F000C4;
	Wed, 25 Nov 2026 14:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618112;
	bh=18/ki7LNbCDrsuRMAJOeyPMM2ipi6hh6pIxlnfpQ6P8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jT/qyZLd1oeTSpN9nnlA87K/ZZhaebpVPDnd2DxEHnNF13RNeyUm5ygMgTEZ3Umv2
	 f/MtgamGFqPXzhvVUWHFLPyHQTU/2UcMDm/YUI8F/4oZ5Wq2lG3edjWqdK8GLv3B/N
	 W5lM9UVUBcJJoQ7R/reMHtqC294prtCoJKzwWyds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0177/1005] bpf: Dont move a MAP_FIXED address in arena_get_unmapped_area()
Date: Wed, 25 Nov 2026 15:25:15 +0100
Message-ID: <20261125143825.888368223@linuxfoundation.org>
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

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit 92b5ce3ca5b7c641e2678f92419aa7833951bc9d ]

The user range of an arena must not cross a 4 GiB boundary. Thus
arena_get_unmapped_area() asks the mm for 2 * len bytes and rounds the
result up if necessary. This is correct only if the mm finds a free range.
With MAP_FIXED the mm does no search and returns addr. For
MAP_FIXED_NOREPLACE, do_mmap() also sets MAP_FIXED.

With MAP_FIXED the arena is not at addr after round_up(). Thus mmap()
removes mappings outside the range from addr to addr + len. It keeps a part
of those in this range. Also, round_up() can wrap to address 0, and the
test for address 0 is before it.

The arch code gets twice the length of the mapping. Thus it can refuse a
valid MAP_FIXED range. On s390 the arch code also grows the page table for
the range. With the double length it can omit this step for a valid range.

The test for a crossing is not exact. Because ret is a long, ret >> 32
extends the sign, but the other side is unsigned. The sides are never equal
for an address with bit 63 set, and round_up() always runs. Such user
addresses exist on s390. arena_map_alloc() does the same test with a u64.

With MAP_FIXED, pass len to the mm. Return -EINVAL if the range crosses a
boundary, as for address 0. Make ret unsigned, so that only these ranges
get the error. On x86-64, if round_up() gives address 0 today, mmap() now
fails with -EINVAL or with -ENOMEM from the mm. Today mmap() can also fail
for the address after round_up(), for example with -ENOMEM, -EEXIST, -EPERM
or -EBUSY.

Without MAP_FIXED the mm must still find a free range of 2 * len bytes
inside the address space of the task. The range after round_up() is inside
it, and round_up() cannot wrap. An address with bit 63 set now moves only
if its range crosses a boundary.

For an arena, libbpf uses MAP_FIXED only with map_extra, and
arena_map_alloc() refuses a map_extra range that crosses a boundary. A
subsequent mmap() must use the range of the first mmap(). For mmap() of the
map fd, this range comes from arena_get_unmapped_area(), thus it crosses no
boundary. arena_map_alloc() still accepts a map_extra above TASK_SIZE, and
mmap() of such an arena fails.

Fixes: 317460317a02 ("bpf: Introduce bpf_arena.")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261102064231.2153879-2-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/arena.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/arena.c b/kernel/bpf/arena.c
index 8e1f7bfd2b4f7..5b65ffefbebd6 100644
--- a/kernel/bpf/arena.c
+++ b/kernel/bpf/arena.c
@@ -7,6 +7,7 @@
 #include <linux/irq_work.h>
 #include "linux/filter.h"
 #include <linux/llist.h>
+#include <linux/mman.h>
 #include <linux/btf_ids.h>
 #include <linux/vmalloc.h>
 #include <linux/pagemap.h>
@@ -630,7 +631,7 @@ static unsigned long arena_get_unmapped_area(struct file *filp, unsigned long ad
 {
 	struct bpf_map *map = filp->private_data;
 	struct bpf_arena *arena = container_of(map, struct bpf_arena, map);
-	long ret;
+	unsigned long ret;
 
 	if (pgoff)
 		return -EINVAL;
@@ -647,7 +648,13 @@ static unsigned long arena_get_unmapped_area(struct file *filp, unsigned long ad
 			return -EINVAL;
 	}
 
-	ret = mm_get_unmapped_area(filp, addr, len * 2, 0, flags);
+	/*
+	 * Without MAP_FIXED the mm finds a free range. Ask for twice the
+	 * length, so that there is room for round_up(). With MAP_FIXED the mm
+	 * does no search, and the caller wants this address. Thus the range
+	 * cannot move.
+	 */
+	ret = mm_get_unmapped_area(filp, addr, flags & MAP_FIXED ? len : len * 2, 0, flags);
 	if (IS_ERR_VALUE(ret))
 		return ret;
 	if (!ret)
@@ -655,6 +662,8 @@ static unsigned long arena_get_unmapped_area(struct file *filp, unsigned long ad
 		return -EINVAL;
 	if ((ret >> 32) == ((ret + len - 1) >> 32))
 		return ret;
+	if (flags & MAP_FIXED)
+		return -EINVAL;
 	return round_up(ret, SZ_4G);
 }
 
-- 
2.53.0



