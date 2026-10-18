Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 600CA448D1D;
	Sun, 18 Oct 2026 09:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792317286; cv=none; b=p7O1UK4HUrC/Y04g/utHHF6rvCCe0AYc0ai1KB3dMnxHxeqdldMeE0zg6zKZyvVMRJFnGh8MI6Uro4RCqRfjJMJlNVI0LaoX8y+A+RBLPSrp0+1/E/uBqdZILv5DaRb2Z2vUWKw5RtdzqJw/8MFvp/ofMvSYZ+fgDdSLfe7/BsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792317286; c=relaxed/simple;
	bh=pxtdxh59zl7Q5hF+T2iXGsXVqDLvISixHD3rd9izVcE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=beHRrTR+S7V7AgthRyyHu5LlzvssRhaEBa1LpKhTPYTTLeRnZB0aKAz84Xf7qO9qip+h0EIN5N5qaWlHd617JG88i7eNZE8etWXPRJwVDvQ35QGlIxPHfmzlseDZ6w3E3StpvDV5ewt8WdWnvCK/SPuMwOr5AbkfOgUS/8xAxb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OhKdziJ2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OhKdziJ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A05E11F000C4;
	Sun, 18 Oct 2026 09:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792317285;
	bh=Bz4xvXF/HrxVoCJqAYOz7i0C+bacfw+OwxKQTSS6fkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OhKdziJ2/RfoEFqO+CXn8OQlWRo7UFhW0u6DASrjUwUCRPFYPYolm7ger6nLyNdiT
	 RDKDvth8OYMwzkRnPeMHswCjCuY458oRjZePGy6AwDNEfPcgawBlgMP55EgGDY+Zlq
	 2xnWJDjrOSGQm55VA65mberG2MACkQXyHETnjxkzw9HU4QcZZ80LpwAfUAwVazSHqK
	 9RlTrVHosAGNgq85i4rALnJ1AzGzDFdKoFBeoMIzKleEBOYRhYQPQCdfE+KUTLxP1X
	 Y484G+xKqiMxEXS0xlwoW6bOd1Pvle1uZqH6idKI4WfB0y2uioigqqMlxBjFm5zZ3s
	 mp7HKwKQdYpSA==
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
Subject: Re: [PATCH 6.18 00/52] 6.18.58-rc1 review
Date: Sun, 18 Oct 2026 11:54:35 +0200
Message-ID: <20261018095435.48888-1-ojeda@kernel.org>
In-Reply-To: <20261017155104.830766652@linuxfoundation.org>
References: <20261017155104.830766652@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sat, 17 Oct 2026 17:54:01 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.58 release.
> There are 52 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 19 Oct 2026 15:50:51 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64 and arm32:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
