Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620207;
	b=EWOJ+OochR+tPTGE/gnJ7HO9W/Z5yVs8C3EbZGt+3LhlNSXhR8JgQf9jz6ptugezJc0I
	 Y0TnC5hCY1dpb1JxHFaA+AaysFMUxWE5EYcouFNtPVumUkwrRZHVExA69CfsRVDVf37p0
	 L8IfMKDeJxsV+/5mRuX8HgVJftcDwBeeoQvhcL7gh6boqHyHjdyopVdgPmzzDYwIjfV9g
	 lnyhLfUw77pa6JEmtPqXQyiCvB1o+w3t+R0LLxGD3bi9tvuOqSddddGFsnqJsdQx5/Jkv
	 XtP2gQswIobElfcKRhBRl1iinxSe07PwD+qq3DGt4hD1hjrxltzHSMWm9Poh5gymnjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620207;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rCFwRmDPY51WBvjyxw5a91kWW+TKH45JGpUaVxZIOc8=;
	b=bux4tOh0s7rr+4/xpBnpZa+oJLb58YS7gsr0nODQLL1mmj9S2hEy3auUiA7DL1LA168O
	 phta4elLBYuZkH2PndLktCMQ69H7oFoXlL+DUTzpAOdDL38aC7OJJX4S82DQBA9n25jwc
	 Y3LIssEveruu8+Y7o3yVhabUJUnEU0CkXkByWF97AgM9uU4acqcfEiHBqU+GYoSgPo1eN
	 ULOPW3YUJd6G7hh2bsjFh4iXYVgfFnSCBoF7i1j0EOEZlsO+oNSIAQo4bXBjZlTyIMTTh
	 IqgcNmNtEtrAFYZhRJzoYbuXQMPxme3GIXzcacXxus8V5NU9GgWD+Nn0c09apfzbJ3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I6VXutiB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2731606A33F;
	Wed, 25 Nov 2026 15:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I6VXutiB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E0501F000F0;
	Wed, 25 Nov 2026 15:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620207;
	bh=rCFwRmDPY51WBvjyxw5a91kWW+TKH45JGpUaVxZIOc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I6VXutiBwk/jqzstlYLlHz2yKroVZ6I2GokAcNYApmMAahCbQLYvO1rVesI7ol87n
	 AcIQPNmXgp/RIV/ybGor3zdWuKUBh570tbJZ33RS17kDfhL09WKIGM6lXbkB0zqlvl
	 njquPezAtYMXqmQ04bNRa/CXIOCAds6hNXaP6Xi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Misiurov <andrey.misyrov@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 7.3 0837/1005] smb: client: fix OOB write when compounding SMB2_IOCTL with encryption
Date: Wed, 25 Nov 2026 15:36:15 +0100
Message-ID: <20261125143841.327484384@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Andrey Misiurov <andrey.misyrov@gmail.com>

commit 73a0060cb22a1d2bd8bff364c18a4259ec0cb528 upstream.

On an encrypted ("seal") mount, SMB2_ioctl_init() keeps the IOCTL input
in a separate iov (iov[1]); iov[0] is a 448-byte buffer from
cifs_small_buf_get().  When such an IOCTL is not the last request of a
compound, smb2_set_next_command() pads it for alignment by copying the
whole request into iov[0].  A large enough input overflows that 448-byte
buffer and corrupts the slab; the copy also sets rq_nvec to 1, so the
input buffer is leaked too.

An unprivileged user can trigger it by creating a symlink with a long
target on such a mount: the native symlink is sent as
FSCTL_SET_REPARSE_POINT + QUERY_INFO + CLOSE in one compound, so the
IOCTL is not the last request.

With slub_debug red zones on the cifs_small_rq cache, the overflow is
caught on the next allocation from that cache in the same compound (the
0x61 bytes are the 'a' characters of the symlink target):

  BUG cifs_small_rq (Not tainted): Object corrupt
  [Left Redzone overwritten] 0xffff8a59c7790500-0xffff8a59c779053f
  First byte 0x61 instead of 0xbb
  Call Trace:
   check_object+0x1a8/0x350
   alloc_debug_processing+0xab/0x110
   ___slab_alloc+0x7e/0x2f0
   kmem_cache_alloc_noprof+0x28d/0x4b0
   mempool_alloc_slab+0x16/0x30
   cifs_small_buf_get+0x1a/0x30 [cifs]
   SMB2_close_init+0x8a/0x100 [cifs]
   smb2_compound_op+0x2571/0x2b50 [cifs]
   smb2_create_reparse_inode+0x27e/0x490 [cifs]
   mknod_nfs+0x1ce/0x2e0 [cifs]
   create_reparse_symlink+0x119/0x180 [cifs]
   cifs_symlink+0x19f/0x8e0 [cifs]
   vfs_symlink+0xa3/0x1b0
   __x64_sys_symlink+0x41/0x70

Pad the input to a multiple of 8 bytes when encryption is required.  The
request is then already aligned and smb2_set_next_command() no longer
copies it; InputCount still carries the real length.

Fixes: 90f7c100d2dd ("smb: client: fix compound alignment with encryption")
Cc: stable@vger.kernel.org
Signed-off-by: Andrey Misiurov <andrey.misyrov@gmail.com>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2pdu.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -3453,11 +3453,12 @@ SMB2_ioctl_init(struct cifs_tcon *tcon,
 		char *in_data, u32 indatalen,
 		__u32 max_response_size)
 {
-	struct smb2_ioctl_req *req;
 	struct kvec *iov = rqst->rq_iov;
+	struct smb2_ioctl_req *req;
+	u32 in_buf_len = indatalen;
 	unsigned int total_len;
-	int rc;
 	char *in_data_buf;
+	int rc;
 
 	rc = smb2_ioctl_req_init(opcode, tcon, server,
 				 (void **) &req, &total_len);
@@ -3465,15 +3466,18 @@ SMB2_ioctl_init(struct cifs_tcon *tcon,
 		return rc;
 
 	if (indatalen) {
+		if (smb3_encryption_required(tcon))
+			in_buf_len = ALIGN(indatalen, 8);
 		/*
 		 * indatalen is usually small at a couple of bytes max, so
 		 * just allocate through generic pool
 		 */
-		in_data_buf = kmemdup(in_data, indatalen, GFP_NOFS);
+		in_data_buf = kzalloc(in_buf_len, GFP_NOFS);
 		if (!in_data_buf) {
 			cifs_small_buf_release(req);
 			return -ENOMEM;
 		}
+		memcpy(in_data_buf, in_data, indatalen);
 	}
 
 	req->CtlCode = cpu_to_le32(opcode);
@@ -3497,7 +3501,7 @@ SMB2_ioctl_init(struct cifs_tcon *tcon,
 		rqst->rq_nvec = 2;
 		iov[0].iov_len = total_len - 1;
 		iov[1].iov_base = in_data_buf;
-		iov[1].iov_len = indatalen;
+		iov[1].iov_len = in_buf_len;
 	} else {
 		rqst->rq_nvec = 1;
 		iov[0].iov_len = total_len;


