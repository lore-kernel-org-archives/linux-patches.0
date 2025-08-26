Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF25C3164A3
	for <patches@lists.linux.dev>; Tue, 26 Aug 2025 16:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756225419; cv=none; b=DLfGirbsfDkQ1AlbwIwCH7MejWLAIcxGfMAya6wazjB5qez42uTd87X3HisUA1ZNBuvjNfW31DeMcsq8Al/FK9DglRniRrSzOWiDSuuO+EO+DnvASu9d/nuGmBPrglomGuJVpI3I6I7EZc859aLkVCD+agmSAiDw+xajB5G+XAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756225419; c=relaxed/simple;
	bh=W5ID3OY7yfWGGgbtnZevjVWj3uINdDq2sxdewYF9kdo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B4qkpcFIrpd8wJmKlIwVHoNPoK+HGmfsB1t/ei4zPM84n/FGwuSJZbkfOIPlU2nNwlzW4caXB3WPVIQdz/ek9gOpv5SwE15kAOxAZ+5EONvbZ0AnAnk+8+RFCKbhvb0PU5M/GhcriRuJCsCRNCKoLyk0rU1cqs9HriYY7VrAgb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=KhlEYKzx; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="KhlEYKzx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1756225404; x=1756830204; i=rwarsow@gmx.de;
	bh=W5ID3OY7yfWGGgbtnZevjVWj3uINdDq2sxdewYF9kdo=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=KhlEYKzxk4eYrMBYwRrxWj97+MeHlwoVlfvRujAqIc1fUApWIHwMiCS2gRRtLVOb
	 cHxNGyLAGcOLOUYOpip0VInOw7QdqnNJ/qTUjihPrbLoMdGGPz6+UxNz6RGhltBYz
	 zccUk5igAZvZMgJB54GG3zrtprWWD9t2UF5S5/sMW+bMLLIV7uHlGSspL1mpdPpME
	 JAdGVvP5sqxO6ywRiabpuLVN5d9V2xEG27lgSIyrr377xws1GmNa9KDjB2H5d3zuz
	 uimCG4DtT9bhFnS4o68CIJx677JAD3keGGez3Bb8YGuxv6bAYfJ7IovBnYmFW+v1Z
	 X9W6Zo8SfZkZFHqyrg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.200.20] ([46.142.34.135]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MjS9C-1u7BIc20Rm-00h4FN; Tue, 26
 Aug 2025 18:23:24 +0200
Message-ID: <1b282d8b-20ea-4496-925b-759bd4911245@gmx.de>
Date: Tue, 26 Aug 2025 18:23:22 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.16 000/457] 6.16.4-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20250826110937.289866482@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:4lrZlQ3LJdUDqEOfFqdPOqwIpBAXjK2+Z0hGYszP6hLx7+mZjMJ
 D/D30j08qD7z5tbRQj59b3mpSgZWw3zRO+pdcloW7LJ58wAPuYzfSJoDPm763Ndpo6RnlSZ
 svCbbzZJjBKbCpJyNe1E4qU7LvQD2N0M654QDGwjhsW1PjMirREAL6DEeOCCMUZLJhcnl6x
 L7YFUqVQGOfDgMROz3KiA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:CnNdA227jjc=;cVqx1pVXcrfPZGEPOp40ESr9UQz
 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
 917HPkHzJLaLE8lIgTe8UNyYv6Bv

Hi

no regressions here on x86_64 (RKL, Intel 11th Gen. CPU)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

