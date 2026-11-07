Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061537;
	b=ygZTpYVzYU2fESOqfkTNzme6Ai5zCJrEOrf7ra/mMyo2n2VUkttSk9fH3B6fQWi2+W5j
	 yt1KGCDmT8lsYsGzsvQgcJnnghZUlQzmgRMyO9gv13jBsr4/lmD0Szd+grWf3BlsD7BFC
	 B3Jj/4BjdhB80MCI7KGoIlb/Y9wU1PJTkTXf6ewyEHicInUHA9s03whWtDAOsEmv1OS4q
	 dQLhO3l3Qo4cAgPF4LV5OMx48wclPZzB+eciVCeoGml0PrR41fIeYWAMKbk6FfOTxGTX5
	 mqbq5lkPoLfXo+BcF4Kq0McwVS97h6JyKYpHSmHclSfN1GZDiQTlbdKUt9jeRiyI11A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061537;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RHXaoM/k4erG3u8h56BBTRC3vVvefYfiUcbXKd21EsI=;
	b=QGeowkgw1QK7y7A4b53Zc3z3YxVC0G2eBOkvsiyR6WJxUYX1KHm1FObyrLWWwMo2zHbo
	 gRUdAlpWruhYXypRVaFyeU2iPxrbjNV5VOnK4tx3OO7Qp25HLaneZwu4gYD83m5t7Tw7E
	 E5cxgRmPplCcAN32sTTwWXoKY3VU7zcs10IZfqyozc0dneG9xeI5MZpqP+SGrZg3ZoY/9
	 5S3m7QYjBPi2Rc3u2v4AwAqrtKqK1T9rmGZCJFQZ0UUBhFuybhm639qbXA1q15y/3z3gh
	 W0pEWJHN9FmmvrgkDQas3AL8r+E7HJ7bwu/DTXb5EijfAf0R56HdTiFqZS/3QQMuDWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dOw6JJlv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B1DA606A326;
	Sat,  7 Nov 2026 14:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dOw6JJlv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B107C1F0089F;
	Sat,  7 Nov 2026 14:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061536;
	bh=RHXaoM/k4erG3u8h56BBTRC3vVvefYfiUcbXKd21EsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dOw6JJlvdhptfTKEIq6KsYOZqp6rp1hMdNagONA9Fls80tULNbZ1icAEVyPtB3FLU
	 H8XvTRZEXfIvCIUPIzosCGxC9onTZheoRoaoSkirz34UtnTMbMBWpYOFthH9polSBd
	 IdF6weJgkt+ngWcMf7B+siQ2FKwakYmTSL11Lvgc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tea La Forgia <tealaforgia+alias@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.12 0584/1536] ksmbd: fix extended session security negotiation for raw NTLMSSP
Date: Sat,  7 Nov 2026 08:43:20 -0500
Message-ID: <20261107135013.946912716@linuxfoundation.org>
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
@@ -446,8 +446,7 @@ ksmbd_build_ntlmssp_challenge_blob(struc
 	if (cflags & NTLMSSP_REQUEST_TARGET)
 		flags |= NTLMSSP_REQUEST_TARGET;
 
-	if (conn->use_spnego &&
-	    (cflags & NTLMSSP_NEGOTIATE_EXTENDED_SEC))
+	if (cflags & NTLMSSP_NEGOTIATE_EXTENDED_SEC)
 		flags |= NTLMSSP_NEGOTIATE_EXTENDED_SEC;
 
 	if (cflags & NTLMSSP_NEGOTIATE_KEY_XCH)


