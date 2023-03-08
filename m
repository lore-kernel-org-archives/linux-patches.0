Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F4AF747F
	for <patches@lists.linux.dev>; Wed,  8 Mar 2023 14:44:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 506A6C433D2;
	Wed,  8 Mar 2023 14:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678286675;
	bh=x7K563D1bIPVbxvD9d60t5KyNe2ANsTBa7TdsK1Ilp4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DNPAEiW0QndoNYuOw3x1ioiPS/T4IXPPHRn2fXqkMUSPPq+srjASJOidgqQ2xznt5
	 yruCKQY+EkPuy7DryxJxvSbyzOrVTldp0Ptzg53glTSjffsYpxXi6B7T15W/8+fDFe
	 GYv3pSGOS7IqnA9ciVEA2jSncLT80neJnnz77fGw=
Date: Wed, 8 Mar 2023 15:44:32 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jon Hunter <jonathanh@nvidia.com>
Cc: stable@vger.kernel.org, Thierry Reding <treding@nvidia.com>,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 0000/1000] 6.2.3-rc2 review
Message-ID: <ZAifUN1XpQ/ojXz8@kroah.com>
References: <20230308091912.362228731@linuxfoundation.org>
 <6883f095-cf2b-2c45-5786-a46ba1c13dd7@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6883f095-cf2b-2c45-5786-a46ba1c13dd7@nvidia.com>

On Wed, Mar 08, 2023 at 01:49:30PM +0000, Jon Hunter wrote:
> Hi Greg,
> 
> On 08/03/2023 09:29, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.2.3 release.
> > There are 1000 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 10 Mar 2023 09:16:12 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.3-rc2.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.2.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > -------------
> > Pseudo-Shortlog of commits:
> 
> ...
> 
> > Thierry Reding <treding@nvidia.com>
> >      arm64: tegra: Bump #address-cells and #size-cells
> 
> 
> The above change introduced a regression for Tegra, which Thierry has since
> fixed [0]. Please can you drop this for now?

Now dropped, and the patch after this in the series as well.

thanks,

greg k-h
