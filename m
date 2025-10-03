Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B18792DE717
	for <patches@lists.linux.dev>; Fri,  3 Oct 2025 18:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759514739; cv=none; b=TDAIMSOCH7MZykJ3Bz+3dtJRiTq+vlfimWCK5EDreEEmDAFgtcNTOBHfvnLzFKiQNzsCzS1UHSmJlEj1zaUPTyt9SNu0lg0zDkiZAvJmGWmAFdJvN8AZ+hcNPtestPHaPZtCPalKPa6c6Jq08dfDOVnuvOI6RckM2uPP4KeXIHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759514739; c=relaxed/simple;
	bh=W5ID3OY7yfWGGgbtnZevjVWj3uINdDq2sxdewYF9kdo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fqPWNJAG+2TL8AygJ38azbtZkAas4xLk00iFdKOdVI9mpC8yK2EP50Pf1dHiHJl5Aa8ECjCDy1/4kRJcoA7hAnkwidkOC8pKDwQX7n5mz9TX8e3px318w0pE6WdsYaoEifeV3qiyYOiFl94slBE8vgEl2xUaxM4492RByINj0wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=lBiNobmV; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="lBiNobmV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1759514720; x=1760119520; i=rwarsow@gmx.de;
	bh=W5ID3OY7yfWGGgbtnZevjVWj3uINdDq2sxdewYF9kdo=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=lBiNobmVh+u9scIHOx0N6Z/30Sj9XRr45ZeE+cNTSq+0flzcx1B6x9R1O2aXSh94
	 GyfkqD4MFA3ELIAAQCMKKnj6P5ESmsyNt99He4HlG/jzIPCDskJFfzWUC1pTct31v
	 6dhpEGE2ybjbiswmPt9VMtXydUs18yAXzVsQyESMpn6k8S3aVNj59l5+y5ve/Ys1N
	 0xHs6PDl3c7N7XaDLG1WCc/oM/OVUjGoM0TaY1qstGHVf7O/+DKx44Fa8OaRfSErU
	 sFsvug59kZPNBbM1RwkQamNRluIUgquUdCDtSrfaz8SSHaqJsvV6dtXaFdKr/mYDO
	 OUPO4gAyahl7B8VAPw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.200.20] ([46.142.34.54]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MaJ81-1ukD812S4T-00Ly3x; Fri, 03
 Oct 2025 20:05:20 +0200
Message-ID: <db988e53-cf5f-4529-8a0a-71779daa6e6e@gmx.de>
Date: Fri, 3 Oct 2025 20:05:18 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.17 00/15] 6.17.1-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20251003160359.831046052@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20251003160359.831046052@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:ZhcklcU7Se7NHy9syxLC9Fmjk3ll9tXKkSBxQ3srrgyvmShyEb1
 WGM8vQloJgFpzsuUwNt9Q6QtiNcP5rBWyrCwVEDqE3txe4ce/ZA1Y5zbPEW90uUxED4w+e/
 5FgW0gkai+ah9sWFrzY5cgesgb2mwmBNFZEqHtM2mI4bqnHagBb8LVOHhkgGnLhgsT/akRB
 qtHTvPoPByv6GJciIFrSg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:kP1kPEMh/BY=;nL+KQF78n95VV+fAbFa75tKduop
 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

Hi

no regressions here on x86_64 (RKL, Intel 11th Gen. CPU)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

