Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2D702417DE;
	Thu, 27 Nov 2025 13:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764251211; cv=none; b=Hpu3KT2CoS1EjghbZKkJ1WPMZDw39zXsTj2q15uCFhbr/fjBcfxaShw71a7/NmMgfcNLcjV3QNLuKZ2/DbyA6lLmCM6qsMSyQOslW9BRsusd51e22PJG8FtqALNH31WlLAQ9NLPtp3n+mo5V1FmL9rfD3eLzvShz1HHWOrNpues=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764251211; c=relaxed/simple;
	bh=nYUsJMeosQDz50qHJWQC4uIRjpDpFDnsaUPdl3/yWrg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kzxyFZB19oyYLMF14JzR9n3/NHYP4SE17E3EulxuBoHLcrOxd1VJPhzmYUinruWUfRIEWw6w8MXCDIG11bcIsPHSvNHX+CmhIIRmVeO86LU9w0YuOmyVCSGoBfDxp2v0seRIVtF9INpUNXJ6CuxEPogWVMUNJLz3p0+VSzIBfZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RxMyScOx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RxMyScOx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 274FDC4CEF8;
	Thu, 27 Nov 2025 13:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764251210;
	bh=nYUsJMeosQDz50qHJWQC4uIRjpDpFDnsaUPdl3/yWrg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RxMyScOxNS1/6+i9B9j0juRfxj8G+sovOyfDngj85F2ghu4dmgL20u9vlhpCT7OTs
	 t9P8k3p8JyLiD8OcTaB7eXQTVMSk6gyKh2x3baTa6DMZiifgt41ay0x5+C9rwhMJh2
	 LCFpbOgNDjSXXMso3zV3RqAAypcdikhxp0bhtpFw=
Date: Thu, 27 Nov 2025 14:46:47 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Kees Cook <kees@kernel.org>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org,
	Russell King - ARM Linux <linux@armlinux.org.uk>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Valdis =?utf-8?Q?Kl=C4=93tnieks?= <valdis.kletnieks@vt.edu>
Subject: Re: [PATCH 5.15 000/411] 5.15.186-rc1 review
Message-ID: <2025112721-elective-delusion-7eb1@gregkh>
References: <20250623130632.993849527@linuxfoundation.org>
 <CA+G9fYuU5uSG1MKdYPoaC6O=-w5z6BtLtwd=+QBzrtZ1uQ8VXg@mail.gmail.com>
 <2025062439-tamer-diner-68e9@gregkh>
 <CA+G9fYvUG9=yGCp1W9-9+dhA6xLRo7mrL=7x9kBNJmzg7TCn7w@mail.gmail.com>
 <2025062517-lucrative-justness-83fe@gregkh>
 <202511061127.52ECA4AB40@keescook>
 <2025112157-renewable-batboy-7b5c@gregkh>
 <202511210951.39AA2F97@keescook>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202511210951.39AA2F97@keescook>

On Fri, Nov 21, 2025 at 10:00:53AM -0800, Kees Cook wrote:
> On Fri, Nov 21, 2025 at 10:36:22AM +0100, Greg Kroah-Hartman wrote:
> > On Thu, Nov 06, 2025 at 11:32:18AM -0800, Kees Cook wrote:
> > > This thread got pointed out to me. You can put this back in if you want;
> > > you just need the other associated fix (which had a bit of an obscure
> > > Fixes tag):
> > 
> > What exactly is "this" commit?
> > 
> > > d8720235d5b5 ("scsi: qedf: Use designated initializer for struct qed_fcoe_cb_ops")
> > 
> > Can you give a list of git ids asked for here?  This thread is confusing
> > :)
> 
> Sorry! For stable, you want these, if they're not already present:
> 
> 960013ec5b5e ("net: qede: Initialize qede_ll_ops with designated initializer")
> d8720235d5b5 ("scsi: qedf: Use designated initializer for struct qed_fcoe_cb_ops")
> e136a4062174 ("randstruct: gcc-plugin: Remove bogus void member")
> f39f18f3c353 ("randstruct: gcc-plugin: Fix attribute addition")
> 
> 
> An additional bit of confusion is that the fix in 960013ec5b5e landed
> twice via 2 trees:
> 6b3ab7f2cbfa ("net: qede: Initialize qede_ll_ops with designated initializer")
> 960013ec5b5e ("net: qede: Initialize qede_ll_ops with designated initializer")

Ugh, that's why we got confused.  This only backported to 6.1.y, but not
earlier.  I'll go queue it up to the older ones as well.  All of the
other commits listed above are already in stable releases.

thanks,

greg k-h
