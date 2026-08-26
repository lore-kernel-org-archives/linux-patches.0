Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 805CB50276
	for <patches@lists.linux.dev>; Wed, 26 Aug 2026 00:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787702572; cv=none; b=oLMUJ4EkfLUICxa99GWyNTA5vp+h/5L+h7XNkK2C9n1lp/DWSmDarSLSc1Hnfz517filHshCduY5zR5dtuX/YqXjegKFokHfU83ws5vYpg66OikOBHmRChy4C5YAub8A1CezYTHJdM2h/ZWx7QBZ66f9+rD9GUomALQkri63lIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787702572; c=relaxed/simple;
	bh=ReTXM9ynVhZlhP+tUhPkijcFLiX/nfvGB2OubiREl84=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dLj297wcKNn1+176gKH/OiooIxrlouop32fX1SZ4MyM+GnCUPO9+4+U474TRVnPmeDwVtmJ/iwXxaHOPrX77PH5Qx8NpwkKmCAOMs+fQCWrMrUX6YWHjyqorAMe1cNFjkIDaR++I2YMBY2zS+lVI5fevaP9UmAsb5PmQnawl5zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I4IJ40i1; arc=none smtp.client-ip=209.85.160.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I4IJ40i1"
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-44cd237446cso545806fac.1
        for <patches@lists.linux.dev>; Tue, 25 Aug 2026 17:02:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1787702568; x=1788307368; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HDg6Q8lfyspr+N0uaaIRNBvtV2V/3UQDK74a3w2PV68=;
        b=I4IJ40i1lzk1UoXWMDQZNwBiqLsBkyIM+YM4XnXKrO+WiBiyWwLddx/yatervDHgJP
         LxLnchF7wtnM9Xa0V6fP3zIEssBic4fKOJMcYg8QKrPdHQItz3B6e+TsCyTuIY4SpP/t
         Kfka6t/pU0FUQU8hS8OvIDlkfROORFLOuyKr0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787702568; x=1788307368;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HDg6Q8lfyspr+N0uaaIRNBvtV2V/3UQDK74a3w2PV68=;
        b=VI21140sKcIZViA3RTNzq4gNtLd9yXROzCRfUiH7RVVSmD+k1V1ucX3VEhAUCX/NvI
         xJQLkevuggX0Ra8UTjLjHVtwsXDE2XmJLutfqDjPtT6WjFETC3y1o1HW8oTib2eOmyX2
         PPb0o+qkrn5thwXRcOW3Ud02OrsHrqMz/8+DsFf7vTQwahqss+t3QiZoDfXeK3RxzQ3K
         sDIHKI0pNRqKWdj2Ea+d4R6tEQ78VQo3fcsecyaVoJIDTmiX0c4MoqWXi0ifao8E92lJ
         sTQK5jHB2WOWnZ1Ce8IuowxyHjKGmCfXUHUqggSgTt4VpNaNabeOmwSva2FlV+8CUzoM
         R2XQ==
X-Gm-Message-State: AFuF++nOyNls0HER2rptxGvyK5WaSEodqaLUC4qqmekmfq/zLZL+OfjI
	dsDpvX4rRwWh3FPkx8RlHq/BpKN13SnL670gn+wYP+3IsjKsbcBNKIM7tAN9U517TsU=
X-Gm-Gg: AR+sD11ba/rx7oSzU8eOMKYhpO+yJlEpbM4E63sTFB+7nRJulTfxw8YBPs2C2vsm+zd
	YUiQnQ9sRRvI3Gbnu75ltFlSwI+nr59mludRqr9Sbww8eAPFsj2/rYMRq6K+xPBn+eeKUgOPFxg
	TddEd4rJ+yQdrrdytHxw7KGDRcquI2Asybk9+QhL/D34KDwkJjGB9f3AHhthcMUKsY44pvbhlmo
	Rifvrq/TvO3McTI5g6c5fOMhPvwu4IWrTjj+x/Ko4833z+gGBwKza4U9t7+vylamnLvaZ73kN2F
	KDJt3aGTEdcBzU0jLwXOd2GADXYPQQCENFj4ogdW+y2kHUVOmV/+NC7G5AMk7gfwUsANdm7vOwy
	CxOHRBN90gEE8ACkC+BrNq/iKxRPrysppgIqNx5cWHJlVwIGbpn4cBzrQhkagLtL7IXbY1INeuW
	KugzVZjAiUYgsEsPLC4lnXTe7DlBboVIgNS/zzHq5vXNGfmiwgmulxZVaQBnzOncgyzSdh
X-Received: by 2002:a05:6870:a0a2:b0:456:4c93:a7f8 with SMTP id 586e51a60fabf-465981b1c08mr3490510fac.6.1787702568147;
        Tue, 25 Aug 2026 17:02:48 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-465adf69375sm780609fac.7.2026.08.25.17.02.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Aug 2026 17:02:47 -0700 (PDT)
Message-ID: <0dbf9d9f-f01f-4e28-85f4-a134486a0ac9@linuxfoundation.org>
Date: Tue, 25 Aug 2026 18:02:43 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 00/82] 7.2.1-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260825132541.560541185@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260825132541.560541185@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/25/26 07:24, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.2.1 release.
> There are 82 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Aug 2026 13:25:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.2.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.2.y
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
