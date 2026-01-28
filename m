Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE68F313E03
	for <patches@lists.linux.dev>; Wed, 28 Jan 2026 16:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769617925; cv=none; b=G8Q/KaKRHKYH3zD0wnGiBNZ7s1LQQg45KcaC0aUrIlk9r7NDR/uxeeKNsSXVqJYnirSgwzHVsot2pV4QMzF5taOGxe2yK7arMd6SfkdgDM7/uVx3ZoiQVb2/c9LDXE+OSTJpqHVvay6Q5PVUOF4gKM5O/9PoEkgF4vvlHAHoNdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769617925; c=relaxed/simple;
	bh=1R+q0brxT5FCSRMOO/LqKS2K1GLvRDjYnI692aiflvw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qu2bq9hlwaPcsHm/zmRYMdXNDj0Yc02ONMunurGbwA3Vt4+8UzF4Du/nh5nka2MnXzzMHtji3Uo3qxLap0kVtdDH25+CyYXN0Vlom16jshUtP3qeYZDHPyhrowH/3IC7QnGO7Ql8g5W16ZrgdHu1cf3ZLkymHmMLtMTyK9Xi5lY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=HnG9cqSE; arc=none smtp.client-ip=212.227.15.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="HnG9cqSE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1769617920; x=1770222720; i=rwarsow@gmx.de;
	bh=1R+q0brxT5FCSRMOO/LqKS2K1GLvRDjYnI692aiflvw=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=HnG9cqSE2vlOTUl04CEyvwm6gGSzHFiUkp3iJMGhPQzvpTLLnS3cqtCWi9up+1JL
	 h4kqQ9eWQGcdf57+uc/bPjvEnqZNdFXVi2ci7GtbJnXYWosdPYjXCGq2EAvujwJ4g
	 tsI1cz8ktJrXO8Se+pprpmAzLGe5GkA7ov8efrpIHOWgcW7AB2qg52cv0g1qTDGJD
	 BAI2x8WZvI9aOqvN668bdGzcYx8YUIoiqJxF1/pb7E3nZDXgF3PbJTmMxZUXz8sOy
	 1RVhbkmZCdEGx/eRi5ljKINMezUxkqsyu2cX8pudfmKJHFt1ua2Wl7khYN2ACRqwI
	 dIJi0aKRRpOEmk3/+Q==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.200.20] ([46.142.35.73]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1M7Jza-1vfc9k0Sdw-004S4f; Wed, 28
 Jan 2026 17:32:00 +0100
Message-ID: <200da7e6-a4a2-4eeb-9638-4c292fe40a56@gmx.de>
Date: Wed, 28 Jan 2026 17:31:58 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/227] 6.18.8-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260128145344.331957407@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:RLbLq43jAfoj6hLrHnc8XR1aTgibJN046YLNR267LmPTcNuETzu
 qGWi8HK603eHfY1khBGfQn09xuSLUP4wRr5BUiofd5YitwhqlyXjPdbmqnXj1pYRyHoIKZs
 JdccDHUYPrWsA0umPl4lvSrxf2PQZZ3BN5g+nCusjUSZvAv1bHPPxJDzYB4SbFqveMV180z
 UWnACNAcr9XYjrQKeYWqQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:6v5DzwKyp54=;UlEcmky1qE0zxqPNZVtJwQsGCyQ
 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
 GBvailkhdbCM/GI34=

Hi

no regressions here on x86_64 (Intel 11th Gen. CPU)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>
