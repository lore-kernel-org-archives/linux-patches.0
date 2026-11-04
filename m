Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826906;
	b=SgSVl5LYU8Gu+XK9kKvfeTVIRShKWwq3+VRyq4+6HU2T/nm4i/+K86lJ9tMWJDYilB9P
	 slxFfwLC0viF9GH6vjXUJ1Z8cDA88bsFjek3TmfzRd43wPkMpB82oDuqOS7aZ9rdwGu2K
	 H0Uau15Iez6hvjXGKIhEVBPwsCbKcEDVIV92fxZIbAdcEkAJVG3iT4ACfs9Y1j3oO6rxD
	 PfyaJ1nyXNxtd9KbadRIcnMGAfVWh3mEFqVkL+0yrKZa+KuLWrB8xhFdfrE7s7IvMrF/r
	 peKRqX9fIfxUlQcz1fLf/oNa3lwr7xcpCD613CW8lsg6CYZOQZAbjo2UPBp9fovNgnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826906;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ooZ17kqiFWZ1BQE4a5UYZgZ4uNq93f+nV+p1GxI9Q+c=;
	b=URZOxFGFqfc+nxdup4izeCWZoZeTW5iUw1zdwECFlEfZ1IQeP8qF90tirooNWKIDm3TP
	 TKM0deeEBHH5+EAHah3p0lZF8SrwVgxGTBHpRR5bS/Iifc2lYuwphfVyFafnhtsYD8vT3
	 dtHhYivItlTsht/99juEirRNQWCVLxFCVj6I7FdfbBEo2bfYGqRk+hoYPShGaX4R+RWuO
	 jQhIEWjPYk6pLYfH5qaFW2z5tkHoQNGWBlSt37D1uIa0GpT5KoA9RRXxfKBtxLyFL/ZqM
	 8dd/QiI69fFn0ltmLV7KzmRpfSvAva3tG77pIsIMFnna3+nupPkCSj/tsXqjJ6gnDgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KDDx3SAK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66BA76070777;
	Wed,  4 Nov 2026 21:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KDDx3SAK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06FE31F000C1;
	Wed,  4 Nov 2026 21:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826906;
	bh=ooZ17kqiFWZ1BQE4a5UYZgZ4uNq93f+nV+p1GxI9Q+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KDDx3SAK8i5ifubq7isLl+qkfNmtczzvsrKbXG28u9q2IeHFGHbIWEwfhhdnEKw3d
	 LgIwYRIS2d5gV1+sHqU1ys5BaKOj1+zjFi5Gg5ISM4UzdxMupKx3mUx098QnVUxiK5
	 +dm57GGSb4eihWILYsFe4YvHewXUfubuLe5eD6HA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	co+25860fb17af97289@bugs.sh,
	Xiang Mei <xmei5@asu.edu>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 7.3 077/547] libceph: bound mon_command ack decode to front len
Date: Wed,  4 Nov 2026 16:04:21 -0500
Message-ID: <20261104211040.444364990@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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


