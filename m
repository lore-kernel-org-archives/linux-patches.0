Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=99.33.87.210
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795130896;
	b=q9SxS1OwD8GgHcK6zqzyGSdG2LFb92VNbORrsBMQLeuRlEzzf9bStLLHgA5GPSz9Av6B
	 4toctq/fAyWkBFYUC/TLbsGkyTGD0Br+2y1StN7RjZwx0Z4mhqpLcOOzsTgHM5alBDFhK
	 PPHg5LP8JHzfNM+hxwo4seReY8P043OTDEJbBPqt8vUhPe1kHlK5Su0cZq4mLGeBG0LTV
	 6JDeCRAbf1/TPfZD9/dEf1E/eyCqLMhFPkEr7nQW6J0mVjsSevvKic+9I09VIXn0rZmga
	 dXF3P4ikLt5vEdcVMfKi+Dd8QelY9k5PZsCazDJ37GXJLVVnYWUxQRKF3KMdyDW2tSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795130896;
	h=DMARC-Filter:Received:Date:From:X-X-Sender:To:cc:Subject:In-Reply-To:
	 Message-ID:References:MIME-Version:Content-Type;
	bh=JgxDKL/Q8WkO9Pgpl8+1BB8H+gUW5XpQ3zCgZlUR3Xs=;
	b=IyCpS2GYq5oWlW1fH1ngKdlg/WFYStcBeC1GTwW+OOVQKiun0xD+jDeHSOwMdqd6VYNF
	 20QNfeqaKfKLOVwMQn1mUKK40abMkYrj0vG052fjqK0x1EFdf+5ktrblZVOCv4u1qcTCj
	 465oFWG1oG6cW+oSk9GMvxWaqSqUfWVGYlPcHd9dth5rvWZaCnfxPyDizUCnSN8/81NOn
	 ArpiAltg8dHLVinMVQ2vEKBNFm1k8UQTsFuvNolBDb9d4fWHT2s45vRifEW5LxLfaSItg
	 eWYWfm8pwusLY61u6Kp4z1wRL+aGdX/wZn94WBhgHpmgnDfw1Z8A+h0m6DDWyiTImOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=aaazen.com;
	spf=pass smtp.mailfrom=aaazen.com;
	arc=none smtp.remote-ip=99.33.87.210
Received: from mail.aaazen.com (99-33-87-210.lightspeed.sntcca.sbcglobal.net [99.33.87.210])
	(using TLSv1.3 with cipher TLS_CHACHA20_POLY1305_SHA256 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2790C60A2614
	for <patches@lists.linux.dev>; Thu, 19 Nov 2026 23:28:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2790C60A2614
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aaazen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aaazen.com
Received: from localhost (localhost [127.0.0.1])
	by thursday.test (OpenSMTPD) with ESMTP id a2484090;
	Thu, 19 Nov 2026 15:28:10 -0800 (PST)
Date: Thu, 19 Nov 2026 15:28:10 -0800 (PST)
From: Richard Narron <richard@aaazen.com>
X-X-Sender: richard@thursday.test
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: stable@vger.kernel.org, patches@lists.linux.dev, 
    linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
    akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
    patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com, 
    jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
    rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
    achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 5.15 0000/2214] 5.15.226-rc1 review
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
Message-ID: <0ba165b-2f55-46b4-c5b8-d892d14a21ba@aaazen.com>
References: <20261118150009.797899913@linuxfoundation.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Wed, 18 Nov 2026, Greg Kroah-Hartman wrote:

> This is the start of the stable review cycle for the 5.15.226 release.
> There are 2214 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 20 Nov 2026 14:55:35 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.226-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>

Tested on AMD    amd64 12-core and     4-core systems
and    on Intel x86-64  4-core and x86 1-core systems

Tested-by: Richard Narron <richard@aaazen.com>

