Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E0B44B1E71;
	Thu, 15 May 2025 05:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747287434; cv=none; b=fsUKiCSKp3+9Gm+RKZhgOOwk7YIMhsWTkwbTh4juSLA/oggjERz12VgA3RxNJMpu7K6HPGaBZj3s7xgnF/25vfYuLOJNEELIEj+JwlW7G4IFURCsmpUT8JFcj4nSMHiFPDIO6+QgzFe0a065WaACtCRZyQPzPVAJfDiRGEzL1os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747287434; c=relaxed/simple;
	bh=3Y/vfFpWVFe1Oykvm9IVuOx9Ja+WEtMvQhd42GVvcxY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Skg3LhQ3DRyCo/Mr/0ZPAc9oryk8KrZ5owc4lCIf1+VO+gocUrEcwRIuqa5uULZFyToNyYDhy6/eHFoDKx15LSlqleVZEgZ8wCQdVd6BSzo2gGd/vPMzr2V32t4dVhDe8N9vkPN0GVrXK/J1e/TDT9pzWJSW5BtVAPASOop4uec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X/KIn15v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X/KIn15v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21E19C4CEE7;
	Thu, 15 May 2025 05:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747287433;
	bh=3Y/vfFpWVFe1Oykvm9IVuOx9Ja+WEtMvQhd42GVvcxY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=X/KIn15vxowFvGkKGsk/jpKaWXhqk179YWJQxzCqG3Dwm7fq3ueoALlvgV+4JNmu3
	 n/XPHUZLV9na0aN9opLYw+TuWgITuhdSDO36Hi28NI2S6X9k4hVmaPU2nphZsdkSgh
	 PKchWgeRwIwtyheyWqudvjVwknT2d7s5knPSsYew=
Date: Thu, 15 May 2025 07:35:26 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Guenter Roeck <linux@roeck-us.net>
Cc: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org,
	Darren Kenny <darren.kenny@oracle.com>
Subject: Re: [PATCH 6.6 000/113] 6.6.91-rc2 review
Message-ID: <2025051527-travesty-shape-0e3b@gregkh>
References: <20250514125617.240903002@linuxfoundation.org>
 <861004b4-e036-4306-b129-252b9cb983c7@oracle.com>
 <2025051440-sturdily-dragging-3843@gregkh>
 <9af6afb1-9d91-48ea-a212-bcd6d1a47203@oracle.com>
 <e1ea37bd-ea7d-4e8a-bb2f-6be709eb99f4@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e1ea37bd-ea7d-4e8a-bb2f-6be709eb99f4@roeck-us.net>

On Wed, May 14, 2025 at 01:49:06PM -0700, Guenter Roeck wrote:
> On 5/14/25 13:33, Harshit Mogalapalli wrote:
> > Hi Greg,
> > 
> > On 15/05/25 01:35, Greg Kroah-Hartman wrote:
> > > On Thu, May 15, 2025 at 12:29:40AM +0530, Harshit Mogalapalli wrote:
> > > > Hi Greg,
> > > > On 14/05/25 18:34, Greg Kroah-Hartman wrote:
> > > > > This is the start of the stable review cycle for the 6.6.91 release.
> > > > > There are 113 patches in this series, all will be posted as a response
> > > > > to this one.  If anyone has any issues with these being applied, please
> > > > > let me know.
> > > > > 
> > > > > Responses should be made by Fri, 16 May 2025 12:55:38 +0000.
> > > > > Anything received after that time might be too late.
> > > > 
> > > > ld: vmlinux.o: in function `patch_retpoline':
> > > > alternative.c:(.text+0x3b6f1): undefined reference to `module_alloc'
> > > > make[2]: *** [scripts/Makefile.vmlinux:37: vmlinux] Error 1
> > > > 
> > > > We see this build error in 6.6.91-rc2 tag.
> > > 
> > > What is odd about your .config?  Have a link to it?  I can't duplicate
> > > it here on my builds.
> > > 
> > 
> > So this is a config where CONFIG_MODULES is unset(!=y) -- with that we could reproduce it on defconfig + disabling CONFIG_MODULES as well.
> > 
> 
> Key is the combination of CONFIG_MODULES=n with CONFIG_MITIGATION_ITS=y.

Ah, this is due to the change in its_alloc() for 6.6.y and 6.1.y by the
call to module_alloc() instead of execmem_alloc() in the backport of
872df34d7c51 ("x86/its: Use dynamic thunks for indirect branches").

Pawan, any hints on what should be done here instead?

thanks,

greg k-h
