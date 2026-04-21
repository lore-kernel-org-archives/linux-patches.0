Received: from vmicros1.altlinux.org (vmicros1.altlinux.org [194.107.17.57])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF44F388E6D
	for <patches@lists.linux.dev>; Tue, 21 Apr 2026 09:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.107.17.57
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776762345; cv=none; b=keyZ+zQQ0T6lHHV8MsaszvtFxhLhQ65QVhqZKj9LuDjjPFQR5QNYUkpEmmMXvedaHwxvXvLUg/GLU2cU5osaQY5b+6/MoiAIJuw55ygx4TLwVM/d3whwPA+rw1kxJe+IH41tk5Tr7OXYO02p5PZVO6q/m4itVCHPoQBpk0DOcjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776762345; c=relaxed/simple;
	bh=VYK6LrsVPkZeCNQwwlEjRppwTIVlN1MuS1VMclp8u+E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QEWt/1ORWpAJEXn2W+uLQFJzI24K0dxU4SJAt0dsNNIrp6vPXhnOWoSODq4cZ8ow0rAWhnk0T0RseCdtzfuQ9D5+e5jM1AGxk6lD5vwLXbr8jTeH2v7G0/50CkzVXhUvqnI7G5P2qQOIrrvUZ1aMmb0aZ51udqC6wxH/XRfygDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org; spf=pass smtp.mailfrom=altlinux.org; arc=none smtp.client-ip=194.107.17.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=altlinux.org
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
	by vmicros1.altlinux.org (Postfix) with ESMTP id CDC3972C8CC;
	Tue, 21 Apr 2026 12:05:35 +0300 (MSK)
Received: from pony.office.basealt.ru (unknown [193.43.10.9])
	by imap.altlinux.org (Postfix) with ESMTPSA id BF59436D01FD;
	Tue, 21 Apr 2026 12:05:35 +0300 (MSK)
Received: by pony.office.basealt.ru (Postfix, from userid 500)
	id 6F764360D727; Tue, 21 Apr 2026 12:05:35 +0300 (MSK)
Date: Tue, 21 Apr 2026 12:05:35 +0300
From: Vitaly Chikunov <vt@altlinux.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.12 000/162] 6.12.83-rc1 review
Message-ID: <aec89o0gkClR3nss@altlinux.org>
References: <20260420153927.006696811@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260420153927.006696811@linuxfoundation.org>

On Mon, Apr 20, 2026 at 05:40:32PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.83 release.
> There are 162 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Vitaly Chikunov <vt@altlinux.org>

Thanks for the drm/xe/mmio fixes.

> 
> Responses should be made by Wed, 22 Apr 2026 15:38:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.83-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------
> Pseudo-Shortlog of commits:

> Sasha Levin <sashal@kernel.org>
>     Revert "drm/xe: Switch MMIO interface to take xe_mmio instead of xe_gt"
> 
> Sasha Levin <sashal@kernel.org>
>     Revert "drm/xe/mmio: Avoid double-adjust in 64-bit reads"
> 
