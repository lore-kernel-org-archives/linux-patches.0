Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831952;
	b=yHZ9cdg4Ut8GK32H7tmfVmA3Ask8LOtsO6Q4BARrDhF0dbWej+DWpsFa/3SD/irAbKE+
	 th0P83qtI1Rb+ndYcT+0uboE2T0JuinnpMjdMwLE0uuTySX9MOYsS94oBesoK2+OLuIdZ
	 2LLleGGrViti6PRN+mXvq162mFr/Y6WfsZjX4pOZUfB3KMOo4U73i2TtOZARPQ7v3a/tn
	 BPLaSvMBf9XtQvMNxPH+ltXGW5HVPJyF4ODgpgLBrdJrYYQhMuNYTAS29TVvvW8/shlQj
	 kTb9mLHstv8puTJhYtcEEI2dtyP4iobUkvTmXsI9FNRPknS2pPnPLNpTC5Iad+2SIbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831952;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=lyL6ijEsuT3MSS7xFThbk4ABeoeZNdxbbS0oFr56UMQ=;
	b=GIr/9H6NxD4VwSpRDpTtZoS2KeYcrIVXFgDP3Gel402NcPxHRtZ0KR/LoPxTYqSrL98K
	 MbbNNyxzGlsr9XeOWl4Lhbdk4RsGI5VkQnyx+BuTtGjdaUxhsWIo5hPV33ImqRVFYs5X3
	 Q9QdFKTRpenwGEsdm3eUGdXXWbKFg5X0zSaWT4MDTHxmGFx4xm9oN5kGZUp0hlccBfdTs
	 GYQOJY+2O2RnYDLPobKdoKzGJRSKXVv+3aj+Lkg0B2xbRFQwkLjSjK3gIneucwK67LO+t
	 2jdN1SPghLl2IKIk0bRfW+Amb5At1LQuLBijNNq0B4DF90Tr+sr+uhaLTbkgvN6YyJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OjHVnlwS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CADF3606A33A;
	Wed,  4 Nov 2026 22:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OjHVnlwS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66E251F000C1;
	Wed,  4 Nov 2026 22:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831951;
	bh=lyL6ijEsuT3MSS7xFThbk4ABeoeZNdxbbS0oFr56UMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OjHVnlwSmDLGP5HPjv9sBYuNSebyqTJROy0aannfqq+flbvmFf+g9wEeJBXPyOZZu
	 GAH9h87s6uX3PdPDEgilngTRWHB7h3KVWwoU480jbZLxvYrmQlHMjHqHP792AhfydR
	 FIjuzx6Fw+SHPlECC8UaYbm+4qoP/WUVqE3thGto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aamir Ahmed <elb12345@hotmail.co.uk>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0986/1005] ksmbd: deny access for an empty DACL instead of granting the request
Date: Wed,  4 Nov 2026 16:11:59 -0500
Message-ID: <20261104211110.660797664@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aamir Ahmed <elb12345@hotmail.co.uk>

[ Upstream commit de0cffef897c1c232ed973f89928cd6c93d0b1e3 ]

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
[ sashal: added missing ownership declarations and initialization of is_owner using the mount’s ID mapping ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smbacl.c |   26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1469,6 +1469,8 @@ int smb_check_perm_dacl(struct ksmbd_con
 	struct posix_acl_entry *pa_entry;
 	unsigned int sid_type = SIDOWNER;
 	unsigned short ace_size;
+	bool is_owner;
+	vfsuid_t vfsuid;
 
 	ksmbd_debug(SMB, "check permission using windows acl\n");
 	pntsd_size = ksmbd_vfs_get_sd_xattr(conn, idmap,
@@ -1489,19 +1491,27 @@ int smb_check_perm_dacl(struct ksmbd_con
 	if (pdacl_size > acl_size || pdacl_size < sizeof(struct smb_acl))
 		goto err_out;
 
+	if (!uid)
+		sid_type = SIDUNIX_USER;
+	id_to_sid(uid, sid_type, &sid);
+	vfsuid = i_uid_into_vfsuid(idmap, d_inode(path->dentry));
+	is_owner = uid == from_kuid(&init_user_ns, vfsuid_into_kuid(vfsuid));
+
 	if (!pdacl->num_aces) {
-		if (!(pdacl_size - sizeof(struct smb_acl)) &&
-		    *pdaccess & ~(FILE_READ_CONTROL_LE | FILE_WRITE_DAC_LE)) {
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
 			rc = -EACCES;
-			goto err_out;
-		}
 		goto err_out;
 	}
 
-	if (!uid)
-		sid_type = SIDUNIX_USER;
-	id_to_sid(uid, sid_type, &sid);
-
 	if (*pdaccess & FILE_MAXIMAL_ACCESS_LE) {
 		access_bits = READ_CONTROL | WRITE_DAC | FILE_READ_ATTRIBUTES |
 			DELETE;


