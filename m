Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 376EA32E74C
	for <patches@lists.linux.dev>; Mon, 27 Oct 2025 23:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761607831; cv=none; b=q3Ic/bUD/spStHWZgK/yBzmyRiI8yoBfY1PgwaFdxWySo3Pw17UxDJwrRiog7weIIPu0TDdYlXg037kmE9GThxqfUkqoIaP8/EMRFd0aVZOayu/sZrR2qW9xHAkF0G+l3ra1IpkpCICIHIIquv3vTIJmHZLrHcdFrLJj5awCxco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761607831; c=relaxed/simple;
	bh=Nnl4wmOlmjdjQpJ1AMKKTFq1A3BB/KMrnObJW1VIWVY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bfl7vV7S8Mhk6UTxkGDL0L3iRUKzmHgzlQI/7uLqwiIfbpCD5SRYBEfUOsb0kNXV5Lj2DmD3zM04Cm562bJJmzicIoHovvDj8YM/Utqt9P9iBDbpnORmUeAoN/GpsJnjG8QNJoRV9hkxNYvxJnzFwooZDO1+t1Ba+IFA7jixndY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sladewatkins.com; spf=pass smtp.mailfrom=sladewatkins.com; dkim=pass (2048-bit key) header.d=sladewatkins.com header.i=@sladewatkins.com header.b=f93TOV+c; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sladewatkins.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sladewatkins.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sladewatkins.com header.i=@sladewatkins.com header.b="f93TOV+c"
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-430d08d56caso22909815ab.2
        for <patches@lists.linux.dev>; Mon, 27 Oct 2025 16:30:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.com; s=google; t=1761607829; x=1762212629; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ldkibGRw4ckwZl2hrIKXdODRudH3hWdiwAG/LBXeHR0=;
        b=f93TOV+cPDtGWG/3nTg/R7aXilogTjBC6Ar839sLVh2kkQuQaJj2HrZi1VXwJ+G+k6
         vV5z7Zjk51s5vloUUX6VeVHoNvb1JJsSZzgk0Z3JzsD6WU/bml8kmbsmlCPQFWiScDLs
         GtnhNBZjSsVut7SCOFGFEk8/oBo2x6eol3IZrEn/owZjDZA5J2P5HU5JKMI8Oooqm6wE
         npRpdhJvJMORDyxZhOkJ4gG/YS0yAibfe6ICkXt6v40G/AVkCMJMFi3ZV00A1r0j9Ncc
         Nkuh5UU6HZ9WbTDQsqtZo5NdhTCaKakghXdL1IFv4aHxnLkfCN8Sle6BHuxPoC2VHqj0
         /UNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761607829; x=1762212629;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ldkibGRw4ckwZl2hrIKXdODRudH3hWdiwAG/LBXeHR0=;
        b=dLMB/o5ZjYyAOyDA9g7G41aZ3YPEBYCN0rrOEuo8E2Uddt6rvcqzoSKneTUBEVrxJU
         mWbpAM0FOfl8yV6WmN5r7U0PwQ0NuPGs+3p1/Irno+7Jk/2K9U6Je/+xJ9DQKtyLu2LO
         fA2mxUI3qAbs+OBvsQwmDc9cMMw3H6kkAjty0N4yP6RZ/fssOVXUqFqdXAHdK/hmzCSg
         L3nJDQrsih5k1wT4EogI73dVeqkZILxQMV5uoXqC2+sSoTkXvWTnNq+pCxD9YBnu37+9
         w1zL42blGE/m40/HM+xNt9EdrZQz1wwl7nGZ3gqoiymkxingfQbuF1MWlPbJMRVlfRdv
         89QA==
X-Forwarded-Encrypted: i=1; AJvYcCX1oblHVP3oGQznCRxOQlni4Vbxc+nClI61W6sn2pt2BFy8fEnPP8RJntgBHlsamiLqR4BRIHLg@lists.linux.dev
X-Gm-Message-State: AOJu0Yy3ZE9YNiOS61IwH21rrv7a4jSL08nWJ26PDZKsS21LatUSLYC5
	E73EHQbMicWkNLWl9Ik45qxuVPneCMzChsPLoi3NmwvALKN+tjG5s/ne3FHpe0fBQxDujROirSV
	PqGkeI52VNiMF
X-Gm-Gg: ASbGncvqA7GlN1M+dLkljay1WnIks36oxSoItqVhTXIivE8mwVeUPuxt6NgcG5KmhFf
	I5JT91sJ1Vyt2HCfUb84VoRMPlop8L7cvCVhb+epv8mxqcMv/m56a/bfx30yUdX+Bk7Bt69ArXh
	eIN7twO/LkdBHjeWlV9t+JoBXdlWd42PIM1JVVRTNhim+FkNpUXRvjV4GGxejdXGKA1XObVPDjV
	AuCJADTzcuCPOWKD9xX2r1ITGcIAEo7cvdkGYq7dgPs3M9NRBzBWsAvGW6Rm6XiDp8+d5NsZ+UL
	97/G/a7CDAmogUxFQJIkYJfKEF/wWvU+B3Zv4F6j60c267sDxz5kBgvb3BHHPaTigJc5ZrYstqK
	Tab10q0httlJfFSfKrKfHHisic+x+ed1rZMv/8bWzW1LSlN+3Vp+e7h3y6RgHgTR3mKWT0WTDnc
	3YFFVxgWGCUILTryvTfWTQdEERuw==
X-Google-Smtp-Source: AGHT+IGvzhXXqslGv9MZEWsvITO+9e9W7hE2kfZZMLHX7/6QstVZpa1/aFSE39Xoa1TpQ7YAxXkmsw==
X-Received: by 2002:a05:6e02:174f:b0:42e:72ee:4164 with SMTP id e9e14a558f8ab-4320f841931mr25299905ab.23.1761607829334;
        Mon, 27 Oct 2025 16:30:29 -0700 (PDT)
Received: from [192.168.5.72] ([174.97.1.113])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-431f6874a1fsm36049655ab.18.2025.10.27.16.30.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Oct 2025 16:30:28 -0700 (PDT)
Message-ID: <a4ae843e-d401-4e25-af83-ed16ce80c2d3@sladewatkins.com>
Date: Mon, 27 Oct 2025 19:30:26 -0400
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/157] 6.1.158-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org
References: <20251027183501.227243846@linuxfoundation.org>
Content-Language: en-US
From: Slade Watkins <sr@sladewatkins.com>
In-Reply-To: <20251027183501.227243846@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/27/2025 2:34 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.158 release.
> There are 157 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Oct 2025 18:34:15 +0000.
> Anything received after that time might be too late.

6.1.158-rc1 built and run on x86_64 test system with no errors or
regressions:
Tested-by: Slade Watkins <sr@sladewatkins.com>

Slade
