Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8399BB65C;
	Sat, 25 Nov 2023 15:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r8U/vD7V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 872B6C433C7;
	Sat, 25 Nov 2023 15:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700927598;
	bh=al+G0rriiHu1mo6bmsIUbIhr6a/3qzbcnyBNXYRyZC8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=r8U/vD7VrZxIR+HnhzkI56te2jE8QiD3+9kFourtDRrbOYMt3tfmI8cAASWmC8PhY
	 eN+Kg9NYTNeToCoW3i7/S/gmJhlDU0FozTS0GwlTABfgz0UvA58x98HIxPhAMsWnjy
	 R7oSlqzppmywGFGMSgCIufjIfbVXW6R+rANBxhAE=
Date: Sat, 25 Nov 2023 15:53:15 +0000
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, jack@suse.cz, chrubis@suse.cz
Subject: Re: [PATCH 5.15 000/297] 5.15.140-rc1 review
Message-ID: <2023112502-supernova-copier-7615@gregkh>
References: <20231124172000.087816911@linuxfoundation.org>
 <81a11ebe-ea47-4e21-b5eb-536b1a723168@linaro.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <81a11ebe-ea47-4e21-b5eb-536b1a723168@linaro.org>

On Fri, Nov 24, 2023 at 11:45:09PM -0600, Daniel Díaz wrote:
> Hello!
> 
> On 24/11/23 11:50 a. m., Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.140 release.
> > There are 297 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 26 Nov 2023 17:19:17 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.140-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> We are noticing a regression with ltp-syscalls' preadv03:
> 
> -----8<-----
>   preadv03 preadv03
>   preadv03_64 preadv03_64
>   preadv03.c:102: TINFO: Using block size 512
>   preadv03.c:87: TPASS: preadv(O_DIRECT) read 512 bytes successfully with content 'a' expectedly
>   preadv03.c:87: TPASS: preadv(O_DIRECT) read 512 bytes successfully with content 'a' expectedly
>   preadv03.c:87: TPASS: preadv(O_DIRECT) read 512 bytes successfully with content 'b' expectedly
>   preadv03.c:102: TINFO: Using block size 512
>   preadv03.c:77: TFAIL: Buffer wrong at 0 have 62 expected 61
>   preadv03.c:77: TFAIL: Buffer wrong at 0 have 62 expected 61
>   preadv03.c:66: TFAIL: preadv(O_DIRECT) read 0 bytes, expected 512
>   preadv03.c:102: TINFO: Using block size 512
>   preadv03.c:77: TFAIL: Buffer wrong at 0 have 62 expected 61
>   preadv03.c:77: TFAIL: Buffer wrong at 0 have 62 expected 61
>   preadv03.c:66: TFAIL: preadv(O_DIRECT) read 0 bytes, expected 512
>   preadv03.c:102: TINFO: Using block size 512
>   preadv03.c:87: TPASS: preadv(O_DIRECT) read 512 bytes successfully with content 'a' expectedly
>   preadv03.c:87: TPASS: preadv(O_DIRECT) read 512 bytes successfully with content 'a' expectedly
>   preadv03.c:87: TPASS: preadv(O_DIRECT) read 512 bytes successfully with content 'b' expectedly
>   preadv03.c:102: TINFO: Using block size 512
>   preadv03.c:77: TFAIL: Buffer wrong at 0 have 62 expected 61
>   preadv03.c:77: TFAIL: Buffer wrong at 0 have 62 expected 61
>   preadv03.c:66: TFAIL: preadv(O_DIRECT) read 0 bytes, expected 512
>   preadv03.c:102: TINFO: Using block size 512
>   preadv03.c:77: TFAIL: Buffer wrong at 0 have 62 expected 61
>   preadv03.c:77: TFAIL: Buffer wrong at 0 have 62 expected 61
>   preadv03.c:66: TFAIL: preadv(O_DIRECT) read 0 bytes, expected 512
> ----->8-----
> 
> This is seen in the following environments:
> * dragonboard-845c
> * juno-64k_page_size
> * qemu-arm64
> * qemu-armv7
> * qemu-i386
> * qemu-x86_64
> * x86_64-clang
> 
> and on the following RC's:
> * v5.10.202-rc1
> * v5.15.140-rc1
> * v6.1.64-rc1
> 
> (Note that the list might not be complete, because some branches failed to execute completely due to build issues reported elsewhere.)
> 
> Bisection in linux-5.15.y pointed to:
> 
>   commit db85c7fff122c14bc5755e47b51fbfafae660235
>   Author: Jan Kara <jack@suse.cz>
>   Date:   Fri Oct 13 14:13:50 2023 +0200
> 
>       ext4: properly sync file size update after O_SYNC direct IO
>       commit 91562895f8030cb9a0470b1db49de79346a69f91 upstream.
> 
> 
> Reverting that commit made the test pass.

Odd.  I'll go drop that from 5.10.y and 5.15.y now, thanks.

greg k-h
