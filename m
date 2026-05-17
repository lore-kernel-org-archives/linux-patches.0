Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1CDE2DEA93;
	Sun, 17 May 2026 05:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778995812; cv=none; b=fih5HpBQYnmRasnNsleewMLOBKWIVpToho8+Vea4t2QEJCKWgIEDcxZD/ovkayQJXf+3yETSQQoREWgcHiq9E6pIh7sMDmjIu/+MDISq0FHxHzcu2VmQp+mYdqoJet9cpjhXOAYtcfZTBxT4x44/hj2jmPTu7Ud+EIvMXCwa30I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778995812; c=relaxed/simple;
	bh=OfASAJ6gi0O1I4DMqWFVWWRyAZkurrtS7BqhySad1EU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iZNmBGRxgDSA0ia0bZmI9vFiuasOYyhv+ZDJ/R2SeXSlftqVNfHRuBINtkIvKlAHAu20zpQffrThsdo1nHrBsgmkVcMiIwNmQQWjZSOU1yAgnwuSFvLWRtgqz1sdaD9FBIlzRdtBOf/COlplUfjB3xiLMWb9YUaCQU9oumi0n0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gdhda21G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gdhda21G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C299C2BCB0;
	Sun, 17 May 2026 05:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778995812;
	bh=OfASAJ6gi0O1I4DMqWFVWWRyAZkurrtS7BqhySad1EU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gdhda21GNWYlqMmllSw47LZC7VU0s4ML3Pan51zbNOg6xrBSBS7CAFwQBuqMsEy6C
	 gQ3VAN6eerbF38j9BU7gk0zW7kLaHd1ScISfcss0LBE0RGHrT1VE8BXMIevmgfe1y/
	 hnKzZ2yWiqCsQ556BCGZOJOGCS6MsAD5MXVfxSdxkGrjPuG0u73YpJj7fD9IMrbZjX
	 DZtq17OH3OkBlEjR3oNED92pPFvXS9aG+YMHxkSPFaF0pM7fuw1xWeZVscc2KBwf7I
	 6VcAmcxypz4qJIMNaXD/fSUQ9zj8nZjrq73wHy2R+J5U2L2RINQTeYNa1aj0AKwaaO
	 98xKV/8CetNYw==
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
Subject: Re: [PATCH 6.12 000/143] 6.12.90-rc2 review
Date: Sun, 17 May 2026 07:29:57 +0200
Message-ID: <20260517052957.190329-1-ojeda@kernel.org>
In-Reply-To: <20260516102210.570453769@linuxfoundation.org>
References: <20260516102210.570453769@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sat, 16 May 2026 12:30:39 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.90 release.
> There are 143 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 18 May 2026 10:21:56 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
