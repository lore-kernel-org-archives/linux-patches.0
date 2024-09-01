Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DD5033987;
	Sun,  1 Sep 2024 09:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725183807; cv=none; b=t2R4+YdjsTR8UiqcttL1cYVbqSzmeTuU6uZonXk9cGQNMe8I9syC+mMavxntLPE2C4jJ5lvON/frrv0SsLR5+XNp02h3wO+A3LDpAarK/yrPd9fNw66tte8K1gvl47JwKfPUlH3qSQGjNQjOQeLHbGqPPm6F/j5ZTI4DKSSsDYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725183807; c=relaxed/simple;
	bh=ATV3v4eEGH1inz75dlAac4a5OY7uoxTwSMgdr+KFD44=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VswiI91AByLv72vAcuTxYJ/onijl+1YgfnHk9wUUr1oBtXA9srTIY7YDgsxykXJ0ed2ey0Xzsf6E9c3sf6ooOzrhkUlMJwOD6t8/IuxYBWgmkIAIV1xY0ALFYhIej8N+PxvWukjRPbFK+wLRcGAkIiDHfnoDNliDnmUSpTjn1E8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rnAMA3h9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rnAMA3h9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C56DC4CEC3;
	Sun,  1 Sep 2024 09:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725183807;
	bh=ATV3v4eEGH1inz75dlAac4a5OY7uoxTwSMgdr+KFD44=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rnAMA3h9Sa05nQxeMRvrOkeSs2Ui2mWgPuugmL1bnjWg368krM3+HvWGiaLwClKFQ
	 XGQNr7ltYNuVNHAkmNlDJ/jcbS9+4bOI1IX4262DRXnqlYS+6k51ix8AMaUFti/yqw
	 HDkT3AW8MvRPNyovfCj6Ap5XEJqUkZrV0SudZxkw=
Date: Sun, 1 Sep 2024 11:43:24 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.6 000/341] 6.6.48-rc1 review
Message-ID: <2024090118-wisdom-footman-ace8@gregkh>
References: <20240827143843.399359062@linuxfoundation.org>
 <4b332d8c-4ed0-4ecf-a4db-75c1aa932b48@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b332d8c-4ed0-4ecf-a4db-75c1aa932b48@roeck-us.net>

On Sat, Aug 31, 2024 at 02:26:28PM -0700, Guenter Roeck wrote:
> On 8/27/24 07:33, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.6.48 release.
> > There are 341 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 29 Aug 2024 14:37:36 +0000.
> > Anything received after that time might be too late.
> > 
> [ ... ]
> 
> > Suren Baghdasaryan <surenb@google.com>
> >      change alloc_pages name in dma_map_ops to avoid name conflicts
> > 
> 
> This patch triggers:
> 
> Building s390:defconfig ... failed
> --------------
> Error log:
> arch/s390/pci/pci_dma.c:724:10: error: 'const struct dma_map_ops' has no member named 'alloc_pages'; did you mean 'alloc_pages_op'?
>   724 |         .alloc_pages    = dma_common_alloc_pages,
> 
> for pretty much all s390 builds.
> 
> Source code analysis suggests that the problem also affects
> arch/ia64/hp/common/sba_iommu.c.a

Thanks, already handled.

greg k-h
