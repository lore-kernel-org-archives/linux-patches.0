Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33A7746F4A5
	for <patches@lists.linux.dev>; Tue, 21 Jul 2026 17:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656102; cv=none; b=A84EagIpmTrheBBm1dvam4lu2RP3wnc7ZdDEQ2WLgJddeygXdkOXOUSX27My+1SsTRjO3N60Om65V2jlYLBJp62OCf6FznNmTb5cWlfFKqZCExr4W6xGlGwzCz5b1Pa9sRLZrTXb2HjBUJntRqakidsYvCgVCG6p5OtqivOdJCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656102; c=relaxed/simple;
	bh=z54MjucnwGiMuLytprU1meauzDZpnVxUhp878AqFPHg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nUv7OqwRzb71lipAhNVV4TREVqr+gdUJQ3htQYmq6DFwgzQktzZ7e5IrvO4Iakc0SZuVQMHCSRvjhELDlS0irhfuICxj4UZ+drVo0F9qbcqpC+taF799D6UhkdQSJ3g2NCyVcwLWqLje9vsDwFC0cx3sZ8JTCtDNnyi0WFRN3H4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mWz3QnmS; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mWz3QnmS"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-51c0a81d286so47538031cf.1
        for <patches@lists.linux.dev>; Tue, 21 Jul 2026 10:48:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784656094; x=1785260894; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3sA2bQLKGkL4eSJMH3iVxOG8hSipTaYQuYvaWYUCx8c=;
        b=mWz3QnmSj8GDdE1Nnex0yovrl12gRUP6o9QWsLuINgQ8zgZjmcOg2I0kFF6fYTeMyp
         somn0VGT9/bBgt9FqpthNNrUbplYdUMJx5YTjX7rprBvBOSH5jgDN//zWYQCcXXM5AS0
         J+jKMdGJ4TcaEZd4/v3cmIdjoXpBVWMA9cNHLIZEtbhhZbAR/XHBphHhiUlZu3b0aPhl
         vt31BWN1NrPygoIoN/CfCYf5XjcJBufqgym2b7PNyMbhv3mhvObVzCDzBBsr7Rjs+/RM
         A2benHMtGk0/fnSygcfZh+p5VkEUxTYTtdPzJ2uaj6lIFCIv+E/AMvVmGwc9kFVZd5tL
         NZbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784656094; x=1785260894;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3sA2bQLKGkL4eSJMH3iVxOG8hSipTaYQuYvaWYUCx8c=;
        b=Jrq3vBKROrCJYK88cQxAnlsO1wKuQfFKeUU7yS/wsaQU23nB6jZPUflXI3EGUHCzLi
         DJ0MMaE8EhHJC0D79H5dbErZVcWT3HU7duKvIC2YjVgbR6M8FMGd50QgvJEgnbc3RhnU
         BAWZDyJxqJxGRTPQHJzfG3jmZfXCqzezBiaPSEGE+NBKBn4pJoMYz0o+hkQjSSjocjB+
         mb4cd4XHiYuxahLGjPbQMkhaWcCW8ayag3DPp74umm7g2L3k5y3czLOzqwcuhNu5nI1j
         XbsoC0jKTxwlCKumG45oHf5ipk1wpbarfHHJ4+qBfLT1KxeqS02Le0QSSZkTcNRTIfU6
         8fKw==
X-Gm-Message-State: AOJu0Yx7Twjr6BI0OTxfsy06iY/jE/9PE05UI6kfG7aTveba74NvuTUH
	755ebxYphSKJUUaIMfvhFas8RK00WLdlPkpZWOzIKbjJ2oa3h9/pw0qsyzYdIQ==
X-Gm-Gg: AfdE7cluUgJi+89sBZg8PgstIFyWijqu4QDVMhPKo6sOsMU3Lg321QXgDqc1Iu30s5+
	aaRd3Md9HUh2SNVrx7X5yIV3v/g+PcgLds1jOzKu9SFZznYtME5z5ikyosy9Cwddfsinw+KSas6
	iwri0GqMg2S4OVN+ujKxsN3rjlrrnkjt/TRgKvqmQC/1eEVy6l84SRhfwu9e3TtAwL9fwccwR/q
	8bzbFHLybunp9nrkHFAdhWVMT3LkLwm5TL9mUx1B5Tas4OACAXItY8n9BkYzyaUKa8Ci+ZK4GkT
	d0hFTnMDSbjmepl5SIOzqitGlCDDOG8DIMutn1wilXdQYoQSUsDyl2CSFv6bYMhNFHuAJUJ/Fnw
	7+DIApTtDUbWoY2nc6A5cO/HKdBzKOL3Ch095/agK145eBXc8Ufm9D4gQBwvz5CJGqEXv2o4oPt
	ySDryU+hJ3BGvFSkGXXHEACRODutzK
X-Received: by 2002:a05:622a:958:20b0:527:7406:56c4 with SMTP id d75a77b69052e-527a6508866mr5249551cf.11.1784656094527;
        Tue, 21 Jul 2026 10:48:14 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5214d2896f9sm99528351cf.13.2026.07.21.10.48.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jul 2026 10:48:13 -0700 (PDT)
Message-ID: <8869a0f4-8e26-4f83-b258-f633a6eb6da3@gmail.com>
Date: Tue, 21 Jul 2026 10:48:11 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 0000/1611] 6.18.40-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260721152514.750365251@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/21/26 08:01, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.40 release.
> There are 1611 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 23 Jul 2026 15:23:00 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.40-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

perf fails to build with:

util/arm-spe.c: In function 'arm_spe__inject_event':
util/arm-spe.c:472:37: error: 'struct perf_sample' has no member named 
'evsel'
   472 |         struct evsel *evsel = sample->evsel;
       |                                     ^~

due to commit ca625699a8d5ddea7213231f090dab1e0ec0380c ("perf event: Fix 
size of synthesized sample with branch stacks"), it looks like we need 
to backport aeae075a0352eb6ab363fb1910f209eaa296a175 ("perf sample: Add 
evsel to struct perf_sample")
-- 
Florian
