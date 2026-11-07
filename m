Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061121;
	b=ZN/EYcStQRhBNtgFTCbG9eqVhT24w7QFxO60uhZgLrABXmcw6Mk/BhYXEeknjciQ/fUB
	 32OZMETmWUmOj0fj804GkZtUCHehIW6xA0JOJKuhKZijc0uKx4cb/XQ8C+ssyC7lGaLOv
	 0ejXGimRevb8WIezPjwr2oQYQjjI7fXx3jO5HUj1CpqHEVyPO/3XCh8GNW3ZNy5tw2wkg
	 4PDCO/3H1gEgJ6e36UyXc97xrZcICgZkB1LLWzyYr/M4z4ZB45+iJr24gbZtZ2Y1ePxP4
	 Ctj5quwCsSNA/AH+0Vh8wODSmbifri/j3sYF/bFRs6cZKFbXVi4piE4wT/R1WKxcdfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061121;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QSPXltMvGFdPYXovWci5KAvoEf/LyQSyLsUiWYAVv1k=;
	b=SNRZNBThusQKvmfDYkyAdkHf3u7NbwfazGvR9D4CFa3UH20+rvMYKHBADZcuU+bsd48Z
	 bw1+nC9s0lMft/kXBFQWolwlCfuR4XjcqasGOZ168hisf5bEpKjmYiSiACpZK6Gq1VkkT
	 ZjZ2CpWiROxbzgcFi2Mzx3oE+XK6NQUm5szEym5XeXl523aS+TW0l5h4HsSTF1fAbAmMm
	 p2btr3g+SuS9GLVcsTimYEFnmopWDQGRbUalEDUfLoL0fGlJ/9NuuM4Ex/7y0d61WBDZO
	 jWAFFJ8klm4vrHECgq9LLPepirGclP+RvGxHRKdKQX6uKLe27e6n4F/78NJNjZTzIIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ujOIlPUt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61DE9606A332;
	Sat,  7 Nov 2026 14:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ujOIlPUt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 090AA1F0089F;
	Sat,  7 Nov 2026 14:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061121;
	bh=QSPXltMvGFdPYXovWci5KAvoEf/LyQSyLsUiWYAVv1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ujOIlPUtYeCi1/MxFsJXG+WiykIcOvFwLrmF0bUKVIuI3P+joV7iePOL6tL0+gM+N
	 NsqekbIyKXKR3kzp5ZjaPWXNMBv3/wrDnCJdXGSBlhNAJmOCy7zQaT9ILugDtb0JDH
	 0US41tMldfqNHyZtpqAAN/lIUAomBw5g3QOGSwWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	co+25860fb17af97289@bugs.sh,
	Xiang Mei <xmei5@asu.edu>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.12 0435/1536] libceph: bound mon_command ack decode to front len
Date: Sat,  7 Nov 2026 08:40:51 -0500
Message-ID: <20261107135009.777543398@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiang Mei <xmei5@asu.edu>

commit 62b41a16d8603d4d809fda212f15c3e9c783a82b upstream.

handle_command_ack() bounds the decode with msg->front_alloc_len, the size
of the reply buffer, instead of msg->front.iov_len, the number of bytes the
monitor sent.  mon_alloc_msg() routes every CEPH_MSG_MON_COMMAND_ACK to
get_generic_reply(), which returns the preallocated ->reply of whichever
generic request carries the same tid, so the buffer keeps its fixed size
however short the reply is.  An ack with hdr.front_len below sizeof(struct
ceph_mon_request_header) + sizeof(u32), including 0, still passes
ceph_decode_need(), and ceph_decode_32() returns four bytes that were never
received: uninitialized slab memory, stale bytes of an earlier message, or
bytes the peer planted by sending a reply that lands in the same buffer and
is then rejected.  The read stays within the allocation, so KASAN does not
flag it.

req->result reaches userspace through ceph_monc_do_statfs(),
ceph_monc_get_version() and ceph_monc_blocklist_add(); rbd hands it back
from write() on /sys/bus/rbd/add_single_major, and rbd_get_client() passes
it to ERR_PTR() unchecked, which faults:

  rbd: failed to get latest osdmap: -186318427
  BUG: unable to handle page fault for address: fffffbfffe9ca034
  Oops: Oops: 0000 [#1] SMP KASAN NOPTI
  RIP: 0010:do_rbd_add (drivers/block/rbd.c:7105)
  Call Trace:
   ...
   kernfs_fop_write_iter (fs/kernfs/file.c:345)
   vfs_write (fs/read_write.c:595 fs/read_write.c:687)
   ksys_write (fs/read_write.c:739)
   do_syscall_64 (arch/x86/entry/syscall_64.c:61 arch/x86/entry/syscall_64.c:84)
   entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)
  Kernel panic - not syncing: Fatal exception

Use msg->front.iov_len, matching handle_subscribe_ack(),
handle_statfs_reply(), handle_get_version_reply() and handle_auth_reply().
A well-formed ack has front.iov_len >= 22 and is unaffected; a short one
takes the existing bad: path.  This applies commit d3c32939fa0e ("libceph:
bound get_version reply decode to front len") to the last decode-side
use of front_alloc_len in this file.

Cc: stable@vger.kernel.org
Fixes: 6305a3b41515 ("libceph: support for blacklisting clients")
Reported-by: co+25860fb17af97289@bugs.sh
Assisted-by: Cursor
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/mon_client.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ceph/mon_client.c
+++ b/net/ceph/mon_client.c
@@ -943,7 +943,7 @@ static void handle_command_ack(struct ce
 {
 	struct ceph_mon_generic_request *req;
 	void *p = msg->front.iov_base;
-	void *const end = p + msg->front_alloc_len;
+	void *const end = p + msg->front.iov_len;
 	u64 tid = le64_to_cpu(msg->hdr.tid);
 
 	dout("%s msg %p tid %llu\n", __func__, msg, tid);


