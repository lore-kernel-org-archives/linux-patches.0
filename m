Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036920;
	b=AByhUnIf1VXsXfcifPWOv6YV35iTgw7cFTMIMRqxROkAcaOm+jOsWfhoN9QQmuJMntfv
	 wL52xQ7woF1gijx47DL/0ZXTk9w1DDO2Uq9Ze9aNoild66K6EOWFYNYEp7PIiOoxok1Ks
	 YoDN6HwzduJ8hIMJKFnXsf6FGmduJrL4gPtxy0TNXvDOWf4sg9lu89c9gu2zrqkJKTew3
	 Y355YPWpXBCxktujtmlpqxcjcGrC6AWrszKeesB8iX9VlZ1OiKPCsf0/SjQT1pdSlj7ig
	 S8OXd0SIESnhsAMX+eLtZpmmcONB5rzkBhyW8z/a9keoZiilZgYvTBN7rR07pmzuQIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036920;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BIZJlenKAUWYnLkIf6IAF0EpDFSPfXLn+wNHiRXweyU=;
	b=EaVqXmM7j1XPnE5O+AHupcCPL9nD4wlD6rY0HeNxrhmc5Oj7VtAobP9OMuT3ywzoV9QM
	 WbqLaVi7n4gVt5fpitqrGdscE48/FwCSRFaa1Gfk+g3fGbKLDVqsi++LqvxaipwkFdk9S
	 aq6f/x1/u3XtRBFMNjjUYOLKTfROjGAX0ICG7qe9EAanWUOiV3yhWwMWTpvXPCApFlA1B
	 UnZXe0YJoyrBJNPaOSpQQ+MpGHOUVVsNaQEXsY68O2Nono+9IEEYMrFuN35Qq3PlVUv++
	 jl0CJ5OdCdDEou/faLGwYv/X8rU+OATQkuqJT8lIAFuPXoO63mzhxjgSDXkQsk7f8rA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M2scKjZy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 750FA606A31C;
	Wed, 18 Nov 2026 21:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M2scKjZy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A6B11F000C4;
	Wed, 18 Nov 2026 21:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036920;
	bh=BIZJlenKAUWYnLkIf6IAF0EpDFSPfXLn+wNHiRXweyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M2scKjZyMOrkDnRUd7AuX9Buemc8W4+TpkHQ0wLokCFT5ZCmBZW+ON0vxAU21dJys
	 ZNKPHP9wFiGbh89HizN5cEmFzSskYZunKX/K6hwwwlzm3Ug0Ww+MYFtPZbLVOIo0mN
	 GZmlG0Yiy/VI3p+yQaq5TVKU7Zg6jddnATZtqyH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	co+f92fbe44e3c6df69@bugs.sh,
	Xiang Mei <xmei5@asu.edu>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1229/3318] ceph: require the dentry lease record to cover struct ceph_mds_reply_lease
Date: Wed, 18 Nov 2026 15:30:51 +0100
Message-ID: <20261118150357.059200983@linuxfoundation.org>
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
index a32f6341fbeb6..20c3e637ba796 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -337,6 +337,8 @@ static int parse_reply_info_lease(void **p, void *end,
 
 	lend = *p + struct_len;
 	ceph_decode_need(p, end, struct_len, bad);
+	if (struct_len < sizeof(**lease))
+		goto bad;
 	*lease = *p;
 	*p += sizeof(**lease);
 
-- 
2.53.0



