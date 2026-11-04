Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831334;
	b=oGdokODkN/5wukCMjv8y+0eaF/eGS0vzxJJ35GczXTb6Y34YmfPYxZz6oDf2SiqLFiny
	 MNIaDhcGbkK0NdR/3NUROowlduUg7ElHsVQRkEFScFomCcVWsTszSWmgxLSKwG8k8/rpc
	 6CbZTpX7hSBFj6VIq0jk00PhZC9i8SBIIJMMXlfLjxHOz8iJi7fhs+mBQnNpgPLtTyJXn
	 dQu0ffCqYf3FGFGypfaWyXX81wPfKa9enJXm3/xhyvh6OFBPv2ArYnV5MO92LgwfzIlPF
	 JJ2PZVutpc1r7wAqEhcF67W3Ffeh5ZsdHB3JWXFudHm8ZbUaw/Cai08SiRxBy+HOzcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831334;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TkN6EsuLDYA4H7XXGgHBwUX6BB5wR9r4iIsWAS877xE=;
	b=BJNYSpn/CN/MvkSxmxw32Kwmz9wgGgydPkezt26yfVOUsKmiN1uljgVbaA/Twm0Erj5e
	 at/bauXY4Tq/517uoZqDakquW016oxLi0luCgiYXM5Out5Fg5X+i1FkO4ZdbxWWoeuMFR
	 iy2bjhVpI6F3t5nIv3s5WFUT6zPiW9MGW42i6BBwMZSluNaAwLKz/ac3M9TocKsITBYrg
	 FWzlR3c17U++hCnVDlegbmDjyV2PJbWK5U/u+Kw9f1HpHeP4jAtVASlbOYo1lMIEq7/Le
	 YjDChvYt4peZF2WQFZuQSbbcv6YnKP0RpfHCBSZvMRHUHbYL932I707DYrTWKO8pLlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hcwfqiGl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3B0B606D828;
	Wed,  4 Nov 2026 22:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hcwfqiGl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 510051F000C1;
	Wed,  4 Nov 2026 22:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831333;
	bh=TkN6EsuLDYA4H7XXGgHBwUX6BB5wR9r4iIsWAS877xE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hcwfqiGlcnhMK7/PqhwDQoHbKgxlQI38oXLzs/YBYYsFQzgu5n4Khjj3czu6450FO
	 7JBQpS9SzWY8rZXriJzng501OUtrNJErCvBUZhXxdl3ZZGy0cLFHd+7PjSJ+ggE/Cq
	 swd9Ksp2QuV+dJu/SDA3/bSHOCAoIQ4SDM0GxJMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tea La Forgia <tealaforgia+alias@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.18 0642/1005] ksmbd: fix extended session security negotiation for raw NTLMSSP
Date: Wed,  4 Nov 2026 16:06:15 -0500
Message-ID: <20261104211101.737072119@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

commit 6868f857514bbfd2ed10b9b566664dc4a8ca039d upstream.

ksmbd_build_ntlmssp_challenge_blob() only advertises extended session
security when conn->use_spnego is true. As a result, raw NTLMSSP
negotiation drops NTLMSSP_NEGOTIATE_EXTENDED_SEC from the challenge even
when the client requested it.

A Windows capture shows an initial SPNEGO authentication succeeding,
followed by a raw NTLMSSP negotiation on the same TCP connection. The raw
challenge omits extended session security, and the client does not send
an AUTHENTICATE message. The unfinished session then occupies the pending
session slot, causing subsequent SESSION_SETUP requests to fail with
STATUS_INSUFFICIENT_RESOURCES.

Set NTLMSSP_NEGOTIATE_EXTENDED_SEC whenever the client requests it,
independently of the SPNEGO wrapper, as required by [MS-NLMP].

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Reported-by: Tea La Forgia <tealaforgia+alias@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/auth.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/smb/server/auth.c
+++ b/fs/smb/server/auth.c
@@ -332,8 +332,7 @@ ksmbd_build_ntlmssp_challenge_blob(struc
 	if (cflags & NTLMSSP_REQUEST_TARGET)
 		flags |= NTLMSSP_REQUEST_TARGET;
 
-	if (conn->use_spnego &&
-	    (cflags & NTLMSSP_NEGOTIATE_EXTENDED_SEC))
+	if (cflags & NTLMSSP_NEGOTIATE_EXTENDED_SEC)
 		flags |= NTLMSSP_NEGOTIATE_EXTENDED_SEC;
 
 	if (cflags & NTLMSSP_NEGOTIATE_KEY_XCH)


