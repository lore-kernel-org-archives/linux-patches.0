Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044717;
	b=GHUs0i/pOgQMrvmuAyaudE9OF3DACNk91Wyug190KudJhGjJMbQ8L5q+Ht3XaEhzMyk2
	 Di2MxiPmiFS0fZgUf6ZmPCSU0b1bS46gOgZ/5iKPPQX8gZO3foC+NrIKHo81Vo5oNEQr2
	 gevPequuA6pwSdSO7CTMvuaVkDujtJMgLNalLduCkByKGt9Otvica6Nlqv8s28rWZg0D8
	 /JAbPINBs2ZbjnY042b70HF4OBRin7nSSKAvfSMvYkOL6ha6FqiEhq9JvYBzi/1kimc3c
	 w5BJEkRP/M6QiEMoD7JHUTm/PZiq4wLnJD5EOSVMK7yJrHNG8AXL7WwHn3RFzaKXclA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044717;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FSmNmAokA2eRkRyXmCCfUQ+czoRGr5NYpijeDQ8UCGo=;
	b=UlMOsfFoRanSS1G1BvBL5r5nrzOBKaScFPKOT5EkPLrWfRfSvSlq488EEkuVJaCWSKwK
	 CrS434XWGx6SW1eCU4QsUeaPEtFVXr3XIwSDJbgUdrycNDz1chpxck88xHsncFWMdZvtc
	 xWg5o6l9Rzk6Czku2A2Uel3ahgyVnCTmfvUGOuHo/d4dZDUU+6Q+g8aLMnWpTBUvP6iQg
	 fqbNhmosDA4uUAsRKlfcByn4nkZJuWpcusSJ+vGkhM2u/DmOdRRfJMGcAWuM6oW7Blsjb
	 lOExKlqgN+8HlLi2kAScyVttFDZXWmoh3kmeJ2bq9A42+sZK63zVz+gj7SeV0IMxNCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rw3MHLS8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDE77606A325;
	Wed, 18 Nov 2026 23:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rw3MHLS8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A7061F000C4;
	Wed, 18 Nov 2026 23:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044717;
	bh=FSmNmAokA2eRkRyXmCCfUQ+czoRGr5NYpijeDQ8UCGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rw3MHLS8qo+uHSpeKKBjHbvUQa3FFSZRrEVuLXvPWUuJlXQ3/b2UxzAUI4YdoNc8i
	 xGTD5qzIqYS3kC0Vzqd3wZR2Dq2HEeHE+xVgzUrHWcMb3wZ90i+GDotJnlY7i0gYSx
	 k2lbFlPgyRB4+V7O0pe7jklbYg9ojvjGALdFNksQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ratnaker Gautam <ratnaker.gautam@kuleuven.be>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0665/2857] ksmbd: validate security descriptor offsets before pointer arithmetic
Date: Wed, 18 Nov 2026 15:28:19 +0100
Message-ID: <20261118150225.494138476@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 3474e1a304fbf9f7c996b24adcd519e031227a90 ]

parse_sec_desc() constructs SID and DACL pointers by adding untrusted
32-bit offsets to the security descriptor before checking their bounds.
The existing checks reject offsets into the descriptor header, but do
not reject offsets beyond the descriptor's length.

On a 32-bit kernel, a large offset can wrap the pointer before the
descriptor. The end-only checks in parse_sid() and parse_dacl() can then
accept it, allowing an authenticated SMB2 SET_INFO request to access
memory outside the security descriptor and fault the kernel.

Check each nonzero offset against acl_len before constructing its
pointer. Initialize the optional owner and group SID pointers to NULL
so an omitted SID remains absent when parsing the DACL.

The 6.1 tree uses a void parse_dacl(). Preserve that interface in this
backport.

Fixes: 0626e6641f6b ("cifsd: add server handler for central processing and tranport layers")
Cc: stable@vger.kernel.org
Reported-by: Ratnaker Gautam <ratnaker.gautam@kuleuven.be>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
(cherry picked from commit 3474e1a304fbf9f7c996b24adcd519e031227a90)
Signed-off-by: Ratnaker Gautam <ratnaker.gautam@kuleuven.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smbacl.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index e03adba7d8ee3..bbbcb12aa9d06 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -885,7 +885,7 @@ int parse_sec_desc(struct user_namespace *user_ns, struct smb_ntsd *pntsd,
 		   int acl_len, struct smb_fattr *fattr)
 {
 	int rc = 0;
-	struct smb_sid *owner_sid_ptr, *group_sid_ptr;
+	struct smb_sid *owner_sid_ptr = NULL, *group_sid_ptr = NULL;
 	struct smb_acl *dacl_ptr; /* no need for SACL ptr */
 	char *end_of_acl = ((char *)pntsd) + acl_len;
 	__u32 dacloffset;
@@ -897,12 +897,7 @@ int parse_sec_desc(struct user_namespace *user_ns, struct smb_ntsd *pntsd,
 	if (acl_len < sizeof(struct smb_ntsd))
 		return -EINVAL;
 
-	owner_sid_ptr = (struct smb_sid *)((char *)pntsd +
-			le32_to_cpu(pntsd->osidoffset));
-	group_sid_ptr = (struct smb_sid *)((char *)pntsd +
-			le32_to_cpu(pntsd->gsidoffset));
 	dacloffset = le32_to_cpu(pntsd->dacloffset);
-	dacl_ptr = (struct smb_acl *)((char *)pntsd + dacloffset);
 	ksmbd_debug(SMB,
 		    "revision %d type 0x%x ooffset 0x%x goffset 0x%x sacloffset 0x%x dacloffset 0x%x\n",
 		    pntsd->revision, pntsd->type, le32_to_cpu(pntsd->osidoffset),
@@ -918,9 +913,12 @@ int parse_sec_desc(struct user_namespace *user_ns, struct smb_ntsd *pntsd,
 	pntsd->type = cpu_to_le16(DACL_PRESENT);
 
 	if (pntsd->osidoffset) {
-		if (le32_to_cpu(pntsd->osidoffset) < sizeof(struct smb_ntsd))
+		if (le32_to_cpu(pntsd->osidoffset) < sizeof(struct smb_ntsd) ||
+		    le32_to_cpu(pntsd->osidoffset) >= acl_len)
 			return -EINVAL;
 
+		owner_sid_ptr = (struct smb_sid *)((char *)pntsd +
+				le32_to_cpu(pntsd->osidoffset));
 		rc = parse_sid(owner_sid_ptr, end_of_acl);
 		if (rc) {
 			pr_err("%s: Error %d parsing Owner SID\n", __func__, rc);
@@ -936,9 +934,12 @@ int parse_sec_desc(struct user_namespace *user_ns, struct smb_ntsd *pntsd,
 	}
 
 	if (pntsd->gsidoffset) {
-		if (le32_to_cpu(pntsd->gsidoffset) < sizeof(struct smb_ntsd))
+		if (le32_to_cpu(pntsd->gsidoffset) < sizeof(struct smb_ntsd) ||
+		    le32_to_cpu(pntsd->gsidoffset) >= acl_len)
 			return -EINVAL;
 
+		group_sid_ptr = (struct smb_sid *)((char *)pntsd +
+				le32_to_cpu(pntsd->gsidoffset));
 		rc = parse_sid(group_sid_ptr, end_of_acl);
 		if (rc) {
 			pr_err("%s: Error %d mapping Owner SID to gid\n",
@@ -960,9 +961,10 @@ int parse_sec_desc(struct user_namespace *user_ns, struct smb_ntsd *pntsd,
 		pntsd->type |= cpu_to_le16(DACL_PROTECTED);
 
 	if (dacloffset) {
-		if (dacloffset < sizeof(struct smb_ntsd))
+		if (dacloffset < sizeof(struct smb_ntsd) || dacloffset >= acl_len)
 			return -EINVAL;
 
+		dacl_ptr = (struct smb_acl *)((char *)pntsd + dacloffset);
 		parse_dacl(user_ns, dacl_ptr, end_of_acl,
 			   owner_sid_ptr, group_sid_ptr, fattr);
 	}
-- 
2.53.0



