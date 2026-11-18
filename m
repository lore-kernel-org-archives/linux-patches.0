Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035029;
	b=X3j5hIdNUY81+jgikXnH0r+4a4SrDUhqfz8SxefCkbxMxmn1m8JrA7q0FEJvFZgVnX5B
	 ZUfjumqMHaNnndbVlYCMRoIjX7o0gZTe62lpEKWfULTZkHdOo3k7OjqwZG+9wGnrmq4wh
	 Xwv37V0QMqkTXRzWECsANNOCK+jLR35r9v8Dv8fQRJLLZPNzDjzudB+mT/C+7IVTa/Eiy
	 1V5Uq/08lFa5ZfA5zPt16055h3M942lvCmPcjhnJtYK/DxhgQ5Lkx4NgXTm2vPls+Etkp
	 Qp/8l8jiqaLRnCCUGJx7FHH6tfchRdUh4hTp0yd4y3ZzHaRLKJijQ2uiQibMiqJK4yQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035029;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jokhvh/gunlOE7e1EHTTJ+kDJvnvzzQ8+MNJ5jDjfkc=;
	b=bTpFKfIEoUf+hLwyLFsu14N+ExJeyIN28eTamxoyl671/UyVHMTSDwkoBTt4U8XG0e1X
	 HpmKpfNHboXppX2KC6shZSxhlAy2xzEZNsgYUnOnEtWYdDRObARtIC39anT8539/5Gt3v
	 yVs3wOBzVoMUkoBlpMCsfbOl6lvrfX5weVymhsBHyNHBBm4roplll4MWOuoqnyljvpnla
	 r2xWMAe8VJkoQgol2jI3ZRKmPzdfcweHa1kkBUHPaJujzrJPHMvgdmaWZcSG0pkCG9Y6I
	 /GYL437YeVBq5keCKTYYdyt0zm6SBOImkCHq9bkf2aHPedIXZGucogv29VkJw++nsgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P2XLweif;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F592606A31C;
	Wed, 18 Nov 2026 20:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P2XLweif
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A96101F000C4;
	Wed, 18 Nov 2026 20:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035029;
	bh=jokhvh/gunlOE7e1EHTTJ+kDJvnvzzQ8+MNJ5jDjfkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P2XLweif/ZGVd8Bmp7ITNrvHPrSACwhoP5rlkrYJO9eeELNwuPo1vDgdIXNqjo1+D
	 ZhvF5FE5+S2p1AwthW40MhOfdXpvf7ensZOLC5Q0JPV5WS4aFrXGpymfIM4CGPcf8Q
	 dGv0lWkfkWpJu6zz2FleOs0hhA4H1xjo/lnc88Oo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ratnaker Gautam <ratnaker.gautam@kuleuven.be>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.6 0578/3318] ksmbd: validate security descriptor offsets before pointer arithmetic
Date: Wed, 18 Nov 2026 15:20:00 +0100
Message-ID: <20261118150334.842098772@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

commit 3474e1a304fbf9f7c996b24adcd519e031227a90 upstream.

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

Fixes: 0626e6641f6b ("cifsd: add server handler for central processing and tranport layers")
Cc: stable@vger.kernel.org
Reported-by: Ratnaker Gautam <ratnaker.gautam@kuleuven.be>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smbacl.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -896,7 +896,7 @@ int parse_sec_desc(struct mnt_idmap *idm
 		   int acl_len, struct smb_fattr *fattr)
 {
 	int rc = 0;
-	struct smb_sid *owner_sid_ptr, *group_sid_ptr;
+	struct smb_sid *owner_sid_ptr = NULL, *group_sid_ptr = NULL;
 	struct smb_acl *dacl_ptr; /* no need for SACL ptr */
 	char *end_of_acl = ((char *)pntsd) + acl_len;
 	__u32 dacloffset;
@@ -908,12 +908,7 @@ int parse_sec_desc(struct mnt_idmap *idm
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
@@ -929,9 +924,12 @@ int parse_sec_desc(struct mnt_idmap *idm
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
@@ -947,9 +945,12 @@ int parse_sec_desc(struct mnt_idmap *idm
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
@@ -971,9 +972,10 @@ int parse_sec_desc(struct mnt_idmap *idm
 		pntsd->type |= cpu_to_le16(DACL_PROTECTED);
 
 	if (dacloffset) {
-		if (dacloffset < sizeof(struct smb_ntsd))
+		if (dacloffset < sizeof(struct smb_ntsd) || dacloffset >= acl_len)
 			return -EINVAL;
 
+		dacl_ptr = (struct smb_acl *)((char *)pntsd + dacloffset);
 		rc = parse_dacl(idmap, dacl_ptr, end_of_acl,
 				owner_sid_ptr, group_sid_ptr, fattr);
 		if (rc)


