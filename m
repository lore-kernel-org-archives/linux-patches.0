Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08298347C6
	for <patches@lists.linux.dev>; Thu, 28 May 2026 21:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780003317; cv=none; b=BV3BYIwa/17pNZb6b5OzpWYPb4qtOJ9/wVEQEf2f0H/WU+1pF8kXg2PKVT411sEceeEJKXpm8NRB5s6Yky/bGyudg7C2wLReMPWrdb2pVrVNv2vtEkRpfKSSpKq3m63B+pOUZGu2oMeRfvLOw6aelyGXozxK2X+6TBFrf8TPLfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780003317; c=relaxed/simple;
	bh=1PO3YHl+btPykbwTM16jfcwADiOLFguz3RVcskKvjrA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SXbHjVYcVT4rbbH19Fl30vjFOR2BcsFjCzWwbqqKwgl6hoXkLyBMdcJiuAMCBd/FwVrHUpj7SXEOnmtHX12IAbM+bEnVO4jPR3XyArqWcUioLArWG1m5Zp6MbEce+NeSs6+PrY3vU1oj4GTgkDmxunDMg5ba0n2HRRFsHK/kKNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=WO8hkQ+I; arc=none smtp.client-ip=212.227.15.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="WO8hkQ+I"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1780003280; x=1780608080; i=rwarsow@gmx.de;
	bh=1PO3YHl+btPykbwTM16jfcwADiOLFguz3RVcskKvjrA=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=WO8hkQ+Ih+b0j0Vjkg1tGw7Fg1lrm4/Z4wbg1X0q8nQihXqBvl0c7auQv82mDlqI
	 gfQJTNTLOgo39qb6YCjaCixGQZvKtexKmGVfw0ou6nWi7PaRnf0g5z0vkpLsC9o4c
	 p3xBXWHfyzZYBxMi35wWIMQNaqGIbvcU5NjJ99aZg1RoD/niPSKVSMF3kK+r8YoyK
	 iSSMnQ+6Dy27hmClBjEfaeSGFczqdGqAehgN9M6IiljiEt1Bdd1oqmTd0Rw5wSreQ
	 AoeL4Mbimg4XwyrXYcEDFyu/+n6lqfM6jVXhH1dtO71I8zHifeG/yiq04XLnGGJFi
	 y0Z6eRiqYW03ueSgkw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1Md6Mj-1x2b592p7L-00ptNG; Thu, 28
 May 2026 23:21:20 +0200
Message-ID: <0a8950bc-ad32-4de9-bdc7-3c0eb8a93dda@gmx.de>
Date: Thu, 28 May 2026 23:21:18 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.0 000/461] 7.0.11-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260528194646.819809818@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:FQ2MsyYhs7KOPNvtv2qosR36TcwNCqfaCsFoR3PMyQpaxkcKYTL
 z7Zv6Wam/fzLyWeOMg9YDtI3pj5Quz3/G6HQqZkkFIxFxS6T4u1T5IxspF8P566oHZwN87/
 xhZixJvn3xDBgYpJ8KVsRVNsWO6FAdSegLtQ2YvsVR6w36fT99xS2F3c1eFbsKmv74gC7ju
 0rGWZArW0c8MUqeXiIekw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:HE98mq0sTKQ=;VqPHIe6LpzET/Q4vlxj7IWfjGDl
 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
 e9isDtghIuNyiWTrRhEsRaTg==

Hi

kernel build / boot test on x86_64.

No regressions here.

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>
