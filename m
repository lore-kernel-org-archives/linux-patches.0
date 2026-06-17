Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2785B32B11D
	for <patches@lists.linux.dev>; Wed, 17 Jun 2026 17:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781716703; cv=none; b=kNZ0+F9QMo+TaXy6/eGtIZXGICTobCIK+GpA0JNQI4H9AyWTIR/AOpNfT83Y0gHGUPyCc9X34eH6JCanBb5ybFfbGFsNYVSf/hAq1XtUXN148T2ImVUewWOdIPfRuM+RU1M0O/G13oewIAJ0Xz7FW6mZtIEgjjeANgfCy34KgsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781716703; c=relaxed/simple;
	bh=zHKO1XlZBRzXSXgfQgWwKooKrNuhcoEsmgecyBdnxXs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Jlg1N7wgLNW9kbFhxKfUiQ8tw60djlQld9fQcTVRxBwjodPui/FDKyR805nUOEGYhD/kHI2kroUr9a4SZ3GWJKeHPqtNcAAuz5IHWXYTkoWB4nqhoQxZB/gMb74wRfV39L4Fb1g8jyBECDLgjfwqAI5x5K/tAdXYdRZyLZAZrCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DLpa/Rc7; arc=none smtp.client-ip=209.85.161.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DLpa/Rc7"
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-69e43b02308so16795eaf.1
        for <patches@lists.linux.dev>; Wed, 17 Jun 2026 10:18:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1781716698; x=1782321498; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ASXWrUWStyQOageYC3LoVBOOGZ/iKGTFoHvXDiH7SyA=;
        b=DLpa/Rc7g2+oajypCXkVh9rRUzmyvqbgWf1ZDYDifca03l7sxZ+5jDA3C06YAj5pW0
         Wq7lovi5u6dESHQfTJuVwHvkLJv5LbsezKo68DFHoAXIr/yhbNsnyVOZwvx9vGRHh3U1
         7L/1N5rzBHz/7nMRN/zpXnQMNZ7QqhtBZzFQ0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781716698; x=1782321498;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ASXWrUWStyQOageYC3LoVBOOGZ/iKGTFoHvXDiH7SyA=;
        b=q+Z0hGk963nNzaNzbEDcqgLwU5XbvDfqaEv+0hCIsQJZeJYL+PfMLXgSDf370rDWV5
         IEdSi+bTwUWXQy1wjh0RywRunR2xMup0ZCU41703/sOvHz8BujU1Mq0WIF7/eFJcZskV
         c1Xoz+FeHfySqIJl/kEfwbouvgCYTYqZveSnFogV32F6bVHA1NKUzApCyhN8tB0yhzjr
         SM+RavRl9wM8cFy3Ht7+U20fvDUvTqqjxSXiKD64pqlEd5UvC6QHYk9bdi6JdFpgyvzD
         3uk4edSvWVs6rYEDdwiDHvakmns9FsJOeGHrep3vO5d56zU6iWp3SYXK7xZq7SzSB6vU
         8Jqg==
X-Gm-Message-State: AOJu0YzzAss1FQHcg6r3n17rNjXIZbxMfZhVQUUvx+eEMol3t+LDjnRw
	mlpak+KLq4AqyUaYfQd2QEpMFfKaLb5uahxXKS0z90gmltPPuEYa/Cs+ZgwakAjb/S0=
X-Gm-Gg: Acq92OGlUil5sJG1lA1bLRT6brmG9tU7Yqqy1WZ0GYWJG77mnn0UQglWdR30Tpn17AW
	NbDjAwyROCc6FafdxDlndVHPHuyoMW9jh4SF8eRWTElmSP70DO6zL5GlO772i1oRhk1wxyIbgK/
	lu7AsBvGA5Z4rADu0Cq+PfIKasOML0WX/kVG6Y4UNtgCOMv+fmlmqFMqrkEhiRvm5ODiFwD7cJu
	IN4bUR/0AAClXJWEMqFCfu++J6bTGJHk7uerKchVGL1hJmscGM4rmzICV7aTcyRx55vFB6ZpukV
	xURYm31SwX6QxBLIp+/3Q5XMLogta52CcX/BiDu2QvO9DCR4drYagu+eVI8+VU6oq8Wc2P3flG7
	OcEQhpV6k8z+cFmFQo0pZQgVwOybXrhXrTS7QszSrNpnq4K+8tUmSHSe3eocK24dLPp+ZQlFTuB
	rvv9793bWn3KFru6AnYmlh
X-Received: by 2002:a05:6820:f022:b0:6a0:b429:4436 with SMTP id 006d021491bc7-6a0c72f9a99mr346616eaf.0.1781716697847;
        Wed, 17 Jun 2026 10:18:17 -0700 (PDT)
Received: from [192.168.1.14] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-44308a66827sm4841164fac.2.2026.06.17.10.18.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jun 2026 10:18:17 -0700 (PDT)
Message-ID: <5f919e15-45e2-4c33-896c-a17782d5e8ec@linuxfoundation.org>
Date: Wed, 17 Jun 2026 11:18:15 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/325] 6.18.36-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/16/26 08:56, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.36 release.
> There are 325 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Jun 2026 14:49:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.36-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
