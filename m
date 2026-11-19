Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.161.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795102655;
	b=1J016mahj4G2RRylpUlYBED0yYtda2rIdTR1X9oaa/Mh6FjYJkoJIKnvlwN/z36cW8Cc
	 a2tWvYAfxxTLQ19hUyW1Zt7a6+QZUrqA6W2AIZBjg/Z3K7wmTPv4Ude1LRtwyOiKBJS/H
	 co6vqQ5oAYgu8Z7WYF4xcwpFuPj9S4LrNzu2F+B/opmqMYtqVysyfifi8yUOclxQ05uEr
	 0+eAf6IdYxH8kUwF65cr0lNhIp1DlIhQFtzLeKZtLEkfeizZty+oLzWug8SIseBb1ulAS
	 8aeYoSoKG0ov3oIX35AdCeARs9YVvwHNZRsyAivuCM4UnB8GOk6tckmayold6Rg8U3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795102655;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=TO+8nrTIMWn71QJShuf5TRZeIr14Js9cHAmW6jrwfig=;
	b=WaWBBGDIJclUscXjBu34f13mWifY/2kWb2xWWPm1/CcxVLq6Kjna4dr0iFyEs4j+7kf5
	 s24uzjnX867WVO/KHHElrlYVk9tYHqC9UUSNyJfSv2BLo3iwe9q8NHBrUr1d1yp5JQLKg
	 1snftONhb1OR+MAobgbnqp/VhNeuI2IEFhz/VtcoLFJpO5jJk3tl611RLJF5CKOxSJx3T
	 N9dZ2uzFiENHn1ZRTDOlkwPdk4A9KX/2tbbBgqI97+q4bwzENKG1kcHcW+NTawdP9iEnj
	 pRrZA9/YrQ3UTmxk0Vw7pLL3wxbudEbhto1Lf0G5AaVTsPrtW2r/S2DMUfoAAtYqzFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linuxfoundation.org;
	spf=pass smtp.mailfrom=linuxfoundation.org;
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=google header.b=TjYZHQow;
	arc=none smtp.remote-ip=209.85.161.52
Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com [209.85.161.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E173E60A260B
	for <patches@lists.linux.dev>; Thu, 19 Nov 2026 15:37:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E173E60A260B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=google header.b=TjYZHQow
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-71aea92f666so1533849eaf.2
        for <patches@lists.linux.dev>; Thu, 19 Nov 2026 07:37:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1795102650; x=1795707450; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TO+8nrTIMWn71QJShuf5TRZeIr14Js9cHAmW6jrwfig=;
        b=TjYZHQowfabTS6Z+HI50xO+blTkH8RDJnIdkBA4KeFOrr8G7cxYIK7gwqEibWI6yOL
         mLTg2ErJdjejgbOW6KczKvGFwB9Z3J/vuQTy9x6GUlew4qZlHpru2PVQ0T6b0QhLzUvu
         eQvDRRVBpa5bPpVPLkRDn/rlHzi5yTNo+V3tI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795102650; x=1795707450;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TO+8nrTIMWn71QJShuf5TRZeIr14Js9cHAmW6jrwfig=;
        b=MrDK/uZUA5fGT2qIxbqqtH9jowHfA9bVu7zlpRWuI/n4aPpj5k18g462n/baQE/BYw
         diqVyQivAX5Jiq4fvOCTWsJnhLHA5nco9w1CT4q/aX20X3WFJP8ycRzYSIyih1BchMik
         2dnR2F7mxQbFj9tWa9P0dHw5158UHsBZ1WwkjCNSqxFsGxQ7MCgCS/H6lqQi4xZetoQG
         FQoLbGzTVX+8eFnSHFRFHYUmlkI7izxemIYKLDLCHoExz+YWCbf4cjBvDu+u9MXukEy+
         cclI/i7sHiUUdVAoIzqPtbkPF4N4B/wWrCF3t4ow2ItOuSE36mHprDQ8FQ0HCCMbWnE6
         uXyA==
X-Gm-Message-State: APuU4Z9lYZPnXoPzkIXnpUWawKkMp8Nn8Sd2H7zsCUKaaKVvrFYwvCte
	m9DG92TqQIjgpEQyMo1CB27y2WxmFfJhzc8teVw76fCiTF9tnG3hFvJmHB953zY1xtU=
X-Gm-Gg: AYBFou1ued5ZWn31EMYzMeb/7wqBqIrgOCyz1Sw4y7SdsKkKBe25NQhiuVpkaEQ+8kM
	209OHlAD83T0zLicc5Ev8s1clFZD7ivvrJSt08OZREXRX7F/RkVnP3SJ/TZPlGDBrWs9bsQI3F1
	m5etZCledi5hiUwPeS2F8WCeu2fQPzGCyC+cIJzHuxobQpoLiYWb6t3SQPESVj3uYZHXqyJY9ec
	n/mf1lt9FUu0YB8NMROIijOTRtn8T7Qtq3Tp65M34cnR/uJq6R3tkYQ92FGlCyWXttDEkisbl6t
	jPgPAAC9vDMSPaXQKT4an6ZVA3+G4espWnk7koPsFe70ImCxCrjtQ+0YVgahjWKtu5ruOC9cRTA
	ySKkhgod5pBtsOw3+bqEozBs+p0TRqRX0/9i/abvZ/xtzwc8W5GNyPvhqeqF6epctfHhcLbl/W0
	xL6bcjVHEydrEmZNL3EyaFTG2mPnLdL6mYieBLM6sN1r1rTZlRShPUlxbVYLxvwDVq5pQuRp5Rf
	oF80HfrJDHKi2sBY2JRxQ66U2a/ERdWd5rSgpz3z4OfZMMZVbbJi5qTTQbGgagZSkPKzbjB+0dr
	TMYGPBU6yNeFzH2ABoHrwNoVJ0ealwatSHTJNQ==
X-Received: by 2002:a05:6820:f025:b0:71a:ed81:a2e4 with SMTP id 006d021491bc7-71b18293191mr5288368eaf.12.1795102649706;
        Thu, 19 Nov 2026 07:37:29 -0800 (PST)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-862f01f71d6sm5008625a34.11.2026.11.19.07.37.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Nov 2026 07:37:29 -0800 (PST)
Message-ID: <0d95318d-d9b3-4732-99cc-ed9c96c20b36@linuxfoundation.org>
Date: Thu, 19 Nov 2026 08:37:24 -0700
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.3 0000/2651] 7.3.6-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/18/26 07:20, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.3.6 release.
> There are 2651 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 20 Nov 2026 14:55:47 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.3.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.3.y
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
