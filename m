Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625949;
	b=E0dfUoSOzv60eKjDaTKZUANQeyCkm/fvxYHkp78Fs3Zrqz7r9IJZngbZY8NFpWhWGdNI
	 UN/6papC48H7n6SV4zHi4NoY6CMOBYrAAP5gozip7vF5B85KL0r38vVK7J2fDVQ7eToNc
	 kSSvgPCajKZrFQ0XzK7x7NtMhnExgn15yQ/tCoXRQwWwN0RyUGkD5WkO80mwUeBmLkBC8
	 wCbRDkYd44Bul/6Rexx7sUl8HwKfFE1ayqg7MMoAv+VqxVr2/buwCeI+eXX+nXOzniBwn
	 9RufiFW42k/3Oszf58h8wZjP4GVtnhcrbZbq1uqvN5IELKw3XajAdZrWwvrEXxiAmgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625949;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VBL+EOgf4aE3CQoSOysCGP2msnsG3O6LNBvXLiq+ato=;
	b=xckhsb1/1lcZPH9dUTRXlRZFlv700z66KbPcSKBU6w1/tJQdHXZjISmx70EPYrZUqpBq
	 ciSEGdJqDXfSDQvzyB6OIy0AM8xp/DMVhAga1j274d+97fKK6owYmsXaaAHje+QsFAvN+
	 /+mln3SNOoGCB/5baBPh/DSs0cn7aIkiohAPLLCwb4ZS+yU47Msefbr0nVv7Ljb0cC88o
	 4+R9hmScM9rDgTrzZEiaDrVKfmgyivpwWP4UOUrITG1CQp1nfUlxVaT7RVbJZJhREmhNa
	 6rRcc0/h6MbVINbbM5U09CW9OxCsEN6FgkwWim9rPd7LnI/274KlXJxdKHuUoAbVXzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lvEmmUPx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AACF1606A327;
	Wed, 25 Nov 2026 16:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lvEmmUPx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E53E1F000D0;
	Wed, 25 Nov 2026 16:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625948;
	bh=VBL+EOgf4aE3CQoSOysCGP2msnsG3O6LNBvXLiq+ato=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lvEmmUPxYKO2KnGwwTds9i4KKVDo6MuAyrak8yyA2wilUGs1H1bnuQ+wBZB4Sl/+A
	 /ioN09u54tKWYqCfmbL+H6qpDibfLgd3NVy8UxK7fR0hzKPKavIAnz1TqREo/hLvec
	 FnvwWBO+BqZw5YM7cZ2jOPBPyy6igC40THLmWw5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	liuyong <pkfxxxing@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.12 682/816] smb: client: compare owner and group SIDs using their encoded lengths
Date: Wed, 25 Nov 2026 15:37:10 +0100
Message-ID: <20261125143904.968443489@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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
@@ -1062,7 +1062,10 @@ static void populate_new_aces(char *nacl
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


