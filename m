Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B08784DE4;
	Fri, 16 Aug 2024 08:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723798319; cv=none; b=QUFlmv//+LTrYtDyxLAw+BrZfbTMhtYHoLWUiHSbfEY0+EtpMOxGjVglkTGULhd4unp3K4GD8J2sVHJ8tQTT3kxMHkValtHncpiJVWmr1zzGCdzey4A/cKzNJ+7EEyyUyZt8OKnWUxLjiXPVE2Y+7YP/yZV81GXNlojxb4lP7f8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723798319; c=relaxed/simple;
	bh=PVDikmWDCXphrDcGq7W4MtX6yVPaIhSv52o/pdJsHf8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XfVH0tLOpW5QnZl6axTj+O1lghR2t1H+mwHjJZNLx1RmweKoCc8VHtstE/uITgV2PtcrOSSjLJUAi52q6D3JEgj2hSxFlN7Igaf1LEwdW8x3JWEmZ8h0siuLnxy/uU7SrfJgkBa/Ludt1JAayME5DhaE/+/JLBSaARk++1A3tZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bqtr94Qe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bqtr94Qe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E9B3C32782;
	Fri, 16 Aug 2024 08:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723798319;
	bh=PVDikmWDCXphrDcGq7W4MtX6yVPaIhSv52o/pdJsHf8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bqtr94QednM74yq0Ke4K0z8zNEUmViVCqELy9NA4PqaiU6PvrzxKRNzqhg2jaip9k
	 qBHFYzbkua9H2T0oX/9cW8+CLdXRfcMPm+TuHflvK/JZOSjzBm+tWrObflHon7aJXu
	 naSE55uVFzsIDdHVQ/Kybo/125DsK34isgUSm1tk=
Date: Fri, 16 Aug 2024 10:51:56 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.10 00/22] 6.10.6-rc1 review
Message-ID: <2024081647-showgirl-squint-dd38@gregkh>
References: <20240815131831.265729493@linuxfoundation.org>
 <d3a5a6b1-4c15-4d02-8c60-5a4d55f497b2@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d3a5a6b1-4c15-4d02-8c60-5a4d55f497b2@roeck-us.net>

On Thu, Aug 15, 2024 at 08:07:58AM -0700, Guenter Roeck wrote:
> On 8/15/24 06:25, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.10.6 release.
> > There are 22 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 17 Aug 2024 13:18:17 +0000.
> > Anything received after that time might be too late.
> > 
> 
> arm:allmodconfig and various other allmodconfig builds:
> 
> drivers/gpu/drm/amd/amdgpu/../display/amdgpu_dm/amdgpu_dm_mst_types.c:1581:13: error: 'is_dsc_common_config_possible' defined but not used [-Werror=unused-function]
>  1581 | static bool is_dsc_common_config_possible(struct dc_stream_state *stream,
>       |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/gpu/drm/amd/amdgpu/../display/amdgpu_dm/amdgpu_dm_mst_types.c:1569:21: error: 'kbps_from_pbn' defined but not used [-Werror=unused-function]
>  1569 | static unsigned int kbps_from_pbn(unsigned int pbn)
> 
> This was introduced in v6.10.5 and is seen with CONFIG_DRM_AMD_DC_FP=n
> and CONFIG_DRM_AMD_DC=y. AFAICS that happens for images built with gcc
> on architectures which don't have kernel FPU support.

I'll push out a -rc2 that should fix this now, thanks.

greg k-h
