Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829154;
	b=JrpIX7K/c2mboyDrZ7Q1RQvWg7h43pr/4colM3K9eYu2aQnONUFDQNJNljLdnUeeGHyq
	 ynMrHuIVpLxDTfzVkYoyuL4acaZV3BUSAHpWYMBol3BH1ts/FFhNVwM0OyEhks8Lyc4NN
	 SbwzMdBJFAmWXe3s7bQllX8Dr9PU3k7IzHhZNtwJ8mqytEhNdql0nrfz1bSwrO+1+DSsY
	 5UgN+E3uBLemsrvQjmS77FBgSkRMWAj/j5ZLxITnnVJL1Lu69j53tnPB3KM7VXsz+AVN+
	 yNZJNn+OtSLBHFQjli2BaUOJedkjNPi2FpX4HDp18b9Yjax9Hy+e2/PLWXD8nbYSGdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829154;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=vQkHnStEvO25wgkbnTsrza4ohBVQCg59mQpr+kARlVI=;
	b=tVvXCWqW25PL+5KEW4kp70qNW0o/MN/yVDF64bt93poPnLIF3JRLlgy0GquzPqWqEwmS
	 wbNmd41DE4rrfpNT/dVswYiqR4B2IyYAjQuywQ+GdVlx/NCx0+EsuN9rQGgX9WpICkPOl
	 1FujWVPkLzD+GX33CL8wjHspgq7URCpb0El7q0bTMquZB5ENZnyBtjvYC8QNfUnI3mZOt
	 Nl22QhF0WULBUyT7Bu7I3OOCqItuTj36A1Q+roe6CXOCm79M6v9gWYnIy/SE8BM/64V/1
	 dGljr5/nLO5tiMAw77cHv2X825Cs5LE0NogY7F30jGPA25TRAfU+l1xiqeXBI8QKI2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OIEasW4q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54CAB607031A;
	Wed,  4 Nov 2026 21:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OIEasW4q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA1091F00A02;
	Wed,  4 Nov 2026 21:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829154;
	bh=vQkHnStEvO25wgkbnTsrza4ohBVQCg59mQpr+kARlVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OIEasW4qEULNqlkTg93q6Sj3+nDP2k+0vpWuS2l7fGKr2EwsYZ9+Qu81O9/vk17of
	 NvIc+coDU7iLvnIKPIzVjUOQxx4y9olfzSdyfytHvv7uvzOJ7hN2HHMNInf1ICqzzw
	 WO3m1+lg3gkQG7VH0JT015yDeXCK+24epps7g3zc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=B6rg=20Sommer?= <joerg@jo-so.de>,
	NeilBrown <neil@brown.name>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 7.3 430/547] NFSD: Return NFSERR_ISDIR for NFSv2 READ and WRITE on a non-regular file
Date: Wed,  4 Nov 2026 16:10:14 -0500
Message-ID: <20261104211050.561941557@linuxfoundation.org>
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

From: Chuck Lever <cel@kernel.org>

commit 07649099cc8c449ea8d37d0e8d6b532fecb24bf8 upstream.

Commit 0ac903d1bfdc ("NFS: NFSERR_INVAL is not defined by NFSv2")
changed the status NFSD returns for an NFSv2 READ or WRITE of a
symlink or other non-regular file from NFSERR_INVAL to NFSERR_IO.
RFC 1094 defines neither an INVAL nor a SYMLINK status.

U-Boot's NFS client follows a symlink only when READ fails with
NFSERR_ISDIR or NFSERR_INVAL. Since that commit it cannot load a
boot image through a symlink exported by a Linux NFS server: the
load completes with zero bytes transferred.

Solaris returns NFSERR_ISDIR when the target of an NFSv2 READ or
WRITE is not a regular file. Return the same status from NFSD.
Other NFSv2 procedures continue to return NFSERR_IO.

Fixes: 0ac903d1bfdc ("NFS: NFSERR_INVAL is not defined by NFSv2")
Cc: stable@vger.kernel.org
Reported-by: Jörg Sommer <joerg@jo-so.de>
Closes: https://lore.kernel.org/linux-nfs/apE90ZRZB8IW_AiS@jo-so.de/
Reviewed-by: NeilBrown <neil@brown.name>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260828231841.282003-1-cel@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfsproc.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

--- a/fs/nfsd/nfsproc.c
+++ b/fs/nfsd/nfsproc.c
@@ -39,6 +39,21 @@ static __be32 nfsd_map_status(__be32 sta
 	return status;
 }
 
+/*
+ * Because NFSv2 does not have an NFSERR_SYMLINK, Solaris returns
+ * NFSERR_ISDIR when the target of a READ or WRITE is any object
+ * that is not a regular file.
+ */
+static __be32 nfsd_map_io_status(__be32 status)
+{
+	switch (status) {
+	case nfserr_symlink:
+	case nfserr_wrong_type:
+		return nfserr_isdir;
+	}
+	return nfsd_map_status(status);
+}
+
 static __be32
 nfsd_proc_null(struct svc_rqst *rqstp)
 {
@@ -237,7 +252,7 @@ nfsd_proc_read(struct svc_rqst *rqstp)
 		resp->status = fh_getattr(&resp->fh, &resp->stat);
 	else if (resp->status == nfserr_jukebox)
 		set_bit(RQ_DROPME, &rqstp->rq_flags);
-	resp->status = nfsd_map_status(resp->status);
+	resp->status = nfsd_map_io_status(resp->status);
 	return rpc_success;
 }
 
@@ -270,7 +285,7 @@ nfsd_proc_write(struct svc_rqst *rqstp)
 		resp->status = fh_getattr(&resp->fh, &resp->stat);
 	else if (resp->status == nfserr_jukebox)
 		set_bit(RQ_DROPME, &rqstp->rq_flags);
-	resp->status = nfsd_map_status(resp->status);
+	resp->status = nfsd_map_io_status(resp->status);
 	return rpc_success;
 }
 


