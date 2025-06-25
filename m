Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF5FE2FE337;
	Wed, 25 Jun 2025 23:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750893388; cv=none; b=TwLATK1dvL9GpMJoM19+OiAvKegcL4/QU8Fgax37WcjixXqsMv4EoSP7KImoF5n7AJ708nok465MIkaXpooiOxWflay5sCIWJ+ef3oJd14Dxne2WOt5oX9hmTiTny57X8iu2xdbtJTnBn3GPjUh+Ml/eEFwCmSnqpCRSsqGiCoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750893388; c=relaxed/simple;
	bh=dK+2/mGZs3BeJZdh1c11SgFNt34ye/oUR3HoFd4zv+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sVlfVCKGg3G4JbuFYdMVNEKnc2pRW9y4HaD9T+BsDuPpC/OXyHEMNPGnaH1TjmTZxvc96eMyxsDFv3gPOHOQl3jPlGs67SIq8/27zjDC0bC45Eh9NI094H2Oh4y4+TYTyHYifyC5nSo7rUGxx1YfO+bwvpP4ZUyrj7TmTf3Ag5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=onhSnqGs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="onhSnqGs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD4B9C4CEEA;
	Wed, 25 Jun 2025 23:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750893388;
	bh=dK+2/mGZs3BeJZdh1c11SgFNt34ye/oUR3HoFd4zv+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=onhSnqGsj0lnR2SC/tzrp9hE3Z+Eb3eWXxFQfHKZWPmfHPaJ80G8o3qz3GxkKme7J
	 ZCam9xkRKlRUT7CZJlX8xLSRsEPQVm0Er/T8HLBvBf48ftVzmI2aglDL65E4wfLvlP
	 oxvSCHGytc27qeKUa3ZgzEg6OUJmsJ8GL0K8lW+cUuYb3eIxeK5qjv2D+yVCYbdwYA
	 rjxfEx4DsUVmZ4YIrqf+iUmTDeS3UCQNrpGVBLJHhmA2K5l+tIM2zsio3L7Qw/ooNd
	 4/I1HrAbCjeCA2uhDv0aLUsSmMvruZquCDRtS2dwA67JiXPAMsuzsWvvpSSCOVlzLe
	 fynGEdZ1SvWDQ==
From: Miguel Ojeda <ojeda@kernel.org>
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org,
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
	pavel@denx.de,
	rwarsow@gmx.de,
	shuah@kernel.org,
	srw@sladewatkins.net,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Miguel Ojeda <ojeda@kernel.org>
Subject: Re: [PATCH 6.15 000/588] 6.15.4-rc2 review
Date: Thu, 26 Jun 2025 01:16:17 +0200
Message-ID: <20250625231617.952195-1-ojeda@kernel.org>
In-Reply-To: <20250624121449.136416081@linuxfoundation.org>
References: <20250624121449.136416081@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 24 Jun 2025 13:30:06 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.15.4 release.
> There are 588 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 26 Jun 2025 12:13:28 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

(-rc1 did fail to build for all those, as reported by others, but it is
fine now in -rc2)

Thanks!

Cheers,
Miguel
