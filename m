Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E030F2F90D6
	for <patches@lists.linux.dev>; Fri, 10 Oct 2025 15:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760109317; cv=none; b=iXq7BlkZPWg7+4xj9po0SKvhdviTmKGX+xa+T1TgI6ZDxODNbj51Z22UZR34draFeTlSDPza1z46n3ny4rc+x0NmtShHaBobqrAuZW+V3GWYMw0wEuV3VjmAPL0rAQZ+kZvhH/r4kY3EyEJqMKrzGrxr4ppvosZfap4GmEqB7iI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760109317; c=relaxed/simple;
	bh=W5ID3OY7yfWGGgbtnZevjVWj3uINdDq2sxdewYF9kdo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FogqUxgcy5sefQHF3sAnoeBzbNQBcIZkfS2NHvS1DKSs7GI92vO1/9+JwHdNyasHbcgjUOjO70a+D+QPl2a6lBYseXSG+ciEUchk0otD1+nxZl2sWLVjV2c0M2r6gZ3+OMWAleWQLsgDerjpT2BMw6FDpiyOjWuiXh6Kk5+R4os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=NH4qBqrN; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="NH4qBqrN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1760109298; x=1760714098; i=rwarsow@gmx.de;
	bh=W5ID3OY7yfWGGgbtnZevjVWj3uINdDq2sxdewYF9kdo=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=NH4qBqrNfivTMyOZDKfLpvDwvxR1d/zh61pqMysH5mDcxevXOa7GsoKIM0o8T5J6
	 pf9KlMWW3Jbghe1nTfGrMtGONt+jglNnsQxSpFhUlMHkyjj8ZMF8Nc9Sv1eWCo5El
	 0WuFtkMSi/bOzRcyep3e8GevwWd00ZCocC955s6LmoXLvXximQC9q9kaZAbc/Hw99
	 SvnkXOPyJWMXkufveb35grjUmMMJPuRRrZRMztztN9ddz90EBJzribyyEtgCiwYZy
	 RMQxIN5E/W/FRHM65zZYwlVTQiLuJ7Slxp9QNAbhWmKr7ZN2sIckr6xi0BNYe1SSq
	 NDclGH9aFYDEu45mAA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.200.20] ([46.142.32.48]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1Mj8qd-1udQO42qFp-00aydJ; Fri, 10
 Oct 2025 17:14:57 +0200
Message-ID: <31a32273-9d8c-40fa-9853-9436c2e1f077@gmx.de>
Date: Fri, 10 Oct 2025 17:14:55 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.17 00/26] 6.17.2-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20251010131331.204964167@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20251010131331.204964167@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:o00+2uT8W+MiKX7FrXifbtdLoO5KiBOeEyv5v+X5wM4WbBlQiQ0
 17MWEcNkqOWdmHXDd7zf1uPpUOtI2ptHVhkZBlVrXIzIVWa9Hq6jM0W9gy540GuOeCS0hxu
 LibmNvEoRCse0aCLGlpX7R///czxInfwIKeARnNjbCjVY8x0k58CM1ebCWMutv+R12pZMyd
 FbvqhFTQhpwlU4sZJNSrQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:qDNdFgtyHPY=;aE5s2vcthEZvW+9mhHn0oKdMQwg
 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
 EBgTizIQglDaah7snYtgKZw==

Hi

no regressions here on x86_64 (RKL, Intel 11th Gen. CPU)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

