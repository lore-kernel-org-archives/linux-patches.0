Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF0943E49ED;
	Tue,  1 Sep 2026 22:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788302434; cv=none; b=F5CqoAMTG+5jZech6MS8uuzH9KKd9WILA31sYfmpOVY1r27tqITFJtm6Tvv84pfVbqzxP59D+ptEXpzzFnbYthkFMmoy3yDics0mWl98YpXNkIYIWFLoaTktwQz3i1lfQ2FVT24hhwGR/wKhpyd24g0iwWksoa4RfTX/BwZvbgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788302434; c=relaxed/simple;
	bh=zQEnQ4FvCI7YWZWwEVODWewygWzC5og3G7EERU4cwSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uP69ZnLhl6OI9PuyTF4eldcBqdH5seD/wuT7mnf/OIDNEe+nKh5e6pcHern+lDZhL3nHsqB7V1eJkEY57Tz7rcemvIcqkAOGbtgOEXTEn5K01H2GR8gdWHiFX+uxIuc3a8uZJY933TDbMoh4d0NxqBBmm3Z/LB5/X5UQPmHYKuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ae4cY4Wv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ae4cY4Wv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B266D1F000E9;
	Tue,  1 Sep 2026 22:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788302430;
	bh=OewlNzwYkgdBJT4O2aYtIk6wqymehWiILKVeDKGl7Vs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ae4cY4WvduXNbvo5huw0UCoYtY60BzjGjfueLOXejLieZztnqO3g1/mtF0WYewIX/
	 g2Zs4qve3hExNueJrgfOtEXxJebDMwxc6IXxV6yuHedt/vksKxS1ChFqKHKEEPMeHk
	 2z4tk/9hmPvcKuu2GJHhujmbMSq+Tz3z9rEqV2QotdXknaA08Z/MpPGuLcAdw585Cf
	 o3KU3voMc+2thbMWIEI0Al+4XXq42fYbjKDG8nSb2nGUVKZMm5VOInLG3l9YnZVxg+
	 YnjYeakE/oQRX8PmPeW0knLJCxP+uATYJpENqqM/pCvmSttgR1ExMC9PwhN+sj4t2o
	 nm97LT3bGm0Qw==
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
Subject: Re: [PATCH 7.1 00/76] 7.1.13-rc1 review
Date: Wed,  2 Sep 2026 00:35:47 +0200
Message-ID: <20260901223547.62187-1-ojeda@kernel.org>
In-Reply-To: <20260831133359.185608553@linuxfoundation.org>
References: <20260831133359.185608553@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 31 Aug 2026 15:33:32 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.1.13 release.
> There are 76 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Sep 2026 13:32:19 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64 and arm32:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
