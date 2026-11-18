Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035002;
	b=qxB1JPJ0wJtDL56r04iEKJDJDZ6GnDOR/Swq+4EUsWKCHOyWIF3A/UPuNNLNTJUEXzfl
	 lWHwZNqmCxGv0GysCRGcDNV0PYd9b8SNbyDbMcUYZPgqgjUE2yl2sJXB8ROOU35SEWKHB
	 RvEbi0uI4Zj257IPPiGFyRTUDHnrb25fthU+sseZI4Z39mPNfLKg0o+2H38geGv9/Lrpy
	 YJkP+sqU7Y6owbUyyhA/PEtSGWvOGfNqZqL9MApr4CyyfbEDxVHfG718hx1upOE/CBb1A
	 YJFejomEWvvhLbCo9PV4LFD4mMia02DRgDhMUkehJ+0RzB16Sy5V8HfVrhJ5XVLYkQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035002;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OkUCKxkDWEbba7kI0A0hWBEr4sl6ps2W+IdQhGJngro=;
	b=OmpFaWFQexDFRyBu3giaVgYpg3KKHuQ7MwK9yT1rGukL8jwcvk91WCVCl3hYDuxWeZAc
	 jwUzV0lodOHfrtfrWtcrqCvgXeHJXywVDL5Yd0P7dByNSFMFD07wWnfO/RYn8b38doYpP
	 gUMC+9V+XeG7QqWCE0aDFmEB9Mtkh8l0j9nPKcUoA+8mtIMVgeK9mPR39yyNNKNU5Zv1C
	 WRsvyG+2Jw5jXSlGeHrrus0Vp2Q9g10dKNehHRLvoagx/EryipTp0Uhm8fhbDtO/G/ITZ
	 Qnx8P0sJ7UCf6f/VP+fzqhzqMiXNKdhg7Psw7Txo4We8Jr+DEXU7ELZzWjBxczS3iEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="z3V5/cBX";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C6DD606A325;
	Wed, 18 Nov 2026 20:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z3V5/cBX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 995D11F000C4;
	Wed, 18 Nov 2026 20:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035002;
	bh=OkUCKxkDWEbba7kI0A0hWBEr4sl6ps2W+IdQhGJngro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z3V5/cBX0o3MJH3JIl5tfha7genXODPY1c2NibOuCyTjBQitmQOmW25xNKH1xR55N
	 eyIWHxaxBRZBEQvYhySLjz7lP8bNOdwI6BSPnphn5eglFRW4Cl4G4nxeQCDdDzVe5I
	 TuGNVO0lhj4rpfPPjJY3+cZor+LRD/oYUw/aXMF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tea La Forgia <tealaforgia+alias@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.6 0569/3318] ksmbd: fix extended session security negotiation for raw NTLMSSP
Date: Wed, 18 Nov 2026 15:19:51 +0100
Message-ID: <20261118150334.490941674@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -453,8 +453,7 @@ ksmbd_build_ntlmssp_challenge_blob(struc
 	if (cflags & NTLMSSP_REQUEST_TARGET)
 		flags |= NTLMSSP_REQUEST_TARGET;
 
-	if (conn->use_spnego &&
-	    (cflags & NTLMSSP_NEGOTIATE_EXTENDED_SEC))
+	if (cflags & NTLMSSP_NEGOTIATE_EXTENDED_SEC)
 		flags |= NTLMSSP_NEGOTIATE_EXTENDED_SEC;
 
 	if (cflags & NTLMSSP_NEGOTIATE_KEY_XCH)


