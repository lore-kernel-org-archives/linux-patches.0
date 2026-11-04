Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829076;
	b=fg+6eeqR/8N/KkF9Es45M1VzlO7+HcZbzGf03DRqkBeEhpFRoCHsdg44SMUAxfTZzayP
	 xFukWfF2ubwOFwfALtLid10cPgBJAQflKy7SfvXp+Xze6pmemyGnbXWvAvdLt7lH7+7Dt
	 dMrb7XAVUaJ+zKEFG2b5iZL6lsCZeuY6uF2DFybFkIqoYKly6fk/8EZPtTSYyWG1e8RCj
	 n2ZcTstEL/qnU1FDe1ZPmolLATJwGcLubOmy2rKRHFC5LpVJMmNMrHJETRevhqGRnGBmM
	 OuQEoixKXwilLVamG0xCupX66CLyCV4i6zEIsdtEisIM7J8G54s+1qWHRPu4GlIZDdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829076;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GmgQPJRmsZvUNnSW68o0qKwPpmfHrLB22FyiJfTSBNw=;
	b=lo7Bqwysn4kPjF/n7apdJ+Ti8Jtnk+5Ke7fblJdpqpGGMIXh8ULTpTIUWztZePYPzAjG
	 GBbGcgaqx/8GnFnvy5u7ulhS1J8hcWqfdr9aSpsAEeZU/3f+YfuzBm68PPOIQLEDAHk9j
	 Dzr/XOL3VJXG0GF3CyGqzGWWQdUxZXxoqxciLIcD7k2/KEdgu7zq5tpSdiZ+/6mSBF3j4
	 7893sBV4ZxBG0dQbkmQZNK2RCHA+qPjBI79DmneWC486qFzx9JZsQj0dheeogoPaiCvf+
	 rmgVT5cSn+NYS9euNLlIQYmK5tB+elKvrOA2GE74xADRp2V7y7mwbucrjz+O28NnWow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XmpIi6wq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE06D606EEB6;
	Wed,  4 Nov 2026 21:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XmpIi6wq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E6F41F00A1D;
	Wed,  4 Nov 2026 21:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829075;
	bh=GmgQPJRmsZvUNnSW68o0qKwPpmfHrLB22FyiJfTSBNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XmpIi6wq6XifAkPOR7ntdqOroDLUhQzE9kl1FTEGJazm/01weeGoKaXmKfPjafi8z
	 tKHihYDHizxk4lt+LlCQQTZs/52jJICqntRK0CoZ5+/DYeA+N4wfzwVTYCBKl60QPl
	 Th679nbuGGxm6GN8gW9cFLc2NitrP9yVqYNT5XZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 7.3 427/547] nfsd: propagate SETXATTR value decode errors
Date: Wed,  4 Nov 2026 16:10:11 -0500
Message-ID: <20261104211050.475905178@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

From: Aldo Ariel Panzardo <qwe.aldo@gmail.com>

commit cfcfe0b38a66bbc4122c78a2b75e1b97b3534761 upstream.

nfsd4_decode_setxattr() stores the status returned while assembling a
non-empty attribute value, but then unconditionally returns nfs_ok. An
allocation failure can therefore leave a NULL value buffer paired with a
non-zero length and allow compound processing to continue.

Return the decoder status so that the operation stops on the original
error.

Fixes: 23e50fe3a5e6 ("nfsd: implement the xattr functions and en/decode logic")
Cc: stable@vger.kernel.org
Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260915125636.2849626-1-qwe.aldo@gmail.com
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4xdr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -2454,7 +2454,7 @@ nfsd4_decode_setxattr(struct nfsd4_compo
 						&setxattr->setxa_buf, size);
 	}
 
-	return nfs_ok;
+	return status;
 }
 
 static __be32


