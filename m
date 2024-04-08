Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C9738061F;
	Mon,  8 Apr 2024 13:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583608; cv=none; b=QdR2NI+NN4qCRqNmxeJRSyWL0aq12Ilf9nxRhUxWsjXIUmfPRivxaJB/06lOzvOzSdBMTXRiwCWFAfhVeYHWMdn8sA3hXGN0PqQrojBS/9HnrOc8O5W7PVC5Y/nj12sPCm/odJg2JTT2je6S0swUaS8hDuwvA9iQY/OZQeGrGBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583608; c=relaxed/simple;
	bh=IxaIgn25F1vSPL7NsgJvWYT9mNtXZtq9fN08vKWiPNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p9WCeluX7dgPj1SIX0MDG5vTphJ9Kw0CZNPeEmB38gPsG7ygRCNX5YO0rHSzgqHdCUhIGRBxT36w/lpFDMgM2i6hB7maZdOVEE+N2w7tdxUSRhMiJdHM8qewMbX/W+3ddbeqZHwoeFPtFStFRBlZQss/yy/YiM1BkXHaaurVugg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b6RcD79Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b6RcD79Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9E35C433C7;
	Mon,  8 Apr 2024 13:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583608;
	bh=IxaIgn25F1vSPL7NsgJvWYT9mNtXZtq9fN08vKWiPNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b6RcD79YHYadTdd79TFkqqyeD0Vjn3MTyAxX7iDWQVNIWSrKgVi2oH8ag3vtv3VvL
	 vTBdQfUX/DoloWu6PKfU7JuDzsouOvykL6tTgWg9w30yvyCXvTooDMGzuVJabIfg7a
	 lgfyWlyevHsFqrwvK0W9UAKxyHuxkuYJ6G81AJfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 266/690] NFSD: Deprecate NFS_OFFSET_MAX
Date: Mon,  8 Apr 2024 14:52:12 +0200
Message-ID: <20240408125409.254493178@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit c306d737691ef84305d4ed0d302c63db2932f0bb ]

NFS_OFFSET_MAX was introduced way back in Linux v2.3.y before there
was a kernel-wide OFFSET_MAX value. As a clean up, replace the last
few uses of it with its generic equivalent, and get rid of it.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs3xdr.c   | 2 +-
 fs/nfsd/nfs4xdr.c   | 2 +-
 include/linux/nfs.h | 8 --------
 3 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
index 2e47a07029f1d..0293b8d65f10f 100644
--- a/fs/nfsd/nfs3xdr.c
+++ b/fs/nfsd/nfs3xdr.c
@@ -1060,7 +1060,7 @@ svcxdr_encode_entry3_common(struct nfsd3_readdirres *resp, const char *name,
 		return false;
 	/* cookie */
 	resp->cookie_offset = dirlist->len;
-	if (xdr_stream_encode_u64(xdr, NFS_OFFSET_MAX) < 0)
+	if (xdr_stream_encode_u64(xdr, OFFSET_MAX) < 0)
 		return false;
 
 	return true;
diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 4459722259fb2..19ddd80239944 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -3492,7 +3492,7 @@ nfsd4_encode_dirent(void *ccdv, const char *name, int namlen,
 	p = xdr_reserve_space(xdr, 3*4 + namlen);
 	if (!p)
 		goto fail;
-	p = xdr_encode_hyper(p, NFS_OFFSET_MAX);    /* offset of next entry */
+	p = xdr_encode_hyper(p, OFFSET_MAX);        /* offset of next entry */
 	p = xdr_encode_array(p, name, namlen);      /* name length & name */
 
 	nfserr = nfsd4_encode_dirent_fattr(xdr, cd, name, namlen);
diff --git a/include/linux/nfs.h b/include/linux/nfs.h
index 0dc7ad38a0da4..b06375e88e589 100644
--- a/include/linux/nfs.h
+++ b/include/linux/nfs.h
@@ -36,14 +36,6 @@ static inline void nfs_copy_fh(struct nfs_fh *target, const struct nfs_fh *sourc
 	memcpy(target->data, source->data, source->size);
 }
 
-
-/*
- * This is really a general kernel constant, but since nothing like
- * this is defined in the kernel headers, I have to do it here.
- */
-#define NFS_OFFSET_MAX		((__s64)((~(__u64)0) >> 1))
-
-
 enum nfs3_stable_how {
 	NFS_UNSTABLE = 0,
 	NFS_DATA_SYNC = 1,
-- 
2.43.0



