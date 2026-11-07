Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061750;
	b=ygFfSLvclZ+Y8UhgYnYqMxXGYZn/CZbrkzCAHdracKpU/GAWFKjgh5LvDllDFI3BPJcE
	 BYduurnx3eNGe6NNJ6WXCVGmizpF3JAAgX5NFcnmuMi0OVaCiGKZaqXFmNMqvhA/fBbXS
	 QHVSb2xzsTNl5Sal0Ym2HgW10Vy5ZEnD15H90Y3giKtpp+494qQZwG7leo7Lw6xrLzfty
	 LOiH+q3QZb+iF56/H2Ly6EeeaGgCkaXkltm462u4gcJ+XMD1gMudEPZ5ctLjjQs16NGKy
	 DicEzoEHXxe4lEuR4lVpna7L4mk2jycIVXRl4kPBfXbsqVOfBNMFvp7FBGkKsKR1Ecw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061750;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UKITI4LdAkHCYxte+vMMO3QevbAJvG503U7ov7FrXuI=;
	b=Da+aFsPo3oioqyAJtux0vU1bviCaeTyKahgBotosbJ4frBsIjL3ydlHvoptfMO280PsV
	 0w6ttxtVFTUiJtaHQ4D9+sN1u5zDr9+YCmHXx8Fhb6hRPtKpukUfPKgCNxBbf9f0hF7at
	 JMQx9Hb0jtKPuWDxAz9GcNFRRNPtd0L2E6JdOIn6bMA37d993QTe786ic5iK6OArmYI1D
	 VC5GnN9ZP6uEM+ZVNc1qZLDJ07EdASWOWGdDw7vNXVevRxRh89h3RmX6dh4LBsd49dFqH
	 ZxkfCoUKT/9YfdmZ4gvbc5ALQcf+0K3TtxsyS3uOlgwxWlO+g2kzOA+ZaErowwO5TIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="HiAJX5/A";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5647606A326;
	Sat,  7 Nov 2026 14:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HiAJX5/A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49AF51F0089F;
	Sat,  7 Nov 2026 14:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061750;
	bh=UKITI4LdAkHCYxte+vMMO3QevbAJvG503U7ov7FrXuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HiAJX5/Av2Og9DM2ZR2Kpv4GqQgg7b8IsFJm7ygwfFlZSxsPZBg0JZZazdi3CV/wH
	 IRMLom7dtWRfbrAvmCfCJkhmiOGYwyRV54nXGctmEnL9gGBFkGgS7Q22l3RnHUcgjn
	 Rc03mOMfuLtKYoApO+J1hl0590zcZPJ7Y5hIQXnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dominik Maier <dmnk@google.com>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.12 0751/1536] smb: client: fix slab-out-of-bounds write in id_mode_to_cifs_acl()
Date: Sat,  7 Nov 2026 08:46:07 -0500
Message-ID: <20261107135018.624229317@linuxfoundation.org>
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

From: Dominik Maier <dmnk@google.com>

commit a377a3645c7d0246af0bc4ef24db94bb2670bdde upstream.

In id_mode_to_cifs_acl(), while the chown branch reserves
sizeof(struct smb_ntsd) + 2 * sizeof(struct smb_sid) (plus
sizeof(struct smb_acl) and the worst-case ACE space after
commit 0ee150794c75 ("smb: client: fix heap overflow in DACL owner/group
rewrite")), the chmod branch only adds 2 * sizeof(struct smb_ace) or
5 * sizeof(struct smb_ace) to secdesclen (or 1 * sizeof(struct smb_ace)
on posix).

However, the chmod branch also invokes build_sec_desc() ->
copy_sec_desc(), which unconditionally writes the Owner SID at
pnntsd + sidsoffset and the Group SID at
pnntsd + sidsoffset + sizeof(struct smb_sid) (2 * 68 = 136 bytes total),
and set_chmod_dacl() always writes a struct smb_acl header (8 bytes)
even when the source descriptor has dacloffset == 0. When a security
descriptor has compact or overlapping Owner/Group SIDs (or
dacloffset == 0), calling chmod() under-allocates pnntsd and writes past
the end of the slab buffer.

Reserve sizeof(struct smb_acl) + 2 * sizeof(struct smb_sid) (plus
sizeof(struct smb_ntsd) on the posix path) in the chmod branch of
id_mode_to_cifs_acl().

Fixes: 7ee0b4c635c0 ("cifs: fix hardcoded default security descriptor length")
Fixes: f5065508897a ("cifs: Retain old ACEs when converting between mode bits and ACL.")
Assisted-by: ARTIST LLM
Signed-off-by: Dominik Maier <dmnk@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifsacl.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/fs/smb/client/cifsacl.c
+++ b/fs/smb/client/cifsacl.c
@@ -1771,12 +1771,15 @@ id_mode_to_cifs_acl(struct inode *inode,
 
 	/* Potentially, five new ACEs can be added to the ACL for U,G,O mapping */
 	if (pnmode && *pnmode != NO_CHANGE_64) { /* chmod */
+		nsecdesclen = sizeof(struct smb_acl) +
+			2 * sizeof(struct smb_sid);
 		if (posix)
-			nsecdesclen = 1 * sizeof(struct smb_ace);
+			nsecdesclen += sizeof(struct smb_ntsd) +
+				       sizeof(struct smb_ace);
 		else if (mode_from_sid)
-			nsecdesclen = secdesclen + (2 * sizeof(struct smb_ace));
+			nsecdesclen += secdesclen + 2 * sizeof(struct smb_ace);
 		else /* cifsacl */
-			nsecdesclen = secdesclen + (5 * sizeof(struct smb_ace));
+			nsecdesclen += secdesclen + 5 * sizeof(struct smb_ace);
 	} else { /* chown */
 		/* When ownership changes, changes new owner sid length could be different */
 		nsecdesclen = sizeof(struct smb_ntsd) + (sizeof(struct smb_sid) * 2);


