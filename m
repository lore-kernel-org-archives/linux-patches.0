Received: from mail-oo1-f45.google.com (mail-oo1-f45.google.com [209.85.161.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F24E3E44E8
	for <patches@lists.linux.dev>; Mon,  6 Jul 2026 14:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783349514; cv=none; b=eOVuAkuD69J+msJIb5MaUVRGeqM0HLxmGHWbGGBNanKxWj+TqIkKGJZnIKsgqg2lpb4sk1uo+esejN4sA+aHq5LofYou8MD38e0Hkkit5MmEy07DjrB+mWB0cI1BYf1h5123C4m2kqlWeTeD2geIOkU580/iZXBDzkTTuQMk7Gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783349514; c=relaxed/simple;
	bh=sq7xbhnc9EjRi0Ay1bR2dO6JbTROjVeGnProqyAUdg8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rYtZa0opGS0ET6XVI6H3CEEQtMI/3PEePpz+eFSD5QQIK7HXJmAkf8TX+jqbaqyNIPUakjq3e2XWa4Ra/N9A9rXXsPG7VmZZ4ilpheU/hAHa9WTKehatcnmurIh+/gVuEXtwvomh1FJhUrl1yhZNVOb1fQiZt7ZdKptf21xsjyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U2CWcEj9; arc=none smtp.client-ip=209.85.161.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U2CWcEj9"
Received: by mail-oo1-f45.google.com with SMTP id 006d021491bc7-6a1888969ddso1791113eaf.3
        for <patches@lists.linux.dev>; Mon, 06 Jul 2026 07:51:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1783349507; x=1783954307; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2wkpr02sORILsW4RehBg9onx4laNz5hB035kvA5lQmY=;
        b=U2CWcEj9bXl6rUI8V+Mos1OIPkOulJwzCsmhr5SqmDv6GpTB/y4rxRCOYqFsl9j+KV
         JGCILXVqP2JamuPcvvNiVaS7tNb4GMTwu8HzuUZAgnv9jHT3n6XG1BwO9J8mvyXB00Z1
         zqY2rDWsu80lTRoBBixiBjmn/c1vTDYNn3VpE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783349507; x=1783954307;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2wkpr02sORILsW4RehBg9onx4laNz5hB035kvA5lQmY=;
        b=IhIjnCDl6V3kviyGmpqG150sCSG9pO6y12f0Q+rwWnUTSa8+g5zscpg8ZH3XxPbcV7
         3zjFrzaPXZY+6Cu8+yGEWEtqHvOQnAGr0/K3pa1d/ylWIueiqvAst/KkF46j9tjj/5cG
         uz/finQ5zLrw0ArKWTDE5O1u+LPdpEZzIT4TMMUeMqALK98m8C/hGfrpu7J5GPRwzqJm
         xWyksQJ7TktsYnl3A5f2VNkBbFlnzga0W4P8KplPXE7HgbixZuOXJWJmO3ofmB+uRi0E
         MfI7JuK9tB9P4A41Ee7wGt1MqplFD+8t3kcT6k9Q/b0cyuhMTbcDeEvPvX7oJm092IgM
         XpjA==
X-Gm-Message-State: AOJu0YyaKv+uPa5m7+plYOXCcC9NiNO1EVh1IkM1cuOzaH++9umVHRd6
	DqjgZMNEV49U30QW2HqDELVecRWmMUHAz60vDts3gMdUXwOCa0Ul9uz5CGsDBhqarEw=
X-Gm-Gg: AfdE7cmZ2q3MjOnz3/nXJ0i+0s/9IQv4nhKr+uYv87CvDS6VexzOfzvlYibuk/8NxTZ
	Ey0uXCFAkNleMAEtxoLILCWjS31kU+iZvGImkjKVXmmUzh237VyqZq6eATHnGjjjm/5XKmEEwjR
	bApI6cM072dbyFTDf65w13Z1sPxOpDtCY6VZfKpqwKjtSLJd3/o0WxfKTXBWB34gZbaJTWZUCuz
	dsVEhjvHdUkfPkPbafbY8eXSN4omb7iMmjF8lCpYZUtXgVVhqMpzGWU/LvTeSHcmNLbwy5YZxbc
	UWBih7xKC5esi2FiiIqpSUZvKpq+AudiPExOdSP4upOnmyuJQzZ7qCUsxU9YXy8jmw8cXM24NGw
	FcuDOWeVoqa7eq3FpRfhQNa9wY7vZNWgnM67tq+y3nennAMDxKFn6Eygn+wg/N6g4JbBK9vlUl4
	TYW8GeSTAKvOsSy312X1QM
X-Received: by 2002:a05:6820:6ac9:b0:6a1:50eb:d4fb with SMTP id 006d021491bc7-6a3553d9de9mr521946eaf.60.1783349506968;
        Mon, 06 Jul 2026 07:51:46 -0700 (PDT)
Received: from [192.168.1.14] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-44cfb13e15esm11222998fac.3.2026.07.06.07.51.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jul 2026 07:51:46 -0700 (PDT)
Message-ID: <8ca09aa7-7ab2-4ce2-8484-ebb2aa0e8cde@linuxfoundation.org>
Date: Mon, 6 Jul 2026 08:51:44 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.1 000/120] 7.1.3-rc1 review
To: Peter Schneider <pschneider1968@googlemail.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260702155112.964534952@linuxfoundation.org>
 <0585b5ab-f9a1-4922-b2f4-167d0402758c@linuxfoundation.org>
 <075e465d-bd07-4fd9-8641-30066e966d07@googlemail.com>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <075e465d-bd07-4fd9-8641-30066e966d07@googlemail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 7/2/26 17:12, Peter Schneider wrote:
> Am 02.07.2026 um 19:44 schrieb Shuah Khan:
>> On 7/2/26 10:19, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 7.1.3 release.
>>> There are 120 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Sat, 04 Jul 2026 15:50:58 +0000.
>>> Anything received after that time might be too late.
>>>
>>> The whole patch series can be found in one patch at:
>>>     https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.1.3-rc1.gz
>>
>> I am seeing 404 on this link. Maybe I will it more time for it to show up on
>> kernel.org
>>
>> Same with 6.18 link - haven't tried the others.
>>
>> thanks,
>> -- Shuah
> 
> LWN has the story that there was a mirroring issue due to a misconfiguration which led to the deletion of everything under /pub on the public mirrors only, and that Konstantin is working on restoring everything.
> 
> https://lwn.net/Articles/1081015/
> 
> This is the ticket status at Linux Foundation:
> 
> https://status.linuxfoundation.org/incidents/3y1k8b4ky71t
> 

Thank you.

-- Shuah
