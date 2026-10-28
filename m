Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216874;
	b=rlQ2vfWiyzSdnY1ZMozrJXiZPl9PQdGDdYAJjqQ8gJw85CIQ0rpaeMCJN0UwpJzLtQZV
	 n+8+Ni/bNFAu1tLcucnMA0MClAqVAxKlVY1tG+bdeArA2TmYC1TCykJNqSt8/I5vW2ZTO
	 lD7p5d12NLEFlOjEWaDE/KwcVFWTbzKynuK+nc+t0iWRDS9hPk3wr5wDYUPYfu7frQmkw
	 jbapc0R+2/ad3hztOTLWNtAykAFa3xpONrppUpr+mIHtS7K/WcohwQNAb4BQxoTKD6vZj
	 ymvabYNGKTOfvcDD7xoBccuQKv0mb7NFtGSQrIiRhAaPYuAdvm02y8zDylsxZCDCyag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216874;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7FmytTKfq1UNzm8mWitMkEq4FSmyOJr0ntkYXEftigQ=;
	b=X6TdsgEqP+GJL2i8Lqv4BnVN4E0TvnM2477Of9WcvFmG2s4ICI78Bn8c23DkuIDqE6+D
	 H5H3jL/7/A5BEp0ZbN+qrDmSUnAO9C7x6T8jV752CzY6wE/Hf2bwrhvWLqBOj4qMg2puu
	 4gw8BPgqXYFczjlPPQ8lTJ1+AuRJba/pb3En1dxxIV0cJ33egLmaFjjEZDSoAAF3vmcnN
	 CKLXL4H4BEvK1KKLr6gZ/+IKPdJoxt/m3L8FBNRPNWLAqdd2gYGAr8N9CklLyMDEgaSGl
	 laf0L2KDWwCr/zVCo/GO4MJy8uRsqoYH9KBpGUaJ82U33cKFXYnr5iQpUYO2ByiXfpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BGP409aS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CBFB606A31A;
	Wed, 28 Oct 2026 19:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BGP409aS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 634C91F01825;
	Wed, 28 Oct 2026 19:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216873;
	bh=7FmytTKfq1UNzm8mWitMkEq4FSmyOJr0ntkYXEftigQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BGP409aS5tiiR3QN1XPxE48LoLBznYV/LhGLBZKcIFTEftRS9gZPkcUalOjPkdlfj
	 Koc/7WOuiz15FBfKzVJ5SHC1yEzKL7OaQYpQqVQCaLPBBuH4QcYcWO2R4DAtQJnfNn
	 2/2vCSzb0oish+F7gaT0onPsBKK/nVqRzhGuNxOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1692/1887] smb: client: honor forceuid/forcegid when mapping SIDs to uid/gid
Date: Wed, 28 Oct 2026 18:03:08 +0100
Message-ID: <20261028170537.959726627@linuxfoundation.org>
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

From: Paulo Alcantara <pc@manguebit.org>

[ Upstream commit 18a72975e9f35aadecc75b031f693f2d1f49308f ]

When the administrator mounts with forceuid or forcegid (uid=/gid=
mount options), they expect all files to appear owned by the specified
user/group.  However, several code paths unconditionally called
sid_to_id() to overwrite cf_uid/cf_gid with server-provided values,
ignoring the administrator's explicit override:

  - smb311_posix_info_to_fattr() (stat via POSIX extensions)
  - cifs_posix_to_fattr() (readdir via POSIX extensions)
  - parse_sec_desc() (CIFS ACL ownership mapping)

This allowed an untrusted server to dictate local file ownership even
when the mount was configured to force specific uid/gid values.

Fix all three call sites to check CIFS_MOUNT_OVERR_UID and
CIFS_MOUNT_OVERR_GID before calling sid_to_id(), following the
same pattern already used by cifs_unix_basic_to_fattr() for unix
extensions.

Closes: https://sashiko.dev/#/patchset/20260906155816.603278-1-pc%40manguebit.org
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsacl.c | 28 ++++++++++++++++++----------
 fs/smb/client/readdir.c |  7 +++++--
 2 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/fs/smb/client/cifsacl.c b/fs/smb/client/cifsacl.c
index ba93199ef7327..7bb35cdbc4d67 100644
--- a/fs/smb/client/cifsacl.c
+++ b/fs/smb/client/cifsacl.c
@@ -1300,6 +1300,7 @@ static int parse_sec_desc(struct cifs_sb_info *cifs_sb,
 {
 	int rc = 0;
 	struct cifs_sid *owner_sid_ptr, *group_sid_ptr;
+	unsigned int sbflags = cifs_sb->mnt_cifs_flags;
 	struct cifs_acl *dacl_ptr; /* no need for SACL ptr */
 	char *end_of_acl = ((char *)pntsd) + acl_len;
 	__u32 dacloffset;
@@ -1316,17 +1317,22 @@ static int parse_sec_desc(struct cifs_sb_info *cifs_sb,
 		 pntsd->revision, pntsd->type, le32_to_cpu(pntsd->osidoffset),
 		 le32_to_cpu(pntsd->gsidoffset),
 		 le32_to_cpu(pntsd->sacloffset), dacloffset);
+	fattr->cf_uid = cifs_sb->ctx->linux_uid;
+	fattr->cf_gid = cifs_sb->ctx->linux_gid;
+
 /*	cifs_dump_mem("owner_sid: ", owner_sid_ptr, 64); */
 	rc = parse_sid(owner_sid_ptr, end_of_acl);
 	if (rc) {
 		cifs_dbg(FYI, "%s: Error %d parsing Owner SID\n", __func__, rc);
 		return rc;
 	}
-	rc = sid_to_id(cifs_sb, owner_sid_ptr, fattr, SIDOWNER);
-	if (rc) {
-		cifs_dbg(FYI, "%s: Error %d mapping Owner SID to uid\n",
-			 __func__, rc);
-		return rc;
+	if (!(sbflags & CIFS_MOUNT_OVERR_UID)) {
+		rc = sid_to_id(cifs_sb, owner_sid_ptr, fattr, SIDOWNER);
+		if (rc) {
+			cifs_dbg(FYI, "%s: Error %d mapping Owner SID to uid\n",
+				 __func__, rc);
+			return rc;
+		}
 	}
 
 	rc = parse_sid(group_sid_ptr, end_of_acl);
@@ -1335,11 +1341,13 @@ static int parse_sec_desc(struct cifs_sb_info *cifs_sb,
 			 __func__, rc);
 		return rc;
 	}
-	rc = sid_to_id(cifs_sb, group_sid_ptr, fattr, SIDGROUP);
-	if (rc) {
-		cifs_dbg(FYI, "%s: Error %d mapping Group SID to gid\n",
-			 __func__, rc);
-		return rc;
+	if (!(sbflags & CIFS_MOUNT_OVERR_GID)) {
+		rc = sid_to_id(cifs_sb, group_sid_ptr, fattr, SIDGROUP);
+		if (rc) {
+			cifs_dbg(FYI, "%s: Error %d mapping Group SID to gid\n",
+				 __func__, rc);
+			return rc;
+		}
 	}
 
 	if (dacloffset) {
diff --git a/fs/smb/client/readdir.c b/fs/smb/client/readdir.c
index ded9cf784c22d..1ba176a690cc3 100644
--- a/fs/smb/client/readdir.c
+++ b/fs/smb/client/readdir.c
@@ -233,6 +233,7 @@ static void
 cifs_posix_to_fattr(struct cifs_fattr *fattr, struct smb2_posix_info *info,
 		    struct cifs_sb_info *cifs_sb)
 {
+	unsigned int sbflags = cifs_sb->mnt_cifs_flags;
 	struct smb2_posix_info_parsed parsed;
 	int rc;
 
@@ -284,8 +285,10 @@ cifs_posix_to_fattr(struct cifs_fattr *fattr, struct smb2_posix_info *info,
 		cifs_dbg(VFS, "%s: failed to parse SIDs: %d\n",
 			 __func__, rc);
 	} else {
-		sid_to_id(cifs_sb, &parsed.owner, fattr, SIDOWNER);
-		sid_to_id(cifs_sb, &parsed.group, fattr, SIDGROUP);
+		if (!(sbflags & CIFS_MOUNT_OVERR_UID))
+			sid_to_id(cifs_sb, &parsed.owner, fattr, SIDOWNER);
+		if (!(sbflags & CIFS_MOUNT_OVERR_GID))
+			sid_to_id(cifs_sb, &parsed.group, fattr, SIDGROUP);
 	}
 }
 
-- 
2.53.0



