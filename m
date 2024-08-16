Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D85213B5B3;
	Fri, 16 Aug 2024 08:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723797491; cv=none; b=hwtcIDfb0cUIAZKDyo0+tdtX6E+H1hDMoUFTJGInLcDZU8H19b5qjcCoizPoRWydKMJnaFKlNmhCtVP/oasJE/l97lsnSsjwYP4V8grpjZfzt17piDmYSmjld1pWNf3ZKvkVjgOwJ+Twr+3/xMjQ++v6+td2Y+ugSPzqKeDm+MM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723797491; c=relaxed/simple;
	bh=UwX6lsj6hDoBBoVbcK6B2glmGl8VcKwym+q5wj1XHlk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CzmoQrMg6ntf83zU39r1EfTVJ777LKKOmAD9bDlehGvPslJKUYRBaOTT02Sipu/DmcDueSwM0GtU6Y81RDpN/mKPZz3820zZAJpjdo9nQqeNH2+smJvGjc+sqKvvz1hSIEVurxFAnFGyPZ9t0wILMNboADinqHEuF39Ma7mQwPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qC+XBRuh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qC+XBRuh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FAB2C4AF0C;
	Fri, 16 Aug 2024 08:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723797491;
	bh=UwX6lsj6hDoBBoVbcK6B2glmGl8VcKwym+q5wj1XHlk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qC+XBRuhBvE3DyBB3DSS0IhO8pmSSmntHeuH+Q+OmHadHYG942cXiK/qfniTqZ5Z7
	 p4YilCWb65NJ6RmzdvLMbLgKcxr38uWh47Uv5aVQWc6go7s2uOrzZ/hakQYsypeRH5
	 GcFg4uo87CX/cCeE6OfJ8Jh6ezglmxYFtKJ3YsDY=
Date: Fri, 16 Aug 2024 10:38:08 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.10 000/263] 6.10.5-rc1 review
Message-ID: <2024081616-gents-snowcap-0e5f@gregkh>
References: <20240812160146.517184156@linuxfoundation.org>
 <8852e518-3867-4802-adea-0c0ee68d1010@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8852e518-3867-4802-adea-0c0ee68d1010@roeck-us.net>

On Thu, Aug 15, 2024 at 07:21:00AM -0700, Guenter Roeck wrote:
> On 8/12/24 09:00, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.10.5 release.
> > There are 263 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 14 Aug 2024 16:00:26 +0000.
> > Anything received after that time might be too late.
> > 
> 
> I see various allmodconfig build failures on v6.10.5.
> 
> Example from arm:
> 
> Building arm:allmodconfig ... failed
> --------------
> Error log:
> drivers/gpu/drm/amd/amdgpu/../display/amdgpu_dm/amdgpu_dm_mst_types.c:1581:13: error: 'is_dsc_common_config_possible' defined but not used [-Werror=unused-function]
>  1581 | static bool is_dsc_common_config_possible(struct dc_stream_state *stream,
>       |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/gpu/drm/amd/amdgpu/../display/amdgpu_dm/amdgpu_dm_mst_types.c:1569:21: error: 'kbps_from_pbn' defined but not used [-Werror=unused-function]
>  1569 | static unsigned int kbps_from_pbn(unsigned int pbn)
> 
> The functions are built and used conditionally in mainline, behind CONFIG_DRM_AMD_DC_FP.
> The conditional is missing in v6.10.5 (and v6.10.6-rc1).

Odd that other allmodconfig builds passed :(

I'll dig up where that conditional showed up, thanks for letting us
know....

Ah, looks like it showed up in 00c391102abc ("drm/amd/display: Add misc
DC changes for DCN401"), gotta love "fix a bunch of things" type of
commits...

{sigh}

greg k-h
