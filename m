Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA01B4B44B4;
	Thu,  1 Oct 2026 12:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790856114; cv=none; b=E+WMRSE5S7Yd9bZZ1VPnE9JT/TQw2S5gaJ7nW5x2dmx8P/WMzDfTeaV4aGWedqSrbMC2VtSaMRLL/yMn2lqkbCbC3Czq23cyYgevtIo2nj485YYfMhBi1biiQiqNeRzeyZYo091paouv7JM5Uj0OClNl5xXbhWZ65wZS0dfZQck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790856114; c=relaxed/simple;
	bh=skhDHr9Zm4+/kFbr496GsWiVlrMnhCMRXawPPy0nKFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p69oJoZy6MGLVgmgDmBULnPgFdicr39fPC5Uv0q42bEW1b9ED6LETF5uCp7eRe2Q39pDmmhZ/aqXf9pkUmaVvRZJCdOJQIHd+N0ABKVzxWidv5Gm1mw+IdxUjnf3Dgq5pHMAyZlidscqALCQPKUNhA/NdOGdocm3bePzndyVkfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SG1amGNG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SG1amGNG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EBA91F000FF;
	Thu,  1 Oct 2026 12:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790856112;
	bh=wsFmbniaNy0mXkbJWAgInsMwcnNCOBQartd2CZAlhG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SG1amGNGdb+qOD7RAGCMOcn3BBc89aI69IVH8wDMnzKX84oVX1NpM/95bMtYQDXtK
	 D7HVfIAvL4Qa/nkYl/G9l1BcZndQW58DNhbuSNjY7F2T3JwXFxOSvu6BbM7mIp4SV7
	 5MIvR0P8aQ0qSJ5ERBCjzdYcdmq0LKOZA8VsODNmgvxWj+7oU3RmEBTrXPyE3/Z3Sq
	 7kPxuATp4bklLBuENp6ANfvTQlX2UHA6cZMDlXdJ9c1qPpNn9781B+6Kq8fPo+EEde
	 dGzu08CkSsugrK/M1ozm+B/t4021tfR/5qON4WFF0NSZe4DamdYEcPQeL08iUI/Lkp
	 UOC5SFqMVjoIw==
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
Subject: Re: [PATCH 6.12 000/877] 6.12.112-rc1 review
Date: Thu,  1 Oct 2026 14:01:38 +0200
Message-ID: <20261001120138.67491-1-ojeda@kernel.org>
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 30 Sep 2026 17:15:11 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.112 release.
> There are 877 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 02 Oct 2026 15:23:04 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
