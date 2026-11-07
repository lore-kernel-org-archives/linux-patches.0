Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063705;
	b=nIIMMFDZoj2uoTpwq5GMfzSrv6YmG3w6Q5ulh7AwzE8hzA4BZC0odmC3vMoJNRRDf5Am
	 WqeCsb1fNpsGfJTOme96u95tKOd4eksDKQfYtj8qqALUnlww6WFZ0bxnA9EhpORbPSZNI
	 fDEQn/uyfWXF8tUZo81KCjhNs1pSC5o5zf9Jikp5YmZYORh+qI9+HRO0rXy+oR2xGjMZA
	 sgg5JxcysWtdMxUsWt4EkBaoiEKK6KFSb++55zIdhXyHKTjigkCXq6V8AoeGQ9QHDyt+d
	 /JiXN/tGfAFf+G8LK1gkOeX7YvDv3RLXNWvvjgKT37uSEm9AvXGwjclms8UE7mOz/8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063705;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oZLyO9gCOQ6DhtA3n/s5UYHJTX7rxrowatAWxn6cY5k=;
	b=u18rDGDb7Xd89CvxmGXBXA0MibhGrxzZWhKdKAB40YkDQOnZvaXJ0DIXhH1NOyeKVkiz
	 htY8HUG/qQwtJcEn+P+Z3YHdw4wLwAkS8Hprpf8YwtoDTVxDExwskao+Jh28qyPLgIKkh
	 rM4RCvXyxFM1SqyQz188l6/kd2Ff8t0ADG0dz4EwRMTTHI9Aj0Otp/6VBUE55vZMUnB4u
	 ju9MKV26LU2VCwe+VU+MgRzO9Xk30tlx95TpAgbZASioWH2n7RJat8HuhIsIVsKoyl7y6
	 6JoVoKlZdlXNJCiJCJJRVyWio06lkrmhzMZ65I7w4LeTGztIqB+wm7eRhi4DQy3ZYRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TWhH1IOw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84931606B8AF;
	Sat,  7 Nov 2026 15:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TWhH1IOw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3376B1F0089F;
	Sat,  7 Nov 2026 15:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063705;
	bh=oZLyO9gCOQ6DhtA3n/s5UYHJTX7rxrowatAWxn6cY5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TWhH1IOwlo0CYAmWeu4eq0AWr/HZvhUXgc2lpJrMDEEudlPfhhry93c5fiTIVvTtH
	 vr/81+RHknXhy7iOxBZko1MdLOvq1QNKdVGPOE+zBdojbiqeuv22V5C8E/fNRj8Thu
	 lvULm5xt7u5AjQ6Bb00fgyca2uzVvSfoc2nY1MC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	co+f92fbe44e3c6df69@bugs.sh,
	Xiang Mei <xmei5@asu.edu>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 769/869] ceph: require the dentry lease record to cover struct ceph_mds_reply_lease
Date: Sat,  7 Nov 2026 08:57:31 -0500
Message-ID: <20261107134918.793119684@linuxfoundation.org>
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

From: Xiang Mei <xmei5@asu.edu>

[ Upstream commit 7286b2ffe04d4b39b4e9884f714792589d94f316 ]

parse_reply_info_lease() reads a 32-bit struct_len off the wire and only
checks that many bytes are present, without requiring struct_len to cover
sizeof(struct ceph_mds_reply_lease) (10 bytes).  A malicious MDS can
declare a shorter record and still get the pointer published: the
following *p += sizeof(**lease) overshoot is undone by *p = lend, so
nothing downstream rejects the reply.  ceph_fill_trace() ->
update_dentry_lease() then reads 10 bytes through that pointer on any
lookup on a mounted CephFS, running past the end of the message front.

Require the record to cover the structure, matching the sibling
parse_reply_info_dir().  A conforming MDS always encodes the full 10
bytes.

  BUG: KASAN: slab-out-of-bounds in __update_dentry_lease.constprop.0 (fs/ceph/inode.c:1459)
  Read of size 4 at addr ffff888026c63d65 by task kworker/0:3/2366
  Workqueue: ceph-msgr ceph_con_workfn
  Call Trace:
   __update_dentry_lease.constprop.0 (fs/ceph/inode.c:1459)
   ceph_fill_trace (fs/ceph/inode.c:1474 fs/ceph/inode.c:1823)
   mds_dispatch (fs/ceph/mds_client.c:4229 fs/ceph/mds_client.c:7225)
   ceph_con_process_message (net/ceph/messenger.c:1424)
   ceph_con_v1_try_read (net/ceph/messenger_v1.c:1430)
   ceph_con_workfn (net/ceph/messenger.c:1576)
   process_one_work (kernel/workqueue.c:3396)
   worker_thread (kernel/workqueue.c:3479 kernel/workqueue.c:3560)
   kthread (kernel/kthread.c:436)
   ret_from_fork (arch/x86/kernel/process.c:158)
   ret_from_fork_asm (arch/x86/entry/entry_64.S:245)

  The buggy address is located 357 bytes inside of
   allocated 360-byte region [ffff888026c63c00, ffff888026c63d68)

Cc: stable@vger.kernel.org
Fixes: 4ac4c23eaa38 ("ceph: decode alternate_name in lease info")
Reported-by: co+f92fbe44e3c6df69@bugs.sh
Assisted-by: LLM
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/mds_client.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 342d8778b69cf..a5bc9f75e0f9c 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -338,6 +338,8 @@ static int parse_reply_info_lease(void **p, void *end,
 
 	lend = *p + struct_len;
 	ceph_decode_need(p, end, struct_len, bad);
+	if (struct_len < sizeof(**lease))
+		goto bad;
 	*lease = *p;
 	*p += sizeof(**lease);
 
-- 
2.53.0



