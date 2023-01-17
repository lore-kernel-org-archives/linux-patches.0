Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B66401FC2
	for <patches@lists.linux.dev>; Tue, 17 Jan 2023 10:15:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13B94C433D2;
	Tue, 17 Jan 2023 10:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673950558;
	bh=sPvnnxQs7gz++ohDYQSkOddbBDV23XwrHutOGT4x8WM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jJry6yWyC9moc9pRdKmhkZz8bbWbgQQQ9M622DocpHPQ/xH73Vho24VwCpfP53+UB
	 aEnVhCnJrbEe5KDNn2ffYPEthkryuyKt+IS3vb0Ss84C52hwR6etktVp9cD7jxsd9r
	 84AdoZDKx5cqvlYhwIolm4tDu5EIZTo7N6h1VeFo=
Date: Tue, 17 Jan 2023 10:17:35 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Wang Yugui <wangyugui@e16-tech.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/183] 6.1.7-rc1 review
Message-ID: <Y8Znr6CAFi8ikhdH@kroah.com>
References: <20230116154803.321528435@linuxfoundation.org>
 <20230117151136.CB79.409509F4@e16-tech.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230117151136.CB79.409509F4@e16-tech.com>

On Tue, Jan 17, 2023 at 03:11:37PM +0800, Wang Yugui wrote:
> Hi,
> 
> fstests(generic/034, xfs) panic when 6.1.7-rc1, but not panic when 6.1.6.
> 
> It seems patch *1 related.
> *1 Subject: blk-mq: move the srcu_struct used for quiescing to the tagset
> From: Christoph Hellwig <hch@lst.de>
> 
> This patch has been drop from 6.1.2-rc1. and it now added in 6.1.7-rc1 again.
> 
> the panic in 6.1.7-rc1 is almost same as that in 6.1.2-rc1.

Argh, yes, let me go drop these again.

Sasha, can you blacklist these from your tools so they don't get picked
up again?

thanks,

greg k-h
