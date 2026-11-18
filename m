Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051991;
	b=BLNGvSvD3bpW65gcw9/jceKZBVmZ2swSAJJH5s9fuwS5umxy2TP2hp3SqwH8ej6kfy8D
	 FIDXT5psTvzAapuHu0F1YVQD0i8bXMN8zjjPyTK+7rOB6OU3sLjg8qROPi7UOXHhuS/CE
	 03rmaU1LNAZaED7foJotsRgSLpIyMYyFMWI6GrDcSJ1OE62VL7zWq157JpV8w0GQsOniB
	 jEz9PgxKlFAICY9DuuPdTDtj+YHMR8GCdh7r+cjPEIGGgN9V/UvcA8APL4bGa08p4BsgC
	 z5gUJGNbTXSAknQIqzjqJ1SLMzEwArsueMBU3jsyFOpsvh3MWW9nTZQcyFvV/P3aYmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051991;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wzURvoas/TZ7clC/feYsXitGY2tfAcl/lozVQNlnVvA=;
	b=Q1/d0heJMr9WtgZat/x+bZY0pydQ3K+hVGDSDP26yzjLwEFnZNmdB4b+WgltiMQCK93U
	 6r9IfL84BqWC/7TAk4Hg0gbG1G4LtMUElWXv3btG09pm+WFt2iYrz+xnM0MauHlzaxXC4
	 jo+tvso8du8T4pV8OvqFlGHZwcOlF+/rTVHiN5/vxuJQG79tKnhIGSlyjc8+xNyjJkxdc
	 yqxzvoZJkA0XT9I6vfwuH5t2F9OhfBrSsH3oeBxjXjAM8odGvWQhiM+orgpvaGqnx0/R2
	 xnb/HfVmRWVt2ZR6G5Aqos2rkqZYPLd/cUfuDSF1gh3MqnxLF1q8bXZRZeiUO9mQZpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0mhDCp9M;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FA8B606A338;
	Thu, 19 Nov 2026 01:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0mhDCp9M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CE5E1F000C4;
	Thu, 19 Nov 2026 01:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051991;
	bh=wzURvoas/TZ7clC/feYsXitGY2tfAcl/lozVQNlnVvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0mhDCp9MJeU04hnLjCwjZEDa92ZY27Ca5r5EvgLCc/klNu3rKKlxDkraEkE78eFf7
	 5TB2dtBjQVoKdAqciiGDY/9m5escSTRG6qAZ/aHzpaC5OqDeepTi1YPySxn9k8Rr+Y
	 0yUCiLu4fddWj3fseh5LcXG8Uw5UmVhqOUy6WYFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tea La Forgia <tealaforgia+alias@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0403/2214] ksmbd: fix extended session security negotiation for raw NTLMSSP
Date: Wed, 18 Nov 2026 15:34:39 +0100
Message-ID: <20261118150026.877007529@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 6868f857514bbfd2ed10b9b566664dc4a8ca039d ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/auth.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ksmbd/auth.c b/fs/ksmbd/auth.c
index cc4233c414b66..0fff634a74e11 100644
--- a/fs/ksmbd/auth.c
+++ b/fs/ksmbd/auth.c
@@ -442,8 +442,7 @@ ksmbd_build_ntlmssp_challenge_blob(struct challenge_message *chgblob,
 	if (cflags & NTLMSSP_REQUEST_TARGET)
 		flags |= NTLMSSP_REQUEST_TARGET;
 
-	if (conn->use_spnego &&
-	    (cflags & NTLMSSP_NEGOTIATE_EXTENDED_SEC))
+	if (cflags & NTLMSSP_NEGOTIATE_EXTENDED_SEC)
 		flags |= NTLMSSP_NEGOTIATE_EXTENDED_SEC;
 
 	if (cflags & NTLMSSP_NEGOTIATE_KEY_XCH)
-- 
2.53.0



