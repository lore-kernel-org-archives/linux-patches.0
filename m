Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 652823659FD;
	Mon, 14 Sep 2026 09:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789379253; cv=none; b=ROzeaEosrm8pWStgFQkS/6ZdnMDjP9wTDi3dBD41E8pOafCI4ZJ4+Q1ujYLccr6Oi675t/oHsRQE7NZzqnszEk1+ezdiX2YiDHnYmSl9qfabdEcTqTVhU4MNXiw5D8ZLOuldDp3YQavkoiwdu/3yLpx0r45plaxLdm/cnjIlMII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789379253; c=relaxed/simple;
	bh=irNNsT8iKCdzudLKleyMornqIv1Z90Ab8V9lrVpvlP8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZLU3mG6G8XL2w6ypl2m3xdMHQrMXIJtdQwrbkOG93i5U1vVW7/NyVRXyVN6XE7847U6jcMHRoqoIw5qNH/3o5aYS+hmLJMr10EEB5Coe6aGBwVaYHJCBbG1tZrtug2cyn77a6v6ISVIuItwnV/cC3ZlfWzMHb4EVx29eSHCd2/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1lfV1fiT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1lfV1fiT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73B8D1F00893;
	Mon, 14 Sep 2026 09:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789379252;
	bh=7dtvjOSlcTcT7bJyUrCOWXgHk0cz7zz4GmfHdeVHrGE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=1lfV1fiTowEAx28pjC0cUZdFBI77m5iTURGxOPRAZ5ujGu0xQH4+IcuEaRRR4aoAb
	 5Y8hN6B/BycYyKvwA2hgJ2zEOOMTJ2u2pzW9gV+IUREG3ByKOGdgRLlbKe39uvUIMe
	 vOoPy2QEgsBBdKjXLyou0T8L48RM4gMr4H63bDVI=
Date: Mon, 14 Sep 2026 11:47:22 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jon Hunter <jonathanh@nvidia.com>
Cc: Pavel Machek <pavel@nabladev.com>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.12 0000/1376] 6.12.110-rc1 review
Message-ID: <2026091413-drizzly-guy-9d8e@gregkh>
References: <20260912065607.535295758@linuxfoundation.org>
 <aqWnzsSIMkyM46NV@duo.ucw.cz>
 <f8e1fe51-03f1-4158-80cd-2b462624da3a@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f8e1fe51-03f1-4158-80cd-2b462624da3a@nvidia.com>

On Sun, Sep 13, 2026 at 12:59:10PM +0100, Jon Hunter wrote:
> 
> On 12/09/2026 20:28, Pavel Machek wrote:
> > Hi!
> > 
> > > This is the start of the stable review cycle for the 6.12.110 release.
> > > There are 1376 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > 
> > We get build errors in -cip testing:
> > 
> > https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/2842911949
> > https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/16461797877
> > 
> > drivers/soc/ti/knav_qmss_queue.c: In function 'knav_queue_probe':
> > drivers/soc/ti/knav_qmss_queue.c:1874:9: error: 'knav_qdev' undeclared (first use in this function); did you mean 'knav_queue'?
> I am seeing the same for 6.12 and 6.18. Appears to be this commit ...
> 
> # first bad commit: [4e91398b6ae1dde1824bcf3d19b4237773f31e68] soc: ti: knav_qmss: Remove debugfs file on teardown

Sasha fixed this up, thanks.

greg k-h
