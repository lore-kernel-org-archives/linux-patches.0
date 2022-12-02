Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF82F1C04
	for <patches@lists.linux.dev>; Fri,  2 Dec 2022 12:39:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D54F8C433C1;
	Fri,  2 Dec 2022 12:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669984769;
	bh=KtngymIfyeQ0A30J7Xlx/WGy9n4uZFsRswH4rUF7oro=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=1q1mZ+R6LUf75CDSex3BDNdhBG8+vmdP34vZs3K5d5+2jcc/TVfeZ1uaXcWVl0rgC
	 0C4uXk7Ynhp9w/zpF4U0Jyi2zdKwQIbZIwzpC/NmgGG+D4R7zjU/qVrMlCLPKcIIbf
	 0qmoYtnqXn2YTs/MLxhKIz9uIfcvIbrJlAV6uNDA=
Date: Fri, 2 Dec 2022 13:39:24 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pavel Machek <pavel@denx.de>
Cc: mlevitsk@redhat.com, samuel.thibault@ens-lyon.org, pawell@cadence.com,
	stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 000/162] 5.10.157-rc1 review
Message-ID: <Y4nx/HMggCOhdIMy@kroah.com>
References: <20221130180528.466039523@linuxfoundation.org>
 <Y4nmNb46aqbm7JuS@duo.ucw.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y4nmNb46aqbm7JuS@duo.ucw.cz>

On Fri, Dec 02, 2022 at 12:49:09PM +0100, Pavel Machek wrote:
> Hi!
> 
> [If I cc-ed you, you are author of one of patches below. Please take a
> look.]
> 
> > Responses should be made by Fri, 02 Dec 2022 18:05:05 +0000.
> > Anything received after that time might be too late.
> 
> I hope to make it :-). I
> 
> > Pawel Laszczak <pawell@cadence.com>
> >     usb: cdnsp: Device side header file for CDNSP driver
> > 
> > Pawel Laszczak <pawell@cadence.com>
> >     usb: cdns3: Add support for DRD CDNSP
> 
> These two together are 1500+ lines, and are marked as Stable-dep-of:
> 9d5333c93134 ("usb: cdns3: host: fix endless superspeed hub port
> reset") . But we don't have that one in 5.10 tree. Likely we should
> not have these either.

I already dropped these yesterday.

> > Maxim Levitsky <mlevitsk@redhat.com>
> >     KVM: x86: emulator: update the emulation mode after rsm
> 
> No. The patch does not do anything. Mainline commit this referenced
> changed the return value, this changes just a comment. Wrong backport?

I will look at this.

> > Samuel Thibault <samuel.thibault@ens-lyon.org>
> >     speakup: Generate speakupmap.h automatically
> 
> Ok, so this one rewrites some header generation and is buggy. 500+ lines.

Already dropped yesterday.

> > Đoàn Trần Công Danh <congdanhqx@gmail.com>
> >     speakup: replace utils' u_char with unsigned char
> 
> With this patch fixing it. The rewrite is marked as stable depedncency
> of the fix, but fix would not be needed if we did not apply the
> rewrite. We should not have these two in stable.

Again, already dropped.

thanks for the review.

greg k-h
