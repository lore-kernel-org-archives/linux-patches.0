Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FD4121638D;
	Sat,  4 Jul 2026 02:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783130901; cv=none; b=iT54T2c2253MSjokOufawgWh6fqKC3kxYfKf1wxu3gjwiptyCEGyJWUqD5wOPK7Std0kBf7RsD8ia9CbqcVwgm9WWuzD/45vdQC+Ob1fIO/gGitZUWc0YzrL3L0Q+5g0yB1jNKUQaLPAPKCZnceZtbWxmHDBv7SYEPBYtxJdlYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783130901; c=relaxed/simple;
	bh=J7kQv2XKt3m7Tc7qN3WrlHks4sp8ylo8/RXgXzsuWPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dDCy0sUJdUH9iDbU+CHQNV0v5Y3aCg5rG9cPVfnz3UaOzBekQ1uRDbaCJUXJdrGgFXvtWkOPKReoHf4EjtEujJgSEC+wK4hc+DsSsGDi8bCWsEtf2XEx1+dKmE26dJf3lm/udn1x3a0//yn7txAKM4QnLmKF7xjyhPPjtl1LFa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CBGaJSwp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CBGaJSwp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 892D61F000E9;
	Sat,  4 Jul 2026 02:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783130900;
	bh=Ooz6dUYEZMP0ls+nKrzttFMXPiKVG7Z90npuvlnccPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CBGaJSwprpsJgWamn9gRuAV8jDqTt1HIoS6zDRjZqUQwJV7n4mnCITYDzR6Omgg5p
	 5mhd2tl8JC86WE9Kf1Q/Cq7WgWFSYJdK4Ir2xWrEqwV9L//LMz4iGMkR+jWpBCZVti
	 oCsMTTvlsfaZixRzbN99VWHmfDahnMbyyM4+7zN0k2Klwu787qwjB4NwARWOCQ0j5c
	 euabw3Zt/uxau9tne1DjraXLDF/NCkvsT0AE91BL0EY25m1Qmy2kuvKjRN8Qg9/qhk
	 9W/LnpNxdZTpn0YvnryLZ3gNLRzDc/WZhjmlczpUi5Gv38SlmWIP2OCv/x2LhUDpvf
	 rWfprLRWLE9sA==
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
Subject: Re: [PATCH 6.12 000/204] 6.12.95-rc2 review
Date: Sat,  4 Jul 2026 04:08:08 +0200
Message-ID: <20260704020808.55860-1-ojeda@kernel.org>
In-Reply-To: <20260703072825.068705122@linuxfoundation.org>
References: <20260703072825.068705122@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 03 Jul 2026 09:35:48 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.95 release.
> There are 204 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 05 Jul 2026 07:28:05 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
