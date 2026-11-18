Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058708;
	b=lYIyf5hgL7uUcBiuRmxJxmBHfmZ/gVStGfAycDtB1B4iHLBF7YrnAH5UE5GQ3e/4Ez6+
	 FRPRJZUaf+US+XT9pxyLAHmDbCaZbjCOqTx7jfZklucF+uq6B5T+1gR2OeVU8xJRlncXm
	 PdamdK+1f/L3w2yY635A+821SiCosS+5SjILtLgXqeNYPcFlmvmilipnANHJKrjcwdbsq
	 DgwpitcJpdx090ckNGq/xiODC1eLC3WyK4KNdmxD+lVSzjnv0UetEFWizh4vKK3gg0FrJ
	 yGudZPU4LJpKisyVbBiqe8/jHPYFPgdfEQJBOj+phBp4pcMhj20JXeEMzfUiunk1RDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058708;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ERYS+Q7h6+Y3sg6oOnneA3RUimjDS/Wa0XXrk1Pi0So=;
	b=SVBL+3s5IFFhoDTVXHzvXtaezudX8bsbIeNb6VMeQbgzLm6aqVnflM7GN1rCO03Ipf6T
	 Hwf5DdVuh7Ult2iu01j+kyrfVRWFEpsfTIWsuNKu5CXnuSA968fKinrd2lXXZmd542IOn
	 tlTfg8n4PvMKZ/zViykUHZsMdN2iHQjeb2LG3FEtjJnGSUD5aXJrizJHxh5EcIaAyGncm
	 GYDscX+qjbm8yAqdkhVI4Z47g7NBNxeRugt1A6pj8+tMq23NQNP640MYlefJpC4IwSEHm
	 PbmV+daKEdDoSXPRTGESoY0DHeZQvXNMe3+iPlJO5qyPRnOKRDnn3dafbnI3IBkwDxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1WrEGXk5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE32E606A325;
	Thu, 19 Nov 2026 03:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1WrEGXk5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 329DC1F000C4;
	Thu, 19 Nov 2026 03:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058708;
	bh=ERYS+Q7h6+Y3sg6oOnneA3RUimjDS/Wa0XXrk1Pi0So=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1WrEGXk5AoBILeBzk7uW3pm4amdedPEk2QKCk5DtrerFAleUrGXmdhcjzlYCahNUh
	 z1TlfPBgviqJ8srXqUFC8gUOy2rGcp13s9UPAri9kv6kfB0Sn1wGjk7BmctXDgFlrs
	 eYwWbxYz7TEcqsQ3RXfVYUHegGwuGRFCZsN6Va5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuanfu Xie <yuanfuxie@stu.pku.edu.cn>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0583/1848] ceph: clamp MDS reply result code to the errno range
Date: Wed, 18 Nov 2026 15:43:41 +0100
Message-ID: <20261118145939.800153035@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuanfu Xie <yuanfuxie@stu.pku.edu.cn>

[ Upstream commit ec8d583469ed64b4973192a21b5a41c33219721f ]

ceph_mdsc_wait_request() returns the reply head result code of the MDS
request to its callers as a plain int errno.  The value is a
server-controlled u32 and nothing checks that it actually is an errno;
several callers pass it straight to ERR_PTR(), e.g.
ceph_finish_lookup() on the atomic open path:

	err = ceph_mdsc_wait_request(...)	/* e.g. +0x50fc00 */
	...
	if (err)
		dentry = ERR_PTR(err);

IS_ERR() only recognizes the [-MAX_ERRNO, -1] window, so an
out-of-range value is not caught anywhere and survives as a "struct
dentry *".  On the open path the positive error travels
ceph_finish_lookup() -> ceph_atomic_open() -> ERR_PTR() in
fs/namei.c's atomic_open() wrapper -> step_into(), which dereferences
it as a dentry and oopses (mainline 7.3-rc3-135-g4982d3552a3b, the
value in R12 is the server-supplied result):

BUG: KASAN: probably user-memory-access in range
[0x000000000050fc00-0x000000000050fc07]
RIP: 0010:step_into_slowpath+0x3e3/0xe60
R12: 000000000050fc00
Call Trace:
 <TASK>
 ? __pfx_ceph_atomic_open+0x10/0x10
 path_openat+0xf41/0x2440
 do_file_open+0x228/0x480
 do_sys_openat2+0x103/0x1d0
 __x64_sys_openat+0x141/0x200
 do_syscall_64+0xe8/0x4f0
 entry_SYSCALL_64_after_hwframe+0x77/0x79
 </TASK>

(0xdffffc00000a1f80 in the full report is the KASAN shadow of 0x50fc00;
without KASAN the raw value is read.)  Values with the top bit set fare
no better: 0xd8000000 sign-extends through the int conversion into the
kernel address range and takes a page fault instead.

Clamp the result at the single read and return -EIO for anything
outside the errno range, which is what a malformed reply means there.
net/9p does the same to server errno values with safe_errno().  This
is the path the reported crash takes; the other readers of
head->result, including the ceph_async_create_cb() and
ceph_async_unlink_cb() callbacks, are not covered by this patch.

Each of the six crashing opens was run on a build of
7.3-rc3-135-g4982d3552a3bf with only this change applied: it crashes
the unpatched kernel on the first openat() (verified on the same
tree without the patch), and with the patch the open fails cleanly
without an oops.  A few hundred normal file operations on the
patched kernel also completed without a crash; valid errno values
pass through unchanged.

Cc: stable@vger.kernel.org
Fixes: 2f2dc053404febedc9c273452d9d518fb31fde72 ("ceph: MDS client")
Signed-off-by: Yuanfu Xie <yuanfuxie@stu.pku.edu.cn>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/mds_client.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 75ce0a52ace27..8154c08d54977 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -3051,6 +3051,14 @@ static int ceph_mdsc_wait_request(struct ceph_mds_client *mdsc,
 	/* only abort if we didn't race with a real reply */
 	if (test_bit(CEPH_MDS_R_GOT_RESULT, &req->r_req_flags)) {
 		err = le32_to_cpu(req->r_reply_info.head->result);
+		if (err > 0 || err < -MAX_ERRNO) {
+			/*
+			 * The result is server-controlled.  Values outside
+			 * the errno range are turned into bogus pointers by
+			 * the ERR_PTR() users among the callers.
+			 */
+			err = -EIO;
+		}
 	} else if (err < 0) {
 		dout("aborted request %lld with %d\n", req->r_tid, err);
 
-- 
2.53.0



