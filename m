Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623400;
	b=GnjkPTJ+y0EogrTPhX3a0bYLuee+3UxtfXcEv3KvuhBAUzgEhXYEmxDhmHZI/aUSGKoi
	 H+1Io1bNvyePzYH9xIpnCcFpByoKN1ZmFhAIsRzXQ+Y7mznil2+qdenvQZ7mKG1AT9qWY
	 00s3aCLn21Beh8tqSdvP1FoIQ2o+F+kbwRAmIvcPaRSiThKXRkHCKITLSEauIaef9jyXf
	 ORVknGufBp9aOXjghuZlacOWsCL40cvktHF1IUfxoznbg9jNGYNPb1zdodKL3MxYVv/L/
	 zwF2HzmM0vREx7Lvp46wYN6QbmYI86mrKlEFRH1Ykk+mcYtwuyLdoeG68Lex8PRRrmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623400;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iO/OwEaTxnN4aeYbQ1FlRS53ZDsdVeG1JAb8hf+Gmnk=;
	b=fhk7e0TlOT+5/iIqIX0FJL1EQluoFKJL5EQ1OaYzn+mMBCG/BDo3Z2blJvaqqKfR2Ax+
	 aAnTcMFvAiLBXCfJv8v521mk3/sRk3jJyEmLYR39O/+ZFfhh7zzNKgp9T5JP9WdN5YDNL
	 anX715nBA0Wt3vESznoFZI5IxaVcJCzlIgrdRKw95/V2nQnQbhsI20UO88FBnIM17Tit3
	 dMdCFzQ1xaI7qGtrIURgLJiZJeHx12ikRvyfARZyo5hQX/bgRPPrxdauP6DRhaqGD1Yos
	 PUd9hTKOQt2S4IhDiePTvuM/limjsWdOfju8jT83yvPo4d5JBcbMbyXfWiOoS55WBtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SprdfL6F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC2AA606A31E;
	Wed, 25 Nov 2026 16:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SprdfL6F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AE2C1F000C4;
	Wed, 25 Nov 2026 16:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623400;
	bh=iO/OwEaTxnN4aeYbQ1FlRS53ZDsdVeG1JAb8hf+Gmnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SprdfL6Fy1MyNyvWFXSk3ZcA/Hu2BMyO3YIArg0DHp4ARh/eqrt68T8brYaS86sOe
	 cUC4B2RwefpcMMcWEnuXC02zh3iBd9Fb0mDh+MA7ifli1pkA9t9U1mpHt6RQg20m/o
	 cCqAnUN1DaYS4L1DMDp9gLDrDJomdA+LQMzh38f4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	liuyong <pkfxxxing@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.18 848/990] smb: client: validate descriptor headers before query result allocation
Date: Wed, 25 Nov 2026 15:36:55 +0100
Message-ID: <20261125143841.894118150@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
@@ -3940,6 +3940,14 @@ replay_again:
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
@@ -4012,7 +4020,8 @@ SMB2_query_acl(const unsigned int xid, s
 
 	return query_info(xid, tcon, persistent_fid, volatile_fid,
 			  0, SMB2_O_INFO_SECURITY, extra_info,
-			  SMB2_MAX_BUFFER_SIZE, MIN_SEC_DESC_LEN, data, plen);
+			  SMB2_MAX_BUFFER_SIZE, sizeof(struct smb_ntsd),
+			  data, plen);
 }
 
 int


