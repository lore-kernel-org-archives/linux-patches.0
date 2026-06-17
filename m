Received: from fout-a6-smtp.messagingengine.com (fout-a6-smtp.messagingengine.com [103.168.172.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CBB63A5434
	for <patches@lists.linux.dev>; Wed, 17 Jun 2026 09:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781689601; cv=none; b=sNNcZo142OlFrzWpEDk5zoL6rrrPHBva1qJ3Rnfvv+0ZeZmCdT3rreett8oY0NvbdCGbVnW30NgYdsQtkOwS4w3TahAvc0NTl+TtbgS9M9AmiPQCpBPsnz91emdHtfQlwEjqd7N5HWn7I010tjzV4dOETwvH8ZaoMVlcy7E9ebA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781689601; c=relaxed/simple;
	bh=xAqe/8U2yGUbThMQKi1IkcJCEV2Y3uLy22DWmUEApC0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tWsiPqGCOwfZChZAVuuSe7qsxbTdTcskAsZNAlCw+VBUeDeaU3PhvIn9+u1ecJ8nG8N6RkoDbRE0DLvmZqkmUMJZfLiGg4F6IzkARhX5MMZQkkXGd4HR0Q9rNe89iUruEdd2NlV54UwDBSQWBGjCCFisDMZG5au30qBlsiUeMMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=B/32yiuD; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=du0WyXdg; arc=none smtp.client-ip=103.168.172.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="B/32yiuD";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="du0WyXdg"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.phl.internal (Postfix) with ESMTP id 69796EC01AF;
	Wed, 17 Jun 2026 05:46:39 -0400 (EDT)
Received: from phl-frontend-02 ([10.202.2.161])
  by phl-compute-04.internal (MEProxy); Wed, 17 Jun 2026 05:46:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1781689599;
	 x=1781775999; bh=mogodG7pcrCiKUsu7dKMewLglswihOIGnqfNWlGOzx8=; b=
	B/32yiuDBi2lpJ3ZPrrzpvLjOTqIkaPIs9EahU/txqcXLBReT0KGLZZNWOwuGwaY
	YXvt/A+DP0jEwcRihddVu4Fw1B2Q4T75P2XCrwEfeBN4ZVOFlEWS7Z7D3lScQZi6
	Xr1O8tGIyXwNf/Ubhfh5SA3SdIpoXcEM59Hp1tIJp9WOehj3F4a7dNQhkijgu+B8
	8chOpPyxj8bjqBC4sUiIximqjAJVHqwrf+q30by4o3Seddjz6ReqH6kX+3VxCec0
	Eg7Uji+BukWXfOWYyrzLmNG+JI/vI8M2rXVQdNVBHiG417yuWeg5xnzH0xE4K99D
	lkbX2IQa83n8vpeCFgZvlQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1781689599; x=
	1781775999; bh=mogodG7pcrCiKUsu7dKMewLglswihOIGnqfNWlGOzx8=; b=d
	u0WyXdg6fmPSxq/3gedyfC/xDAxoN6rVImZu+lJVANZjCrcqt/O2r8GIRtFHnd7z
	R+g1JLSZRnm9p6kb0mVdbhyC0mlx0nzAwobZDjEvKk/aH4ReR5x1y8seNImiZ9j5
	AnMnCY9bwld4C0xEsb44da0BAzfs7kkSaNLQFCJ2JDVv9D2jZRzoVfz4JFeC5Dt9
	nJ559r3sS0HBwygqcqCp0onQtcYvRlIo0eqSHv2/NDozETqapwfE6N2kei0Q8EWG
	Ubm5gIrPHpAHMw2L9nPeMkdhl/JhpnS0bNCjpsgeVVvefj5QicsxyGQBkNZEWRvM
	KpSrop9jmCdwVOk1T9J2Q==
X-ME-Sender: <xms:_mwyaiiU8SRSXyTulPHXOEmoi9_pT1_zhYt7AY8kmDlUY61VibJSSg>
    <xme:_mwyau5T2-ZLaz6qfBzqwvSdF2XHznz52l6lnOU0kEBBM7NCaRsF0ZMEUzFTX2LCi
    3Rh7CDKHOPc0F0yo0f3AHwEGrbXmZqt7NFBD0s-uHWDuZpr0Ni_xwo>
X-ME-Received: <xmr:_mwyall3RiXUvERwPwMqUptrdrhOaSbXujhc3gLK0GdpSA9ZfGauhixBhHLQhXneAoPetXB4_yFRsj_rKMwXNHrn5xOHZ2zW>
X-ME-Proxy-Cause: dmFkZTEtUkYpXsvlu3vF1Efxo7cKDRm7QTRG0dyYph7GzLNBbqcTNMzdurQZb0QJIWBeQv
    CFE/o6qwPa8NsbO2vSbcM7FGZs4HIMygkj8yHeqJIy/79UAPaKJ+oJvRVAcc5IYRpAZcmh
    QEwdl0QPwIp2Et5ZdSmQfU7TZmGjiOE6BzpNPlTflUY3fdSDyU51fSAVa8IFFpk7jGDto+
    QZgyCeI0cgzf4VFeqCjl3ardLsncVvqPtHwd3MyseMhb9mZuIi9pFHkvQGKsK+Gbv/oatP
    ZN5Zt7hKmXT0YBTGmZzXbWB4eX2C/k1abq5RmoMzruEsP8OIze93IjApyoK/2Xg8iPLzED
    j4DH5Z3kNt2zriQ58f3++m6ovval02rDJirg+N9smNq9excavfyuizos6cDEKsBvrD42nE
    4+HGOvpnFov+h7K7PMPaldtHJVhEXTBlX2dTCmhFVAdR9aKjXy6q31ILRzsdSgk1dDCBrY
    845CMrnTOKS8abip9b+vs05OHoref5BgLfNQPPa5BXPq69Q+1Qrxp74UCUqSZ/DngBwN1S
    dGTaxuMN9lsK84Di7TeLs2kMFuy06sWCUTtWAfvflPW9NgijkE/OyscbJXs/BEAt6p21o5
    5LhtlacudGNaPCmOqpEfoL/UGTLjLdwcoalkPfa+QoVWR/mXLlWmzVHMiccQ
X-ME-Proxy: <xmx:_mwyavOwubVHqZQ7KDwj4k3Uc3gK0at18X_FHDyDU97VkjtOpzd5XA>
    <xmx:_mwyanpieopgR9tz9ark79GX-jEKBUWYSmvRmnG42NpgaoYZDb3mnw>
    <xmx:_mwyaosgaT8mnv80DHWkfOiZSTEM-z0f0-aSXEUdMx_VzUGG2KZZpQ>
    <xmx:_mwyar7e7QZfwcVVCxPKMOeA1UX2enSgJaWrwz7W-4q7r3R6oe43xA>
    <xmx:_2wyah0ndfP6brtdhROD6lh_czgWTvBJbY7--PLjJx4iuKG4cCIYzJ-W>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 17 Jun 2026 05:46:35 -0400 (EDT)
Message-ID: <d0a4a3ca-e799-45a5-978d-9d81fea2a9de@pobox.com>
Date: Wed, 17 Jun 2026 02:46:34 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH 7.1 0/8] 7.1.1-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260616145523.335696673@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260616145523.335696673@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/16/26 7:58 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.1.1 release.
> There are 8 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Jun 2026 14:55:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.1.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested on 2 amd64 systems and an arm64 VM. Working well, no regressions
observed.

Tested-by: Barry K. Nathan <barryn@pobox.com>

-- 
-Barry K. Nathan  <barryn@pobox.com>
