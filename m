Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D308528429
	for <patches@lists.linux.dev>; Fri, 18 Sep 2026 20:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789764330; cv=none; b=BmMyAA4iOIIsXLshOmn6iTcSTQJPEo9BcHpWsDcALl+Wutm61ChnP2kkgR1wpU+QbxPwOA0DnJYSqJkcgUGWVaAiroCcXZ3FuF4g8FyW98yTbwjZAzivgTZqE1ozIDZLCV7DNq/wpcAi6PEkEqWZLIUAOAqMdqdCEIEWFocOtLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789764330; c=relaxed/simple;
	bh=BomUviBUNUQlVkBMORra6e4cgkHHwm0n78aJJsEbh2Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VV4VBE7m+d+rvyfQrWDGi+n4A0RQAgO6ZPAdEKLr7P3Pq/YefZ025n9oWXWlUV34scfGSEr+Hl5s5O0tY4zYHXYA4KXJCvUPI0VJb/qoHvbnX34J+PO2Y1UwVaXtMsusinCEV85KsmEUz7Xgk1ojRW+0G2FrkqdGrRIMf6n1pqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=lBJfR+lu; arc=none smtp.client-ip=74.125.225.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="lBJfR+lu"
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-482f6350faaso635918f8f.0
        for <patches@lists.linux.dev>; Fri, 18 Sep 2026 13:45:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1789764326; x=1790369126; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WiR8DBDsif0mC1j33ACiydbHhduFs7IpyrOda9gWllU=;
        b=lBJfR+lu9kkc80uQvmhrAP3rh8Oo09OMqp/zqORVC5nvfg2jbugvM2sx9HGyBChrZ2
         g9vh040NS2Ou+Gch/swfxKOYNxS/rWT2JCjOto5xRCk7xqIA//Lj3x8mOQOY9wNTakBo
         r9Y0knC5u3fhga9zs/GgsdG7S1N6L3MdrqX/pId4ty9fBh38kuiL78UAA+O4kQZNeVlE
         o6fmyN70EiLyp0XPZOLJyajeY9RVlq9SU38ZH4CV58QTaEyGaxQItVPF+bEzxSV62SUM
         yC0/WdKR47GQPPThuAPw2Z2H0ul1plODEUkgbR0zPI24e0El7HSeGmr48ywk8WNmzCoq
         qhbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789764326; x=1790369126;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WiR8DBDsif0mC1j33ACiydbHhduFs7IpyrOda9gWllU=;
        b=m0wgX+dDWg4ZvcnQLmsGR3vhP5b8OFBcDfcxsw98O9IH8o4hH8h98jPTr1gJpnTkjQ
         WgycaUlXmgDpqgIAN0eR5hS7L920HYmCT5sf5WR1a4wwtzojGa/ma1V3xelW41cEzLoZ
         e2mwr5w7Fo/PxtQANcgILjaiHe+nhNNDif1X//fmA6Bm3VkrcWcaFuWnc1rcbXUrDv9l
         hx5HGgzJN3SRps/ny12hxYQQQayabkAdwNmlt/D3xBioLZ7qPGY0XXAMtrrCO03Wkw61
         2SLOqEv99OllT5ShOTymrpa9fnxEBglTWVDszn1jxPdAGbtW2OtWB3jF5NeXO1Xg6XWv
         9kYw==
X-Forwarded-Encrypted: i=1; AKwUvBzrZI7rpfz2gH6CdGQWK10pulWY3fFTlzwySWA9feV5aKW77CgcTf+Tdxss+W0PZ1mrMfDDQ8Wl@lists.linux.dev
X-Gm-Message-State: AFuF++lxbexZHeqiWfmZ0u3X4biLke9kcCjHV9KKes4jeW/AYnNj9R9U
	r3uBmeeFidJJzCLCKtoQLiszR2CpTCpr1dVk25vLsVO84ZCiwiZ5RfU=
X-Gm-Gg: AYBFou0bTvO7PsPTjs/C0DMGRoUnH7it5ZHOM1r4duBYEvWViAKJlrBas3gpEUcmqN7
	RBw0bY7Ys+/Mdv6b+Pek0siLOMLecKTfxMafNJv6wmP5MmPQyooyK0nFmwvgV8s5PSysTTDijll
	mfEojgCNWZ08zimyjo9vGkr3EumGuIwp+90mNFnzS0PzZO/izKD3Z4hr4m6u1FZYkAfYW/ac5Id
	XQw/zsKeUAJKcmaACMECE+fAHatflNi0koHTmp6q1sgUUQefuodXpGcebxHkFXqbuIA5maTcVlG
	z+ddxj5KopiIgwDDyAgSr9kwHHbWs4XI/MEDzgSSkSt+FlStyku0wWyFHL6EMP8bBBnOU6BmDaM
	LLAJHae/qr0b9MmmoTJnm8p+huGWsWCp9GKmRkvUrdnclsML78fLkLaGMAt0XAfsBvpPzZvAyus
	TAESMBGtEpbWCgL2QTSYnLRDjts7fItncXyDfDIz+JMhv8ZKFux6s703QWsGZOxostyPB1Bintb
	sXhMR2+dxgoye/dPyWyU14qTu8ME2dELXG7FjyfJeBRyl6TaAU=
X-Received: by 2002:a5d:64c8:0:b0:487:fb0:9ff with SMTP id ffacd0b85a97d-4871e2177a0mr5879599f8f.22.1789764326000;
        Fri, 18 Sep 2026 13:45:26 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b47fd.dip0.t-ipconnect.de. [91.43.71.253])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-487243cede9sm1480767f8f.0.2026.09.18.13.45.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Sep 2026 13:45:25 -0700 (PDT)
Message-ID: <8c3677b0-4def-42d8-989f-b0934c686f6f@googlemail.com>
Date: Fri, 18 Sep 2026 22:45:24 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 0000/1102] 6.12.111-rc1 review
To: Sasha Levin <sashal@kernel.org>, Brett A C Sheffield
 <bacs@librecast.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260917151539.408551884@linuxfoundation.org>
 <aqxBBu5GXVhHcqTz@auntie.librecast.net>
 <0dc35fd5-ee4c-4140-b154-78a49981ddb7@googlemail.com>
 <1e80f4b3-3919-4568-aabd-f0172581831d@googlemail.com>
 <20260918151140.2101477305-sashal@kernel.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260918151140.2101477305-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 18.09.2026 um 17:54 schrieb Sasha Levin:
> On Fri, Sep 18, 2026 at 07:49:48AM +0200, Peter Schneider wrote:
>> So I have bisected this warning, and the first bad commit is
>>
>> [af5775004c9c02f37be06d2035a056b6abb1cb6c] sched/fair: Fix EEVDF entity
>> placement bug causing scheduling lag
> 
> Thank you - a second bisect on top of a reverted tree is real work, and
> it was the right call. Dropped from the 6.12 queue:
> 
>    6d71a9c61604 ("sched/fair: Fix EEVDF entity placement bug causing
>                   scheduling lag")
> 
>> Trying to revert this from 6.12.111-rc1 however resulted in some
>> conflicts I was unable to resolve. There are other dependencies like:
> 
> Right, which is why the three patches stacked on top of it came out at
> the same time:
> 
>    6e3c0a4e1ad1 ("sched/fair: Fix lag clamp")
>    51b0e68cfa0a ("sched/eevdf: Fix rb augmented with multi fields")
>    9a8bc9bb4c3f ("sched/eevdf: Fix augmented max_slice")

Ah ok, that third one I missed, so it didn't work out for me.

> Some background on why this only bites 6.12: the WARN_ON_ONCE(!load) you hit
> needs 4423af84b297 ("sched/fair: optimize the PLACE_LAG when se->vlag is zero")
> and c70fc32f4443 ("sched/fair: Adhere to place_entity() constraints", which is
> a Fixes: for exactly this commit) to be shut up, and 6.12 has neither. More to
> the point, upstream has since reverted 6d71a9c61604 outright - 101f3498b4bd
> ("sched/fair: Revert 6d71a9c61604 ...") from January, which concludes the
> original commit "was wrong!" because avg_vruntime() already accounts for
> cfs_rq->curr when it is on_rq. 6.12 only ever picked it up as a dependency of
> the eevdf fixes above, so carrying placement math that mainline has disowned is
> not something we want here.

Sounds complicated; no wonder I was unable to figure this out on my own.


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
