Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A587611CA0
	for <patches@lists.linux.dev>; Mon, 20 Nov 2023 10:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DxR8Zzs2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71E03C433C7;
	Mon, 20 Nov 2023 10:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700474751;
	bh=K0YC+nZZ5T4BKyoKuBlC5dhluF5RVj5i/m8wcUN0dvg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DxR8Zzs2yF8PJLGSysIVrFRKKma31+eFAvg+b4WjExSrL3JeAO8BUhsINck39DSWe
	 XvwDW6MdrSqkgkMnXRVCzByOw4elPbIOD/TBhgf4iN9Zuk/bbMu0fycANKcdQs3KQm
	 VQs9RtXnZMdt3g0x3NjpxQBmjqKK8blucdfLkIUY=
Date: Mon, 20 Nov 2023 11:05:48 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 5.10 000/191] 5.10.201-rc1 review
Message-ID: <2023112039-reverse-careless-e646@gregkh>
References: <20231115204644.490636297@linuxfoundation.org>
 <b5367845-8d70-4fcf-861a-ff9b8849c9c9@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b5367845-8d70-4fcf-861a-ff9b8849c9c9@roeck-us.net>

On Thu, Nov 16, 2023 at 05:13:39PM -0800, Guenter Roeck wrote:
> On 11/15/23 12:44, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.201 release.
> > There are 191 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 17 Nov 2023 20:46:03 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 159 pass: 155 fail: 4
> Failed builds:
> 	arm:allmodconfig
> 	arm64:allmodconfig
> 	i386:tools/perf
> 	x86_64:tools/perf
> Qemu test results:
> 	total: 495 pass: 495 fail: 0
> 
> with:
> 
> Building arm64:allmodconfig ... failed
> --------------
> Error log:
> drivers/interconnect/qcom/osm-l3.c:6:10: fatal error: linux/args.h: No such file or directory
> 
> There is no linux/args.h in v5.10.y.
> 
> Caused by "interconnect: qcom: osm-l3: Replace custom implementation of COUNT_ARGS()".

Now dropped, thanks.

greg k-h
