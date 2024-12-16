Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B376420ADEC
	for <patches@lists.linux.dev>; Mon, 16 Dec 2024 16:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734368051; cv=none; b=b6s61I4p7eBLVg4II0HJA/fal3FOv7iVxtTLvpLPQacqVnxZuBCv6b5P0pT6VLEKeahg5DrcFAQqISD5ByeQPvJJgINyot8CIJHgei39+P+EoNDACQu06rSydg4+NbkfDYIvwfiALJzuhCStH7hgVK+cApUHL1937DgdayPmbek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734368051; c=relaxed/simple;
	bh=nIV1DmxfVi+Mib3HJgbL9EDF6NiZRMmiIF6Y4RvTdSY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MM1wuPr8knss3uqnzT/Q3PawfR6HlHNN+9qq4YQsuy16nCFC//g2BGu2Milxuc7HwJitmPr1l+UmHNYbTDdw8BUl7atx3fznr8fZ9itYC6OCL+/zMb/88IMZgFQNXC8nh3Cm2776Rwze0VTCKkbIw+hT1vOtW9gFkVKAUsBz8C4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jpuF4J9u; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jpuF4J9u"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-21675fd60feso45778565ad.2
        for <patches@lists.linux.dev>; Mon, 16 Dec 2024 08:54:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734368049; x=1734972849; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=a8zOzjaJlDBPXxh57eb5jO2HE5yiIs3Wf3GEyJoiLUk=;
        b=jpuF4J9uxDG+Ycz0KbKOZyZzP/6st12y+Dvi7lMctMSa/P/5CbpvWOCS4VICt6tEi/
         hjTyQ83ZjJXCmML0hj/FjQzPLbFSXJ7qOzAys5PHYFIjjO8VpZGctpYytMXUSF7h+W1v
         nT9TBgqpiMpOvz7Uuopdk6Moe288/lOEHZCl7TxC8GOYm737bzBZUZzazURz4MiAWFds
         Xme3XT0RYieSWVvlvMhAaKgmcF23XNWNZHbY/qSirk0Tt75HJa958hVtLht9OtBrKlxY
         y2yu/akNIBWpbNLjr7zQhoTFQEjhTU7Ldl/nAo6PSr1li2GLmuvGLlpCTLoGL+bNniiT
         TDKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734368049; x=1734972849;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a8zOzjaJlDBPXxh57eb5jO2HE5yiIs3Wf3GEyJoiLUk=;
        b=Wcw7zqiw/JOLB3cfjUxuJmfAFza4pUyq5LM/7tnGapketDZ+bTE49Igm14XVPvcu0c
         InPqGMeYwdfsj5MIAmQbxgsKi3uHySgED2mMFubO2MQjk/0rx+kzDRY88T+i8OF7IBwv
         zyIMDoemmatlWjrU+ncFMlHGcwn8dAXTgSiy0pW3gAwVWrdqPzashWbuEPRZ8HJuaXGy
         U1AX0S1mgGyKgvstj25OrudrWkIHbs2ogV+qEMOLRh8+tNvGkacXxdlsiazBmzwdsjMH
         oSi/lFNoFhGsSBsr6qtk6cObTkMK6ma5iKKwmH3lJoiZ3q5nenNJ6M2HiXEvSL9ew4c+
         VoQQ==
X-Gm-Message-State: AOJu0Yx19r9hjMnfhl6MPZ+9QkZlFte4KEX3b8GeTVqdRIer6T/Z3J0E
	glAelMF5/bCKlxr13gw4AecYBKbytP86/HpH2CRRfoY486+GzBfC
X-Gm-Gg: ASbGnct5AF+O+Chy1H9n0IgeCq6hY8HpSQ10aLCgU3948jzIG+YtLYp0SWuomXoGkju
	2dr3cvOVY6rmQGSnEK6QINO7yCjOlrVdDzYg+vV1Bg0oqc1VkOJMo9H5tdjPO+r6NZKAcVL4ZGb
	E0RkXPClHVxRpG702tuTXiY8dO3kAVgBgOx3yqkavEJFIQelXpi2VZzgKlLQiEgPzXyYdwudgqY
	mRBEVZ9RldfCqS9bnFRVk0fCWr0LKg6hDK8noU3uPY7wWvGGXE35zjccvQaYAsos1jECIiiLKv1
	3HUieWchtprMzw/jRHI=
X-Google-Smtp-Source: AGHT+IE247/C7LlD0CbgkuKpBdcsqeF0GznYQjHYwP/PTRfVkmDZb65uvE2bRPtlsx9G3yCjV3q6Dg==
X-Received: by 2002:a17:902:ea08:b0:216:4169:f9d7 with SMTP id d9443c01a7336-21892997505mr201786135ad.2.1734368049121;
        Mon, 16 Dec 2024 08:54:09 -0800 (PST)
Received: from [192.168.1.3] (ip68-4-215-93.oc.oc.cox.net. [68.4.215.93])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-218a1dcaefesm45292665ad.58.2024.12.16.08.54.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Dec 2024 08:54:08 -0800 (PST)
Message-ID: <fadf81d6-6115-4829-90e1-858e48ed9b43@gmail.com>
Date: Mon, 16 Dec 2024 08:54:07 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/467] 6.12.5-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20241213145925.077514874@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20241213145925.077514874@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 12/13/2024 7:03 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.5 release.
> There are 467 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 15 Dec 2024 14:57:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.5-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
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

