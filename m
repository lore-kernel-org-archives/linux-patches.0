Received: from mail-dy1-f177.google.com (mail-dy1-f177.google.com [74.125.82.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB47130B50F
	for <patches@lists.linux.dev>; Mon,  9 Feb 2026 22:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770677955; cv=none; b=dds80Ktp0UDgpNaiKRb+A85I2ZjakXfBjdA4+P4Vb5Tq+O0YUEHULToWDXDjaXX84kLHar8ZjQ+9mtEa6PYCAxH+7OqnIX7YcDS+fj0MuKpRM9bKAbhFivuIQoY3gLAnMh3kWn8sCyis04RBG6noDmIxNT8Bosfy3LJScilrUK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770677955; c=relaxed/simple;
	bh=j21Bg9Hu1UR/YbZ0GmOKFVH5gHIFsMLusYKnkEAJW8I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ckmcoR+szrDeROHmkPIeyRMStp/MqMPByr9xYPjSUs56o0dAneAHfvC3RhEbpUQEjHBTUhRdMWBCorbTWTK3ekwRG4ZE1AnvELnbiRUPJeAbYhs9vQ0DO7FiM+LFqehhXOlSefNg6FOdmh8g9W9oR5xNwkm8CfVm7RaqVluufKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Cce5R4FA; arc=none smtp.client-ip=74.125.82.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Cce5R4FA"
Received: by mail-dy1-f177.google.com with SMTP id 5a478bee46e88-2ba88e53b46so154927eec.1
        for <patches@lists.linux.dev>; Mon, 09 Feb 2026 14:59:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770677953; x=1771282753; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SwRl2jgVQ7pdHo4zbbwuiuP4OVpWvxht5MYoo80zj8E=;
        b=Cce5R4FAVvDSEgsqi6XZolfm2JYeAwBULbpfYmbJqiRQe1/nhkzq0bIZsOZ66QKj20
         2kWKuoiBKe3yjnl0VY1j7DHseZqRg3Sb/dFEOULS6GWTEsore+f4Mfi3p3ceZhDuy4DO
         cPKibXyY0tCbO1MYa6MojmUGymcJsa17E+WQfzJjsp0aaJastgrfF6LMlsxNhC7h57v8
         erXHqvj1VMwvdC+6aKntqhBsAL8Rjbhu/kiniF/UE28odfuwgWaeW7lO5CZi11qcOjmn
         0r8b9J+P0GkDzhtOYXJ98X3L582nH49/fVpSeefIyzK+R0qCbg+vWifdLkRPhUkZ0P9r
         UzKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770677953; x=1771282753;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SwRl2jgVQ7pdHo4zbbwuiuP4OVpWvxht5MYoo80zj8E=;
        b=gHDCeGzu9r5DxtOaXt7DyUHdivXR9R4jRa5n7z3fMsxoofL46K3d6G9x67SkU0LpIl
         nH7ddMLsKlsO68kAG1iCnuZWpDOWJcRUW22FFy5F905ip+IO6iiZRJTykWudbvadXxNn
         +GNDUSPHjUb1kFczSohxkJQa1lLiU6v+l43aBEF5zXaD+QPh5HB3jClullSlCZTl1LsU
         UbgDhIc1qd1Fpq/o2XKneYJI4bNtt99uvO1NfieO2v4WqFwzMmc+T/V+/sk7N5fYQcA4
         wEvggOOX9lwIMs9vHV1KdRHkUbRb5TrtVKYmNKBJa9lUpuM6+Ccfi0DxwiTFmLMCkRgw
         4d9Q==
X-Gm-Message-State: AOJu0YwRAbFDFSCx6lI2HOxfNH1/w0b1T35sDbQbKgngXGtsitRKdFLz
	lvU3tM8Mkk3fcF4pmGsQAJ2PQS6ZnREtP4jJGfuYfgwfEgTVcqMyivDS
X-Gm-Gg: AZuq6aIALj64rZzdT/dlgnF4jGQ23S8FdthhHQ111FBPMTONyryZkoENdUv0RJADLgc
	DVwmVwlQ/wnyy1xADKH6thkGwqqczO8HW7jP5/i/qcpzpXc2XF08Mo1M1hlsdvseknGUhJLXSzA
	iNuiwAHeP3OsH9WwTWfNKFH3TAIJrIICLk29T7lKS+dVIUAJlg3dBVLrVMZKlVJRYxxavJz99RE
	MpHbzxJB5VEGhZ0pYkgHgzDiyq2MyOgU9z9U5ycXLOS1q1rn0EFoX5AGUEoRpqWg5pw5NlLQrY5
	qGFZdHQIfjMzjNnN1+rPA6qKdlyvQQ0zJQdqI9S5NjULFvoabz7MK4L5L9PG3GeTgZrTJYrFUKA
	MX0n/g1/hA76MAiYZ71Hy19TsvAbnyIOxECLpfb0TVvFp7iu6APXdG0PdwGALMFWprZ4H5fcqgR
	vFRLu4r09dheFkm1Vfpt/iTZxesGwY4nd+MxjTWqF3YYxR2uJHgNNHYJ3POQnSSpU=
X-Received: by 2002:a05:7300:cd97:b0:2ba:86e5:f0be with SMTP id 5a478bee46e88-2ba8a0c8215mr125500eec.17.1770677952675;
        Mon, 09 Feb 2026 14:59:12 -0800 (PST)
Received: from [192.168.1.3] (ip68-4-215-93.oc.oc.cox.net. [68.4.215.93])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ba6ac0cd26sm3864791eec.18.2026.02.09.14.59.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Feb 2026 14:59:12 -0800 (PST)
Message-ID: <383e1853-68e5-4521-b344-0d41ee5e2b6b@gmail.com>
Date: Mon, 9 Feb 2026 14:59:07 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 00/86] 6.6.124-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260209142304.770150175@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260209142304.770150175@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/9/2026 6:23 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.124 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 11 Feb 2026 14:22:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.124-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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

