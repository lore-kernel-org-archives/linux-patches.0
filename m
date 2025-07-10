Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 652FF17993;
	Thu, 10 Jul 2025 13:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752153667; cv=none; b=KXtdJJwugfF9Sv6cVgyLw75MVdKu6FSwKmApazF1R+eOgi7m541PWZAClRQCZqpTCE5Hhyko42Sl/PJpE5bMXgSnDOX0HMfd8WRiIRPkaLaVxQNXWbcM+J6OV8SHDVZv/dXWtWW2HVu3umXUgfGzKU74P97fKyfTX5G1DGtGFtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752153667; c=relaxed/simple;
	bh=2tjF1/ercQz6JkWaRs6QZFJaed098Fwkj2MdCVrIS+Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r/NodPWI/plpH+Tq8B5btnG04stY8QlkHmm5i6XHr8fn7RDKf6rOV+yaVDE/k5Ts+TUoMyZt0cAO+dpofkHgdPfNE1Epp4XeW2LitV2furYTXWl9ZtQbkt8kfFISv+nrwFSEWqlod8yb8nfmQE2hfyHil2LIqEPVLtiWv3qKvso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QpCzoMS9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QpCzoMS9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EAD2C4CEE3;
	Thu, 10 Jul 2025 13:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752153666;
	bh=2tjF1/ercQz6JkWaRs6QZFJaed098Fwkj2MdCVrIS+Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QpCzoMS9hKONfy77yVwRXJCTVVo0dLkLPPu0QKRYermoja1JxndeL48vp13nqp6gZ
	 A37oaaqNRP8093kXOoP/hKKo/Wvin67XTlYVbfD4BWlUg/t8X4HU3vbXl/ti1efZL2
	 SJ9I8T+aq7Wne6CqTj8mkd8jilXg+BryltaFIY2Y=
Date: Thu, 10 Jul 2025 15:21:04 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Achill Gilgenast <fossdd@pwned.life>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.15 000/263] 6.15.5-rc1 review
Message-ID: <2025071003-hydroxide-cussed-5a4f@gregkh>
References: <20250703144004.276210867@linuxfoundation.org>
 <DB33ON4ANDZN.AX2EUQQAI3JX@pwned.life>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DB33ON4ANDZN.AX2EUQQAI3JX@pwned.life>

On Fri, Jul 04, 2025 at 09:42:47AM +0200, Achill Gilgenast wrote:
> On Thu Jul 3, 2025 at 4:38 PM CEST, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.15.5 release.
> > There are 263 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat, 05 Jul 2025 14:39:10 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.5-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.15.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Tested-By: Achill Gilgenast <fossdd@pwned.life>
> 
> Build-tested on all Alpine architectures and boot-tested on x86_64.
> Thanks!
> 

Thanks for testing and letting me know,

greg k-h
