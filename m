Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADABE33BBCB
	for <patches@lists.linux.dev>; Wed, 17 Jun 2026 17:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781716514; cv=none; b=jntu5kkbA1dkp0nNgl77nyYykyrV4uABWx9pzv55GiyCfeQdaXlqiRq2VZOxL0mJ/3gE15J7k8OhTxqJ2DJQnqLseqKxlDpXIGs6VIN1nr3QjiFLYguKUwSmmyCGB+0GKxBhU4r74q4KNpR06EZpyu991G2Yu3Got2nR0/4wdFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781716514; c=relaxed/simple;
	bh=DfopIBMX/TQrYURkHA/8/q1uNAzuMF8sUBfrpC3SFio=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QVzLEJF7DgYP6LtkWla2Dl3t9J1GG3mYFPronGBA/LaBSF5TZ/lFkubXjurlCUkFaCM+ZzXheOUEVvWfpnSSkO5cGrz3TIbu9eLUxNLuHOZIuDHUahKegJLF2akP4ObMvdJqSlX3CvUXc0i6qpoxg7FgHQKCNlMlM4x2OfPgTlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KcnC0L1d; arc=none smtp.client-ip=209.85.210.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KcnC0L1d"
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7e6da33a561so5388067a34.3
        for <patches@lists.linux.dev>; Wed, 17 Jun 2026 10:15:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1781716510; x=1782321310; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YTV+yTlG0bYfe+/PihUammSNlg4bVXG5fdMlVuGlrtQ=;
        b=KcnC0L1dnQ9wgIDGULj6OIF81h4y2N1VC+pmY92uw6yZw3yGj9BzyIfB5f3sTEeXEC
         Dt4mi0GgzErCD9QMuOxun0mE7XbWg2/ZGCAeP3pATw8yemDBYn/+sLvnJoxPA6vwEF6k
         qG7ntDsKmpGh2ABkMip6cbCtgXpjfcDF8TNFA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781716510; x=1782321310;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YTV+yTlG0bYfe+/PihUammSNlg4bVXG5fdMlVuGlrtQ=;
        b=iilmN7OufN6WnH+5s8RVXYDRh5Pd6Cb8yWIKDwRyMmxC9Ewzilo/IVfsi6UR3WZH4u
         qtyE4GVLpE6SaQLaS03RtupCNuKTT61FSmxzyAtBI+CA7raCTZKg+EEAorXmJBvb8x3E
         d5y7K4r6rKmZj4nF+C0xFNAwlY/F3Y0pRGxXbOu5BP4240CxvZGQPViC3YovRQiM5A3c
         m2GURPTsCeAD7bVAKWlsIAAnOKgLXzXhw5/0A9AwTrwJlXvXDZ0z2NQIHy6mRKnjfOp7
         QTRpEMSxz56G7y8KaE+NfmY9JzutTjtd0Z/59ncjxEhjJKV12Mhka71YFf6qdeZTpbDC
         cBSQ==
X-Gm-Message-State: AOJu0YxwMIzxbldbZw+7KxrmUmEWyKAu/xW2dwweFxEK7XndYvXNGVNH
	6Syr5+fTiBjBjtlVN2Q90RtnYx6OzGtXzlfdPWNcepe5aqI66hvDdGkjNGQQqORhWv8=
X-Gm-Gg: Acq92OHYKVuZ89plYNJxyme+Lq9YwAcBsHUBekFN0feEOf2yumGLx21kHNyOrMK2zbQ
	NgvoKCv9la2gI4sIHEJl4Vd+PEiDN0kPmO2ss0pujf9JXrmtvFUmwuzjsghVWhj5ZkhYAAK6O4c
	P0YGvp4ZSqsM3RgjHyB7pnms3y/TxdqaSbM2P3MyfK138eT67iKnMRpDyJlJ/Wq2dn6V8vcZM+F
	I28VTw7zYExIIVHlfXFk2cZoLLBY17Q3xCNYXdJQvI3njjlL8Xi4N+0ieZL8Pa6gGExCCLoYTYN
	w82d4S1bYQrR4/ie/Xt3tqDPLbVydbMIhB0WkWz1Ct7RhXXe0zsC0/iHCR4GdCOuEqYBP55VMcd
	wf3zw72aELn9n3QBg1RcnhqwuZLz6WNPMOxXWLSfMYTpWVJY/2IPVie9Fm8eHsy0/yebjbVea/i
	vK390WURQiFt35uy/COKcW
X-Received: by 2002:a05:6808:178c:b0:482:6b96:5ad0 with SMTP id 5614622812f47-489429ace36mr3857167b6e.26.1781716509971;
        Wed, 17 Jun 2026 10:15:09 -0700 (PDT)
Received: from [192.168.1.14] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4875dda5f7csm6566221b6e.1.2026.06.17.10.15.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jun 2026 10:15:08 -0700 (PDT)
Message-ID: <e112ac49-e518-4efc-b481-a557ee929ee6@linuxfoundation.org>
Date: Wed, 17 Jun 2026 11:15:06 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.1 0/8] 7.1.1-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260616145523.335696673@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260616145523.335696673@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/16/26 08:58, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.1.1 release.
> There are 8 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Jun 2026 14:55:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.1.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.1.y
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
