Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620360;
	b=gVk9l3UQ8nAAsjUJ4DwNCc0R07CiNjVTBtUnLJJ0alj0eNNs57pm6DhKJ4yEn6u50Mjf
	 nONDp1ohc3tABijrT+vu5jEPFOahN3dhbfLyDMRT+6t96n391Zwj7wpgHdcDHV/rN0+0Q
	 OCDSQtNxQcHvrGThrSDhbbn4UDDnbzwUyACr2UX11LWcTYHO8lRkuzdg9ytJF/gnTE/Hn
	 aoJgxUR0+UQVB8YVblag1D0FglKYQ1XowcJ4D3lT8yniIcytfYiMOFQVXTJOCyS8xl22S
	 rIHj4YYphTlgo06gyPqCY+zu6Kx02JfUkosU81CLst+1n6DvkQ3qK4oHoyfWF8JmHqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620360;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=+//WTznbCvVL2vPw1sfrf4hE3jBpLnMZVyrcAO1wOrE=;
	b=4l2n/egwycwe3f2CUPEj1SihJgi88munDisFMeLDr7iAucGgdkYc7n3prZMPyAeiFs0s
	 7swZiubIGiZSukmgstwXKpzVHFQO0GgFHAshKmVdCjv+ozUJX3wB+eJOnrIIMBJKzMRZI
	 sNjuHZfuEUXXcxgV4/DTRL1NohnAIg7mjUlg0NP6L0J81ebtI81gt3+rU0IZIua6Mbh3u
	 nd5O8jGaVT/mT3pddR/7bbLQG8+Xm3C/xzyRDdFATdhXIOiAovFrQVlupul/S3k+FxPUZ
	 w3YwuEf3Y4oCukLPER6OPfuk2xNMuqHZrM/T9dUpVll2ZNFQc3FgnDc7wLusQBSCtUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="f7+oTm/r";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21100606A321;
	Wed, 25 Nov 2026 15:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f7+oTm/r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA45A1F000C4;
	Wed, 25 Nov 2026 15:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620359;
	bh=+//WTznbCvVL2vPw1sfrf4hE3jBpLnMZVyrcAO1wOrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f7+oTm/ry5RO6JxW72CDvxunKYScmKG7D9Uf/LA4v2hbheTSgRlchaVkMpiXLutNz
	 VS19IbIZRrtNwP8M1zFLGjG4VS7IY2PuW3y30f9g1LWmneuH+HrRpJXgyhFLVbMW3K
	 LznSPDDClcrDwbzNT66bWyQREX8rshOCo/v1pUdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fredric Cover <fredric.cover.lkernel@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 7.3 0836/1005] smb: client: fix double conversion of DFS path in setup_dfs_ref()
Date: Wed, 25 Nov 2026 15:36:14 +0100
Message-ID: <20261125143841.304567018@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fredric Cover <fredric.cover.lkernel@gmail.com>

commit 92509ce64ffff02d05fe9f3c82b889e1cc500076 upstream.

setup_dfs_ref() converts the path from the mount charset to the DFS
cache charset (utf8) via dfs_get_path(), and then passes that already
converted string to dfs_get_referral().  dfs_cache_find() converts its
input again, assuming it is still in the mount charset.

When the mount charset is not utf8 (iocharset=iso8859-1, or a kernel
built with a non-utf8 CONFIG_NLS_DEFAULT) and the DFS path contains
non-ASCII characters, the utf8 bytes are interpreted as mount-charset
characters and encoded a second time.  For example, "é" is sent as
c3 83 c2 a9 instead of c3 a9.  The server then fails the second-level
referral with STATUS_OBJECT_PATH_NOT_FOUND and the mount fails with
-ENOENT, even though the path exists.

Pass the unconverted path to dfs_get_referral() so that it is converted
exactly once.

Such mounts now get past the second-level referral and reach
dfs_parse_target_referral(), which is why this change depends on
"smb: client: fix out-of-bounds read in dfs_parse_target_referral()".

Tested with a Samba DFS root containing a link named "café", mounted
with iocharset=iso8859-1 and the single Latin-1 byte 0xe9 in the path:
before, the mount failed with -ENOENT; with both patches applied, it
succeeds.

Signed-off-by: Fredric Cover <fredric.cover.lkernel@gmail.com>
Cc: stable@vger.kernel.org
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/dfs.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/fs/smb/client/dfs.c
+++ b/fs/smb/client/dfs.c
@@ -103,6 +103,7 @@ static int setup_dfs_ref(struct dfs_info
 	struct cifs_sb_info *cifs_sb = rw->mnt_ctx->cifs_sb;
 	struct smb3_fs_context *ctx = rw->mnt_ctx->fs_ctx;
 	char *ref_path, *full_path;
+	const char *raw_path;
 	int rc;
 
 	set_root_smb_session(rw->mnt_ctx);
@@ -114,9 +115,10 @@ static int setup_dfs_ref(struct dfs_info
 
 	if (!tgt || (tgt->server_type == DFS_TYPE_LINK &&
 		     DFS_INTERLINK(tgt->flags)))
-		ref_path = dfs_get_path(cifs_sb, ctx->UNC);
+		raw_path = ctx->UNC;
 	else
-		ref_path = dfs_get_path(cifs_sb, full_path);
+		raw_path = full_path;
+	ref_path = dfs_get_path(cifs_sb, raw_path);
 	if (IS_ERR(ref_path)) {
 		rc = PTR_ERR(ref_path);
 		kfree(full_path);
@@ -125,9 +127,7 @@ static int setup_dfs_ref(struct dfs_info
 	ref_walk_path(rw) = ref_path;
 	ref_walk_fpath(rw) = full_path;
 
-	return dfs_get_referral(rw->mnt_ctx,
-				ref_walk_path(rw) + 1,
-				ref_walk_tl(rw));
+	return dfs_get_referral(rw->mnt_ctx, raw_path + 1, ref_walk_tl(rw));
 }
 
 static int __dfs_referral_walk(struct dfs_ref_walk *rw)


