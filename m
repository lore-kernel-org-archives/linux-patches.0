Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061822;
	b=qD5iEWHcxbdC10f5xj6ixZ+tW4sI0Vj1F9vXsJVfKtxQeZJIGm0IN28Rb/3s6fMoRsiC
	 inWY9OxukkozLzpVLZ0kl5+1Bfe8JdFuBlEF1OeAr5Q092vsOij1t5vkMwwE3ty+3Ys+h
	 5UD8tsVWyhsZ8a72i7la4D3frmC+yzfefvmGnOFT+dkUgwBgPFLrdccFIdmkwJ3f96360
	 +2hvmTpiz6yvCy16m19qIziJWfq3iX08fSlD6fkGZRn0QrtFuTQf4k3fiump+FwGyTsGf
	 SKgxzSo0RApsM0ESbXOUoN/xp3HTNHLa/u/nwuOaBnYIDDz+emfQ/CDuSGz/uvBHIGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061822;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=G64iCR6uKaz9/t5Cr9wg3vZ0t6JVBq5odYDwMk8ZK3E=;
	b=k1DODfVKYZ22UEFA/QxEznGnf9hk0nUS+sB9rseLMC59OYV3bIFLYSlNjGtmsZALai19
	 EJ9iUuE7jXouqLVKBNL2UDWQ8lYWAnNZ4WpubpSZBuWBOQTNojQOYiOiEk9cMEAuvEaI7
	 bssZOW4WgDg0aCPTWng0BxIRXClGLlw2AJv+gSNYbuQ1W75ywOyAYE2n9f8KYpVphLlEu
	 Rwwax+hxxc6bQOhr4J9Dmplmc9Ik3z6QLcYuwWNFn6Nkb5ocSRHjCZ59fmNduVLHWBIw3
	 M92Gp//Ke5lxs2Akt9tav6z4InvBf+i5AFr2hB6l1lbtqXMxBy1AplP8V+FrRi+BJrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K9gHH+YR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A55E606A32E;
	Sat,  7 Nov 2026 14:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K9gHH+YR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C9AB1F0089F;
	Sat,  7 Nov 2026 14:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061822;
	bh=G64iCR6uKaz9/t5Cr9wg3vZ0t6JVBq5odYDwMk8ZK3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K9gHH+YRdTQnG3DGbi6c+2KMkfECXsNZDPyVW6WUxHGrXsNepd9tOFozpF5Asb9vy
	 35bJ2gD9uCvpU1TjEQ9HFoUQSK0dx+dEAhxSQpjEQns/rk3RX65eK+/dKrusCB+UtQ
	 VkiHzeE/aPJQ9OP2YLfqVPwPAUC+IdhAFOYGOR+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aamir Ahmed <elb12345@hotmail.co.uk>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0845/1536] ksmbd: deny access for an empty DACL instead of granting the request
Date: Sat,  7 Nov 2026 08:47:41 -0500
Message-ID: <20261107135021.283326188@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: added the missing mount-mapped UID ownership calculation for is_owner ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smbacl.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index 49a35974dd296..33a607e709f18 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1469,6 +1469,8 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 	struct posix_acl_entry *pa_entry;
 	unsigned int sid_type = SIDOWNER;
 	unsigned short ace_size;
+	bool is_owner;
+	vfsuid_t vfsuid;
 
 	ksmbd_debug(SMB, "check permission using windows acl\n");
 	pntsd_size = ksmbd_vfs_get_sd_xattr(conn, idmap,
@@ -1489,19 +1491,27 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
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
-- 
2.53.0



