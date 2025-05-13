Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C4E521171F
	for <patches@lists.linux.dev>; Tue, 13 May 2025 17:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747157465; cv=none; b=Q4MtKZb8Hp15ad88ZYFeqr86Y6tX8LWJ5DQD4TgZPhcN9riNvQYVGr461ODsjRwulWiqC8pMaPNBEO5LJI/d1SxNdpsyO/Jq67wkXLGJf8XiCliV1jZuSxVyJfHUL07fIrSLIKfLarnZaCs0+AD5uDNLkpUGg3fi9N0U4VZLMBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747157465; c=relaxed/simple;
	bh=EKZGO4knTlWgvD7ViYHkL4Rd21IweRpy1rbhQfQGqWs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mM8dCI2oJ/rY6sEGZNXQbYpPK9dH6XNiNo+neaSqvrCq88GwxKceqlE9k/1Nf7SFwdeWFimAgPAhNuo5v3Hao+wLIx4Qzibxqz5lZ7bL+W7uWjE/oPa8Th2xsl9UFsCO/KkjWRNu3EbcpwSnA3gjal9sLlvnqL4FkUpYu9+aum0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JoNWkjJ7; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JoNWkjJ7"
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-3da7d0d7d58so41291445ab.0
        for <patches@lists.linux.dev>; Tue, 13 May 2025 10:31:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1747157463; x=1747762263; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lBntU9Zb457F3v0HGH06DfYXgcqKhRbeHf7CeDFOHkY=;
        b=JoNWkjJ7t2+tOa4zHo8KurdO/qwqX6/8tDfbxobHLQLeD6pYQ+igDfcTvetKiVRge6
         6pJyipGjzoMYVn9JPZrwTgD7TZQxFuYm9Pa/o0yiAei48fdaEw5R2c0x6todqFOdMcTd
         lBJg7lstr92XI8bW7Qj83rqUybkxB/qsfgso4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747157463; x=1747762263;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lBntU9Zb457F3v0HGH06DfYXgcqKhRbeHf7CeDFOHkY=;
        b=nR7ugy5pHjjhu2MG3D0iGB+5yFKqt7+GlZ4lAa9EMd6RHgv/8oVHx+7U8RsFy6FcMI
         V1tjjRvTn1AKM1WVAa+vGThKQI3YyM3LN/WFMxJMT3web323q6S7QF8uBDkVire/EH2L
         LZEss0CIxSLHX7vunxnScKIyGgYQsnBAq3KnR/HsXmyJZ1sPQw6KFwwpWAYkhlGno0dS
         Hs+W4QVE651Aoe5KPii/xdQB8lXnjdVgICF3C4iK0E2td4Y2GPazTes5IvsXIBN1gxu/
         LgSFFKdpPk8tcMUb4xyVEb2GpBG4hpXlUPgVpban86GUif+6dju3U88lWEoT89wOLU5P
         wXyw==
X-Gm-Message-State: AOJu0YwevxvZyH9GrFM6d2wl65BDtkpp7oAoBfn8Hb2UmFQzGXFiCSAW
	RnSp9ae1hn3ikEI7m9+n6O7YYtwrf4fNk/gF+UiRgeaL3KHVkPFgl1gSwKkzI20=
X-Gm-Gg: ASbGncvAKrF6DgNx85RkXPTrP5Hd+DKOOjWP0DRBODJp5nseP4eyU2NLByytIaEmDR9
	BxWXK96rajg8c52IIc+vnlSsT4ZT3rOO/cdguo5IRwc+lPru/B2Msupzes3x2E32CQPDBrh7a6h
	bS6dabx4z1cY0Mjf+JwMOXaFgJ4gOUKp2CvyWFFma8fCnI70sw23Ge7UWqzQyXRUPtL8iE5QVAD
	O2s6RfiJtisV913+iyP4R+zeEmCoQRfBWHlFO+bZhNoRsHvTEiBVgb1i8Nnlm0cEMtDifskl08/
	5677HYEq6h6mJS4KJZXRM91u3UjojNYs2YANrK+W55cg/lRsZJqBHBAS4Rija9fhFW8QMgt9
X-Google-Smtp-Source: AGHT+IFfXGh5EzpevJ90lLPFiR7gOTOcforPZ1I0Vvr8Lq/brdcUSs21qS3Q2pEIsSdxIfk2vUq18w==
X-Received: by 2002:a05:6e02:194b:b0:3d0:1fc4:edf0 with SMTP id e9e14a558f8ab-3db6f7f465dmr3573645ab.15.1747157462597;
        Tue, 13 May 2025 10:31:02 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3da7e113335sm28971905ab.31.2025.05.13.10.31.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 May 2025 10:31:02 -0700 (PDT)
Message-ID: <3f88e8e3-1c8b-4ce4-a5f9-4c9646b6c28b@linuxfoundation.org>
Date: Tue, 13 May 2025 11:31:01 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/184] 6.12.29-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/12/25 11:43, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.29 release.
> There are 184 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 May 2025 17:19:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.29-rc1.gz
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
