Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B0AA18AFE
	for <patches@lists.linux.dev>; Tue, 14 Apr 2026 21:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776203385; cv=none; b=LrfXfyoA2BQ79gJOkj3/4liPHgJ5YOWirw4u/B2RNl5g6yAzraQIIMN/6HKavLYPNtJCmGMYUNlu8gDktKTOxDrmOQkO2/j29TSP0ipfmzypXH/B2dplB8WzRVXUksclMhnh30MkYdhcwGi/1cvRQTWTo5zrv6T5iFWYEciaH6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776203385; c=relaxed/simple;
	bh=ytcqA41zrL7QUs8Xha+hnKTXzfGRT0PvGOlj7ME6CtU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F8rQdgIbkIQYLbKKFyWmDD/uC3hvml1gBlldSbYmhMZNxE3I3suakKaRiYwRGsQ3C5gcRv0nL5RWJ4T97HZ0G09SgrQHpLC5db+3zL1Nu0/IXREyK+6ZgaDdJCrtExBoJBqiy4QdLKsrRDF6DoDj7TdkGj/y420ikou/x15b8DU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FmcnXZm9; arc=none smtp.client-ip=209.85.210.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FmcnXZm9"
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-7dbccf6a23dso5850038a34.2
        for <patches@lists.linux.dev>; Tue, 14 Apr 2026 14:49:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1776203382; x=1776808182; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/ls/MF5YlFX8eWIIa5wJrWeJBI0E64mcpAYTvQqf+Io=;
        b=FmcnXZm9fppWvupk2hqd+BYTN2f7nVR9IoAS21lhJrO8aZ+mWMw86GEBpZuERh2uik
         C2duqyBxWB6e5RNjGOq/6+mVsevXlGC4ZxZ5gb2VRSjn4aB76jFueIV2lOYpLVrlPQk3
         JIxFGc3tdkAX/dU+w71hfG1eVWTBp4Xxsv3+Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776203382; x=1776808182;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/ls/MF5YlFX8eWIIa5wJrWeJBI0E64mcpAYTvQqf+Io=;
        b=nFl1VZ9wG2Bf8UVWChqcZ3IfD+ENBzMCc933Wwc6Hl2gr+DdE0P2UVHVA4rcFEGKIf
         Gik0PVbFFbjRKL8VCZzYWbJa1jxaA6cPLDzIB7/Be6FpF6VUfGu6jHmq1E7RopqPEOYY
         9ZQhxRk71xpkCagAHw3K5xRjmpZuMeKn0NxS6xGh7AQ+aWssfGSBVK5dUrQigXsz4fJC
         9wFoghHQOn8TWIKRzaVw3nDLRXP49ndf2vwqRjtqstEiJhfkA+4S5SwDVYaUFImhVVWe
         4Ge4xC7vDjuQDaoRuXNSB0MTnd3plKW1kTmPc5PmN/en7yspyjJnmPZH//44FVX9AFnj
         /VBg==
X-Gm-Message-State: AOJu0Yz5TAl9soazg1tlakqwb3rXcm2j+tp/0DeatRqR8u8/jO/5Mj65
	Oe/geL7bebFQfS0cfgeTC2XS9wWlcAJIhqF5MuTPoV1Qq1XL1wOU0sarK6mlxfRt+Lw=
X-Gm-Gg: AeBDiet8FM/af0uty8CN9bZOZhmQYkWoljx7qumkr4LrNNsBU2cITq12/uRBXLFFhMA
	luVuXRlVdEHmHAjPcFMfnl+FG0kKaRvkhWGyHOfCTfKnByAQySjCTK7jcV0yMyNf+rgHFf5BRPF
	bqcezViZX17Cj4t/KcoJuKy+xreuMzc5dmmSUTaUGQ0qRMDKNcP/0IoY/woEodfX8YdRlcjQ+D3
	uqKMRxoBNBM1v/uO+v9lzEa1Ga3UAqgaDAK3Xv+cg8DRS4qqRWy6/P0bZRd5v0pqQMpNntfh7g0
	00PkPKwd+goxhqAy4/jIGDbyikVoNVV4UkDpNLmui+9I47gdYcg0PupoBFTIJIwjBa/MqltJG5P
	nHv5Q0av+QIRmXyX3MeyHqP6ll1DHHHbQ85VI0QjwuP4Znb3qPks8F3NV2HYpXyyzINBHL+p1Z0
	G6+qQ3Pgask6oZ+/LwUKheW6PewgGVwYo=
X-Received: by 2002:a05:6830:67d7:b0:7d7:ef0a:1ce9 with SMTP id 46e09a7af769-7dc27f0b2d3mr12296295a34.14.1776203382297;
        Tue, 14 Apr 2026 14:49:42 -0700 (PDT)
Received: from [192.168.1.14] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7dc3959099fsm8932418a34.9.2026.04.14.14.49.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Apr 2026 14:49:41 -0700 (PDT)
Message-ID: <356f0b83-9338-4b23-b417-8b72f760d0c9@linuxfoundation.org>
Date: Tue, 14 Apr 2026 15:49:40 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/570] 5.15.203-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/13/26 09:52, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.203 release.
> There are 570 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Apr 2026 15:57:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.203-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
