Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620214;
	b=pgAiyq4lf99WQbe7mSP/nxz16SsGIB4vDHGlK4H8EoBSdlK/2rSVEd8UgfK7eEKpix82
	 gqQ2wZVY3apQRsWG2qL68B6hHlu7tDFEFtLUdAN6G5KT9ltJVP+d6RHYpjXnnWBFeFM2x
	 GxYHuR89csAMdJmaHgyJknAK0bUpmVJUZRxUHKDvY+iOF7bN+UmprqWmARBQUpNdul1z3
	 fud8s85nkPRMzqxrm/H3vOQfDZwadEs6TwTogD+apuI14cxS3QJp6d2Gb/T88BtpYQdlA
	 CyvbY/46R8QBsRoCQRlm58p7+USf/ZPEQNzgGq1kqIfra6dbKiw8J9pX+f8xh6KWycw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620214;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ezNGJNsIhUWpi09who8mIhUlS4fJ0b3gQbeL2Xt6eY0=;
	b=N2N1hSS/xtJJQVRNFHS26euLoZpkFjAxzbbrn+8bfkFFn+UdXW/PT6qLt4fpx39bxoYR
	 IiSpUgdYeUTeMcqUiZTkkGsKFukmkK2i4wR6wtTGfuzq5DuAztvGJX5MRYzn1upsUzscv
	 bN+yoVimGb0LRRy3QuS/4y83NwEvCi0FbSLCvTVdkHWmDH+MlaeT8YnPxQ+2bI9bGjpwz
	 zJG0OAqi9adtMeJzbVjkRSLXab06T/uLhHeKKMmazoCNeRN/T35ZGqkb/AYkbtKHIHXhx
	 FwBQIXJsOe+XfYPY+y/5mjw2DFe82DfnPKpit1oHuAk80eeWFDgzTqaqf9KQ5OeowlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RJ4xXh4V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C264B606A31E;
	Wed, 25 Nov 2026 15:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RJ4xXh4V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC9A91F000CF;
	Wed, 25 Nov 2026 15:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620214;
	bh=ezNGJNsIhUWpi09who8mIhUlS4fJ0b3gQbeL2Xt6eY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RJ4xXh4V5hA8zhupSaGN7nnnWBBthMMifCymeWwtwwgtXxC/KtElafwxObWAOKxU0
	 gYAp63aLOGWditDApLyvlcc4JAugm3vlG7hJlVd2LfVts8iVuduDyY7uwcRxRcL8/h
	 KoM3t6bw2OGTUww/51+mLsP0yjXD8dGT+/KIr2AM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	liuyong <pkfxxxing@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 7.3 0847/1005] smb: client: validate descriptor headers before query result allocation
Date: Wed, 25 Nov 2026 15:36:25 +0100
Message-ID: <20261125143841.554263186@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: liuyong <pkfxxxing@gmail.com>

commit ffb59029c0d52bf76fdd2678f5d6fd13e26220dd upstream.

query_info() uses the server's returned length instead of the caller's
minimum when a dynamic result is requested. A zero-length ACL response
can therefore return ZERO_SIZE_PTR to id_mode_to_cifs_acl(), whose
ownership-change path reads dacloffset before checking the header size.
A KASAN-enabled test shows a read at address 0x20 and a kernel Oops.

Validate the returned range and the caller's minimum before allocating
the dynamic result. Keep the reported length zero if validation fails.

Use the security descriptor header size as the minimum in SMB2_query_acl().
DACL-only and SACL-only xattr queries do not require owner and group SIDs,
so enforcing MIN_SEC_DESC_LEN would reject short descriptors that these
queries could previously return. The rewrite paths validate the required
owner/group SIDs and DACL separately before using their contents.

These issues were discovered and fixed by Qihoo 360's Tulongfeng
multi-agent system.

Fixes: 9ee2afe5207b ("cifs: prevent copying past input buffer boundaries")
Cc: stable@vger.kernel.org
Signed-off-by: liuyong <pkfxxxing@gmail.com>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifsacl.h |   14 --------------
 fs/smb/client/smb2pdu.c |   11 ++++++++++-
 2 files changed, 10 insertions(+), 15 deletions(-)

--- a/fs/smb/client/cifsacl.h
+++ b/fs/smb/client/cifsacl.h
@@ -93,18 +93,4 @@ struct owner_group_sids {
 	struct owner_sid group;
 } __packed;
 
-/*
- * Minimum security identifier can be one for system defined Users
- * and Groups such as NULL SID and World or Built-in accounts such
- * as Administrator and Guest and consists of
- * Revision + Num (Sub)Auths + Authority + Domain (one Subauthority)
- */
-#define MIN_SID_LEN  (1 + 1 + 6 + 4) /* in bytes */
-
-/*
- * Minimum security descriptor can be one without any SACL and DACL and can
- * consist of revision, type, and two sids of minimum size for owner and group
- */
-#define MIN_SEC_DESC_LEN  (sizeof(struct smb_ntsd) + (2 * MIN_SID_LEN))
-
 #endif /* _CIFSACL_H */
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -4058,6 +4058,14 @@ replay_again:
 				ses->Suid, info_class, (__u32)info_type);
 
 	if (dlen) {
+		rc = smb2_validate_iov(le16_to_cpu(rsp->OutputBufferOffset),
+				       le32_to_cpu(rsp->OutputBufferLength),
+				       &rsp_iov, min_len);
+		if (rc) {
+			*dlen = 0;
+			goto qinf_exit;
+		}
+
 		*dlen = le32_to_cpu(rsp->OutputBufferLength);
 		if (!*data) {
 			*data = kmalloc(*dlen, GFP_KERNEL);
@@ -4112,7 +4120,8 @@ SMB2_query_acl(const unsigned int xid, s
 
 	return query_info(xid, tcon, persistent_fid, volatile_fid,
 			  0, SMB2_O_INFO_SECURITY, extra_info,
-			  SMB2_MAX_BUFFER_SIZE, MIN_SEC_DESC_LEN, data, plen);
+			  SMB2_MAX_BUFFER_SIZE, sizeof(struct smb_ntsd),
+			  data, plen);
 }
 
 int


