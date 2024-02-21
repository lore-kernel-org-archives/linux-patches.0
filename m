Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85CC93B2B6
	for <patches@lists.linux.dev>; Wed, 21 Feb 2024 23:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708558880; cv=none; b=B0/5AIL7/8h6oOXbovzdx4XgVxz1iycL6V8DWONeAM6w6qyXlBYJFCYJ60VSyWcr+q2MCT7rvt62/H3L6K/AjSuLswtYwqrfwXHX0s2b/zOOXDtw0kfgfyu7h+HHvpJq/1+17EpS0+n2WRdCZzapor32GuJRbNQmp92reUmtQsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708558880; c=relaxed/simple;
	bh=peA9XfH82m0PDu+D+3ZCMjMzlRV6jT/mQwz03yS/uF8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oTict709vcdKN6xBShDeFOYMuL2GGJeZK3udb2PdF/rLIiIwrdBzmy+LVnkanjyRomq+G56xbJR5Kb5rz5gwjURLKEDGQhcMxrmyPr1FtDcmt0Ry1K91uuWwABOK78b+BRAzODuOIWFvm5PglKC2DXEodXfuWLENRTrTsJcCLmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jslJcxKM; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jslJcxKM"
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-517ab9a4a13so928879a12.1
        for <patches@lists.linux.dev>; Wed, 21 Feb 2024 15:41:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708558879; x=1709163679; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4wn3lnUr6QvHlVk0vYM9gSiyKQ1rcyaC3AxclYDdvOE=;
        b=jslJcxKM4wGjxTVyk/k4Oemtc3WLWH5jj4zFRkoVUKo0gUzb53Z+UkNEy+EusqvhcZ
         748Eg604se4USaoFQ4/ZWRnok3MWYxzbUuYY/Myvb3ArY/g/H7znjwHdd4D9lczW4KV6
         +EMUXAYFLo8lSthsU2XYtJns/oo6DDQ1D9+Ao8SadJdaoFhI0OBADZ5uBNJlO078NIJI
         XmhYenqwy+VYmuiCmSIOI/FD44vcAC6YAqFQeMzPrcNQD5ZaQAJ//vtjr5eJVLxvzDyF
         tDflSdwROz/RXjmi1gi+Ec9B/bENUJFXXfyt0p7wvidp5tQjSGhJ+VAYFm/z2AiZACPX
         hMkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708558879; x=1709163679;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4wn3lnUr6QvHlVk0vYM9gSiyKQ1rcyaC3AxclYDdvOE=;
        b=DMpzWboqlyWxy4OLtsn9ZWXtn7YjAu7Nqrqg3Q3Qe+JveZsGhgYPKB5Ow6QxJ+iJ8E
         lQM9GfUEyP9AkHhl3T03xfS88DcLvV4hH3Tf8Icq6z4gLSyqp5q/kUbJJbP+EwdAdKTb
         hMXoQHQp3wgmZcAtGjgoFpoj4P3xp6ph3D3y9xZaS+EQBW7PxxwjoGu8i9AIWtkgNigb
         KTrGCGh7vuYb6i6pYhJSVNU5g5D/mUjrCrdMuDEK/tBS+hzUitxrx/rC7q9tZR52h/qU
         osUP71mG34cbPMa9ri6UXkQeSADsDy6AqIRgo8QnSkgxV/LH/JSq/Fs0j3g07XLxCjZL
         N6Dg==
X-Gm-Message-State: AOJu0Yw2IREOQXnYk/CBNPijK5IJc+GIVo2QyuYVPHYaY2kVPjlKDSkd
	DudcUdKnvzbToK7wFXyy1VJ6L4g7j5F5t+Z1YGc3XiDDlHud9aP4
X-Google-Smtp-Source: AGHT+IE4OsDUYJmlhzfSnU3fjQT55rsecC0mb4NZ0MRKrPJG4olCy8r0HlPJgm4UfflptFVs5PlLTg==
X-Received: by 2002:a05:6a21:1706:b0:1a0:9391:b066 with SMTP id nv6-20020a056a21170600b001a09391b066mr15253871pzb.35.1708558878754;
        Wed, 21 Feb 2024 15:41:18 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id g5-20020a17090adac500b002989864e50dsm676669pjx.0.2024.02.21.15.41.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Feb 2024 15:41:18 -0800 (PST)
Message-ID: <8f70c289-8fc9-4925-a3b0-feb928259b6d@gmail.com>
Date: Wed, 21 Feb 2024 15:41:15 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 000/379] 5.10.210-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com
References: <20240221125954.917878865@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/21/24 05:02, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.210 release.
> There are 379 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 23 Feb 2024 12:59:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.210-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

