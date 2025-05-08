Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C503F5A79B;
	Thu,  8 May 2025 11:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746703403; cv=none; b=ZJTkEflTAEZQyWPOjOVVwl2AKyYC56edhFfLDGD6SViKRNENegAyfBHiTD2WOuRuIrHuifzzXHomlSZtzXmiWEeDA0aiWqe+zCKoZdbgBtDq9nUUHvHFPf0HbpC04IoL9JCbXXU+BNCioVKktXvfjVhVciJ/sv5FOdtkkS1j3r8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746703403; c=relaxed/simple;
	bh=9cRsRIw5h8Q8Aa3akEl/ew1Q7vlSqa6FTzoFmcr0C0A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lKsF3yp2OVZdAEmT8FebsRca12MKXpMmH/7Wl4s68xooPqozr4T1VRPjsp/mmjFg+lx/L4xchO3sQGdGXUVgxdYQL0pBRHfwj38WM3p3IAxH2kaeUR8K9lkt45yjPcIry10jPwpYTcH8MHKB4x9FlBDbHOAiM9Sfm0whOmjxdUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AlGp+r+/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AlGp+r+/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA9F1C4CEE7;
	Thu,  8 May 2025 11:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746703402;
	bh=9cRsRIw5h8Q8Aa3akEl/ew1Q7vlSqa6FTzoFmcr0C0A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AlGp+r+/rf1C17WhNL4goPwpTB2/ircsoq81I+re9IpWRHToyJo6b62YRa437pO1D
	 ZBoLNWZA2qLoLeWTfEuV1oCFFB1ek4F5AScgF0oCQ8kWUo2bxXCjmMbPQ4FlMWr6jk
	 yjNQI/cVAoVss2VH7VmasX9iCV0sC1ks9kEsx+4I=
Date: Thu, 8 May 2025 13:23:19 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jon Hunter <jonathanh@nvidia.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org,
	"linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.15 00/55] 5.15.182-rc1 review
Message-ID: <2025050855-lustrous-perch-ad8d@gregkh>
References: <20250507183759.048732653@linuxfoundation.org>
 <843c2ffe-6653-4975-a818-03d4bb9e5be6@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <843c2ffe-6653-4975-a818-03d4bb9e5be6@nvidia.com>

On Thu, May 08, 2025 at 10:44:45AM +0100, Jon Hunter wrote:
> Hi Greg,
> 
> On 07/05/2025 19:39, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.182 release.
> > There are 55 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 09 May 2025 18:37:41 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.182-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
> > Stephan Gerhold <stephan.gerhold@linaro.org>
> >      serial: msm: Configure correct working mode before starting earlycon
> 
> The above commit is breaking the build for ARM64 and I am seeing
> the following build error ...
> 
> drivers/tty/serial/msm_serial.c: In function ‘msm_serial_early_console_setup_dm’:
> drivers/tty/serial/msm_serial.c:1737:34: error: ‘MSM_UART_CR_CMD_RESET_RX’ undeclared (first use in this function); did you mean ‘UART_CR_CMD_RESET_RX’?
>  1737 |         msm_write(&device->port, MSM_UART_CR_CMD_RESET_RX, MSM_UART_CR);
>       |                                  ^~~~~~~~~~~~~~~~~~~~~~~~
>       |                                  UART_CR_CMD_RESET_RX
> drivers/tty/serial/msm_serial.c:1737:34: note: each undeclared identifier is reported only once for each function it appears in
> drivers/tty/serial/msm_serial.c:1737:60: error: ‘MSM_UART_CR’ undeclared (first use in this function); did you mean ‘UART_CR’?
>  1737 |         msm_write(&device->port, MSM_UART_CR_CMD_RESET_RX, MSM_UART_CR);
>       |                                                            ^~~~~~~~~~~
>       |                                                            UART_CR
> drivers/tty/serial/msm_serial.c:1738:34: error: ‘MSM_UART_CR_CMD_RESET_TX’ undeclared (first use in this function); did you mean ‘UART_CR_CMD_RESET_TX’?
>  1738 |         msm_write(&device->port, MSM_UART_CR_CMD_RESET_TX, MSM_UART_CR);
>       |                                  ^~~~~~~~~~~~~~~~~~~~~~~~
>       |                                  UART_CR_CMD_RESET_TX
>   CC      drivers/ata/libata-transport.o
> drivers/tty/serial/msm_serial.c:1739:34: error: ‘MSM_UART_CR_TX_ENABLE’ undeclared (first use in this function); did you mean ‘UART_CR_TX_ENABLE’?
>  1739 |         msm_write(&device->port, MSM_UART_CR_TX_ENABLE, MSM_UART_CR);
>       |                                  ^~~~~~~~~~~~~~~~~~~~~
>       |                                  UART_CR_TX_ENABLE
> 
> 
> After reverting this, the build is passing again.

Thanks, commit is now dropped.  Odd it didn't show up on my arm64
allmodconfig builds :(

greg k-h
