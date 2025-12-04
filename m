Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79E03330329;
	Thu,  4 Dec 2025 16:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764866193; cv=none; b=ObLfSW5Xi9esFdatuK0xfJGHqjzDK5SdBR8/HdB6oo8BJT/DCoJAHYJaK8OxQwNcxdYsopoCINcCwZWHRfLz1/+wcF9j2ryY7Ak05eH65/9l2Us6QpSHqPQc7/wazXn663Ur211MUXIGcFUC16U20ej5xK9Ta91qZTdCyAJ+PVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764866193; c=relaxed/simple;
	bh=dFvsBwxGQF22ujlN99CR/V1sTbYm9cilYBPfcU7I3iY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bhIoTYm33uab3LEnJLCAZnt3gN7SDBEaISZpxe/kke0wK+ELFc1kOFVLH8OrPazo5AXJLXsWwHa19zAjpAwuurBwbmgwCdVA4Kb4bP8pHaZ1Cgpb68WBtwKI65yBsz8yC64OXTjQ+Qj55XSF24Pi7XBEEYl3iwzAYHFNlgb9Aac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k8RgzgD5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k8RgzgD5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A65AAC4CEFB;
	Thu,  4 Dec 2025 16:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764866193;
	bh=dFvsBwxGQF22ujlN99CR/V1sTbYm9cilYBPfcU7I3iY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=k8RgzgD5sUSHnXdF+LB1LEoguIQdAEdHmbXHSEAT9lCuhHD31n4sLgcfinSXyNI7Y
	 rt6nJqMlWOdrxviXUsW+FfAeoJDXslB7G4Ck8traXy1ncRfKu1QT8tn6Xlk1TeuwRY
	 Ua/IZalGT47sS7P5a4EEuzFGmVtE42obdpLxgLms=
Date: Thu, 4 Dec 2025 17:36:30 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 5.15 000/392] 5.15.197-rc1 review
Message-ID: <2025120416-smartly-snowshoe-e927@gregkh>
References: <20251203152414.082328008@linuxfoundation.org>
 <d9adb2a6-47cd-468a-bb6a-de11aff80659@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d9adb2a6-47cd-468a-bb6a-de11aff80659@gmail.com>

On Wed, Dec 03, 2025 at 09:51:28AM -0800, Florian Fainelli wrote:
> On 12/3/25 07:22, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.197 release.
> > There are 392 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 05 Dec 2025 15:23:16 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.197-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> MIPS fails to build with the same errors as 5.10 with:
> 
> arch/mips/mm/tlb-r4k.c: In function 'r4k_tlb_uniquify':
> arch/mips/mm/tlb-r4k.c:591:17: error: passing argument 1 of 'memblock_free'
> makes integer from pointer without a cast [-Werror=int-conversion]
>    memblock_free(tlb_vpns, tlb_vpn_size);
>                  ^~~~~~~~
> In file included from arch/mips/mm/tlb-r4k.c:15:
> ./include/linux/memblock.h:107:31: note: expected 'phys_addr_t' {aka
> 'unsigned int'} but argument is of type 'long unsigned int *'
>  int memblock_free(phys_addr_t base, phys_addr_t size);
>                    ~~~~~~~~~~~~^~~~
> cc1: all warnings being treated as errors

Offending commit now dropped, I'll push out a -rc2 soon for testing.

thanks,

greg k-h
