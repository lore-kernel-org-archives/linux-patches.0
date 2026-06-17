Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A9893DE45A;
	Wed, 17 Jun 2026 10:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781692841; cv=none; b=AMV+mbyM7cBlhwaT7XwiQh0FKG71c3p3ZlAXrkmEBIKAG3M1JNqDCkDzetXKxXOQZ6Da30ZQLvjSKEuDPFMQSh6wqz03W3x+Xc7jVyURjXzluUbXhT55qxbU1FxzpC7b1uv+absdVLomH7W2q1i8Tr1dmETCO8acetpaNTPv4C0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781692841; c=relaxed/simple;
	bh=7TC80CrGI3Qo9kNoGlXH9GTMtIlvvx9wHSiNMo6w2tE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PoPktZhUoQ1nRzaQKFllTI0Cozm5RdWnzDBvk4qOavvuMyJDHJE5LOfSTrvpmyJAte/HnyuazEg3d1oJNNGH8BIF8zqDQ8A1vplSNXXaf4CDzcRhMA5S14XvU4Du2jEveReQW3DqNWaKtWiXiK4c0g81MYXxZZ41DLkmhzRRQV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BPwiYOp0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BPwiYOp0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 844141F000E9;
	Wed, 17 Jun 2026 10:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781692840;
	bh=zERjKaHDd50jUvAGu2yUgVNjX/cBuP3IXKh9BbT2vVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BPwiYOp0+g1yIfQZ6OoaIlz2KV2UVUXY5WsdxfqesO6FS6ywGu/D6HU6mINJBqS5u
	 j612pSxvxlf2jD6sdCde+XDxpHNtFxfAGIDrC4QeeV3Uip8MgQHzxSPFm5pIppw9xd
	 XzGjv2/aCDXv8pJb72qgMPf7d9M+sE5cec35yOVtvTtmTota1bu7Rxu0RkoBGZCHSo
	 RZ1mVLbGc4c9RbI/NICyooP17O3dXkksj42RG4MDtYJZzDsuiShf7H6itNfMQSA330
	 q319KSOHCGEu3d47iSnD0na9zcS46bfzh+J6TEmCLXsRmR/GC32rP4nSaMkt85+k8G
	 IwFn0r06935rw==
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
Subject: Re: [PATCH 7.0 000/378] 7.0.13-rc1 review
Date: Wed, 17 Jun 2026 12:40:31 +0200
Message-ID: <20260617104031.63882-1-ojeda@kernel.org>
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 16 Jun 2026 20:23:51 +0530 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.0.13 release.
> There are 378 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 18 Jun 2026 14:49:57 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64 and arm32:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

UML x86_64 also looks fine (apart from its usual warnings) on a couple
builds.

Thanks!

Cheers,
Miguel
