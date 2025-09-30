Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35B5B25A323
	for <patches@lists.linux.dev>; Tue, 30 Sep 2025 17:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759253002; cv=none; b=RSa4OaO69XByfIPum8pVuddCBF0mTg2dcJ3UD/bYIXRPIS98kIoPveVOHMv0sAIuyCOBx+uyA84EfN/FvT80BCNXQE6NGhi5PLeCec7n3QtdMqfQ+j+2g1FVwX0DCyfM/lfDdiUVDlGf/ipAMlOjL3/Rpa1otSuHMDKOh0VpxqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759253002; c=relaxed/simple;
	bh=Gmprb3G0hVbY/wqnk/AWfgc0XcA4SLvjCB8vCR8Kz1U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZO06WdEHRmv4WiB6i/gurK0HnV4QP701e8glWog2WZBkj1n5SXa1Zn0Gdsb7sm4YT2b+5ZSDgjSRhSHamqfhAn6Z1hd+NTTqUB5YopiX/6WxuuvB+WHJCt6Hblx/+bDRW16Zl1v2ICz80oHuJNN9yQp8BSqAm7mEG0mdDS8aQE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HkO+1Ch2; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HkO+1Ch2"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4dd7233b407so54960551cf.1
        for <patches@lists.linux.dev>; Tue, 30 Sep 2025 10:23:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759253000; x=1759857800; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sNXg0KH+3u6gOVaOqmzWivNbyQ6+EgiPLfdVOQgDUu0=;
        b=HkO+1Ch2v57KlBy0iG8/XUwi/CvQ0BmvtThuk9Gy1hTeBbgVqHqhvVvupQ7O7xuR7b
         u3Azh1UYn8eXNBuiq41XLuS6dZOqXb/xu+FgIxhlSAgdt3qpAMDCpYJjOruW9QWB0llx
         9jgioRSsjok6666SzNS/DCwwez90tGVHVxY4+pA8/0CyoihqaA4EKaM1itrz+SQtMpsB
         BpsCd/IGA0xbetzetFojvlCV+FqlMxl0wG48J4nsmrnO20xf8M7XhzYbjePWbkKsRW4s
         9EiSEU0Npm/tLb8AnMTPdQKbtNiQMKae/5uQCm4UaFstOz+4UQVe2rEJCScn/JapS6BS
         VQTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759253000; x=1759857800;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sNXg0KH+3u6gOVaOqmzWivNbyQ6+EgiPLfdVOQgDUu0=;
        b=k0SH8nv0P5zzmB37xERyJkoKw0SwGpqe4SA9LXKH1OMr/54FTAVF5h4ZNYJsampL9A
         jsuGZWdvjxiNc5oGE5minwWcRWvMyla6dl2Vrk2JCcQJgRBzVNfEFF90HneUZ9DaeY9A
         io/o0NO+WAogc1Z/HJTgkqWS8XGcVC3BmOswiZssIs95DuKCVB21r0DHeGhjL9acG+kp
         JVfAEmKEe6YnhOQZ/lpLnQmRVSjpY2A0eLsDn/CRHTbl6YCyOOgCKWCTLsflF+WgKxZb
         2PT/vUeL7F7LXUrmcEZzwv/6KHNprZDtssL56+1Emc0CP/RuVH/wf4qzDW8lhHUxDn8c
         5thA==
X-Gm-Message-State: AOJu0Yxn8J3Aawc9OKNux9UEY8ybG2ECcC5GprubP0OFROHgBRww2oWJ
	tWAp08dGUFiXfgOdP77aZYgv1BL7eKrBApgRDMsEVmpLxKI/14Ab05hz
X-Gm-Gg: ASbGncs8jJUUw1jolExX2PUobnarb/p9FqCox6IF7icjUuBvtndD6jJQLnuTaLyJ6JB
	deB8FvsJ1QiHdDqDtjbPyRPha0q6RvYF06pRdAwTgnH9zECsk2BaYUaeWqxHidZyhkpl07HTQ+T
	41bAIMQDCUMj7/VAy6zOtfCMvL88KMP79X2XQQH64CZIelVfNi5rLdpYV2IC2ZxEHgPTohGFwft
	nbJ1z6G+8YqMPz3OZasi1ydQcd1WBOvYjhYmD7bmwINHHmZI5DeFAo2uRuLHNFIzrJ4eOA2f5Sp
	ze9g+/nCs5magdBz2RZ1PByV6KbVJotxdYavjgaGF/cFsVzaU7tup0mizDujprf9SgpGtwF6cKM
	V+XkuZtIICHxka5PHd0LM+5U4tEe2kZ9kBHLvYUfLzmbe7OP0JuFsZJxDoxf4X8XCzjNIMN8dGx
	cnwwDj71xZ
X-Google-Smtp-Source: AGHT+IE6pmTMC5913viVxHCB4hjx7BlppxYkXAL1vAw+AKddbNTwcrXB5U4RHHgog0XwsfyAUet6eA==
X-Received: by 2002:ac8:5741:0:b0:4b3:4a3a:48b8 with SMTP id d75a77b69052e-4e41e827c5emr4195621cf.73.1759252999952;
        Tue, 30 Sep 2025 10:23:19 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4db11222768sm101479241cf.37.2025.09.30.10.23.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Sep 2025 10:23:19 -0700 (PDT)
Message-ID: <3b5693e2-c63b-4977-96ba-72374832dfa4@gmail.com>
Date: Tue, 30 Sep 2025 10:23:16 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 000/122] 5.10.245-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20250930143822.939301999@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20250930143822.939301999@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/30/25 07:45, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.245 release.
> There are 122 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 02 Oct 2025 14:37:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.245-rc1.gz
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
