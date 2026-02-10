Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C5CC2F39AB;
	Tue, 10 Feb 2026 15:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770738194; cv=none; b=b2uYcxu+gPH7zPEDHBVD5j330Glwb2f+rHQCS65Thheu+SNfGHCgZg/BHW+Z4ujEeNT8FzyDJZ4I72FX9t4avNXR4Dou9GJ2fy+HcrAACTRgL39mf8uSt+gzYehJ+kjBcaMWEzuwv9X4mEht7WdxF00y7feBpddWgbmeyd6ug9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770738194; c=relaxed/simple;
	bh=HFPre1kxWcQ9TiBZN7T3HcqweGfELl7jlV2eZ3dAAuI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o940ANoEkKeJvIrBz70ZgX2BSD63gc7erZE68UpdKntAgY0ssWMktZueH3HQ1QmdeUwkAWOEfswt9etzPM+kMbY67VLokuUUc7nXrg/0O5olOn0EJTKlaVuJO2j4+pDJMiSLxVPzZhnGZeYgUsnAiNj2t8tmero6sROnrMrxsCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mZybD4ss; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mZybD4ss"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4236C19423;
	Tue, 10 Feb 2026 15:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770738194;
	bh=HFPre1kxWcQ9TiBZN7T3HcqweGfELl7jlV2eZ3dAAuI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mZybD4ss8xJjmA/f+bWEqbJUq8EIMPe5wNF4yDWFZR2bEIBrY2hlq395TRw/npHVk
	 HNtizyzJL0Q+wX3I34QxI6rKwcWGrkfeVAVsvlVAKA2cdOQmr+STIlu/xPTlVesaB2
	 64493qCHicayWpSAnBsufe47RtBwLgmc0UArpGiY=
Date: Tue, 10 Feb 2026 16:43:11 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.18 000/175] 6.18.10-rc1 review
Message-ID: <2026021034-salt-unhearing-88b5@gregkh>
References: <20260209142320.474120190@linuxfoundation.org>
 <CAG=yYwkhAAm76qUH_2dCHUp8+hGzvgT1Fm_288Z-=QRG+tAbfQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG=yYwkhAAm76qUH_2dCHUp8+hGzvgT1Fm_288Z-=QRG+tAbfQ@mail.gmail.com>

On Tue, Feb 10, 2026 at 08:34:53PM +0530, Jeffrin Thalakkottoor wrote:
>  hello
> 
> dmesg  stuff's ...
> ------------------------error----------------------------
> [   21.307326] lp lp.0: really_probe: driver_sysfs_add failed
> [   21.309030] kobject: kobject_add_internal failed for lp0 (error: -2
> parent: printer)
> ------------------------error----------------------------
> I DO NOT HAVE A PRINTER

That's good, finding one here would mean that there was a problem :)

Why did you load/build this driver into the kernel?  Any other lp
messages or drivers loaded?

thanks,

greg k-h
