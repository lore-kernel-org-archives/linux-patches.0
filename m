Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D52565CA9
	for <patches@lists.linux.dev>; Tue, 13 Dec 2022 14:23:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 162ECC433EF;
	Tue, 13 Dec 2022 14:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670941412;
	bh=s313XL+1OkI/sYPxToUUD8jO9asGoh5OQpwiWOtWwgY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QV/Xvn+/Cqc3JUsQDfDrm8kOK3XOcG17SjuCeTVAdwc1iOaC98aNoPSuxkH3tlPSL
	 Vq7/zdjr7rY61MFa3GqXexef3OVABJvnRFU8IA+0/ulbg7T0Fj/G0CbOkMkMbSupl6
	 Uuq+N/gzZXe1AUYa+XnfGIIL+qWn9j7Ti5ZOiD7U=
Date: Tue, 13 Dec 2022 15:23:30 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>,
	YueHaibing <yuehaibing@huawei.com>, Netdev <netdev@vger.kernel.org>,
	stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Guenter Roeck <linux@roeck-us.net>, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	Pavel Machek <pavel@denx.de>, Jon Hunter <jonathanh@nvidia.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Sudip Mukherjee <sudipm.mukherjee@gmail.com>, srw@sladewatkins.net,
	rwarsow@gmx.de, Jakub Kicinski <kuba@kernel.org>,
	Anders Roxell <anders.roxell@linaro.org>
Subject: Re: [PATCH 5.10 000/106] 5.10.159-rc1 review
Message-ID: <Y5iK4kii6oPYi6g8@kroah.com>
References: <20221212130924.863767275@linuxfoundation.org>
 <CA+G9fYv7tm9zQwVWnPMQMjFXtNDoRpdGkxZ4ehMjY9qAFF0QLQ@mail.gmail.com>
 <86c7e7a5-6457-49c5-a9e3-b28b8b8c1134@app.fastmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86c7e7a5-6457-49c5-a9e3-b28b8b8c1134@app.fastmail.com>

On Tue, Dec 13, 2022 at 10:20:30AM +0100, Arnd Bergmann wrote:
> On Tue, Dec 13, 2022, at 08:48, Naresh Kamboju wrote:
> > On Mon, 12 Dec 2022 at 18:43, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> >
> > Regression detected on arm64 Raspberry Pi 4 Model B the NFS mount failed.
> >
> > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> >
> > Following changes have been noticed in the Kconfig file between good and bad.
> > The config files attached to this email.
> >
> > -CONFIG_BCMGENET=y
> > -CONFIG_BROADCOM_PHY=y
> > +# CONFIG_BROADCOM_PHY is not set
> > -CONFIG_BCM7XXX_PHY=y
> > +# CONFIG_BCM7XXX_PHY is not set
> > -CONFIG_BCM_NET_PHYLIB=y
> 
> > Full test log details,
> >  - https://lkft.validation.linaro.org/scheduler/job/5946533#L392
> >  - 
> > https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.158-107-gd2432186ff47/testrun/13594402/suite/log-parser-test/tests/
> >  - 
> > https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.158-107-gd2432186ff47/testrun/13594402/suite/log-parser-test/test/check-kernel-panic/history/
> 
> Where does the kernel configuration come from? Is this
> a plain defconfig that used to work, or do you have
> a board specific config file?
> 
> This is most likely caused by the added dependency on
> CONFIG_PTP_1588_CLOCK that would lead to the BCMGENET
> driver not being built-in if PTP support is in a module.

I've dropped the patch that caused this and will push out a -rc2 in a
bit.

thanks all!

greg k-h
