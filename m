Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D294536921E;
	Tue, 10 Mar 2026 09:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773136114; cv=none; b=umMUP2jZrWa04v24lx1uLFfwaJEg2kpW9pT3xY0F9mDdgV1euq5bfTrSd165GWIY8GsKe3cVRNCOxspCD/Tuyj9ZFxVm/LiEprqnBoTvZaaN6iFT3tpo0QG4T7kM0bGPU3VCjXQL3TzI6rxL6QUxvZIJDvDMD3oL4ufkefNpJ2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773136114; c=relaxed/simple;
	bh=L1yvzOSxU9NCf04mh5XL35W/zpGczWoYGgiPaoSk1Uc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g2i+sO4rMqZkCGdPdyY71vZ0b8TCfGsIUhRMMLGncN+P8fKP5UEyQ/z2aOP2x0VlshalJElffMrCMN9gHXZA7S9SepEa2XVeoVTD1S91tYKEDLbdXawMsLTeb/uFR8M4iTkoFsUoUdgstOR1ApJ5Y+MXIWsC/Co3CnKqaZ3QaOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q6jOYhkN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q6jOYhkN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58E06C19423;
	Tue, 10 Mar 2026 09:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773136114;
	bh=L1yvzOSxU9NCf04mh5XL35W/zpGczWoYGgiPaoSk1Uc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Q6jOYhkNNJZz9jOIJ30JvKt+vBnQZTS4tAr6Jl9xJ558Yr+lzj0i8+OXoNZl57bOv
	 KGgqi28y9yy/EyhH+AiIYnLfMk8qcnCW0184y6o4m66Hp6ygXbgj6E2P2QWAqrpjjv
	 cvkt9N1o3yRBTfrsGds2O4Zv9WiqB4cj08TQHTiCfjTVOUgucs+tb0NQDwPwO3eFls
	 BE9kex6k1+/yZDkiwYnTQC2GaRym+ZKE+dCWssCeOuePasA8GNDB/S3cmkRX4xFg2a
	 h+HAT0fBHEI2S24vCw4nOQtVl468+ZjP9FnMSGNKULDmgH8ByJecZJmzoqbVjZhRav
	 0n08xcC7M6b5Q==
Date: Tue, 10 Mar 2026 05:48:33 -0400
From: Sasha Levin <sashal@kernel.org>
To: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	gregkh@linuxfoundation.org, patches@lists.linux.dev,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@nabladev.com,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: Patches not posted as reply to stable-rc reviews (was "Re:
 [PATCH 6.18 000/757] 6.18.16-rc2 review")
Message-ID: <aa_o8WKGFjhRUPgx@laps>
References: <20260302160853.2519610-1-sashal@kernel.org>
 <iy7dogrbld3h5ygezzkhp3sebokfibu5suegpidlsrmp2ibfwd@fvstv7j7dcfm>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <iy7dogrbld3h5ygezzkhp3sebokfibu5suegpidlsrmp2ibfwd@fvstv7j7dcfm>

On Tue, Mar 10, 2026 at 11:16:37AM +0800, Shung-Hsi Yu wrote:
>Hi Sasha,
>
>On Mon, Mar 02, 2026 at 11:08:53AM -0500, Sasha Levin wrote:
>> This is the start of the stable review cycle for the 6.18.16 release.
>> There are 757 patches in this series, all will be posted as a response
>> to this one...
>
>It seems that patches were not posted as response. It was for 6.19, but
>not for the rest (6.18, 6.12, 6.6, 6.1, 5.15, and 5.10).

Yup, they ended up going only to patches@. I've fixed that.

-- 
Thanks,
Sasha
