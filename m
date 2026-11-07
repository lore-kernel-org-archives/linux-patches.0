Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061118;
	b=T8pq7CQkpXqQTWzupFsLg0XEXx2pz2lwGDRN6uY+o4e+2TprOEm2SYf/mydVDT4OoIGa
	 gKQCZncEUMUi7jZYTpGIW5cvb+raSsl1pFYKZgN6pDPzX+weno9fCFOBhc/NQEQwIzWfD
	 S6qK4aXtAd6swMwwWXGg0DLVyHJUAE8kJXP6alFKKbTte6RlqLaK98aV/xvRNGtZdVIMq
	 FUHAyCcvsSUVrzd/6ktjC9z3WOCcmROR2hg082iWoiAP5/WK+KWRSWmnVuvtuA3nhIlNc
	 3ydcZrkYPxe8kRVh6761e9CsxPrVzDoGUZhOCYvxtIuBsR9LglsXz9QzwQ00ywJPyCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061118;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=9GsuYxLZy7J1cv6W7XAZYxvGYLlHiKM1FePwopOptk4=;
	b=MQ9m4p5c3n8USyfW3g9+xMnOinKcShLlxatmsTuYNM0Kf+dY04h6G95MQcxFyzzhWdss
	 QudqbMKkpkdFxezuYr+Bzap2amwzFzGh4OhRCgXrccaJrYBJeIvPK7vYdgdFQgRwzX40o
	 e0ELNbu3P44DjgkuhNizSh3bNblfZgu+3Op3kbkPBUiPHXo18O+SQaYT4TS2bL7B8xkC+
	 yMW+WO9JhbbIPoiCFyegv2mSRCUoVdnmzyFyl0imFIbmxtwVa6KoVcqHaB8qGeg2Byo3c
	 hOknCuAwnBATBflj9mwH7rZtTID56pMAnSQqXe/aci+8t+N8ao5AntyuAOi8Dd+p+5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xFDUA9Ps;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3790606A332;
	Sat,  7 Nov 2026 14:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xFDUA9Ps
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6109F1F0089F;
	Sat,  7 Nov 2026 14:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061117;
	bh=9GsuYxLZy7J1cv6W7XAZYxvGYLlHiKM1FePwopOptk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xFDUA9PsO9Fic6E2X4NBm9fd9gI42UWwuswTIRhYMjLY6S8PPro78Ij8J9H+LAvN2
	 S6+sUnnmoT9umHsUJ6YZ4LMbO18ovQXW94JdxSWO8O4EJHqc+U8y7bSVas5AB4pAIf
	 8ggg6lJIRyiY0yXcZTV9sFqnVqAt31aHfRvwN6S0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuanfu Xie <yuanfuxie@stu.pku.edu.cn>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.12 0432/1536] ceph: fail readdir when the MDS reply carries no dirfrag
Date: Sat,  7 Nov 2026 08:40:48 -0500
Message-ID: <20261107135009.699876818@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -466,6 +466,10 @@ more:
 		      (int)req->r_reply_info.hash_order);
 
 		rinfo = &req->r_reply_info;
+		if (WARN_ON_ONCE(!rinfo->dir_dir)) {
+			ceph_mdsc_put_request(req);
+			return -EIO;
+		}
 		if (le32_to_cpu(rinfo->dir_dir->frag) != frag) {
 			frag = le32_to_cpu(rinfo->dir_dir->frag);
 			if (!rinfo->hash_order) {


