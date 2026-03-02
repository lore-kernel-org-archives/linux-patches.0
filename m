Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6B682D97BB;
	Mon,  2 Mar 2026 13:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772459541; cv=none; b=ECIqgIcvAvu1HUwEJEx1cWOC59cbU6vzf2mGHPe5+dUUlheMGGYJsKgN1QSnIic2lrOPBGEHE0iHYklt7QYYNqlVavSBlHay1Ccb/pyqbXjg+I9s8HMuKlo/dpfEw+zgNwBhNE2xpPQeO3XkJ0QD9mEwY3J2sccv4Y2VTSISZLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772459541; c=relaxed/simple;
	bh=6gfMUTzTUSlChUd4RFMxjyxhJAdG8HDKJNuSWu1BIH4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hAy4l0jIg4ENjAhsuOqThz3055coHwCABPdeGx0twC5tqI/yBQGcy5mnWUorJLSm4OmiSe7CHjIL0GHumFPTTf16T1BBAzIX0i8LQo0Wm0rN5hNUB9ADLjAI6fA3TraZL33eGsTz58l04MY3/uoDbHcShFWCldxg3F5fOBDsKqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M3Eji0Q+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M3Eji0Q+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F78DC19423;
	Mon,  2 Mar 2026 13:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772459541;
	bh=6gfMUTzTUSlChUd4RFMxjyxhJAdG8HDKJNuSWu1BIH4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=M3Eji0Q+Ii1HMOWh/kkgUtteiPM8ZSXaqYtmiUBDALoLGm6rD0j4Qx/lu+9qyTTcq
	 GaF42WTHpLa4r2nDy/p2iS/2D8heUlCIuF3fyvYEr4cMjN1Mnya9NG46E3F/e+8+kq
	 ap/OEu36X0H8M42OK3PKHewd3L0nf3EJ2NxfrQUx9qmUqRWSSwz0Ol4vxlRuaugtAv
	 f/bv+70Mzqn1UsDFKtqCc5S88y4Qgapx6ZqLFxRs1nyDsfMggp/GQF4aBH/6/bKNyX
	 e9773XMHYHVUoNjKnysMDSVMW09AOQ9lg4USQksdMd3nECpijwu42cOX9UoWOVFUuW
	 gPLz4VEfC2DuQ==
Date: Mon, 2 Mar 2026 08:52:19 -0500
From: Sasha Levin <sashal@kernel.org>
To: "Barry K. Nathan" <barryn@pobox.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	gregkh@linuxfoundation.org, patches@lists.linux.dev,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@nabladev.com,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.12 000/385] 6.12.75-rc1 review
Message-ID: <aaWWE5uQqz_eG69i@laps>
References: <20260228180001.1567994-1-sashal@kernel.org>
 <41b35d0e-bd7e-4bcd-a22c-cd96ee6c43d8@pobox.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <41b35d0e-bd7e-4bcd-a22c-cd96ee6c43d8@pobox.com>

On Sun, Mar 01, 2026 at 10:05:02PM -0800, Barry K. Nathan wrote:
>On 2/28/26 10:00, Sasha Levin wrote:
>>This is the start of the stable review cycle for the 6.12.75 release.
>>There are 385 patches in this series, all will be posted as a response
>>to this one.  If anyone has any issues with these being applied, please
>>let me know.
>>
>>Responses should be made by Mon Mar  2 05:59:55 PM UTC 2026.
>>Anything received after that time might be too late.
>>
>>The whole patch series can be found in one patch at:
>>         https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-6.12.y&id2=v6.12.74
>>or in the git tree and branch at:
>>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
>>and the diffstat can be found below.
>>
>>Thanks,
>>Sasha
>
>I just now noticed a sizable discrepancy between what's in the
>stable-queue and what's in -rc1, for 5.10.y through 6.12.y. (6.18.y
>and 6.19.y appear unaffected.)
>
>To make sure this is an apples-to-apples comparison, I'll compare with
>the stable-queue as of commit 2370009958172f632d48973387e7b6ae116086b1
>("Drop a broken ACPI patch"); I'd expect the queue as of that commit to
>match the -rc1 patches, if I'm not mistaken.
>
>
>                      # of patches in         # of patches in
>                      stable mailing list     stable-queue git
>                      thread                  @ 237000995817
>
>5.10.252-rc1          147                     334
>5.15.202-rc1          164                     411
>6.1.165-rc1           232                     533
>6.6.128-rc1           283                     683
>6.12.75-rc1           385                     953
>6.18.16-rc1           752                     751
>6.19.6-rc1            844                     843
>
>The off-by-one difference for 6.18.y/6.19.y is expected, since
>(unlike the stable-queue itself) the -rc1 patch and the mailing
>list thread include a Makefile patch to update the version number.
>
>For the other kernels, though, it looks to me like something
>went wrong somewhere. Of course I could be mistaken, but that's
>how it appears to me.
>
>In any case, I figured I should bring this to your attention.

Barry, this is a great catch. Thank you!

The root cause turned out to be a bug in git-quiltimport. One of the
patches queued has the literal text "\0" in its subject line:

   selftests: tc_actions: don't dump 2MB of \0 to stdout

git-quiltimport constructs commit messages using echo(1):

   commit=$( { echo "$SUBJECT"; echo; cat "$tmp_msg"; } | git commit-tree $tree -p $commit)

The problem is that echo interprets backslash escape sequences, so
"\0" gets expanded into an actual NUL byte (0x00). git commit-tree
then rejects the commit with:

   error: a NUL byte in commit log message not allowed.

This caused git-quiltimport to bail out mid-way through building
several trees during -rc construction. The trees that had this patch
queued (5.10 through 6.12) only got a partial set of patches into
the -rc branch, while 6.18 and 6.19 were unaffected because they
hadn't hit the problematic patch yet.

6.18 and 6.19 were also previously released by Greg, who uses actual
quilt rather than git-quiltimport, so he wouldn't have run into this.

This also explains the bogus FAILED emails that went out for patches
that actually apply cleanly - since the patches never made it into the
-rc branch, my scripts concluded they had failed to apply.

I'll propose a fix for git to use printf '%s\n' instead of echo on
that line, which doesn't interpret escape sequences.

-- 
Thanks,
Sasha
