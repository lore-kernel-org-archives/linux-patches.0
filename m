Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214901;
	b=NHwmC36+b8S5RP//1FYMU0GE0f4pEcPKoqUg2CuJGMSfnQU5eF3Thsp//CLXRunR8l6x
	 1iCN7nG2hMPhU4jZCSH/4aJGosqbWL7Zakfa3Qth8gAztxpkcZYL7zvdk1SlBgShdRNgW
	 pcKdPLJllMDtUbmlRfQtg6yRPRNxw934gdNtSILQu6nsGlMLhiH5surEaovEa3A8lrE2C
	 enOEW1GJHbtWJAtvnW7k8VZq4NDYWT58vZfys44elUife7NzZ71vd/9TQ2z/1NyuT4xsn
	 Q7Qd1h6k4K7vGbY+ZPMVtVvdAcfUz0z/AkONYqu1xUK6Px8oLcWJZKzpKjerDBqAFow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214901;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6s6puFskJDceLHooS5i1Tg3T5xhC9c2Q5QMevwuVmM0=;
	b=lzZXL9HkFicTpV+32tRCigW4En82M2lsBviuZYLcmoA6naS8d532ChVBl0DAGg05S8EV
	 HpOUcp+zAIFiBKEZKZ4h0iFBBdcM1yJaPRjTIrC7u00Js44y9my7hUHp1njPYlkpDYMfR
	 SBjtNMAEmkHb++Q9aBPpGLeJUqWQ+9+vVOvxm0D4Ymp4C4X2Eth1KUd7kPz5EBRcBZAEf
	 jv3+2NCUYoCxfukpgS//0MaBCF1NZeP0n3qoqyiRARFI9ufbD748exz/R2m3p+5Sr7ye+
	 HZRIL0LsjrVbZOwTpBMzErkAX1T14+doPxZqz6WZ0Wc0KlKd5bA/NmW1pH7fIEWTsLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aZ3M5t+S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7E09606AB0E;
	Wed, 28 Oct 2026 19:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aZ3M5t+S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 343A91F01825;
	Wed, 28 Oct 2026 19:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214900;
	bh=6s6puFskJDceLHooS5i1Tg3T5xhC9c2Q5QMevwuVmM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aZ3M5t+SaGCr9sFDXhZSgd6WYNVOv/zkNmPtpvpcTqDddc4N4KYjiy6ctenqlHFCj
	 q7/2F+M8Y8SMeXkpb5PkKAPLicZGk45pqoSYwmwxuFxJPbgf6THKZZ4NAejJWYAWT8
	 c/TyarGm5L9OcfYW/ZKygtkEH6XCnizKIgDWKwKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shota Zaizen <s@zaizen.me>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1022/1887] ksmbd: validate inherited ACE SID length
Date: Wed, 28 Oct 2026 17:51:58 +0100
Message-ID: <20261028170522.673064148@linuxfoundation.org>
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

From: Shota Zaizen <s@zaizen.me>

[ Upstream commit 996454bc0da84d5a1dedb1a7861823087e01a7ae ]

smb_inherit_dacl() walks the parent directory DACL loaded from the
security descriptor xattr. It verifies that each ACE contains the fixed
SID header before using it, but does not verify that the variable-length
SID described by sid.num_subauth is fully contained in the ACE.

A malformed inheritable ACE can advertise more subauthorities than are
present in the ACE. compare_sids() may then read past the ACE.
smb_set_ace() also clamps the copied destination SID, but used the
unchecked source SID count to compute the inherited ACE size. That could
advance the temporary inherited ACE buffer pointer and nt_size accounting
past the allocated buffer.

Fix this by validating the parent ACE SID count and SID length before
using the SID during inheritance. Compute the inherited ACE size from the
copied SID so the size matches the bounded destination SID. Reject the
inherited DACL if size accumulation would overflow smb_acl.size or the
security descriptor allocation size.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Signed-off-by: Shota Zaizen <s@zaizen.me>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smbacl.c | 66 +++++++++++++++++++++++++++++++++---------
 1 file changed, 52 insertions(+), 14 deletions(-)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index fb48a504435d6..a338884d2115f 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1105,7 +1105,26 @@ static void smb_set_ace(struct smb_ace *ace, const struct smb_sid *sid, u8 type,
 	ace->flags = flags;
 	ace->access_req = access_req;
 	smb_copy_sid(&ace->sid, sid);
-	ace->size = cpu_to_le16(1 + 1 + 2 + 4 + 1 + 1 + 6 + (sid->num_subauth * 4));
+	ace->size = cpu_to_le16(1 + 1 + 2 + 4 + 1 + 1 + 6 +
+				(ace->sid.num_subauth * 4));
+}
+
+static int smb_append_inherited_ace(struct smb_ace **ace, int *nt_size,
+				    int *ace_cnt, const struct smb_sid *sid,
+				    u8 type, u8 flags, __le32 access_req)
+{
+	int ace_size;
+
+	smb_set_ace(*ace, sid, type, flags, access_req);
+	ace_size = le16_to_cpu((*ace)->size);
+	/* pdacl->size is __le16 and includes struct smb_acl. */
+	if (check_add_overflow(*nt_size, ace_size, nt_size) ||
+	    *nt_size > U16_MAX - (int)sizeof(struct smb_acl))
+		return -EINVAL;
+
+	(*ace_cnt)++;
+	*ace = (struct smb_ace *)((char *)*ace + ace_size);
+	return 0;
 }
 
 int smb_inherit_dacl(struct ksmbd_conn *conn,
@@ -1193,6 +1212,12 @@ int smb_inherit_dacl(struct ksmbd_conn *conn,
 				CIFS_SID_BASE_SIZE)
 			break;
 
+		if (parent_aces->sid.num_subauth > SID_MAX_SUB_AUTHORITIES ||
+		    pace_size < offsetof(struct smb_ace, sid) +
+				CIFS_SID_BASE_SIZE +
+				sizeof(__le32) * parent_aces->sid.num_subauth)
+			break;
+
 		aces_size -= pace_size;
 
 		flags = parent_aces->flags;
@@ -1222,22 +1247,24 @@ int smb_inherit_dacl(struct ksmbd_conn *conn,
 		}
 
 		if (is_dir && creator && flags & CONTAINER_INHERIT_ACE) {
-			smb_set_ace(aces, psid, parent_aces->type, inherited_flags,
-				    parent_aces->access_req);
-			nt_size += le16_to_cpu(aces->size);
-			ace_cnt++;
-			aces = (struct smb_ace *)((char *)aces + le16_to_cpu(aces->size));
+			rc = smb_append_inherited_ace(&aces, &nt_size, &ace_cnt,
+						      psid, parent_aces->type,
+						      inherited_flags,
+						      parent_aces->access_req);
+			if (rc)
+				goto free_aces_base;
 			flags |= INHERIT_ONLY_ACE;
 			psid = creator;
 		} else if (is_dir && !(parent_aces->flags & NO_PROPAGATE_INHERIT_ACE)) {
 			psid = &parent_aces->sid;
 		}
 
-		smb_set_ace(aces, psid, parent_aces->type, flags | inherited_flags,
-			    parent_aces->access_req);
-		nt_size += le16_to_cpu(aces->size);
-		aces = (struct smb_ace *)((char *)aces + le16_to_cpu(aces->size));
-		ace_cnt++;
+		rc = smb_append_inherited_ace(&aces, &nt_size, &ace_cnt, psid,
+					      parent_aces->type,
+					      flags | inherited_flags,
+					      parent_aces->access_req);
+		if (rc)
+			goto free_aces_base;
 pass:
 		parent_aces = (struct smb_ace *)((char *)parent_aces + pace_size);
 	}
@@ -1247,7 +1274,7 @@ int smb_inherit_dacl(struct ksmbd_conn *conn,
 		struct smb_acl *pdacl;
 		struct smb_sid *powner_sid = NULL, *pgroup_sid = NULL;
 		int powner_sid_size = 0, pgroup_sid_size = 0, pntsd_size;
-		int pntsd_alloc_size;
+		size_t pntsd_alloc_size;
 
 		if (parent_pntsd->osidoffset) {
 			powner_sid = (struct smb_sid *)((char *)parent_pntsd +
@@ -1260,8 +1287,19 @@ int smb_inherit_dacl(struct ksmbd_conn *conn,
 			pgroup_sid_size = 1 + 1 + 6 + (pgroup_sid->num_subauth * 4);
 		}
 
-		pntsd_alloc_size = sizeof(struct smb_ntsd) + powner_sid_size +
-			pgroup_sid_size + sizeof(struct smb_acl) + nt_size;
+		if (check_add_overflow(sizeof(struct smb_ntsd),
+				       (size_t)powner_sid_size,
+				       &pntsd_alloc_size) ||
+		    check_add_overflow(pntsd_alloc_size,
+				       (size_t)pgroup_sid_size,
+				       &pntsd_alloc_size) ||
+		    check_add_overflow(pntsd_alloc_size, sizeof(struct smb_acl),
+				       &pntsd_alloc_size) ||
+		    check_add_overflow(pntsd_alloc_size, (size_t)nt_size,
+				       &pntsd_alloc_size)) {
+			rc = -EINVAL;
+			goto free_aces_base;
+		}
 
 		pntsd = kzalloc(pntsd_alloc_size, GFP_KERNEL);
 		if (!pntsd) {
-- 
2.53.0



