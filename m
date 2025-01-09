Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 049B3204C3C;
	Thu,  9 Jan 2025 11:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736420893; cv=none; b=gOU8ADwMCMizZDd/+IIIBUau07sAwyJ/XCZmZ525EhDlXmTEHZyOdvUSoOyCSbkBx/hlH1ClfI8T0NCHHWxeXep790fadg0O7tuqaAiol1qAC6rGaC8hr5H0fcJ1C33ndh5cjeqq9jTuz+/tD42cfvsABMjO/lTWeDwCB9SqNeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736420893; c=relaxed/simple;
	bh=OajkFyR8OD1INXvtuqQRJQ/9A6aanoq5KYOKqZrlPQ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f++UqtS8HpIEG0+9+ZB9vQSWO5l+jxPusJwx5Mmoanpf1mFwn5WsXEHbZCWowPWcoHNgWmCXG1V5R3u5rEYR14k4AGwGbBOEhbXOKAm2XKJdVKyUonzH5cghjlcgof+YutfTC3y9GgDTMaHaVLsNMP4BMiPNlFFZxb0GkyJJ1fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ePr+06WS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ePr+06WS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03513C4CED2;
	Thu,  9 Jan 2025 11:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736420892;
	bh=OajkFyR8OD1INXvtuqQRJQ/9A6aanoq5KYOKqZrlPQ0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ePr+06WS8bIttYarDHrcbpLE0nvAcBkfC/C2/1IOZ/LGs3TuCLTVObhB8BQLuaj+P
	 q0ZPwzgLN3rfJMd/hS3cpsdAwIS/y1rSZLGHp1k6cIPAXYdNO8mU14ZY1eRbwkt1DO
	 IwMfuqcYdjJcm8SIDkt9Xt+xLuj5I+Yumt8Z8whY=
Date: Thu, 9 Jan 2025 12:08:09 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Shuah Khan <skhan@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 5.15 000/168] 5.15.176-rc1 review
Message-ID: <2025010924-snooper-penalty-c7e9@gregkh>
References: <20250106151138.451846855@linuxfoundation.org>
 <d0e2b7d8-cde9-48f7-a931-ba204deb3a47@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d0e2b7d8-cde9-48f7-a931-ba204deb3a47@linuxfoundation.org>

On Mon, Jan 06, 2025 at 04:05:30PM -0700, Shuah Khan wrote:
> On 1/6/25 08:15, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.176 release.
> > There are 168 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 08 Jan 2025 15:11:04 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.176-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> Build failed on my test system with this commit:
> 
> 	999976126ca826e40fd85007a1b325d83e102164
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit/?h=linux-5.15.y&id=999976126ca826e40fd85007a1b325d83e102164
> 
> Worked when I removed this commit.
> 
> Errors:
>  CC [M]  drivers/gpu/drm/amd/amdgpu/../display/dc/dcn20/dcn20_resource.o
> drivers/gpu/drm/amd/amdgpu/../display/dc/dcn20/dcn20_resource.c: In function ‘dcn20_split_stream_for_odm’:
> drivers/gpu/drm/amd/amdgpu/../display/dc/dcn20/dcn20_resource.c:1945:40: error: ‘const struct opp_funcs’ has no member named ‘opp_get_left_edge_extra_pixel_count’; did you mean ‘opp_program_left_edge_extra_pixel’?
>  1945 |                 if (opp && opp->funcs->opp_get_left_edge_extra_pixel_count
>       |                                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>       |                                        opp_program_left_edge_extra_pixel
> drivers/gpu/drm/amd/amdgpu/../display/dc/dcn20/dcn20_resource.c:1946:48: error: ‘const struct opp_funcs’ has no member named ‘opp_get_left_edge_extra_pixel_count’; did you mean ‘opp_program_left_edge_extra_pixel’?
>  1946 |                                 && opp->funcs->opp_get_left_edge_extra_pixel_count(
>       |                                                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>       |                                                opp_program_left_edge_extra_pixel
> drivers/gpu/drm/amd/amdgpu/../display/dc/dcn20/dcn20_resource.c:1948:41: error: implicit declaration of function ‘resource_is_pipe_type’; did you mean ‘resource_list_first_type’? [-Werror=implicit-function-declaration]
>  1948 |                                         resource_is_pipe_type(next_odm_pipe, OTG_MASTER)) == 1) {
>       |                                         ^~~~~~~~~~~~~~~~~~~~~
>       |                                         resource_list_first_type
> drivers/gpu/drm/amd/amdgpu/../display/dc/dcn20/dcn20_resource.c:1948:78: error: ‘OTG_MASTER’ undeclared (first use in this function); did you mean ‘IFF_MASTER’?
>  1948 |                                         resource_is_pipe_type(next_odm_pipe, OTG_MASTER)) == 1) {
>       |                                                                              ^~~~~~~~~~
>       |

This took me a while to figure out, turns out that it's only built if
KCOV_INSTRUMENT_ALL is disabled as it looks like this code is really
sensitive to compiler issues.  None of my test builds caught it at all,
thanks!

I'll go drop the offending commit now.

greg k-h
