Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EF3223A7
	for <patches@lists.linux.dev>; Wed, 18 Jan 2023 06:08:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68FE7C433D2;
	Wed, 18 Jan 2023 06:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674022107;
	bh=wJKzVtiwlBDSkpF0tCKhmbESueBYIIC1ljEZoRcApd0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UQ16+kTHXljxWWrlz3cs8bXXZ6YbI+m3Uex9mKKd1yJV/xr2tYPhJ6ZGY8W1m5jeB
	 sr68AvpDIoQam4Wf0ZRHJ55sUrExyTU86RiaGLW7fP0HsV4+0espWmqNnwzvaM7div
	 rfzB5YZtd891k2SRyXuVgY1LzPFEeZ9uXb7yZ6UQ=
Date: Wed, 18 Jan 2023 07:08:22 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Wang Yugui <wangyugui@e16-tech.com>
Cc: hch@lst.de, stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/183] 6.1.7-rc1 review
Message-ID: <Y8eM1ln+uGaR5h72@kroah.com>
References: <20230117151136.CB79.409509F4@e16-tech.com>
 <Y8Znr6CAFi8ikhdH@kroah.com>
 <20230118101433.734D.409509F4@e16-tech.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230118101433.734D.409509F4@e16-tech.com>

On Wed, Jan 18, 2023 at 10:14:35AM +0800, Wang Yugui wrote:
> Hi,
> 
> > On Tue, Jan 17, 2023 at 03:11:37PM +0800, Wang Yugui wrote:
> > > Hi,
> > > 
> > > fstests(generic/034, xfs) panic when 6.1.7-rc1, but not panic when 6.1.6.
> > > 
> > > It seems patch *1 related.
> > > *1 Subject: blk-mq: move the srcu_struct used for quiescing to the tagset
> > > From: Christoph Hellwig <hch@lst.de>
> > > 
> > > This patch has been drop from 6.1.2-rc1. and it now added in 6.1.7-rc1 again.
> > > 
> > > the panic in 6.1.7-rc1 is almost same as that in 6.1.2-rc1.
> > 
> > Argh, yes, let me go drop these again.
> > 
> > Sasha, can you blacklist these from your tools so they don't get picked
> > up again?
> 
> this panic does not happen on  upstream 6.2.0-rc4.
> or maybe we need a bigger patch set?

We just need to stop attempting to backport these to 6.1 :)
