Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048322;
	b=w/NHFHSnG8LWq9oVaIYp/K9foPmL/E/JsDzO4h4SHCjBMh8paLnwfjc0d+4TB/jgPZ3C
	 WGotr+jSzrbihBOog5vBukx6Rn4YeGE7diUUPJv0GhNK1TRaKI6tR8VgRgVfU8uhOrsBE
	 J0C998EODuKqt9oEOqGl5LJbgsYQnp8TszOWnzFueSuwVNwgRKrwAM4e++Ba0z8uQK1H7
	 clCXsko+OD7SsUg0clSqVTSbivPCSCrqpbPpmCrKchOX9hZu1zgLchGRHKN1q99+YYQHt
	 e9nzl10cNUnFx4py1d/8QrVx0YCSS9uGOie/hrgDeAC9tWUoN9wErXzzm/gvTwukvqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048322;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:Content-Language:To:Cc:References:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=EmJ9n+7z7H7Pdfstw1q7EPzAbXgdZ2VMyW5XMf764DE=;
	b=J8SqP05JWI+ajl36c7mm3DQfwjMN6fOg7173j2+iOGE3wqi4RVCOIOUtQmCvBLWMeXlT
	 GokCnxo/BRbEuLb/OaaeyaNnRwU5CzC9OCEs5chrC7EVAZxrESmshwspsGLBse6R00N5o
	 p0PaBzBZZC1RaXYJcrNpzFzQBnCgx1RRN0EXEFbDaA1w5wjq8eyfbHKhO/uTvF+pDWrai
	 ug/JAmp9bIAjyW96s4u6qE2WoOSxS7dVyDnrAC1qbxxk5DzBUoQBmGmkCFm+wzXXW8Ebi
	 cDfbgnCmsdf7OCAD1QODMR9dUDoZXEiUP/SNtg8z2U4abpiP7TNYSkwEyTWAayh2JYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=googlemail.com;
	spf=pass smtp.mailfrom=googlemail.com;
	dkim=pass header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20260707 header.b=BzOn8aXZ;
	arc=none smtp.remote-ip=209.85.128.50
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F853606A32C
	for <patches@lists.linux.dev>; Thu, 19 Nov 2026 00:32:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0F853606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20260707 header.b=BzOn8aXZ
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4bb6adaf0f1so15402495e9.0
        for <patches@lists.linux.dev>; Wed, 18 Nov 2026 16:32:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20260707; t=1795048320; x=1795653120; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=EmJ9n+7z7H7Pdfstw1q7EPzAbXgdZ2VMyW5XMf764DE=;
        b=BzOn8aXZord/tvjtPRwiTen3xwUOw7pBuzuK2I/qSJ2z/yaAlA3r+61bq42TxCHDqi
         /rtUaoXLtGE94BVokC3plTrYzMPRutN33Cgjdc1Jv3fsjsEVlPWkFqBZdR3Q8zalUhwz
         rV8nQ9Uoc06+HHvzWa+1m52t4NOHlr8v5Ymqe7a3jznuZA/VwMQjFK1JO11za7dd9eol
         f/RjCtxqgKgWkb5n8RQS8yv87R0hKEPWHCq3v4SZlfdx+75LbDOcDZRCUJhS2QI+5QZd
         55ZqDb+1ZBfwhrPS7SAuxRgfCCSJhpRBOHXBOh7Bb1ltdOuayp5JwPIsIruxLxiXK4up
         Bcmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795048320; x=1795653120;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EmJ9n+7z7H7Pdfstw1q7EPzAbXgdZ2VMyW5XMf764DE=;
        b=yLBYFm3xEdYwhjiOtFKpmru7tGgPYNk+yU90S2+g+++D7rz0VlR50yHqElb7s7BqdV
         v6EqrUn2g33hnobVa9l2mDbA+c6T1hDC8Vl2zkN+A/sOD1ZQ7F/5ielkxuERfE91r7m7
         YCMdCVhgCA/QFa/RSzDwgJnbXGq1s3KfA6YBmJzBex/b6Ccne5HHEEFYvrs1Ba0iEGvn
         xw5KyGNYaGHKdrOdCtGGzlMKaXG5RUCs+rMRJSMCSRYzGmHqY6dhjMQwrx9XW9ThQ4Jl
         FIgAfyCXWI40IzqWuC8cn/W8A7y28oFVB974trtZ5UXEjdvSPa75J0SexZ31ZfJTCIhQ
         dvLw==
X-Gm-Message-State: APuU4Z96vjqyFrk/0OYzLN8IsPAcQRtwMdoZHxC2wpL87NLg7S6LHFRr
	dP+QghX52Mgonfex4zId8acKA9JQf7yfAT6QIY3uBgL7kaqF4GQdm5o=
X-Gm-Gg: AYBFou11yRRU2fGrsKcaTWLRrzxDyFS0+KMAIy/os2OxoQptcz7AwUz3B5OEMcrM/L/
	3u96Ds+EeZ2awr/SNnDtJ9n3s/yBwrO8mv3LXjfeEY7ZsAar7+auvhqIsU4dZvu5PoSW3c9SSqo
	rJS+PcvBkvXJs4dQQq0YHswRBEInFGi6sIaSyHNBLuvvyPvfk2eDfn4AOm8WH387TWjT1aw0gTa
	q3j9SBIXhkbz+a1hR/r3OfKjJKNWqi59tG/WCFVmK8KVm/lhuL1NiEJX6WDgB50Tck+f7fd0/1I
	NQjjRR8yovzbPXYvsb1uSd7svh0m2aClITUspT/o5wyzmCWUhtTIFJvQr5kp92p42LU9cbmIu0k
	+dWGWppT3Tx9P+VNaXPEq6Luu3qX1Lezwl9YboOKrO2Q1fYhow8Y/Lbn5VXJg+QDLaWX9oeoNiM
	eTb5AlhLkk0SqHV2OeCNQTwuP0UKf5nas3EbOHPIvkJ1ASL828v5S05X+0QcyCkQ1cZ5iuJUeO/
	YRTK8vVryY0us7G8kgzSRFx38EiX+XwGqOwJlsEOrw0SMx4JrS0qBshi7iL1CL3J142QzqIZ6uk
	SuxoVu0/X4VlxsrUvVvDm6gCcgAPj3poe5qaDNlfcAirWDwLTSkxBNtcPlt3wLq99Oa+m++4QHz
	8uqhl/ud1gNyzU+gcQ3i6iGUZAwU=
X-Received: by 2002:a05:600c:8b05:b0:4a3:12fb:1ef1 with SMTP id 5b1f17b1804b1-4bb7da26eacmr82453255e9.29.1795048320249;
        Wed, 18 Nov 2026 16:32:00 -0800 (PST)
Received: from [192.168.1.3] (p5b2acb64.dip0.t-ipconnect.de. [91.42.203.100])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb845095dfsm13761465e9.5.2026.11.18.16.31.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2026 16:32:00 -0800 (PST)
Message-ID: <62c31ebf-0752-4208-afd7-57baae9fd73c@googlemail.com>
Date: Thu, 19 Nov 2026 01:31:59 +0100
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 0000/3318] 6.6.163-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261118150313.527275416@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 18.11.2026 um 15:10 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.163 release.
> There are 3318 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

It's really a bit scary that the "new normal" these days seems to be that these RCs are so massive, 3318 patches, WOW!

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697v2 server. No dmesg oddities or regressions found.

Tested-by: Peter Schneider <pschneider1968@googlemail.com>


Beste Grüße,
Peter Schneider

-- 
Climb the mountain not to plant your flag, but to embrace the challenge,
enjoy the air and behold the view. Climb it so you can see the world,
not so the world can see you.                    -- David McCullough Jr.

OpenPGP:  0xA3828BD796CCE11A8CADE8866E3A92C92C3FF244
Download: https://www.peters-netzplatz.de/download/pschneider1968_pub.asc
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@googlemail.com
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@gmail.com
