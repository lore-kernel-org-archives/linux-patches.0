Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF715182AC
	for <patches@lists.linux.dev>; Tue, 10 Oct 2023 11:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HIjQ7dja"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 948EEC43391;
	Tue, 10 Oct 2023 11:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696937304;
	bh=5bnGt4lMhl5rzH037xz8U29xurwNmAHMeyXzFtlqGPU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HIjQ7djaafy0PD7j8vLxL1+4GcUyCtzJy21G6IEhsnaf2XJna1TE84W0Q5ZjkDb5H
	 4GOq2Y2P9fEXHlIEuhYQNKmF8mL/zVUcoM3V/gUBkk1kEJ7e3X4HUaQzMjoDh4KDFX
	 xvKqAA5vc/Ei/ZoIYFdTqKPA/GJLSB2H5A4OTauc=
Date: Tue, 10 Oct 2023 13:28:21 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Wang Yugui <wangyugui@e16-tech.com>
Cc: wqu@suse.com, stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org
Subject: Re: [PATCH 6.1 000/162] 6.1.57-rc1 review
Message-ID: <2023101008-argue-impart-a6ad@gregkh>
References: <20231009130122.946357448@linuxfoundation.org>
 <20231010161046.7861.409509F4@e16-tech.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231010161046.7861.409509F4@e16-tech.com>

On Tue, Oct 10, 2023 at 04:10:48PM +0800, Wang Yugui wrote:
> Hi,
> 
> > This is the start of the stable review cycle for the 6.1.57 release.
> > There are 162 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 11 Oct 2023 13:00:55 +0000.
> > Anything received after that time might be too late.
> 
> 
> drop this patch from 6.5/6.1/5.15/... please, 
>   Qu Wenruo <wqu@suse.com>
>      btrfs: reject unknown mount options early
> 
> becuase of this report.
> https://lore.kernel.org/linux-btrfs/f3ac7b74-c011-4d1f-a510-677679fc9743@gmx.com/T/#t

Is there a revert somewhere for this already?

thanks,

greg k-h
