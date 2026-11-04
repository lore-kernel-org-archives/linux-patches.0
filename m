Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831772;
	b=PCCYiq4I/+B1pj7gJS5faERnVgPRH4HN30fYm6v1YqcPjssKMkFPsooH7VDnJ3BIFVpq
	 JguXnPcUVwijDf7ZvcbZOlaz7FF1BIjtxO031/sf+9TitpbKyFf7FNsb9u7AY3027d3Fa
	 wg+p9NxQLZhbcRiiVG7PWfARWfg2NqnH0KwjjK4dkZiYhKM4gs5O+BfdeJJcQ8j7HzG9K
	 PM2paujzS4YO84dDDjjFoJ6xiNs4gRG1oqBzZ/Cf6F6PeSe38TNw0kKYrXuxbNLBFuK78
	 BAslDvSsnuM4MrtgMUQ7jagGyOEdP/Dv4N7THTuYGV7aQTMlAx7Qs3n+/K3Hju1bbEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831772;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=B0zXC7CklPEgfiwZJr3oLkIqKD7P33H4qk5UklmY43c=;
	b=mdZgcULnVgpEzzh+nS1BjuAC3n9NfEEBErFYfuiBzn1cx9yhyWSQ8jCHE8KM6hW7D6KI
	 r4F25Y9V95RKA4AiexUxmdInpcHGvQQDPZGPLkSApfTZqD0deTW8im/FjL66AQaUN+Cf2
	 F4Llin9JG37r3e1pTDX4dcawNMnHc63zOkwJ7eDRr+dDfgWl4nOmEmgShFvsMpRgJTjmu
	 cxX+NZIHYUvkEIPAGo9F3JogUU9i0LQZGzCGaO1QDEFf39vbnfhdhFHDqRak6MM8bqu4g
	 BI/KOewfClNPKQTZiRP7edt4ofLbpGFqZI53op/5CPr+5bnn8ZoKdDSnyfxRR1sMWsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KhRPLXHk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19A1A606A31B;
	Wed,  4 Nov 2026 22:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KhRPLXHk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA11E1F000C1;
	Wed,  4 Nov 2026 22:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831772;
	bh=B0zXC7CklPEgfiwZJr3oLkIqKD7P33H4qk5UklmY43c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KhRPLXHkfpwdLSM4VA+Z2cGZsXnSW74QH6MdsymntI/yjopupCBNNyP7sNyf5ta6w
	 WZ/tAe8cwq7ld/Ic8noDHEvzYw8BBLnMCeLSgZerDGKnIEeVzpASVG9OKl2yNVwKMr
	 h5ZUGp2IwN6uNUtqjLh/winlgtJjj3WOylasCLJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=B6rg=20Sommer?= <joerg@jo-so.de>,
	NeilBrown <neil@brown.name>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.18 0903/1005] NFSD: Return NFSERR_ISDIR for NFSv2 READ and WRITE on a non-regular file
Date: Wed,  4 Nov 2026 16:10:36 -0500
Message-ID: <20261104211108.483432996@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 


