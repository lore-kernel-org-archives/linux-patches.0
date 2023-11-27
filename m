Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 756FD16419;
	Mon, 27 Nov 2023 13:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XGeA/H3k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C4D1C433C8;
	Mon, 27 Nov 2023 13:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701090097;
	bh=lXWg88itlTnqydnqiK3rCRUDWJLDAFTD9g8Pk4yxK6c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XGeA/H3k7yZ+OkeaJItHDcgTYsncPXxGgWd7VEpu4vLWbqVnhD5qwbrg+VA6CODBX
	 pryou3AigatAlqrTj7FGcPk18Pkgnts/kZPjWBGONUVJEN8Kh/cp7x2T2SB00t54fo
	 dMeBAv7SiUEGJQENNwUH4uDmAzDgzsMTOvyxc9C4=
Date: Mon, 27 Nov 2023 12:47:03 +0000
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Helge Deller <deller@gmx.de>
Cc: Guenter Roeck <linux@roeck-us.net>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com
Subject: Re: [PATCH 4.14 00/53] 4.14.331-rc2 review
Message-ID: <2023112751-predict-ovary-5afa@gregkh>
References: <20231125163059.878143365@linuxfoundation.org>
 <09f33739-9bf6-4ff8-895d-92d3567c3cb9@roeck-us.net>
 <ZWOs6uwZoCoxYSSs@p100>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZWOs6uwZoCoxYSSs@p100>

On Sun, Nov 26, 2023 at 09:39:06PM +0100, Helge Deller wrote:
> * Guenter Roeck <linux@roeck-us.net>:
> > On 11/25/23 08:32, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 4.14.331 release.
> > > There are 53 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Mon, 27 Nov 2023 16:30:48 +0000.
> > > Anything received after that time might be too late.
> > > 
> > 
> > Building parisc64:generic-64bit_defconfig ... failed
> > --------------
> > Error log:
> > hppa64-linux-ld: arch/parisc/kernel/head.o: in function `$iodc_panic':
> > (.head.text+0x64): undefined reference to `init_stack'
> > hppa64-linux-ld: (.head.text+0x68): undefined reference to `init_stack'
> > make[1]: *** [Makefile:1049: vmlinux] Error 1
> > make: *** [Makefile:153: sub-make] Error 2
> 
> Indeed.
> Thanks for testing, Guenter!
> 
> Greg, could you please replace the patch in queue/4.14 with
> the one below? It simply uses another stack start, which is ok since the
> machine will stop anyway.
> 
> No changes needed for your other stable-queues. I tested 4.19 and
> it's ok as-is.
> 

Now replaced, thanks.

greg k-h
