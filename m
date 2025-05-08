Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C52417A2E2;
	Thu,  8 May 2025 17:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746723652; cv=none; b=Qd4ea+bI+cKSu0fCMl9nmb/FFRu9jIe5kULThcnl4IWxIDrXwgaE5DVb7M583x0/NTg/tuwQtbMflck9x8JEFODIsMsTdQQNOPHJBEZTmSb3uuocRZIRcrM+jCMp/6Kd/IrG6rdHG9GE0sD/wTCN2Hc93m2MM068BiyroFXlKrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746723652; c=relaxed/simple;
	bh=OvoXxUKaR+tHWgtJAp/P6Kona4W6UF4j1OIAaQA0Iqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RSQsLwTNmgYrKneXFt2aX7vu6Xfl/TdazI21avlRqt87kYPHEt4SAOJ7PQIcBugnqv5jqsgzNlC4zzSfJeBfpCqyagVYrGbBZdwgkXhR+2VP26QfkuVRY8fHsm4Vctz5dY8wCeBlZJYQXTqso0K4I2GJdue7IpewEJZxE0O4XYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bLbfYmJA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bLbfYmJA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D74DC4CEE7;
	Thu,  8 May 2025 17:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746723651;
	bh=OvoXxUKaR+tHWgtJAp/P6Kona4W6UF4j1OIAaQA0Iqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bLbfYmJA18I7zGSX5B7DDL9iOPFXv1rsf2zjVlaG9HRiIecWoXwpwcXyfaPmqlPNW
	 7QMQ0rLiP1+BI4tlzGmYktTmzodCDPPJF5Jj6KdowojcPxjUkmsEbTGbF/VSOMos9e
	 Kc+jHyZ+oFKPzeEntgh19uyyISkhedt0aS01AMRVvcF/3HZ7ZSZ0nMYZlFzgaKP8S2
	 XekVjPU8TcoVDomIsdYfPB7f9kUuozXY9P8XpxeYw0xJMm1rKoFCrCwZoOuALNYHsS
	 dlkQ+g689+5P3WiTY5ob/AIGWIImCs2ydAxWlO8GaxuDct8GNBd3e7Ntjx5EGVnvjV
	 gESDJrUggHTqg==
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
Subject: Re: [PATCH 6.6 000/129] 6.6.90-rc2 review
Date: Thu,  8 May 2025 19:00:32 +0200
Message-ID: <20250508170032.640283-1-ojeda@kernel.org>
In-Reply-To: <20250508112618.875786933@linuxfoundation.org>
References: <20250508112618.875786933@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 08 May 2025 13:30:36 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.90 release.
> There are 129 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 10 May 2025 11:25:47 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
