Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831351;
	b=iwS8Gs1I2LIGcdVRSimNgFXPutfGSJfR7UtjxyRqCgTuqG/4LBpmEKECQ5Qw0tjXGSPD
	 MWUc6UNgqVZlTyu2PKEQOer7qCxlfevgTGeGgOL9JRRYhBQmT+OsazVQN8yWPDFxLlass
	 lpg6O48Xanl+kRsU7GUobElR+E2YAb+jBzlxuxTrQlZKNN2vBBxR5sBZ5AjPCIGDjjYY4
	 vUR9jbyS2qSp9ta+sUkkVZzWxyhfQj2Ezu+IM4XlYMf6c1RQZnHIPlMkWgAHCQq0atqFD
	 5+eSWTAV6ZcoD+bLilacYXkhhxJ91hxJ6WqhQv4TQTPTKL8/kIIfvUTV50ZVfbalHYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831351;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ndYQqLr0rGHlmtH6RL/ELp7wKykq2Y7UFe2hO5SwHYo=;
	b=40itDQitlI3e+izBpG9nK4hO/pFWG00PThHov28AedUIOxXhtF1YPYDmeiUdSSNPllT6
	 W3LJZv7iqAUhs7YRvlzDqhU2vYx3MceAycHkKB2/ew88Saw0lJP7JCD3LXimZ+cFEM2+8
	 KNZ1yoqO3arjQSLuNjYqQWin0D2ynTUudUdpUImRLpdqGQ6/5+ixvR2kcqEhXTjhW+ST6
	 0QTEphsriDUu5gPdyQwy7aYcestW9OkeE7ofet8To2HbRMtnRnzrrTpMMNtWT7/6nPxIr
	 dM3IozBND9orv2C6CP8B0TOQu7HARPWb8OvBmIvHjGg2dFrhqOAZ8AnTlD+t8pLpEBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1fMal2Fu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5B9D606A33D;
	Wed,  4 Nov 2026 22:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1fMal2Fu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60CF11F000C1;
	Wed,  4 Nov 2026 22:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831350;
	bh=ndYQqLr0rGHlmtH6RL/ELp7wKykq2Y7UFe2hO5SwHYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1fMal2Fu6p/mbV1a+DUIf9r1HgmkLlQ7qBZvWtGquvhVSBFocsb6vTPsZ+T77ZgMe
	 lF62xg7DHs0DTyeAjXlT4aHMn45tK8HU/Hn+bcCysHFQFZW5qCq4a4OBML96mJcJLN
	 e0WPNdXH3SBQ4A8UbMlbjV51s3YquvcQsm4y732k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ratnaker Gautam <ratnaker.gautam@kuleuven.be>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.18 0651/1005] ksmbd: validate security descriptor offsets before pointer arithmetic
Date: Wed,  4 Nov 2026 16:06:24 -0500
Message-ID: <20261104211101.953339163@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

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


