Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022741;
	b=u67PlB7gVPt2YlZTJoH/gN+4u7DbO1l6wZ7i50adwYRtByQmJUMihJG+lV6gQE/oc2Zx
	 WTXPMuFKbVaZrXvhf3+ywuiFCKCOodG58hVEHwm1kgp4uywJBWvmp8EJVJPqTV8o6+4jC
	 4ox9OBj4n7d5zvI6f04W4rvqoj9S8ad0Gvg04llSWwxUzCffseSBaUrPKSlpjORG+bUpK
	 fJkWL3erz/JUwSSumYTTJSp8FhkvvkxB6dd04QXCvssdFo8yKTwp6zReA1qhYV3eQWvxu
	 thhR/+crC+bhdRF7fIU9tTPOh3/SBuHEKDpko2VfHrMKrl3/iivdrx6HpzdjBjVa4oQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022741;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WZnwfLo34mKNUZFow3UKwzGjynordBkFOGp8b80rjtU=;
	b=aF+1DMaP6rQy38Ex+KXBMv0pbQ2vhgsa8rw4l+fleTRwIh1Bmh0pykBQBzeHhLemsuyf
	 k9lZ735hW8USgyY9IEGXssmsuBNYSZzJoCjl5cWtBbmbWaMMotNQwKk4PSmD0n9XHpB6X
	 yxhgujn3JnNTkOkvu02pNaJrInymKwrgGk/dSGLKbpXpran5FfsFhzqwPUOdqXXj9LnKI
	 OymhCwKGvkQQViwT2IC58kEKGwVlb75PXQ2CWdwUNr9OjG3KY5wqhRrq3AMwEafOJyBEb
	 zyf20xc/bL1qcJiWHl16DKLOQyfSa5eNervN92ZKg8sL3CIOAl7MH0gNF5R1C7sibZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pgwPW+Ss;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE3CD606A320;
	Wed, 18 Nov 2026 17:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pgwPW+Ss
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B44EE1F000C4;
	Wed, 18 Nov 2026 17:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022741;
	bh=WZnwfLo34mKNUZFow3UKwzGjynordBkFOGp8b80rjtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pgwPW+SsgDULrLdCDN29D0h04XqYB4jMjiSycoeaKhTQD+h5LQXQ7jjzba7oeTDRD
	 W++v5ep3U5uDXJxAP07N2kV60sGrLofmWeuxMok2TCxquMVJG7iJBu1rFyssuGPQ+G
	 QMQR+v4z3lJhQ3owU1j+6GaMAhVsx7bUQUdiBOMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Bridges <icb@fastmail.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0094/2151] ksmbd: let the owner read and change the DACL when no ACE names it
Date: Wed, 18 Nov 2026 15:30:29 +0100
Message-ID: <20261118150125.228608866@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Bridges <icb@fastmail.org>

[ Upstream commit ffc855fe16afe02b22305111aa68cd8d07360941 ]

smb_check_perm_dacl() refuses the owner when neither its DACL lookup nor
the POSIX ACL fallback matches. The owner then cannot read or replace
the DACL over SMB. MS-DTYP 2.5.3.2 grants the owner READ_CONTROL and
WRITE_DAC unless an OWNER RIGHTS ACE applies.

An empty DACL allows the owner's explicit requests for these rights but
refuses MAXIMUM_ALLOWED. smb2_open() uses that check for the maximal
access reply (MS-SMB2 3.3.5.9.5), so even a READ_CONTROL open fails when
it asks for that reply.

Grant the owner's implicit rights on both paths, for explicit requests
and MAXIMUM_ALLOWED, unless an OWNER RIGHTS ACE applies.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: Ian Bridges <icb@fastmail.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
[ sashal: added the missing sid_owner_rights definition required by the upstream patch ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smbacl.c | 37 +++++++++++++++++++++++++++++++++----
 1 file changed, 33 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index d8c01e775d941..42a638d1d2b97 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -27,6 +27,9 @@ static const struct smb_sid creator_owner = {
 /* security id for everyone/world system group */
 static const struct smb_sid creator_group = {
 	1, 1, {0, 0, 0, 0, 0, 3}, {cpu_to_le32(1)} };
+/* security id for owner rights */
+static const struct smb_sid sid_owner_rights = {
+	1, 1, {0, 0, 0, 0, 0, 3}, {cpu_to_le32(4)} };
 
 /* security id for everyone/world system group */
 static const struct smb_sid sid_everyone = {
@@ -1466,6 +1469,7 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 	int i, found = 0;
 	unsigned int access_bits = 0, denied = 0;
 	struct smb_ace *others_ace = NULL;
+	bool or_ace = false;
 	struct posix_acl_entry *pa_entry;
 	unsigned int sid_type = SIDOWNER;
 	unsigned short ace_size;
@@ -1498,6 +1502,8 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 	is_owner = uid == from_kuid(&init_user_ns, vfsuid_into_kuid(vfsuid));
 
 	if (!pdacl->num_aces) {
+		unsigned int allowed = 0;
+
 		/*
 		 * An empty (present, zero-ACE) DACL grants no access to
 		 * anyone except the object owner's implicit READ_CONTROL
@@ -1506,9 +1512,14 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 		 * not let trailing bytes after a zero-ACE DACL become an
 		 * implicit grant.
 		 */
-		if (!is_owner ||
-		    (*pdaccess & ~(FILE_READ_CONTROL_LE | FILE_WRITE_DAC_LE)))
+		if (is_owner)
+			allowed = READ_CONTROL | WRITE_DAC;
+		if (*pdaccess & FILE_MAXIMAL_ACCESS_LE)
+			requested |= allowed;
+		if (!allowed || requested & ~allowed)
 			rc = -EACCES;
+		else
+			*pdaccess = cpu_to_le32(requested);
 		goto err_out;
 	}
 
@@ -1585,6 +1596,9 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 			found = 1;
 			break;
 		}
+		if (!compare_sids(&sid_owner_rights, &ace->sid) &&
+		    !(ace->flags & INHERIT_ONLY_ACE))
+			or_ace = true;
 		if (!compare_sids(&sid_everyone, &ace->sid) ||
 		    !compare_sids(&sid_authusers, &ace->sid))
 			others_ace = ace;
@@ -1629,8 +1643,23 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 		if (others_ace) {
 			ace = others_ace;
 		} else {
-			ksmbd_debug(SMB, "Can't find corresponding sid\n");
-			rc = -EACCES;
+			unsigned int allowed = 0;
+
+			/*
+			 * No ACE names the owner, who may still read and
+			 * change the DACL unless OWNER RIGHTS applies
+			 * (MS-DTYP 2.5.3.2).
+			 */
+			if (is_owner && !or_ace)
+				allowed = READ_CONTROL | WRITE_DAC;
+			if (*pdaccess & FILE_MAXIMAL_ACCESS_LE)
+				requested |= allowed;
+			if (!allowed || requested & ~allowed) {
+				ksmbd_debug(SMB, "Can't find corresponding sid\n");
+				rc = -EACCES;
+				goto err_out;
+			}
+			*pdaccess = cpu_to_le32(requested);
 			goto err_out;
 		}
 	}
-- 
2.53.0



