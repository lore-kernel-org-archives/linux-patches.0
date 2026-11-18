Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053038;
	b=plxHhziebOqF1cC5NaUhyDRm8YCJDhGpz5otc5w8iuEYVjJnXc6VakGNj0gPZAusCWbB
	 lvcLdlAECnEay5jP3/zjGWy3yQC6Ck27ZoefWxcBivYBzkPyNcAI2fh+KSzg9MzMBm4/6
	 e7YqbQsDWJyaKi6RMt/bAqvEf3V6+Mglia25ZCqVYKoX4ICLJIB0mlI6B5RucuYjNW2vY
	 ZACLfK9L/SfmX50vFhACAonUIkPPPonmKE6vrh+TrK4tngw5rIskSj6cvuKW5i14yx+c+
	 cPPxLTVYe0DHE8rGe7GfZ6ADaZKJsWIIxMQKy43TIz/4Y1VibsC7W7DXM46hpO1oX/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053038;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DDBTGB6RqMP+P0W/c73ZcQhufmAD8cuaz/OUjHcezj0=;
	b=CfaRpf5kX9Lzv8GPqx5dckRV70WAj447+u2kT7MUT/ptbU4ILSWpejvMbCQmianwu+kg
	 WMS+WOo8uZi7LfUssRjrzsw5/XBmQWCJFT10VeAlYiyuBVGz6V4vVBgIaNXW8yPfOq1Tv
	 wVTpym/nxa6TqmloYGz10UE5A/ZSZHSyHzjA3dM0ZWXIfsKTUpC53b0AHimXrihRY7kHJ
	 MICHcLt3fMsGQlDYbVKuB+AUAm50+bA+FO0Kjdf3qC0IzJ6Csnw7/VM77XPd97YUXHIUn
	 4TGSRqF1E1fAYYOXX0WdcGFR8a4zIEgr6C2oCp3Pv0vo7Q0k7peShFflMt+kNngQoYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="he/YSmTK";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 206CC606A330;
	Thu, 19 Nov 2026 01:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=he/YSmTK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 756FA1F000C4;
	Thu, 19 Nov 2026 01:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053038;
	bh=DDBTGB6RqMP+P0W/c73ZcQhufmAD8cuaz/OUjHcezj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=he/YSmTKQ9eG7AOl4yjqvBzFwHCx2TRcj7U89pT2lkLP1GC90ach12iIuYiKK8CEI
	 6CLtqa5uiI58JzgLfCD/BovxaAmFqM88dOJPN/NdYWcWNaSITx2/41+1OXPfMA7Rnd
	 j46+nogdDXxkpM+6YYCwCVtbeE3X2VzWdqWRYzRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dominik Maier <dmnk@google.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0775/2214] smb: client: fix slab-out-of-bounds write in id_mode_to_cifs_acl()
Date: Wed, 18 Nov 2026 15:40:51 +0100
Message-ID: <20261118150042.658048309@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dominik Maier <dmnk@google.com>

[ Upstream commit a377a3645c7d0246af0bc4ef24db94bb2670bdde ]

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
[ sashal: Adapted the allocation calculation to cifs types and the existing nsecdesclen initialization in code lacking the POSIX branch. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/cifsacl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index 3baafbc12f1a1..defd9493ed396 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -1725,6 +1725,8 @@ id_mode_to_cifs_acl(struct inode *inode, const char *path, __u64 *pnmode,
 	/* Potentially, five new ACEs can be added to the ACL for U,G,O mapping */
 	nsecdesclen = secdesclen;
 	if (pnmode && *pnmode != NO_CHANGE_64) { /* chmod */
+		nsecdesclen += sizeof(struct cifs_acl) +
+			2 * sizeof(struct cifs_sid);
 		if (mode_from_sid)
 			nsecdesclen += 2 * sizeof(struct cifs_ace);
 		else /* cifsacl */
-- 
2.53.0



