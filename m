Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793848189;
	b=bQKiHsRVIkfyAMghMc11H+ZIyrRzbpdXgRl7MzPJN289aDDPry3Rjz52RgPdWfkpcfy/
	 D0zOg5ElYsxpHUies9wHEnWL60FLgpjHt1Uy4Kku1gWIhcVuz9qRZuCzMyK7hvQ7nGD2M
	 oiGzD6nzSTPDDMAgpflo6HiApTCDdws+otVuxmoF5iLrWxC0MpR0w90kJxwadSvmwl2Hr
	 9V8+5UvRZd3nTrqp1sC+U/seXAV9/6ORlb0dTZFP6eni9ie8c5VUXVfYrnx7gPqVCBUQL
	 eHqi28l7Nk3j6qUuZghCCZiOfAv65dQ2MgT4Sdn6ABi073xXnV+Ib90lMvMDC9l/+8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793848189;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=XAsI1N45Kb/uCkK8qxNt8jRdX1BvQybOdaWXm+IgpGI=;
	b=OK8hvd70E9N0Qr1ILRcWYopmKU8XNjpzJzxitbHHT6yDeRF8FnccBcNYnqwD4gaK8/9R
	 jeeWM7qLdPhBYpor7dL2k32RYaN4tqPdwl9Qkv0MWoY8/OkRmYHqW36oVl5M0Rx4Dpx61
	 zIXVI6A+Qr2RxtLOBxeE8bBveqYUBRKETRpltIgPamDnE9+kD5AbcGD1U0hxIK6chgUWb
	 Nz44cztWvcgJWDSZ1KfoQCQtY8LADoEoS0qGnx6NcAZ4sDCph74vYkCi5PNStc49cT3yS
	 LljaVcpGtqjwT/Alwi+dTqWPjxjwmpRhFiSYBtblkEp9uqFqhkJ95h0F5rOzEE1Fg0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bEv1nQrV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C8AD606A326;
	Thu,  5 Nov 2026 03:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bEv1nQrV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A6B01F000C1;
	Thu,  5 Nov 2026 03:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793848189;
	bh=XAsI1N45Kb/uCkK8qxNt8jRdX1BvQybOdaWXm+IgpGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bEv1nQrVt8HojGdR2jvPytHsVzfshAkXyOhJ4h/x1+d5axsS8EHi89ioGFjtDgjFH
	 BclyRQCA0SSWBn/MJ/ISq901ykudDll75RxGFdrm1cLL6E5Bz3ta3OeGoNNRtoHXxD
	 X0ALgQAFBA4KYZo7QFiiCP52N0srSU2iNvaoaKQmgg/zJMENgOJweXlsMOnAFlPg39
	 QpYeTVlEwp2PCG/kshrQO2UnBsF70x31+fMx4jcHS1TxqhbOazdQmUw7nkNjtfZaYj
	 g8mI/R6cqkOFfqtNeDrcoKxhwjOQGbyT/nTd0cifGIHKShJvt6cklcEbJud6CKo74X
	 ekfDIk47IQ4xg==
From: SJ Park <sj@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org,
	akpm@linux-foundation.org,
	linux@roeck-us.net,
	shuah@kernel.org,
	patches@kernelci.org,
	lkft-triage@lists.linaro.org,
	pavel@nabladev.com,
	jonathanh@nvidia.com,
	f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com,
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.18 0000/1005] 6.18.61-rc1 review
Date: Wed,  4 Nov 2026 19:09:40 -0800
Message-ID: <20261105030941.89192-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: 
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed,  4 Nov 2026 15:55:33 -0500 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.18.61 release.
> There are 1005 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 06 Nov 2026 21:07:23 +0000.
> Anything received after that time might be too late.

This rc kernel passes DAMON functionality test [1] on my test machine.

Tested-by: SJ Park <sj@kernel.org>

[1] https://github.com/damonitor/damon-tests/tree/next/corr


Thanks,
SJ

[...]
