Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28CE925DD07
	for <patches@lists.linux.dev>; Mon, 18 Aug 2025 20:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755547983; cv=none; b=U3e7qB/4XRjwxxaQi2G15ooV8mDoldqMTnrX5tYuBiJG22fywBIA1V7Zyd1VhqJcObHzzETxNoMWO5uhFyA3EheEFz84JlYX3UghRbUzChQLGcW+OiptIDyDB0FQ7EYbb0YrnzO8HR2J5pKxQZMwko6oN5yFny4MnE/w6gc1GJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755547983; c=relaxed/simple;
	bh=VAjCSTlcEEGZlPyyXMdHvI7J32g8GhLs3Msg9ipZ2NE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ENaXlC6oEjZS75FObdF45XswVREkV18kiucnidLDlhox6qODTzVHMWgVEaHtjAJFeCPTxw6xpee33uJLvXvmUPbQD4pnih8kmtEJ3nZQrkxkpjKROrPV7Su/7qsflSoEKy7eoGGlu2+bbk1ahi+bpH16fb+ELe7o2r4TVZbSqPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ap9PqWpN; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ap9PqWpN"
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-88432e1b264so33427739f.2
        for <patches@lists.linux.dev>; Mon, 18 Aug 2025 13:13:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1755547981; x=1756152781; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TRl3ccManntYJKAwiaCT/1BaRhYkoYTuAWYVQSgG0/I=;
        b=ap9PqWpN+EotmATJib7TPdWCJT3VSQrM6opr3yccg+7aykMNWAn+zwTL2+YL7tldLl
         c2C1hweKE4g4a5UrJ845T03EOp6/D/PBvwtfqdd4f31nwfMuDmW0yPm85rSZoXMo/aFF
         9S2DprpnSpkV//3JL3xUTETjBmkQPo6F6FU2U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755547981; x=1756152781;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TRl3ccManntYJKAwiaCT/1BaRhYkoYTuAWYVQSgG0/I=;
        b=HsGTGk76ThpRuIa92sLjRJ8b6simO9wSC467SwtVQkLatQlk0KivI1OJC2aRL5ODRl
         xo4MRXNFyuojPPlH2Js7n4PhGnK+BBZgNGJk0Nk+7UUmy8wfkc4xZBRsaG1JhjnkbONO
         BG0+UgeV4vDp8GtZaUvliu3OXoLRMFvVFhnrjrr7DIS57xT3namQ2YBahhaiIlaSgLi4
         WEtrSm2qOUOgtk484cvKp8VEwaP2ALVnudOcGMup6av/ejAq4kbPmV404YrkjDGO3Q5I
         BriK5wGJNQ7FTXTbAapBXDm7GpHTadsFq/P5gFBz0PyayuaOA+qO2VFMyrycczapByad
         ob2Q==
X-Gm-Message-State: AOJu0Yy24rtTNAKBONqaLzEsAhuyV1OnUxDyc9Nr8iv1W2NYFslN9+va
	N1eYhpSzncV8ukryGrpbMaef/RFFy/XuA0tjb3swUxTRKWhFHC+tc9Aq0aFncds0Yzg=
X-Gm-Gg: ASbGncsmxsP4MGxvgHcq8KjFj726PjaFTnIXwQ11GONj1a8frQIAa4GN3auFQyFvnht
	J11SWm6BXyTrgCFF//GzlgRlaJiAj3pHUbmbm3XHs2hFanHRHo504h/n93OgXG+5iqVs2Qw7iSl
	UdGBvqEpJ37pJb8lT6ZXy1mrXK8Tpt1aw+5l4R08NfdR96zJsZ+Fv4fK4MvFjLzeoAPUaVHHo8V
	QwDbS4mobdRKgzmF2XgGiiWPiByHTTBjD4WE9ccJ4STJeC60jrTUQg5wlmyyyeuuP9xerhm06Co
	ulUsHPMff41iq0o25Tg39/QHKddhi5JQe06h9971kVMuK5LketkryOW3Fx1cflae8mY8Ms1oK+4
	1jaQtkW0jUHgaZdcpKWOvZBIF0RV/1E4vC4I=
X-Google-Smtp-Source: AGHT+IGjlhq7sguM+xWvT5IQPoezITIl1RzzNEuyUyPKDhMsTlph7rxOfo7GdwLsAfa+UZYwBXDIyQ==
X-Received: by 2002:a05:6602:2b8e:b0:86c:f3aa:8199 with SMTP id ca18e2360f4ac-88467024bf4mr102010639f.11.1755547981176;
        Mon, 18 Aug 2025 13:13:01 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-8843f8522b7sm336762039f.13.2025.08.18.13.13.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Aug 2025 13:13:00 -0700 (PDT)
Message-ID: <d9476fd1-2ad1-4dca-8f97-342c9f781d3a@linuxfoundation.org>
Date: Mon, 18 Aug 2025 14:12:59 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.15 000/515] 6.15.11-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/18/25 06:39, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.15.11 release.
> There are 515 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 20 Aug 2025 12:43:43 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.15.y
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
