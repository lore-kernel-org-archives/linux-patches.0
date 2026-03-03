Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A1D9397684
	for <patches@lists.linux.dev>; Tue,  3 Mar 2026 19:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772566440; cv=none; b=n/3E4Kxd8+CEPEMORGAqLsnDyQLUO4AjQV6Tt/PPICdlZmt4mOLF1zod9qTr98RRGPFpuHwxCGTV9tdt6j5VIvdh8z8S6OiJgw4KRu7JXYFC2XmjjioOTa3mdgq7tvwGHItq4k5M+se+Y+xxWsxsyHYSXZJRM3Vwex8iiy20RrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772566440; c=relaxed/simple;
	bh=v4W0IUWNCjSldMoui/Y6rMkmEfuNqcADiSf1iVMKr4g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MYAfLzXbIlRoCbVloH7aPm8+n52qACBAsawgmV/I70m9bAnO/xIJwJqH7bjFQ0B1KWdpfmpKNEz0DoKfNfqSY0fgTAsrQq92sus5w/HITn+eleB8jQEzrhlCSqzmdF5nb0rs2apGNxc7rEGZpjM+XnVAkQuqL/CEcL6myBRq08o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AsIcM0Li; arc=none smtp.client-ip=209.85.210.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AsIcM0Li"
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-7d18f80b5c2so4535492a34.3
        for <patches@lists.linux.dev>; Tue, 03 Mar 2026 11:33:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1772566437; x=1773171237; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UZviA96oGVQXRs9IZPnXvFy1Y0ZE+xhMCmch8AHXIZk=;
        b=AsIcM0LiAC2tYugth2nqkVUEx0EFAmVtnBMUK8rtlNM6HUemld6Hi2okXdid9Ci+hz
         NHa3vgJpdMHnbKtHU3+0yiRCQlMi9tpU44aOP2cJc0PI86Jfn+g9GVfJ9mDbIXdDIAhe
         92p6SMKk10WKCWgr4p/nWR1yXsqd4cQ6CtNfo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772566437; x=1773171237;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UZviA96oGVQXRs9IZPnXvFy1Y0ZE+xhMCmch8AHXIZk=;
        b=qgplpng8osK46dca3OL2+F9HAnOmr0rGLzIkwqnulPZ5sBJkX5/jUeAHXgv3feNCyj
         1V/P+hZzH3Ql6WCBojiOfptKkj6ny04bp/xWGc+BfFiZLLPq0k964CI8UNRnEGxBCPTp
         qOcdZ3LqurODSn92DZadqWodIZhVvudmJaMlreOpBw6Zf6JoYWRHs6yk3VDeEzyC1LVe
         TujBBA5KbyANU5TpXzHez2JkKoDkvPkp/cbZeACMha84PTTuDimM0VrRoRAp7I7tBk8R
         z0rP2b5obZDApPNkqdfmlin4apxJxv49Unw83tj1r6xywN3h6UtlGfgnolxekhOiQjVf
         rM9Q==
X-Forwarded-Encrypted: i=1; AJvYcCW8+9ZTFPDcOh25Ri+Izpz73+yOf6EVSixZo86PeGBLYnGYG9c9P3GyCMeHogNyNhZjRTR2JukH@lists.linux.dev
X-Gm-Message-State: AOJu0Yw0TEKKoJJXBDqJ4y9pHsc171mP0Ry9nQxuFQymL1BKd+e415Aa
	KXpCmAjnLQp/dLomgUTR4eL6iqvXCnjV+M9u3pZclIWdRfiNhggHF16ITa+ZqONb4II=
X-Gm-Gg: ATEYQzwBKsg7hX4y5g2zDXDukL2xeXpWKQai1t0NmZxvEW+vEAKBwaDj1cVoNKZTSZr
	iY9uDgoVC73W5OobKhlot9xuP/8xqXjKbogT+cMZXCDlkSB+tFW4GUJLTLH+Ssv6rDtccA6lOo5
	J5UHiH5SM/y693hlZrQE4K8T2Ci0+jdlgf8YTxNzSDeSzEYgYfbGVGoaz7eblmSdjDVdtN8/K6j
	f6R53ibBplczMCG6Dg30F0mB2Ys2/hKxd9C2/aQZVs3hrJ+yT+Wh+6VGWT3+IR+B6XlLe1rK/TA
	0Rtp9ZrmVAG+S+wTLh9UfK27ztduavvJm7oGSGNq2D0BSXiBPLn/tkcy5e7M1yb7PHA7uGb3hD5
	5UiUDEzZ6hHuhGgpL3Sihb3kpolGGmuTeRPS1BfcuUl6S1ekjFiwPreTva9tDcHsvzlgBZP7/fY
	S9biYf1w6LSyHtHHC4YpwlkF9BsrFr1WjnHpw=
X-Received: by 2002:a05:6830:d88:b0:7cf:cd4c:347 with SMTP id 46e09a7af769-7d591bf3726mr9485677a34.30.1772566437473;
        Tue, 03 Mar 2026 11:33:57 -0800 (PST)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d586626895sm15470339a34.18.2026.03.03.11.33.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Mar 2026 11:33:57 -0800 (PST)
Message-ID: <aba962ef-e824-41c5-846b-a7cf04034575@linuxfoundation.org>
Date: Tue, 3 Mar 2026 12:33:55 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/684] 6.6.128-rc2 review
To: Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org, patches@lists.linux.dev,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260302160934.2521545-1-sashal@kernel.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260302160934.2521545-1-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/2/26 09:09, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 6.6.128 release.
> There are 684 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed Mar  4 04:09:32 PM UTC 2026.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>          https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-6.6.y&id2=v6.6.127
> or in the git tree and branch at:
>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> Thanks,
> Sasha
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
