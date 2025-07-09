Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23FE723BCF3;
	Wed,  9 Jul 2025 08:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752049183; cv=none; b=hi68No0RFueKuqaLyYA2god8/Isay7U0g0Z9LP97o/4GXthcCDCR7w+ZLRsWypFkZ4h4UDAcPZKg0lX2k8/BtKyS0PB6+fDHcz1gEOvVsj1Ea9Oei+JDbzMS7wj1+WBzHzymkAnJsNrZSEZulJpWefMOCGbeH1zdoDd9yKFYH9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752049183; c=relaxed/simple;
	bh=a4DO43GgiFHJwdOTp+kKgsrgjSbcR3PTiF2Q8UxI5ck=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gJ3qwMMg4V/Q8sbVCX54p4TlLdjzfbt6gqIaVD+QGTeKC+vk6EvFF5WtICg4dir9vtUd4j+osA7+w9dfbe87QN9w42hMXzgpAp7hB/GpDLUVbS65Nss2oDHnUx21KyiSRujrrbZK771OU6PR5d63MxhH8Ww98I9V9/6VitJLzZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EZtD6fAY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EZtD6fAY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 267D4C4CEEF;
	Wed,  9 Jul 2025 08:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752049182;
	bh=a4DO43GgiFHJwdOTp+kKgsrgjSbcR3PTiF2Q8UxI5ck=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EZtD6fAYcuBCx4QDbkWYeF18ikPAdwiPH0K2kdqkZmV4/IKlVvAmQb7RQMh6WEoUb
	 NF0T0h+jNiUsiz6Sdp2Jid1wXw5J43uMfsYBe1aMW1THIxtAllHGWJkNqdV9jzk4pC
	 Iy7THedHkVQ0ZePLfGC/R53GaSMNs46IEqShrlDQ=
Date: Wed, 9 Jul 2025 10:19:37 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Anders Roxell <anders.roxell@linaro.org>, jakub.lewalski@nokia.com,
	Elodie Decerle <elodie.decerle@nokia.com>,
	Aidan Stewart <astewart@tektelic.com>,
	Fabio Estevam <festevam@gmail.com>
Subject: Re: [PATCH 6.15 000/263] 6.15.5-rc2 review
Message-ID: <2025070946-heroism-operation-5ea8@gregkh>
References: <20250704125604.759558342@linuxfoundation.org>
 <CA+G9fYvidpyHTQ179dAJ4TSdhthC-Mtjuks5iQjMf+ovfPQbTg@mail.gmail.com>
 <CA+G9fYub_Ln=EPp2mgL4-2ewvorZ6O7btM97Ka6RrWhO1o0Liw@mail.gmail.com>
 <CA+G9fYtb3OW5+0Y+qYC-hbg2AV-UUff3orui0VuckDrrMYjrcw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYtb3OW5+0Y+qYC-hbg2AV-UUff3orui0VuckDrrMYjrcw@mail.gmail.com>

On Wed, Jul 09, 2025 at 02:54:03AM +0530, Naresh Kamboju wrote:
> On Tue, 8 Jul 2025 at 00:04, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
> >
> > On Sun, 6 Jul 2025 at 15:50, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
> > >
> > > On Fri, 4 Jul 2025 at 20:14, Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > This is the start of the stable review cycle for the 6.15.5 release.
> > > > There are 263 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > >
> > > > Responses should be made by Sun, 06 Jul 2025 12:55:09 +0000.
> > > > Anything received after that time might be too late.
> > > >
> > > > The whole patch series can be found in one patch at:
> > > >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.5-rc2.gz
> > > > or in the git tree and branch at:
> > > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.15.y
> > > > and the diffstat can be found below.
> > > >
> > > > thanks,
> > > >
> > > > greg k-h
> > >
> > > Approximately 20% of devices are experiencing intermittent boot failures
> > > with this kernel version. The issue appears to be related to auto login
> > > failures, where an incorrect password is being detected on the serial
> > > console during the login process.
> >
> > Reported issue is also noticed on Linux tree 6.16-rc5 build.
> >
> > > We are investigating this problem.
> 
> The following three patches were reverted and the system was re-tested.
> The previously reported issues are no longer observed after applying the
> reverts.
> 
> serial: imx: Restore original RXTL for console to fix data loss
>     commit f23c52aafb1675ab1d1f46914556d8e29cbbf7b3 upstream.
> 
> serial: core: restore of_node information in sysfs
>     commit d36f0e9a0002f04f4d6dd9be908d58fe5bd3a279 upstream.
> 
> tty: serial: uartlite: register uart driver in init
>     [ Upstream commit 6bd697b5fc39fd24e2aa418c7b7d14469f550a93 ]
> 
> Reference bug report lore link,
>  - https://lore.kernel.org/stable/CA+G9fYvidpyHTQ179dAJ4TSdhthC-Mtjuks5iQjMf+ovfPQbTg@mail.gmail.com/

As these are upstream, and causing the problem there too, can you email
the tty list about them?  And those are 2 different serial drivers, and
one serial core change, all independant, which feels odd that they all
were needed to fix this issue.

thanks,

greg k-h
