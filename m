Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B35884D9E0;
	Wed, 15 May 2024 07:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715759708; cv=none; b=EyTk77GKf25sI/ubpUwhkQz3oEOrBnPQmY6uHn4BWFa2E/VNmrieN5cKvf3nWqlnSJ+6G9YEkGan4cztpumV6lrf9Uz+zsRLQvTQ1nnqwG7VEHXbXLW+lAZ1XNDeMTU/ndH2jGE0wcsIwHfyE/Gur7gmT7FGCt3yGXXwxNc5N6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715759708; c=relaxed/simple;
	bh=UjJSeKkiJ6B2n4MFcDvDqQ9b3pUnSfpg0nvBsiXT9f4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ueuiTDxscywuFgdXhiEnjOTVOuGXAJsSKp8tc821KFgX4C6oxwlNMwPASVpj0jeJqEGg1HeAW9pgDOzNwK1P69Kb0Acf2BZXfGm/4doehn2XNWAzFs6H1W4rFL5VlgmBZAYueb9q8Ocy/1fRDkwg6WubpLPHMtLE19A5mFfLeyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yXhoC09w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yXhoC09w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A47C8C116B1;
	Wed, 15 May 2024 07:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715759708;
	bh=UjJSeKkiJ6B2n4MFcDvDqQ9b3pUnSfpg0nvBsiXT9f4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=yXhoC09wWCMu0z0EhcGr/f3e5LyIvQJxBoS982DJtYGH8H6QGprJhiSY20Db0wI3K
	 eT03k5hbhv0A+gE/TOA5OKPR0e/HGJwufx6loQNiNS8IG2LzfGp3j9Sf+1nynrnM7A
	 BMQU+KN9GolLaaN5bSEO3BDGjyf/OcFp7cVsf6ZM=
Date: Wed, 15 May 2024 09:55:05 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Martin Faltesek <mfaltesek@google.com>
Cc: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Darren Kenny <darren.kenny@oracle.com>
Subject: Re: [PATCH 5.15 000/168] 5.15.159-rc1 review
Message-ID: <2024051551-turret-distance-49d6@gregkh>
References: <20240514101006.678521560@linuxfoundation.org>
 <5beea8ed-b92b-4bee-b77b-4a3d57a5c001@oracle.com>
 <CAOiWkA8SNRbCPZ_gHQRczZovokZbFSJXQc1vUmtD0quZV9tp0Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOiWkA8SNRbCPZ_gHQRczZovokZbFSJXQc1vUmtD0quZV9tp0Q@mail.gmail.com>

On Tue, May 14, 2024 at 07:36:24PM -0500, Martin Faltesek wrote:
> Build failure on arm:
> 
> In file included from drivers/iommu/mtk_iommu_v1.c:22:
> drivers/iommu/mtk_iommu_v1.c:579:25: error: 'mtk_iommu_v1_of_ids'
> undeclared here (not in a function); did you mean 'mtk_iommu_of_ids'?
>   579 | MODULE_DEVICE_TABLE(of, mtk_iommu_v1_of_ids);
>       |                         ^~~~~~~~~~~~~~~~~~~
> ./include/linux/module.h:244:15: note: in definition of macro
> 'MODULE_DEVICE_TABLE'
>   244 | extern typeof(name) __mod_##type##__##name##_device_table
>          \
>       |               ^~~~
> ./include/linux/module.h:244:21: error:
> '__mod_of__mtk_iommu_v1_of_ids_device_table' aliased to undefined
> symbol 'mtk_iommu_v1_of_ids'
>   244 | extern typeof(name) __mod_##type##__##name##_device_table
>          \
>       |                     ^~~~~~
> drivers/iommu/mtk_iommu_v1.c:579:1: note: in expansion of macro
> 'MODULE_DEVICE_TABLE'
>   579 | MODULE_DEVICE_TABLE(of, mtk_iommu_v1_of_ids);
>       | ^~~~~~~~~~~~~~~~~~~
> make[2]: *** [scripts/Makefile.build:289: drivers/iommu/mtk_iommu_v1.o] Error 1
> make[1]: *** [scripts/Makefile.build:552: drivers/iommu] Error 2
> 
> This is from patch:
> 
> bce893a92324  krzk@kernel.org           2024-05-14  iommu: mtk: fix
> module autoloading
> 
> +MODULE_DEVICE_TABLE(of, mtk_iommu_v1_of_ids);
> 
> should be, I think:
> 
> +MODULE_DEVICE_TABLE(of, mtk_iommu_of_ids);
> 

Good catch, now fixed up.  I'll push out a -rc2 with this in it.

greg k-h
