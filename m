Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619985;
	b=T9EjlYSv8Q7mHCtdcsoo4HlcobMyhpioeK9O1xUVq848t68vp5M53kD8nO2xh0mvMgjK
	 lKd2uNsGsUnEoJNSPLGvkveZloFEMrZeYfflzvQBNJTi6tEyUZufeOPU/S7ZbhZxxTrRn
	 w9X4zeooLSiZ78P4eDiROGu3xaAqHXQgcZqyu1UJv1VlEbHZ5wossJugSrJKmvKBJegSV
	 7qXnpMMzlGg/ZsYfLipDJF19AAIOeVluCI/+UnzfBlzqKptCOWfJv7XTHNYmnKYQ0fIMP
	 SEeN8oM65tGsuLVa4DjZfkXuvsw6z/X0MxPJB47NGl4y9ZAsHa7fymdhKenOd3p041w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619985;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=F/PI5GczkVc5ECTrVGnxfaXkRAq9zDDp0ATEAiVQDfM=;
	b=YdmY0dui+sEHxZhTsCEShU72pyEJC4Nl9oQUwtL8ucAhl4CbQnhDLT5S7IBD0Mlvaqsl
	 VVO8bS1E9WcHFwLQVpR3mg7SwvKIO0sV0lka2E5mKlvGInJy9nCZuD3PXUO8VjtHDzZ7J
	 2xENfVwFzxeT/FnPSvp+hPSLLh6oYrTMx0fJLssNPM3o3Fnza8gJuGvarmyTxIfeNPO9B
	 ciVeLU7SDCLwpD/k0QDPkrQ4GeU+ttZMpdo/eCVJwoDhZFaBnw2XI1rEsfA6uU7hMfcjP
	 /2h7qifLVoq511fXMtGiMRAZSfTTDk2TTn10XjqJ7vU3b1PDLC+WLMcUj9MAX2jMdYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EgLdgsOt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 958FB606A31E;
	Wed, 25 Nov 2026 15:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EgLdgsOt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC36F1F000C4;
	Wed, 25 Nov 2026 15:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619985;
	bh=F/PI5GczkVc5ECTrVGnxfaXkRAq9zDDp0ATEAiVQDfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EgLdgsOt8Ua2lKpr0OezhqxwbuXtcl/0e/fIz0J0B3UbE0+nq7ZKWcmLcMORK1Tl+
	 +94s5UNXjp513xUpJEdEG+Z1Ldf5uhL/kmYVEs450WeHsNT67/X8TrcBtn0GlEJ1nn
	 /0+V5oFwnOAB4drfcBP0VSNi4vo4hqIs6jsuRQYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Bridges <icb@fastmail.org>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 7.3 0770/1005] ksmbd: grant a caller what its groups and OWNER RIGHTS ACEs allow
Date: Wed, 25 Nov 2026 15:35:08 +0100
Message-ID: <20261125143839.783015410@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Bridges <icb@fastmail.org>

commit 42ac1f1917ae678ee2c47f415ab844af03bbd46b upstream.

smb_check_perm_dacl() does not match ACEs for the caller's Unix
groups and refuses an owner named only by OWNER RIGHTS. These callers
cannot use rights the DACL grants them under MS-DTYP 2.5.3.2.

Match Unix group SIDs (S-1-22-2) against the caller's credentials. Use
the ordered DACL result when the existing SID lookup and POSIX ACL
fallback do not decide access. In that result, deny ACEs for the
caller's groups limit what it grants, also for MAXIMUM_ALLOWED. Count
only the exact OWNER RIGHTS SID in that result, since compare_sids()
also matches shorter and longer SIDs, and return only file access
rights. Preserve the refusal for non-inherit-only object deny ACEs,
which ksmbd does not parse.

MAXIMUM_ALLOWED still excludes group allow ACEs. Including them
requires corresponding changes in smb2_open() to avoid breaking
existing opens. An open relying on group grants can therefore still
fail when it requests a maximal access reply. For the owner, that
reply leaves out the rights of its groups.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: Ian Bridges <icb@fastmail.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smbacl.c |  162 +++++++++++++++++++++++++++++++++++--------------
 1 file changed, 117 insertions(+), 45 deletions(-)

--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1452,6 +1452,35 @@ bool smb_inherit_flags(int flags, bool i
 	return false;
 }
 
+/* Whether the caller's credentials hold the group of an S-1-22-2-<gid> SID */
+static bool smb_sid_in_group(const struct smb_sid *sid)
+{
+	gid_t gid;
+
+	if (sid->num_subauth != sid_unix_groups.num_subauth + 1 ||
+	    compare_sids(sid, &sid_unix_groups))
+		return false;
+	gid = le32_to_cpu(sid->sub_auth[sid->num_subauth - 1]);
+	/*
+	 * ksmbd_override_fsids() builds the caller's credentials with
+	 * make_kgid(&init_user_ns, ...), so the group membership test must
+	 * compare in that space. Applying the mount idmap here (as when
+	 * resolving a SID to an on-disk gid) would mismatch on idmapped
+	 * mounts.
+	 */
+	return in_group_p(make_kgid(&init_user_ns, gid));
+}
+
+/*
+ * compare_sids() compares only the sub-authorities both SIDs have, so it
+ * also matches a shorter or longer SID, such as S-1-3 or S-1-3-4-777
+ */
+static bool smb_sid_is_owner_rights(const struct smb_sid *sid)
+{
+	return sid->num_subauth == sid_owner_rights.num_subauth &&
+	       !compare_sids(sid, &sid_owner_rights);
+}
+
 int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 			__le32 *pdaccess, __le32 raw_daccess, int uid,
 			bool strict)
@@ -1468,13 +1497,15 @@ int smb_check_perm_dacl(struct ksmbd_con
 	int granted = requested;
 	struct smb_ace *ace;
 	int i, found = 0;
-	unsigned int access_bits = 0, denied = 0;
+	unsigned int access_bits = 0, denied = 0, grp_granted = 0;
+	unsigned int grp_allowed = 0, grp_denied = 0, bits;
 	struct smb_ace *others_ace = NULL;
-	bool or_ace = false;
+	bool or_ace = false, obj_deny = false, member, counted;
 	struct posix_acl_entry *pa_entry;
 	unsigned int sid_type = SIDOWNER;
 	unsigned short ace_size;
 	bool is_owner, owner_rights = false;
+	bool maximal = *pdaccess & FILE_MAXIMAL_ACCESS_LE;
 	vfsuid_t vfsuid;
 
 	ksmbd_debug(SMB, "check permission using windows acl\n");
@@ -1515,7 +1546,7 @@ int smb_check_perm_dacl(struct ksmbd_con
 		 */
 		if (is_owner)
 			allowed = READ_CONTROL | WRITE_DAC;
-		if (*pdaccess & FILE_MAXIMAL_ACCESS_LE)
+		if (maximal)
 			requested |= allowed;
 		if (!allowed || requested & ~allowed)
 			rc = -EACCES;
@@ -1524,53 +1555,83 @@ int smb_check_perm_dacl(struct ksmbd_con
 		goto err_out;
 	}
 
-	if (*pdaccess & FILE_MAXIMAL_ACCESS_LE) {
-		ace = (struct smb_ace *)((char *)pdacl + sizeof(struct smb_acl));
-		aces_size = pdacl_size - sizeof(struct smb_acl);
-		for (i = 0; i < le16_to_cpu(pdacl->num_aces); i++) {
-			if (aces_size < offsetof(struct smb_ace, sid) +
-			    CIFS_SID_BASE_SIZE)
-				break;
-			ace_size = le16_to_cpu(ace->size);
-			if (ace_size > aces_size ||
-			    ace_size < offsetof(struct smb_ace, sid) +
-				       CIFS_SID_BASE_SIZE)
-				break;
-			aces_size -= ace_size;
+	/*
+	 * Evaluate the DACL in order (MS-DTYP 2.5.3.2). access_bits collects
+	 * the MAXIMUM_ALLOWED result. grp_granted collects what ACEs for the
+	 * caller's groups, or OWNER RIGHTS for the owner, grant. It is used
+	 * when the SID lookup and POSIX ACL fallback below do not decide.
+	 */
+	ace = (struct smb_ace *)((char *)pdacl + sizeof(struct smb_acl));
+	aces_size = pdacl_size - sizeof(struct smb_acl);
+	for (i = 0; i < le16_to_cpu(pdacl->num_aces); i++) {
+		if (aces_size < offsetof(struct smb_ace, sid) +
+		    CIFS_SID_BASE_SIZE)
+			break;
+		ace_size = le16_to_cpu(ace->size);
+		if (ace_size > aces_size ||
+		    ace_size < offsetof(struct smb_ace, sid) +
+			       CIFS_SID_BASE_SIZE)
+			break;
+		aces_size -= ace_size;
 
-			if (ace->sid.num_subauth > SID_MAX_SUB_AUTHORITIES ||
-			    ace_size < offsetof(struct smb_ace, sid) +
-				      CIFS_SID_BASE_SIZE +
-				      sizeof(__le32) * ace->sid.num_subauth)
-				break;
+		if (ace->sid.num_subauth > SID_MAX_SUB_AUTHORITIES ||
+		    ace_size < offsetof(struct smb_ace, sid) +
+			      CIFS_SID_BASE_SIZE +
+			      sizeof(__le32) * ace->sid.num_subauth)
+			break;
 
-			if (!compare_sids(&sid_owner_rights, &ace->sid)) {
-				owner_rights = true;
-				if (!is_owner)
-					goto next_ace;
-			}
+		if ((ace->type == ACCESS_DENIED_OBJECT_ACE_TYPE ||
+		     ace->type == ACCESS_DENIED_CALLBACK_OBJECT_ACE_TYPE) &&
+		    !(ace->flags & INHERIT_ONLY_ACE))
+			obj_deny = true;
 
-			if (ace->flags & INHERIT_ONLY_ACE ||
-			    (compare_sids(&sid, &ace->sid) &&
-			     compare_sids(&sid_unix_NFS_mode, &ace->sid) &&
-			     compare_sids(&sid_everyone, &ace->sid) &&
-			     compare_sids(&sid_authusers, &ace->sid) &&
-			     compare_sids(&sid_owner_rights, &ace->sid)))
+		if (!compare_sids(&sid_owner_rights, &ace->sid)) {
+			owner_rights = true;
+			if (!is_owner)
 				goto next_ace;
+		}
 
-			switch (ace->type) {
-			case ACCESS_ALLOWED_ACE_TYPE:
-				access_bits |= le32_to_cpu(ace->access_req);
-				break;
-			case ACCESS_DENIED_ACE_TYPE:
-			case ACCESS_DENIED_CALLBACK_ACE_TYPE:
-				denied |= ~access_bits &
-					le32_to_cpu(ace->access_req);
+		member = smb_sid_in_group(&ace->sid);
+		/* The grp_ masks count groups and OWNER RIGHTS only */
+		counted = member ||
+			  (is_owner && smb_sid_is_owner_rights(&ace->sid));
+		if (ace->flags & INHERIT_ONLY_ACE ||
+		    (compare_sids(&sid, &ace->sid) &&
+		     compare_sids(&sid_unix_NFS_mode, &ace->sid) &&
+		     compare_sids(&sid_everyone, &ace->sid) &&
+		     compare_sids(&sid_authusers, &ace->sid) &&
+		     compare_sids(&sid_owner_rights, &ace->sid) &&
+		     !member))
+			goto next_ace;
+
+		bits = le32_to_cpu(ace->access_req);
+		switch (ace->type) {
+		case ACCESS_ALLOWED_ACE_TYPE:
+			if (counted)
+				grp_allowed |= bits;
+			/* MAXIMUM_ALLOWED takes no group grants */
+			if (maximal && member)
 				break;
-			}
-next_ace:
-			ace = (struct smb_ace *)((char *)ace + le16_to_cpu(ace->size));
+			if (counted)
+				grp_granted |= bits;
+			access_bits |= bits;
+			break;
+		case ACCESS_DENIED_ACE_TYPE:
+		case ACCESS_DENIED_CALLBACK_ACE_TYPE:
+			if (counted)
+				grp_denied |= ~grp_allowed & bits;
+			/* access_bits takes no group denials either */
+			if (!member)
+				denied |= ~access_bits & bits;
+			break;
 		}
+next_ace:
+		ace = (struct smb_ace *)((char *)ace + le16_to_cpu(ace->size));
+	}
+
+	/* Keep only file rights, not MAXIMUM_ALLOWED or generic bits */
+	grp_granted &= GENERIC_ALL_FLAGS & ~grp_denied;
+	if (maximal) {
 		if (is_owner && !owner_rights)
 			access_bits |= READ_CONTROL | WRITE_DAC |
 				FILE_READ_ATTRIBUTES | DELETE;
@@ -1580,6 +1641,9 @@ next_ace:
 		    (access_bits & GENERIC_READ_FLAGS) == GENERIC_READ_FLAGS)
 			access_bits |= FILE_EXECUTE;
 		granted = requested | access_bits;
+	} else {
+		/* An explicit request uses only grp_granted and obj_deny */
+		access_bits = 0;
 	}
 
 	ace = (struct smb_ace *)((char *)pdacl + sizeof(struct smb_acl));
@@ -1661,7 +1725,15 @@ next_ace:
 			 */
 			if (is_owner && !or_ace)
 				allowed = READ_CONTROL | WRITE_DAC;
-			if (*pdaccess & FILE_MAXIMAL_ACCESS_LE)
+			/*
+			 * Add what ACEs for the caller's groups, or OWNER
+			 * RIGHTS for the owner, grant in DACL order, unless an
+			 * object deny ACE, which ksmbd does not parse, could
+			 * apply.
+			 */
+			if (!obj_deny)
+				allowed |= grp_granted;
+			if (maximal)
 				requested |= allowed;
 			if (!allowed || requested & ~allowed) {
 				ksmbd_debug(SMB, "Can't find corresponding sid\n");
@@ -1673,7 +1745,7 @@ next_ace:
 		}
 	}
 
-	if (!(*pdaccess & FILE_MAXIMAL_ACCESS_LE)) {
+	if (!maximal) {
 		switch (ace->type) {
 		case ACCESS_ALLOWED_ACE_TYPE:
 			access_bits = le32_to_cpu(ace->access_req);


