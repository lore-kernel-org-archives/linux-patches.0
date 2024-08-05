Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EB0015F330
	for <patches@lists.linux.dev>; Mon,  5 Aug 2024 17:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722879779; cv=none; b=rHExGzzYzkPQB7KTsJUk8xEeZTFHUQeJy//X0WKzuFcfHLvfGxGdhvJII2V7JHukj9uSaJDkIDq4IjoniPm2MQE8ClxmmjkEr2NbPAJtI+Oy7/fzeu6KbyLnPKuDOYC0kNFivzLMXPiMRi7z48MpXVeZL/MOvWm6Uou6lKv3vxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722879779; c=relaxed/simple;
	bh=dVcgk1Ne85Fv0mC3xhxmoZoZR7RbyGXDK5k4NffPkE8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=U6GG2kDTc6RnYbr8MXu8xtrdH+SGnCnFJTfHtRisosHfqtuzeh7IFHCL6tBO6Ze5C/ubIOKpBFWyfutPFeM0dmgwPUK8iT51r0blXNbkqPtxOQ2TnR6Pbu5ntl6saIloMbXWxs6MSLQPkBUlsyumuJ7IHY1/DoPHMU299PQgbG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HMrGguhm; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HMrGguhm"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1fc569440e1so95098205ad.3
        for <patches@lists.linux.dev>; Mon, 05 Aug 2024 10:42:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722879777; x=1723484577; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=6VbQh8mSbRW3lubvyrbJti/A8j4Q7wUIF9hsHCo7CWQ=;
        b=HMrGguhm2Uv4ybxkE8ejSfSd1/MqLGZ23ewxtIAVMecm1cVaCuAyFoCYob+N19olgP
         193nREejcqAP/dV8l5VZUJkWsbr5uElnm6W/CYKthfa+9/gjZngHY7S91MHABkyLF5/Z
         XM6+0MnTvYbkOx1BcMuhgOsJpPUVwv3mQ5haJTRffTEYoTiqoXZQre1LFcXr/l2c4355
         VZ+vzNkb174JVOVRBNKJF7Ci8eO299G4A0LUF0jiAbzAVUg+pF0/L/xr+JWxCyHqyD5T
         /YSjfFXWUX+zhfABV/n38enk+WhoE7hSa6yGgpsTpdhh69XFr1OJA8oBtKeaN+ME2FGj
         8F1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722879777; x=1723484577;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6VbQh8mSbRW3lubvyrbJti/A8j4Q7wUIF9hsHCo7CWQ=;
        b=ZRhEPg4+pXnm5dj/oAQ43JLR6dBPXyYvPnVv4S1JehAGWtZkos2Eeyxg6qUBUn2CtX
         H8lFl0Aenou1b30qvh64N0LO2BTW5dS+teh93/46Hss3w766fepe1l8WsI9YdZjNwV4t
         gl9/8EoIqQ6puOgYPQrQip+HRDg8MIibkns1SU6w6ziQ8u4ak+a3UdaX4yixY5Lj+3Kg
         j9+wR8Nfip0IuApmMy/qGtgq++I+1J7mcNFuaWXt4EkKjHDGLAkx4qDBg66Jr/2gfd14
         brumtGxRftU+yIkuu/EIM4Y77TwSREDtucjTtMoTGQUnytgxa+5rXN26E93YaXueJf3D
         PgKg==
X-Gm-Message-State: AOJu0YwCbcMC8ldVhB5bAqV+DFy+Jouykq4nuI1sippCRmLB+j2HA2NL
	HWEhChkEsWP2VaNbbC2lc40sTckFpjP/Va4DXEBnEVo+ns5iFSgl
X-Google-Smtp-Source: AGHT+IED9JAxC6zoQhCjbLEHyYvynj8Snu5jQmSjsxwwQvECvD8vrtT+XFCNoPoYaJjdcFXVzV94Ag==
X-Received: by 2002:a17:903:120c:b0:1fd:a0b9:2be7 with SMTP id d9443c01a7336-1ff5722d9bamr198616075ad.13.1722879776576;
        Mon, 05 Aug 2024 10:42:56 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1ff59298f8asm71034115ad.266.2024.08.05.10.42.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Aug 2024 10:42:55 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <0ad9d0db-df2f-4e35-b53c-ed23cb2dc42d@roeck-us.net>
Date: Mon, 5 Aug 2024 10:42:53 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.10 000/809] 6.10.3-rc3 review
To: Thomas Gleixner <tglx@linutronix.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
 allen.lkml@gmail.com, broonie@kernel.org,
 "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
 Helge Deller <deller@gmx.de>, Parisc List <linux-parisc@vger.kernel.org>
References: <20240731095022.970699670@linuxfoundation.org>
 <718b8afe-222f-4b3a-96d3-93af0e4ceff1@roeck-us.net>
 <a8a81b3d-b005-4b6f-991b-c31cdb5513e5@roeck-us.net> <87ikwf5owu.ffs@tglx>
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
In-Reply-To: <87ikwf5owu.ffs@tglx>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 8/5/24 01:56, Thomas Gleixner wrote:
> On Sun, Aug 04 2024 at 20:28, Guenter Roeck wrote:
>> On 8/4/24 11:36, Guenter Roeck wrote:
>>>> Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>>>>       genirq: Set IRQF_COND_ONESHOT in request_irq()
>>>>
>>>
>>> With this patch in v6.10.3, all my parisc64 qemu tests get stuck with repeated error messages
>>>
>>> [    0.000000] =============================================================================
>>> [    0.000000] BUG kmem_cache_node (Not tainted): objects 21 > max 16
>>> [    0.000000] -----------------------------------------------------------------------------
> 
> Do you have a full boot log? It's unclear to me at which point of the boot
> process this happens. Is this before or after the secondary CPUs have
> been brought up?
> 
>>> This never stops until the emulation aborts.
> 
> Do you have a recipe how to reproduce?
> 
>>> Reverting this patch fixes the problem for me.
>>>
>>> I noticed a similar problem in the mainline kernel but it is either spurious there
>>> or the problem has been fixed.
>>>
>>
>> As a follow-up, the patch below (on top of v6.10.3) "fixes" the problem for me.
>> I guess that suggests some kind of race condition.
>>
>>
>> @@ -2156,6 +2157,8 @@ int request_threaded_irq(unsigned int irq, irq_handler_t handler,
>>           struct irq_desc *desc;
>>           int retval;
>>
>> +       udelay(1);
>> +
>>           if (irq == IRQ_NOTCONNECTED)
>>                   return -ENOTCONN;
> 
> That all makes absolutely no sense to me.
> 

Same here, really. I can reproduce the problem with v6.10.3, using my configuration,
but whatever debugging I add makes the problem disappear. I had seen the same problem
on mainline with v6.11-rc1-272-g17712b7ea075. Log is at
https://kerneltests.org/builders/qemu-parisc64-master/builds/168/steps/qemubuildcommand/logs/stdio
However, I can no longer reproduce it there. What makes it even more weird / odd
is that I can bisect the problem between v6.10.2 and v6.10.3 and it points to this
commit, but reproducing it outside that chain seems to be all but impossible.

Guenter

> IRQF_COND_ONESHOT has only an effect on shared interrupts, when the
> interrupt was already requested with IRQF_ONESHOT.
> 
> If this is really a race then the following must be true:
> 
> 1) no delay
> 
>     CPU0                                 CPU1
>     request_irq(IRQF_ONESHOT)
>                                          request_irq(IRQF_COND_ONESHOT)
> 
> 2) delay
> 
>     CPU0                                 CPU1
>                                          request_irq(IRQF_COND_ONESHOT)
>     request_irq(IRQF_ONESHOT)
> 
>     In this case the request on CPU 0 fails with -EBUSY ...
> 
> Confused
> 
>          tglx
> 
> 

