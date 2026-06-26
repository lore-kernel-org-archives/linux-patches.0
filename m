Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E9093DB327;
	Fri, 26 Jun 2026 10:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782471515; cv=none; b=ZyjLzwKXMvnqkV6gQF/gM6p0hpfEZgBbnlTgbp8FKAy3m2Le9p0c9H5WoyyyppxTIUXg9E1uL6D+FUhPbKVkT6PfC7wdXYZQpGHPMuBMpZC64TmNEUgOPBOPsWCiTwF7p813hQHrzdDKqTELZ4nI/cGyM8eWfElq9QjMOC4QAkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782471515; c=relaxed/simple;
	bh=/0l7Nt+4TNhl557yBceI8rREewPzRgRyOnCziU2GSUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LSbj3PlcZvLsnGrnVdcD+m+DagtpWs+iVPOeAAxyKH3Kkv0UHrtSrfrere3jh7V1CSYvg9v76jTbIzkdGYs3KOlJsAFRU6zgQipodloIxK0O7bkW2rEV45ojrobXniQkxzjZP9jnPwBX9mWhU/BfxTLRyxEN2yXdYBWeYfFfRYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ar+tRCm4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ar+tRCm4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63F2C1F000E9;
	Fri, 26 Jun 2026 10:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782471514;
	bh=t7jtMt3ITmleyTcDgm2saqowHBNoxzjC9xQxhQhDDt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ar+tRCm4TZA8XqJIZUE1JozbwubSj0dsFPDOCgwwRktmCOcmkyM06uhU1LPlQxx+p
	 Cbb27IhUF2KSi5o+M6SgWJ5p87yt38dnqMYyLQdJeu3PyPbjsE8sXncaW8uONOvD/c
	 0yIwiwvuEgPWhTAZGlEcFPGurghxF0lriQH+B2TlqRgIgvYeQYeoSdvYM/OjegYNfn
	 agaB+N+WTGaT26KaShgn5tOFgSg4TAmYrEvCUiSTNm3JopOtNidv0kXsj0s+gXm2rO
	 pjXlwFoJH8sDSthTt67mfaN5D7lnR4y7ZTNhTUpLAcXOL7gTPhh1YP7AMj+O/awG9p
	 4Tkz7JZR0MEAw==
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
Subject: Re: [PATCH 6.18 00/60] 6.18.37-rc1 review
Date: Fri, 26 Jun 2026 12:58:24 +0200
Message-ID: <20260626105824.733843-1-ojeda@kernel.org>
In-Reply-To: <20260625125645.554579168@linuxfoundation.org>
References: <20260625125645.554579168@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 25 Jun 2026 14:02:45 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.37 release.
> There are 60 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 27 Jun 2026 12:54:50 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64 and arm32:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
