Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AA301EA90;
	Mon, 27 Nov 2023 12:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="weGFaxme"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57AA6C433C8;
	Mon, 27 Nov 2023 12:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701088854;
	bh=mFCKdLu7hgFSzZlU35GDqQpUtEwbIPeo0aA8OfG/OPw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=weGFaxmed+deLIEa5XZKOW4yn8VKLnfzzdkR1+ohhDrJiC4GHE8qz4V4Inl+vu+qd
	 nvgVRzE37EnS4hRtAUIqYZERZfzkbNsDcNBdksT37I+PY/LVfGSfCRik10BlCbNZT3
	 Zc6JV1Ds2HIQsrowDy+aCHZWmb0Us7LgReQVwoJU=
Date: Mon, 27 Nov 2023 12:40:51 +0000
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com
Subject: Re: [PATCH 5.10 000/187] 5.10.202-rc3 review
Message-ID: <2023112745-spree-require-c3a6@gregkh>
References: <20231126154335.643804657@linuxfoundation.org>
 <76363981-1f2a-47c2-b1b1-ae039844e936@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <76363981-1f2a-47c2-b1b1-ae039844e936@roeck-us.net>

On Sun, Nov 26, 2023 at 10:23:24AM -0800, Guenter Roeck wrote:
> On 11/26/23 07:46, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.202 release.
> > There are 187 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Tue, 28 Nov 2023 15:43:06 +0000.
> > Anything received after that time might be too late.
> > 
> 
> For v5.10.201-188-g2f84e268b78b (5.10.202-rc3):
> 
> s390:defconfig, s390:allmodconfig, s390:debug_defconfig:
> 
> drivers/s390/crypto/ap_bus.c: In function 'ap_bus_force_rescan':
> drivers/s390/crypto/ap_bus.c:791:28: error: 'ap_scan_bus_count' undeclared
> 
> $ git grep ap_scan_bus_count
> drivers/s390/crypto/ap_bus.c:   if (atomic64_read(&ap_scan_bus_count) <= 0)
> $ git blame drivers/s390/crypto/ap_bus.c |& grep ap_scan_bus_count
> 467f51fb3ab6e (Harald Freudenberger 2023-10-23 09:57:10 +0200  791) 	if (atomic64_read(&ap_scan_bus_count) <= 0)
> 
> which is:
> 
> 467f51fb3ab6 s390/ap: fix AP bus crash on early config change callback invocation

Now dropped, thanks.

greg k-h
