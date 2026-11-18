Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046012;
	b=pQ4uefyYneXx+23VC/CwJi8lFIpsBJayLyS6+cl5NQVyP98hStPTwZutEQ/cbVQUmoOG
	 ewAKOci72Y8J/H/dEvx0lZ7e4eTrF9Jr8FiXeh9EhspViGvZq9IGsiJlPc++dntna+Wpf
	 Zj9VxbI6ITZmwEmiyK40z79KjRpHE2o0cY0VJW+PbPkvIWOLLkhhGIDSEvhYppolQOZtv
	 CSbuCz2W6W1aWaUQ4P7Pm6AfzV0Ub6jxOCtmV1sG60h3GacDfGpaLKKsaIMmJChvg/MtS
	 3OdmtPL79JwiInS1XDRpwWlvyFG3QvXM4NsAat7kArxz9nZEoV609Mhvk127d6B1CRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046012;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ySCkAHg9xyh0EMt6wP0gvpK0fmwP+g+F/k5gXmEVFFs=;
	b=Y1Reis5qGx533BO8C4TtYtMFpIg0ykL7UInIjx30h6xvfBcQX6ayECTvICxvJ4dfmhN4
	 WhjrZ2DXr0FtS9cG8zz7D7N9DhDkGF/H2moiCy9L+pFq3tHlE6DHQVJjBZLW/OZwU7syR
	 rSjYA04wx/uxDxUslIhCoxZuEbF57bMCz6yArd1qcKjElaz9VGFXE0Yedd/UvI0LojB+l
	 xmyQhIs/4o6NXqLzVik/GVeDiBku0TzF6PCYEPn1egnIjANRZH7B3nEKqIM2ydl9DPoTx
	 kqQT+k6CF0GzM/YVGB65s58PgEnrZdDSe+gIhqyqeZSNPoav7KZ454IiNbKd/83PmUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vNTFjHqa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B512606A325;
	Wed, 18 Nov 2026 23:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vNTFjHqa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC7C11F000C4;
	Wed, 18 Nov 2026 23:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046012;
	bh=ySCkAHg9xyh0EMt6wP0gvpK0fmwP+g+F/k5gXmEVFFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vNTFjHqaLy578kCH7RS+MQnU9mo29HIbAEsD9Bheju6MSwcj+LG6fFpiQ6V9RTCRB
	 ZtuWUY+/XRMjvmUJsgPWY8B8MfZ9NDi3sfNquXuY5IeqbiZrYC1jX1SqxNpv7ltbtj
	 DZ0y+cxSV9KN/pLNAPeHrAg7CrLW+Lwqt23sAtnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1130/2857] NFSD: Map flex file layout IDs through the requests user namespace
Date: Wed, 18 Nov 2026 15:36:04 +0100
Message-ID: <20261118150242.287803260@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Chuck Lever <cel@kernel.org>

[ Upstream commit f913d5d2130a584d1a027ffe3dfd88b6be2e0540 ]

nfsd4_ff_proc_layoutget() and nfsd4_ff_encode_layoutget() translate
the file's owner and group with init_user_ns, but every other identity
nfsd places on the wire goes through nfsd_user_namespace(). When the
transport carries a credential from a non-initial user namespace, the
flex file layout reports host-global IDs. The client copies those IDs
into the AUTH_SYS credential it presents to the data server, and
svcauth_unix_accept() resolves that credential in the transport's
namespace, so data server I/O runs under an identity unrelated to the
file's owner.

Switching to the request's namespace introduces a second hazard.
from_kuid() returns (uid_t)-1 when the target namespace has no
mapping for the owner, and the IOMODE_READ arm adds one to that
result to derive an identity for which the data server denies
writes. The addition would wrap to zero, handing the client uid 0
instead of an identity distinct from the owner.

Translate both IDs in nfsd4_ff_proc_layoutget(), which has the
svc_rqst, and carry the wire values in struct pnfs_ff_layout.
from_kuid_munged() substitutes overflowuid for an unmapped owner and
thus never returns (uid_t)-1, so the increment cannot wrap to zero.

Fixes: 9b9960a0ca47 ("nfsd: Add a super simple flex file server")
Cc: stable@vger.kernel.org
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260720141442.783935-1-cel@kernel.org?part=3
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260720163724.810227-1-cel@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
[ sashal: added the missing rqstp argument to the proc_layoutget callback interface, caller and implementations ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/blocklayout.c       |  4 ++--
 fs/nfsd/flexfilelayout.c    | 24 ++++++++++++++----------
 fs/nfsd/flexfilelayoutxdr.c |  4 ++--
 fs/nfsd/flexfilelayoutxdr.h |  5 +++--
 fs/nfsd/nfs4proc.c          |  2 +-
 fs/nfsd/pnfs.h              |  4 ++--
 6 files changed, 24 insertions(+), 19 deletions(-)

diff --git a/fs/nfsd/blocklayout.c b/fs/nfsd/blocklayout.c
index 5eae60425e57c..bbb999c9bab99 100644
--- a/fs/nfsd/blocklayout.c
+++ b/fs/nfsd/blocklayout.c
@@ -18,8 +18,8 @@
 
 
 static __be32
-nfsd4_block_proc_layoutget(struct inode *inode, const struct svc_fh *fhp,
-		struct nfsd4_layoutget *args)
+nfsd4_block_proc_layoutget(struct svc_rqst *rqstp, struct inode *inode,
+		const struct svc_fh *fhp, struct nfsd4_layoutget *args)
 {
 	struct nfsd4_layout_seg *seg = &args->lg_seg;
 	struct super_block *sb = inode->i_sb;
diff --git a/fs/nfsd/flexfilelayout.c b/fs/nfsd/flexfilelayout.c
index 0bc52e6bec394..3c6a80c010957 100644
--- a/fs/nfsd/flexfilelayout.c
+++ b/fs/nfsd/flexfilelayout.c
@@ -14,19 +14,20 @@
 #include <linux/sunrpc/addr.h>
 
 #include "flexfilelayoutxdr.h"
+#include "auth.h"
 #include "pnfs.h"
 #include "vfs.h"
 
 #define NFSDDBG_FACILITY	NFSDDBG_PNFS
 
 static __be32
-nfsd4_ff_proc_layoutget(struct inode *inode, const struct svc_fh *fhp,
-		struct nfsd4_layoutget *args)
+nfsd4_ff_proc_layoutget(struct svc_rqst *rqstp, struct inode *inode,
+		const struct svc_fh *fhp, struct nfsd4_layoutget *args)
 {
+	struct user_namespace *userns = nfsd_user_namespace(rqstp);
 	struct nfsd4_layout_seg *seg = &args->lg_seg;
 	u32 device_generation = 0;
 	int error;
-	uid_t u;
 
 	struct pnfs_ff_layout *fl;
 
@@ -49,13 +50,16 @@ nfsd4_ff_proc_layoutget(struct inode *inode, const struct svc_fh *fhp,
 	fl->flags = FF_FLAGS_NO_LAYOUTCOMMIT | FF_FLAGS_NO_IO_THRU_MDS |
 		    FF_FLAGS_NO_READ_IO;
 
-	/* Do not allow a IOMODE_READ segment to have write pemissions */
-	if (seg->iomode == IOMODE_READ) {
-		u = from_kuid(&init_user_ns, inode->i_uid) + 1;
-		fl->uid = make_kuid(&init_user_ns, u);
-	} else
-		fl->uid = inode->i_uid;
-	fl->gid = inode->i_gid;
+	fl->uid = from_kuid_munged(userns, inode->i_uid);
+	fl->gid = from_kgid_munged(userns, inode->i_gid);
+
+	/*
+	 * Do not allow an IOMODE_READ segment to have write permissions.
+	 * The group is left intact so group-readable files stay readable;
+	 * nfsd_setuser() squashes an unmapped uid to the export's anon ID.
+	 */
+	if (seg->iomode == IOMODE_READ)
+		fl->uid++;
 
 	error = nfsd4_set_deviceid(&fl->deviceid, fhp, device_generation);
 	if (error)
diff --git a/fs/nfsd/flexfilelayoutxdr.c b/fs/nfsd/flexfilelayoutxdr.c
index c05d1d3e20210..4bfdfee1bf9ce 100644
--- a/fs/nfsd/flexfilelayoutxdr.c
+++ b/fs/nfsd/flexfilelayoutxdr.c
@@ -32,8 +32,8 @@ nfsd4_ff_encode_layoutget(struct xdr_stream *xdr,
 
 	fh_len = 4 + xdr_align_size(fl->fh.size);
 
-	uid.len = sprintf(uid.buf, "%u", from_kuid(&init_user_ns, fl->uid));
-	gid.len = sprintf(gid.buf, "%u", from_kgid(&init_user_ns, fl->gid));
+	uid.len = sprintf(uid.buf, "%u", fl->uid);
+	gid.len = sprintf(gid.buf, "%u", fl->gid);
 
 	/* data server entry: deviceid + efficiency + stateid + fh list +
 	 * user + group + flags + stats_collect_hint
diff --git a/fs/nfsd/flexfilelayoutxdr.h b/fs/nfsd/flexfilelayoutxdr.h
index 8e195aeca0237..3e2dc4d070f8d 100644
--- a/fs/nfsd/flexfilelayoutxdr.h
+++ b/fs/nfsd/flexfilelayoutxdr.h
@@ -35,8 +35,9 @@ struct pnfs_ff_device_addr {
 struct pnfs_ff_layout {
 	u32				flags;
 	u32				stats_collect_hint;
-	kuid_t				uid;
-	kgid_t				gid;
+	/* Values to encode; nfsd4_ff_proc_layoutget() has mapped these */
+	u32				uid;
+	u32				gid;
 	struct nfsd4_deviceid		deviceid;
 	stateid_t			stateid;
 	struct nfs_fh			fh;
diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 3af22badd70f5..9bad4740101fa 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -2260,7 +2260,7 @@ nfsd4_layoutget(struct svc_rqst *rqstp,
 	if (atomic_read(&ls->ls_stid.sc_file->fi_lo_recalls))
 		goto out_put_stid;
 
-	nfserr = ops->proc_layoutget(d_inode(current_fh->fh_dentry),
+	nfserr = ops->proc_layoutget(rqstp, d_inode(current_fh->fh_dentry),
 				     current_fh, lgp);
 	if (nfserr)
 		goto out_put_stid;
diff --git a/fs/nfsd/pnfs.h b/fs/nfsd/pnfs.h
index 4f4282d4eeca4..c29de1795b2cb 100644
--- a/fs/nfsd/pnfs.h
+++ b/fs/nfsd/pnfs.h
@@ -29,8 +29,8 @@ struct nfsd4_layout_ops {
 	__be32 (*encode_getdeviceinfo)(struct xdr_stream *xdr,
 			struct nfsd4_getdeviceinfo *gdevp);
 
-	__be32 (*proc_layoutget)(struct inode *, const struct svc_fh *fhp,
-			struct nfsd4_layoutget *lgp);
+	__be32 (*proc_layoutget)(struct svc_rqst *rqstp, struct inode *inode,
+			const struct svc_fh *fhp, struct nfsd4_layoutget *lgp);
 	__be32 (*encode_layoutget)(struct xdr_stream *,
 			struct nfsd4_layoutget *lgp);
 
-- 
2.53.0



