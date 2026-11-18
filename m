Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034412;
	b=0lfu0kYDK3LRBJvPdtbE8W000uJNSczH8hhrhrz30ZMeqieuAVnYMsUWvbjS41Mi9sXP
	 xnA3kUzyNIH19N3KEMu87Yok5DnU5xVXNQlQ4/l+eEPZlv6MXM6lA5tWSWOektM1Tv+lS
	 g+5g9gZKAGaaqDq5Kle4kd2yxyhKfVF1adUb2V223oV3K6AESirzu6PAbqW/51/aRRfrC
	 ZhwBsM44Bz4QwTXizCILnNca/ueHTIunuRpodUP+OaadcrInrCgUWyR/8TlzzFWrv8IHV
	 SwW+zfn3GAtGb+L33N/cyh1oozBQsTOJZ8AowVE7eOzlgpVYkaJsReDbS0sNP5y77Aw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034412;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cyTiz6KaBZm2zz85q20xk6xsceOrY/LZmSuML5Wm5kw=;
	b=flf1/pjFzTJ1Mn10Jfi4OruDm96Sg3kns7pL3EqZOeOVPETMUir8mu23qQh62BdrYx6H
	 OJ+wFCI3Lt3kpSi/10Bo/4FlSKOE6QmuAWG1iDMcYYaM3QkW8YzsDX1TFmVgtov/w0PzV
	 8QNbW9qWR4M2cuMYExOvxTiMwTGzZ0Y00dpUaaUmTb1dfCjbOdp+1JlVGL9ENe440+JUo
	 fIN0MSK6NuGe6lPpDIPCRP9D0iNLS3fdRb2fCV+52iwxOiPBucK7DJBHtyIQw0peOa8nT
	 BMjvPQ7hxxOYxn65UIHHDYt6ovR7OkMJ2wNRPUi6mJlPtExfVR0KTZa6IYMt9Xbxy0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xNWsYIED;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74B72606A31C;
	Wed, 18 Nov 2026 20:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xNWsYIED
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C99921F000C4;
	Wed, 18 Nov 2026 20:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034412;
	bh=cyTiz6KaBZm2zz85q20xk6xsceOrY/LZmSuML5Wm5kw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xNWsYIEDEH9nX28O64avqIe1raeAbSkfDBgYHaBrx89DiZgqd9/Zxs39j39McadVe
	 4h4VyWuCCuYYUXvXeOlDUU5Azp6E8888Q37l0Dwvi0/7yL72kl1A1uku34cQUBq2hP
	 RD0KJEWdvME3VYCmwCQxVO84CcnWq7e8lXhtlGVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	co+25860fb17af97289@bugs.sh,
	Xiang Mei <xmei5@asu.edu>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.6 0359/3318] libceph: bound mon_command ack decode to front len
Date: Wed, 18 Nov 2026 15:16:21 +0100
Message-ID: <20261118150326.894169037@linuxfoundation.org>
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


