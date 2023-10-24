Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8C9C224EB
	for <patches@lists.linux.dev>; Tue, 24 Oct 2023 08:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZclkhsmN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D290AC433C8;
	Tue, 24 Oct 2023 08:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698136317;
	bh=BYQEbgrs6X61ixSYGvdHAsL1b7y8U2m7ZhKq7Y4SGFA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZclkhsmNsPql+3TnbKv3S9YL0/90JmCDTmuUBbfu9KU11Balc4EBEbMBO13/cewqR
	 yG9vukpc5PoknNU9WWCuktsBCa4TbzfYzjGFegxJMrooam7euifBvrUtuetHrY7niH
	 cipNa+8ZAxXGnyF3Ub8bpPxiK+uMJ8LDtEz1iQCU=
Date: Tue, 24 Oct 2023 10:31:54 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Dominique Martinet <asmadeus@codewreck.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org
Subject: Re: [PATCH 5.10 000/202] 5.10.199-rc1 review
Message-ID: <2023102443-woozy-spud-171a@gregkh>
References: <20231023104826.569169691@linuxfoundation.org>
 <ZTd3TZ7oZH7nxKfY@codewreck.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZTd3TZ7oZH7nxKfY@codewreck.org>

On Tue, Oct 24, 2023 at 04:50:37PM +0900, Dominique Martinet wrote:
> Greg Kroah-Hartman wrote on Mon, Oct 23, 2023 at 12:55:07PM +0200:
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.199-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > and the diffstat can be found below.
> 
> Not much point in adding to the IRQCHIP_IMMUTABLE errors reports; I went
> ahead and reverted these two commits:
> da4ad7dba3a1 ("gpio: vf610: mask the gpio irq in system suspend and support wakeup")
> 90225415cad6 ("gpio: vf610: make irq_chip immutable")

Thanks, I'm dropping them now as well.

greg k-h
