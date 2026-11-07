Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064756;
	b=Y1getH5vBXrR+ITMOBzNoPrTIi9fQb+4eblPfkh1YMnvA428vDqsD3N+oWKYXnQaa3hv
	 FbJu+5gfsWDesNgH2fIB/Nh3UiVS7ZHFgylEsF6DRQ355Ylr2SdO2tXzKj3ThRjEtZaba
	 YrPq5EYcApn1GG2VCxVp/JLV2u5rpzyM1tsYNdC02J+znWwZNFggusiaShF2dNhD5PLgU
	 J+TDVQqyFaMaFOacb8I7aSeLnY0NzaABFcr6zmjYjMtfcNPnSv0+oMZnpZnzGILYkk2/l
	 q00PcTqp8vJqrCmPE7JEr+Y3LSTIaxg3hp5nbQlUJV+yN8M+s62ndAiR3isYwjiqZxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064756;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fJ7OivK2pnOl39s1BEfTEfIs+zv3Qu5iXVYt2TrKOSQ=;
	b=YYCqKn7xe9GBQSNpUYGj7B7hnTSaq0HebjF4356uXcK1OwegADuuFW83MbZ7GOLKV2V3
	 c0wgte/QwPWX0vhDLOaHn0Tn9Xjp5kHuJpbNQvetcsAWrQ2McWHQxF+hH/kaNF+VDpsgm
	 LeVO6ODjOzUdneapV+ncZVoIBs5kt+UAKhndiUqUoM0aTFYvM5nt4CVpe3HM9EzEHgfsV
	 oeAF6bSFRRcpPzMImhIB7eVJfJGxI/MizXitnk0sp9zVF824tcGwNFn/CO17Rul7X/Bxo
	 ajl+sga0KV1tx+KlTFR8OUN61oCSaS8jtWUJ++BDs6hrTPy2umUarwJjEZTfMM08Yxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0ZEK23j3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7F73606A334;
	Sat,  7 Nov 2026 15:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0ZEK23j3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66C031F0089F;
	Sat,  7 Nov 2026 15:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064755;
	bh=fJ7OivK2pnOl39s1BEfTEfIs+zv3Qu5iXVYt2TrKOSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0ZEK23j3MseIQMK0g+GEU08fnBj9sV6kYVHO5fhK1RkrQAcEmh9RZpIyn6svw+1EQ
	 PQ3A9Yg0BWzDx+qDRWeUlQmssgxqM3g4sxMxIKbBbe2NtUYmOlSsIXP2f/c7j2yfRI
	 e5f/nLbA72JRwT+UYn1RmJFxWyyppc7ejNq4Jlww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0727/1257] f2fs: fix to use bio_in_atomic() in f2fs_read_end_io()
Date: Sat,  7 Nov 2026 08:50:23 -0500
Message-ID: <20261107134959.347796426@linuxfoundation.org>
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

From: Chao Yu <chao@kernel.org>

[ Upstream commit a605d5d71a6d280c43c7ede9778dda63fb5c3f22 ]

f2fs_read_end_io() uses "in_task() && !irqs_disabled()" to decide
whether it is safe to sleep, the result is passed down as @in_task to:
- f2fs_put_dic() -> f2fs_free_dic() -> f2fs_release_decomp_mem()
  -> vm_unmap_ram(), which may sleep.
- f2fs_end_read_compressed_page() -> f2fs_cache_compressed_page()
  -> f2fs_grab_cache() -> f2fs_lock_cache(), which may sleep in
  wait_on_bit_lock().

However, the check still treats below task contexts as sleepable:
- with spinlock held via spin_lock(), i.e. preempt count != 0 while
  irqs are enabled.
- with BH disabled via local_bh_disable().
- inside an RCU read lock on kernels with CONFIG_PREEMPTION.
- with any spinlock held on kernels without CONFIG_PREEMPT_COUNT.

So the "sleeping function called from invalid context" issue fixed by
commit 08a7efc5b02a ("f2fs: vm_unmap_ram() may be called from an
invalid context") can still be triggered.

The block layer provides bio_in_atomic() for exactly this purpose, it
checks rcu_preempt_depth() and preemptible(), and conservatively returns
true if CONFIG_PREEMPT_COUNT is disabled, let's use it instead. The
difference is as below:

 old: intask = in_task() && !irqs_disabled()
 new: intask = !bio_in_atomic()

 Context                              | old intask     | new intask
 -------------------------------------+----------------+----------------
 Hard IRQ / softirq                   | false          | false
 IRQs disabled                        | false          | false
 spin_lock() held, IRQs enabled       | true (wrong)   | false
 BH disabled by local_bh_disable()    | true (wrong)   | false
 RCU read lock (CONFIG_PREEMPTION)    | true (wrong)   | false
 Spinlock held, w/o PREEMPT_COUNT     | true (wrong)   | false

Note that on kernels without CONFIG_PREEMPT_COUNT, bio_in_atomic()
always returns true, so dic freeing will always be offloaded to sbi->wq,
and compressed pages will not be cached in f2fs_read_end_io(); this is
the price of correctness, since there is no way to tell whether the
current context can sleep.

Cc: stable@kernel.org
Fixes: 08a7efc5b02a ("f2fs: vm_unmap_ram() may be called from an invalid context")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/data.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index d8965229e3e7a..cfd81bfc28a22 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -303,7 +303,7 @@ static void f2fs_read_end_io(struct bio *bio)
 {
 	struct f2fs_sb_info *sbi = F2FS_F_SB(bio_first_folio_all(bio));
 	struct bio_post_read_ctx *ctx;
-	bool intask = in_task() && !irqs_disabled();
+	bool intask = !bio_in_atomic();
 
 	iostat_update_and_unbind_ctx(bio);
 	ctx = bio->bi_private;
-- 
2.53.0



