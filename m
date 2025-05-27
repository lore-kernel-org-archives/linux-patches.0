Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0CED1DF26B
	for <patches@lists.linux.dev>; Tue, 27 May 2025 18:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748371956; cv=none; b=kJAGGDY6XpN/uWSmYbEr8cDRaVg3xMFhflPypIIgcx36oqNvng4PM0zq0T2SG6jOAtdUnEwqZ7FSKgst4jYSGAX41OWpX8ztkVrEiVIjuINTXv4GHggx0L1hTReqGE/oSxNk/sLswJ/C1SDnrLdPdjxsq1IkGtJJDbopoRhVqao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748371956; c=relaxed/simple;
	bh=HtuFhXI63urBA3dRKYyXQ6GHreCYVeNttV6YM+zDLlM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z+UxHCmK0nPPw/BqFehnW0tWo6wHZsUt7F5FXcmqGoZK4NP5lPSbM70KC7a1icuap8vLUKzUZuUlon1zcOtUIeX5XOu1aSa35vpo9ViBNeV4Sf2ggOdjCLXOT6T7vOzXXMp6dgms0NMpBqgaabqV6GB4gIeGr6owQ27w9T5z7P0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=ZhFAQWf/; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="ZhFAQWf/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1748371923; x=1748976723; i=rwarsow@gmx.de;
	bh=HtuFhXI63urBA3dRKYyXQ6GHreCYVeNttV6YM+zDLlM=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=ZhFAQWf/XerVWi0dnSxwRKvnPzd2lkSU4ftv4RkTdQFkBgKSZQZcZyCsHYNdMuWE
	 Aja52jB68ddQq2/kYkyuy+fySM1Ye034Twbuf+BNyRjnZGPuEuxxL7d6j9h8gWFWr
	 hex1XurfWuD6OICdzXwiWq9ownQCvAC2OTb3vnZ/QMMaqPBIqkwoECBuwd9S4NzfS
	 u7Hq1cHKR5yVAer0oqqKuS/l6UpouNOzuxZcyP353FKXNXUGtRQyKp3ojXybhQUsl
	 XPJ4EnCcLcrsm5mxopQNlCv936XxeDSR5+bJd9j2ZJ9AGqFqKCNXP8Bct4KIIwp3/
	 xWgK1FsB3tILc2Pe9g==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.200.20] ([46.142.33.72]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1M4b1o-1uILVk3DOQ-003iSS; Tue, 27
 May 2025 20:52:02 +0200
Message-ID: <ac4521b6-25c3-4735-9f2d-536bf2ef1c88@gmx.de>
Date: Tue, 27 May 2025 20:52:00 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.14 000/783] 6.14.9-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250527162513.035720581@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:P/2q1lodxNagBT4Kt3xgoD979npgMUEGJadMaZeuCn+QxoPAVh4
 BnvwPQk7IkXxyMU5Jx6NayEbfNd2M1sqBsYUY/jwTr4LITDgE4qXbrVgvRfMTwXoM/69J+F
 xScewezQO/9XZwfBp50fw4U50w+pw+2ygtHqBnwhHDxuv3JihGgPseExqSIr9AgFCYQT4/Z
 nkgWLuxk/rP3NWMxuY36Q==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:bm14VE7LJtQ=;cMbMP0zppa3FCJTelJ1Jy2s8ipk
 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
 YTtI=

Hi Greg

no regressions here on x86_64 (RKL, Intel 11th Gen. CPU)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

