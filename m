Received: from mail-dy2-f12.google.com (mail-dy2-f12.google.com [74.125.229.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F7CA4F4049
	for <patches@lists.linux.dev>; Wed, 30 Sep 2026 18:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793990; cv=none; b=LVkLDtF8Z4OPsn5C1OGp0Y42iuMscXiigDk52AZQC9C0tvIsatJI5AAVq2O0YTaNP36RU5fxp5hNJfppNGnLbHw4ls/12NQQgWulDOIppbBUyGraQDNNvVs3hIYPBnm1Y8HXsaHiVqCxI/6FWt/AeRdDgw/ODb+e6P+4BBkDEnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793990; c=relaxed/simple;
	bh=/Dih9SrtItbcUH/2CE5n62UdEiJQyuq3ooSxlD3/Fp8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=O3NRgVZHfTwY2GwC4a++Uksiy0eqt1D4QsxV2u3q0vgQZ9RnQnUM/AXUz5KPrHcHgEE5ONcUawlP7nrCrFA28xC+V//lWNuGXo0vh8mPMmSjQ+0VTtil+mCDpFAmnUTkBIPArmz1dPqVmSBNb6ggR50UjW9QIucsuwu/tUVufF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=I4QW7f/W; arc=none smtp.client-ip=74.125.229.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I4QW7f/W"
Received: by mail-dy2-f12.google.com with SMTP id 5a478bee46e88-328664c2da6so4872632eec.1
        for <patches@lists.linux.dev>; Wed, 30 Sep 2026 11:46:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790793988; x=1791398788; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+rnVWzcL1s6imxSLl6Sw7NlkVC1rq2Qam6ENx2rJYs0=;
        b=I4QW7f/Wk9HlrH6QgIqzHLw0vuvyUzeu2JtkZ+JDfwIPTDes7xqF9LdAn0kudV/al6
         XuuOddACB2wWTCYex3bQp7D1oYlIIZdVD1gb3c3tdZWY72vdj8vxwFSl/7CHwEGugyVO
         6BO2IUZwlHHmUnOjvwCowSbUlP6Pq0i/ISAERlQBy4pZX2KBB+j/X2ONNSlUitdWCCuR
         zscxj0aa00ieLwcXLmUc9Eesu3WnhD0EJ8rxuiijAmmblKG/Y9kHkJe7X1aHR8CTUuDu
         fn05tBqrflRpW+3aAWq3ZT9laoKVmKaa0WIWeaBlVCcuwJR2LT7MhgTsZQTqykBFZLW8
         0Yzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790793988; x=1791398788;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+rnVWzcL1s6imxSLl6Sw7NlkVC1rq2Qam6ENx2rJYs0=;
        b=LwR5DlLLpARJFclEb4D9zI3XR4ZR+bnJXoCj0tB8NaoPDnDWEHNG1GYuwQhbO/s6WO
         ak7JPbDNcPSe1hzfUU5RrQYqKdnMPvRy8Mk7Uozo8zZt1NhlzFgDKNIWjmyC7+uhHn+G
         I5MTqX3jGHn9GxPWLAcP+mJkNPndndaOLrfgE1HwFesehBGN1e3wjnFEW5p8vURTabAl
         A/NQkinnc4uTq0o4QOaxoabA2Izn61pAV+OMAaI0a/nbexe23WRU/mPueMvM74x6ObqZ
         r2m7CEbg0StS/4guOS4MCaimwDOzdhYtA62bHn9+OAGRtK0fNyHjHY+bIaEvD33ojlB5
         rPjw==
X-Gm-Message-State: AFuF++kXdIqMWzj5ZbScKbGBXyhCxTA5T9j6Oba4CyxonulmCm0leFdZ
	Me/KNd7e0K1afa9y7zF5rdZ4PBte1hixQIKpb4+mzTDlHFdeqjlpNnAc
X-Gm-Gg: AYBFou26X3TcLdihrqJ66YtSF0I5kgJOGhq42Hh1YKzzzAGeSh1v6aXp/wArmV+nZkp
	5i3j14MF4j+dUqkDADo4ShtFOBI6FDLMvKys1XeA5Qn5xQnE8o17ZCY01yaIzvXADzvAnx7Gmll
	6V2JFzuNNW5fWRKXUF/gHX3AjjbEBW5myh/kAenYp1iED0k4XALmuvQbTzGojTN7u25qdUXwgnp
	qrVy8yRRam5AOmHeOhjRYJgHghK0IIeBHBF8AJ0UqI7dapQ6mtiVd2Z9s8WAX32arZy+xbogSNr
	JABfN77p+rPSxOIuuH1L/udQxfeR+LqY5tADewezXiCtQ5NFg0buSfbGdLNmrNwIga7iGA0MPvE
	h3XEbL298Ppy3TwJI2g9aAZYpswdXnZypKuVrnCj+eJgf35ANE/dLBmRY7qrp8PYJwrloMlDaHK
	1jx0RHb2n3xzab4GBD6QfSc3oKwSIoeNfEN+uwYIKo/C4SiyIKMhkgi/7Y73BZ5BVM1XAjqDuah
	ogvje+yFiqKKqTEdzMldIpHpAaen99+hejiS1E=
X-Received: by 2002:a05:693c:6385:20b0:33b:fc68:9790 with SMTP id 5a478bee46e88-34cdc3c1deemr2690727eec.21.1790793987430;
        Wed, 30 Sep 2026 11:46:27 -0700 (PDT)
Received: from [192.168.1.3] (ip68-4-215-93.oc.oc.cox.net. [68.4.215.93])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-34db491fae1sm814955eec.24.2026.09.30.11.46.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Sep 2026 11:46:26 -0700 (PDT)
Message-ID: <67c415f3-99d0-41aa-88b3-5e94a765d7ca@gmail.com>
Date: Wed, 30 Sep 2026 11:46:25 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/982] 6.1.189-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260930152416.775402466@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/30/2026 8:12 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.189 release.
> There are 982 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 02 Oct 2026 15:23:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.189-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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

