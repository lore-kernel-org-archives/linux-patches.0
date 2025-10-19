Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A976366;
	Sun, 19 Oct 2025 12:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760875355; cv=none; b=m05KfdJ7yITNt9K9uOw8wk7OVQSOGwdkZ0DdkiJ7OEFn7zPMp5T5aYAv6xBkGQVqDlyY4ZVjcyXJ4FM3pxrAqt52ZdO+q3BRKA91+bir/WSRJXDzBnH8hc+HcyJim/SOp35cffj5kFEumeXJF1l09w/CTJbth86wX6XkVHqmBf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760875355; c=relaxed/simple;
	bh=0IuCpk9UxBeR+C9BHxVRSSL+EJ0KV/W4DsG0DkKDkSI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WriEqZCKD1T6ZlN9IAzs0PkhPM72HmuZQQsI/i1j1AjnWp7ndBy9gOLTuJ+ZAM7gGaNesqQ7iYFg7OKbzMft2e/aSXt43ib7nHpLTVSlV6Trj7oDxGQRcLs+Qf3ZZrib4WFk95WFV7iwNZjCOytoPzmaizcQIynNOBLK9rSgYdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=di5lqBUV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="di5lqBUV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85973C4CEE7;
	Sun, 19 Oct 2025 12:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760875355;
	bh=0IuCpk9UxBeR+C9BHxVRSSL+EJ0KV/W4DsG0DkKDkSI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=di5lqBUVapMsNjAmHde4l/1zbpAPQ0Y9jbgnJMb6MfVVfsqnWGxpkLuvxF7ykFsJS
	 YEK7RZM8EkxwYS75qQlM4pp3yfQzz4zvsUBgT8eeGEh0ynbVS8miL9U9AEfjcBNcWN
	 UM6MeUxrWgPLxACiTW6GzYlGxlWEegXzaBKrnW0o=
Date: Sun, 19 Oct 2025 14:02:32 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ron Economos <re@w6rz.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org
Subject: Re: [PATCH 6.17 000/371] 6.17.4-rc1 review
Message-ID: <2025101933-utensil-campfire-75f8@gregkh>
References: <20251017145201.780251198@linuxfoundation.org>
 <90bc04ea-e7ec-49b9-ae6e-d0e2c85bbf96@w6rz.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <90bc04ea-e7ec-49b9-ae6e-d0e2c85bbf96@w6rz.net>

On Fri, Oct 17, 2025 at 04:04:23PM -0700, Ron Economos wrote:
> On 10/17/25 07:49, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.17.4 release.
> > There are 371 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 19 Oct 2025 14:50:59 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.4-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.17.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Build fails for RISC-V with:
> 
> In file included from ./include/linux/pgtable.h:6,
>                  from ./include/linux/mm.h:31,
>                  from arch/riscv/kernel/asm-offsets.c:8:
> ./arch/riscv/include/asm/pgtable.h:963:21: error: redefinition of
> 'pudp_huge_get_and_clear'
>   963 | static inline pud_t pudp_huge_get_and_clear(struct mm_struct *mm,
>       |                     ^~~~~~~~~~~~~~~~~~~~~~~
> ./arch/riscv/include/asm/pgtable.h:946:21: note: previous definition of
> 'pudp_huge_get_and_clear' with type 'pud_t(struct mm_struct *, long unsigned
> int,  pud_t *)'
>   946 | static inline pud_t pudp_huge_get_and_clear(struct mm_struct *mm,
>       |                     ^~~~~~~~~~~~~~~~~~~~~~~
> 
> Reverting 06536c4857271eeb19d76dbb4af989e2654a94e0 riscv: use an atomic xchg
> in pudp_huge_get_and_clear() fixes the build.
> 
> The problem is that this patch was already applied to 6.17 just before
> release, so the function pudp_huge_get_and_clear() ends up being duplicated
> in the file.

Thanks, I'll go drop this patch now, thanks.

greg k-h
