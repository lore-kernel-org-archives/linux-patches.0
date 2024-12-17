Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 462D41EBA07
	for <patches@lists.linux.dev>; Tue, 17 Dec 2024 22:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734476318; cv=none; b=GqOQsvdgHMrc9oFLH+ZdzA3tQuDCcWw4HOvTUXJOecrK8eCSOsjbXfn+jIVZR/dtWfD+MFpbHf8APpZVrDOlRxHN6GWl9b49U9vP64x2hYzz9kZGZ57S1rdGp/rWx4kdLNg++pwXw3TKvDNnrdXdYol7y5/ImBauPyCWq17Fa9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734476318; c=relaxed/simple;
	bh=ezNdIKG5fex1vz/PMbs67WqFA9e2zxQBEQ/jnlZRIWU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CnVoojesvBamgkfhhOJgpB4FBHarVKJTMV8p7NN3YwUCIU8DyiKCri+6GALwHDeTLqMdExoXqmOLOOqllbQ5OlGodT1CJTTRJrVtEAecOShYthYkJdh+tLnk7VAnt+fbVE/9KXkhTe8oJaxmENWI93AIlNahSiL9LEUjxXVrioA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BIKnKW2g; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BIKnKW2g"
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-844ee15d6f4so372043639f.1
        for <patches@lists.linux.dev>; Tue, 17 Dec 2024 14:58:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1734476315; x=1735081115; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VHLDHmFEFp8u1VKVXZNoakOoMfbmaJWuqMVHMF4IENY=;
        b=BIKnKW2gHYoM9pxxDd8cHVCQEzWFfmnURSZEHK6wGuSz3JxcAQ2eurW34f1O1bTB7W
         7xX99IGl7GQMS/BJQ/OFXLgJk/7cqyVltgVaxy+/WPa9/iNjwayCbdEh0Nxu8xgsDFCB
         6xGO/Ml0+CWcGEblRpH9k6C2RSXiKgN1jI7zw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734476315; x=1735081115;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VHLDHmFEFp8u1VKVXZNoakOoMfbmaJWuqMVHMF4IENY=;
        b=GquJOo3f0scSO7LLtRjXkP1vDP3RgtyKs8lHauqcAmOp1wywG6kPoubS/UMSVNy2YD
         bYGPfaB9WDpY0aIOB2GM0qHpL1b+yKYV50vmUMXNorJdhFXVdnj9XPt2ugBTGZ0tI87q
         FmpwoomlCQ11YAdL/aBioqcbS2Lh5Mn+PWF9bqNDC3hTTdeifVtFRhFL08oBHjI9i7RQ
         XA4EaJrqO318mkVzZ+oh7e4qtahLLDvI2vtJwIHShFlKWXcT94phB2X0R/HFpTe9DmP5
         ub+sSHQmH6/Nc6wQflMcfb1OjppHcQ9I9qYa1OCHeHTJGFj20Eq0fq6BjeWs6d2qkICw
         2mEQ==
X-Gm-Message-State: AOJu0YwZmNcXm1YGSIHpNrkFeX8t9c+bN+wkCXEiCWsMDrXtJRKMgSyB
	TAkWV6rFE1OcI8MRtRKJNIZOdJmt/Eb2mOEEIOXrLOn/P02ktpbBjYgpQIxuyn8=
X-Gm-Gg: ASbGncteppYfR8VwsPix9rq8NBi1SY/2qK+ZEb3+/Edu21NWDtxR4o3wBLWN6ajpoHK
	Pk0BHnqwqO7GENmGUcq8PE+6XnTwEAAjUWGLWkwhXBAfb59i46JGN1E3/X7aeEeao4FYrgSJDXb
	TqhWrFNHRSCoq+h3NNY/l0/g10cyLs+eQLeNlzcBGT7wJgmlSVYmp/IWQGJpF5KEtXm6wO1GX8v
	5K4hpFHBBE8ikS7CsWd25ROgYN/FgR1fTMfFSN8gU3Ib5A2Rvk6gnat/5I5DgVTn2/R
X-Google-Smtp-Source: AGHT+IFv77BQQLGIXsZCeXEiuFTtdJydsCE5cUHiEZjwmk1jeQkDKOeTOJE9aoC1yqn4HWLR4XEXrg==
X-Received: by 2002:a05:6602:6c0a:b0:83d:e526:fde7 with SMTP id ca18e2360f4ac-847585086demr65850939f.6.1734476315338;
        Tue, 17 Dec 2024 14:58:35 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-844f626ad4asm198570939f.16.2024.12.17.14.58.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Dec 2024 14:58:34 -0800 (PST)
Message-ID: <02fc080e-467c-4f4f-b52e-b20ef722dbe6@linuxfoundation.org>
Date: Tue, 17 Dec 2024 15:58:33 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/172] 6.12.6-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/17/24 10:05, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.6 release.
> There are 172 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Dec 2024 17:05:03 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
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
