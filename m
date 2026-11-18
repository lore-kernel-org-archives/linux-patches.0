Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051629;
	b=BUHqBL7FTjnLaqXWbXLYKTThb6VkC8D0nqtcjMrKiK51AU32/8t8jllPmRtp6PekEteC
	 RsV3e7KyPTWxDTaN0wb7vjEJvRc6xDvvFSg5G5bfrvx02MDhz9iwoKZXXSriAt+1GFtyr
	 MtfjMybc9zqTvoYEV6tpSKyNJh5sIEQpQy2pMPBS5bLXB9jGC02Xh0MgVLVXwkfqstlLq
	 zH3BJEQrtW8N6apUnxLXlkMJYuyd3afAnu1/FIARtSthpxn/pVuqxot/sMaOjmrce23fl
	 lxbmOx5HJkhZigDq8pxSFc4s/FpCdva2df0910ESz1Ye3RcR3fVR3E5Gg6mVK0fVpsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051629;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qAw1A5xhX42Ds3BoalS99oJRcsh+E4wf38RUqecPwIE=;
	b=m5komlSP3oeJqwyPiU9z91mPVhfJZqDWiWrWm5uYDZFVIVQk/mmN1zkp1qPxwklTIGOR
	 xM7Oebd5HAocP2uu+I1b7d9J4OKmmcpXd/p4ULAENnHBtOCdOgCOR/KIfTFa+/Tp3ibDo
	 ovqKU3l6DDPHJHIfMTDPuGhWpnfhuVdOdlWATxgcvNBOzkuSrz1qSLQdZkO4z7C4kwBru
	 oRmZ9vF6V63cZRUrr+jPfgCWd9dwDw4ZtkVmSCzi1XKqYe+sDe7AilNDr7XkGWsKfYetJ
	 FTqVs0nWkQD5KMUbclJ0eTPAgmJ++BLSif43RWIYOXXioek2+paidzEiooDwL0i2C1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bo2LSXWK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8875660A2607;
	Thu, 19 Nov 2026 01:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bo2LSXWK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B80FB1F000C4;
	Thu, 19 Nov 2026 01:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051629;
	bh=qAw1A5xhX42Ds3BoalS99oJRcsh+E4wf38RUqecPwIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bo2LSXWKNHVzYY0FjNTIJB5SVCQWtyNoJIAn3Vhe5JJ5IXd5KmXL3r7wEwx1fj07e
	 auYJSD8OcAfOvlGQVjK4oHDj5jCTRbhAR75CCwyPgoDMzcLsbDqb1GfauMRm+OKp7/
	 VAF0wB8FUa28LXLCdF35GmyZhQEHTb7DU16+TZQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	co+25860fb17af97289@bugs.sh,
	Xiang Mei <xmei5@asu.edu>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 5.15 0259/2214] libceph: bound mon_command ack decode to front len
Date: Wed, 18 Nov 2026 15:32:15 +0100
Message-ID: <20261118150020.483290197@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


