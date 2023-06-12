Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B46101D0
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 09:13:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 491E1C433EF;
	Mon, 12 Jun 2023 09:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686561222;
	bh=VtwgqtSsYOl05kBZ+EgGtyLaG3GxAwgmQJsmPvB2W+g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qvsbBO9C50agdOxNnEEETmkmCzzaIi91qNQ+t1JstqCCgZRxVM7PmlWaviAzbpc+x
	 yAOauDyp5LWBBmE84FqaXwpciGo9mL5rOm/fJpNX3lSs9s85pTVsQ/LXOCIp7j4RlE
	 Wm8QsCITummxgfl8R+eZRO5BrGejpKYYA5UczKpQ=
Date: Mon, 12 Jun 2023 11:13:40 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de,
	Thomas Gleixner <tglx@linutronix.de>,
	Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH 5.15 000/159] 5.15.116-rc1 review
Message-ID: <2023061226-footgear-kooky-cb04@gregkh>
References: <20230607200903.652580797@linuxfoundation.org>
 <b979807a-a437-4d3f-98f9-989da52abb30@roeck-us.net>
 <d35b1ff1-e198-481c-b1be-9e22445efe06@roeck-us.net>
 <CAHk-=whA=HsyDFtgQnWMZP-08ddhMh1a88OZHCXf8N-iP6hFQw@mail.gmail.com>
 <8a166eec-fc09-9ae8-b590-2c2e84796da0@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8a166eec-fc09-9ae8-b590-2c2e84796da0@roeck-us.net>

On Fri, Jun 09, 2023 at 12:31:04PM -0700, Guenter Roeck wrote:
> On 6/9/23 12:06, Linus Torvalds wrote:
> > On Fri, Jun 9, 2023 at 11:42 AM Guenter Roeck <linux@roeck-us.net> wrote:
> > > 
> > > I managed to revise my bisect script sufficiently enough to get reliable
> > > results. It looks like the culprit is commit 503e554782c9 (" debugobject:
> > > Ensure pool refill (again)"); see bisect log below. Bisect on four
> > > different systems all have the same result. After reverting this patch,
> > > I do not see the problem anymore (again, confirmed on four different
> > > systems).
> > 
> > Does this happen on mainline too? It's commit 0af462f19e63 in the upstream tree.
> > 
> > It was in 6.4-rc1, and I see a clean result from you at least for
> > -rc2, so for some reason it sounds like upstream is ok. But I don't
> > really see why that would be the case...
> > 
> 
> I see the problem only in v5.15.y, to the point where it is almost
> impossible to get a clean test of all arm-v7 systems. Affected are
> npcm (Nuvoton) boards (kudo-bmc, quanta-gsj, npcm750-evb) as well as
> orangepi-pc. I don't see it in any other branch or with any other
> platform/architecture.
> 
> Mainline is fine; I have not seen any problems since -rc2.
> 
> I have no idea what is going on either, only that I can reliably
> reproduce the problem (and of course it disappears if CONFIG_DEBUG_OBJECTS
> is disabled).

Ok, I've reverted it from 5.15.y for now until this is figured out.

thanks,

greg k-h
