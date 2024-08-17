Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E48213DDCD;
	Sat, 17 Aug 2024 07:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723880612; cv=none; b=g13Rh/uWl15wU6VVZYCBzp2oYpT+sn8S+gOFsZghFXnZqdJzMWG/qJezxnFbwCRo1i8T5aZZNdOv/ZO77YE77GGS/fLgS0KvQ0ElTYyd46epVC6RXnEt3KgZXjMktZjt443kmUOF96vJT+9XPxfuc6TrPlt4JvkwU1fyJ443GVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723880612; c=relaxed/simple;
	bh=A+lGQ5o2T8pTh+g0c7rkc60LOwZr5vn2JgeBHKg8cFw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qnu9rqJX1oVwVU+lDAgTj4S9VXDLpD/OSHnlPAY4M3BhRFRbg9S0B4P2dabTd8SucdoGDhoxHuoR9FDee9uQtkMWAjqSGpJ3jYbcHrlkdK39cK2ZjCsPHl4MIn3RITWlwukNEKZizigr29aZrCQOZDa9Rxn+uE6GRXdaK3y+ils=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b+bOyJLw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b+bOyJLw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93D9DC116B1;
	Sat, 17 Aug 2024 07:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723880612;
	bh=A+lGQ5o2T8pTh+g0c7rkc60LOwZr5vn2JgeBHKg8cFw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=b+bOyJLwmiy6YEkoXJgi5GDZAhcU2/ZYt7TdUNHaQNcdkH5tniePs41HNqa+gRM9Y
	 QqAM1qVgHc0XxSw2EMOQ/GQpwuc8Zwh3+nPdgx915kSm/TfkE2uo1Ao6cHVkZBr9rn
	 0hAFVN9NfCsNuKHBBk9WEc54gpBSch4nB5SgW6ig=
Date: Sat, 17 Aug 2024 09:43:28 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jon Hunter <jonathanh@nvidia.com>
Cc: "patches@lists.linux.dev" <patches@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux@roeck-us.net" <linux@roeck-us.net>,
	"shuah@kernel.org" <shuah@kernel.org>,
	"patches@kernelci.org" <patches@kernelci.org>,
	"lkft-triage@lists.linaro.org" <lkft-triage@lists.linaro.org>,
	"pavel@denx.de" <pavel@denx.de>,
	"f.fainelli@gmail.com" <f.fainelli@gmail.com>,
	"sudipm.mukherjee@gmail.com" <sudipm.mukherjee@gmail.com>,
	"srw@sladewatkins.net" <srw@sladewatkins.net>,
	"rwarsow@gmx.de" <rwarsow@gmx.de>,
	"conor@kernel.org" <conor@kernel.org>,
	"allen.lkml@gmail.com" <allen.lkml@gmail.com>,
	"broonie@kernel.org" <broonie@kernel.org>,
	"linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 5.10 000/350] 5.10.224-rc2 review
Message-ID: <2024081757-single-anime-67a3@gregkh>
References: <20240816101509.001640500@linuxfoundation.org>
 <058ae5ab-7040-4bb0-b451-c4fd4e37bb36@drhqmail201.nvidia.com>
 <DM8PR12MB5447F590697190728874B64FD9812@DM8PR12MB5447.namprd12.prod.outlook.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM8PR12MB5447F590697190728874B64FD9812@DM8PR12MB5447.namprd12.prod.outlook.com>

On Fri, Aug 16, 2024 at 08:12:36PM +0000, Jon Hunter wrote:
> 
> ________________________________
> From: Jon Hunter <jonathanh@nvidia.com>
> Sent: Friday, August 16, 2024 2:43 PM
> To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>; patches@lists.linux.dev <patches@lists.linux.dev>; linux-kernel@vger.kernel.org <linux-kernel@vger.kernel.org>; torvalds@linux-foundation.org <torvalds@linux-foundation.org>; akpm@linux-foundation.org <akpm@linux-foundation.org>; linux@roeck-us.net <linux@roeck-us.net>; shuah@kernel.org <shuah@kernel.org>; patches@kernelci.org <patches@kernelci.org>; lkft-triage@lists.linaro.org <lkft-triage@lists.linaro.org>; pavel@denx.de <pavel@denx.de>; Jon Hunter <jonathanh@nvidia.com>; f.fainelli@gmail.com <f.fainelli@gmail.com>; sudipm.mukherjee@gmail.com <sudipm.mukherjee@gmail.com>; srw@sladewatkins.net <srw@sladewatkins.net>; rwarsow@gmx.de <rwarsow@gmx.de>; conor@kernel.org <conor@kernel.org>; allen.lkml@gmail.com <allen.lkml@gmail.com>; broonie@kernel.org <broonie@kernel.org>; linux-tegra@vger.kernel.org <linux-tegra@vger.kernel.org>; stable@vger.kernel.org <stable@vger.kernel.org>
> Subject: Re: [PATCH 5.10 000/350] 5.10.224-rc2 review
> 
> On Fri, 16 Aug 2024 12:22:05 +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.224 release.
> > There are 350 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sun, 18 Aug 2024 10:14:04 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >        https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.224-rc2.gz
> > or in the git tree and branch at:
> >        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Failures detected for Tegra ...
> 
> Test results for stable-v5.10:
>     10 builds:  10 pass, 0 fail
>     31 boots:   26 pass, 5 fail
>     45 tests:   44 pass, 1 fail
> 
> Linux version:  5.10.224-rc2-g470450f8c61c
> Boards tested:  tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
>                 tegra20-ventana, tegra210-p2371-2180,
>                 tegra210-p3450-0000, tegra30-cardhu-a04
> 
> Boot failures:  tegra186-p2771-0000, tegra210-p2371-2180,
>                 tegra210-p3450-0000
> 
> Test failures:  tegra194-p2972-0000: boot.py
> 
> ---
> 
> Apologies for the mail formatting. I am travelling and only have outlook for mobile :-(
> 
> Bisect points to the following commit ...
> 
> # first bad commit: [4bade5a6b1cfe81c9777aa3c8823009ff28a6e7f] memory: fsl_ifc: Make FSL_IFC config visible and selectable
> 
> Reverting this does fix the issue. Seems odd but this appears to disable CONFIG_MEMORY for v5.10 with ARM64 defconfig. So something we need to fix.

Ah, that's a mess.  I'll go drop this one for now, glad it's not showing
up on 5.15.y where this commit also is.  It's not really important for
5.10.y so there's no harm in removing it.

thanks,

greg k-h
