Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57F1F215187;
	Thu,  9 Jan 2025 10:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736418859; cv=none; b=cWcZBv5sDTK1RPh7HPp/7T3hU01WqnK4BEIY0skyxNxwYng6QXD6sO36PlcPaU4oFozMLY8DtTfOV6G1yE/vBjr/b87VE5Bfifye3PDeT39Ybz2Y7C9aImfqvtLMy8HQI7WUHhVdv0/Ie+781YswREbeQjB1o2Pb4xkwjyfDoMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736418859; c=relaxed/simple;
	bh=yNEZBdIeiIXwz/6eGWGR51In1FWa4FVb8uWKuXPUw94=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C7UuzfiURD5+McKo9kkNfHdMvIf7nzSEHwZAxLjYD67BKY6rV4bS+aYiDKkvYis17eTca/OJu8GL3C8dl5m0q00j94Cze3v2XFFRLzuAEY7/4lesQbA6vglaaiNbjM7xnJyyHgAFrx2iSmv6jMtsRyIlo5/Y+3/w23urzN7bnAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XXHFmcLf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XXHFmcLf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BC6EC4CED2;
	Thu,  9 Jan 2025 10:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736418858;
	bh=yNEZBdIeiIXwz/6eGWGR51In1FWa4FVb8uWKuXPUw94=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XXHFmcLfRlpHv+ySxHyoxPzPGK54DZ3qgjNZjzfR6mn9PAStmYQAY7IpWARHeGr2T
	 GNzdE2Jqi5p9s1K6E/9T6f8XPjqh2HQxEUHMflDrfzriCvbjgkRhFpJTWQ2EoxcJSP
	 Aaa6u9NA9sPSatXqaZ44tlbMUPoUaAVYqdyy9veg=
Date: Thu, 9 Jan 2025 11:34:14 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 5.10 000/138] 5.10.233-rc1 review
Message-ID: <2025010958-bunkbed-engross-d5a1@gregkh>
References: <20250106151133.209718681@linuxfoundation.org>
 <CA+G9fYss0LJRq6rzg0g_oG2+c_TZ=i3uNnq7DuWWfm4c5YkOpQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYss0LJRq6rzg0g_oG2+c_TZ=i3uNnq7DuWWfm4c5YkOpQ@mail.gmail.com>

On Tue, Jan 07, 2025 at 02:42:20PM +0530, Naresh Kamboju wrote:
> On Mon, 6 Jan 2025 at 21:12, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.10.233 release.
> > There are 138 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 08 Jan 2025 15:11:04 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.233-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> The following build warnings are noticed on arm64 and arm
> while building with defconfig using gcc-12 and clang-19.
> 
> Build log:
> ==========
> drivers/gpu/drm/drm_modes.c:772:6: warning: comparison of distinct
> pointer types ('typeof (mode->clock) *' (aka 'const int *') and
> 'typeof (num) *' (aka 'unsigned int *'))
> [-Wcompare-distinct-pointer-types]
>   772 |         if (check_mul_overflow(mode->clock, num, &num))
>       |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> include/linux/overflow.h:88:15: note: expanded from macro 'check_mul_overflow'
>    88 |         (void) (&__a == &__b);                  \
>       |                 ~~~~ ^  ~~~~
> drivers/gpu/drm/drm_modes.c:772:6: warning: comparison of distinct
> pointer types ('typeof (mode->clock) *' (aka 'const int *') and
> 'typeof (&num)' (aka 'unsigned int *'))
> [-Wcompare-distinct-pointer-types]
>   772 |         if (check_mul_overflow(mode->clock, num, &num))
>       |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Thanks, I've dropped the offending commit now.

greg k-h
