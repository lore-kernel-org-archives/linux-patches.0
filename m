Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B5F512CDA5
	for <patches@lists.linux.dev>; Tue,  3 Mar 2026 05:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772516179; cv=none; b=jIauFEnxilW0okehCbv7Nplb7pu6LnaYA5pPA/3yQzSrck/AZHw5WvkeqLI5ik9peRV/ZyEg3nUuuqfBKAY31IeVsLFXCUP/N9t1/2qUMpbf9oKBs2hWidOHqZ4va7cUdTX4ZStEhNhfqDYA4FuLRTMxa5Biw0+cVugsWIRJn/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772516179; c=relaxed/simple;
	bh=nfTUl6XfL511CTcdM0JnR/NJoknvfNZI8VA3+qHeMXE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CYM/Sl2QQkFVQad0E51F2PrwV/ZqHeEZMYrtXg/9Zni4ZRVwWW/1aay4uk41Rrx+GxUonccWn5Xe2SPUnTL8LN7X98hS8cPZkFRxn7Q+/AWm4SCR1BudXLnXeLkJVn/e39Tz2U6zBy3nNNsa0haNoTMXp/tgVNOikddGd63SsRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DjTk4AZU; arc=none smtp.client-ip=74.125.82.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DjTk4AZU"
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-2bded9bf7a7so3414413eec.1
        for <patches@lists.linux.dev>; Mon, 02 Mar 2026 21:36:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772516177; x=1773120977; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KHCCjm8Bm4lkp89j7/3fszuU87OHs/Re7pFoKbSAl48=;
        b=DjTk4AZUrddD6NyDcYB7gARJQcptqGytE4zsIo2ipKHl0f1Hq963C/BpprW2aB77w/
         IBLSzeRFgXSg5SFdfAvxLLfYRlqKcO1O+3DmPUS94axVKOWSv8d8ZIJDt8MBSBLMvAuX
         yS/Xma4y3M7nYlrqmKgRVFeVqZwVWrUJg7mQPWPEacV1ozu/jDDpeFTU1DbDvDa2xAr9
         7eOHHmJMx1lb+Iz7sblsnAO7sDKIysVUwy42DlL1fUkw78NqxIaKVc4cNOBVURoFRHhT
         swDrhj+euw/7rDvcbpLel4gyQ/mwWrJKlxJG/ivmfdb4zChhl+cnOCL0VCRF4DPw5jdU
         /MyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772516177; x=1773120977;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KHCCjm8Bm4lkp89j7/3fszuU87OHs/Re7pFoKbSAl48=;
        b=o7c9Km0gtGMKwlk7sPV9Mbei4ylY+7zY8dIe7uO39XJvjCiGVX2WYVklYQwxIsJ0Z1
         PX8p6AH4nRuUKyeHYDqdVMDthZZX6WrNy9K5/H8Hd/D23c0Ms+ei8aClwqVlJkekFzmi
         u3262VHExyDKt2Is4IKWapq1Xnw9rzxYrunsr2aOCMulzfn4sXjWVryG8owi0nNVoWYr
         sPQVb2M70W/gqiEB1lEn2w0fnRy9JWncKll0XkBWzknRZlDiBGKDK7blk8+sLYmslk4X
         z5siGM5UXgd68OzOenCpWt+bKvpNUff1XneKsx1MqfWSt537ls/eSInsAavI1eJnG5/G
         ZPXw==
X-Forwarded-Encrypted: i=1; AJvYcCVmXJFN1OdO4cBL/Hj9J3qFHVg1nZZGYVkah1mmJrfvoeBFdvF/9LJk7TiPuyyxZJ8Qb7SETtoa@lists.linux.dev
X-Gm-Message-State: AOJu0YxAb3pOThdKFB7oMhGu0oejWA67PRCNiPiXY1uggZg9O4Hl1IEE
	CmlfMXV+/KVuHLVG+j69RpxNk6WYMHyabiXiuW7l1nLaowBuaK7z8Xkq
X-Gm-Gg: ATEYQzweBsmzoPfqWWVIXxcFp5EJmA9Pca1r3jjUjBCmWRcYCwNLpXYB1+2wIXvFOyW
	XcdOwBb/tg825/oIZrKsIhqig+VG9vHLw7R0CPPPXYlQpmDme4lrFXF/JPRpZw0c+sTf9E9uPrt
	TuRyXMmrJNXnagCI1VaIr505IXNzGOmgMOjJCAARL9uqiH0ZcN2wOi/Tr2FOaX1m1AvFnprHhD5
	gVlUJff0By12uQCaDR1ydxX9RAuEPMMzX6jMCjZIRGWvJ2ul7aRdXfM8xkPPQn0MCWmF6TvWl5X
	ooXZ4XAst2AoWkR0/yxgLbap0jCzdizya/p/T845tGF3PU/IX2BO8XRLFGKsPH0ta8VhNVHybA4
	RyrQCeyZixW5w3KqrgM47CHVjJwX8F93C9/dkhbujhNYaFVc2Ht2OI4uioOwh+nPv4JZB62matZ
	tpkQ5RYsc6jmVs0lkYKVFYvmep74iCoseQYmqUomB89rpu3pygcYC+jgSUNC2rkFqV
X-Received: by 2002:a05:7300:538e:b0:2ae:5e93:b6d with SMTP id 5a478bee46e88-2bde1fdd68amr4317602eec.38.1772516177484;
        Mon, 02 Mar 2026 21:36:17 -0800 (PST)
Received: from [192.168.1.3] (ip68-4-215-93.oc.oc.cox.net. [68.4.215.93])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2be002ee839sm7810973eec.8.2026.03.02.21.36.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2026 21:36:16 -0800 (PST)
Message-ID: <8b6aaa08-73db-416a-9288-a1ec9b384247@gmail.com>
Date: Mon, 2 Mar 2026 21:36:14 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.19 000/850] 6.19.6-rc2 review
To: Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org, patches@lists.linux.dev,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260302160834.2518716-1-sashal@kernel.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260302160834.2518716-1-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 3/2/2026 8:08 AM, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 6.19.6 release.
> There are 850 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed Mar  4 04:07:42 PM UTC 2026.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>          https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-6.19.y&id2=v6.19.5
> or in the git tree and branch at:
>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.19.y
> and the diffstat can be found below.
> 
> Thanks,
> Sasha
> 
> -------------

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

