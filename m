Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02E0326E15D
	for <patches@lists.linux.dev>; Tue, 12 Aug 2025 21:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755035781; cv=none; b=UTHPUEVnuan0P6TtEfBX3F4wzwhO7RMSgZdWKGwYsJrIf22S5t1nB+gKxENWOwd64qb41cSXwONuWl1WrHH9y3lH7B0V9gYy4Mj1VyYG76MfXRr5sZUZxV6wKHK7FqC4+QYPshXWbdL/jjEKWSFL+bptsqPjasLgVJLJnQyLMWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755035781; c=relaxed/simple;
	bh=npFsQ/2FJpoQ5YfyMz0bgUYAIYUyvj+q2Q8QbTUvYMk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BcjRBKt8+6kYMF+MMdga/c7q53X6FctKpUuJL1Kp7vvgqpp8qOkak2Uc96d8zcHzvBng2nAxHTRhV/H96mwSRRYTn3qkBSViVlWQuGijkDDMhxt3xV1jiooPikh1XlphePkzFwIKDu9kNzhn2k686K987//PT3YHuP+cwihPagI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GcRjzhmm; arc=none smtp.client-ip=209.85.167.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GcRjzhmm"
Received: by mail-oi1-f172.google.com with SMTP id 5614622812f47-4358a73e7efso193604b6e.1
        for <patches@lists.linux.dev>; Tue, 12 Aug 2025 14:56:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755035779; x=1755640579; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3OYO28Q4WMutLsFiJxtUOsDf8GVDoThxADMjckiwEJo=;
        b=GcRjzhmmBA8r5g5CyVLdBw8qHb0i6CvF9nSgp6UH81tY7ag3vZ/M9EZ4qb449X6sQA
         M7SzUcvb5XOw4LCVtPSDHdsxtNfBu01TIBBKfJhhSYtLuOVumKKmqpcknC+6jGzsA8Ye
         +myxfOnCHEZmfQ1DKIlPCMojV4XhGzF6SOOvFSdHW3eBAkGMaDvgXTin12pTykNifk3J
         S6qREpcZBnQ0jB1WiAMfC941NjUzdDcEnGUsFlHCsOFGs2XYHUjR5AmrKlCm2Fb40eAF
         Bq6HJRfBrYzGCMfkJ895lPgQ/+/Xh1A/ARHQetMGXMuFaZBYj6WRxxAtSUFSitXCgJFM
         8HEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755035779; x=1755640579;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3OYO28Q4WMutLsFiJxtUOsDf8GVDoThxADMjckiwEJo=;
        b=Kw5mkf+G5ZfjefOwtfDqjzBfH994h/c3ie4P0LRXeqq0vxqpB/aW3vKv7ibG+7w3Ll
         XadK5vGdTAMPgYBLlmTn5qAvzu/5OR36Af+1YNjU/sAujwDiYBPEJ0LKpJP8giX1AOB7
         bD3xi3x78e7iKCuP9pS+lsI30ZMcn50Tt5L5YY/fI0avUw8mYJYMrzbYaQQsMVbJSVlQ
         82xozy23DnAAz+S9MpXMo/RiLXDrE5QKMva6ff4zvUYrZ7IrfE9S05gGVJDxTIqnWssa
         iDlw32T+YLvlbbcq+7m0WubgEt1x5Yjqb5Ez37mku0dkNlP7spXD/pzWo7MXo1UwNzX2
         PMig==
X-Gm-Message-State: AOJu0YxUtdHHLzvKwwSIa8FvB93dtnDJIOxGnrOus+MaU38s0S82/Fbn
	fYuou+Ec/YEi2bVSigus9NEtQdduAhwH7QSOEZ64bF96oa0DFyXZ60Kb
X-Gm-Gg: ASbGncvoMcRdezrckFpmYx5HnIyhsS7JK9N0UZrSXd0cER0IBEFxexTv7gPF9m7mZ9C
	1K7RluxJqEuY/ozDhMuHTcqX6MwWWx0JAkzqIwOzSPspPGHvTJbXNhLSIr1RqPg0ltQ5gjv2NyM
	KIB4sXdgNHGWU6GTnO0gdunO650quX27wwUOfKYE5GoKEhCVfYbxGa/4j1+sYQE5/1rdKauuZut
	sIZImHUIBszO3iJP2gzc/8q2IV+ZPZ2P9B1Fx7YbxS1wLY6Qd+q8EePEpWqiQVxMnDSL9X02htV
	8tpKfYtC1r8WDxWTREUTkPmjWQ5QIiO3aqbjO1g5TwwO3rYu5TjSr5cN/xoEZvMFoiTqGFl7B5B
	s3dgP3rFIhpmPZkcxy6BjbXKRUtd5IPBrlzTj4KQQd+ak
X-Google-Smtp-Source: AGHT+IGlTPoVcbuI5YWA0De0mG2ElR/KMShadFbH1lF8C1lKnqHY0jyfGCWMsF17lWgYMOI9sjyPWA==
X-Received: by 2002:a05:6808:4481:b0:414:31e6:f6f1 with SMTP id 5614622812f47-435d640b476mr96195b6e.17.1755035778959;
        Tue, 12 Aug 2025 14:56:18 -0700 (PDT)
Received: from [10.236.102.133] ([108.147.189.97])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-435ce895fd2sm371460b6e.29.2025.08.12.14.56.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Aug 2025 14:56:18 -0700 (PDT)
Message-ID: <ae04fb61-23d0-4d6b-9ba2-8473f8499272@gmail.com>
Date: Tue, 12 Aug 2025 14:56:15 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.16 000/627] 6.16.1-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20250812173419.303046420@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 8/12/2025 10:24 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.16.1 release.
> There are 627 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 Aug 2025 17:32:40 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.16.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

