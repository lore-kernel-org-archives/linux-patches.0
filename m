Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE446D273;
	Tue,  5 Dec 2023 04:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nf+47rp8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4522C433C8;
	Tue,  5 Dec 2023 04:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701750875;
	bh=8Ps76KLB/ZwO7Js1mZaNyHK/kOWqD+42yNXiGnKLZ4w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Nf+47rp8SQVdhStKXaKUosvr7HkgPDC6Nk9l7yjPnnhGMmGbh3gapuSBah7q/7eMj
	 ZmCv6ML3oG1lLXQ6TgtnRpyqw7hmLXZRR5FLEhxEoKChB5STBCCLRMboNcVLFoQEXb
	 TEDvKvOy6jWxkg1X9ZvcRpHwUgsO4yctoLAK10Kk=
Date: Tue, 5 Dec 2023 13:34:32 +0900
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com
Subject: Re: [PATCH 5.10 000/135] 5.10.203-rc1 review
Message-ID: <2023120526-handshake-kick-28a7@gregkh>
References: <20231205031530.557782248@linuxfoundation.org>
 <2d9146a0-3043-4e22-841f-78ada94224c6@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d9146a0-3043-4e22-841f-78ada94224c6@roeck-us.net>

On Mon, Dec 04, 2023 at 07:47:48PM -0800, Guenter Roeck wrote:
> On 12/4/23 19:15, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.203 release.
> > There are 135 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 07 Dec 2023 03:14:57 +0000.
> > Anything received after that time might be too late.
> > 
> 
> drivers/s390/crypto/ap_bus.c: In function 'ap_bus_force_rescan':
> drivers/s390/crypto/ap_bus.c:791:28: error: 'ap_scan_bus_count' undeclared
> 
> Seen with various s390 builds. Caused by commit 4c61e62ecde8 ("s390/ap: fix AP
> bus crash on early config change callback invocation") which uses the
> undeclared variable but does not introduce it.

Now dropped, thanks.

greg k-h
