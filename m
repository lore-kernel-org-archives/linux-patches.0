Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C8AF317145
	for <patches@lists.linux.dev>; Thu,  2 Jul 2026 20:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783023489; cv=none; b=deQZ92b+4xoxGllYF430eK6fQ/1HKchU3w9I2Vj1SAxSWu07L7cw0hP5m5iki5mvUx1uQZbnGXaL9o4c8cjcjQ38McugKZvQJeSdr9AwDuYIuwqBVE90On4p8F1Lj0pRYvTi9GGwKa9AztIYJ5UjOIwfhZktAsI7DYWtN5IflA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783023489; c=relaxed/simple;
	bh=SkElOmdjimEVDG9if3msE0Md43LetI4ECNME1NI6CSw=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=AJieQ7UcKVgL5ofR49+/SZLZweINGqC2mlZ/Qu7Wh7n2Ymlwg6IN4iRlz0xsK3i7MbfEvHZrALlUzsek2K6Pa2rAbeAv364EUPiolGVWF5IsPkqvi+7p1XAjr6z6gSEefftPHmEEhfNQGbIX2a9QQ5rhP2b/VBSzje6qhZ0w8DM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fQxOciqk; arc=none smtp.client-ip=209.85.160.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fQxOciqk"
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-44aeefa1c00so700586fac.0
        for <patches@lists.linux.dev>; Thu, 02 Jul 2026 13:18:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783023487; x=1783628287; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:mime-version:user-agent:date
         :message-id:from:references:cc:to:subject:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dF7n7bcUMpvGgguhuXDMND355JS/AC8zTZapBPi/s0E=;
        b=fQxOciqk7NIj6BKB9eqEOLo34tMUd6Ed1o4L6i3qCJYJizJlLVmuhgXmVVi6sq5crL
         j+vL8/vT8h1j3fOwl56DRWEd6qeMsP3Ar2m18J1P0Sek1eQj1+Bb8UadjHVDMIummX20
         rZGkA3o5ImBgKYLhqGrN6HuC6k/lTcnxNZmAFj0OKnESGi7hzcNNrZEVvXzi0xlXNAbj
         BRzL+g0VYmDdrgElCoweW06MJvHC8kds+MrJWTcLQSWd4oHIT4yzj156G17DC00OmPh5
         HBT9sHuLVFJ89xHRkWuOsT+EZTdRg1t+0YvJMI/RnCvdGOppZgytJQmf+r2G1kgOOM7q
         Uo6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783023487; x=1783628287;
        h=content-transfer-encoding:in-reply-to:mime-version:user-agent:date
         :message-id:from:references:cc:to:subject:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dF7n7bcUMpvGgguhuXDMND355JS/AC8zTZapBPi/s0E=;
        b=mmEYMYdrZGS10kLz8GXwMPyUzsn8LLyWlUccQAI70o1Ekb3RX8kftKPVmWr2Kn/LXP
         XooScjzudH539cJlR4ztG7qTH+ke6kzrkqUFtgYku5ALKg1ba4WrwqXTOK9i8vVyPJDO
         T77+5RT/O9v0ukTtwYgfXUGyDI+6GVhqP6SWw24yfS3cBs1vt/1mg8CJLdYEhLJ745LS
         Hq4aV0HW8BN0Ii5J0G3Zmol//t1wPwIZeAeN+1HT1/TPIqvm/5jGoGfvezOjYBx0izgi
         o5xl+PSqyJZ1zOpX84dB21QJD8zzpwjJrUnzk8o0/xm0BmQDN13RwGLG+ZF5nwMdap8y
         LrQQ==
X-Gm-Message-State: AOJu0YzQ3Y7eNAsxlJ4yYy5Atm2X4N/RLYvMI2WiipfJ+3AYVwkZ7ZrT
	X7YoTNrrJW5Ku5bqn++KWbzM12Jgdt5TK4ju+qIgcStpPyP1K1/mZCw=
X-Gm-Gg: AfdE7cmo4OgmOIXy6lp1fQ3Ns3/9CMKx74BleLwcHRbzzZK5L47pm/K8PKDli3YV+ph
	JmjEGkyjAH+k/bco7pxW6qHX5C4LCTE3JSkqK+9qQCI+5UuDRGNwxFK12Tlug78+m6fPss7ej4l
	uLp/U2w3+XtMayjgScnX90P5IaX8Ud4dvVD0+aRh1M6bvJMh8rhmC1avPaIS3XIXM/LiGGHGQAZ
	gzKorttdlvRKdB4D5cmfBrLqS8beM+1MUKfL39v4QXssSQ1XZ5W6WdTgQeATVXeDxbBMS7WrbUG
	bf2MM+JQJXLrXMnsjt+YczLPMoJ8kDFYMRDnPnIaDX9TM5qrtOBS4WmrhCHM/xxB1a7zr5WRw4L
	Pue69Bu1/Yxic9pqN0VTM7jI4tqqPwXEwPVUX00sPhyBMvr3yjFnT1KPa1/syYseOrs3jE2u10U
	If4T9EYnhPcesZF9UEwz67AM7v3TxfuLg7QSi5M/W3
X-Received: by 2002:a05:6870:5348:10b0:42f:f3b2:e2c9 with SMTP id 586e51a60fabf-44ce9b12300mr627785fac.0.1783023487335;
        Thu, 02 Jul 2026 13:18:07 -0700 (PDT)
Received: from [120.7.1.23] (135-23-94-154.cpe.pppoe.ca. [135.23.94.154])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-44cbe84f609sm4052650fac.1.2026.07.02.13.18.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Jul 2026 13:18:06 -0700 (PDT)
Subject: Re: [PATCH 5.10 00/96] 5.10.260-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260702155108.949633242@linuxfoundation.org>
From: Woody Suwalski <terraluna977@gmail.com>
Message-ID: <cd648774-2a64-e5c2-a120-e4253d72cd1e@gmail.com>
Date: Thu, 2 Jul 2026 16:18:19 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:128.0) Gecko/20100101
 Firefox/128.0 SeaMonkey/2.53.23
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260702155108.949633242@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.260 release.
> There are 96 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 04 Jul 2026 15:50:58 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.260-rc1.gz
>
Problem with the kernel.org web site? I am getting

https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/


  404 Not Found

Same for v6.x and v7.x..
https://www.kernel.org/pub/linux/kernel/ seems OK???

Woody


