Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BBD87BAFB;
	Mon,  4 Mar 2024 21:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589042; cv=none; b=IvczZaeNRmDchFlW/ddwlYpQLpalUzkMSeuAx9QSY9aEFZiX2u/JO8dFTNVwmacmH+z6dwyEzV5JAB0AKAHsrKdyfpMe6d1HNVqvitDlPUH7XriMJJqyYl62R1G+rTnnfpbzCL22lOYfN54SAdspBfC0hEDudWxRWKOJ2nyL8B8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589042; c=relaxed/simple;
	bh=O0LnXOoRfkoS9erxmMKAxdBxYdSTcCeNYVIPneUr2Cs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ki3bC7WdNNS0l8XplE5YRSANaYA95qoGpTS2X3fcCtiYYUIvEtRDqiAvkoiOp+sO/+ZgXE5q4af972NK8DLr1wXfBfXwXu+oJRfZ7NAM4PXipbNGMFsEiw9NT9IzFjFNhppvQZDO4onXnLV0s8+DLIY88A5j9uBhwB8AhpCfHXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v6lpWuyf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v6lpWuyf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59D43C433C7;
	Mon,  4 Mar 2024 21:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589041;
	bh=O0LnXOoRfkoS9erxmMKAxdBxYdSTcCeNYVIPneUr2Cs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v6lpWuyfLN9/FBKXluKLpsBExWAiScKOkJWGaf80Yh7dfK2RkWoJLy7kPClfNm1ZF
	 npyfwBoG2t16y5qfP/rp0XBbLY3hShw6ZkEK58cUwLOY7wZSNPUA7g9Q9jILMASa7o
	 72QIBNH016fBhkmFv4J97re3zwwzrfGefzW+8wtc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	NeilBrown <neilb@suse.de>,
	Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 6.1 154/215] NFSD: Update file_hashtbl() helpers
Date: Mon,  4 Mar 2024 21:23:37 +0000
Message-ID: <20240304211601.902879558@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 3fe828caddd81e68e9d29353c6e9285a658ca056 ]

Enable callers to use const pointers for type safety.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: NeilBrown <neilb@suse.de>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4state.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -721,7 +721,7 @@ static unsigned int ownerstr_hashval(str
 #define FILE_HASH_BITS                   8
 #define FILE_HASH_SIZE                  (1 << FILE_HASH_BITS)
 
-static unsigned int file_hashval(struct svc_fh *fh)
+static unsigned int file_hashval(const struct svc_fh *fh)
 {
 	struct inode *inode = d_inode(fh->fh_dentry);
 
@@ -4687,7 +4687,7 @@ move_to_close_lru(struct nfs4_ol_stateid
 
 /* search file_hashtbl[] for file */
 static struct nfs4_file *
-find_file_locked(struct svc_fh *fh, unsigned int hashval)
+find_file_locked(const struct svc_fh *fh, unsigned int hashval)
 {
 	struct nfs4_file *fp;
 


