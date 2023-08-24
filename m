Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1974288EB
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 16:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDB98C433CA;
	Thu, 24 Aug 2023 16:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692895221;
	bh=4e06H7VcbeP0wJI+cNsJmxHmi54j3RoRZWY0z6/rWLM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IRFvXzN7U7fH2Vqh9ICN+vGBH+5S2BX4sKsuBMm7Tg4eknKTe0OZDCh/ufYNmzRTh
	 f040ZPz4veBtvTIrsd4eg/5Gd/FVhRn2GpVWC3PfVdhkgIitZ/7dTlsXbHR3T2LLW1
	 dnT63sWg7d0nqo8F9P34R4ExT9EXb7YOU6mw2OSQ=
Date: Thu, 24 Aug 2023 18:40:18 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.1 000/194] 6.1.47-rc1 review
Message-ID: <2023082404-ion-jaunt-a14f@gregkh>
References: <20230821194122.695845670@linuxfoundation.org>
 <991b93d2-9fde-4233-97d5-1133a9360d02@roeck-us.net>
 <2023082309-veggie-unwoven-a7df@gregkh>
 <CA+G9fYvwxuVpSn24YvtdNXaofg2JtZDREatOpDsKTVJX+nFN3Q@mail.gmail.com>
 <2d8a5f48-6c50-4c12-8a3d-23e621c6b722@roeck-us.net>
 <2023082325-expansion-revoke-1f3a@gregkh>
 <2023082401-arrange-bulk-d42a@gregkh>
 <4b8fcb23-c5e3-4bf1-957f-f0cc717564be@roeck-us.net>
 <2023082459-oxidize-script-77e4@gregkh>
 <78a26d15-68eb-4a6f-a092-f7a554aa29e7@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <78a26d15-68eb-4a6f-a092-f7a554aa29e7@roeck-us.net>

On Thu, Aug 24, 2023 at 08:58:46AM -0700, Guenter Roeck wrote:
> On Thu, Aug 24, 2023 at 05:15:30PM +0200, Greg Kroah-Hartman wrote:
> [ ... ]
> > 
> > This might be an issue on AMD chips, but for some reason, in running
> > this kernel on my systems here, I have no boot warnings at all.  I
> > blamed it on them being only AMD chips.  If that's not the issue then I
> > really have no idea, sorry.
> > 
> 
> AFAIK it depends on the compiler used and on the enabled debug options.
> At some point I lost track about what exactly has to be enabled to see
> the problem. We see it a lot with our (ChromeOS) debug kernel testing
> which has various debug options enabled, to the point where we may
> temporarily remove the warning from the kernel to stop the noise.
> 
> Alternatively, as I had suggested earlier, we could revert all srso patches
> because they only seem to cause trouble. So far I have been resisting that
> because I am concerned that it would make things even worse (like one can
> not really revert a heart surgery without doing even more damage).

If you don't want the feature, you can disable it at build time (I
think), and I know you can disable it at runtime.  But there are groups
out that that "need" this, to solve a known security hole in some cpus,
so it is required for them.  To remove the code entirely would not be
good for them, so I will say, if they are the ones that need this, they
should help fix this warning, no one else should be seeing it :)

thanks,

greg k-h
