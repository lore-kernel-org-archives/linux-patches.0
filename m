Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79C22430BBA;
	Sun,  1 Mar 2026 18:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772388567; cv=none; b=aXp6bkNns6ai4AxYtbZ8+5AtA6pXYjYichZ7wOS5xeD4wHfxUHRKUcpjvNZARCelP49eTQEWnZeF/FwsR9PkU9oAZerfUUdodWn3ehB9q7gmuxzFidDvcaYm/7AGRU0ELXeovLyHluxmU/+O32Rhti/QAobxfBvgBa8BwDoXpRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772388567; c=relaxed/simple;
	bh=6hgHVegu/OHt23ZOtKDbhEcFAA/UNu1ntA4auhtPzsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zzb4Fu0JV0FjlEIojNKiI7PQ2AbdAfpnvZGwdUSGqOlm01jco4TSScyZJ2v8CELA09vY+QgmZdw+R/g3VTQM2BxIcm/eTMCx9i572ntt6jFNl4M7M/6do+8LfOvar4RAbwMDHOrvCc2gQE5Fp8VlNaMSZpJ7i6zMwrxpnOqMkRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tMhlN1/V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tMhlN1/V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AB92C116C6;
	Sun,  1 Mar 2026 18:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772388567;
	bh=6hgHVegu/OHt23ZOtKDbhEcFAA/UNu1ntA4auhtPzsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tMhlN1/VcybdPmY8B18aPxUJaKjg524vyNdlYv2xZfmqWmgt7PmuIFIQ2YA/1vWtQ
	 yD2sx8rqGLUH3fBmg8cK/+5LCVBg6fsQYWa9xgBV9gNHUNjNQQkTTURqs8JDy3yVqA
	 NoxhB9VU6MJ1/ocvC6bqublC2p+aaKrNFdsInv0fNB+BG4hmlGqdmpdFSb/M8y/THF
	 luwEShe/UDbcJwKiQuXY9i+7HA0QAtNfXB0/NbbATE+q3xxrEq/yJ5pAaeREAUoM7Y
	 dQrn8eJaLkAv6s5+Mf472tnkXSDq8jBjvW9t/hImDNPbnxMiNCB2canl5UJ1Itiy2s
	 qS9ytNP8mMOjQ==
From: Miguel Ojeda <ojeda@kernel.org>
To: sashal@kernel.org
Cc: achill@achill.org,
	akpm@linux-foundation.org,
	broonie@kernel.org,
	conor@kernel.org,
	f.fainelli@gmail.com,
	gregkh@linuxfoundation.org,
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
Subject: Re: [PATCH 6.1 000/232] 6.1.165-rc1 review
Date: Sun,  1 Mar 2026 19:09:13 +0100
Message-ID: <20260301180913.176066-1-ojeda@kernel.org>
In-Reply-To: <20260228181119.1592516-1-sashal@kernel.org>
References: <20260228181119.1592516-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sat, 28 Feb 2026 13:11:19 -0500 Sasha Levin <sashal@kernel.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.165 release.
> There are 232 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon Mar  2 06:11:17 PM UTC 2026.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
