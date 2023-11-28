Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31E685026F;
	Tue, 28 Nov 2023 21:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iKqTfH/0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F8ADC4166B;
	Tue, 28 Nov 2023 21:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701205805;
	bh=Tk8vqq2f+B+POOBODD8vnVMKQofy9qJFCjtMT7FlNR0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iKqTfH/0fZ7PC6Ri15G7qxwxShqEPIZQDuTVp/GlILYShPIZniktNnsy3bTCem8by
	 5u6sGPvGGlHbQJqrPSW36t9Wzmi1+fwKCxe3eeG9m+baqy6bQUW2HCYAFd8uUAINDK
	 KSJ9Kewp9jr5eeDbVzVkZJ1swj9On/D5TeLbLbrg=
Date: Tue, 28 Nov 2023 21:10:03 +0000
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pavel Machek <pavel@denx.de>
Cc: Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	stable@vger.kernel.org, patches@lists.linux.dev,
	LKML <linux-kernel@vger.kernel.org>, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, alexander.deucher@amd.com,
	mario.limonciello@amd.com, zhujun2@cmss.chinamobile.com,
	sashal@kernel.org, skhan@linuxfoundation.org, bhelgaas@google.com
Subject: Re: [PATCH 4.14 00/53] 4.14.331-rc2 review
Message-ID: <2023112844-sesame-overdrawn-5853@gregkh>
References: <20231125163059.878143365@linuxfoundation.org>
 <ZWUBaYipygLMkfjz@duo.ucw.cz>
 <f4a7634-3d34-af29-36ca-6f3439b4ce9@linux.intel.com>
 <ZWZQCJtD7kmX9iRO@duo.ucw.cz>
 <2023112818-browse-floss-eb6f@gregkh>
 <ZWZSKgxjSRcA/qUK@duo.ucw.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZWZSKgxjSRcA/qUK@duo.ucw.cz>

On Tue, Nov 28, 2023 at 09:48:42PM +0100, Pavel Machek wrote:
> Hi!
> 
> > > > > > Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
> > > > > >     RDMA/hfi1: Use FIELD_GET() to extract Link Width
> > > > > 
> > > > > This is a good cleanup, but not a bugfix.
> > > > > 
> > > > > > Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
> > > > > >     atm: iphase: Do PCI error checks on own line
> > > > > 
> > > > > Just a cleanup, not sure why it was picked for stable.
> > > > 
> > > > Just an additional bit of information, there have been quite many cleanups 
> > > > from me which have recently gotten the stable notification for some 
> > > > mysterious reason. When I had tens of them in my inbox and for various 
> > > > kernel versions, I immediately stopped caring to stop it from happening.
> > > > 
> > > > AFAIK, I've not marked those for stable inclusion so I've no idea what
> > > > got them included.
> > > 
> > > Fixes tag can do it. Plus, "AUTOSEL" robot does it randomly, with no
> > > human oversight :-(.
> > 
> > the autosel bot has lots of oversight.
> 
> Can you describe how that oversight works?

There have been many papers and presentations about it, no need for me
to say it all here again...
