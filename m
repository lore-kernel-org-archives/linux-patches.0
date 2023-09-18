Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 183091CAA4
	for <patches@lists.linux.dev>; Mon, 18 Sep 2023 13:14:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E745DC433CA;
	Mon, 18 Sep 2023 13:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695042862;
	bh=XDOvjrjguMe0O3jeSSKS15M6Sp7a2R6O1nCtq8TDOqo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=moy/uvBgM6HQA8GWIujBSefdQevbL1rDY6drGoWCOGAlRwHdu8P/KHLhnJT+tInE4
	 l44tiN9OEtrlAXsiw2qAUwUR3MtgNqen8AbL2Z/IhiGH2naAKgbsQ3QAv8hSXmVk/3
	 HibdaCy/zzKUZszzEX+CwGKBdA4qiQizGxtg7aBQ=
Date: Mon, 18 Sep 2023 15:14:19 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jon Hunter <jonathanh@nvidia.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	Sameer Pujar <spujar@nvidia.com>,
	"linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 6.5 000/285] 6.5.4-rc1 review
Message-ID: <2023091850-gossip-denatured-ce2b@gregkh>
References: <20230917191051.639202302@linuxfoundation.org>
 <dfe78c1a-8322-413b-f1b7-3a6a307a831c@nvidia.com>
 <e5a0e1cc-1360-23fe-408d-03f46dd76c5f@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e5a0e1cc-1360-23fe-408d-03f46dd76c5f@nvidia.com>

On Mon, Sep 18, 2023 at 02:04:27PM +0100, Jon Hunter wrote:
> 
> On 18/09/2023 13:52, Jon Hunter wrote:
> > Hi Greg,
> > 
> > On 17/09/2023 20:10, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 6.5.4 release.
> > > There are 285 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Tue, 19 Sep 2023 19:10:04 +0000.
> > > Anything received after that time might be too late.
> > > 
> > > The whole patch series can be found in one patch at:
> > >     https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.5.4-rc1.gz
> > > or in the git tree and branch at:
> > >     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.5.y
> > > and the diffstat can be found below.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > > 
> > > -------------
> > > Pseudo-Shortlog of commits:
> > 
> > ...
> > 
> > > Sameer Pujar <spujar@nvidia.com>
> > >      arm64: tegra: Update AHUB clock parent and rate
> > 
> > 
> > Unfortunately, the above change is causing a regression in one of our
> > audio tests and we are looking into why this is.
> > 
> > Can we drop this from stable for now?
> 
> 
> An alternative to dropping this change is to pull in the following fixes ...
> 
> https://lore.kernel.org/linux-tegra/169447691068.2390116.10518505217580469969.b4-ty@kernel.org/T/#t

they aren't in Linus's tree yet, any plans on when that will happen?

And to confirm, what are the git ids of these in linux-next?

thanks,

greg k-h
