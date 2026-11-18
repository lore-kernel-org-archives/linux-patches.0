Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057881;
	b=YtRi/bTjk92ozrDzD6BN2h3/j9642az/5BnW9CZpXj+JJHbkVvNB3nMTgulD3vxaz6Bz
	 jFB26z/OnBAxfX+5IJLvNQg+epDiqyvvn7gaB6xR/rncI30FvJUM8fx3heJU8Bz9PWjSa
	 YOLX3DbR65+3dyqhpHCIDs1mOkDlDJM6sQuXRQKYC0wns3m0gH6Itb8m256G2yhDbw80w
	 ONyroLHbD+Bpaup9eNVESFj0wHS+RyXGysHW7xEcIxA9VJsJvVSgSPRmK+WpTJDxY+Roi
	 sbUuBZ8Br60U17o7IFcTQnWp2SocqArOmKtcRLZCUYJ8bjtjKJ4Dhdp62CnsXTxLT6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057881;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=quEtu/aJ043+YOEwOmQkk0qQfBbEDzqInxHiSlMfdOI=;
	b=HwpKWk8cgyMktePKZ+gzyv+w7Qs4u/TRXUusCelmENPBn+fjwti/yKB2lo0RWskftAKW
	 nrG/ypriqk/YkkX7Ekr7OG7GoASnBtoR9ADS05xkNHBWrlmrM/CW1I2iAMhS/kBe6/zHa
	 XUp1vrgp9FBl5+uRPwIIGz8R59n66lKo6gw/h+3oVQ95CX57Tk/B1Oa0Tru7SbD1czy1/
	 9+AxL3MBCNJ0Fq+kJnPDVTpgLEp8cgJXAklGi+4rQhn3ug18r6/tE5R1LNBcEVdNuid+F
	 3KIG7U3foRVS0JrY3OhyErl/GG3nAQLzwtjCYEa5LwOTXX8p0YodAS1/bcq+Lvf7TwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J5woEaoB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08716606A31C;
	Thu, 19 Nov 2026 03:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J5woEaoB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 561651F000C4;
	Thu, 19 Nov 2026 03:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057880;
	bh=quEtu/aJ043+YOEwOmQkk0qQfBbEDzqInxHiSlMfdOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J5woEaoB7YLfVHPhmruCaGNqeXxeiQ+O+P7UqC7qyOQR6QH80ntN3QiRjKYlOxKm4
	 vROe1UN8gniRyEKbPtCH7UFB34SM3kfgqBl6fVtenqIMkfrkFJCWU4uITPicGO1CAj
	 URlJ/X/Ew34AqgkhCmsbgVT1NERJH1BhRDmG3D58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 5.10 0287/1848] nfsd: clear XDR padding in GETXATTR replies
Date: Wed, 18 Nov 2026 15:38:45 +0100
Message-ID: <20261118145924.158320078@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5044,7 +5044,7 @@ nfsd4_vbuf_to_stream(struct xdr_stream *
 	if (!p)
 		return nfserr_resource;
 
-	memcpy(p, buf, cplen);
+	xdr_encode_opaque_fixed(p, buf, cplen);
 	buf += cplen;
 	buflen -= cplen;
 


