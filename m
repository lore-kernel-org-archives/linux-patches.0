Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 271D01FB8
	for <patches@lists.linux.dev>; Tue, 21 Mar 2023 07:46:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AD78C433EF;
	Tue, 21 Mar 2023 07:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679384768;
	bh=rEcVB7T14gHFsfgbwm2lqLV7XcRfpAg8FXysH4WV4/w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qyURn68Jgg4qoJtgc77j6rZNRmDUyJ6OWrGz9Q9r0zxhrx9LV06vVbDRJ8Y+yBFyx
	 4T40VU2XusgWd1/7S4YimS6xOwI/6DNz+VcoFv/crlHCCKgTKGVz2iaeX/qUj2JEw0
	 f0w2gwkDWjBWNFRyRN7SHGB7kMOSwd53KX/VO1sI=
Date: Tue, 21 Mar 2023 08:46:06 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Wang Yugui <wangyugui@e16-tech.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/198] 6.1.21-rc1 review
Message-ID: <ZBlgvqscqTJLiCE4@kroah.com>
References: <20230320145507.420176832@linuxfoundation.org>
 <20230321074819.2A17.409509F4@e16-tech.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230321074819.2A17.409509F4@e16-tech.com>

On Tue, Mar 21, 2023 at 07:48:20AM +0800, Wang Yugui wrote:
> Hi,
> 
> 
> > This is the start of the stable review cycle for the 6.1.21 release.
> > There are 198 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 22 Mar 2023 14:54:29 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.21-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> > and the diffstat can be found below.
> 
> fstests btrfs/056 triggered a panic for 6.1.21-rc1, but the panic does not
> happen on 6.1.20.
> 
> the patch *1 dropped in 6.1.9-rc is added to 6.1.21-rc1 again.
> *1 Subject: blk-mq: move the srcu_struct used for quiescing to the tagset
> 
> we need to drop it again, or need more patches.

Wow, I think this holds the record for the "patch that keeps getting
applied" :(

Sasha, can you add this one to your "never apply it" list for 6.1.y?

thanks,

greg k-h
