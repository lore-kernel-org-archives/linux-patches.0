Received: from mail-dl2-f42.google.com (mail-dl2-f42.google.com [74.125.229.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F3D7405C35
	for <patches@lists.linux.dev>; Wed, 30 Sep 2026 22:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790807456; cv=none; b=JxRHLVIMkyl+toudTIfnrVHIGW+jYcmVPXrbjMPQ//OWNwm21S12vMcAF8USDH3eTagCUVCrx57MUi7mRlUWKkI7jQQfXivea+ZdPKTMkceZUeRbYEvWEwgiKM8NWXq07x8qLt0LPZ82djJ002I2yfSTI7aCf/Lsy9JNQDASqvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790807456; c=relaxed/simple;
	bh=KeH/wdLc3pIBM3h4KTbENqpk8QupNvfzPsLZCFCXyA4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Mmt3rNnPABaqAMKPucWisD8ruDzry6gTMx5LUJQwr81UAxGNYV9kZ77UB1phWE+QBJeAHtMlDz9VXgLJq/DdOWeXqT1jMkbfKIOGj1Y7htGETq+7n96usyXLS79XXGZIz6Ip7S7Q+8oF1l6+kyRPkItuOV14Vz0vXAz2jWEKO60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R+QOT/4D; arc=none smtp.client-ip=74.125.229.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R+QOT/4D"
Received: by mail-dl2-f42.google.com with SMTP id a92af1059eb24-1438cb9b3a3so4699645c88.2
        for <patches@lists.linux.dev>; Wed, 30 Sep 2026 15:30:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790807453; x=1791412253; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SctRVBh2XMR8BEHKgf52Y5FElqtO+9fDYfFxFd+FYrA=;
        b=R+QOT/4DKmUutYm50/uetTB5UT+4FIHZpZLVKu/NaT+HlDwTvj+9FluA+k6y7ERxAS
         LlIRtSWMYLMp5YdPRZMSg2U569jb74kqNpfQXXrIIEPPblWs9Pm3EQq2td9LlKRMaIqV
         LeFeF28WbfICdaLmsUtz1YOXghNMi/c7280EWWiUIyYTzFmfdTG84XMQYUYGA4nBXlFa
         DOA/+esxaVBfXkbV758GMORC/ZHbfliAyDw36WXgcPAoWpVd35z3TKPnAvus2I6rO39n
         qyGs9ZvOmkJ+5royokEgNTanaLDaoXivv1ZH4oLlmfxEFwsngXujC/g8mPl5qEHLM2CR
         ZoVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790807453; x=1791412253;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SctRVBh2XMR8BEHKgf52Y5FElqtO+9fDYfFxFd+FYrA=;
        b=hR3aiwZ6uvJGPFZ9JzQvE34KYgoMopSTF+O0F1fwPZuWo8ujzqkCOPMhmfPQADVG63
         RN96W0V0kQizAn3mFxb+GXABXyVcIAlFKGq/kN7ULLuTLKN5X7hVqboRUgYimRTTA6kF
         rKD2Zabdqa/WLxoGTZovsFnNCbzlkfkEM34Xr8KvTB8ZjWD+sGO19IXVqCuU96B8VIcm
         u3FVuw8F60kEcDSMUPXa5DyiDdUaUXIFHloo5Hyyuu44pcPE3V0YGNS/6HXDrlGhroHz
         fxwxp9JPa5F0iks3GxyD7r7C90dBclmL7VBKz7K3Djv6TIR5RCwRvbsQLpppUC0PCh1+
         M5kA==
X-Gm-Message-State: AFuF++kfbLCa/Y9poQ/3iqCs2u/nbvCmKOQj7uHlTBMxJ45FU7/gz47B
	MDqgf+9G82hBYipfgBXPZc2NA1+DyiqZ+bH2RzHnuXzYEuBU3lhpQ5HT
X-Gm-Gg: AYBFou0kcDXz61gYyW2PzIZXw+gw2Rv1CXIwjhfIgjLo9Uj8KFg+XLnGEtNqhAK0ATh
	ZZRQ/e5dFFFdwNch71zyV2TwtnkacPVoWiFX7h7mPIpVMgJAO5v9dMHYT2/tbswYmo+pn/I10L7
	OKGVgP4biCR2aux0TsAEC+EGwIipfxKzoMtaAy7liJxvPxz0WWy65IbQDlwX8AMfpcdyUS1XOUv
	iVYgTc8sRVM08TbQjUNRHnSUzM1kas9zmv99odxmxUXfJngjIvKpMDVvhBsi3DkAzaesxJjxhB9
	Ow31kms6Vfj82vNKHYDWIFSUvT14Kh1Ikn7AVxUSRAb4qmrcH9JXaebgO1ViJoH/GK2qZzs+nUk
	XnuOYbXAGfSJ+b9YiSl0ozbudvi9ajQ5pTJcxIYhRmUj9GIKb98fqrEFBauR+XniOP7/J2Pc0B7
	/aJJn9tCnHiBdlcwnCuYGpVmWpct6ivBsjcR0UEkvnO6dggiNRJNmkcWZLWlcUc75KnGLnhA9NF
	ny1SUd5u2btTPbZbHXsjAWidYPSSh5xj/xw8hI=
X-Received: by 2002:a05:7023:a56:20b0:141:51fa:e609 with SMTP id a92af1059eb24-14d2cd25362mr2498682c88.0.1790807452434;
        Wed, 30 Sep 2026 15:30:52 -0700 (PDT)
Received: from [192.168.1.3] (ip68-4-215-93.oc.oc.cox.net. [68.4.215.93])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-14df3bb4a2fsm1281395c88.8.2026.09.30.15.30.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Sep 2026 15:30:51 -0700 (PDT)
Message-ID: <4fe680d4-1104-48b2-bf44-a2241e85a1b9@gmail.com>
Date: Wed, 30 Sep 2026 15:30:50 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 000/595] 5.10.271-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260930152347.700140858@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/30/2026 8:18 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.271 release.
> There are 595 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 02 Oct 2026 15:23:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.271-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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

