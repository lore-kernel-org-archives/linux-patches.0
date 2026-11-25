Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623506;
	b=dRWx5RzmGm+zCz9+UR7/7pyMLzufRwBr0YT3KU8k1uMwP0M5fD2LI0BVSKG+PtgLKGrB
	 aE0qyx3kGl9c7hOo/iGTMPgwSp7eOwC0SJQdqzvc4CBfv8sf1ncQYn6nGQMZ18gpTiZ7m
	 +/DMzHwuoje8wO17Wvjf345/Xglhr+Vne08XoD+R1CgE0gNKBe98GSOtVFw9DXnOR4buZ
	 H7fjuaEzY0ET7tUXv+/SpIKsTJNrSefua+mWrOhiNn1kLqLdCRX5nTaz6+U3pbHaTXCnh
	 P3Paf2FKCmO4mW9M8hhvRo2njaTCxiAWEvVEG+KG0N4tzWHdWJCjbKfwivSrXfhdYzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623506;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7UGzTsLzq96T2g9+eiKUm8Z5Bwj2sqCXjsXBIrF6gh0=;
	b=Yw5dAcxaM7zztxf8YJMbdX8BcK+vI0evpVRK0DZfoD72927xuNUl2BIpptjsvpAvzABi
	 Na+rnnOwvHtUEqMWvMCJz0xbxmf3gK0UG1ZpRWFvQTvoikXBWc7xIdBH4jsIkVNCD0Q32
	 4Ef63FSTiDzpUUW9a8JU0YtJS2crC+C3ZPRuUK70mVxeJHZP/+vmtCUS8JaPNa6oDapPW
	 MllSWicWzGeXOIuJXlFvHkqMk3RaRHPx0DroTGs5IDuka5KVpQ097ozF4VKFJNUYppgMY
	 QfAR+nKgFqD2zClqkGAQGmPBPTXT3XldSHjAXeIjboAonzje8VhT2epRBUTCGcm+vDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dZufx3n3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 176E0606A321;
	Wed, 25 Nov 2026 16:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dZufx3n3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5014F1F000C4;
	Wed, 25 Nov 2026 16:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623505;
	bh=7UGzTsLzq96T2g9+eiKUm8Z5Bwj2sqCXjsXBIrF6gh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dZufx3n3m2//b+6LPZkrdKrrMQnob1ttbuDncJ75JjbLV0lOyV0dMD3I0iS7AZ972
	 sixADtwpLu0xlyW/AiCTIY9EBxmDzyS9X542F3l+OcRTaRiq2ZpqZt2zkVrKoe4raK
	 BRFvf3BO1Cdo6rfiwA01EIGlEMZWXJcKsmN5UzTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	liuyong <pkfxxxing@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.18 837/990] smb: client: compare owner and group SIDs using their encoded lengths
Date: Wed, 25 Nov 2026 15:36:44 +0100
Message-ID: <20261125143841.637353479@linuxfoundation.org>
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

commit a2dabe73ea05ad3b3f8e1cc08fb2e7c2ddc5564b upstream.

populate_new_aces() compares owner and group SIDs over sizeof(struct
smb_sid), including storage for all 15 possible subauthorities. Received
SIDs contain only their encoded subauthorities. The comparison can read
past the security descriptor, as shown by the supplied KASAN report for
a 44-byte descriptor during chmod.

The input SIDs have already been checked by sid_from_sd(). Require equal
subauthority counts, then compare only the fixed SID header and the
encoded subauthorities with memcmp(). The count check ensures that both
validated SIDs contain the number of bytes being compared.

These issues were discovered and fixed by Qihoo 360's Tulongfeng
multi-agent system.

Fixes: 0f22053e811c ("cifs: Fix unix perm bits to cifsacl conversion for "other" bits.")
Cc: stable@vger.kernel.org
Signed-off-by: liuyong <pkfxxxing@gmail.com>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifsacl.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/smb/client/cifsacl.c
+++ b/fs/smb/client/cifsacl.c
@@ -1061,7 +1061,10 @@ static void populate_new_aces(char *nacl
 	 * updated in the inode.
 	 */
 
-	if (!memcmp(pownersid, pgrpsid, sizeof(struct smb_sid))) {
+	if (pownersid->num_subauth == pgrpsid->num_subauth &&
+	    !memcmp(pownersid, pgrpsid,
+		    CIFS_SID_BASE_SIZE +
+		    pownersid->num_subauth * sizeof(__le32))) {
 		/*
 		 * Case when owner and group SIDs are the same.
 		 * Set the more restrictive of the two modes.


