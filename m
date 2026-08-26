Received: from fhigh-a7-smtp.messagingengine.com (fhigh-a7-smtp.messagingengine.com [103.168.172.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B8E73B19B6
	for <patches@lists.linux.dev>; Wed, 26 Aug 2026 07:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787731071; cv=none; b=sLhAbyAeK1CPI9n275vQLtL8yEabG4XeS4iAAt4Km+iodWmkvHjX8tT1LTJvQ3EXX2Vh+IewO5W23k9qpia+97PqgIect4h6oWmz1PGBKxnEqN7Y6vm/lSGI+w90RSyPVn7jLPU6yw1DtgRbzsSNGte3BACCw1Yx6aTmiGorDF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787731071; c=relaxed/simple;
	bh=PIv7Vk4CueoRVOds5QWgAMsuXIpc2CESTKrfOi+N3p8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lD/vHjMtqjkgp+pi/qgM0Dx8Xt6j7tjRI3DdbHW/mxvN0l/8E/+hZGLPvrVJJW+QiVawremFQ6yzB7qTzeHLSP+xlN0DJNd4cXkwg2VhBpcfqg0B9LoH4YuKabp4ZpFZP0I/emXW8PmLO4thnlE4ntjfJnL/dBo6NC1bA4vU1+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=JQEu7Rp3; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=OmnwJ5UX; arc=none smtp.client-ip=103.168.172.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="JQEu7Rp3";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="OmnwJ5UX"
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 5F5FC1400035;
	Wed, 26 Aug 2026 03:57:49 -0400 (EDT)
Received: from phl-frontend-01 ([10.202.2.160])
  by phl-compute-06.internal (MEProxy); Wed, 26 Aug 2026 03:57:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1787731069;
	 x=1787817469; bh=n3tJdoJ4OIJuAc9QGu7+R3Mnt31hJMNNhTOwaiN/FNI=; b=
	JQEu7Rp38Q9OROJmDxiaLhDwqFkhZu/ClYNwdP398S5f9FvQ6WBFdrlJA/zWdnLN
	3LrW+juOquR+wyAYcQEIsrwB3o40XbvQ8BK+a9HSzNEGK2ww3lzqCI10ha/6Trg0
	KQLJYxUBqzUxGvqLIJ73UmrrS3JHbcnAGL7gIX8fLCIgj4arslWkU3mOLxtIBgP2
	UvD83nEJlaqxvACU4DuPNIZsgQ1Iatuvv5etq41ceMlSfMuh6VULkotQsaH3tP/C
	Sj/jRNq6amMVVW2SIOoHkP8Y8T+QTL/Utw/xbmfVtNAtBg9EYsAVc8F66o10yR1O
	8WzLH+MWqhrAz81eS50M/g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1787731069; x=
	1787817469; bh=n3tJdoJ4OIJuAc9QGu7+R3Mnt31hJMNNhTOwaiN/FNI=; b=O
	mnwJ5UXzKEBgzxisPnGtYG5SIddJXsUy1SIfP7hszVV4SZJc1jbZ2Ka7VwJ3I97W
	REMI7erWpG7BBP/CTFGD1kOEEJsOJNa3vnNUD9b1KcIe1lzP6yHHRoahZMU/u2Px
	7deQekAb3Ib9hCtlmY+DlD1oz/GvtRTyEYmvcDN2R1033v7QTpAZ20Ygii+SLPyw
	yfgRdGsgLmfWQ1FwrbHZJjS3gx4UTInVeF/fKMnsd60VUrVIPms+aNmBwGDgonVE
	uOEk3LxJUYde6vg3fuigT91sJSEdNdyQkgubPv0Jt6lC+ueDkSRfUyGOo4psXZIl
	PPwyxU4al11A3RRUkTUJA==
X-ME-Sender: <xms:fZyOavXpeAQQ64yvENjlHNeIaM-vHP_MRU4kAVlCxyE7hQmdXH3zfQ>
    <xme:fZyOajcKjYloNqzMAL5OJDyVG2k0EoQLUFvcSr2M4ttl3egaWgmhdfuUYuGQsbUN6
    smHOjdPq8Z5E5Ca3gFZ0ousHwk3XuFs_USXUELS5An4zjqv7swGj3wg>
X-ME-Received: <xmr:fZyOam6qAm5mmwQFj2goxv1fkJu5gzSKKyh73gMf5_A7JuEf9fsSKYd6dm-YwFxVpAsfJg8M3AjFEJ3UqmmhywdYCEXdhVmf>
X-ME-Proxy-Cause: dmFkZTGG2hBiTOAsBCcb4hwW6iPrjgjHlSVr/r4RVmMm6wxJIthp1hETO/1fuexuNmi2Ix
    psnwLkcFWNz+u7JxHt5AlIQ+/gHnE1l+MFo+Q0AFPcVsLmZZvEHglDOXbEuLF9rhf2YbBq
    ByKapiR7wHyVcsZQZKBXac/6LNlwzp35NyNzH5gNKkSq3rt1o9t/2Uvda5C01UkvoC27or
    1huFymfqcedK0xRivlFIFFUEmMdo1ezLMZC1CZRCgMoMxVJC6/gyvB83txcOttu2BKe7yE
    y1qgwbEhtMmZQTP3yFN+z8uB4TxQ8DhIjdnreOzciIWS0ag6CE6yDZXg/Ng4cjHEJd3ie1
    R+HlsqUq05/e08J8i68cvxXRIiF+YcPbM7mbcHGvOd8RadYV9gQUvTIburJHfjQuX1WjYb
    pOxrKzLR6/UuI6DfjHsfpeUtVj2/Wjopcw4kN0KkWKjKhuaN1iRGVEPkPXgNK9o40FK3mS
    er9+TSzgII7rLDLld8imsDwqSGaSL0a5OH4jUH1R92ZiXtVP4mGcUgPoZnfjkUlCqS0Luc
    c0CyEEzjg8dd5gqtoq68LvH6doALWCvJBvkkpgBgUEv1eUeiF1UPvRsHiSclWxLLeIHRth
    nMy3tgecccLrt7+5PZAjojhO3Q42OIq42+8dn3m++FSjQyr51XTIxtb9L/pA
X-ME-Proxy: <xmx:fZyOauROHBGFOFF06iin7mL_hPOoHNkP4YNuKQYu1JCDPOP5qmckEw>
    <xmx:fZyOahcoiqV3Y-MD8UP3vibmRM31FtMHhefpVlTik9-LhUPlD_fXqw>
    <xmx:fZyOamRSZ0MK5nBFOgxnMY60046Ku0QVk1FeWM2TQrGJoSeS4IGjPg>
    <xmx:fZyOaiMO_jyRJHvPN5ncfJlk0HcwOq1KlBJJ6dBdoojZ-LAcifs28g>
    <xmx:fZyOahtQRoPT3e4pbwjYVvZkpdo--mR0OzRHFmeFl2mWZmb7uYsmDf8e>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 26 Aug 2026 03:57:46 -0400 (EDT)
Message-ID: <79ab93f1-21a6-4c9c-b32a-f2266703e9cb@pobox.com>
Date: Wed, 26 Aug 2026 00:57:45 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 00/82] 7.2.1-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260825132541.560541185@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260825132541.560541185@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/25/26 6:24 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.2.1 release.
> There are 82 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Aug 2026 13:25:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.2.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.2.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested on my amd64 home NAS and an arm64 virtual machine. Working well,
no regressions observed.

Tested-by: Barry K. Nathan <barryn@pobox.com>

-- 
-Barry K. Nathan  <barryn@pobox.com>
