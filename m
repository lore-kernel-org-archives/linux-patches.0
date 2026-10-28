Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208241;
	b=lUFaKWDyx21xbrbF8MKE68i9x9++DWQkCQJq3eL+3+xJprdbr4k7IP5QG0CvnfRwOiLP
	 P5WW59pc5gYIKUFrDyrgo0+awrL3jtsz0rLEXdXrx1ozheIoFm6JH4joJNY9kzr7CDSux
	 NLFT2NB35edK2h9HQ0rAR2bwT9XTxCxby6gS2v0bI4MrF4n2sY/UyB5Eu3WRJiQwjb26K
	 WSPdDwEwwuVVwvWnhNDCgusEKHSg6frPQLRgLL3M8P1s4Otnq3mS5XTf29od41x/nXteQ
	 vRJa0xvReh+xeJB2QLm4RSZyPvS99jlxvl8mvDTp7IZOA93pzpn1Txc6cENH0kb5UWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208241;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LX8QEuNCg+rPVgJKtXfraQdmO2HT8OMBHTPRjUISt7E=;
	b=lkPRUkLTQmlcjEWvk3aYC9OxKvcHWSyQ5NhHuZum/WBsfbV2kBCC0UNFsrIsoddbF7Xe
	 k+scJ7SbVx0X79ge2qssQu9xJxCbJVMF832f99WDgOBL3uacpkcVCthN/1m8ig9XigsAM
	 GJgn0wN1TorU/CCy86G/jwFMJD8yZNdMMinRdZAW47guxRWsqe8Pra6oFHgUHVpDZj2Fl
	 5vxl3HBPAv1XpBRnCNLdCVClSL/BzKxvBi0NaUWvOO+01ofxGn7laRRfZIXaBRLQr0nV3
	 gIfrWtbdYveFCbO96CqxYMMT6BzOTFLC+pYzDGCJ/RglN82X05bGlYcavM4KZ4HKobg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wCJn+00k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B58B5606A31A;
	Wed, 28 Oct 2026 17:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wCJn+00k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DB1C1F031E1;
	Wed, 28 Oct 2026 17:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208240;
	bh=LX8QEuNCg+rPVgJKtXfraQdmO2HT8OMBHTPRjUISt7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wCJn+00kME2Py6o0S2ADAxAtsDDZbmaoq23H7fTl1pjLZa1QPdUC73T8pme7infi+
	 uHGzz52S4PQa95LwHAG5V5ZYRMa5NqFXQnZVb6yZzltBS1dNxUspg2hUn21Qbnq0zN
	 tBwHNjbNTdjCl+WbVi4e7MmLz9RwMxjC/JySNKEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 048/516] nfsd: check nfsd4_acl_to_attr() return value in nfsd4_create()
Date: Wed, 28 Oct 2026 17:53:20 +0100
Message-ID: <20261028170004.670384809@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 2c7912732184773dbd371a411da87af1cc080b86 ]

nfsd4_create() stores the return value of nfsd4_acl_to_attr() in
status, but the switch(create->cr_type) block unconditionally
overwrites it in every branch. ACL translation errors are silently
discarded, and the CREATE proceeds without the requested ACL.

Add an early exit check after nfsd4_acl_to_attr(), matching the
pattern already used in nfsd4_setattr().

Fixes: c0cbe70742f4 ("NFSD: add posix ACLs to struct nfsd_attrs")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Jeff Layton <jlayton@kernel.org>
[ cel: prefer NFS4ERR_BADTYPE over NFS4ERR_ATTRNOTSUPP ]
Link: https://patch.msgid.link/20260611-nfsd-testing-v2-5-5b90e276f2d9@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
[ retained unconditional ACL conversion because the older helper already handles null ACLs ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4proc.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 2ef88a7d22e37..586cd5df5c3b0 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -762,7 +762,23 @@ nfsd4_create(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	if (status)
 		return status;
 
+	/* Sanitize cr_type to avoid returning ATTRNOTSUPP. */
+	switch (create->cr_type) {
+	case NF4LNK:
+	case NF4BLK:
+	case NF4CHR:
+	case NF4SOCK:
+	case NF4FIFO:
+	case NF4DIR:
+		break;
+	default:
+		status = nfserr_badtype;
+		goto out_aftermask;
+	}
+
 	status = nfsd4_acl_to_attr(create->cr_type, create->cr_acl, &attrs);
+	if (status != nfs_ok)
+		goto out_aftermask;
 	current->fs->umask = create->cr_umask;
 	switch (create->cr_type) {
 	case NF4LNK:
@@ -829,6 +845,7 @@ nfsd4_create(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	fh_put(&resfh);
 out_umask:
 	current->fs->umask = 0;
+out_aftermask:
 	nfsd_attrs_free(&attrs);
 	return status;
 }
-- 
2.53.0



