Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B57E123C6
	for <patches@lists.linux.dev>; Mon, 10 Jul 2023 05:43:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2B81C433C8;
	Mon, 10 Jul 2023 05:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688967834;
	bh=+80BagJxUJyQJ3IMWMojMWDAgzi0xlAYAibhFrk/X9A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Z5/oMyt4b5wjIz5uqrUGDb+tesqrwL8xoViSIwXapcNAwEvzd6vWrCSaKoxWHvUni
	 gR6hZwVXqM6437xyqprAnfhVKcV2TW3b6TVp8O1nQKbYxxSVFpLfrWy4XQxpu4A5XM
	 ZHTFp6K0I/jW9/FR9q8M1piqkPZWw9rNp3TW5NCk=
Date: Mon, 10 Jul 2023 07:43:51 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org
Subject: Re: [PATCH 6.3 000/425] 6.3.13-rc2 review
Message-ID: <2023071039-puppet-wieldable-6db2@gregkh>
References: <20230709202353.266998088@linuxfoundation.org>
 <CAEUSe7_KV_+jLJzE4u4_DHUPbi8Z=ASh-=aKB_JQr4+pz_8GVw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEUSe7_KV_+jLJzE4u4_DHUPbi8Z=ASh-=aKB_JQr4+pz_8GVw@mail.gmail.com>

On Sun, Jul 09, 2023 at 04:55:55PM -0600, Daniel Díaz wrote:
> Hello!
> 
> On Sun, 9 Jul 2023 at 14:24, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > This is the start of the stable review cycle for the 6.3.13 release.
> > There are 425 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Tue, 11 Jul 2023 20:22:29 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.3.13-rc2.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.3.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> This introduces a warning:
> -----8<-----
>   In file included from /builds/linux/block/genhd.c:28:
>   /builds/linux/block/genhd.c: In function 'disk_release':
>   /builds/linux/include/linux/blktrace_api.h:88:33: warning: statement
> with no effect [-Wunused-value]
>    # define blk_trace_remove(q)    (-ENOTTY)
>                                    ^
>   /builds/linux/block/genhd.c:1187:2: note: in expansion of macro
> 'blk_trace_remove'
>     blk_trace_remove(disk->queue);
>     ^~~~~~~~~~~~~~~~
> ----->8-----
> 
> This is again with Arm 32-bits on omap1_defconfig.
> 
> Bisection points to "block: fix blktrace debugfs entries leakage"
> (d8c9d0067dbd here, dd7de3704af9 upstream). Reverting this commit
> makes the warning go away.

Thanks, I've queued up a fix for this and will push out a -rc3.

greg k-h
