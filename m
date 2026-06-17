Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13B643F165C;
	Wed, 17 Jun 2026 10:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781691717; cv=none; b=fnTOtqTcKBOL+at6rpbQXzTBDpXaO8+lxMsUFFSs2Efx/KyCpJHonIWbC4Z0fqcUJOXa8u08/hInA3vyEVdquWC0uSDayvbB7st5d+AyCDHjBysSL8ul2Ca9RHGG4Kvbs01wQC1oUNSzn61hXf0Fl02iHyq5S32t6q8+fX+T08g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781691717; c=relaxed/simple;
	bh=AH1pDRYo7A3DSQqwwCQEJtGKFlyfOAdz7AwbrsMnyhU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FkrorCdTaMZvtvIiZaQQtQkYSONzgaa+VdRvLLRZsjxlxfP2Uj0erKygfWqp60f44RvlGlAbRmwysY/gEhwPDQ5+7At4iD8MO7OC8UhMKJKvB1tuReyjk7roNWoTYxRNCFHi0YV6TD58TdKvWviE+gVkU5a6AZhTe8MFW+RInwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B6NclmR0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B6NclmR0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D2761F000E9;
	Wed, 17 Jun 2026 10:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781691710;
	bh=o/DAq3MyaWupkG+CRy+4C+hylC6ZRqRy+r4sN8eZ71Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B6NclmR0rgQNxcNk1Z9IvCCs0Vx5WNNwRyuHtqNe/RznB6E5fHHBgy+4ENlAGrRVq
	 iiBwUqJsraQC3kMhlr/yDROhTE7VN4WudXVCkxQSIbFaeI7Q7D0cDtLkR/Wdq1JKdW
	 rfsn+NFnedaYvsH4b+J2u+xqT6AcqoHd62fpOJhGREOBqPRKWWKhW75alw8gcxwGje
	 vbFs6eGqxaW4tQJI/thZ02ZA9TGYvgFq56r4Qryj4abf3v7iqprzzijPuclT+CWsjw
	 sTepO1gDbqI9wRAXgUpeLoa2voWksQ8yhACo2Gf2IdXr0OFFs69LVw5I5AMadvb1W+
	 MoyyZbPpGc6JA==
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
Subject: Re: [PATCH 6.18 000/325] 6.18.36-rc1 review
Date: Wed, 17 Jun 2026 12:21:29 +0200
Message-ID: <20260617102129.61293-1-ojeda@kernel.org>
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 16 Jun 2026 20:26:36 +0530 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.36 release.
> There are 325 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Jun 2026 14:49:57 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64 and arm32:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
