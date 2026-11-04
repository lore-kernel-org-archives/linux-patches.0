Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826898;
	b=PvU7+lY9GPNRqFv1pEWE9xw9i8bzfJixBc3g7JLeCObY7DWDdfHDRkvkIZjLFEgdvj18
	 OZ6NuugHpBv1BphGkesMfvXtc2Thi21XyTEUx8hOYbEO6hHdDZ572kzkAriqgTMPG76mY
	 SOgZtKCq4KE2sK9qXnxb3SQqVrEIyEZqIM+uO6MrF1p5K4zxy6AUETOl0k68SzqEVzZxg
	 yuQVvxDuZ017mSFhErvN/n6rXN2nbo1agXKKPiiBgNu8E5uGBo0mpn9vyQHdy+bLll6YY
	 NhVb06U7w47/HzGnHzBYI7mwcWpnbGp3lRn+DbZMWdXWsyXi5yE3AtGdmhXAeVagnJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826898;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=w9AhB8m04QFyc/6yTsqhcfIm/Mc+ApT8EV5XIJsoyMM=;
	b=mtSPXlN/NsBoLBcbMF3V26yBCkC2rvD7MYoB15dNt4L8kYSJRJyOwjAGhn2p9FKivonJ
	 Q3xrmMRDcS7JSNRRcmXh83C7iofctfeic9Ee/0HekoU2U8g1MIkLvR8JnaQ4qRze+GmiE
	 10kNAM69ki5pTxZRsC8eM2C0evr2DqYHF0Up72VvO64ZekJ6J5kCTjsz5Q1wjYTQnm8VW
	 DwB8xEqw2MuamJCW5KMAVr3ofHGPaTxiO0e5jOlAx9ZTdWS0GOyQY36HbFNDW0Kd/pI2I
	 mPkFjaYAbq9xlHMye5JoaHQ9rfC82MNFCNFsPBk9cqbB/EqkQEVFvC8S1es5S1ZjSgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="P/mUKTZ9";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22E6160B4792;
	Wed,  4 Nov 2026 21:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P/mUKTZ9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3AD31F00A15;
	Wed,  4 Nov 2026 21:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826898;
	bh=w9AhB8m04QFyc/6yTsqhcfIm/Mc+ApT8EV5XIJsoyMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P/mUKTZ9b4PqWg8SuuWxICe2YUKvEmeudTElIlauqoggcd5CvIY0ZFnZ3z+O4r/lR
	 BiVFTfyOO9+wNKmL1U0NYpa0iTdG//woHLCDxeZIX5h7bEs/2fiI9EVCB+arcv+dY4
	 MZn4LJA/5G6jIy6Osv/JCoezyYSlMw+vmRAJxtso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuanfu Xie <yuanfuxie@stu.pku.edu.cn>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 7.3 072/547] ceph: fail readdir when the MDS reply carries no dirfrag
Date: Wed,  4 Nov 2026 16:04:16 -0500
Message-ID: <20261104211040.306690428@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

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


