Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B22CE1DB375
	for <patches@lists.linux.dev>; Wed, 15 Jan 2025 22:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736980220; cv=none; b=c2muLchBF0K0pmga+y4Pk3WuNWdT2/4Zmpz/5dyymnZooEbuiDN80DEizhBqY/rb69e1eKVhjoV4hTtdb3AjongJNZJvR98nw0C+HBABla2UoTYrBzlsjKf/ekXsKovLNeLblsdv8+yZT0MU8jCqpCkNKr8rbPCxXh3RXH+pNV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736980220; c=relaxed/simple;
	bh=vx6wcL04Ydt7tNuVr3fr+dVyXTGGZ4LzHWKkj+ssP5I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KnZb6HvgaQGOlLMCgYJRZpSm39gBS5l++G2KLk2HgWsFhUoGS7ekY1/S76QDwiku1QPY0CjiRq/VUYDXsy3oFt7yYhYsY8pCiA2nHy0W90fFv1WHEEfKEZvnVphROkcNEolNC/brukvlrFqe9re07XzxUEJwJCUVk1ZZNJkEYAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bWHFMqAu; arc=none smtp.client-ip=209.85.166.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bWHFMqAu"
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-3a7dd54af4bso961955ab.2
        for <patches@lists.linux.dev>; Wed, 15 Jan 2025 14:30:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1736980217; x=1737585017; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZDzLXjfPdjDlNmIBVryULcTBacgMofahEFhz1hfW49U=;
        b=bWHFMqAuDjALWX9cojCL1KlW+9UAqj4+PbKaa2JXqNoh95zsVESRjdCNTdoXkM11n2
         yBjTpbXxFQqRyplIZTJRTBboYx9MYI+Z5oRhiyYw8Te7DcWwMpL46BnsDX+D394cTzGi
         A6doHq4c/cVnh0PuoBIZx0J/j3wdAImHk8vIM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736980217; x=1737585017;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZDzLXjfPdjDlNmIBVryULcTBacgMofahEFhz1hfW49U=;
        b=vjuKKYQxnG4GObVvfGDPtH8KXo7kyiFqfiN7SLhpEccJ3QKxX28Qowyl37UgSktzqI
         NmozXsL9k+Jlfhfb2eFBkj+RAARJ4yMWSlZmzFximv+I5nfs5ocpl30Zxlvsd2Zgw5D4
         Gp6EwuTa8Hs1FWfleurery4WCi9aCGobIh8IplKVKSxIt1aKw1ZwQvLZo3Vo29ubk9g8
         /ZeEYKGcP+89aOF0VVjxKlGcjh2AS5B9PV+aVNe2iHqalNcElSM9st4eCDfZHQAqwjl9
         nblWhvFVoSK36lgTE5Bh0M154FpJC/Dfpgu9aagUgz95lZUr7tN82P1sRJyQhfN4KN+k
         aIdw==
X-Gm-Message-State: AOJu0YxrL97R4LCJeEakKvFuTO4AtSYDPMqx4AYwGS+6HGfGrfnC35dv
	ldWOGnTooq+Y3elDUT4+rhlVlNNeJ4bNsUYtxOO0rPsHTPkntVzW30+jsTCa8oY=
X-Gm-Gg: ASbGnct+SktkF6COYWjBIJRyLVp9HQV+1b/R7y0tK9LU+RMGwb7EnqsYM2keP/pUDmU
	Sz/l8qf8gfaMNy7JBua0IK0EfKFRFAVC6We8sY6ji+8xBTCFSN7+ZHqDIo26+JQRC2TI8g9H2zs
	Uu8WPTdA1xAK+Ru9C7P3lUMZSuwWHI/v2BpOzQF1VD1XtjSf4EAQsj4otb8atRBhipHbSoV1cjm
	mNT9PcBFuImWposhBaqsYCnFydw+x7NohC8efoc1L1ywa7Tkb1BpB2RixJaNHb0vzA=
X-Google-Smtp-Source: AGHT+IG2WwtUP/JJuLB77C/BDPZHNFfY8VRwYLryPnpSnDM0EUaOK4FaiQwxifegqpwHOzYfSllctg==
X-Received: by 2002:a05:6e02:188a:b0:3ce:8d4e:9c79 with SMTP id e9e14a558f8ab-3ce8d4ea151mr30799685ab.4.1736980216846;
        Wed, 15 Jan 2025 14:30:16 -0800 (PST)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ea1b611829sm4387550173.33.2025.01.15.14.30.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jan 2025 14:30:16 -0800 (PST)
Message-ID: <56bfd53f-6fbe-43a8-b565-131e47b92d59@linuxfoundation.org>
Date: Wed, 15 Jan 2025 15:30:15 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/129] 6.6.72-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250115103554.357917208@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/15/25 03:36, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.72 release.
> There are 129 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 17 Jan 2025 10:34:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.72-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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
