Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 527B13002CE
	for <patches@lists.linux.dev>; Tue, 28 Oct 2025 22:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761689525; cv=none; b=AbBnY4iQ6kdO+J5LASuIs1qZ6DgeiAS5koLg1z2iQaCIJtshMb58l15+AWlWszmP8hMY2cmd1d0BHL2/2AUJRhO5jK+36m2o63VYdK+qy6JHZHY8QpoMhkwQx5yvqk2dySUl+UosL10/fM7rl+abLq6VRDkwamSG+kcE7u/i2Fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761689525; c=relaxed/simple;
	bh=Qx1dpR4Z5VFWuR4pe3KjnkMHzfKUXq4FOnh7HstojfU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j6dSr0HrFFtsSigoOfCtSwRp+4HcUDOFph9THJ9TJr+lbF6dREyjcICjbCMaVNMVwND+KG3E7qJA6v6Q7m4T/oo+M5zn51wKIB8DrTve87ah82EL870kkwHcnvYSSDWu3pNdMyLvbhV8xpmxeg+9fPkC+Wt5eTK9/7UXTUVFaQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sladewatkins.com; spf=pass smtp.mailfrom=sladewatkins.com; dkim=pass (2048-bit key) header.d=sladewatkins.com header.i=@sladewatkins.com header.b=OQP7E7VI; arc=none smtp.client-ip=209.85.222.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sladewatkins.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sladewatkins.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sladewatkins.com header.i=@sladewatkins.com header.b="OQP7E7VI"
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-89e7a7e0256so522887585a.2
        for <patches@lists.linux.dev>; Tue, 28 Oct 2025 15:12:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.com; s=google; t=1761689523; x=1762294323; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Yxf4SgMlhljxRfzO4HwJ4G6Vr60VuBp1eH0raIEYlEY=;
        b=OQP7E7VIUowliJZw0pBSHluremULXwnsFjk0CHpNkup940USFwCqhKTKO64iMlNjQb
         qnmpYHz62kyenH1l4eKQmm95/4xk+jY1nKB8pTstMAHWDcJs1wT3f5eHftA2wCzYWJXu
         PtlpIvCIP7X1pWiLFT1Zz+dmXW55Cue895w9nMrgdGRLhbzcEXojBU171UoO68na5GYD
         RTfTkyK37zH7BqBvyE7zMtjUKx+aOGNfUfoJSjr2kbRyd6rqbLM/A8DBX2blp8Z6DtAw
         Gjl9P3X4wtUm2nCJZWlSCifp4B8j/7i5fP53+zsT7VxmvRDMvhXNprGjTI6Us0HnIDnv
         brEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761689523; x=1762294323;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Yxf4SgMlhljxRfzO4HwJ4G6Vr60VuBp1eH0raIEYlEY=;
        b=AW3qFW7qirUJUe1728DeseZmqgjlUWUCvBqlxnqCYzjqjs8e14rxmtW/pL+njeZU0+
         xu3KOsczArBZWINJClo4trIOISBZzoeYgFES3e/0Tk1PNvac/PPyWoW9ASkg6fO9L2HA
         zLZ6NjmKInbtz/ryxTwFy2HixgvBcbW8beJLLPIs8GlKvkQfKOdhCIGL7NyaI+xzLlXD
         EsB/r7ront8CpLlK6SHHlhJZIFCSebD1o2gYoey2JIeYMf8DQuo9F7pKB+U7yaiHUti1
         0pBzu4NaQBshZiIyB4kSsR+ocKS7H0ZXnZnkayJ5c/sAMB1lTdYKB6JnaUjeUEJTxY3Z
         5NMA==
X-Forwarded-Encrypted: i=1; AJvYcCVKs6/NrNeXYqUx8hb3WBvm3FommGPjvVGCIAanFEgEMf3RChcdbwz5cPmASNp2RcjoJZRdJg4X@lists.linux.dev
X-Gm-Message-State: AOJu0YzHyRmwiWSoLU1xkQ0nJoGg/AWBMN6SY5M/2Rf/3y2gmU5qxEZF
	FDfS7kyvgOnGWSA2U9vsTrQ2mTdFI7NwttNO03pBrs4zVybovO1fgryzF+gQko3M574=
X-Gm-Gg: ASbGncvOHxSzKD8khPzet3QJA+K/p9nDdX9XUdTMSl3bBcHCwZrJ8WGDE3wL8QNwDmu
	a3+j9LBhuB0R1fN1I7lFqd8bshbtf/zhf2RRja4/2P427mV7F9uQ23Qs++basEr5GSG+80vz5pQ
	JOskbXXyBIkC81eToHAlm/ufSg2A2rKUTHUNM46v2IT6EoK1AtxlR9+CH3ch5ea26I4rYtwZa5E
	5taH+HdEUT2wpVigYmPbKt4ihyFQf8a1qfJHMKD9VlZc4OyeIHUNQvkGRo4mHUjjzkYUE/MgcZk
	TZw6767S3w67sFlUCLGBcMf6zEtTyudjpTV6k88nNvJYpfYXvhhvDLiNFZ2LKPPGK5CZCbBuLeO
	/a+mcpmd6TqaeYTq3sKttNAZIBEwdaswGB1LjbX8h0SFbMLheshz8YIdApK+ZG0QuhV5Gp8ysY/
	EuYxyMuoxoRT/Lxw==
X-Google-Smtp-Source: AGHT+IEuxLZFeeurzwWASjRayjwc5R+HDg5nYPnfTfXlcqnJxlxd958na83WIBclidyoi5t/YfRt3g==
X-Received: by 2002:a05:620a:45a7:b0:8a1:c120:4620 with SMTP id af79cd13be357-8a8eab66367mr103423285a.45.1761689523165;
        Tue, 28 Oct 2025 15:12:03 -0700 (PDT)
Received: from [10.10.13.73] ([76.76.25.10])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-89f251b8a24sm892468585a.25.2025.10.28.15.12.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Oct 2025 15:12:02 -0700 (PDT)
Message-ID: <2242a1ea-d6bd-4593-a884-3c28d8037e1b@sladewatkins.com>
Date: Tue, 28 Oct 2025 18:12:01 -0400
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/117] 6.12.56-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org
References: <20251027183453.919157109@linuxfoundation.org>
Content-Language: en-US
From: Slade Watkins <sr@sladewatkins.com>
In-Reply-To: <20251027183453.919157109@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/27/25 2:35 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.56 release.
> There are 117 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Oct 2025 18:34:15 +0000.
> Anything received after that time might be too late.

6.12.56-rc1 built and run on x86_64 test system with no errors or
regressions:
Tested-by: Slade Watkins <sr@sladewatkins.com>

Thanks,
Slade
