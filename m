Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9C1D3FD12C;
	Mon,  2 Mar 2026 14:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772460622; cv=none; b=E5P7YqzJUTlSwHnxt8Jih+Q1icRmVA+KG8QroG+kPKaQj7Y0sdGazMlV1M42+kbmD9D84sTVX8Dz708CXKJ2o7fx3ZxAQwA87Jx6t70u69OAeHXLV4OPOcPVC1UDoqKAkrA2mjE4SWAKD0qjgTNldr9mb6YT5viEzgFwqpQk9sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772460622; c=relaxed/simple;
	bh=agTjp2LcqjbzxQoqMEdQOc+B/FIEf+v1kHZ4Y+6e8ZU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nUJhDyZEaBaoEmGxRmoWQCx0lXMHNvSEWNwlq9rCDzi/OwHwSeRH+ZoM+Op7uumRwpUTzx8HvJw0QrmxzjxKmxwP4ExZZoEciAxg1TcOubO2Q/ezkXqsrRQTfhEtAPE74itN7xvwd01dvxbVX2QlyWuzciocMGu7QnruoMlihgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VxZuvCQT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VxZuvCQT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 454BFC19423;
	Mon,  2 Mar 2026 14:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772460622;
	bh=agTjp2LcqjbzxQoqMEdQOc+B/FIEf+v1kHZ4Y+6e8ZU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VxZuvCQTMogBZWCdFnFSCYQUITCKpVKPznyHvEc3n9dEg4z1iKkxHlMG6aaLqPXz3
	 0nQeY5EM/BHBRnpTXeD4ynrm1zaLBby+WAartDUMqAIvahS8bIGiOkN9C5gher12hz
	 1gY9jGk1MSFnIVKvqJJVlDrb3JAXzZ3Qn0yyqhSQ=
Date: Mon, 2 Mar 2026 09:10:11 -0500
From: Greg KH <gregkh@linuxfoundation.org>
To: Sasha Levin <sashal@kernel.org>
Cc: "Barry K. Nathan" <barryn@pobox.com>, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org, patches@lists.linux.dev,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@nabladev.com,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.12 000/385] 6.12.75-rc1 review
Message-ID: <2026030203-detector-overlook-93cd@gregkh>
References: <20260228180001.1567994-1-sashal@kernel.org>
 <41b35d0e-bd7e-4bcd-a22c-cd96ee6c43d8@pobox.com>
 <aaWWE5uQqz_eG69i@laps>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aaWWE5uQqz_eG69i@laps>

On Mon, Mar 02, 2026 at 08:52:19AM -0500, Sasha Levin wrote:
> On Sun, Mar 01, 2026 at 10:05:02PM -0800, Barry K. Nathan wrote:
> > On 2/28/26 10:00, Sasha Levin wrote:
> > > This is the start of the stable review cycle for the 6.12.75 release.
> > > There are 385 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Mon Mar  2 05:59:55 PM UTC 2026.
> > > Anything received after that time might be too late.
> > > 
> > > The whole patch series can be found in one patch at:
> > >         https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-6.12.y&id2=v6.12.74
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> > > and the diffstat can be found below.
> > > 
> > > Thanks,
> > > Sasha
> > 
> > I just now noticed a sizable discrepancy between what's in the
> > stable-queue and what's in -rc1, for 5.10.y through 6.12.y. (6.18.y
> > and 6.19.y appear unaffected.)
> > 
> > To make sure this is an apples-to-apples comparison, I'll compare with
> > the stable-queue as of commit 2370009958172f632d48973387e7b6ae116086b1
> > ("Drop a broken ACPI patch"); I'd expect the queue as of that commit to
> > match the -rc1 patches, if I'm not mistaken.
> > 
> > 
> >                      # of patches in         # of patches in
> >                      stable mailing list     stable-queue git
> >                      thread                  @ 237000995817
> > 
> > 5.10.252-rc1          147                     334
> > 5.15.202-rc1          164                     411
> > 6.1.165-rc1           232                     533
> > 6.6.128-rc1           283                     683
> > 6.12.75-rc1           385                     953
> > 6.18.16-rc1           752                     751
> > 6.19.6-rc1            844                     843
> > 
> > The off-by-one difference for 6.18.y/6.19.y is expected, since
> > (unlike the stable-queue itself) the -rc1 patch and the mailing
> > list thread include a Makefile patch to update the version number.
> > 
> > For the other kernels, though, it looks to me like something
> > went wrong somewhere. Of course I could be mistaken, but that's
> > how it appears to me.
> > 
> > In any case, I figured I should bring this to your attention.
> 
> Barry, this is a great catch. Thank you!
> 
> The root cause turned out to be a bug in git-quiltimport. One of the
> patches queued has the literal text "\0" in its subject line:
> 
>   selftests: tc_actions: don't dump 2MB of \0 to stdout
> 
> git-quiltimport constructs commit messages using echo(1):
> 
>   commit=$( { echo "$SUBJECT"; echo; cat "$tmp_msg"; } | git commit-tree $tree -p $commit)
> 
> The problem is that echo interprets backslash escape sequences, so
> "\0" gets expanded into an actual NUL byte (0x00). git commit-tree
> then rejects the commit with:
> 
>   error: a NUL byte in commit log message not allowed.
> 
> This caused git-quiltimport to bail out mid-way through building
> several trees during -rc construction. The trees that had this patch
> queued (5.10 through 6.12) only got a partial set of patches into
> the -rc branch, while 6.18 and 6.19 were unaffected because they
> hadn't hit the problematic patch yet.
> 
> 6.18 and 6.19 were also previously released by Greg, who uses actual
> quilt rather than git-quiltimport, so he wouldn't have run into this.

But I use git-quiltimport when creating the releases, so did I somehow
not apply things properly when that happens, skipping patches in the
releaase?

thanks,

greg k-h
