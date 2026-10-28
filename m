Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214187;
	b=UL0SG2KqUSifz6ksT+zs7wqdl15FZwcp1tWYC24rXzQAytgq3lSmHoZuhLxGdt67LCll
	 srfgDk9fLDiJeehSA7gGa7nE7ampCRFEStjhFMeyB9cOW8HE2Eod2qHMzibmxZn6geVbO
	 6mhQ9BbM7pHkKLvigH0qdR4Kkcok0GKvjeALszKBOo64e/vuM2F/5fiGJOYDEpHNPrD3N
	 /eEwpWkd+HjlSkw880TG8yhj+x9DFO4x6ozKwz1fGTKnZrOcQRRlaQALwS+/h5wk+yj0k
	 qNcTZdW129SFCO+aq+seLbPi2nrbGJyfTigmbhEsMoayhU/56txatQdKV1QrUF4grIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214187;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=REueg69Tnk3HHptEc9FebJsaKUAnMBVu0svMV0Jfex8=;
	b=WI4k4XGut5KLHqBYpxxVeUKc2IabUGCahQaKQJifbYqGnkByeujiEzW2n91uyWxQkGFH
	 T8w4BjIP8aXkcs+5mN7pbRS/91HCmnljipanrQbIWxBHCC4v9KTZUYFm1f15edSwVvwMC
	 3P/ZdshMFq2uHXJOT7c2M/k9aywDUcy+fkLrQBTVP/6fNRhAAdaGwmXwFn2mWPtKCkl/N
	 omioI3aTFNFN/otvZcMcmhDHM7rQ1BqhzIxJjMkFbMwzBTFJy1lXt/mHXxypbneAbKlq+
	 IY27xr8/n+uut6s1u4C7OE984SzoQVzBAkuJFxTKMNo/Xua7baJcgXbSI1rpduzjlag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KPIHUTq1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DAAD60A3806;
	Wed, 28 Oct 2026 19:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KPIHUTq1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 868CB1F01828;
	Wed, 28 Oct 2026 19:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214187;
	bh=REueg69Tnk3HHptEc9FebJsaKUAnMBVu0svMV0Jfex8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KPIHUTq1psHLquYRa/VbxMCMgpqlYRkKHp37aJUBRtEjTWUHZkh6y/5vG6DlSOcun
	 DHPv/vynHvfhoLrrqpX5ZjXkhDE/hq4RtrzxvaUYGqK5PR7Cuj/JxxZEs/izfpckpU
	 BMuzmGL+EVLa0Dn0erZUOaFSS9FreRdyAOzDYPbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vlad Poenaru <thevlad@meta.com>,
	Yonghong Song <yonghong.song@linux.dev>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0771/1887] bpf: Fix kmemleak warning for percpu hashmap
Date: Wed, 28 Oct 2026 17:47:47 +0100
Message-ID: <20261028170516.985143055@linuxfoundation.org>
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

From: Yonghong Song <yonghong.song@linux.dev>

[ Upstream commit 11ba7ce076e5903e7bdc1fd1498979c331b3c286 ]

Vlad Poenaru reported the following kmemleak issue:

  unreferenced object 0x606fd7c44ac8 (size 32):
    backtrace (crc 0):
      pcpu_alloc_noprof+0x730/0xeb0
      bpf_map_alloc_percpu+0x69/0xc0
      prealloc_init+0x9d/0x1b0
      htab_map_alloc+0x363/0x510
      map_create+0x215/0x3a0
      __sys_bpf+0x16b/0x3e0
      __x64_sys_bpf+0x18/0x20
      do_syscall_64+0x7b/0x150
      entry_SYSCALL_64_after_hwframe+0x4b/0x53

Further investigation shows the reason is due to not 8-byte aligned
store of percpu pointer in htab_elem_set_ptr():
  *(void __percpu **)(l->key + key_size) = pptr;

Note that the whole htab_elem alignment is 8 (for x86_64). If the key_size
is 4, that means pptr is stored in a location which is 4 byte aligned but
not 8 byte aligned. In mm/kmemleak.c, scan_block() scans the memory based
on 8 byte stride, so it won't detect above pptr, hence reporting the memory
leak.

In htab_map_alloc(), we already have

        htab->elem_size = sizeof(struct htab_elem) +
                          round_up(htab->map.key_size, 8);
        if (percpu)
                htab->elem_size += sizeof(void *);
        else
                htab->elem_size += round_up(htab->map.value_size, 8);

So storing pptr with 8-byte alignment won't cause any problem and can fix
kmemleak too.

The issue can be reproduced with bpf selftest as well:
  1. Enable CONFIG_DEBUG_KMEMLEAK config
  2. Add a getchar() before skel destroy in test_hash_map() in prog_tests/for_each.c.
     The purpose is to keep map available so kmemleak can be detected.
  3. run './test_progs -t for_each/hash_map &' and a kmemleak should be reported.

Reported-by: Vlad Poenaru <thevlad@meta.com>
Signed-off-by: Yonghong Song <yonghong.song@linux.dev>
Acked-by: Martin KaFai Lau <martin.lau@kernel.org>
Link: https://lore.kernel.org/r/20250224175514.2207227-1-yonghong.song@linux.dev
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/hashtab.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 56d2879c64699..36c44451b0911 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -197,12 +197,12 @@ static bool htab_is_percpu(const struct bpf_htab *htab)
 static inline void htab_elem_set_ptr(struct htab_elem *l, u32 key_size,
 				     void __percpu *pptr)
 {
-	*(void __percpu **)(l->key + key_size) = pptr;
+	*(void __percpu **)(l->key + roundup(key_size, 8)) = pptr;
 }
 
 static inline void __percpu *htab_elem_get_ptr(struct htab_elem *l, u32 key_size)
 {
-	return *(void __percpu **)(l->key + key_size);
+	return *(void __percpu **)(l->key + roundup(key_size, 8));
 }
 
 static void *fd_htab_map_get_ptr(const struct bpf_map *map, struct htab_elem *l)
-- 
2.53.0



