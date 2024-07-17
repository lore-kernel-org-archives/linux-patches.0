Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEC2318A954
	for <patches@lists.linux.dev>; Wed, 17 Jul 2024 18:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721239703; cv=none; b=tGHQ5bWae2L2Jqwr5P0+qgf+cgXmnH2FCDoGIcoAP1hw1C28TbCDjwlMThq6d1CIkaVkS7j1mlLssFVceFX9EW1msbekxngGvEDOTL/JxJN3AUbsVawRyq1t1K6GhXJtrogiwtImF7gpIpPKEQEuoOeFj2PULAgz/HhRa9Ljpyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721239703; c=relaxed/simple;
	bh=9hxNeCBB8b5Vej3mf5NmU9RvWiDp8eSSnsAiXtQIXko=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SOMs5KEoag0ff6LIE09l+D3hDru7a5d5COuyTiEl6JPNxndFQq/U/O+JXsxjYKsxb4SSoqo8oHgjnM9FmFYoeazCZozVrGJw7Iwl6fdkz4A3wYuHT9i+T/wwqZNga7mNBgP6ZxNmCHVeNcokrydF6NSUu2rAjpVw7IZrC6lDans=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=bQcdB+OW; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="bQcdB+OW"
Received: by linux.microsoft.com (Postfix, from userid 1131)
	id 36C9B20B7165; Wed, 17 Jul 2024 11:08:22 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 36C9B20B7165
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1721239702;
	bh=H0dZi2HUxG9Kqf5PJWw1uBjQr+BrpxyIdPGsVJYkk0E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bQcdB+OWlkrw//dIOl2UeTwMbDLZvwwy0boDcuA9+VNDE8XG1ugev5Ry576RpnBRp
	 4EEPBYiYvl8jTILSdIT0anJl/kRmx5YmD/FajfqQXN07CRJlJCt8MqNCBsThvqQz6Y
	 pU7DahD2uJFda2au9EvHy1U7hjNe2X0pcZhAa8dk=
Date: Wed, 17 Jul 2024 11:08:22 -0700
From: Kelsey Steele <kelseysteele@linux.microsoft.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 00/95] 6.1.100-rc2 review
Message-ID: <20240717180822.GC7194@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20240717063758.086668888@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240717063758.086668888@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Wed, Jul 17, 2024 at 08:39:41AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.100 release.
> There are 95 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 19 Jul 2024 06:37:32 +0000.
> Anything received after that time might be too late.
> 
No regressions found on WSL (x86 and arm64).

Built, booted, and reviewed dmesg.

I had hit the previously reported build failure with -rc1 which is
now resolved with -rc2. Thank you for always getting quick fixes out! :)

Tested-by: Kelsey Steele <kelseysteele@linux.microsoft.com> 
