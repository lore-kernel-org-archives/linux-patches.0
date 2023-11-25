Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EC3F28DD5;
	Sat, 25 Nov 2023 15:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b8VP3DDZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61225C433C7;
	Sat, 25 Nov 2023 15:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700925969;
	bh=AxS91YaKOq3eGrZCLY+7MTYjoghw/8YartYwc4isNbY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=b8VP3DDZUVqRQmaMk8BXN+oIr50lKsDnRAj+g+JYXQAcEJKiM2vX2ObB0uhRKxn3i
	 mBwTh6aJsYh/nyIvAQZ/0oHwgRbWLPIfUrOi0DNoSAVJa0gMGiS9lKV4U0yntpSfdT
	 m1OtjSlLhQFH2XGPs1P/wUPNhLD+Nx4cVl/OEJms=
Date: Sat, 25 Nov 2023 15:26:07 +0000
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pavel Machek <pavel@denx.de>
Cc: Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>,
	stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org
Subject: Re: [PATCH 4.19 00/97] 4.19.300-rc1 review
Message-ID: <2023112518-traverse-unsecured-daa2@gregkh>
References: <20231124171934.122298957@linuxfoundation.org>
 <d48b5514-759f-47a0-b024-494ce87ec60f@linaro.org>
 <ZWHYlErVfVq8ZoOu@duo.ucw.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZWHYlErVfVq8ZoOu@duo.ucw.cz>

On Sat, Nov 25, 2023 at 12:20:52PM +0100, Pavel Machek wrote:
> Hi!
> 
> > > This is the start of the stable review cycle for the 4.19.300 release.
> > > There are 97 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > 
> > We see this failure on Arm32:
> > And this one on Arm64:
> 
> We see problems on arm, too:
> 
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/1084460512

Note, posting odd links isn't going to really help much, I don't have
the cycle, and sometimes the connectivity (last few stable releases were
done on trains and planes), to check stuff like this.

Info in an email is key, raw links is not going to help, sorry.

greg k-h
