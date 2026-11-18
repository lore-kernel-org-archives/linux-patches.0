Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051831;
	b=xjmNEeaiDuWKm8qfY/fw3n9WApPtTR2KvBIU0aAK4XfkJyBobVyIDTSX7zk4WwlMJyVj
	 o3gXYLyJVmTkJNY0SpaKa9Xzt1qkZ6asaYmdf0nxgYISLWUoZfYkXh+D31eSplV7leO2m
	 +YRw5WrKE6ZMfhj33qdytLFiwjMT82eH9UyZkjlrHM7UbwD8edrTRFPUtmp/JbWoOjjXh
	 wxivT+g6bXNQYrY3I/zwxPwD2/sJEpaYKXbCWImqBfzvlHQvF7u0bWYSfgfzf6RgUWwq+
	 mim/Ng1Uqdml1lzVFMkVBmlu1vTjQoofTWO68qmoz3mWhLO+ynG3WUFlxqLPsvlxVzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051831;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=D5MS2utJ70qHpbTNw1wUVRlD8sEgEFMNbe7aTEY9x04=;
	b=tPmNeotaN5KW9nZCmc6s5NyO8BAgSVUeW+YLcU5Vqrwd2ABMscCAEtPXKCdhVbI79ou4
	 9iPmUtbTmOkfUjEBwml3YQQUUer9250o7nBtTg1X09cKNQd4OeSpLq2veNmk0PU1Zh5RM
	 iScwheByVjhk5iDDgKlHqheC1j58IXfJQwJnvTnuS83s8U9BA2l/S57rbWuIC5msRV5bz
	 wBpB2tefkO681WQllUZpA9BwWjQes55zJUmVk0E/DbnmR/bU276oG4wz76uFCG4wyNfhQ
	 h2Lj9eX+T+jhAzkf+3KPsZGQ+K497ETk88ucZjR4KHo5eXH5Y0sGk7QCUAL1UHFWhRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qXgrddrh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9A81606A320;
	Thu, 19 Nov 2026 01:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qXgrddrh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 437C91F000C4;
	Thu, 19 Nov 2026 01:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051830;
	bh=D5MS2utJ70qHpbTNw1wUVRlD8sEgEFMNbe7aTEY9x04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qXgrddrhKdWMN6eXeUVROfsjAwoFIpfd2j5k00E8Ln6JqI+k5fMD5+SE/zQyb0OvT
	 4EIHGWSfBYk8UotOVPGkXXYnncM0F0lKbeNCMY55VCrVI6y05a5YetqtyH23Z/F+0a
	 H7sgQkdpDxH6w5+TAMs8n/nLbZcDU13Z4cavd2iA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 5.15 0347/2214] nfsd: clear XDR padding in GETXATTR replies
Date: Wed, 18 Nov 2026 15:33:43 +0100
Message-ID: <20261118150024.591184904@linuxfoundation.org>
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

From: Aldo Ariel Panzardo <qwe.aldo@gmail.com>

commit daba58690339ae86f1ebeb5197aa1369fae37e57 upstream.

nfsd4_vbuf_to_stream() uses a raw memcpy() for the first fragment of an
attribute value. xdr_reserve_space() aligns the reservation but does not
initialize the extra bytes. If the complete value fits in that fragment,
the loop that clears padding for the final fragment is never entered.

A remote client reading an attribute whose length is not a multiple of
four can therefore receive one to three stale bytes from the response
page.

Encode the first fragment with xdr_encode_opaque_fixed(), matching the
final-fragment path and ensuring that any XDR padding is zeroed.

Fixes: 23e50fe3a5e6 ("nfsd: implement the xattr functions and en/decode logic")
Cc: stable@vger.kernel.org
Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260915160119.3105745-1-qwe.aldo@gmail.com
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4xdr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -5045,7 +5045,7 @@ nfsd4_vbuf_to_stream(struct xdr_stream *
 	if (!p)
 		return nfserr_resource;
 
-	memcpy(p, buf, cplen);
+	xdr_encode_opaque_fixed(p, buf, cplen);
 	buf += cplen;
 	buflen -= cplen;
 


