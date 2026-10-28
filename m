Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216063;
	b=ZEUcC/rZa45gy82JjmAAhVZG02k6/+X9RFloMSiOxWUFIj6kwe6P8VacH64rh5NXR+yh
	 /jyLlEfKC3tzLF+zb0kwvqAIIOKL0ypvpy59xgo4ATRU8JSeDXYTHED0zM83s/nxeZCQW
	 2SLuBdIdiIhzto/3l+8lPoCBIz1Qd2+W75U+KKllcECGDnTRUe8pwU1Kub1EEwtqL8vXU
	 Nbz0zzq0yLyA3HBlpeP/wgdZnfwGdt/oE53FEu88bGFfBx+WCvjCa084r2I8mXk+z4vzP
	 vFvRRTG/4UxatodeBBaM5yu4OF/dKpk4o6+n8VwOP6HFIS/x1wJNPBC8BjBWl+sqbxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216063;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HVNvgiVe0c9AeYOvhLyx72R5gligobR1+ZKuy+PuqSc=;
	b=CCHvK7c1wD82EdLIronYmc6cDsrQOjq6H4YmhuLaDdRtxhh3HY5W77F5zqcO42DZo/6b
	 vLmrQik3bl4sPL+Key7W94OkQ+eS+4A/QGPe4AznWWIRbtmZFcPMTnKrLPGx6uYm0eC2S
	 QRrlFaw6Pli/dqG/+3Yqx/K7dEqdQQbcG6n52IVucnBq3Rl3+7l0mbLfIGMkaTKXCwl7N
	 ulsxe2uu1tvUeIkRnRGKmO2xOs3gicrLM2RHPNFHBo4YVSnm2G0WK6S/FNl7wtG9Jhgcx
	 BvGypSpsH14aogdjMbGycYNF5wI9Ol9eHCgwMATnE1aBl2tfjMS5xvkx4gQ3heGqzjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="P2DbLLE/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 961AC606A31D;
	Wed, 28 Oct 2026 19:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P2DbLLE/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E41FF1F01825;
	Wed, 28 Oct 2026 19:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216063;
	bh=HVNvgiVe0c9AeYOvhLyx72R5gligobR1+ZKuy+PuqSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P2DbLLE/87P/mu3gqm1GC9uIwJpiXpZ8Oz1RuFzdaXv2nYjET9VEatw/FJWOcLsjI
	 i1DBhWiR3Xj4NQbYPFiBTxcYf8E1SJ4Eq0wmce6FPgWlktN7MYG3TCJmDL1r3UzY2g
	 lirYxoQEzbirXhA7ofb7RNNfOb0rvwSwNwO1aXCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robbie Ko <robbieko@synology.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1429/1887] nfsd: reject out-of-range nseconds in NFSv3 SETATTR and create ops
Date: Wed, 28 Oct 2026 17:58:45 +0100
Message-ID: <20261028170531.978793315@linuxfoundation.org>
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

From: Robbie Ko <robbieko@synology.com>

[ Upstream commit eb0eca7720662ba5847df1510e73801f7f473094 ]

A client can send an NFSv3 SETATTR, CREATE, MKDIR, SYMLINK or MKNOD
carrying an atime or mtime whose nseconds field is out of range. The
value is well-formed on the wire and decodes cleanly into a valid
uint32, but it is not a valid timespec64: tv_nsec must be less than
NSEC_PER_SEC.

Nothing in the setattr path clamps it. notify_change() runs the time
through timestamp_truncate(), which does not reduce tv_nsec below
NSEC_PER_SEC when the filesystem supports nanosecond granularity
(s_time_gran == 1), and the inode atime/mtime setters store it verbatim
(only ctime is normalized, via inode_set_ctime_to_ts()). The
un-normalized value then corrupts on-disk metadata: ext4's
ext4_encode_extra_time() shifts tv_nsec left by EXT4_EPOCH_BITS, which
overflows the 32-bit extra field and clobbers the seconds-epoch bits, so
the stored seconds (and thus the year) are wrong on read-back. XFS with
bigtime mis-stores the timestamp for the same reason.

Validate the client-supplied atime/mtime in the proc handlers and return
NFS3ERR_INVAL before anything is changed. RFC 1813 lists NFS3ERR_INVAL
for SETATTR and describes it as the error for a value the server 'can
not store ... in its own representation'; the client maps it to EINVAL.

Checking in the proc handlers, rather than in nfsd_setattr(), keeps the
rejection in front of object creation. The create operations create the
object before nfsd_create_setattr() runs, so a late failure would leave
the new object behind and turn a non-idempotent request into a namespace
change that reports failure. The check is therefore done up front, for
the create operations before the object is created.

tv_nsec is a long, so the comparison casts it to unsigned long (the same
width) rather than to u32, matching timespec64_valid(). A u32 cast would
truncate on 64-bit; the unsigned long cast also rejects a value that
became negative when an out-of-range u32 wire nseconds was assigned to a
32-bit long.

Only client-supplied times are checked: SET_TO_SERVER_TIME requests
carry no client value. The sattrguard3 ctime is deliberately left alone:
an out-of-range guard simply never matches the object's ctime and yields
NFS3ERR_NOT_SYNC via the existing guardtime comparison, which is the
protocol-correct outcome rather than rejecting the request.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Robbie Ko <robbieko@synology.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260616054027.2360930-2-robbieko@synology.com
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs3proc.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/fs/nfsd/nfs3proc.c b/fs/nfsd/nfs3proc.c
index d01b29aba6623..5b206463b11e7 100644
--- a/fs/nfsd/nfs3proc.c
+++ b/fs/nfsd/nfs3proc.c
@@ -28,6 +28,25 @@ static int	nfs3_ftypes[] = {
 	S_IFIFO,		/* NF3FIFO */
 };
 
+/*
+ * Reject a client-supplied atime or mtime whose nanoseconds field is out
+ * of range. Such a value is well-formed on the wire but is not a valid
+ * timespec64, and storing it verbatim can corrupt on-disk timestamps.
+ * tv_nsec is a long, so it is cast to unsigned long (the same width) to
+ * catch both an over-large value and one that became negative when an
+ * out-of-range u32 wire nseconds was assigned to a 32-bit long.
+ */
+static bool nfsd3_time_in_range(const struct iattr *iap)
+{
+	if ((iap->ia_valid & ATTR_ATIME_SET) &&
+	    (unsigned long)iap->ia_atime.tv_nsec >= NSEC_PER_SEC)
+		return false;
+	if ((iap->ia_valid & ATTR_MTIME_SET) &&
+	    (unsigned long)iap->ia_mtime.tv_nsec >= NSEC_PER_SEC)
+		return false;
+	return true;
+}
+
 /*
  * NULL call.
  */
@@ -76,6 +95,10 @@ nfsd3_proc_setattr(struct svc_rqst *rqstp)
 				SVCFH_fmt(&argp->fh));
 
 	fh_copy(&resp->fh, &argp->fh);
+	if (!nfsd3_time_in_range(&argp->attrs)) {
+		resp->status = nfserr_inval;
+		return rpc_success;
+	}
 	resp->status = nfsd_setattr(rqstp, &resp->fh, &attrs,
 				    argp->check_guard, argp->guardtime);
 	return rpc_success;
@@ -245,6 +268,8 @@ nfsd3_create_file(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	__be32 status;
 	int host_err;
 
+	if (!nfsd3_time_in_range(iap))
+		return nfserr_inval;
 	if (isdotent(argp->name, argp->len))
 		return nfserr_exist;
 	if (!(iap->ia_valid & ATTR_MODE))
@@ -389,6 +414,10 @@ nfsd3_proc_mkdir(struct svc_rqst *rqstp)
 	argp->attrs.ia_valid &= ~ATTR_SIZE;
 	fh_copy(&resp->dirfh, &argp->fh);
 	fh_init(&resp->fh, NFS3_FHSIZE);
+	if (!nfsd3_time_in_range(&argp->attrs)) {
+		resp->status = nfserr_inval;
+		return rpc_success;
+	}
 	resp->status = nfsd_create(rqstp, &resp->dirfh, argp->name, argp->len,
 				   &attrs, S_IFDIR, 0, &resp->fh);
 	return rpc_success;
@@ -403,6 +432,10 @@ nfsd3_proc_symlink(struct svc_rqst *rqstp)
 		.na_iattr	= &argp->attrs,
 	};
 
+	if (!nfsd3_time_in_range(&argp->attrs)) {
+		resp->status = nfserr_inval;
+		goto out;
+	}
 	if (argp->tlen == 0) {
 		resp->status = nfserr_inval;
 		goto out;
@@ -468,6 +501,11 @@ nfsd3_proc_mknod(struct svc_rqst *rqstp)
 		goto out;
 	}
 
+	if (!nfsd3_time_in_range(&argp->attrs)) {
+		resp->status = nfserr_inval;
+		goto out;
+	}
+
 	type = nfs3_ftypes[argp->ftype];
 	resp->status = nfsd_create(rqstp, &resp->dirfh, argp->name, argp->len,
 				   &attrs, type, rdev, &resp->fh);
-- 
2.53.0



