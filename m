Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044289;
	b=azQXxOUXWBxmIf2Kp+LL+jelfCRsP1zv6a38U0gCVMrQ4cQMm7cfE34p4z6EvEYFbOCP
	 HV4YTlHjNonI83MZ/EUTMxNTYMJ8eRxyvfbmsBXshMDKqrsFE38Z8pEQLOAiZUyy6p09L
	 0KwkXtqfiugk49//tH7/hdQokxoQt6ayj2jwXlEuNKgAnSgiAfss1dChx36XI1ZxS1Oum
	 18cGTlLCOIDbRWNw5wFT6/iPN3yBjKAYCxfABxNdoLY1lX+VSZYgGzOCDqIZ5cI/2rDj7
	 SXHGtTXWRn6O/dGfiJRjEHfzWFOT+NkyeKzi9VnT59O0imOtLrwme+Ll0Bad5JmjRZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044289;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hr0l8TwfsZ+zAfUKz9e4yaQ+7lKPGUv8SfQ0fofBORk=;
	b=tFMnkvBhc7IUi7UluzHbsLp1/2SOIItYkK5pamxpA13w2/DcoYmu2F6DcEOqQZPXJlRA
	 shia9G0HEnDYBD9ZeWxjNFFQc8S4KYC7MPzSps4THd2lUZcHEYXzgHMJ4qLQJyB9DdEeD
	 +5tU3e1n3hL8Jp1nkHAmXW1lFX5qb2UoRb6bKi1FGh+2cP2G/eYL6SjfnxdbC2vCb/gJn
	 g4bZkddO7SVGLkW6wNv6o/aFymmdQk5bgFANMECgmwe6vhY5naxBJoTdjfpULr/R/wVjX
	 6QHAUP+cZu0VA5ks2yXwgSfXyuxgDYX6rd4nuKgklE97cUxhobovIFw3bYDnvIupQxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HQdtxQiM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ABD4606A32F;
	Wed, 18 Nov 2026 23:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HQdtxQiM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CFCD1F000C4;
	Wed, 18 Nov 2026 23:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044289;
	bh=hr0l8TwfsZ+zAfUKz9e4yaQ+7lKPGUv8SfQ0fofBORk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HQdtxQiMkdtZ5Rz7c+m/bLeA1KsNFFS2rsGQOC/fI0oDSQxxq4uU/MjSJIoDmA8CN
	 W+ZVwKmTAvYzyFN6BMV2sP84GhtNPO6XTWKM4S+jATm6gxOau57w/PeVh4uU7E+1+L
	 etbxnfUlo0Sth/bRXr35ECigHx1D2pY62n19twwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tea La Forgia <tealaforgia+alias@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.1 0512/2857] ksmbd: fix extended session security negotiation for raw NTLMSSP
Date: Wed, 18 Nov 2026 15:25:46 +0100
Message-ID: <20261118150219.897822745@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
@@ -452,8 +452,7 @@ ksmbd_build_ntlmssp_challenge_blob(struc
 	if (cflags & NTLMSSP_REQUEST_TARGET)
 		flags |= NTLMSSP_REQUEST_TARGET;
 
-	if (conn->use_spnego &&
-	    (cflags & NTLMSSP_NEGOTIATE_EXTENDED_SEC))
+	if (cflags & NTLMSSP_NEGOTIATE_EXTENDED_SEC)
 		flags |= NTLMSSP_NEGOTIATE_EXTENDED_SEC;
 
 	if (cflags & NTLMSSP_NEGOTIATE_KEY_XCH)


