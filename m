Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32B7E288EB
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 16:38:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21138C433C8;
	Thu, 24 Aug 2023 16:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692895105;
	bh=7R2mvuEZmSt/0ZkAzdJIROp/ZSpNB4MHh0SyypYt6mY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iSxz1KZpMoSCWQ91+86Z4jQPCQlxYEJ0281UqxRF+Cb4ZhlUlfeyDJziC8buAlGba
	 UBjXg6jaChnOEZ73RE8sXwANjZwaiNeJeCkI2xEsU83jI+FDm8tF5Xao0HMO5b8Db5
	 M3wKfD4Ujgoiec+4zUtZezg+VtSu4nBY+UCnLUWU=
Date: Thu, 24 Aug 2023 18:38:22 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org
Subject: Re: [PATCH 5.10 000/135] 5.10.191-rc1 review
Message-ID: <2023082438-voucher-disobey-c591@gregkh>
References: <20230824145027.008282920@linuxfoundation.org>
 <e722f48c-2032-8898-84ed-994a4457c62b@ispras.ru>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e722f48c-2032-8898-84ed-994a4457c62b@ispras.ru>

On Thu, Aug 24, 2023 at 07:05:35PM +0300, Alexey Khoroshilov wrote:
> On 24.08.2023 17:49, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.191 release.
> 
> Do you mean 5.10.192 release?

Ah crap, this is what happens when I come back from a long trip where I
was working on my laptop and I didn't fully sync my desktop.

Yes, you are right, I am behind a release here, let me go update my
trees and push out a new -rc for this, thanks for catching it.

greg k-h
