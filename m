Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793281431;
	b=bs1B/rfE25IXPYP7s4QzzVcllIfuuFwarwih98XVJyWAhzST89Z84ZcpeSd/z7u/iMHr
	 RIrmo2pkOyGOc6So7r5Z0fbbI0D0U6UryaFZxWfu61Ke8nZnEjA2nAk7Sfj3xMFplWpJZ
	 qIUp1prf5omxr/CMFfLiWZlQWfguUBRu5whW5TccGbD1srSfdTZzrgur3K3hBiwSVNHJT
	 xtUOKm0/k5J0DsCfeHKkvo9jcWZBPGHaYW69fEI2IptaoMI84vMYWhJvmU0sb7k2qZQuf
	 Igp3st6FsWco9PZx+HrFXTuqm9r+CPggUwom8MUfwoAXEbgSaAcpMhzQfitEbJfdJtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793281431;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=AeOMU0UVhm1pYfZM16LNB5VdSJefDDC2GiVbKn1hRJM=;
	b=tADbkJih9up4+X99D28S+eHUJUGy5qqZkXvkBid55vEFfpCxo9uakZ3OHsokmsCB96Qb
	 VtQPGij+xHeMZ130B+kNJo5wsbj+2uC9UROWkRKnqQyCAYP8wWyjvBme9+HslBqqB/Dv+
	 //AbMB6/tSjLORU1RdSsf5CSq4FCED4dPZJwAOKtOD02xRVaYdQAE7t9hUaqL7FX8D64u
	 +TtA9y7PwBefCxfWMW338C279WaS5McfprCUPyZc8NCx7EJoxnkPYhvqacaePs/SCbKEe
	 aCmADDNJr4taohssrLHZ3kkaN5aVnudDXi2cmwohsKFS/ncuH7v+8g88A1WlCMzu9kA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j0b1pCsm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 825DC606A31A;
	Thu, 29 Oct 2026 13:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j0b1pCsm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99C511F01825;
	Thu, 29 Oct 2026 13:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793281431;
	bh=AeOMU0UVhm1pYfZM16LNB5VdSJefDDC2GiVbKn1hRJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j0b1pCsmoW7HAbGu6HZinrrCP5kH12dPc/1BpyW3BZ6gT3NYfzvNueZVvHlS0elWS
	 58m5WDiDenpCXmzbl2Yk8dk2k1cV5OAQtGCHKhJ1/+t3YxjcXQ/him2alvmtm2XLUY
	 e+g+WKyBOn84NkXeivCMxRuR+zZK4txcwzubqAcyehDzxUA/htVrQj3RvyOUrjDa5L
	 pvOoQQYNKihbfa8n05XNOMj/BbEs74RNndHyFJR+3IxvLzxjT33BYc/GBuIaib9ix0
	 kcisD0UgazehBkhvBEBsg+5o6JeSq6oBQ7cakdYhQEA6QsgtU/Ysw3TKjxcdGv49Ez
	 JZiprJMMSMuIw==
From: Miguel Ojeda <ojeda@kernel.org>
To: gregkh@linuxfoundation.org
Cc: achill@achill.org,
	akpm@linux-foundation.org,
	broonie@kernel.org,
	conor@kernel.org,
	f.fainelli@gmail.com,
	hargar@microsoft.com,
	jonathanh@nvidia.com,
	linux-kernel@vger.kernel.org,
	linux@roeck-us.net,
	lkft-triage@lists.linaro.org,
	patches@kernelci.org,
	patches@lists.linux.dev,
	pavel@nabladev.com,
	rwarsow@gmx.de,
	shuah@kernel.org,
	sr@sladewatkins.com,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Miguel Ojeda <ojeda@kernel.org>
Subject: Re: [PATCH 6.18 000/109] 6.18.60-rc1 review
Date: Thu, 29 Oct 2026 14:43:41 +0100
Message-ID: <20261029134341.26316-1-ojeda@kernel.org>
In-Reply-To: <20261028165942.357251485@linuxfoundation.org>
References: <20261028165942.357251485@linuxfoundation.org>
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

On Wed, 28 Oct 2026 17:59:44 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.60 release.
> There are 109 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 30 Oct 2026 16:59:22 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64 and arm32:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
