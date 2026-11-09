Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794228262;
	b=WWJnQfxV9uFlrZHOUMfGYXVreUWkt/nyz2oV0GlKEMqxFTcwfHv8RetY9G4kW4tWKxKv
	 0XSjYnH2w1MJx3tKuf/2Jn36qkWCnE4JKUZ7kw2Xf6gZdqlPCFjS8aqr6RbmSY7DcBKvc
	 2eYjSg/Dgmv+YTDIiWMhtw9hsaVIlDbdcYS4j8PAPNoEtU8i2FUV921PFV015C9GEn21G
	 oYxJKpqXR0ORCyL5uE/2AdTU/O9S4t0GNKAXexkC3KDXAxCQ0BI6Ch60iSPIKMT7ds4jm
	 G+6ux7DOYjCQzU476FmibV2Wp5rJr4quTnP1puPf+O+9fBM4EzsBe8jDrFeMq1t9NHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794228262;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=wCwX+KhVRI6NnD4xYy03md5dg+U159xRfAejqBI6STk=;
	b=xqOhA1rL1QnCVFCUAxTF0taNzRtVvM+iulxdNuNitWWVu7DY45mwfTo08iPdVSwH12Xf
	 cRx8qIV+tqXAhSmEpyeRAqpgmqhQ7+1aJd0t7iQHjJtfZXXkIPgV2cEyl3kqej1+fLOzq
	 BGkd6Z4wBo48WTQBYkDrRePDr2fWAEKNOYvgrBjFmNZ20h7fiS4V+WU2aBXfvb/STch1+
	 LPqffhQUo3QRrLUD8bW/1YAD+BM2wA0t1a5YViMsbHYPE+gql8o4jU01ddj043D2kZiK8
	 dBXA58FTYWmH+kGwBWC70lu2XsbFF2j7pXon8ylGZTUmkOsJ4I8WMdhpMuLim6GcTYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DMYRPH2n;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82AC2606A330;
	Mon,  9 Nov 2026 12:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DMYRPH2n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BE3D1F008A3;
	Mon,  9 Nov 2026 12:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794228262;
	bh=wCwX+KhVRI6NnD4xYy03md5dg+U159xRfAejqBI6STk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DMYRPH2nOnyhO126h3rnBoMgFE9SIn6NtdkYLP/jQoYQAC+CPkhoPgYSNASMBCrBS
	 GL3Jm/5m9IPuggNS+rS1XbCwgaBEBF1Hr0GwdcGkQT08dsz/s0QOHb8+rXXejo8lK1
	 4Q9OS6MdWFeYU5uvw5Z3ktDNtKg8p4tK46y378n/zoL0ybszWeuEmjeXL2pWAHxXCT
	 1l5hqBUFc8hLywPrQvxAbtfTaVjZItMdhXVFhLGLraL+HD59t6oz5R6s5kaXCTWLWN
	 A197unf8VTm5h517oeBMmkxhNl3X7oglc2pYfEcdipAa/m86U+/i1LmuJDVGY+Ph2k
	 3DtKlqib2sxbw==
From: Sasha Levin <sashal@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Sasha Levin <sashal@kernel.org>,
	gregkh@linuxfoundation.org,
	a.hindborg@kernel.org,
	axboe@kernel.dk,
	patches@lists.linux.dev,
	pgovind2@uci.edu,
	stable@vger.kernel.org,
	ytan089@ucr.edu,
	Boqun Feng <boqun@kernel.org>,
	linux-block@vger.kernel.org,
	rust-for-linux@vger.kernel.org
Subject: Re: [PATCH 6.12 0630/1536] rust: block: fix `Send` bound for `GenDisk`
Date: Mon,  9 Nov 2026 07:44:16 -0500
Message-ID: <20261109120000.sasha-rc-reply-001@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261108163608.122524-1-ojeda@kernel.org>
References: <20261107135015.226523646@linuxfoundation.org> <20261108163608.122524-1-ojeda@kernel.org>
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

On Sun, Nov 08, 2026 at 04:36:08PM +0000, Miguel Ojeda wrote:
> This one breaks most Rust builds:
>
>     error[E0220]: associated type `QueueData` not found for `T`
>        --> rust/kernel/block/mq/gen_disk.rs:198:8
>         |
>     198 |     T::QueueData: Send,
>         |        ^^^^^^^^^ associated type `QueueData` not found
>
> because there is no `QueueData` in 6.12.y. We would also need commit
> 06dad60393f2 ("rust: block: implement `Send` and `Sync` for `TagSet`")
> for the other bound anyway.
>
> I would suggest dropping the patch for the moment.

Dropped from the 6.12 queue, thanks for the report.

-- 
Thanks,
Sasha
