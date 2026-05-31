Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F81028642B;
	Sun, 31 May 2026 06:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780209381; cv=none; b=r+ci/3Ef0FUMTIg94AkfL4wIKQgiSffBez+e7hIzLyjZLnROzW3mCgg1teRSPsRv37uDc78AGGdt7sC4nH1yQw7ePQuzBaJIdwlxNQ0TW6RLu8H6xUcatxqXrCaLFaFQkhSP6G13Tjn4WSoEGyxcRJzyb+TGEAw075nFXxlcJdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780209381; c=relaxed/simple;
	bh=a6U6dm2sWUcL/dZbSpHQB73RbHD/njBr4SGsbOH3FQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hDe/u1EUGZRJ9beZf/fr8q2Q9ugD1ziEjsxkkISt8Gkg3ErBx4v2uHhwJOHGcb8jrzpOwvo032LFP6PAhSSp+QsrgIebIKgX8DyONCA9Fuk7u89AJ8JkdEwFcXk8y1aCZ/LhXYsRRJAK38VNaaVmUhOIYHyugwpPK6t6utT0kBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xks0NjXP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xks0NjXP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A8931F00893;
	Sun, 31 May 2026 06:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780209380;
	bh=8TUaWuCYYi0D1NSnyA5RNcdI4LZcWAJJViAnBUVsYuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xks0NjXPo35WDVV1h6DN3HufngAn/cKvUJEWNZPTll77t/PLkzNKFLTQohMh+VyVD
	 3ho8skkCLM9/BXJGQq7Myr6V4nhAG+d3oKBw28fUiRDTUnYERjWuONZogrbab+7OLC
	 eOKduW9jBMK4ZffA3Awl6S3JdUlMfCw7ek2MS+htdnLF4kjjaVSjUTHzXAKab50B7r
	 CRQbHOUAl6iX4RWd4nAY6KyXitZpW/ldx03ywJtYaMrXbAYV7BSdxJiFYOkB8MNsyo
	 eyh72jsSH316VbUvugXZcqtVmvxcIRIee5s4ZbnoeFlvJ5wH5k2ChrwKYND7n9RLpz
	 0Snv4PWC9ucOA==
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
Subject: Re: [PATCH 6.1 000/969] 6.1.175-rc1 review
Date: Sun, 31 May 2026 08:36:07 +0200
Message-ID: <20260531063607.54909-1-ojeda@kernel.org>
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sat, 30 May 2026 17:52:04 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.175 release.
> There are 969 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 01 Jun 2026 16:01:39 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
