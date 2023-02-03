Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D3D979D9
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 16:45:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E89CAC433D2;
	Fri,  3 Feb 2023 16:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675442722;
	bh=jFqyihOG2qysQhfUaE8WHd7ywz99MsnZfWzodwPNilo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=G6/WWc8hp0Xk23in/lJm56NhvcRndfWU6EugJe+EpyH8lVaJbXQHAouLzK6COs5l/
	 tp5oFNUXrjFKfBMxZC7BG6+9NtuLxh/CiFa3KuVDOqaGx+0mHS0y7b+hxSb3TwheYN
	 URwF5W1FCr5VeSUjxnogdwB8URnYC2CoMQ8CYSdE=
Date: Fri, 3 Feb 2023 17:45:19 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>, Eric Biggers <ebiggers@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.4 000/134] 5.4.231-rc1 review
Message-ID: <Y906Hz3UWYxoxYdD@kroah.com>
References: <20230203101023.832083974@linuxfoundation.org>
 <20230203155619.GA3176223@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230203155619.GA3176223@roeck-us.net>

On Fri, Feb 03, 2023 at 07:56:19AM -0800, Guenter Roeck wrote:
> On Fri, Feb 03, 2023 at 11:11:45AM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.231 release.
> > There are 134 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 05 Feb 2023 10:09:58 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Building ia64:defconfig ... failed
> --------------
> Error log:
> <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
> arch/ia64/kernel/mca_drv.c: In function 'mca_handler_bh':
> arch/ia64/kernel/mca_drv.c:179:9: error: implicit declaration of function 'make_task_dead'
> 
> Caused by "exit: Add and use make_task_dead.". Did that really have to be backported ?

Yup, it does!

Eric, any help with this?

thanks,

greg k-h
