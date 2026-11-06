Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793982971;
	b=xF4RQDAKvqAGLHz5N+eQjoDffBwKDBcTraLqw1rqKwvt7aQ/cM0uDuchplbhZnMfYgRh
	 3JIbD/cTXPNaGMj2okoJ3jrLm+A2FWyciqKZUjWTrx7cjGsod5AEg370fqJ28sMUHAo1Y
	 dW1Do0yInIXWDgpyvfVf/G4T4mmf7H6pv4aDKhvth42HOFN+nMOTAheyMMepJ10BE8HyI
	 SYUu/wuae2WXAAJH65B72NWGZj3JVMzSqt5ggZEdgQsJj8GF4z6d58oS9wmR5pfwHWTxn
	 YsIw3+FUjNcPRh9vUHIvPkFLqCnJe/N8HqY1mv3xz7pnXI0TRV9GwBbB37nO3R1oCZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793982971;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=7o2tTUCKHyOfDrgMjYDFTqN7oDMZSwbcGWhBdhfpeRQ=;
	b=h36q6znLEFnYYrRcZ0UvWvWmDkgFyT8SQf2TL1Nf4kxqYQ6DgVkqjC2A5HbUlF2vPjK6
	 hJv19ZJGBwDNFBsIKNwu6cUjveWpoIG0lT0PzIik/CZ7U/9UCxpVk64r0hAYRGDI9ttvz
	 VBYC4+6UZggXWfzlBpxN0MNPmJ+D9c6+uiJMeAH7DfFIw+b4BQSIdhH+tC9q4nGGptWEz
	 SY0qmJAFVM3Q2cwlHcuJcFSoG4t4jlL4GfCzr0eRQ8cariV9d01x0pyPrFL22aKYiAxNQ
	 SSpqvRl2SL3vLth2c4Y2f6SrroBm5uO4k9mHNVEBR+LkdZdpAXQiFiZc5WEEd9qJoIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="A/pqPcJy";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2B17606A337;
	Fri,  6 Nov 2026 16:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=A/pqPcJy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A69F01F008A2;
	Fri,  6 Nov 2026 16:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793982970;
	bh=7o2tTUCKHyOfDrgMjYDFTqN7oDMZSwbcGWhBdhfpeRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A/pqPcJyWMWTM+lzVj4f29uyWASY4Wq6BUxM1xO9zW7rBVNbQAhEroX8xpXUlgv81
	 bM6vffoHJQTi6itBP3qvdI7Kx9jTRBaHD2KqQEfoUlVmIJKf7Qi9kfkzx/4Gu9ggU+
	 mLwP0NGdFkK25OJnq2N+JfGuMQNIxvw50gdeE6pIrtjmUKa2K8HmrxydmzZFmXTj6N
	 OUEMtzOlJyokIR38/xOy3SVqyMPsX03qIkhIFmRrauh6ZJ8THbTqST72REuLBgcIfJ
	 tJmIi7ToXdEnC8LJAS8u8dG6F94w2bizOMnI0fm3JHCXJrHgQvsRxPtlVrjnI6gpFI
	 kKFDzdseh5nQQ==
From: Sasha Levin <sashal@kernel.org>
To: gregkh@linuxfoundation.org
Cc: Sasha Levin <sashal@kernel.org>,
	burak.emir@gmail.com,
	ecourtney@nvidia.com,
	ojeda@kernel.org,
	patches@lists.linux.dev,
	stable@vger.kernel.org,
	ynorov@nvidia.com,
	Alice Ryhl <aliceryhl@google.com>,
	Yury Norov <yury.norov@gmail.com>
Subject: Re: [PATCH 6.18 0699/1005] rust: bitmap: restrict bitmap length to at most i32::MAX
Date: Fri,  6 Nov 2026 11:35:48 -0500
Message-ID: <2026-11-06-1-daily-reply-0013-rust-bitmap-doc@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261106070701.89282-1-ojeda@kernel.org>
References: <20261106070701.89282-1-ojeda@kernel.org>
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

> But another option (cleaner but a bigger change) is to cherry-pick:
>
>   f5535d78e126 ("rust: bitmap: add MAX_LEN and MAX_INLINE_LEN constants")

I took your one-liner for 6.18, since f5535d78e126 ("rust: bitmap: add MAX_LEN
and MAX_INLINE_LEN constants") adds new API and is not a fix.

-- 
Thanks,
Sasha
