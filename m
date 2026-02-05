Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E09FB32A3D4
	for <patches@lists.linux.dev>; Thu,  5 Feb 2026 19:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770321521; cv=none; b=qotnM73hCI8p8dYUhbvPo2xWke5IJdh6WdNt7q1uBb5VoCq+cLTP9GDW1qwInPSMSzR1guw28x7CcaQIEj6pelVHLYyr4D5XeNv2mmYk4BSPZRPXvKhqm0yj3ABSRV5EVgFEtqfGR6akUZs0AJgrcBNuT7Y/rQRDBzSa+6ng8Wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770321521; c=relaxed/simple;
	bh=wjOJpS1Be0lrIXHOKRw7AA2oLGRcmSqsJg9FgPtL5Qg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I09KzVjaXXZkFiiOuxocF4s/a1UzLmUp4zYSViom+nc64Glm2hRntE2QsRVuBNCe7h5PY/9RvMS+U+P4y6wEWoytYmp+XwnWgnYah9ydUyzFO2ivX7n8NerkB9NT+n5+tniJ6+zwh3Qmq4m7WuHEia4k4lqhAY59rGzLCQY15OY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Rz+Ulx9H; arc=none smtp.client-ip=74.125.82.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Rz+Ulx9H"
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-2b71515d8adso1232339eec.1
        for <patches@lists.linux.dev>; Thu, 05 Feb 2026 11:58:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770321520; x=1770926320; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ij/zLdrWcWHh7R5tlgMoxwCAW7LC/FBBeDjIZZrZTEQ=;
        b=Rz+Ulx9H/3YJk90Q6IX3yustPeS9K141cTg7CID0bbJCxAvMHZJ+2xK5AvJPhAhFvj
         PqtGe1dOfIdTzquKiYYp0Ns0j69AUTlv6RtwlwZUkeSc8VEVYBPDZIPG4xaIquJjs1ES
         5IW/J3XnhY9JRB5wS3LrCWHQqohLOlJ0xgL++oO79jOUgrei67WegHmIZJHgDZ57Jiuu
         snE7SJUtUsXb7emp0A1DdVXZ6PaXLjW912Ndv/boX5y+Jte0aS6gYMNjU2YvPtK/b2Zj
         yPy70ruh6uFaH0rnPUzdYsH6Vf8u+N00WFJriomKmiN1XaujV6F24uXLciI9ItATjOYz
         7ZaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770321520; x=1770926320;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ij/zLdrWcWHh7R5tlgMoxwCAW7LC/FBBeDjIZZrZTEQ=;
        b=cvTdHC6MOHEgK0sV5AQdWnoYccv5jVZ86+mxHFwZBVgC+8F8ZP7rfJPAFa5pcBoT/1
         qXw0K9ToCQwbgdK17OBYkNKOvw1SPc8DOjDFpBQcHbzHtaopZ4+VPS3Vdst/Vy1a5NO/
         jFWQkgmeHLO/kUHWfqKpWVPq+Z2b1U1gBaF9KJ14GCYDGbp7vW5fOi/KqQNgaumV1kqD
         K/YwPVWTqT4o2JxUboZB3GkrDp2aZOBYEFNkPH2g9Tfwx9STEYnPoWgiZVsLUNr7s7UO
         Ic2XWcRadymAlXBlUVTwpyQM2Dxuwg2k8PrpA0IqjGZxDsZbjd7jcykM622hc+vyTXM1
         Oi1g==
X-Gm-Message-State: AOJu0YyyFmySKmz9IAayf2xS7l5on/RcF1bYAQqrJqoNM93IRkYB/gFn
	bK+q8d0s9BMasvRcy/MKyudVexwqUUrINhsirkq1/325yaS2UQViActM
X-Gm-Gg: AZuq6aKbNIJ+09qCLe63xLXarA7MdQuEvE7o0rKvkoIOdLxezKeQP/q0zkVg0caQx4n
	SgWCI4ZbZVV3KJm/gqL1K7KdCWez4q+oMHpLDtK6hQOoAKPYXAIZUR2AsrV6YYO7eL/4/olrJ+2
	d1Kn4kNwcj1N1B9Atfs4iY3oixsMHN41Sp9C3bhmTsRLk4iH6ot07Ob/JQXchbmSy69FdDkPfhs
	N9Xbn1rbJsoCsn9SNUvxkL1tIl+fAbdrmbCYS0RY1CsLCnlQqRBhYXGlu1/c4BV3oRWsenrYepT
	0bWBV8X80hKdhhHqawTRQzou8il5Q9jlufKE+IpbzSiYRXtH4WcP+IFj04cB3fg7Mdpm+P+nHhG
	BYkgfFVKiR0fA27sirRilGFDEJN04h8hEPjtbg9FIpXa7a0LVzDCWRJxlLwl9ORtB9cpMmZk8L3
	Ouz7mtaoQq70BiR2X6hRYo4lda/jwPWJ3+ujEdcw==
X-Received: by 2002:a05:7301:198e:b0:2ac:1e68:2342 with SMTP id 5a478bee46e88-2b856a4247emr95411eec.39.1770321519939;
        Thu, 05 Feb 2026 11:58:39 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b855af6452sm287924eec.9.2026.02.05.11.58.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Feb 2026 11:58:39 -0800 (PST)
Message-ID: <90ef9551-f188-4645-9cf5-efa49d6c3005@gmail.com>
Date: Thu, 5 Feb 2026 11:58:37 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 000/160] 5.10.249-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260205143430.733102763@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260205143430.733102763@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/5/26 06:44, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.249 release.
> There are 160 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 07 Feb 2026 14:34:03 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.249-rc2.gz
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
