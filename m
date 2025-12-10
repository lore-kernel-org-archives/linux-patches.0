Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24AEF1E9B12
	for <patches@lists.linux.dev>; Wed, 10 Dec 2025 21:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765403381; cv=none; b=q8A20q9nfnun06hV6I0/xF079TcBswJ2/sJlQEUi3ICSKJw7BkY5iULE7Qfbc0cnWe6ynV9+lc0UsSafL/9mkZyaRJruUkQmeiwWD34dTiXy3HQ3PSEnxnWW60mDXSK0OqOcbrQYqriNsu+mTf0Kfw5t0YsyfQvNevQtIsNVRyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765403381; c=relaxed/simple;
	bh=W5ID3OY7yfWGGgbtnZevjVWj3uINdDq2sxdewYF9kdo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RR1XXnt2gBrvSnQL5nkLhdak40xobnZRbdXI5ahj+IjdPOrMQ39pq42+qKD6HnJc3K6mnkbwNmtq1uDkvmGB2M2Y58CwQZi0UyqfiMyOegpYcmRHYUF7i5IIY9vpTstWiaMDEvw1VB7CWpIrfS3HQCIHIyOGy7X9qfnGRCTy/FI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=kMMcw7/3; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="kMMcw7/3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1765403374; x=1766008174; i=rwarsow@gmx.de;
	bh=W5ID3OY7yfWGGgbtnZevjVWj3uINdDq2sxdewYF9kdo=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=kMMcw7/3tEUvm+TklNgCjpMyk/nWFF3YF9dXtD0753Py9HejcooTTJAO0jMYssyN
	 vBXfCEjpUMkA4QxyfKujzSF2ai7SKulgMzL3b86pPsLEsiowNNihxjvvq3AwY1abJ
	 XHdJPSeKtp+USts3wa90qCDGa4Ni4AD2W4HjOly5znb0KQ+COcok4lHffOrePmfYK
	 KMeTyHg9HpdxmCrw46lvTHrLBtIhFQCE+ZqzmXfKpmrFOMYsdF+H94+0Gb+ECwTPT
	 99gGoJEep0mi31T9GIf3/Du07PfzdQ53nG6/zFvI3bOSqDyfWFN7HtShBE+2jPWHV
	 xF1F8yNGOqdlZr2Tgw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.200.20] ([46.142.35.251]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1M3UZG-1vU01k16Sg-00ACcj; Wed, 10
 Dec 2025 22:49:34 +0100
Message-ID: <0dc3b7db-fbb2-45b0-b4bd-146fe2ec4286@gmx.de>
Date: Wed, 10 Dec 2025 22:49:32 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 00/29] 6.18.1-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, conor@kernel.org, hargar@microsoft.com,
 broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
References: <20251210072944.363788552@linuxfoundation.org>
 <4b1a256f-5d1d-489a-9c87-c38b4465a6bc@gmail.com>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <4b1a256f-5d1d-489a-9c87-c38b4465a6bc@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:ji13FcTrYryXUcIov6CA3VAHNMEdMXm0kKX2TsxfOmZ8hiuD5NU
 dSiGZVB7E+WfeNWbyRmBMzbVUMKe3Bej7G8htNrBP9uTeFce0K7rKi7tl/6H5CTisup1vKm
 idVr4nLX+r3nZgdh+qJT7ekvLN8HNyZKyoPbUPrnPuLvIKE/AjcIlKTATs4qHZUzhuGudrB
 r+x6Bq+badu2mkDS2qoLA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:ychKxEQFJ+Q=;a3Do05M6/reZuMarlzISQHyJMV6
 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
 vDgQ3xrLzpzHsMQ6MAKPHB8Zag=

Hi

no regressions here on x86_64 (RKL, Intel 11th Gen. CPU)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

