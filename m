Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F5BD1FAC
	for <patches@lists.linux.dev>; Thu, 26 Jan 2023 08:59:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44C5DC433EF;
	Thu, 26 Jan 2023 08:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674723586;
	bh=v3w9KN+/EXtKdKP/cxgLT2pEpAH9qvQ39rctUq6PiHE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rcvt4K9mWAV5Q9aukHLQmKR+aRBP48i+zvD+s/B4VxsdKtfShdcyjlWuPZpn9VisU
	 vcejLxN3z09cSJ6rF8QRf/oWIcXoWPH3uy/ZZ1t/7dQbNmYGns14yYG1qYZQKo/+D/
	 tDWorCu5WpKeUk+oo09ikve4sACZumUo2UkM8cf8=
Date: Thu, 26 Jan 2023 09:59:44 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.19 00/37] 4.19.271-rc1 review
Message-ID: <Y9JBAPjj1+aj++Ro@kroah.com>
References: <20230122150219.557984692@linuxfoundation.org>
 <20230124024734.GB1495310@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230124024734.GB1495310@roeck-us.net>

On Mon, Jan 23, 2023 at 06:47:34PM -0800, Guenter Roeck wrote:
> On Sun, Jan 22, 2023 at 04:03:57PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.19.271 release.
> > There are 37 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Tue, 24 Jan 2023 15:02:08 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 155 pass: 154 fail: 1
> Failed builds:
> 	i386:tools/perf
> Qemu test results:
> 	total: 426 pass: 426 fail: 0
> 
> perf build failure:
> 
> util/env.c: In function ‘perf_env__arch’:
> cc1: error: function may return address of local variable [-Werror=return-local-addr]
> util/env.c:166:17: note: declared here
>   166 |  struct utsname uts;
>       |                 ^~~
> 
> No one to blame but me, for switching the gcc version used to build perf
> to gcc 10.3.0 (from 9.4.0). The problem is fixed in the upstream kernel
> with commit ebcb9464a2ae3 ("perf env: Do not return pointers to local
> variables"). This patch applies to v5.4.y and earlier kernels.

It's already in the 5.4.y tree (in release 5.4.56), and it applies to
4.19.y so I'll add it there, but it does not apply to 4.14.y so I would
need a working backport for that tree if you want it there.

thanks,

greg k-h
