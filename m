Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 558422F1FD6;
	Thu, 26 Jun 2025 17:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750959591; cv=none; b=TOu+zdXweTcuUkemBMza0i7f5/wkBF/skCWg2g/dhYFarPaDXbO+haXrPjv1/gkPGU7z4uSjEtC+bonIAflo6NKkK+qbZFxYh7AInj7ncA37A/RiYLTIOhelx1ruEJH6N8fiuRtgDZk7IflEPPs6WmLoTiX2HsMrgscC5LN8nzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750959591; c=relaxed/simple;
	bh=64olsWKIVSHLEVT5PLX5598PsIQWsFK0bWU60pRo+AU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WHJAh+6fHFTixDDKRokcFux3Vwp4vpw2iEVLu2ufc1cpsfoYOlajMyk/OUsW4lwd9hGp0l8btz5JgqOgt3Cs0ZmZI57GR3rzm/is5HqXGx1GskkzVNci7kStstcn+WhbpVvXF7D7yjRPOdhGtuebydGZcVOcwwSFDx8UjDGzwpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EqfQazFt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EqfQazFt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60236C4CEEB;
	Thu, 26 Jun 2025 17:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750959590;
	bh=64olsWKIVSHLEVT5PLX5598PsIQWsFK0bWU60pRo+AU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EqfQazFtuPkQ+TaF7mVEHI3kPUhoPJKF2Utw8BOUJJ/T4QwVtqPO7/9SmGKHJeiNc
	 WRoNf4uT5Ih4xS6/dUrZkJghVGJfpxqzh+Oym0VYbQFUFO48/Hx+iMS40D79YurH3g
	 lPTGgrP/DmoDI6ipLaBgV2OXDbAbKLFBsg0HfGEPsFv6nQyiJkCJCYwf6WzyUdX/2A
	 pUcL7Bn7aVZLws4FAWOOjgIXGCqC6DuDN1RnAwbI1OBZOT1qFgrjAR6AUCR8hdlJ9s
	 yBDMg2mWUYVuJA/2ioZb6AW2yxgQpg5auRW4G/n9fRZ3yhSD1MTdoXWGbaOwYHTq0l
	 w6GRXzWO4uD3w==
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
Subject: Re: [PATCH 6.15 000/589] 6.15.4-rc3 review
Date: Thu, 26 Jun 2025 19:39:32 +0200
Message-ID: <20250626173932.1017297-1-ojeda@kernel.org>
In-Reply-To: <20250626105243.160967269@linuxfoundation.org>
References: <20250626105243.160967269@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 26 Jun 2025 11:55:53 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.15.4 release.
> There are 589 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 28 Jun 2025 10:51:38 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
