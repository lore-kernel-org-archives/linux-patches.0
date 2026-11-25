Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619681;
	b=rxR5sUJN4NO59iaQau8jDvzFhaOvi/FVuNCvJ1lDOBnYQpANNrEIhg9yd1ppsS35/mQt
	 TuR5xcktGmZNDMRxn5DYGLPSM5JIBCZqxeNzC1c2OnJmyY6HP3z0La0Th6KV0eoVgozue
	 SCuTqGL5dOZ8aJibWKYts81aljYEqLQQj+E1kT5jwRLEtbhCMb4L5iC9Za6/1FBOl1Lmu
	 LL7j5Ro++ezNFSIC7pOiBS6nHF4hkE5PXeUJBWMgZhBB5yuN9kLS2hvgZ4Ag3kYIB213n
	 KD3cG4+EQSCHrePiNXYEmxpi7f8BcvmsJAAVQHGt8blRz5wzYwJHp7y3vdIX6zCey+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619681;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ow+RUAWvnV+tBViFy1aN/+G4qZcZ6ocQg3364j7qR+Q=;
	b=dkFsDIOSHpxvir0iqPedFRjXVIyWTAp6QtfCL17pn3dBJqkJMvWSqxzGet/OoB374lB5
	 PyG1k/t8Xy4H3vpIpLClVM1UCLxOILdEB9M/1Bfp75Z9GwXerMh0s033qcD7WrFpXM6MI
	 CpfA+XgM6InilgJX3qtVZeDHJNhh7p8Kaf2IU+9WeNtWpdFaT6sy2+ZY2cC9YHgbDLF3U
	 GWpZhVLDAG5WCz52xr4vnfYstvDuZ39Iv1cTCKhSgn2PKQvZS2tXfBeKwY6sn/gwO56Yu
	 uES96h4s0/C1xp/VvqBA9sDiu7rQXNmDtVPfvMu9jOmkM9S9l5pJmmuJ1GoIgoNNW5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OjkFnShv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6952606A332;
	Wed, 25 Nov 2026 15:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OjkFnShv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C7EB1F000C4;
	Wed, 25 Nov 2026 15:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619681;
	bh=Ow+RUAWvnV+tBViFy1aN/+G4qZcZ6ocQg3364j7qR+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OjkFnShvTMQczyvxH2hTxtjy/fCL22CVglDnlmUFMvuqr9KEqsKVUhks7AWcBghWd
	 Th+XcFW3ePa+NElNAWwGXD7r4AEPPUbDVcmayKffIv/xcKvGu0dsgdj5VuiQgJFMGZ
	 rzXe1XqT67xqlW5uo5Rkq3PhmPcqP4ZJWl+yD5eg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wahid Khan <wahidzk0091@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 7.3 0674/1005] ntfs: open the index allocation before reading or writing an index block
Date: Wed, 25 Nov 2026 15:33:32 +0100
Message-ID: <20261125143837.542216358@linuxfoundation.org>
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

From: Wahid Khan <wahidzk0091@gmail.com>

commit bada7bbb11aaa6feba8904cf38ff833453f5b5d9 upstream.

ntfs_ib_write() and ntfs_ib_read() use icx->ia_ni without checking it.
ntfs_ir_reparent() only opens the index allocation through
ntfs_ia_add() when the root is a small index. For a root that is already
marked as a large index it calls ntfs_ib_write() directly.

The lookup does not open the index allocation either when it ends in the
root. If the last entry of the root has no child node, ia_ni is still
NULL when the root has to be moved into an index block, and the write
dereferences it:

  Oops: general protection fault, KASAN: null-ptr-deref in range
        [0x0000000000000128-0x000000000000012f]
  RIP: 0010:ntfs_inode_attr_pwrite+0x52/0x1600
   ntfs_ir_make_space
   ntfs_ie_add
   ntfs_index_add_filename
   __ntfs_link
   ntfs_link
   vfs_link

A single byte of an image from mkntfs is enough. In a directory that has
one empty index block, clear INDEX_ENTRY_NODE (flags 3 -> 2) of the last
entry of the $INDEX_ROOT and link() a file into the directory.

Commit 9365c4a1357e ("ntfs: fix NULL dereference on index allocation open failure")
covers the case where ntfs_ia_open() fails in the lookup. Here it was
never tried. Open the index allocation on demand in both
helpers and fail with -EIO if that does not work.

ntfs_ia_open() also succeeds for a directory that has no
$INDEX_ALLOCATION attribute. The inode it returns is then an empty resident
stub that does not describe an index allocation, so reject that case too.

Fixes: 0a8ac0c1fa0b ("ntfs: update directory operations")
Cc: stable@vger.kernel.org # v7.1+
Signed-off-by: Wahid Khan <wahidzk0091@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs/index.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/fs/ntfs/index.c
+++ b/fs/ntfs/index.c
@@ -99,12 +99,30 @@ static s64 ntfs_ib_pos_to_vcn(struct ntf
 	return pos >> icx->vcn_size_bits;
 }
 
+/* Open the index allocation inode if no earlier step of the operation did. */
+static int ntfs_icx_ia_ensure(struct ntfs_index_context *icx)
+{
+	if (!icx->ia_ni) {
+		icx->ia_ni = ntfs_ia_open(icx, icx->idx_ni);
+		if (!icx->ia_ni)
+			return -EIO;
+	}
+	/* Without $INDEX_ALLOCATION the index inode is an empty resident stub. */
+	if (!NInoNonResident(icx->ia_ni))
+		return -EIO;
+	return 0;
+}
+
 static int ntfs_ib_write(struct ntfs_index_context *icx, struct index_block *ib)
 {
 	s64 ret, vcn = le64_to_cpu(ib->index_block_vcn);
 
 	ntfs_debug("vcn: %lld\n", vcn);
 
+	ret = ntfs_icx_ia_ensure(icx);
+	if (ret)
+		return ret;
+
 	ret = pre_write_mst_fixup((struct ntfs_record *)ib, icx->block_size);
 	if (ret)
 		return -EIO;
@@ -770,6 +788,10 @@ static int ntfs_ib_read(struct ntfs_inde
 
 	ntfs_debug("vcn: %lld\n", vcn);
 
+	ret = ntfs_icx_ia_ensure(icx);
+	if (ret)
+		return ret;
+
 	pos = ntfs_ib_vcn_to_pos(icx, vcn);
 
 	ret = ntfs_inode_attr_pread(VFS_I(icx->ia_ni), pos, icx->block_size, (u8 *)dst);


