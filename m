Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B65CB27721
	for <patches@lists.linux.dev>; Tue, 14 Feb 2023 13:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=B+E+7sy6cIbhAFMXxGnABOOh8lPakVEHgkYT0x+xQvs=; b=AQvj8Ppa1PFMSyTsi497SfB/sR
	mhZr/dAGFbjgjAn2lv+Sc8jXibmG6RK0vbbCME7Ao691caEmdEflJu1hrcCUTXM14nhNBM77CPfLw
	VCC931hk0OdmpXGe4aIo6Pqyvz8Koh3VGCNDsv3ysVl9iLKJdfa1guNdHtLoLSxWNxxjAHniuwPUx
	9ois8DSySAruNeU+Bi9OuPOm72EYTeRo+Tw6ChWbFtAYe8q/hAoUwGsyhormn1argw4DgkblYW+M5
	wbe2GD/0JeXyrs2lCVAEEMy8XZPAlr2vO9YVz+xvfxbxzQIno73pob2wJlHQeZGbAqPuPi5fuvmac
	nE2TRnEg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:37078)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1pRvE4-0005RY-Fp; Tue, 14 Feb 2023 13:20:04 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1pRvE0-0003wh-Is; Tue, 14 Feb 2023 13:20:00 +0000
Date: Tue, 14 Feb 2023 13:20:00 +0000
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Florian Fainelli <f.fainelli@gmail.com>, stable@vger.kernel.org,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 000/139] 5.10.168-rc1 review
Message-ID: <Y+uKgPDwdPrfGoq4@shell.armlinux.org.uk>
References: <20230213144745.696901179@linuxfoundation.org>
 <cc3f4cfb-adbc-c3b7-1c21-bb28e98499d8@gmail.com>
 <Y+soPsujgwChdgr7@kroah.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+soPsujgwChdgr7@kroah.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>

On Tue, Feb 14, 2023 at 07:20:46AM +0100, Greg Kroah-Hartman wrote:
> On Mon, Feb 13, 2023 at 11:50:24AM -0800, Florian Fainelli wrote:
> > On 2/13/23 06:49, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.10.168 release.
> > > There are 139 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Wed, 15 Feb 2023 14:46:51 +0000.
> > > Anything received after that time might be too late.
> > > 
> > > The whole patch series can be found in one patch at:
> > > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.168-rc1.gz
> > > or in the git tree and branch at:
> > > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > > and the diffstat can be found below.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > 
> > There is a regression coming from:
> > 
> > nvmem: core: fix registration vs use race
> > 
> > which causes the following to happen for MTD devices:
> > 
> > [    6.031640] kobject_add_internal failed for mtd0 with -EEXIST, don't try
> > to register things with the same name in the same directory.
> > [    7.846965] spi-nor: probe of spi0.0 failed with error -17
> > 
> > attached is a full log with the call trace. This does not happen with
> > v6.2-rc8 where the MTD partitions are successfully registered.
> 
> Can you use `git bisect` to find the offending commit?

I would guess that there is something wrong with the backporting of
my series - possibly a patch was dropped from the series?

"nvmem: core: fix cleanup after dev_set_name()" missing, which
initialises the struct device? But if that was missing, then
"nvmem: core: fix registration vs use race" wouldn't apply.

... but then you did send me a failure notice for the above
blamed commit, so I wonder how you applied it.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
