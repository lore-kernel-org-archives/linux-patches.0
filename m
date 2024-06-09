Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EE46FC19;
	Sun,  9 Jun 2024 11:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717931734; cv=none; b=IcLwnS+88ilp3gqq7koi0rv6IlrW/Jb5PYcXRtCqAEMscJb7FiFtqyGAWDnXllyC/VtWRmKizQpKaFtGnulKNt6Zb4rqNli7WBvcf6p1jc0hSIq1OUTMr2ofv5tZDoWGv4cpIzAKDoua0uD64eHyLLT41sWPuRYps0U5bkfNdTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717931734; c=relaxed/simple;
	bh=Yiu87WmkzUAqtCTuLzJKesGbXeV39VIDNRIjxNSxJH8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZeM18grc/wRCzcDVKCwKw+2SSWbNt91TJ6O3aZKd+a8OHOZJFe+JUZ2Gv+2Nrr1hBclc4vs8es0YEPHqt3QnnhAUrXOvpG9fX7F7vWyn5riR24Q4BwwrCkABSwesNy7onbcar1E8xFjF9xwWLXy/fCdZmajpIksR2z5D/jlGilk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RQXFQSl/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RQXFQSl/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B93DC2BD10;
	Sun,  9 Jun 2024 11:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717931733;
	bh=Yiu87WmkzUAqtCTuLzJKesGbXeV39VIDNRIjxNSxJH8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RQXFQSl/5NGmzposFJDZv/4TqKC70uvqnhrXpTZS8lX3XzEgpAZJHF/WMS861Jqih
	 qWiLQG7VDOG+sn8Npw4N9A8YT/XuARwasFUMkyYaPrsf+1WcRo15X2n3V7kuKz5Bpl
	 p9CkY2La9JVA33u6hhh2wtd9krBoP6fw0vVdVAh8=
Date: Sun, 9 Jun 2024 13:15:30 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 000/473] 6.1.93-rc1 review
Message-ID: <2024060914-preview-sulphate-8097@gregkh>
References: <20240606131659.786180261@linuxfoundation.org>
 <CA+G9fYtMCm-iRDfhq-H5nENO=OyH+wN+HfwHUhandK0JKV_nnw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYtMCm-iRDfhq-H5nENO=OyH+wN+HfwHUhandK0JKV_nnw@mail.gmail.com>

On Thu, Jun 06, 2024 at 08:01:05PM +0530, Naresh Kamboju wrote:
> On Thu, 6 Jun 2024 at 19:42, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 6.1.93 release.
> > There are 473 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat, 08 Jun 2024 13:15:55 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.93-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> 
> The Powerpc build failures were noticed on stable-rc 6.9, 6.6 and 6.1.
> 
> Powerpc:
>  - maple_defconfig - gcc-13 - failed
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> arch/powerpc/include/asm/inst.h: In function '__copy_inst_from_kernel_nofault':
> arch/powerpc/include/asm/uaccess.h:177:19: error: expected string
> literal before 'DS_FORM_CONSTRAINT'
>   177 |                 : DS_FORM_CONSTRAINT (*addr)                    \
>       |                   ^~~~~~~~~~~~~~~~~~

Thanks, now fixed up for all branches.  I'll push out -rc2 releases soon
to verify.

greg k-h
