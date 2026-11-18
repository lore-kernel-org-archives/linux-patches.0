Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057660;
	b=jTdZsXHpH4fwmoXaaF+NIK5eFyuKcNRYOMnarKN+bDHHiWkI+i72m6EatPZDuLcnxDaW
	 pw7UAFzORVDGpFYMXYf1Fe4ky0l5POe6x4VUUDbUwgRJ4ydeGrKskEQayx8pgP6MzJv+m
	 w5Z5P7K8F8NUsN77DjkeN6wObQaEsyqq7YNrP+WA9plo0qkeOfMS0G5HnU0lH9XjT8u9s
	 jl0KCFe0bNbUsCFFI2gAUcWkp2TgM20lvHwkDxtIYjeuktLppe8Q+avP30fp1wIJsjmVD
	 8nthMDaKhO2RoK7ola3YkZkeGavKgk4wEb6xzV8G679qOG/yL4en6qsl75kY5plkuIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057660;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=mPVen6BQM8coRzUAJS0A2tdWyFyRfZzYJu8Z6voixuo=;
	b=LxXvc9OFV3zvWe7iYf+Gj/Ys1RpE94yhzKOW3gAKmaIsLqwowrULmkcknziOtx/2kEjx
	 0iXrd15B/FTkXmwsQDuONXWN/Kg374lViLxasSSCfswyQs5Iqv5JpgPfLSOG6JZzHxrtK
	 7hojVUJPqYI8H54WkD3Y7Saqm06ua/s6qT/agPZ+DZ+KgyvbvHap0HmB0lH2WlC3GkIpB
	 DKKzAGIx69eCvALf70ZOOlds4bBwrEbTqZ19s/OFXcxj7GHtJ8Op5yt2RqcexdMgZoRqW
	 49Zq8tCt1er6CC12JdRNQXLu06mpvQ7ZdrKFK31KwnyQ/JNtMURa/SSkA73GEwiFnQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oRQ5mB5W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B230D60A2600;
	Thu, 19 Nov 2026 03:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oRQ5mB5W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 142F71F000C4;
	Thu, 19 Nov 2026 03:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057660;
	bh=mPVen6BQM8coRzUAJS0A2tdWyFyRfZzYJu8Z6voixuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oRQ5mB5WAwrqIcT5APjeesEuEULv4JrZkaOn/Rtz1j0gO1SBSIsclWGykv5NKuMf6
	 kACGG3Ic4MdH8MHZcL+czb04EENhklqlawwCWvjqAe+kMgLJFGIYWUgXESs0Q8T0G+
	 n3PA7bzmUl77g9MBAt1x4owBmYtVkeVEcIaemo1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuanfu Xie <yuanfuxie@stu.pku.edu.cn>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 5.10 0208/1848] ceph: fail readdir when the MDS reply carries no dirfrag
Date: Wed, 18 Nov 2026 15:37:26 +0100
Message-ID: <20261118145920.751410653@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuanfu Xie <yuanfuxie@stu.pku.edu.cn>

commit 728c856d7da04fb79f7aa00e974ffb6f55e55995 upstream.

A ceph mount oopses in ceph_readdir() when the MDS answers a READDIR
request with a reply whose extra blob is empty.  parse_reply_info()
skips reply blobs whose length is zero, so parse_reply_info_readdir()
never runs, r_reply_info.dir_dir stays NULL, and the reply still
parses as successful.  ceph_mdsc_do_request() returns 0 and
ceph_readdir() then reads rinfo->dir_dir->frag with no NULL check:

	/* extra */
	ceph_decode_32_safe(&p, end, len, bad);
	if (len > 0) {
		...
		err = parse_reply_info_extra(&p, p + len, req, features, s);
		...
	}

The oops on v7.3.0-rc4-00537-ga3ff15db6820, one getdents64(2) on the
mount root after an ms_mode=legacy mount, trimmed:

BUG: KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
Oops: general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] SMP KASAN NOPTI
CPU: 1 UID: 0 PID: 266 Comm: ls Tainted: G                 N  7.3.0-rc4-00537-ga3ff15db6820 #1 PREEMPT(lazy)
RIP: 0010:ceph_readdir+0xbff/0x3ea0
Call Trace:
 <TASK>
 ? __pfx_ceph_readdir+0x10/0x10
 wrap_directory_iterator+0xa2/0xe0
 iterate_dir+0x1da/0x5d0
 __x64_sys_getdents64+0x13b/0x2a0
 do_syscall_64+0xdd/0x4a0
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
 </TASK>

The unconditional frag read came in with 81c6aea5275ea ("ceph: handle
frag mismatch between readdir request and reply"), so the bug is old.

Treat a reply with no dirfrag as a protocol violation: warn once,
drop the request and return -EIO, the same way ceph_readdir() already
handles the two malformed-reply cases later in the function.

Tested on v7.3.0-rc4-00537-ga3ff15db6820 (KASAN).  Unpatched, the
getdents64(2) above takes the machine down (oops=panic) on the first
READDIR reply.  With the patch it warns once and getdents64(2)
returns -EIO, no oops, no hang.  A conformant reply for an empty
directory — dirfrag present, zero entries, FRAG_END|FRAG_COMPLETE —
still lists "." and ".." and returns EOF on both kernels, so normal
readdir behavior is unchanged.  The oops is still present in
v7.3-rc5 (72d3fcf802c45).

Cc: stable@vger.kernel.org
Fixes: 81c6aea5275ea ("ceph: handle frag mismatch between readdir request and reply")
Signed-off-by: Yuanfu Xie <yuanfuxie@stu.pku.edu.cn>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/dir.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -436,6 +436,10 @@ more:
 		     (int)req->r_reply_info.hash_order);
 
 		rinfo = &req->r_reply_info;
+		if (WARN_ON_ONCE(!rinfo->dir_dir)) {
+			ceph_mdsc_put_request(req);
+			return -EIO;
+		}
 		if (le32_to_cpu(rinfo->dir_dir->frag) != frag) {
 			frag = le32_to_cpu(rinfo->dir_dir->frag);
 			if (!rinfo->hash_order) {


