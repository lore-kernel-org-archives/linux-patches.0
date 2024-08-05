Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E193139D15
	for <patches@lists.linux.dev>; Mon,  5 Aug 2024 15:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722870177; cv=none; b=sIHzzbJQgMghRWYBzzJ4FeMxjt1RBP1hmnrXJQKMKdGE4aDq+/uzfhhOGpLuZvXlKP1jOLqPl6wUYspzi4hQ9CdKRzYd3uuwOYLa9bo4VE3y0kB6+jtEWzN+44bCqQFhzNe+S6lhP6Uu+1uoPHs4Im13cnd+SpylsuQ+xP0ySLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722870177; c=relaxed/simple;
	bh=RBsnFk5DadJtMA1FJS0lHnyvEaqrRFpHI5h0r1n3R6s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=A8/5uqdJxOK5TVPDQblKdyIqh9Y+wKWvPQKxPv4x9HATrkAdak/aqkS9f2EAVCXGxmzJVRAwfBxzFneruk9jQwteAGGWMaIBrFvQ3EwUJUWhPlQMu6+xKptndSOg29cIZDVjw1enuYiy8rHKibWy/z5qRhtnc68JClE/5QMEtBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=URo6CJrP; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="URo6CJrP"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-70eec5f2401so7668192b3a.3
        for <patches@lists.linux.dev>; Mon, 05 Aug 2024 08:02:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722870175; x=1723474975; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=/UW2E4RcKiJERBgH4Mqjg5hlsYlWS/uYtAEnyYZE9eU=;
        b=URo6CJrP044so+4bqhwJFlXdq+vp7sbZEfypEJ2uq7pBYYhX/Y05YFv1nevqnWmXgn
         EfuxpwDxlCZ4QHRCxLc/tu3jj+CC7YuhIZhXXfdPHbZwodMAhquYnCuHKIJtXgn4A+lO
         W97dajxqIjJ9vjJV35FN4PZvlCeJ1STSUuuz6v3HERBAWUpTf9wqRk9D9wy0cjD76fql
         +8s+nc4flV4VMlQUCPJVyUs4UZuCyu//qAIzalZc91LRpSqMELR05P4fUh2CAkcJDaAR
         GWrrdq7rKL1bSF4D8p9QXyQVGREB2J3jBZcuL+XkYlRcXOqn3ODCbsFIHS/N1b+C6Jj7
         GOyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722870175; x=1723474975;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/UW2E4RcKiJERBgH4Mqjg5hlsYlWS/uYtAEnyYZE9eU=;
        b=GtL3DtHqPvaPW7e9U5F0wzjQEufSwKaCKyfVx6EiThDnNIHlRI1gbaOp9Y6BpHMSfe
         dbVX1xRbYcH5BoZRoFO39CV50rQLUhr59C/qNAVYbTOaAWws2M5flrtRjRse4V3O304S
         usnpo/vd2Cg5EAYxuVu+5mgB4mxUjKx5wWGZLp9G68uUiO8PLbYKW6QFzSM+HNksMBRy
         /5W5FQ/10kUeaezqu0DKdI5BP17zc26AMFAZFMeUgtB92uW0Kk3BRbbVVo96Zq3xcwEf
         2iTUFwO3Fb7mRZMoaWNdogZ08NoDgC+vx1Fb24prQCIj9SD83qRRUWQnjz77iPEllG0D
         w/HQ==
X-Gm-Message-State: AOJu0YxJGcAEmcD3E7RT7+x6TWZA4LNcGIwRX+k33fDpry/EUr3k7EE1
	rWcbAYKCWwHeNdvgTskaqNomqU4ssm96VJ/UN+IUv6xkpyrm8zum
X-Google-Smtp-Source: AGHT+IFPYXq5FsQ7KWy51Os2WgMdVPa87GeT5Uo5Wtkin4gKLKDpsvR94eZ56uiR2b+AupH6Ol4VCw==
X-Received: by 2002:a05:6a00:928a:b0:70d:3420:9309 with SMTP id d2e1a72fcca58-7106cfd9664mr17189497b3a.17.1722870174693;
        Mon, 05 Aug 2024 08:02:54 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7106ece493esm5508909b3a.110.2024.08.05.08.02.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Aug 2024 08:02:53 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <8326f852-87fa-435a-9ca7-712bce534472@roeck-us.net>
Date: Mon, 5 Aug 2024 08:02:51 -0700
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
 <87frrj5e0o.ffs@tglx>
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
In-Reply-To: <87frrj5e0o.ffs@tglx>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/5/24 05:51, Thomas Gleixner wrote:
> On Mon, Aug 05 2024 at 10:56, Thomas Gleixner wrote:
>> If this is really a race then the following must be true:
>>
>> 1) no delay
>>
>>     CPU0                                 CPU1
>>     request_irq(IRQF_ONESHOT)
>>                                          request_irq(IRQF_COND_ONESHOT)
>>
>> 2) delay
>>
>>     CPU0                                 CPU1
>>                                          request_irq(IRQF_COND_ONESHOT)
>>     request_irq(IRQF_ONESHOT)
>>
>>     In this case the request on CPU 0 fails with -EBUSY ...
>>
>> Confused
> 
> More confusing:
> 
> Adding a printk() in setup_irq() - using the config, rootfs and the run.sh
> script from:
> 
>    http://server.roeck-us.net/qemu/parisc64-6.1.5/
> 
> results in:
> 
> [    0.000000] genirq: 64 flags: 00215600
> [    0.000000] genirq: 65 flags: 00200400
> [    8.110946] genirq: 66 flags: 00200080
> 
> IRQF_ONESHOT is 0x2000 which is not set by any of the interrupt
> requests.
> 
> IRQF_COND_ONESHOT has only an effect when
> 
>      1) Interrupt is shared
>      2) First interrupt request has IRQF_ONESHOT set
> 
> Neither #1 nor #2 are true, but maybe your current config enables some moar
> devices than the one on your website.
> 

No, it is pretty much the same, except for a more recent C compiler, and it
requires qemu v9.0. See http://server.roeck-us.net/qemu/parisc64-6.10.3/.

Debugging shows pretty much the same for me, and any log message added
to request_irq() makes the problem go away (or be different), and if the problem
is seen it doesn't even get to the third interrupt request. I copied a more complete
log to bad.log.gz in above page.

Below is yet another "fix" of the problem, just as puzzling as the other "fix".

Guenter

---
diff --git a/arch/parisc/kernel/time.c b/arch/parisc/kernel/time.c
index 9714fbd7c42d..9707914c1a62 100644
--- a/arch/parisc/kernel/time.c
+++ b/arch/parisc/kernel/time.c
@@ -75,6 +75,8 @@ irqreturn_t __irq_entry timer_interrupt(int irq, void *dev_id)
         /* Initialize next_tick to the old expected tick time. */
         next_tick = cpuinfo->it_value;

+       pr_info_once("####### First timer interrupt\n");
+
         /* Calculate how many ticks have elapsed. */
         now = mfctl(16);
         do {

