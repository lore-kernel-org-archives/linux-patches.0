Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215982;
	b=GBQeIzTkrJwtNBIrZD0E5DpsydEUGzQ+QtjrCVMC36YuHQEyDc46l47lTTbxy6uuXBeA
	 08LJcvgS2fk+QOYH+rFtW0fEQjkwBUytOnw1EaQEf7SYcczmIKwAXV3PPXarTavWxLgI0
	 eCXDFpMsp2gAzMsV3wJSDnpt93Q343IMj+lND5IJPf2XusYPSB3cqv5DYUF2x16/DQTfx
	 KBzzkQJ4y7iEfcqIjC5juMTPxZ1erpQi8tkaDpXjeiN0DzF8+f334GM63z1WeZd/2pyt1
	 PecySRTnXbwEXbGoLrzmPlt7zZEnujl7BIUWxk+p5Vd3mYyBwttTjXBxlO7Z4hByPvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215982;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VpUff6sL88Ix9AYbNgIw7PeaYFY6Svs1c/CRkXJ5vgc=;
	b=3JwDLOHLOQ1IZNz3MTAXoZasGS/cLxZXY0q9/0ymLh/8BKkKPNUs0zZv1SyniheKnS+c
	 /lGsEvBQh8OqBAb8r7XqMdJTqm3SWbCAunGhotVgYoIUr3R8Ufh5WM35efhICAsWlQzHd
	 qdUiNyKNustMSDsxaPcC9ITGEA0dwOdXjERroY0dW/9aLJ3R1AmQMaWzkj5ABoG3AUB+e
	 BwdJRcN4f9j5XyWPjzZZ/GC8+h/BejI6wBAF1SmaTMlYvek6ui1fm3uJ6L4AlPnGO8Ts9
	 WpmOBtAQmj0UtzYSKIgzNTnhqjXfYWlOpv0mAjRkhHWUN4fL0Xy4Q65WkS9nZ+9Xg/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oqjX5mMm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3BA3606A323;
	Wed, 28 Oct 2026 19:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oqjX5mMm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F41E71F01828;
	Wed, 28 Oct 2026 19:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215982;
	bh=VpUff6sL88Ix9AYbNgIw7PeaYFY6Svs1c/CRkXJ5vgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oqjX5mMmzpOkHtdE6UsypV9DDw0ftdzXL/YodiFuYXRpjzaKRUoYZEoWsJxnrFoAV
	 3ch9O61B+UXUCWavUMiYswNQ0JhWN4OAYDvWCo7UnwPdHWiZgCM+HgIruZSmIsernQ
	 OOhy898laZTTOMFgIJo2VQW6Dy0OIqK2/WDXv9OA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1399/1887] SUNRPC: Reject short RFC 4121 MIC tokens in gss_krb5_verify_mic_v2
Date: Wed, 28 Oct 2026 17:58:15 +0100
Message-ID: <20261028170531.287350101@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit b94f6719dcd9f7a609bc5f459f85795900e77d25 ]

gss_krb5_verify_mic_v2() reads the token ID at ptr[0..1], the flags
byte at ptr[2], and padding at ptr[3..7], then passes
ptr + GSS_KRB5_TOK_HDR_LEN and cksum_len to gss_krb5_mic_build_sg().
None of these accesses check read_token->len first.

The minimum safe token size is GSS_KRB5_TOK_HDR_LEN (16) plus
ctx->krb5e->cksum_len (12-24, depending on the enctype).  All callers
accept shorter tokens from the wire:

 - gss_unwrap_resp_integ() enforces only an upper bound
   (offset + len <= rcv_buf->len) before allocating
   mic.data = kmalloc(len) and passing it to gss_verify_mic().
   A malicious NFS server can therefore supply a short checksum
   opaque, producing a small slab allocation that the Kerberos MIC
   verifier reads past.

 - gss_validate() enforces only len <= RPC_MAX_AUTH_SIZE (400)
   before passing the wire-supplied length to
   gss_validate_seqno_mic(), which constructs a mic xdr_netobj
   and calls gss_verify_mic().

 - svcauth_gss_verify_header() enforces only
   checksum.len >= XDR_UNIT (4 bytes) before dispatching to
   gss_verify_mic().

 - svcauth_gss_unwrap_integ() checks only that the checksum fits
   in gsd->gsd_scratch.

Add a length guard at the top of gss_krb5_verify_mic_v2(), before any
ptr[] access or scatterlist construction.  Well-formed MIC tokens from
gss_krb5_get_mic_v2() already have exactly GSS_KRB5_TOK_HDR_LEN +
cksum_len bytes, so valid traffic is unaffected.

Reported-by: Chris Mason <clm@meta.com>
Fixes: de9c17eb4a91 ("gss_krb5: add support for new token formats in rfc4121")
Cc: stable@vger.kernel.org
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260523165237.510204-1-cel@kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/auth_gss/gss_krb5_unseal.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/sunrpc/auth_gss/gss_krb5_unseal.c b/net/sunrpc/auth_gss/gss_krb5_unseal.c
index ba04e3ec970ad..b7adf2fc7cf50 100644
--- a/net/sunrpc/auth_gss/gss_krb5_unseal.c
+++ b/net/sunrpc/auth_gss/gss_krb5_unseal.c
@@ -159,6 +159,9 @@ gss_verify_mic_v2(struct krb5_ctx *ctx,
 
 	dprintk("RPC:       %s\n", __func__);
 
+	if (read_token->len < GSS_KRB5_TOK_HDR_LEN + ctx->gk5e->cksumlength)
+		return GSS_S_DEFECTIVE_TOKEN;
+
 	memcpy(&be16_ptr, (char *) ptr, 2);
 	if (be16_to_cpu(be16_ptr) != KG2_TOK_MIC)
 		return GSS_S_DEFECTIVE_TOKEN;
-- 
2.53.0



