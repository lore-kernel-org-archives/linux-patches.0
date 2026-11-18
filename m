Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043707;
	b=UBPzQkQvP1eHtZN12E5fuF2sE7hzNcE4EnNiFq3Fcc5eaEhIy5+xEZG6sgErdMDdJl3N
	 Yrzg/czfjsJJyHz1bX4VHX82+9HGbg0tXLHvT+vod/vDiu3UjY13lnxojGcG2V5qHapvj
	 uMrvooQ04juYwyNDccniro8g9d2gC84/Ypu+SWOq3weM5mcpEg1fkCBvWK2sEc5mz91SB
	 Ud+vgJdsPxhNerLCuAWIHA1XnoYpkeY6NMdPYxLTXgHFdgF+vdRftDCm+fE3SSC19LsEG
	 Z3NtcyClw2ctEOn0Y3ybiyW3Wz2gZ5oQudjVVhHHy5cYHFeczXzckv7/0OANC9aotAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043707;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=vLPblO+xXde/vH3NW8wETSIZcWD3vn/vllBbnM/y1fQ=;
	b=HGjOmQEW10q0MzCbWgWxXRvsS7816l5UHJ3z5GJ6WEZRUP4soAI6jCIb2r9D40mvlJFx
	 eYaU8RqVj5bO0MdFShUmVO+b8r6YhNw5EgMyjGlt1iOJ3Qj/WVn2wYRypmfKT64NGmERB
	 XAMvP7sMTRg7Bxn9KlqQ4N7JJHGIDeQyWeuA8+34AV3XTOxi/Q+oYbugy0dtS7o1mfgSz
	 3KHOA5ifnFAjgSb+rntoo9BTgtmZXE6wZWrNGJydMfPjZ2DH2DTzwrXVkLilboG2r0S7G
	 tOGEWE1tNeYZZCS/wbBP/sysf14nD0Io40kFeuM48FtzMCRR89XKdyElt9n4ei+nohw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ycbo+y72;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA743606A31C;
	Wed, 18 Nov 2026 23:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ycbo+y72
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 281FB1F000C4;
	Wed, 18 Nov 2026 23:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043707;
	bh=vLPblO+xXde/vH3NW8wETSIZcWD3vn/vllBbnM/y1fQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ycbo+y726zPD57pyJ0lFydPnrGHMNWzAikBmeSO9Ewvzz8+AZC0a+MkkqBmucZNLP
	 JYeyjQvirCrLuhjRB0/+keKV1Y2WUtVFvRii4GQHcZZTawrZRjk41Y1J41k3L58tja
	 xL5/qNDBIw7QZ8NfGRnVKrIeZf0lD5Ln+810Zw00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuanfu Xie <yuanfuxie@stu.pku.edu.cn>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.1 0305/2857] ceph: fail readdir when the MDS reply carries no dirfrag
Date: Wed, 18 Nov 2026 15:22:19 +0100
Message-ID: <20261118150212.400106325@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


