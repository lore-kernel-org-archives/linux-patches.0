Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212470;
	b=BcqInmRabpKBx0btKFoUlzEiEUW4OyM8v+Cp1OysHt+vSM/dAJnKHcmdxP/Q9QA5hKK7
	 yGedwY5ysIQ38y77AZJY7T0zK1nfn7BAcYPg4H48aYcezQB7vDEvNdRHdw/Z3umkIm4uF
	 vMz/5CQnda+H8azQbcE7CHLcaLcG9WRL4f/DFBCsAfNIqsJKWmpzrg2z1Jagh72Ur7Qec
	 dO5OgSDE63NQOatAi9fWKL9qWt+Nc73D+JcV6PX9uuvAfwdAY0zKBxBgz/kdXOY5Q4asN
	 y9WPexSev4LZ9XPOmJGiEK5i52+75l2UciVBuYxpTVAmLO2yTPgovnBWeXmQMOimlkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212470;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=h0MM3zfCNsF3yVJd6s9CeilQjBnpOVYdeKzW/dR0qlw=;
	b=YCqO4Rm0xSzM6dIrQOs15FSeCkwTvHd/fRA+P9eDT4ZIq9GXhKtn3n9j97YNQY/u8rny
	 qgmh9nkBv1OYx4Ks8Hdt1L+Q5pXBUO1mOjjYoF6oHdNCCpXWu6YrmG3ZkJQzAcegHzP4A
	 f6WijJzCYyep/NRM92GW3qu/X0PUM+bhT7N3xrYNoWrxXdT0LnhiSWJaogOrMmCp5WGbf
	 8So8BjRkj64lUj9pdfhXlXr/xvifiSAdy5qVM0wuMmfRaeIOmS6R8T16n8E0CDQWYMCCG
	 agzuQjN2LT9Um18CjvlPXvsdybssAxpmDlZHidtJValaoyWrXbO89EV+VzjiDcBie9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Einnl6WW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EF32606A321;
	Wed, 28 Oct 2026 18:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Einnl6WW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D01A1F01825;
	Wed, 28 Oct 2026 18:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212470;
	bh=h0MM3zfCNsF3yVJd6s9CeilQjBnpOVYdeKzW/dR0qlw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Einnl6WW/jZ5SyBkedetqABzLWysMWH3rTMBd7Y0PzSI/YTR47eEMAceA4EyehRfo
	 mPEuVEJ2z0rSNb0mTFIHgZfi+pQVvQO4/QC/bX7nWgbMMkqIZnpLXVaWcMk26vQFf6
	 vGNWwKllESXPO8y/rAqvEXFiilL/1eWc/+Fv0svQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0166/1887] smb/client: use stack-allocated smb2_file_all_info in smb3_query_mf_symlink()
Date: Wed, 28 Oct 2026 17:37:42 +0100
Message-ID: <20261028170503.012970316@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

[ Upstream commit fc8789bb57e625e5f32ac57ca2e7d3e7b7fda225 ]

SMB2_open() only fills the fixed fields, so a stack-allocated
smb2_file_all_info is sufficient here.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: 566820af017e ("smb: client: close handle after create-context parsing failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/link.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/fs/smb/client/link.c b/fs/smb/client/link.c
index d71feb3fdbd2c..ce76807cfe915 100644
--- a/fs/smb/client/link.c
+++ b/fs/smb/client/link.c
@@ -355,7 +355,7 @@ smb3_query_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
 	int buf_type = CIFS_NO_BUFFER;
 	__le16 *utf16_path;
 	__u8 oplock = SMB2_OPLOCK_LEVEL_NONE;
-	struct smb2_file_all_info *pfile_info = NULL;
+	struct smb2_file_all_info file_info = {};
 
 	oparms = (struct cifs_open_parms) {
 		.tcon = tcon,
@@ -371,20 +371,12 @@ smb3_query_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
 	if (utf16_path == NULL)
 		return -ENOMEM;
 
-	pfile_info = kzalloc(sizeof(struct smb2_file_all_info) + PATH_MAX * 2,
-			     GFP_KERNEL);
-
-	if (pfile_info == NULL) {
-		kfree(utf16_path);
-		return  -ENOMEM;
-	}
-
-	rc = SMB2_open(xid, &oparms, utf16_path, &oplock, pfile_info, NULL,
+	rc = SMB2_open(xid, &oparms, utf16_path, &oplock, &file_info, NULL,
 		       NULL, NULL);
 	if (rc)
 		goto qmf_out_open_fail;
 
-	if (pfile_info->EndOfFile != cpu_to_le64(CIFS_MF_SYMLINK_FILE_SIZE)) {
+	if (file_info.EndOfFile != cpu_to_le64(CIFS_MF_SYMLINK_FILE_SIZE)) {
 		/* it's not a symlink */
 		rc = -ENOENT; /* Is there a better rc to return? */
 		goto qmf_out;
@@ -402,7 +394,6 @@ smb3_query_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
 	SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_fid);
 qmf_out_open_fail:
 	kfree(utf16_path);
-	kfree(pfile_info);
 	return rc;
 }
 
-- 
2.53.0



