Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EFC21CEE8B;
	Wed,  4 Sep 2024 09:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725442689; cv=none; b=EBOk6qnHrjBLDyPvCfe8Blu4+KA9ykYKuwJOtLKq0caKMQVD42hOylu446zDGuMJzXJFPxuYBAruvjhTEEwcfJpqkHfFglW2UMns4UTC5PXlnc9ell63A8+s19FJy129vd34JJJsYkAjeef89BM6T2u92b3rfEoEzsmGuUM1O5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725442689; c=relaxed/simple;
	bh=IKirc6HevZIvUKJ+85aPDDWvupVvCnVxgat3yoXt4Mc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V6YoCiPPG/rFI7EaQAkrEG4QsGoLooW+v5hg/PXmRUwVYJdJNZ8DaoE/vnfI8Ak8IpnsELDKmjvXkfoVW4bsg8+bDetyVoVvPS1QtbvpHCTl4Md6nRIIqA9IngP9FsXsY7245Va0Qotxf0Qd6Gl5pc6Tp+evAoBpYIO2tiZKP+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GSabC1xj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GSabC1xj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D0C3C4CEC2;
	Wed,  4 Sep 2024 09:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725442688;
	bh=IKirc6HevZIvUKJ+85aPDDWvupVvCnVxgat3yoXt4Mc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GSabC1xjeQi546QZ83/KA3NhitTdMJaFd0r4H7JYFMe6oaDFZUale8NPYaPwS6r7J
	 D7u9fCkaaDm/hZCaqFNv/+04TLGOHh47s1mYMFILeDLJcO11ATut+dyOa3miU9mbvz
	 15Ig8bZL2cr8drjJkcOGBGXoCY4TRXhQvwmEoKD4=
Date: Wed, 4 Sep 2024 11:38:05 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
	Anders Roxell <anders.roxell@linaro.org>,
	aleksander.lobakin@intel.com,
	"David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 4.19 00/98] 4.19.321-rc1 review
Message-ID: <2024090449-reselect-charter-575b@gregkh>
References: <20240901160803.673617007@linuxfoundation.org>
 <CA+G9fYscUiPT0Eo9yo4UhJq2jjYtvLhOofQKhAMEOiVueR-Vaw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYscUiPT0Eo9yo4UhJq2jjYtvLhOofQKhAMEOiVueR-Vaw@mail.gmail.com>

On Mon, Sep 02, 2024 at 02:30:57PM +0530, Naresh Kamboju wrote:
> On Sun, 1 Sept 2024 at 21:50, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 4.19.321 release.
> > There are 98 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Tue, 03 Sep 2024 16:07:34 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.321-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Apart from Powerpc build regressions we have noticed s390 build regression.
> The S390 defconfig builds failed on Linux stable-rc 4.19.321-rc1 due to
> following build warnings / errors with clang-18 and gcc-12.
> 
> This is a same problem on current stable-rc review on
>    - 4.19.321-rc1 review
> 
> In the case of stable-rc linux-4.19.y
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> Following two commits have been added on 4.19.321-rc1.
> -------
>   s390/cio: rename bitmap_size() -> idset_bitmap_size()
>   commit c1023f5634b9bfcbfff0dc200245309e3cde9b54 upstream.
> 
>   bitmap: introduce generic optimized bitmap_size()
>   commit a37fbe666c016fd89e4460d0ebfcea05baba46dc upstream.

Odd, this should have also shown up in your 5.4.y builds too.

I'll go drop this from both trees now, thanks.

greg k-h
