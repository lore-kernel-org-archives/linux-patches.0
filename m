Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036937;
	b=yye/KqTWrfmfirdNxeV/a5IIGt1AgJNRo+uBcZNPsuHKeVk69SCzAvfkBrOYGrx5aTmD
	 vOGGGoNB5fIHmzZ6SmUZn82uGQGDiEEdFff701ZLMfECOqWNIZgmNGjKwL/t78PizUFJh
	 pF9QkbQ2oZLQsUWiCzJ5zz6KJo3cm6+ejD+Ho1b/jnvyTjPFZv8hPNzYPkN1BWwT17B3B
	 2lW02fHpEfn7J9RTZOtz+BPWDDg95E5ESnV3Ib56JOHPgxTRHPgD4/4h5gZbQvN7YPa9d
	 soiHRUMH9uQSjTtrESw6NlQiRJKdItPisIOa+4+Kti4HQFhvtX8P95vZcVOiIerVrjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036937;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4nL88seL9WC7vVGjK98/dSQPN4jUcrcdV6x28+/n3p4=;
	b=QabtcjnAVn+L7nXdy2gnQ1bZE/O3H6pSK4hhBZ8yPN7kdyGyHB1F2r+6u8fOgQ4k4fBz
	 n4ZNIIbS4fJ2gfcvwRldhy86CL4vrhiU7IDWDVs38xIVx5Yn4bIUkHUcwVO+0O4WfE6Z8
	 +P+dpzjr1J/ZHLUnkF0HOxGAJFHlXhCeL/YYhgyvm2U3tF4xEJP3rulg/iC20YhceMVOS
	 4W7bBuIr/W2dvjlEEXgGDvyacMFrQVd+pYXCc/0aVbFKVgvntIEGi9vnW3m0Det/e3Y33
	 P+Zp0npk3pCR2RfrR1iLcQ/6r5VCYfB3LZtRHdkZKUfes9dsLjzo5HoNmwIzzeFectg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dSfpq6Ts;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3E1C606A31C;
	Wed, 18 Nov 2026 21:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dSfpq6Ts
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A6D31F000C4;
	Wed, 18 Nov 2026 21:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036937;
	bh=4nL88seL9WC7vVGjK98/dSQPN4jUcrcdV6x28+/n3p4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dSfpq6TskI1fxxbF23DTmWD9Yc5rOxGPC2pxvjAPbXL3C73nDreRti5G7OlaQihDB
	 mKwweONA2nwJHB8KgSmuV2OZYDoqizWKY3fsE7gNZQjhyJa6qZ/ptAQqI320G63C8Z
	 vkJTd9jZMQe6YNwmhc5j3PmLb73XPtIb0EOmjaXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	co+ecaada42f806f629@bugs.sh,
	Xiang Mei <xmei5@asu.edu>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1235/3318] ceph: fix integer overflow in the snap trace bounds check
Date: Wed, 18 Nov 2026 15:30:57 +0100
Message-ID: <20261118150357.243959129@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiang Mei <xmei5@asu.edu>

[ Upstream commit b3bf89767e3ca9506f1c7167cac97c41ec254d42 ]

ceph_update_snap_trace() bounds the two encoded snapid arrays that follow a
struct ceph_mds_snap_realm with sizeof(u64) * (num_snaps +
num_prior_parent_snaps).  Both counts come straight off the wire as __le32,
so the addition is evaluated in unsigned int and wraps before sizeof(u64)
promotes it to size_t: an MDS sending num_snaps = 1 and
num_prior_parent_snaps = 0xffffffff makes the sum zero and the check
degenerates to ceph_decode_need(&p, e, 0, bad), which always passes.
dup_array() then reads num_snaps * 8 bytes past the end of the message
front, which ceph_msg_new2() allocates at exactly front_len bytes.  An
unsolicited CEPH_MSG_CLIENT_SNAP reaches this from a malicious or
compromised MDS with no client-side action, as do the snaptraces carried in
an MDS reply and in a cap import.

Compute the length with size_add()/size_mul() so it saturates at SIZE_MAX
instead of wrapping, in the style fs/ceph/mdsmap.c already uses for
num_export_targets.

  BUG: KASAN: slab-out-of-bounds in dup_array (include/linux/unaligned.h:28 fs/ceph/snap.c:500)
  Read of size 8 at addr ffff8880102a16c8 by task kworker/1:2/129
  Workqueue: ceph-msgr ceph_con_workfn
  Call Trace:
   dump_stack_lvl (lib/dump_stack.c:94 lib/dump_stack.c:120)
   print_report (mm/kasan/report.c:378 mm/kasan/report.c:482)
   kasan_report (mm/kasan/report.c:595)
   dup_array (include/linux/unaligned.h:28 fs/ceph/snap.c:500)
   ceph_update_snap_trace (fs/ceph/snap.c:836)
   ceph_handle_snap (fs/ceph/snap.c:1155)
   mds_dispatch (fs/ceph/mds_client.c:7234)
   ceph_con_process_message (net/ceph/messenger.c:1424)
   ceph_con_v1_try_read (net/ceph/messenger_v1.c:1430)
   ceph_con_workfn (net/ceph/messenger.c:1576)
   process_one_work (kernel/workqueue.c:3396)
   worker_thread (kernel/workqueue.c:3479 kernel/workqueue.c:3560)
   kthread (kernel/kthread.c:436)
   ret_from_fork (arch/x86/kernel/process.c:158)
   ret_from_fork_asm (arch/x86/entry/entry_64.S:245)
  ...
  The buggy address is located 0 bytes to the right of
   allocated 72-byte region [ffff8880102a1680, ffff8880102a16c8)

Cc: stable@vger.kernel.org
Fixes: 963b61eb041e ("ceph: snapshot management")
Reported-by: co+ecaada42f806f629@bugs.sh
Assisted-by: LLM
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/snap.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
index 73c5269547491..148f9ab18d01f 100644
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -788,6 +788,7 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
 	struct ceph_snap_realm *first_realm = NULL;
 	struct ceph_snap_realm *realm_to_rebuild = NULL;
 	struct ceph_client *client = mdsc->fsc->client;
+	size_t snaps_len;
 	int rebuild_snapcs;
 	int err = -ENOMEM;
 	int ret;
@@ -802,8 +803,10 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
 	ceph_decode_need(&p, e, sizeof(*ri), bad);
 	ri = p;
 	p += sizeof(*ri);
-	ceph_decode_need(&p, e, sizeof(u64)*(le32_to_cpu(ri->num_snaps) +
-			    le32_to_cpu(ri->num_prior_parent_snaps)), bad);
+	snaps_len = size_mul(size_add(le32_to_cpu(ri->num_snaps),
+				      le32_to_cpu(ri->num_prior_parent_snaps)),
+			     sizeof(u64));
+	ceph_decode_need(&p, e, snaps_len, bad);
 	snaps = p;
 	p += sizeof(u64) * le32_to_cpu(ri->num_snaps);
 	prior_parent_snaps = p;
-- 
2.53.0



