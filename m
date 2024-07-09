Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99D8817B02B
	for <patches@lists.linux.dev>; Tue,  9 Jul 2024 20:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720555261; cv=none; b=oDp+7SYKaGA90SWvmJs4vB71HnDhwBVWFdDh+Rvhl/bVwQgGa/jaM5sTiYT1/B1F+rvHSyKSOTw1aoDvqELPJ1u0Ann7xjam5TKNBhCXGYRnz2BgGkP7+Tn3VjBxtnk/oJOjjPvU3mJkl+nXyoIC8Fyv45U6jnVei/EBEWgWo44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720555261; c=relaxed/simple;
	bh=LobDdWxshv37vTxwEBQhAQKllebZbsocJq3rs9CXzgI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iHQLQ1U8zQoKBeY6B5poeSW8Ez0wbbiNZLzkiqfI7F6LCMzZTVzHQpSz6Iq30BvcLLZ/ggWoA+s4zOIu4vgSj5EFVp3rU0kdixO3y47Yrug0LqlZXISXi8w3k90ddPz0QnAM4tlsrNFWCi1ySpuS5VKhSWUgk9nPJZ1LvaRxRw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=edFkEmAE; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="edFkEmAE"
Received: by linux.microsoft.com (Postfix, from userid 1131)
	id 33CF620B7165; Tue,  9 Jul 2024 13:01:00 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 33CF620B7165
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1720555260;
	bh=sdaJsz7B9EMQXguHZnzNSXO7wCkHbNCBIqyRwyEgZnc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=edFkEmAEF/h9mTngRoI/aXvmAu/w93H2guZHW+9zo7q+ABZiWVCHdXLxhfsR1WOrN
	 S1HFl6P52c7OnY/nyzUDEy84vAZL+UCV/D8TzymkfjQAEya3FXmxkMJUz88LXPN7wx
	 02+4FRNhwz0UvkhBNWBWUmrNGszW50/JJPGV/L9I=
Date: Tue, 9 Jul 2024 13:01:00 -0700
From: Kelsey Steele <kelseysteele@linux.microsoft.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.9 000/197] 6.9.9-rc1 review
Message-ID: <20240709200100.GC28302@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20240709110708.903245467@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Tue, Jul 09, 2024 at 01:07:34PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.9.9 release.
> There are 197 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 11 Jul 2024 11:06:25 +0000.
> Anything received after that time might be too late.
> 
No regressions found on WSL (x86 and arm64).

Built, booted, and reviewed dmesg.

Thank you. :)

Tested-by: Kelsey Steele <kelseysteele@linux.microsoft.com> 
