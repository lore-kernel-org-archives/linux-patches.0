Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F30273DD524
	for <patches@lists.linux.dev>; Tue, 14 Apr 2026 17:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776188645; cv=none; b=SMoVxzzZnCBBJu0BpYCA9r5T0seTa6FqjJsiCgnfpFtP+ZwCLGYIhROyGV3HE0OESVZw9Mc0s3K6LCysmFix2ZWXEIKtzKXG/REd9K0vyqnABfnTn65U7CJiDamf3mKFxwqyeAWNG2cCwWM1wafLZfjtMLqsHIe6MBMJcOuiloU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776188645; c=relaxed/simple;
	bh=dW+CVxs/CRofxgPG4UcHeZ9b3FzUcZ6G8lii97SL2VA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZPyUWoJqZXq8Saqj+SxobkZXJZJi2KwMaTWWVvCQNZa4n2q+3xEBG9kipZAVEMfX/1c+renh3KMfsPjeHTKeND0FCkvziAqYGNpL4K/XwjX0JkuFoqywGUE0xSPEci+heUaNL38dCMIPDWLQ2Joz4XiisDRtH8tEZhiMKBG86bI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eorTJS9x; arc=none smtp.client-ip=209.85.167.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eorTJS9x"
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-471618e202bso1491579b6e.2
        for <patches@lists.linux.dev>; Tue, 14 Apr 2026 10:44:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1776188643; x=1776793443; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FrmDWbThq3bQOFyy4Ba5d3JbT+VbLbI3qf204VvN754=;
        b=eorTJS9xJH0Zi5sTirNrpxe0AEJvRVukvUDviP2mrP/NgfmjdUFNBIVbfsenUQF82O
         JY5iLxjIWdvADo4J1UmFVK5f/63kZ5jpLwXn4gkwNYPjrOVHReSZir2m73Wc+7PgIWJf
         Y+ywKQn+ANwGm6V61vL5w+M03O+jlfsBmeM5U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776188643; x=1776793443;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FrmDWbThq3bQOFyy4Ba5d3JbT+VbLbI3qf204VvN754=;
        b=TfapaQ1kWzd1Cmmwdz3aPYwCuYhAGja7w5+gp3GGQ/xGTRHTcZcQbOBxYm3DmL2g8u
         wM3jsWRngHb11OCJEMHGoYky2E4jHmXGcnqrxnz+BuoWur+9BQQbSAO3IfSJHrd3Ambl
         363pntbezNVxV99yVFppeuoJOY1DsA0UNc4y+cJCS5lIRnlrdVIAQBgE9t9gN1ZnkuPC
         fbFd8uTfg7AVzNPQNju358OG+Amaj4ih9wPjqxoWGG2mLSw4nbPZrmIzdUCjh/J8EiA/
         CqXwY6PIQtICC1icGQXuA/0aABdu67alnc3pKDviampe9SdokPockTFoyFSou8H7AR9u
         EwDQ==
X-Gm-Message-State: AOJu0Yy3Rd7A8hC9ykPi0r5fRHZDuK4TOkyN2/kXO0PZwkUvPUDlxBQ/
	SREJcXc2ynLzaeX+u4ffgCi/wGw2wjzySr71FiPF44wCRFwPmEjgcEdpK4C6StK9qPs=
X-Gm-Gg: AeBDieu9oi+WjMDAx/28d04TScEmgdrVz8Aw6UyzoeZ4lUlHMjYgp8aChr0Wtds9gNz
	Aju3EdrQHtvi2QWW5iKjtnOsUIKi4Hyzn1La6HR5YARsHDBV7lWYIvqQVheTcJzFfeOCDQziCKU
	kXQTHFH9Ugu/6dA0Y1n9IXlxliSaabUhEJs1FkoA1OET4hNAj5Y9SRf6ELvViQyTYnsBmjDSgWS
	OQAlb2Hz4JGv6e2+9eJK/+07nbYcJ88tmMhXWU9uYXk2xlAlmrfKrGw9vqedBZGRXoqmtg0oD61
	tAEeqqcBZdy0qYOlcR3DTTA4CjsE4cC3FiCKgBAa+hTAytQMVPB29Syd9N6IWikfqNB2pQv4tH3
	Oe+pfRFDm8Zt5YnCCzFBrP76sDClA1d6OAaMPT27C1l9uhMZXuqC0+A8kj1rJo/iACmCDfmVdmc
	PztM6v+PHbShW2Gfvud5P+iqyPIQG4s9I=
X-Received: by 2002:a05:6808:444a:b0:467:32c1:acf1 with SMTP id 5614622812f47-4789f00c7cfmr8963274b6e.39.1776188642873;
        Tue, 14 Apr 2026 10:44:02 -0700 (PDT)
Received: from [192.168.1.14] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-478a080c237sm8502418b6e.1.2026.04.14.10.44.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Apr 2026 10:44:02 -0700 (PDT)
Message-ID: <c16923b8-6e2b-48d5-ae68-7b345e3a2c9d@linuxfoundation.org>
Date: Tue, 14 Apr 2026 11:44:00 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/55] 6.1.169-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260413155724.820472494@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260413155724.820472494@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/13/26 10:00, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.169 release.
> There are 55 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Apr 2026 15:57:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.169-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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
