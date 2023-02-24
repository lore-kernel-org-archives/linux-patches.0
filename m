Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 266643C26
	for <patches@lists.linux.dev>; Fri, 24 Feb 2023 10:28:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60C26C433EF;
	Fri, 24 Feb 2023 10:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1677234479;
	bh=kM7MCuigNoYDO61daH0fOla+5ecmOkbreNuU2hHUUXg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bqaU3TlyXhr1AatFbf81rtky4awB0/+Kqk0aPEIxuEiqvmj3KjxqocLmYEzme1CsV
	 Qpb7U+h6FzTH3QE+N7uN2IpmiFxWSmhHu1S8QjlZxN3qKxpXISZzUx8j9bvzXOI6i+
	 ok8elxwwbNrll4mYRXZ499OGqW9uqsiMNjZVSwIs=
Date: Fri, 24 Feb 2023 11:27:57 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/37] 5.15.96-rc3 review
Message-ID: <Y/iRLeEsyiYHjeh5@kroah.com>
References: <20230224102235.663354088@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230224102235.663354088@linuxfoundation.org>

On Fri, Feb 24, 2023 at 11:23:55AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.96 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 26 Feb 2023 10:22:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.96-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.

Only change here is that the permission issue on
scripts/pahole-version.sh _should_ now be resolved.

If not, please let me know.

thanks,

greg k-h
