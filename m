Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFF5F170A11
	for <patches@lists.linux.dev>; Mon, 27 Oct 2025 22:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761602448; cv=none; b=or4tJVtQ/mwjObdpx8CFQU1SW8/f2f8jRrk2HM6BNoqyt27gLwbv6c7Utk7FmBaYowGjCM0zT8HJoZHfQqIlBVUKsXPpP2H5Xa1LIQSQaR6/B1WCXE/1z5HfFqmIH4vFpMne7XRPLlqM2hOkHN2vZqrPV7u4/Qbsn7lPq5mpSIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761602448; c=relaxed/simple;
	bh=W5ID3OY7yfWGGgbtnZevjVWj3uINdDq2sxdewYF9kdo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UkmP7x2sKz8uzrIzlw1hWozT6VJzjIviuM2QPawrfCbDLbTsckOHF/nlx7eVAfLwEjl8L3sMEb4HByUJD5o7GUhUVbUvE2gOrNwed8HD7y5G0qjD787sqZNvP/aHljwJ+iUgKwM6Ql93UohZ0mFQkU8ToCeCVQiwtNIyHW2JkWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=d+3QOGnh; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="d+3QOGnh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1761602412; x=1762207212; i=rwarsow@gmx.de;
	bh=W5ID3OY7yfWGGgbtnZevjVWj3uINdDq2sxdewYF9kdo=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=d+3QOGnhyX9R6ql2Cj6Czd644bknPjREtiVlrDi1uXqnUlf6vR2X7xgZiFi8GXwv
	 p5F8uiw+dt+HKxJvBnTrUl63k6CaIc3h1dyKBJOTTXM6azYAJ2tYKuP4n5kFvRheD
	 pi+ZcAoL12XJZ37EGO9NwKwIgWkKZo0bYVyrNE4Em9Fs1EtV+ptpl9Z4EAsefDU1f
	 2E2YXUY2UM8VMU8sAwWW2yi/kdNjsXHDxiHhrrFSPtWm08Y+WSfyz+ZglsQi0CEfv
	 pc1EvfbRe6N7nj5ftFsxEj1KtKPRStwBOtXNIEqGew1+OVQqJpNF2VcVDzaoGijzv
	 MiS4JwiDkNsRYo+Aaw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.200.20] ([46.142.35.117]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MmULx-1uV3gg3tvF-00hVV6; Mon, 27
 Oct 2025 23:00:12 +0100
Message-ID: <25c427cd-3080-4cfc-93d6-2b4d082b1166@gmx.de>
Date: Mon, 27 Oct 2025 23:00:10 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.17 000/184] 6.17.6-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20251027183514.934710872@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:ZyVI+iOHmHeGG6Innqqf+jIfCnxkLJ8tXLF2GtY4X02xlbxH9Qt
 PIow7PLbcjBWLNhM2IM8GFWEI4yBfMfuBvb7iFBflC/pDkLXUkWOkaupXgk/4AjCSDtkm+5
 i498K2gBx1fR8KWHmOyFfX5jr53ruD7WEqem2/UO+d4TAUXQXlIb+TLLJjl7CqTgtdjoSkk
 jGdO9IxNROUH48tVE3WNw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:mSphpQ+XcXk=;2vRlWtqWoN3p+qJ1Zj/leuXxHRQ
 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

Hi

no regressions here on x86_64 (RKL, Intel 11th Gen. CPU)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

