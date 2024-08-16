Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C52C213D882;
	Fri, 16 Aug 2024 22:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723846391; cv=none; b=rGc3gXjZnBGDwv2DtWCmNDnuq+/JBmju1Ij+whbSSFpF7A0Dw0vu2tUTqYkTltgbr7214JVg7nIS5HAiYrE0rO+kFXHg3qYuK/JtbfL8tg0MlA3F/yvqN+uXaj+QJB1OTyVlzq6jFmivhcRm58vHU7qZ99bVmth54fSQYKjyVRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723846391; c=relaxed/simple;
	bh=bPUTxKSsaCNz7sMonQ8qq2ULBVbPwSEXbqUK6RnJB/k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rjZBCpgafR93pn0kh30LthgY1rvSjOtETb3KfU8KgcRlEnU2edQmufGtwwilfYpBVLnc9fqSKEF5ZgwKvnwFil989ppJsk05MIuGLmnV/WZdnJwScu7p88otl22UMwXKM1bO7M1LtXhsV+QkVKuM22+SsweWFucqNcJfS81v83w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pdN3VGdJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pdN3VGdJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 245FDC32782;
	Fri, 16 Aug 2024 22:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723846391;
	bh=bPUTxKSsaCNz7sMonQ8qq2ULBVbPwSEXbqUK6RnJB/k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pdN3VGdJV4o8JQyUEsG+dlEyZwngI4/uoSTvJV82uj9HdNs4/4pvj5hE8wpb9s8bP
	 xQkF0fRvf1TGq9iv/ym3Z2BloyoeOOju5ZaNOqufxGzv1lkaBIcPxmlYb3QXrrKWvP
	 Cm3QDv6OPC+sgAJ+Kzxx6tiIoeD9HT7bt37dc4VXrZhWtSCs4wYpIK+SGmhNyD2UMG
	 RSNqza1QTF0kTMHI3xOJGiSHcDmKEt1tOJ05TwgB1ktkjSlzXuJOPfx9aw8Srkdpa4
	 oOpUlEFCIfis5LspKN7WkxLPlXl503d5/KX3RIkvar+HZPRekF7vblcVv9tqYPNBQY
	 5tpc2M895UwZw==
Date: Fri, 16 Aug 2024 15:13:08 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.10 000/263] 6.10.5-rc1 review
Message-ID: <20240816221308.GA3360409@thelio-3990X>
References: <20240812160146.517184156@linuxfoundation.org>
 <8852e518-3867-4802-adea-0c0ee68d1010@roeck-us.net>
 <2024081616-gents-snowcap-0e5f@gregkh>
 <b27c5434-f1b1-4697-985b-91bb3e9a22df@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b27c5434-f1b1-4697-985b-91bb3e9a22df@roeck-us.net>

On Fri, Aug 16, 2024 at 07:43:31AM -0700, Guenter Roeck wrote:
> On 8/16/24 01:38, Greg Kroah-Hartman wrote:
> > Odd that other allmodconfig builds passed :(
> > 
> 
> Yes, that is odd. Maybe they all build with clang nowadays ?

I doubt that is the factor because our CI sees it and we obviously only
use clang:

https://github.com/ClangBuiltLinux/continuous-integration2/actions/runs/10424364978

Cheers,
Nathan
