Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216002;
	b=DmxfH0gPCr2zfOlpBo27twYM5qvSaj1K4ZSDR0G8PDwNh4oR1ykEZW84bEiQcyr8lIIF
	 u+norMwrRGnZNYLFepjjJ3dcRgreyfSwYn5LpxJGZC4/3EgAmEhVLJ+qmJykMR/21fx2a
	 1Gb/lhAeXYAeeev2dPNk3wRQ2NAKIZVNnE7cCfeSaCYg/OuOz65lJL7DmNp5cDLIGh+G7
	 VO60Y1nrseMa4FDA3MGrWhZV2mP43J9SoRleXsAcdir2DEaxwBAWoV2CPKnXRO5YPe9ww
	 dQNlPoTqs1XQRRIiAvZp/VIWtDTD7DezMdZ5ZZxlWUSp0sSxDwMWwDonoMtb5jWv8Rw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216002;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=H/a2gMQ3goTS7Qe9nHYlIzoXJpzn8soyEi6mQ/t4uJg=;
	b=WvKDihYDOlWqwlmlgDr520EdXK2IpNEnSXHxq9gU9q+XQS5lW/73lIynz0u21/Lfa9n9
	 MO6lU+4U1088oqRC2cND2xPY+huq+RfbYE7LYG+u0IBLVu1C7zEa6TV9wFHS7N2q2ZEF/
	 HVOlb2ja948iOCG2yWSKyYGzSqZd6eQBpR4o623V+qEV45eoj85DawIEwXsDMc64VJZwH
	 C9Bv1GBGxRUJO0iRqzqGHnmR3vo7XQ+9EK1sAxBmpYPpuNKRm3HF1oquyarlBVeirFoEZ
	 9AlRpcvnbCs3amn6tl/E2ChOqudHO3/7tpynZXGHlEjioSxH0roFQ6gViE3HwTPIrOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mNAOxKHC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E5B3606A31A;
	Wed, 28 Oct 2026 19:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mNAOxKHC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCAE31F01825;
	Wed, 28 Oct 2026 19:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216002;
	bh=H/a2gMQ3goTS7Qe9nHYlIzoXJpzn8soyEi6mQ/t4uJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mNAOxKHCkFw6evbF3FEMoe6jR9YHbjxc0vdax+Vr6LN67+cvB+/kUi8kzYze33bIx
	 SfAELFmBt7NZOfLVfrZek2JHwE5teylQHNxP4rOb20oaq1/nks3El3UTqop+oHxpWU
	 ofuejrjK0aoVjxefkOq6cyZyDdJJ6I4gMpNvGb8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1405/1887] SUNRPC: svcauth_gss: enforce krb5 token minimum length
Date: Wed, 28 Oct 2026 17:58:21 +0100
Message-ID: <20261028170531.426221161@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Chris Mason <clm@meta.com>

[ Upstream commit a919c5c88769cf8fb3ec071e6078d830bf512489 ]

svcauth_gss_unwrap_priv() validates only an upper bound on the
wire-supplied opaque length before handing the buffer to
gss_unwrap():

    if (len > xdr_stream_remaining(xdr))
            goto unwrap_failed;
    offset = xdr_stream_pos(xdr);
    ...
    maj_stat = gss_unwrap(ctx, offset, offset + len, buf);

The wire value `len` flows unchanged as the upper bound into the
krb5 unwrap path, so a len in [0, 16] passes this check and is
handed to gss_unwrap(). For a krb5 v2 context that lands in
gss_krb5_unwrap_v2(), which reads the 16-byte RFC 4121 token
header fields at ptr+4 and ptr+6 and then calls rotate_left()
before any integrity check. With a sub-header length the header
reads run past the token, and _rotate_left()'s `shift %= buf->len`
path can divide by zero when buf->len has been driven to zero by
the truncated token. A header-only token (len == 16) is equally
invalid: with a non-zero RRC field and the opaque blob ending at
the XDR buffer boundary, rotate_left() builds a zero-length
subbuffer, reaching the same division.

Reject the token at the server entry point before it reaches the
krb5 unwrap core. A valid sealed RFC 4121 token must contain
the 16-byte header plus at least some encrypted payload.

Fix by adding a minimum-length check immediately after the
existing upper-bound check:

    if (len <= GSS_KRB5_TOK_HDR_LEN)
            goto unwrap_failed;

Fixes: 7c9fdcfb1b64 ("[PATCH] knfsd: svcrpc: gss: server-side implementation of rpcsec_gss privacy")
Cc: stable@vger.kernel.org
Assisted-by: kres (claude-opus-4-7)
Signed-off-by: Chris Mason <clm@meta.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260524010213.557424-2-cel@kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/auth_gss/svcauth_gss.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sunrpc/auth_gss/svcauth_gss.c b/net/sunrpc/auth_gss/svcauth_gss.c
index 7d15429dfd7ab..5567c1f426a79 100644
--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -1003,6 +1003,8 @@ svcauth_gss_unwrap_priv(struct svc_rqst *rqstp, u32 seq, struct gss_ctx *ctx)
 	}
 	if (len > xdr_stream_remaining(xdr))
 		goto unwrap_failed;
+	if (len <= GSS_KRB5_TOK_HDR_LEN)
+		goto unwrap_failed;
 	offset = xdr_stream_pos(xdr);
 
 	saved_len = buf->len;
-- 
2.53.0



