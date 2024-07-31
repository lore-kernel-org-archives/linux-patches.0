Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8E0A12CD8B;
	Wed, 31 Jul 2024 06:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722406043; cv=none; b=qnfOzu6DJR06g5H71t5/Ua+rgiIZSykbRlKZpdg2jVFZwKVvJfCfAwe3248Hf8LLYGZKJVgaMhDM7acmpW0jSaKt8dqeWbbF7pRYIFzJoZ5zZsKfxgAtihALVl9hLJGJKN1uy2GWjIP0XpDXLgdaQDwe7/nCTYy0aaPFKAeMps0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722406043; c=relaxed/simple;
	bh=m9H/vZfzxCiO48tSjGipkOtUHTQ4Uyip2hjeMCtMCqA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pgu8BN6q3DgmGm/XYLeme7fAGHEZlhhuh36OKHnPthiHF2rsXuGt2Dg3ZlklUKf8vbEW8vEvt2Ms9QOvBVrkPAYn4s2cu8Ga29dnypGpYzOCZFi9mfq37jJDGpCEQwm6Tu0jLDw4TQtsj5rH0eQ3X4MVX09Dy9DpdoEAgR6QaZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c2SlwS+j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c2SlwS+j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4098C116B1;
	Wed, 31 Jul 2024 06:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722406043;
	bh=m9H/vZfzxCiO48tSjGipkOtUHTQ4Uyip2hjeMCtMCqA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=c2SlwS+jpaXWYY091/o+2qnnDX4Um8yrPpS0AxL6ubKIuQ0cQwIiApldEOTv73GWb
	 mPYhI6Jem8oVooUxH9sskfBfN3aNL9B4XURjDukQLAkNUtQQW0P8OgWHL/5R0Tb8It
	 McfeN3sdfN0cNK0OCyS2ibT0Xq+9lSKc3aqthJeA=
Date: Wed, 31 Jul 2024 08:07:15 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Frank Scheiner <frank.scheiner@web.de>
Cc: akpm@linux-foundation.org, allen.lkml@gmail.com, broonie@kernel.org,
	conor@kernel.org, f.fainelli@gmail.com, jonathanh@nvidia.com,
	linux-kernel@vger.kernel.org, linux@roeck-us.net,
	lkft-triage@lists.linaro.org, patches@kernelci.org,
	patches@lists.linux.dev, pavel@denx.de, rwarsow@gmx.de,
	shuah@kernel.org, srw@sladewatkins.net, stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com, torvalds@linux-foundation.org
Subject: Re: [PATCH 6.1 000/440] 6.1.103-rc1 review
Message-ID: <2024073137-scouting-wooing-ec33@gregkh>
References: <20240730151615.753688326@linuxfoundation.org>
 <de6f52bb-c670-4e03-9ce1-b4ee9b981686@web.de>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <de6f52bb-c670-4e03-9ce1-b4ee9b981686@web.de>

On Wed, Jul 31, 2024 at 01:24:25AM +0200, Frank Scheiner wrote:
> Dear Greg,
> 
> 6259151c04d4e0085e00d2dcb471ebdd1778e72e from mainline is missing in
> 6.1.103-rc1 and completes 39823b47bbd40502632ffba90ebb34fff7c8b5e8.
> 
> Please note that the second hunk from 6259151 needs to be modified to
> cleanly apply to 6.1.103-rc1. Example on [1].
> 
> [1]:
> https://github.com/linux-ia64/linux-stable-rc/blob/__mirror/patches/linux-6.1.y/6259151c04d4e0085e00d2dcb471ebdd1778e72e.patch
> 
> ****
> 
> ## Long version ##
> 
> This patch series breaks operation of the hp-sim kernel in ski. I think
> it happens when trying to access the ext4 root FS in the simulation, see
> for example [2] for more details.
> 
> [2]: https://github.com/linux-ia64/linux-stable-rc/issues/3
> 
> From the call trace:
> ```
> [...]
> [<a0000001000263f0>] die+0x1b0/0x3e0
> [<a00000010004bd40>] ia64_do_page_fault+0x680/0x9c0
> [<a00000010000c4e0>] ia64_leave_kernel+0x0/0x280
> [<a00000010063f6a0>] dd_limit_depth+0x80/0x140
> [...]
> ```
> 
> ...I tracked it down to [3] and following the linked discussion ([4]),
> this is actually patch 2 of 2. And 1 of 2 ([5]) is in upstream, but not
> in 6.1.103-rc1.
> 
> [3]:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=39823b47bbd40502632ffba90ebb34fff7c8b5e8
> 
> [4]: https://lore.kernel.org/all/20240509170149.7639-3-bvanassche@acm.org/
> 
> [5]:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=6259151c04d4e0085e00d2dcb471ebdd1778e72e
> 
> Applying that patch ([5]) (plus adapting hunk #2 of it) on top of
> 6.1.103-rc1 fixes it for me ([6]).
> 
> [6]:
> https://github.com/linux-ia64/linux-stable-rc/actions/runs/10170700172#summary-28130632329

Thanks for this, I'll just drop the original offending commit here as
that seems like the simplest way.  If these really need to be in the
6.1.y tree, I'll be glad to take a backported series that people have
tested to verify it all works properly.

greg k-h
