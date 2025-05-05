Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E38701A070E;
	Mon,  5 May 2025 08:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746435451; cv=none; b=cwMdk7vCMV9Bn+oUSX61HL2/9iwoNL8Axlwc3tdU++INp1twe/bq+fRKLv33oAt/UL8ov0Jn5t2QC0VM3msdGdnQdHpnkHSOzz1aGTvsMbMi3Hv1G/PZo+6q80o83U0jUq13UGOToFVkXPJbRNkeKs8272XXPKomrlpdNdG4Q4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746435451; c=relaxed/simple;
	bh=6WIH3XHB+pL3rFSA2uS3Jl2jkkuHGqHfHT10q9nvXGA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c+eyHXpNH1CwDrTdczoOzf86p5Z9kJAUU2rzK4OLsCZ9QvBtsxMhjq330hKjLQoDQ9J8dFnrvVh1uzG2aMK+BRFXu8CLG+b/jkRLa3mfi2PTBF59tqn55uCy50Db5ml7xYCS8/QoSWHFhlyqumNsQAk9n3J5In5OqaPZhqwGY1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P9vkNEae; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P9vkNEae"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5B68C4CEE4;
	Mon,  5 May 2025 08:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746435450;
	bh=6WIH3XHB+pL3rFSA2uS3Jl2jkkuHGqHfHT10q9nvXGA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=P9vkNEaeBVekcY93FtS4cXpq8DLpfU2LlqG4wiAkmgNIk64SchhNrohhvr6p6pjaN
	 tpzfCBEv/OHw46BF7QWwJLMxBb1QbhlBKYLqotLqmwT3EnlEEZO9jqiAm9dnMDUX23
	 zPzET5ovaBBUSWDtu4meFHvQq6ee1RcXn06pcOzM=
Date: Mon, 5 May 2025 10:57:27 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 000/157] 6.1.136-rc2 review
Message-ID: <2025050510-headlamp-omega-56bd@gregkh>
References: <20250501080849.930068482@linuxfoundation.org>
 <f978ec9a-b103-40af-b116-6a9238197110@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f978ec9a-b103-40af-b116-6a9238197110@roeck-us.net>

On Sat, May 03, 2025 at 06:03:53AM -0700, Guenter Roeck wrote:
> On 5/1/25 01:14, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.1.136 release.
> > There are 157 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 03 May 2025 08:08:16 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Building loongarch:defconfig ... failed
> --------------
> Error log:
> arch/loongarch/mm/hugetlbpage.c: In function 'huge_pte_offset':
> arch/loongarch/mm/hugetlbpage.c:50:25: error: implicit declaration of function 'pmdp_get'; did you mean 'ptep_get'? [-Werror=implicit-function-declaration]
>    50 |         return pmd_none(pmdp_get(pmd)) ? NULL : (pte_t *) pmd;
>       |                         ^~~~~~~~
>       |                         ptep_get
> arch/loongarch/mm/hugetlbpage.c:50:25: error: incompatible type for argument 1 of 'pmd_none'
>    50 |         return pmd_none(pmdp_get(pmd)) ? NULL : (pte_t *) pmd;
>       |                         ^~~~~~~~~~~~~
>       |                         |
>       |                         int
> In file included from arch/loongarch/include/asm/uaccess.h:17,
>                  from include/linux/uaccess.h:11,
>                  from include/linux/sched/task.h:11,
>                  from include/linux/sched/signal.h:9,
>                  from include/linux/rcuwait.h:6,
>                  from include/linux/percpu-rwsem.h:7,
>                  from include/linux/fs.h:33,
>                  from arch/loongarch/mm/hugetlbpage.c:6:
> arch/loongarch/include/asm/pgtable.h:198:34: note: expected 'pmd_t' but argument is of type 'int'
>   198 | static inline int pmd_none(pmd_t pmd)
>       |                            ~~~~~~^~~
> arch/loongarch/mm/hugetlbpage.c:51:1: error: control reaches end of non-void function [-Werror=return-type]

Thanks, a fix has now been posted, let me do a release with it now...

greg k-h
