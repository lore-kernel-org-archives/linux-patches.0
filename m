Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831133;
	b=3Idrn2hjV6HAvDnlKfHkhMM1bWzIeM+QW7VLuvnMSNKp+Xlh+EDQq0KGP2VbdRRPo3Tp
	 uztsBQzL3F93SV2Pa9j3aRe3jtsXLt0BbWulBz7MW2jMetfiOEGULVRObuHFQo0rYXXTE
	 ZB6+khh3rbC/UH55+MBMujptdn3NrZjVwK8e5/sCYekDWb4A4CpIV/a6yfsXst/sLv5CI
	 shJys2GyuPHhy39ABXWm0wKaZ/R19QUPKJybfuZB7P8m+6EJoz9RZKjCD418sK05Gb+/o
	 MMzdw2plSaU/KVa/XPV2yBs5/ulsCdyuEGWVJOGx+cDqLEFtv3BTO5GQFIgAoYWRyYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831133;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=rEoLhvsN9HAs8sz1zd2NNQ4KwsHQophdyKYKHoC+miE=;
	b=nIIzQB6Kvb5IPv+A08OHldktC7am6HQfpUrK3vNS/20zGarmaz3PTdbGuuDS7oeOjxLu
	 HCG0OK8N2z6fzTAQRuUGjzRkmLb8AdZKY6hUopnPxMW69EgiAHNqc8haFaFWj4+sRu12W
	 mjWaxFqpCITzLgE/ATacijVCrZ0h3KoXSMLAhVJ+pnAIzuBsmr09ob9tAFyfe3iJmuRdV
	 jY6e1GK63m/F/JpuxUZIS87X5Ux44zTnNp+qk1btlmNk6XzXMyH1DhyRACqySz4aoQjX+
	 Z33YIJh+3msYnAiFrMg4Sv++BSzdawaoivsA/1qMLuJd6cx6YOXmvQtlVQj9B0L1upw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jTaxwCEc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BB36606B3AF;
	Wed,  4 Nov 2026 22:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jTaxwCEc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0E7E1F000C1;
	Wed,  4 Nov 2026 22:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831133;
	bh=rEoLhvsN9HAs8sz1zd2NNQ4KwsHQophdyKYKHoC+miE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jTaxwCEcJ4S3tDOLp1QUnBB1MHhzT0i2fnsV83mIrgf6EhNJpORwBQCl06mbtcyU0
	 4MjEnDoPn9mJcWxB8GCQQfoG29cTiLH1uFRiXoVoceD3pLm4u5uYRANIrQK0El/I+S
	 mgFHJZP5Gcvds2pY7wuYnXDAeharyvRLnft6Yls4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuanfu Xie <yuanfuxie@stu.pku.edu.cn>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.18 0518/1005] ceph: fail readdir when the MDS reply carries no dirfrag
Date: Wed,  4 Nov 2026 16:04:11 -0500
Message-ID: <20261104211058.439308678@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


