Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061734;
	b=S2pnCk/9Otwda7u6+NbeqGNKecHYwGw++AZzZKlGvIXCAU2SmnqogCMA/H7ilaNz11RT
	 I7//5SofWCsj1cEHf7XSm3JTv6QV5JvA2lokwrYf6tkfiratOrOi+enKpe+679lmTUwKX
	 PJhLrACANgPBNxCyYui2KW7AbL7N4bZllBPkykTs84hacWZ4Kv6I4DLf2TSiFEdvNGeD1
	 OlPoeO0fVWkgyjX2TGTbg2cLqAhNc8hV7ILWRBLWr/9Zt185xPtsLdyjIN8cQEEsil4hc
	 38Ger4VLMoteonX9mOry8GUURcLRlboiPSnlK59AAmaZHm8t4LCvQ8fgDu3/aKEPg+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061734;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=6vpnUnc/3IocMg4FUhi3yuo+JwKfcnhZn6tm3dzvSmg=;
	b=ZKNiFzev+HW30MXWIZ24kvB5oZw1pN5paqcutCjCCc5OoOHh2hHsueBuN8VGCb9UrLfW
	 NRHuQ2vulAWtHuxGEx1oTNy8QOfMiVRmjOZZ2Q6Op0J4quCONzVYsq48MlU2Fppc34Ed9
	 kND6xzk58/Moc/jSkhrhIBnlm5GvNuuXNKtrW2eGgDNzJf4Ouq39NzNGJfbVu2ntCyJ+o
	 EeRngEUC2dHtmU/p9LA02g19BBhbpXxKV24T/jBSgmRRo94i9++HoqG7w20YZl6+U+eV/
	 iSyE/L4pPrvJfTckGIJY5ZTqarKV6hKWqwt7lN0EtZq+KaHtKlHAWYCvwR0tvhb8NlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="jEH2W/Vg";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B404606A326;
	Sat,  7 Nov 2026 14:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jEH2W/Vg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9B951F008A2;
	Sat,  7 Nov 2026 14:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061734;
	bh=6vpnUnc/3IocMg4FUhi3yuo+JwKfcnhZn6tm3dzvSmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jEH2W/VgyMRC3z1CbjIOKfXzKUnTtnaS/MFH83SdOhAz9itSFfe1vMHwvSxOcfZtC
	 BEYMJwtVvsUyY3WwADabAnX0VLMG+3o1GxkeGcIXMDQS6o2hTMnFC6zHlpqYNNgZci
	 TrSAILS4aqDC1y3k2cw2UNOzzhxJk2M1bIKxrpcU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=B6rg=20Sommer?= <joerg@jo-so.de>,
	NeilBrown <neil@brown.name>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.12 0775/1536] NFSD: Return NFSERR_ISDIR for NFSv2 READ and WRITE on a non-regular file
Date: Sat,  7 Nov 2026 08:46:31 -0500
Message-ID: <20261107135019.299662889@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -38,6 +38,21 @@ static __be32 nfsd_map_status(__be32 sta
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
@@ -236,7 +251,7 @@ nfsd_proc_read(struct svc_rqst *rqstp)
 		resp->status = fh_getattr(&resp->fh, &resp->stat);
 	else if (resp->status == nfserr_jukebox)
 		set_bit(RQ_DROPME, &rqstp->rq_flags);
-	resp->status = nfsd_map_status(resp->status);
+	resp->status = nfsd_map_io_status(resp->status);
 	return rpc_success;
 }
 
@@ -272,7 +287,7 @@ nfsd_proc_write(struct svc_rqst *rqstp)
 		resp->status = fh_getattr(&resp->fh, &resp->stat);
 	else if (resp->status == nfserr_jukebox)
 		set_bit(RQ_DROPME, &rqstp->rq_flags);
-	resp->status = nfsd_map_status(resp->status);
+	resp->status = nfsd_map_io_status(resp->status);
 	return rpc_success;
 }
 


