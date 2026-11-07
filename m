Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061713;
	b=fbKWu3I8gW+eHYofOfEsZsvdDCbtP1NGb9fLgHviARrDe1EI1PdJN2HpUtj0kKna4s7+
	 dip5dRfTPRqOXApy2mcHn/r0F8fWxbR8X/EjCRMP6u9P4nr5BHDIcdYrPTjCWRDKX6fvc
	 2w6SrfzGwo7pRBDj91CsX2U74qJdhEokDlCfQ1SDEaqa6wDXIGv5lWvgGR6ZhUugHwuf+
	 2nQLglGSpBQ9nG0Okq8xH1cyobd2bhFr1vKe/vdN/E/dkJh3X6DM9DxSKeBoiQAD6SyX2
	 ARFX8oxC4EElaRvBO6fK4RCmRAlnqAmh0S7uO+jHwqykSweyuy6yaCtS12NqaE23pLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061713;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kTuT4IlNmB5ff/7WSIVNBqxXagWG5zCdXxgjjJ5asVI=;
	b=1kTfm5TlKIyzOTVR9cTnVeQA9OnCJRO5vvecRq0ndAwA53pjtLACIRoT+3AWg8k+rGlj
	 OlElE1hYZ20eSZ30UzSsDOC0XrvH8I7X6y135J9PenIPH4nA2uLfkhfuipPzu63NMv+vy
	 D4lPzVMC5r7Ys275TNp6Aishth/w6xUmsY5zlUmu3Xzt+f4osKsoxqcKtBtp4zdy8i7+n
	 1guq4jYdXyHlQjKWwPn0QRVXdd+BI1zcjSuOHZ4HDNLImxP7K6zUGLwULuCSqEquHhuru
	 cRKssVMnGz704RQ8JATCfOfmokSJNFX1c+iOXcSqJFZL0oJqwo7FQ+R8SygcD64yxUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="h6WRsv/V";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06A2D606A326;
	Sat,  7 Nov 2026 14:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h6WRsv/V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6BD11F008A2;
	Sat,  7 Nov 2026 14:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061712;
	bh=kTuT4IlNmB5ff/7WSIVNBqxXagWG5zCdXxgjjJ5asVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h6WRsv/VH2nbIRKEGjXVS0ywu0wULffKm5tykCdyA3T83i/sHaLXXXZRVz4hWMe2o
	 AUyes9QUg2CxJ6U+3yXc0CB9BsaEX7vH2lZlVTXPPrNJaIAQF/Ie40sEMhuZUUWWPQ
	 8XWJmg28SjloLsqtNOLFySG/5YdI1Qqs9aTL+8s4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.12 0760/1536] nfsd: clear XDR padding in GETXATTR replies
Date: Sat,  7 Nov 2026 08:46:16 -0500
Message-ID: <20261107135018.877053420@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
@@ -5414,7 +5414,7 @@ nfsd4_vbuf_to_stream(struct xdr_stream *
 	if (!p)
 		return nfserr_resource;
 
-	memcpy(p, buf, cplen);
+	xdr_encode_opaque_fixed(p, buf, cplen);
 	buf += cplen;
 	buflen -= cplen;
 


