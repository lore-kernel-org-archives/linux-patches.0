Received: from mail.antaris-organics.com (mail.antaris-organics.com [91.227.220.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BDB0427F94
	for <patches@lists.linux.dev>; Fri, 31 Jul 2026 14:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.227.220.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785508614; cv=none; b=ciq1XVW4bWiziWyFiNbVmemq+riGpHDwGVgEeDHk7k7F4mKoU+5e5eERKKnIkFpiRopbnE7+Xldbz8ECimVQm0ZQH+YN2pI+8ESYc9E5xARr8+TVmc8hy9j33thx+d8IYwfqIRhDip0XcQFZrcazR0v48ERq1kbhcxADasN+jJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785508614; c=relaxed/simple;
	bh=F4LgoteC2e6o2WW/OhfAfb8TIfN8WskWJ+AXaNOp5a8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=tRXqZlGI5rvwBLm85NoLEQH/vlcov5wGo7bZUPaH5CBng3yr7J768d8AK8ir4pvnYxu15EroG1QLeOe7fHCZsBf0lLN8VzEXgyG6HHbKCElj8kr6WBIqNadcQluqxMnEql3BNEh2eH+mYjfWmgcG/Sx8lU3iAhcTQ8C3kr+Tm/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mareichelt.com; spf=pass smtp.mailfrom=mareichelt.com; dkim=pass (2048-bit key) header.d=mareichelt.com header.i=@mareichelt.com header.b=vXuLHEji; arc=none smtp.client-ip=91.227.220.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mareichelt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mareichelt.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mareichelt.com header.i=@mareichelt.com header.b="vXuLHEji"
Date: Fri, 31 Jul 2026 16:31:20 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mareichelt.com;
	s=202107; t=1785508281;
	bh=SbtiAmo847PQkBzYOsU8T5bEGz2t5hGIdIWPj+7FojU=;
	h=Date:From:To:Cc:Subject:Message-ID:Mail-Followup-To:MIME-Version:
	 Content-Type:Content-Disposition:date:author:from:to:subject:
	 message-id:in-reply-to:references:mail-followup-to:openpgp:
	 mime-version:content-type:content-transfer-encoding:author:from:
	 subject:date:to:cc:resent-author:resent-date:resent-from:
	 resent-sender:resent-to:resent-cc:resent-reply-to:
	 resent-message-id:in-reply-to:references:mime-version:content-type:
	 content-transfer-encoding:content-disposition:content-id:
	 content-description:message-id:mail-followup-to:openpgp;
	b=vXuLHEjiTdZh8g5u9uol5WR2LCRrBB1pXWj+PvNkizOYuMKCCE1iuy1RhQVABrNWM
	 uGgnE4DJ4/wpdMGhU/HTEeeyGc+SKB2HqTjUpNdJeer2MsoQGAaqObx6H9pv1JG3gi
	 4Y2w3Rf7+eXcCbJ2e1N6+y7f1zZ+S7i1zgM9IcSi8ny7cH8xcl1ae4/irJjrnmg7um
	 LK4xR0fULiWzIilGJo7+xdC3fT0X/crqU2n1VLxa/9J71uGyhDSPXXLBF5gEoeFpDP
	 FX0NXgp6uBP/ZT46297TtCD9ZU5a5BAMIQfzU24PjyjYqW2ubxPSPqCvArh0P1QqoU
	 eh74/f3BGdPWg==
From: Markus Reichelt <lkt+2023@mareichelt.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 7.1 000/744] 7.1.6-rc1 review
Message-ID: <20260731143120.GB21778@pc21.mareichelt.com>
Mail-Followup-To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

* Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 7.1.6 release.
> There are 744 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 01 Aug 2026 14:13:38 +0000.
> Anything received after that time might be too late.

Hi Greg

7.1.6-rc1 compiles on x86_64 (Xeon E5-1620 v2, Slackware64-15.0),
and boots & runs on x86_64 (AMD Ryzen 5 7520U, Slackware64-current).
No regressions observed during boot & my custom tests.

Tested-by: Markus Reichelt <lkt+2023@mareichelt.com>
