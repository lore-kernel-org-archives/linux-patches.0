Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793282027;
	b=qG4EIr6Sw7AZXUm64TfIHxYOEQIw5Oogl+Ltl4Q4DhMJkyCpA9kNkr6wtpiH1fg+j6AH
	 23QbxbG1E0XVaqw/7l7sap+Mj8CJGKG7azA6+G4D5HHmIsAiHeBx7bU9Qm7rAPzwK8exd
	 XvUdhBdKM3O9ned1u6giOhVZKfLm0fXM/J5VusUT8plneP60C1iT6PUrRGnExS9N31sI0
	 pSrJHKSAeblzD0DR3pJnvJfsOhSYhsJXG0Jk9QZygyTdM84ppzu5qWMxhqG9ek/UrVlIv
	 MaI7F/ET/Peyc+anTbRelBEqqxTdSKl5Amd6acjShucRe+NCKw/j0sRYIB2YEvSiPtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793282027;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=A1JPThoaFRXYN+lhR6CpD36ITWtrzEepS8ewM6gTiKA=;
	b=VAUJllt+p7wDr19XeixvEPYE4gpK0kSGR1fpu0ZON0uD7fyghDyivcegvHG7dM2OLXPT
	 yS8t+zSa7Z14g1o39Jrq7lfnVgApErJfwrbDKKABykJwJxYzWnRlF5ut4DUgOQpdGSej3
	 W6NOkXx8OBRo8w16Tqzl/Yik9obE0JTWSTlk24oG5MYglP7bZV+750H9pMKugQcP4XdDj
	 4aN2tTNAMQlAcSkZmLe2Moa5bkXVuP265EThdirsQ4edeh2W4VCGL2kypcpbjhK/3rCdw
	 2Mb/0G7b8WlcKptxGe55XYCZaklDkPYQMWmVuYRh4YG272+iBVDaZXZiG46WXsZlFwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IGlEB+bI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13DF9606A833;
	Thu, 29 Oct 2026 13:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IGlEB+bI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2256E1F0128E;
	Thu, 29 Oct 2026 13:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793282026;
	bh=A1JPThoaFRXYN+lhR6CpD36ITWtrzEepS8ewM6gTiKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IGlEB+bInYDNUFZ5BPyYHJwBZk+JnTp3oFH64wis6M9/cAiIcKtXz+fjllv/kWxcj
	 jratDm0UVC60iNCRtwEeWF4FyR1zYyy/+ebgI3wIWDFzD+vU6TTVkrNveCx/cgBAlS
	 dGFzq/X66Ce1UVFyfipHy321LZdF6NzhJccCjaqE90CpY5oictsJtoVOqppMUER/bx
	 g9hDsRvudMFuC99SZZv4nG1bXunBktxy5k90fQb5mJwk7ksXxQlmMV0nsnwoGs6bHG
	 Uqdfs6Q5kFjSNfuMNJ/+SgJqe/TRXh+/iWio672HxtCs1ZdTc95FdQ00vQtvQwT/H2
	 cKP3uKf1zSzaQ==
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
Subject: Re: [PATCH 7.3 00/38] 7.3.1-rc1 review
Date: Thu, 29 Oct 2026 14:53:36 +0100
Message-ID: <20261029135336.27808-1-ojeda@kernel.org>
In-Reply-To: <20261028165940.394092994@linuxfoundation.org>
References: <20261028165940.394092994@linuxfoundation.org>
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

On Wed, 28 Oct 2026 17:59:47 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.3.1 release.
> There are 38 patches in this series, all will be posted as a response
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
