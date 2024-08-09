Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE82E155725
	for <patches@lists.linux.dev>; Fri,  9 Aug 2024 07:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723189933; cv=none; b=uaNKg4jWU3zwOqWUCB2y39zDyvEWfe5IQcnUVAyL8aE4N2+E/kZkfHGi+lzvTA7kwG/8oZPLDu48jdTfOd9G6BJc+JmDkqoAQWxC/u78yr8HK74rswGC16z4TGPqfr/pXIAX/5+VaHKEz55X6NPUwDt+aUwWX+hex6xSwRDG7Ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723189933; c=relaxed/simple;
	bh=WE7k6D28IPiuVNuNF0yk/oEv5frGPz8PpAqNeBAcOQg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=meeMx0j7vHAEYPGhxVT/qo6t3lawyVX2wkGi01RFCOXorHV4Qs6BuRI5gkpenmShoPhA19MWh09Pd4pRnjjizDUAWcPFGrg2Rk4bVzX4Uyj/RxpDbnnVG6eqNPCeI7P3gtx85YCVMmq5vQVtbzQHAU2WUvIZWsBP7L7GhX3PebA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=jsnHNZsW; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="jsnHNZsW"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5b8c2a6135eso2660365a12.0
        for <patches@lists.linux.dev>; Fri, 09 Aug 2024 00:52:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1723189930; x=1723794730; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qfWLL5imiDz9F+CxuIwiH+imn9QnZVkp2UmzuD56ox8=;
        b=jsnHNZsW2PijxvUcj/vzv7c441R7YmWYpE1ulOH4CmgA3UQsyheryPr/BdByNVjvEI
         QL0NuNyEQmnV2lI5SlrLR2S0Z2hJ8AEDPjfqOsU8DXeh31tbgW3u1obfZYrH/COwmKao
         v3aPf830AuHq3UNnxfFlglprJKrFkPJnXvb/eQTK37LToD5Qx/pNB0ZlqglSz5oVc8IT
         j8a+oL3wr0TUp4cOioknwR/iqFZbelkm22Xg4LUTvT5CJIZqmWQZu9tT5tDo6TiME37g
         2ArQNYFoflej8dHSyCaDEZKyC8nUZayI7K/wObH71XfDx82fLq8BokIIzE7ixUZCssYN
         57Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723189930; x=1723794730;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qfWLL5imiDz9F+CxuIwiH+imn9QnZVkp2UmzuD56ox8=;
        b=fA6aXYIFQqJVUtfuwhwUxoq+0pJr2NDS9oqdr7scb+OPdYUf+DSApANagViGpxpFa0
         W5anHXkF5XTmWGHPIno6IO2tUC2GYyXvakB6Ur6QtA4u2O/IApGCNJcPL6z6QmEtc6lj
         Ts0PVo+HVdSJijv+YYs4IyxeSVee1clsLKxm6gP1rFzD4WlX1GM/uDwTrVxjNB/yl+VF
         E718VN1BUd7EvtgmtsInQGxL64pH8Ux8xkDmnFRymuZvySK+UeWj63uUsfFV2Rt/X9Mg
         77S9b6cN869YW7WViNzlCJA/j3/kMCLQIC42gb6vER63xj8g0D49eCdhuyaRX5n3uRzY
         8oJw==
X-Gm-Message-State: AOJu0YwcpsKgRHeBrhNvfFA3lgIkQqp1Y9X8XQXB8p95kkf4bzmQuUJQ
	dLoeQm5TbqBhJbtqteuupGDZBss0qCTSDa4MPZYucbdEu8dANxk=
X-Google-Smtp-Source: AGHT+IHo9lOLj5SORUWn1SV2NnWTBLGCiC+vS/GL+OIQBNDL0KUifCX7RaGI+mujFCYv2Rs2wCJglg==
X-Received: by 2002:a05:6402:1d4f:b0:58c:b2b8:31b2 with SMTP id 4fb4d7f45d1cf-5bd0abdc414mr601773a12.17.1723189929644;
        Fri, 09 Aug 2024 00:52:09 -0700 (PDT)
Received: from [192.168.1.3] (p5b05740f.dip0.t-ipconnect.de. [91.5.116.15])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5bbb2c2019bsm1303945a12.31.2024.08.09.00.52.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Aug 2024 00:52:09 -0700 (PDT)
Message-ID: <3c61ccd8-38be-4da1-bef1-0738c3593a15@googlemail.com>
Date: Fri, 9 Aug 2024 09:52:07 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.10 000/123] 6.10.4-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240807150020.790615758@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 07.08.2024 um 16:58 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.10.4 release.
> There are 123 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg 
oddities or regressions found.

Tested-by: Peter Schneider <pschneider1968@googlemail.com>


Beste Grüße,
Peter Schneider

-- 
Climb the mountain not to plant your flag, but to embrace the challenge,
enjoy the air and behold the view. Climb it so you can see the world,
not so the world can see you.                    -- David McCullough Jr.

OpenPGP:  0xA3828BD796CCE11A8CADE8866E3A92C92C3FF244
Download: https://www.peters-netzplatz.de/download/pschneider1968_pub.asc
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@googlemail.com
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@gmail.com
