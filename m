Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EB7779D2
	for <patches@lists.linux.dev>; Wed, 17 Jul 2024 18:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721239731; cv=none; b=Oaqf8KUYazf4MaBXkF1hAgP0Pann1i7/X/Vf14vwK9nWnCWAtg29A4ODF0kXWMocY+DbndbYnpVII/u6WdQDEm56rQo2DDx5/ef5NChK+D9rhUBFoyCo6fpv/JoheJpL2TmUR+SLEfWxV1WFI8npSNdZKKjfNYraHMO5ysgjQGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721239731; c=relaxed/simple;
	bh=jfEbLwRzbR+AO47MR26vocJVJ/6XK/TedgE18kMAe38=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VeYmv5GeypaE+8QlZMNWws5hSzazMxy0DsUrVdR1+vawH1d8j1TmPnJShGjUqMkiGitdbAUWU5vMZNNFBZxZDFmby/uXWxrVbByZTrQLRSbaKof98DCeA7agkoYVSdi+74jvC/wA7C8iTmwa2E70Fqk4Tl1uL3X+2tfq1b3BC2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=eL7vubkz; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="eL7vubkz"
Received: by linux.microsoft.com (Postfix, from userid 1131)
	id E4EC920B7165; Wed, 17 Jul 2024 11:08:49 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com E4EC920B7165
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1721239729;
	bh=G0VEVN2SRHtPLntxZ9hRSv/0U/PE7pyDny9m53mBDnE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eL7vubkzF5jg+ol/xpqXaylGTv+pIjkZF70+AN5N8keBZ80b2Hj+fldlGta2ANpF7
	 5tYwGxRuNPyqpoMDjoUkzN3TgrO4buLdKnpAS0W8QTxyUeEXeWA87DcquWXr/xR7Wx
	 gZVeVWqUgfamvnU6KIn6iPB93kMHv+IcPpESeW+E=
Date: Wed, 17 Jul 2024 11:08:49 -0700
From: Kelsey Steele <kelseysteele@linux.microsoft.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 5.15 000/145] 5.15.163-rc2 review
Message-ID: <20240717180849.GD7194@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20240717063804.076815489@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240717063804.076815489@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Wed, Jul 17, 2024 at 08:39:16AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.163 release.
> There are 145 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 19 Jul 2024 06:37:32 +0000.
> Anything received after that time might be too late.
> 
No regressions found on WSL (x86 and arm64).

Built, booted, and reviewed dmesg.

Thank you. :)

Tested-by: Kelsey Steele <kelseysteele@linux.microsoft.com> 
