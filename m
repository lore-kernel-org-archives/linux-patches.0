Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B37F53016F2;
	Tue,  5 May 2026 09:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777973532; cv=none; b=BDvYsbrcY3wKSI/3GMdIr7ZQSh0qgQeinxuWKMhqk2eHwgZeCEiy1zeNyExS2NeYbfyUF09qwN1tEosH30sPCOqJydal8nQTHqBgTULvkgKSzrFcFLljnWGOWfMaqvJ+33X+d/6MLhSJaRzza9oj76rV+aEKNBr7ha3WxOUHlIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777973532; c=relaxed/simple;
	bh=C5mXDN8AYXkPUoovFe0V6BMOhcKGdgVIXmCE1Uob2g0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nbHAgvMLFnLK2tNbTJL2sJvIGtOg7b+UkBf5y31WejLzxWR1UxRKZ0etiZgt4CSH5mDZHvz36Q8dpE2PH1KCqRrX3m25X6lI2ylrCYEeMEMsih5k0b3ClPbYVyPIo1PN/cVjIqxjtRTavWRkhkkDUqKPpCiUdseGB716gVi556o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A/RefMnU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A/RefMnU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1EF6C2BCB4;
	Tue,  5 May 2026 09:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777973532;
	bh=C5mXDN8AYXkPUoovFe0V6BMOhcKGdgVIXmCE1Uob2g0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A/RefMnUnExWI5VODjh7yf6tZw0+GnNBTVzd4vOgSeFA7JU0AazL1iMwk8KWlGGtf
	 EDU0GKZgQ92xsEFPv8bS/pI0HowMxqvdbsHSNJLS5ZsZIBiTPZoP7YQg1GhJB31Ukj
	 1F9cJJOoXWnki3oOaUUv/iagDexSuEJna8dD1tVKTchTtEpXoNHWmPIMopYp39Xsqa
	 4obD40HCYkwOrFePGuJiBeMeusXo6E5olO5mM8EY93aLHqyMT4lU0OBPdCS3Sm9ZoQ
	 9Qr2S0nIRjCmc3up8yKi7P8EovrNgUxPqFWiXZwtgaaPEFp0yyuXm0ks5q+mNQeYdZ
	 GzZXDI2/CbSBQ==
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
Subject: Re: [PATCH 6.12 000/215] 6.12.86-rc1 review
Date: Tue,  5 May 2026 11:31:54 +0200
Message-ID: <20260505093154.244209-1-ojeda@kernel.org>
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 04 May 2026 15:50:19 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.86 release.
> There are 215 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 06 May 2026 13:50:52 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

The Clippy pin-init-related warnings are gone, as expected.

Thanks!

Cheers,
Miguel
