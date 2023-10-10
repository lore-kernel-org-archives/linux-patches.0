Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35A5F27470
	for <patches@lists.linux.dev>; Tue, 10 Oct 2023 16:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NvSVceR7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35719C433C7;
	Tue, 10 Oct 2023 16:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696954518;
	bh=E6kRIQQhwOKGKVKTczVQPqNC4o7DfYIF2l61fia6LCs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NvSVceR7UXVU4u//6GoXudNeDUmoI7tVvtX5f2PWTvt8n6sLXLt/CxA1C7W940yoP
	 WzH0uIufndvCP7AWRIeGTa1xH1mTIkCbAulOpJRHfkaVyx5T8J7yMZyCJb5O2bM5BN
	 QyY2Gr4+4ECMfLqDcSizPJNHxqhw04j6ofe0NJpE=
Date: Tue, 10 Oct 2023 18:15:16 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pavel Machek <pavel@denx.de>
Cc: sweettea-kernel@dorminy.me, dsterba@suse.com, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: unneeded btrfs changes -- Re: [PATCH 6.1 000/162] 6.1.57-rc1
 review
Message-ID: <2023101053-angles-audacity-a284@gregkh>
References: <20231009130122.946357448@linuxfoundation.org>
 <ZSUerjykMViykoYZ@duo.ucw.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZSUerjykMViykoYZ@duo.ucw.cz>

On Tue, Oct 10, 2023 at 11:51:42AM +0200, Pavel Machek wrote:
> Hi!
> On Mon 2023-10-09 14:59:41, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.1.57 release.
> > There are 162 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 11 Oct 2023 13:00:55 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.57-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> > and the diffstat can be found below.
> > 
> 
> > Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> >     btrfs: use struct fscrypt_str instead of struct qstr
> > 
> > Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> >     btrfs: setup qstr from dentrys using fscrypt helper
> > 
> > Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> >     btrfs: use struct qstr instead of name and namelen pairs
> 
> These are rather intrusive, and marked with
> 
> Stable-dep-of: 9af86694fd5d ("btrfs: file_remove_privs needs an exclusive lock in direct io write")
> 
> but we don't have that one in 6.1, so we should not have these,
> either.

Ah, seems we forgot that dep patch, so that's now added which makes more
sense why the prep patches were added.

thanks,

greg k-h
