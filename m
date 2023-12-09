Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61FA812B6C;
	Sat,  9 Dec 2023 11:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j48TNs3Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62E91C433C7;
	Sat,  9 Dec 2023 11:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702122283;
	bh=pw89+S3o+Y1kMK3hZRtx1AOUlilB1qIakTnGLVDhbLM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=j48TNs3YzTG6TGGcT4Y1ML+ejJzHeFfqETyIWx0F6mgK5FV86r1JAKYqbD55aF2by
	 S4+nX6mjxt2Za6tSaL4tv3vJH1PqLQtGzzpGFKld781txtNuq1sfHoyeiVXytr2KDB
	 gQCqBfqNLV2Duh0QDm3nZ6AYNginHs890odwAPzs=
Date: Sat, 9 Dec 2023 12:44:40 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Shuah Khan <skhan@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 5.10 000/131] 5.10.203-rc3 review
Message-ID: <2023120932-revolver-apple-d4c9@gregkh>
References: <20231205183249.651714114@linuxfoundation.org>
 <fa221062-03b4-46d7-8708-9d3ce49961dd@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa221062-03b4-46d7-8708-9d3ce49961dd@linuxfoundation.org>

On Wed, Dec 06, 2023 at 09:31:48AM -0700, Shuah Khan wrote:
> On 12/5/23 12:22, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.203 release.
> > There are 131 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 07 Dec 2023 18:32:16 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.203-rc3.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> Compiled. Fails to boot up. Boot hangs during systemd init sequence.
> I am debugging this and will update you.

Anything come of this?

thanks,

greg k-h
