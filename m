Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BEA43C9896;
	Fri, 15 May 2026 16:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861527; cv=none; b=XyugemGhxbQaobt9JO9vMJsBwTx5G0FF0r7X00TBrDz/NBMbH5OpIvSFPSDenNrI5hBYWi9LvyPnItXRW0x1yucryp1+zxTuPaViru/X9AgKSTqq3jH5b4kjKE6pYiFNRoIl8cuc5vdFrvJTAFQFscGdfF5Rk1GcsX+V2cHZAOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861527; c=relaxed/simple;
	bh=NUmct7xirwCntrqYIRuY4Ikf32eNe5EEkxEXApFjpaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ob8DckrKIpITkRXv8IvYBDi4VJkzU5IyftOkzvRulUfQ/Nhe/W7OwXa9OaqUXeqPIPBK1dOtfXvqmA5BsqX15q6AxYnFszQbKx0Isfl8yKiSYsnnXihDfHr6UhZCtfEXoej6xS/xCgh//S2uu/BnQ5nKCrTX+0FHQ/6w4Gi384s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TiL6rN9v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TiL6rN9v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ABF9C2BCB0;
	Fri, 15 May 2026 16:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861527;
	bh=NUmct7xirwCntrqYIRuY4Ikf32eNe5EEkxEXApFjpaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TiL6rN9v4UhcQLjbCA47wm9NuYQIRmC/d3+UGcYAstsDaG7RsbTJSrp+EE/RtAxlA
	 4vLCiu3zRsRPkJwH9RvEe1qxRER3zQa5TDJDnjJKTu/RlQKKA/FiPlK5b7/lSQsIEU
	 ER6nQEW2VNpr/XTPkv5MWpKK6zguyiNYTL5MKud0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Leite Ladessa <igor-ladessa@hotmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 363/474] smb: common: change the data type of num_aces to le16
Date: Fri, 15 May 2026 17:47:52 +0200
Message-ID: <20260515154722.873416518@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 62e7dd0a39c2d0d7ff03274c36df971f1b3d2d0d ]

2.4.5 in [MS-DTYP].pdf describe the data type of num_aces as le16.

AceCount (2 bytes): An unsigned 16-bit integer that specifies the count
of the number of ACE records in the ACL.

Change it to le16 and add reserved field to smb_acl struct.

Reported-by: Igor Leite Ladessa <igor-ladessa@hotmail.com>
Tested-by: Igor Leite Ladessa <igor-ladessa@hotmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: d07b26f39246 ("ksmbd: require minimum ACE size in smb_check_perm_dacl()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifsacl.c |   26 +++++++++++++-------------
 fs/smb/common/smbacl.h  |    3 ++-
 fs/smb/server/smbacl.c  |   31 ++++++++++++++++---------------
 fs/smb/server/smbacl.h  |    2 +-
 4 files changed, 32 insertions(+), 30 deletions(-)

--- a/fs/smb/client/cifsacl.c
+++ b/fs/smb/client/cifsacl.c
@@ -763,7 +763,7 @@ static void parse_dacl(struct smb_acl *p
 		       struct cifs_fattr *fattr, bool mode_from_special_sid)
 {
 	int i;
-	int num_aces = 0;
+	u16 num_aces = 0;
 	int acl_size;
 	char *acl_base;
 	struct smb_ace **ppace;
@@ -786,7 +786,7 @@ static void parse_dacl(struct smb_acl *p
 
 	cifs_dbg(NOISY, "DACL revision %d size %d num aces %d\n",
 		 le16_to_cpu(pdacl->revision), le16_to_cpu(pdacl->size),
-		 le32_to_cpu(pdacl->num_aces));
+		 le16_to_cpu(pdacl->num_aces));
 
 	/* reset rwx permissions for user/group/other.
 	   Also, if num_aces is 0 i.e. DACL has no ACEs,
@@ -796,7 +796,7 @@ static void parse_dacl(struct smb_acl *p
 	acl_base = (char *)pdacl;
 	acl_size = sizeof(struct smb_acl);
 
-	num_aces = le32_to_cpu(pdacl->num_aces);
+	num_aces = le16_to_cpu(pdacl->num_aces);
 	if (num_aces > 0) {
 		umode_t denied_mode = 0;
 
@@ -957,12 +957,12 @@ unsigned int setup_special_user_owner_AC
 static void populate_new_aces(char *nacl_base,
 		struct smb_sid *pownersid,
 		struct smb_sid *pgrpsid,
-		__u64 *pnmode, u32 *pnum_aces, u16 *pnsize,
+		__u64 *pnmode, u16 *pnum_aces, u16 *pnsize,
 		bool modefromsid,
 		bool posix)
 {
 	__u64 nmode;
-	u32 num_aces = 0;
+	u16 num_aces = 0;
 	u16 nsize = 0;
 	__u64 user_mode;
 	__u64 group_mode;
@@ -1070,7 +1070,7 @@ static __u16 replace_sids_and_copy_aces(
 	u16 size = 0;
 	struct smb_ace *pntace = NULL;
 	char *acl_base = NULL;
-	u32 src_num_aces = 0;
+	u16 src_num_aces = 0;
 	u16 nsize = 0;
 	struct smb_ace *pnntace = NULL;
 	char *nacl_base = NULL;
@@ -1078,7 +1078,7 @@ static __u16 replace_sids_and_copy_aces(
 
 	acl_base = (char *)pdacl;
 	size = sizeof(struct smb_acl);
-	src_num_aces = le32_to_cpu(pdacl->num_aces);
+	src_num_aces = le16_to_cpu(pdacl->num_aces);
 
 	nacl_base = (char *)pndacl;
 	nsize = sizeof(struct smb_acl);
@@ -1110,11 +1110,11 @@ static int set_chmod_dacl(struct smb_acl
 	u16 size = 0;
 	struct smb_ace *pntace = NULL;
 	char *acl_base = NULL;
-	u32 src_num_aces = 0;
+	u16 src_num_aces = 0;
 	u16 nsize = 0;
 	struct smb_ace *pnntace = NULL;
 	char *nacl_base = NULL;
-	u32 num_aces = 0;
+	u16 num_aces = 0;
 	bool new_aces_set = false;
 
 	/* Assuming that pndacl and pnmode are never NULL */
@@ -1132,7 +1132,7 @@ static int set_chmod_dacl(struct smb_acl
 
 	acl_base = (char *)pdacl;
 	size = sizeof(struct smb_acl);
-	src_num_aces = le32_to_cpu(pdacl->num_aces);
+	src_num_aces = le16_to_cpu(pdacl->num_aces);
 
 	/* Retain old ACEs which we can retain */
 	for (i = 0; i < src_num_aces; ++i) {
@@ -1178,7 +1178,7 @@ next_ace:
 	}
 
 finalize_dacl:
-	pndacl->num_aces = cpu_to_le32(num_aces);
+	pndacl->num_aces = cpu_to_le16(num_aces);
 	pndacl->size = cpu_to_le16(nsize);
 
 	return 0;
@@ -1335,7 +1335,7 @@ static int build_sec_desc(struct smb_nts
 			dacloffset ? dacl_ptr->revision : cpu_to_le16(ACL_REVISION);
 
 		ndacl_ptr->size = cpu_to_le16(0);
-		ndacl_ptr->num_aces = cpu_to_le32(0);
+		ndacl_ptr->num_aces = cpu_to_le16(0);
 
 		rc = set_chmod_dacl(dacl_ptr, ndacl_ptr, owner_sid_ptr, group_sid_ptr,
 				    pnmode, mode_from_sid, posix);
@@ -1699,7 +1699,7 @@ id_mode_to_cifs_acl(struct inode *inode,
 			dacl_ptr = (struct smb_acl *)((char *)pntsd + dacloffset);
 			if (mode_from_sid)
 				nsecdesclen +=
-					le32_to_cpu(dacl_ptr->num_aces) * sizeof(struct smb_ace);
+					le16_to_cpu(dacl_ptr->num_aces) * sizeof(struct smb_ace);
 			else /* cifsacl */
 				nsecdesclen += le16_to_cpu(dacl_ptr->size);
 		}
--- a/fs/smb/common/smbacl.h
+++ b/fs/smb/common/smbacl.h
@@ -107,7 +107,8 @@ struct smb_sid {
 struct smb_acl {
 	__le16 revision; /* revision level */
 	__le16 size;
-	__le32 num_aces;
+	__le16 num_aces;
+	__le16 reserved;
 } __attribute__((packed));
 
 struct smb_ace {
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -338,7 +338,7 @@ void posix_state_to_acl(struct posix_acl
 	pace->e_perm = state->other.allow;
 }
 
-int init_acl_state(struct posix_acl_state *state, int cnt)
+int init_acl_state(struct posix_acl_state *state, u16 cnt)
 {
 	int alloc;
 
@@ -373,7 +373,7 @@ static void parse_dacl(struct mnt_idmap
 		       struct smb_fattr *fattr)
 {
 	int i, ret;
-	int num_aces = 0;
+	u16 num_aces = 0;
 	unsigned int acl_size;
 	char *acl_base;
 	struct smb_ace **ppace;
@@ -394,12 +394,12 @@ static void parse_dacl(struct mnt_idmap
 
 	ksmbd_debug(SMB, "DACL revision %d size %d num aces %d\n",
 		    le16_to_cpu(pdacl->revision), le16_to_cpu(pdacl->size),
-		    le32_to_cpu(pdacl->num_aces));
+		    le16_to_cpu(pdacl->num_aces));
 
 	acl_base = (char *)pdacl;
 	acl_size = sizeof(struct smb_acl);
 
-	num_aces = le32_to_cpu(pdacl->num_aces);
+	num_aces = le16_to_cpu(pdacl->num_aces);
 	if (num_aces <= 0)
 		return;
 
@@ -589,7 +589,7 @@ static void parse_dacl(struct mnt_idmap
 
 static void set_posix_acl_entries_dacl(struct mnt_idmap *idmap,
 				       struct smb_ace *pndace,
-				       struct smb_fattr *fattr, u32 *num_aces,
+				       struct smb_fattr *fattr, u16 *num_aces,
 				       u16 *size, u32 nt_aces_num)
 {
 	struct posix_acl_entry *pace;
@@ -717,7 +717,7 @@ static void set_ntacl_dacl(struct mnt_id
 			   struct smb_fattr *fattr)
 {
 	struct smb_ace *ntace, *pndace;
-	int nt_num_aces = le32_to_cpu(nt_dacl->num_aces), num_aces = 0;
+	u16 nt_num_aces = le16_to_cpu(nt_dacl->num_aces), num_aces = 0;
 	unsigned short size = 0;
 	int i;
 
@@ -745,7 +745,7 @@ static void set_ntacl_dacl(struct mnt_id
 
 	set_posix_acl_entries_dacl(idmap, pndace, fattr,
 				   &num_aces, &size, nt_num_aces);
-	pndacl->num_aces = cpu_to_le32(num_aces);
+	pndacl->num_aces = cpu_to_le16(num_aces);
 	pndacl->size = cpu_to_le16(le16_to_cpu(pndacl->size) + size);
 }
 
@@ -753,7 +753,7 @@ static void set_mode_dacl(struct mnt_idm
 			  struct smb_acl *pndacl, struct smb_fattr *fattr)
 {
 	struct smb_ace *pace, *pndace;
-	u32 num_aces = 0;
+	u16 num_aces = 0;
 	u16 size = 0, ace_size = 0;
 	uid_t uid;
 	const struct smb_sid *sid;
@@ -809,7 +809,7 @@ static void set_mode_dacl(struct mnt_idm
 				 fattr->cf_mode, 0007);
 
 out:
-	pndacl->num_aces = cpu_to_le32(num_aces);
+	pndacl->num_aces = cpu_to_le16(num_aces);
 	pndacl->size = cpu_to_le16(le16_to_cpu(pndacl->size) + size);
 }
 
@@ -1039,8 +1039,9 @@ int smb_inherit_dacl(struct ksmbd_conn *
 	struct smb_sid owner_sid, group_sid;
 	struct dentry *parent = path->dentry->d_parent;
 	struct mnt_idmap *idmap = mnt_idmap(path->mnt);
-	int inherited_flags = 0, flags = 0, i, ace_cnt = 0, nt_size = 0, pdacl_size;
-	int rc = 0, num_aces, dacloffset, pntsd_type, pntsd_size, acl_len, aces_size;
+	int inherited_flags = 0, flags = 0, i, nt_size = 0, pdacl_size;
+	int rc = 0, dacloffset, pntsd_type, pntsd_size, acl_len, aces_size;
+	u16 num_aces, ace_cnt = 0;
 	char *aces_base;
 	bool is_dir = S_ISDIR(d_inode(path->dentry)->i_mode);
 
@@ -1056,7 +1057,7 @@ int smb_inherit_dacl(struct ksmbd_conn *
 
 	parent_pdacl = (struct smb_acl *)((char *)parent_pntsd + dacloffset);
 	acl_len = pntsd_size - dacloffset;
-	num_aces = le32_to_cpu(parent_pdacl->num_aces);
+	num_aces = le16_to_cpu(parent_pdacl->num_aces);
 	pntsd_type = le16_to_cpu(parent_pntsd->type);
 	pdacl_size = le16_to_cpu(parent_pdacl->size);
 
@@ -1215,7 +1216,7 @@ pass:
 			pdacl = (struct smb_acl *)((char *)pntsd + le32_to_cpu(pntsd->dacloffset));
 			pdacl->revision = cpu_to_le16(2);
 			pdacl->size = cpu_to_le16(sizeof(struct smb_acl) + nt_size);
-			pdacl->num_aces = cpu_to_le32(ace_cnt);
+			pdacl->num_aces = cpu_to_le16(ace_cnt);
 			pace = (struct smb_ace *)((char *)pdacl + sizeof(struct smb_acl));
 			memcpy(pace, aces_base, nt_size);
 			pntsd_size += sizeof(struct smb_acl) + nt_size;
@@ -1296,7 +1297,7 @@ int smb_check_perm_dacl(struct ksmbd_con
 
 		ace = (struct smb_ace *)((char *)pdacl + sizeof(struct smb_acl));
 		aces_size = acl_size - sizeof(struct smb_acl);
-		for (i = 0; i < le32_to_cpu(pdacl->num_aces); i++) {
+		for (i = 0; i < le16_to_cpu(pdacl->num_aces); i++) {
 			if (offsetof(struct smb_ace, access_req) > aces_size)
 				break;
 			ace_size = le16_to_cpu(ace->size);
@@ -1317,7 +1318,7 @@ int smb_check_perm_dacl(struct ksmbd_con
 
 	ace = (struct smb_ace *)((char *)pdacl + sizeof(struct smb_acl));
 	aces_size = acl_size - sizeof(struct smb_acl);
-	for (i = 0; i < le32_to_cpu(pdacl->num_aces); i++) {
+	for (i = 0; i < le16_to_cpu(pdacl->num_aces); i++) {
 		if (offsetof(struct smb_ace, access_req) > aces_size)
 			break;
 		ace_size = le16_to_cpu(ace->size);
--- a/fs/smb/server/smbacl.h
+++ b/fs/smb/server/smbacl.h
@@ -86,7 +86,7 @@ int parse_sec_desc(struct mnt_idmap *idm
 int build_sec_desc(struct mnt_idmap *idmap, struct smb_ntsd *pntsd,
 		   struct smb_ntsd *ppntsd, int ppntsd_size, int addition_info,
 		   __u32 *secdesclen, struct smb_fattr *fattr);
-int init_acl_state(struct posix_acl_state *state, int cnt);
+int init_acl_state(struct posix_acl_state *state, u16 cnt);
 void free_acl_state(struct posix_acl_state *state);
 void posix_state_to_acl(struct posix_acl_state *state,
 			struct posix_acl_entry *pace);


