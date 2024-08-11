Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88FEA1BF24;
	Sun, 11 Aug 2024 10:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723370974; cv=none; b=c9GDw6OL/WKFK/OT4b5n1sq3zWWziiiZmBw087U6cHvAfJ0i6LPh/JshSp/flqHHVvhP2WjQzs1Z0g2ng0uwIo9ov0/BkxYAxtf5V3LQnOtLqZirc+9GDBXCbmHWi4DKxRD/PN9rDVMa2oA6B+LRyZqDtaBwQ9KWFaHG05dO63w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723370974; c=relaxed/simple;
	bh=ilC40Nmsw33MfZF3x6PHdMLsA4yI2N+MWvd+qYOYjmw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mqdj/aYGiGlTVSynfWiiGBu3FxZyizTMi+jEWw0bj7T9hqHhSb5rBSyRYApyLFDW/JkgdSYuo6p5yTrszEr2Z51vHhHwvh3nN4NqGDabumn+RAdfqq19/n3SvNTKsOQaJ9zY4wijgsmeXWeCVQA2b/AnjfSpulJJ8AqlcmDoERM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wStmPFug; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wStmPFug"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B648C32786;
	Sun, 11 Aug 2024 10:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723370974;
	bh=ilC40Nmsw33MfZF3x6PHdMLsA4yI2N+MWvd+qYOYjmw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=wStmPFugh/sWlFUMlLCwJJhxMrjyNj940Ibk9/4SjYIrzbTzeg7LKui14MWHKtX7Z
	 k9Rw1o7ff8k/t5K+VdbtCZ8GUM6v0twJt+XvKuZA68ObdOlxT8fMNwY3pC+nNCfqft
	 G24tw71mTt+DuPbfSgZutj3lBcSmpeOA3LvGyvUI=
Date: Sun, 11 Aug 2024 12:09:30 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Salvatore Bonaccorso <carnil@debian.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
	Akemi Yagi <toracat@elrepo.org>,
	Hardik Garg <hargar@linux.microsoft.com>
Subject: Re: [PATCH 6.1 00/86] 6.1.104-rc1 review
Message-ID: <2024081117-delusion-halved-9e9c@gregkh>
References: <20240807150039.247123516@linuxfoundation.org>
 <ZrPafx6KUuhZZsci@eldamar.lan>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZrPafx6KUuhZZsci@eldamar.lan>

On Wed, Aug 07, 2024 at 10:35:11PM +0200, Salvatore Bonaccorso wrote:
> Hi Greg,
> 
> On Wed, Aug 07, 2024 at 04:59:39PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.1.104 release.
> > There are 86 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 09 Aug 2024 15:00:24 +0000.
> > Anything received after that time might be too late.
> 
> 6.1.103 had the regression of bpftool not building, due to a missing
> backport:
> 
> https://lore.kernel.org/stable/v8lqgl$15bq$1@ciao.gmane.io/
> 
> The problem is that da5f8fd1f0d3 ("bpftool: Mount bpffs when pinmaps
> path not under the bpffs") was backported to 6.1.103 but there is no
> defintion of create_and_mount_bpffs_dir(). 
> 
> it was suggested to revert the commit completely.

Thanks for this, I'll fix it up after this release.

greg k-h
