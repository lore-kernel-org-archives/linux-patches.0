Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBDBB18CBFB;
	Wed, 30 Apr 2025 15:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746028379; cv=none; b=gyd7M1D47lX1KV2maFgCK2aYk6po8rhDzJ2ws/JvXr1aFU0xkhqY7nDhfp0+lwxscQTuVKl/mXv8jR1SPQnazQ8pE4JWcOofAbyZXJ/CJqunLoED9KaMFxRy52PzmfMkPwDHH9+C1KJiCU6tyqP0O9tee/WaOB7a8o9EzO9ksjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746028379; c=relaxed/simple;
	bh=TwIJUl+tU3NChBQ2y7Q3MotupAQfjdh5KAn/tsFF3Iw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DnrI+4BhISOsYi/W7alPfsV2I5DD8/8xtr21MuCrTmQThAVBu/YI2REfFmGTTgan+S7homzkttaNgfeuSTNqBzzi/03vzIoSuX37Rd/UfSeO6Z0rpALlahAA+M3TwsqgmCHweYvItav9KUdh6KMagnRSh+woyong+H/K0xUe46Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nCChD59K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nCChD59K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 998D4C4CEE7;
	Wed, 30 Apr 2025 15:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746028379;
	bh=TwIJUl+tU3NChBQ2y7Q3MotupAQfjdh5KAn/tsFF3Iw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nCChD59KqvM4PV4K9OwbMt+JuRycpUPsC20t3Op3ss5e7G7nZ+cuOn4341qDKP3+G
	 C0Or48R8m4D0it1apbq9VOiU62r5QTHhTEj8He/O0iG1KsGk+IvJiryrnRZeofEzOz
	 Selc/g/MANI0ziOwMPe4og+kgTR8CqUG+ee8caX5pgsw/edXKt547ljTLUBUaBkBWd
	 l7VbPqnxeOJnCkj7U5EGIUnY6ILSKT5o+c4TnzfKGuFDeiNTLyE0mhHtnptSoL8+JK
	 F6prephFUc+UtCW7dY01pKqW5Tt8f5YUFIWyqR+raK/pSMRYKeeUKV3gXpPR7O2eHv
	 tew1oja3sv1JA==
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
Subject: Re: [PATCH 6.1 000/167] 6.1.136-rc1 review
Date: Wed, 30 Apr 2025 17:52:46 +0200
Message-ID: <20250430155246.796507-1-ojeda@kernel.org>
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 29 Apr 2025 18:41:48 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.136 release.
> There are 167 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 01 May 2025 16:10:15 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
