Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826971;
	b=TspndmeKpmtok7Wbbzd1GsZaa5S2wYk+iVHe+4KWkvdJ3Nt2M58hrLRMwWoHMjCXYeDp
	 BCC5+nJVVnT7BLIqq96h1Wr+YgJm6bdbZBtAWSqkBUhdcfsRiWCg1gu6EoGlC4OzIDoVZ
	 mLgNnsuIzAkWUDOSbZClnwdWXSPJznqCjQnTfH24JnFrBiXkJOHg6MYYcp15SIvA0U536
	 siyKGkr4We4CICATLJyw8SEpRNKxHEWAfuepfirstko4Mc7BOWTCtLDZ6Ak1KMCXEceGH
	 bQi4mXPX3av0mrDvObYC6WnFjaDNkYhV7wywlOQxSFCnzjCRgXfPwLbLo6ZkTi48peA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826971;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/n3yWd+mDpcqwxaKusSa3Yn+AzgIszIfLEDXJLQmCiA=;
	b=ln5/dgRoNQ59i1sm5XgvEWzRMuC6CdwCu7OoLUueqZOkwn34Qu0MaIAA52lBdCPxvEEH
	 ZJ7fU+ldPZPOueaUVBmDBOWoRrosbs/AZkZ84Q/t+veCofHjIybPare05H2gZGyEK9SZz
	 rLcsVcv8NPA66ugygLTVqUxa4TeLJvZidppz7v8xrSa7iAGgy+rE44NdxsQeLhBtubbwM
	 /kL+19toqEWUsV7p2mPArA2SWAuPGpKBPojmE7zeWcG3jI56lG1ktvYxMtmiWSn7B8dQQ
	 h5GSperHsL+Zwc5kFq3FBHpu4DMxHFsHwu5Lpnt/iVef/z0JWNUis3EZ/0S4+6MjcFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ha+lVpA3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C77836070336;
	Wed,  4 Nov 2026 21:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ha+lVpA3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FBA61F00A18;
	Wed,  4 Nov 2026 21:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826970;
	bh=/n3yWd+mDpcqwxaKusSa3Yn+AzgIszIfLEDXJLQmCiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ha+lVpA3jKh4hNqE26SounsA4TxsT0JemVbBsK6H0mheP52O0pZUjmQH097n4rD30
	 ZKU2th3CXTE/GnrxcWlrKqajED6MW7+ZJmYZkynkMqhsmo4Dp60NWk5jliqiu0+b6c
	 BCYvpuJZNYc67FxnGUvMQJ5VATnIFzR1q2kp9g0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aamir Ahmed <elb12345@hotmail.co.uk>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 7.3 116/547] ksmbd: deny access for an empty DACL instead of granting the request
Date: Wed,  4 Nov 2026 16:05:00 -0500
Message-ID: <20261104211041.498019132@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

From: Aamir Ahmed <elb12345@hotmail.co.uk>

commit de0cffef897c1c232ed973f89928cd6c93d0b1e3 upstream.

smb_check_perm_dacl() returns the access mask it computes to the SMB2
CREATE handler, which uses it as the granted access for the open. For a
security descriptor whose DACL is present but contains no ACEs, the
function is supposed to deny access: an empty (non-NULL) DACL grants no
access to anyone except the object owner's implicit READ_CONTROL and
WRITE_DAC (MS-DTYP 2.4.5).

The empty-DACL branch only denies when both

  - the DACL has no trailing bytes (pdacl_size == sizeof(struct smb_acl)),
    and
  - the request contains bits beyond READ_CONTROL / WRITE_DAC.

In every other case it takes the shared "goto err_out" with rc still 0,
which returns success without modifying *pdaccess, so the caller grants
the full requested access. Three problems follow:

  - The READ_CONTROL / WRITE_DAC carve-out models the owner's implicit
    rights, but the check runs before is_owner is computed, so those
    rights are handed to *every* caller, not just the owner. For
    READ_CONTROL the SMB2 CREATE path does not fall back to
    inode_permission(), so any user can read the security descriptor of
    an object whose empty DACL is meant to deny them.

  - A request of exactly READ_CONTROL and/or WRITE_DAC is granted to any
    caller. WRITE_DAC lets the handle rewrite the DACL.

  - A DACL that declares zero ACEs but carries trailing bytes
    (pdacl_size > sizeof(struct smb_acl)) skips the deny entirely and is
    granted whatever was requested.

On shares where the NT ACL is the authoritative access control -- e.g.
"force user" shares, where every client maps to one POSIX identity so
POSIX cannot distinguish users -- this is an access-control bypass.

Compute is_owner before the empty-DACL branch and deny access from an
empty DACL unless the caller is the owner requesting no more than
READ_CONTROL / WRITE_DAC.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Aamir Ahmed <elb12345@hotmail.co.uk>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smbacl.c |   24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1490,21 +1490,27 @@ int smb_check_perm_dacl(struct ksmbd_con
 	if (pdacl_size > acl_size || pdacl_size < sizeof(struct smb_acl))
 		goto err_out;
 
-	if (!pdacl->num_aces) {
-		if (!(pdacl_size - sizeof(struct smb_acl)) &&
-		    *pdaccess & ~(FILE_READ_CONTROL_LE | FILE_WRITE_DAC_LE)) {
-			rc = -EACCES;
-			goto err_out;
-		}
-		goto err_out;
-	}
-
 	if (!uid)
 		sid_type = SIDUNIX_USER;
 	id_to_sid(uid, sid_type, &sid);
 	vfsuid = i_uid_into_vfsuid(idmap, d_inode(path->dentry));
 	is_owner = uid == from_kuid(&init_user_ns, vfsuid_into_kuid(vfsuid));
 
+	if (!pdacl->num_aces) {
+		/*
+		 * An empty (present, zero-ACE) DACL grants no access to
+		 * anyone except the object owner's implicit READ_CONTROL
+		 * and WRITE_DAC (MS-DTYP 2.4.5). Deny every other caller,
+		 * deny the owner any access beyond those two bits, and do
+		 * not let trailing bytes after a zero-ACE DACL become an
+		 * implicit grant.
+		 */
+		if (!is_owner ||
+		    (*pdaccess & ~(FILE_READ_CONTROL_LE | FILE_WRITE_DAC_LE)))
+			rc = -EACCES;
+		goto err_out;
+	}
+
 	if (*pdaccess & FILE_MAXIMAL_ACCESS_LE) {
 		ace = (struct smb_ace *)((char *)pdacl + sizeof(struct smb_acl));
 		aces_size = pdacl_size - sizeof(struct smb_acl);


