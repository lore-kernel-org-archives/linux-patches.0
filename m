Received: from relay5.mymailcheap.com (relay5.mymailcheap.com [159.100.241.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF13F176FA0
	for <patches@lists.linux.dev>; Wed, 18 Sep 2024 10:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.100.241.64
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726653815; cv=none; b=MM5g0T60jQvrLnZNVAk5dIFQHGHvYfUu+u2uSvkiMdpcJnc0v2IdfssDgA+Sg1Yid3NUJUlAsw3UAow4/UuefKffFJVngW7Sh+bpflz0c6I3iVyqKdbMWcqnApmFvQVFGDYt4r7/7FxEhohBbFOU/t1cJlb0b04jmKgmCnkYXQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726653815; c=relaxed/simple;
	bh=hl8gQiNOJ+WDAgbQlfu7CzUnwfdJCS8hNzX+TaNuOhg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J1IzfGTs+CijJosoNEuETdq1Z9j5dvGCSRco3pUMGXQp3KW/s68rdPw5tCHmbD/HE9vlwMj57Br3qwAStbYo95Sf+ZNXap0LVGbmXswSj6kF30kA4TS6zqxKLEomgMD0XHO/M4zZpm/KRO/8WyyMUY/CummKV1+wSlw3V87tcT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aosc.io; spf=pass smtp.mailfrom=aosc.io; dkim=pass (1024-bit key) header.d=aosc.io header.i=@aosc.io header.b=GFxWfeUp; arc=none smtp.client-ip=159.100.241.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aosc.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aosc.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=aosc.io header.i=@aosc.io header.b="GFxWfeUp"
Received: from relay1.mymailcheap.com (relay1.mymailcheap.com [149.56.97.132])
	by relay5.mymailcheap.com (Postfix) with ESMTPS id 2D9172000E
	for <patches@lists.linux.dev>; Wed, 18 Sep 2024 10:03:32 +0000 (UTC)
Received: from nf2.mymailcheap.com (nf2.mymailcheap.com [54.39.180.165])
	by relay1.mymailcheap.com (Postfix) with ESMTPS id 23F1E3E870;
	Wed, 18 Sep 2024 10:03:24 +0000 (UTC)
Received: from mail20.mymailcheap.com (mail20.mymailcheap.com [51.83.111.147])
	by nf2.mymailcheap.com (Postfix) with ESMTPSA id C29E4400F3;
	Wed, 18 Sep 2024 10:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=aosc.io; s=default;
	t=1726653802; bh=hl8gQiNOJ+WDAgbQlfu7CzUnwfdJCS8hNzX+TaNuOhg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=GFxWfeUpUFGkOOuTUXN545X7t0SczoNbV3t00qr1Xa6zErvgnC+NVJ7ZN5mG4HWJN
	 7JWsedC+t5iSfrOaHMTFdMTCH/24nylufBwIPB0ZWe7hV69CnZrLfx2i/qZFb3aeUh
	 Gb1E1X7B4+bhIGO7hU9fzj68xAHciL+cn7tt2ppo=
Received: from [198.18.0.1] (unknown [58.32.24.203])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail20.mymailcheap.com (Postfix) with ESMTPSA id DC69D4141B;
	Wed, 18 Sep 2024 10:03:13 +0000 (UTC)
Message-ID: <d4c0e2c4-b5f8-4102-91bf-b07d2b9a585c@aosc.io>
Date: Wed, 18 Sep 2024 18:03:10 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Thunderbird Daily
Subject: Re: [PATCH 6.6 00/91] 6.6.52-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240916114224.509743970@linuxfoundation.org>
Content-Language: en-US
From: Kexy Biscuit <kexybiscuit@aosc.io>
In-Reply-To: <20240916114224.509743970@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C29E4400F3
X-Rspamd-Server: nf2.mymailcheap.com
X-Spamd-Result: default: False [1.41 / 10.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_ONE(0.00)[1];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	ASN(0.00)[asn:16276, ipnet:51.83.0.0/16, country:FR];
	TAGGED_RCPT(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FREEMAIL_CC(0.00)[lists.linux.dev,vger.kernel.org,linux-foundation.org,roeck-us.net,kernel.org,kernelci.org,lists.linaro.org,denx.de,nvidia.com,gmail.com,sladewatkins.net,gmx.de];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com,gmx.de];
	TO_DN_SOME(0.00)[]
X-Rspamd-Action: no action

On 9/16/2024 7:43 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.52 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 Sep 2024 11:42:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.52-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Building passed on amd64, arm64, loongarch64, ppc64el, and riscv64. 
Smoke testing passed on 9 amd64 and 1 arm64 test systems.

Tested-by: Kexy Biscuit <kexybiscuit@aosc.io>

https://github.com/AOSC-Dev/aosc-os-abbs/pull/8027
-- 
Best Regards,
Kexy Biscuit
