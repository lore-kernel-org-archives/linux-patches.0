Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212314;
	b=yZZ6aKEE0+uf1T2D3m0dLIfhXhdKSBDhxMDOLIwXlOf1ZxOptQ/RnR5HA12ir+znY+2G
	 4y/eGmb/xSFzOZdfaSR7FDi6Ldk16ncB5/j7+4RDiJJuk+a5SgSPvokzwzw/cHpBNZuZ0
	 FcnPaQKvuvJ17wkTgs3uY7s6lKlIh0iB5OnrxBM9FkKgf5q8hRJ0AVNp7ehgIFfUEzOcE
	 jKBcJI/Y3uy/1WDaMbwAenO8yUBKmqT2zTa5ZPFw/ynI7xJaTAAQ9uQLpGZTNQUDerLjs
	 mZcXs+yOaCTIa7Hj7eJc/RPPlJjWChGrHTuOa2x286Xql3pZhny8ASXLny12ZmvZXiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212314;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dCtdZjAs45/C+ucPH84p+LfmMQpgaJ2WBr/ETvSlQ54=;
	b=hpvmTmXrdjzIyc6SrlndSwYqyhGrJ5N3RHevRQNYLh66nJ3Lzy2VJH/vkM92RzRgtC0O
	 AX5OqhRGcxz1uib+rlIovLO4w8ZUEcpy0+r7ES3YkZ770bMwzxF4TbIeNtIvUwaKLOV7K
	 HKMVlAgyvwayNMSaNVNmw5t7ku0OLNZkZK7W8b3MiretkwHIqgk1e3aeS2tgdUZEbTZHM
	 +/dX4SjGUV+lBnrLgOUBLhhVmykPXrMkKhANqM2Nx0CFzIO2sYt9kdD+yAakPsNs2cABA
	 wGPuUYpw5jNK3gLiqj2vu9XjD8O99exgnvEHbwvJi3VWxI5TX6zmYtnELYNlE6NuoEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0tw5fuTJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8211A606A31A;
	Wed, 28 Oct 2026 18:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0tw5fuTJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6D1C1F01825;
	Wed, 28 Oct 2026 18:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212314;
	bh=dCtdZjAs45/C+ucPH84p+LfmMQpgaJ2WBr/ETvSlQ54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0tw5fuTJMRjm6VYByjl08PiAG10yrA+e+tsPI11rtmLW4fFy6KnoXNDce9AAdChqV
	 P4FkrzWlDd5gQYjW0q+z2aoIe5CtAeQ8MtX6x0LgOWqiwtbmqY/X9g66CKJ1xRvMlt
	 8ZFpJsh1F7Ze3YX4JN5IBqXzP76wRPyWNl5JzeQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0067/1887] nfsd: check nfsd4_acl_to_attr() return value in nfsd4_create()
Date: Wed, 28 Oct 2026 17:36:03 +0100
Message-ID: <20261028170500.757474237@linuxfoundation.org>
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
index 7486c470fe6f1..97d48dea5ac3a 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -761,7 +761,23 @@ nfsd4_create(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
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
@@ -828,6 +844,7 @@ nfsd4_create(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	fh_put(&resfh);
 out_umask:
 	current->fs->umask = 0;
+out_aftermask:
 	nfsd_attrs_free(&attrs);
 	return status;
 }
-- 
2.53.0



