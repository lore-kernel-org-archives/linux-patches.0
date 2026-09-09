Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49D6548595C
	for <patches@lists.linux.dev>; Wed,  9 Sep 2026 22:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788992592; cv=none; b=VF8+//rh6vi9CwsyvwuLcfhdXbXDGNxUgtXZZPmKQo7+refjcyvT9SAOiRDEw7m2gB48X0NPhogIIH3jiy03DUEZxOFUvQUGkmcm18DrvkQbCcK7FU5JDeEPf+L/0o8e7EvcGhPyCL2WrV7y67jzXwtaalERZ344eH4mAZ2zJig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788992592; c=relaxed/simple;
	bh=EE93P9JaUK/IWvFQ7DBmgLnl1nyw464WW68C5E/9MDQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Lnuic0i6L4Pu7qez4lh2mfKb454uwcna2QIjcsu+0fgTlptCoALyuwMQSUVHibs0JIFx+IgltQbVcVjsV7sWkL4Zl7OQyuUCTXHsi0l2rKg5LPoGqATKUD0OjPjyRddePgHA5NjygYTyxqEfLp0vHbnclcntkl90jBvtTXkGdUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L1CDpL66; arc=none smtp.client-ip=209.85.210.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L1CDpL66"
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-7f4f824de5dso2797168a34.2
        for <patches@lists.linux.dev>; Wed, 09 Sep 2026 15:23:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1788992586; x=1789597386; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=P+UF9QqPpTGZ3kEfYDBVlbL9sc6DciTd1OvmLrZ0VC4=;
        b=L1CDpL66u6MgYwDjCMZ4Obk5RFtP0sNqGJ/TsV4mN0+hsLnyX0fmu6bYJE9ZCVmtyH
         Oa/RKjF5OVjsSyBqY9YJyhyKF55NthR+Tnb0W+XzSmHsZn6Db5iti0+0kxlDq8Y5WbmK
         r0JMVZUtsDqT4iPrtmq1f43i+hBFDZ7/OSac0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788992586; x=1789597386;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=P+UF9QqPpTGZ3kEfYDBVlbL9sc6DciTd1OvmLrZ0VC4=;
        b=eMxOQ0E/uApOSI6sfXm8XZXeRG3bMQZpvCXLfWU5PvsTdeI4r7ZTYK3VbscQziXc1k
         /3MiHNyfbDbaWXH56O6YrTTK07wem+k3EU+eNWiu0Pel6ZQgxf1IShdIFUbtx/N+FMPK
         YJMp5p+YdMc7VIvkQgCZxIq+ybf9P84BsYKvhdNLkuFKRbZtePrLoHFe7EDUc3SuPePW
         vT25xyEAbfCtHSIh8DlDw663yJhdIw838bLBt3k9iPyrHmC3QpZ8tJdTvB9ru+roug5u
         UzmTs14h8XeQ1G/30sTwQ+kqwc5uoNltooubehc6PODd6zpXW6A17NozRU+82yALxmLh
         ob1Q==
X-Gm-Message-State: AFuF++mkEwYsGj7wdpgewhnBsIyFa0PV58pUOfjZPqyjo+X+apSsp1j1
	HsXllVXcUW0FpmM52OrsHoTcIuwD070jpzdpLWqxAKr3+thk+Btv4oz8ltQzhP33pvs=
X-Gm-Gg: AYBFou1shGJjPAA4ktS39mbW5uGwS/XMhVm4MWyAVd7Cn7zH07i3kBq6lVysM2/EXoA
	Nvwjx8RE7lr9cm0YVqA2BYdg2k7rZet5LA0QbDNG1bFdUKFBYeBY8HK/JtDqEc8+nYYV78nDTR8
	EocUo5X16jNRzct5Zr0TrFefBWRQ0hb1Z7UKWVuepe2Rmd6MRZLnr1DYCvgj5GmzyCx1m8jw6qb
	HC+bYA0+ClTmv3ZlW2tJklvTpRAW6k9z9RhbFX6IsNWeljpr1O7vs2m7hU/7x61+ZMVIlVDXUmx
	UeUEJ0ujMJVYIizCNsCMV1rn5PwjUpbz3g7hGd8twMqGmQm+v29w1lBGPxK3a7jvGNRAt4XZ7yj
	XZ/U0NKMP68tSh/Dux/UrUcIK1Qtm9ugemYJuRlvBYNshzH8bhDcDb1JKN8R0D9FsUodp9r3b0L
	Agm7Dq6//ckfZ2vmw8OjjrlMULtvgyOw5fGQMT3fZMhgNC/eDd0wiQ/eYB1CC/a5D8iTIRr3kqT
	Q+PX6Fb
X-Received: by 2002:a05:6830:3989:b0:7e6:d54e:8fe3 with SMTP id 46e09a7af769-7fa1f92c50dmr23754536a34.9.1788992586339;
        Wed, 09 Sep 2026 15:23:06 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f9f6794e22sm17892719a34.7.2026.09.09.15.23.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Sep 2026 15:23:04 -0700 (PDT)
Message-ID: <a312900c-9de7-40b9-8687-82ecd18bd563@linuxfoundation.org>
Date: Wed, 9 Sep 2026 16:23:00 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 000/556] 7.2.5-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/9/26 07:34, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.2.5 release.
> There are 556 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Sep 2026 13:40:31 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.2.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.2.y
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
