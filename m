Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C56D2135CE;
	Thu,  4 Dec 2025 16:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764865343; cv=none; b=GoF3VdfDKWnMmBY5E9RE/8QFZL9eEJqbikfqpFXHUVT6VEaZZ5JR5p7RTiZazdk8c2Y2DAqw1yGWEVqdwa8uzZ8XcKkngXgPWNVhSsjyka+xyq6YKS+6jDaAIDbcAMVAxLkONKfEM9+1Ly2cbqb2lmf/K3pz1Uxk1s3nW70cgfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764865343; c=relaxed/simple;
	bh=WfgX1xQRScOcU6PhFTsSDZ4bGvIKu4d0DKOWzwhbE+M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RU1D6ac+OdOxdydilbA2yi6v3Orst+yrxoceo5sXy65NdM0dq+oGetpjZlcoBlJy5cHG39L7lBzueeqByOoGoklbljiMxa2p3dMMdn2JSIvThEjfD0T62Y3rD4Rj6nIPwrPNTgfnhBF6T9jgWMuDKU1OEU2qg83mIjjCauywGTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oHQDhzi3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oHQDhzi3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50516C4CEFB;
	Thu,  4 Dec 2025 16:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764865342;
	bh=WfgX1xQRScOcU6PhFTsSDZ4bGvIKu4d0DKOWzwhbE+M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oHQDhzi3x2DJ/bhL1GAeANyuSVNA9rrosD/43qf21DyJQJhndWKuGmy/U05ZGwOVn
	 85o9LjNK6wF41Oqe8CL9SlZMmLA4grGFn5vQ9XdDeDv7gEE9AH/bO1L86w9XBhC6Mi
	 f1WERbPHgVoG5vQOtg+jARkW8jHYYJTDrKdTgM+o=
Date: Thu, 4 Dec 2025 17:22:20 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	kai.heng.feng@canonical.com, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	achill@achill.org, sr@sladewatkins.com,
	Svyatoslav Ryhel <clamor95@gmail.com>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>, Arnd Bergmann <arnd@arndb.de>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Anders Roxell <anders.roxell@linaro.org>,
	Ben Copeland <benjamin.copeland@linaro.org>,
	sparclinux@vger.kernel.org
Subject: Re: [PATCH 6.1 000/568] 6.1.159-rc1 review
Message-ID: <2025120406-unenvied-postbox-99e1@gregkh>
References: <20251203152440.645416925@linuxfoundation.org>
 <CA+G9fYuoT9s1cx3tOoczbCJDf2rtrmT1xSg-wut5ii6LG6ieMg@mail.gmail.com>
 <6f16db6d-0c42-4115-bede-ab398c819742@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6f16db6d-0c42-4115-bede-ab398c819742@intel.com>

On Thu, Dec 04, 2025 at 03:54:15PM +0200, Adrian Hunter wrote:
> On 04/12/2025 12:43, Naresh Kamboju wrote:
> > On Wed, 3 Dec 2025 at 21:48, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> >>
> >> This is the start of the stable review cycle for the 6.1.159 release.
> >> There are 568 patches in this series, all will be posted as a response
> >> to this one.  If anyone has any issues with these being applied, please
> >> let me know.
> 
> > Build regressions: sparc, allmodconfig, ERROR: modpost:
> > "pm_suspend_target_state" [drivers/ufs/host/ufshcd-pci.ko] undefined!
> > 
> > ### sparc build error
> > ERROR: modpost: "pm_suspend_target_state"
> > [drivers/ufs/host/ufshcd-pci.ko] undefined!
> > 
> > ### commit pointing to sparc build errors
> >   scsi: ufs: ufs-pci: Fix S0ix/S3 for Intel controllers
> >   commit bb44826c3bdbf1fa3957008a04908f45e5666463 upstream.
> 
> For that issue, cherry-picking the following provides the
> needed definition:
> 
> commit 2e41e3ca4729455e002bcb585f0d3749ee66d572
> Author: Kai-Heng Feng <kai.heng.feng@canonical.com>
> Date:   Tue May 2 17:04:34 2023 +0200
> 
>     PM: suspend: Fix pm_suspend_target_state handling for !CONFIG_PM
>     
>     Move the pm_suspend_target_state definition for CONFIG_SUSPEND
>     unset from the wakeup code into the headers so as to allow it
>     to still be used elsewhere when CONFIG_SUSPEND is not set.
>     
>     Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
>     [ rjw: Changelog and subject edits ]
>     Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Thanks, will go queue that up now.

greg k-h
