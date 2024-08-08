Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C4818DF70;
	Thu,  8 Aug 2024 16:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723133826; cv=none; b=Wysfaa3aGtwZSwoMA2poptMw/BvPfXmq+FtVCBEaLRG6Ci1+yFdIQuXfMQniGWz8coP+34X2l1optCc3P/RNxduG2LTRLOp7mhffhgT8IieypXdIa/fJ4oHZTt7CA3sBFWGFrH1C0k6TVuSX0+Kz7/JL0V6VpMjOs0cV65aLRXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723133826; c=relaxed/simple;
	bh=8xtzEYp2WtL2RFQkIWbThmghJH82Jb6RXcsbasHDgNk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nOJB5kkcR8gxCEGaVLWaMbpchBZ/9gMYVOxcpLCYic7S4sW1ffmdTsBYFwGFDY1FsgRYVPxyNBIlKx4a1nTW4tSpiv7SeERamc5AYRTbfER1rmdYf1BXwwOt0baEI1Xz6CibFt9aP2fAYMjFJDWPJdfTRdE8rJV0rUX5/1ouhkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UDABoYu/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UDABoYu/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B98FC32786;
	Thu,  8 Aug 2024 16:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723133826;
	bh=8xtzEYp2WtL2RFQkIWbThmghJH82Jb6RXcsbasHDgNk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UDABoYu/OOG2vPWgv6V9boAx8FYwCxOvPbgAoTnuNhtC6M6TZTbucEtaSnPIs2+WG
	 zXwY+ncYB6YMXlDZBLSZu8x46sfC9DYgNOCDoVKjUWIpeEV6FCAfv2OkKtiao+/FKO
	 0RKTZlm/PuEKE9ipNsj0NLd329660xgnQK6dsoTY=
Date: Thu, 8 Aug 2024 18:17:03 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Kevin Holm <kevin@holm.dev>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.10 000/123] 6.10.4-rc1 review
Message-ID: <2024080834-raving-karate-3d7c@gregkh>
References: <20240807150020.790615758@linuxfoundation.org>
 <9df7b196-abdc-49ed-85a5-269c14a80d30@holm.dev>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9df7b196-abdc-49ed-85a5-269c14a80d30@holm.dev>

On Thu, Aug 08, 2024 at 11:15:51AM +0200, Kevin Holm wrote:
> Hi Greg,
> 
> is there a problem with my backport of 4df96ba6676034 ("drm/amd/display: Add
> timing pixel encoding for mst mode validation") that I send to the stable list
> [1] that prevent it from inclusion of 6.10.4?
> If there is a problem, is there something I can do to fix it?

It is in the "to review" queue of mine that is quite large at the
moment.  Give us some time to catch up next week due to travel this
week, thanks.

greg k-h
