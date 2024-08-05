Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1F6F3FBB2
	for <patches@lists.linux.dev>; Mon,  5 Aug 2024 03:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722828535; cv=none; b=R+1Gw4taPXcWPOLf3XzKd70H9K3pSVs/TZkJBur7QaQQOn/tBuyizPbiqqZDYFT2dBg7y4z9Aw6/npFgIkrD2OoNNG3+0ydm4OVf9J0+wS0SRXVOQKu3DihmXgXFUf+iF2eQABIrvS/ZHoKEVPSZZqsigpxqvL0JQjuGYkCaBsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722828535; c=relaxed/simple;
	bh=kts81rH1k8RtXz6FCafCNk3tonScZQfSdlrhwhCMsZQ=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=VIJy6X6ZYhkgM673PCTiHxNnk812wngUQSAbqfT+G/GhAEkFaAy52bCcFA4rC7fHIr31XKcX7xZ9ETzrDqftMFEn6yOxOBDef+zW9Qn3b0K4mbremj7YQx4B+K3sqbSOxzzUlBoMgrALrJAE9aaD+wA8x6MpzmoRbK/IGCkDxb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mbalcOYM; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mbalcOYM"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-6b95b710e2cso12823006d6.2
        for <patches@lists.linux.dev>; Sun, 04 Aug 2024 20:28:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722828533; x=1723433333; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=ubgoVcGCg+qbw4dJAKrhDegiiKl08DrFXbdGG+4Wd2Q=;
        b=mbalcOYMvhQ1l+tZmwKTcB/dHLHTGEh9L3DEblB1mp4nw0r0dIxJQ831AolLV/5S/R
         Pw/e0Fxt2zIgDm4UVTCgGFT073q4aVim8+qOoPq5uEYMb1cXowcsP8hnIj8Eeam3mR+b
         iyWfAbQr+t6RpnIwYYIiA0Wds9BtqSLs+IhZC5r2SrMZAeOXfFpTl6V3UQmFNchE8h15
         dQxUa8NDfQuZVHhAxNkM6aug2HqTxku1Mfahilez3xzXL0kqPueTdcyBUJMXEO+TP1z9
         FB3v+vSbkeXrGQc9XKNGvHtKCnwHZYBc4G2QZQpPDQuLQQ2amHgj0p0Vm2OG2xucR2Me
         mXJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722828533; x=1723433333;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ubgoVcGCg+qbw4dJAKrhDegiiKl08DrFXbdGG+4Wd2Q=;
        b=gLsi7yuwQNguWuw//9TfxGKW6TM7Pzwc5C3d1JAlNxCzwFydf+c+Ks2yFK37AE7iHz
         qwrgZm2tsQ8o/UGz5mSKBmn7b1LCyFgiheyQOvMNxEeAWJPQzZPxqCXuh+jcE4cjVcaW
         XK5YGhAICFRrgjvIECQbmvmAbNRFx7M9a3aDv+EJLCGe86Z8bEv8HgwoKdRYrmecQRlf
         Kw1tMQ/rw6Ro1oRcr9ZbINxwliQMGlLkQqq+sxeu9++5G6YWzF23w9InZ8hHmyvsR6dh
         UBRBn+L7NeJDdFDnqvYnOvyi8uYOW2wARnlgZPom7ECLrW9dKVqELLjgx6I2zJftMLSx
         +QSA==
X-Gm-Message-State: AOJu0Yz1cbs9iO2g7zSYrFDKyGrJteXUddMJyJDcOw4xbbb2gCO0aPUW
	V/C5ZIUUHQUELdlY4hQJHjXgbBC56TtBKC9dVzni+y4Y9f0iOvPL
X-Google-Smtp-Source: AGHT+IH65vZ8s5Q2UC3ovyv39LXG4xjNR+pcI5Q9I5KU56YIdlaN4OVmeOgUNJPurldO3bZxh3coNA==
X-Received: by 2002:a05:6214:5c05:b0:6b5:dcda:badf with SMTP id 6a1803df08f44-6bb9843e9bcmr155389146d6.42.1722828532703;
        Sun, 04 Aug 2024 20:28:52 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6bb9c78ecc7sm31518456d6.35.2024.08.04.20.28.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 04 Aug 2024 20:28:51 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <a8a81b3d-b005-4b6f-991b-c31cdb5513e5@roeck-us.net>
Date: Sun, 4 Aug 2024 20:28:48 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.10 000/809] 6.10.3-rc3 review
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
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
Content-Language: en-US
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
In-Reply-To: <718b8afe-222f-4b3a-96d3-93af0e4ceff1@roeck-us.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 8/4/24 11:36, Guenter Roeck wrote:
> Hi,
> 
> On 7/31/24 03:03, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 6.10.3 release.
>> There are 809 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Fri, 02 Aug 2024 09:47:47 +0000.
>> Anything received after that time might be too late.
>>
> [ ... ]
> 
>> Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>>      genirq: Set IRQF_COND_ONESHOT in request_irq()
>>
> 
> With this patch in v6.10.3, all my parisc64 qemu tests get stuck with repeated error messages
> 
> [    0.000000] =============================================================================
> [    0.000000] BUG kmem_cache_node (Not tainted): objects 21 > max 16
> [    0.000000] -----------------------------------------------------------------------------
> 
> This never stops until the emulation aborts.
> 
> Reverting this patch fixes the problem for me.
> 
> I noticed a similar problem in the mainline kernel but it is either spurious there
> or the problem has been fixed.
> 

As a follow-up, the patch below (on top of v6.10.3) "fixes" the problem for me.
I guess that suggests some kind of race condition.

Added Helge and the parisc mailing list to Cc:. Sorry, I forgot that earlier.

Guenter

---
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index dd53298ef1a5..53a0f654ab56 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -8,6 +8,7 @@

  #define pr_fmt(fmt) "genirq: " fmt

+#include <linux/delay.h>
  #include <linux/irq.h>
  #include <linux/kthread.h>
  #include <linux/module.h>
@@ -2156,6 +2157,8 @@ int request_threaded_irq(unsigned int irq, irq_handler_t handler,
         struct irq_desc *desc;
         int retval;

+       udelay(1);
+
         if (irq == IRQ_NOTCONNECTED)
                 return -ENOTCONN;

