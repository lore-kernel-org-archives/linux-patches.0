Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F7BC28E22;
	Sat, 25 Nov 2023 15:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NhLQiHQ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43554C433C7;
	Sat, 25 Nov 2023 15:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700927129;
	bh=ObM2SPrwslmICoD8Q96gXrgGU06eqzKoLp3WXIF2rqI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NhLQiHQ1HATVxzr6Gwt7XXIQnHL8Zcz8zl1jLM3PWyQBet3x6mNKzyg6WExfgkqWx
	 eW/useTyVBnWWRuGDIMzAPCMYU7/svCq+s78rzFjRBFSUDJcyCDW0mbfkdBt676+cq
	 0SHPxRpgr9gXGwIE4sB7XgvvDD5hQ3bal73ka9D0=
Date: Sat, 25 Nov 2023 15:45:27 +0000
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org,
	Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>,
	dima@arista.com, linux-amlogic@lists.infradead.org,
	Linux ARM <linux-arm-kernel@lists.infradead.org>,
	Kevin Hilman <khilman@baylibre.com>
Subject: Re: [PATCH 5.4 000/159] 5.4.262-rc1 review
Message-ID: <2023112517-agreed-email-0ecc@gregkh>
References: <20231124171941.909624388@linuxfoundation.org>
 <CA+G9fYuVgqVc57YAwfA8MK6_Q86wD=RznCYKHDf_tD3foM9Y5w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYuVgqVc57YAwfA8MK6_Q86wD=RznCYKHDf_tD3foM9Y5w@mail.gmail.com>

On Sat, Nov 25, 2023 at 01:09:43AM +0530, Naresh Kamboju wrote:
> On Sat, 25 Nov 2023 at 00:52, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.4.262 release.
> > There are 159 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sun, 26 Nov 2023 17:19:17 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.262-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> 
> As Daniel replied on 4.19 build failures,
> Following build warning / errors occurred on arm and arm64 on the
> stable-rc linux.5.4.y and linux-4.19.y.
> 
> tty/serial: Migrate meson_uart to use has_sysrq
> [ Upstream commit dca3ac8d3bc9436eb5fd35b80cdcad762fbfa518 ]
> 
> drivers/tty/serial/meson_uart.c: In function 'meson_uart_probe':
> drivers/tty/serial/meson_uart.c:728:13: error: 'struct uart_port' has
> no member named 'has_sysrq'
>   728 |         port->has_sysrq = IS_ENABLED(CONFIG_SERIAL_MESON_CONSOLE);
>       |             ^~
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Now fixed, thanks.

greg k-h
