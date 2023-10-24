Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C9BB1BDC8
	for <patches@lists.linux.dev>; Tue, 24 Oct 2023 08:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YXIiJktf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8337DC433C8;
	Tue, 24 Oct 2023 08:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698135755;
	bh=4pSVrj+SSWFw7rLDfWopdukUhyQvQyk5SOKZaKQkS0o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YXIiJktfIv7Abl+M8zp4gbGGj0GnTXHzbrf4LD6M0kU3+1RZuMGmw4+l/2mugI9G5
	 NzUyjVtiWRV40ghQoAtw9uX5HPgnClbG/LqF2u0ghSL+1bkjWu1A9tPmpfODc9Vaa9
	 2/N6CZmcPCtUv4cfv/jRzn5l8tZouQt+uLICfyNo=
Date: Tue, 24 Oct 2023 10:22:32 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 4.14 00/66] 4.14.328-rc1 review
Message-ID: <2023102417-blade-bartender-29e2@gregkh>
References: <20231023104810.781270702@linuxfoundation.org>
 <f3b2a4ac-042d-4c20-4020-3a09822811ac@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f3b2a4ac-042d-4c20-4020-3a09822811ac@roeck-us.net>

On Mon, Oct 23, 2023 at 07:37:36AM -0700, Guenter Roeck wrote:
> On 10/23/23 03:55, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.14.328 release.
> > There are 66 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 25 Oct 2023 10:47:57 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Building s390:allmodconfig ... failed
> --------------
> Error log:
> In file included from include/linux/kernel.h:10,
>                  from arch/s390/pci/pci_dma.c:8:
> arch/s390/pci/pci_dma.c: In function 'bitmap_vzalloc':
> arch/s390/pci/pci_dma.c:536:15: error: implicit declaration of function 'check_mul_overflow'

Ah the header file maze.  I've fixed this up now, thanks.

greg k-h
