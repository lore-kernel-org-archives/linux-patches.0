Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BE7A1D435F
	for <patches@lists.linux.dev>; Wed, 26 Aug 2026 00:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787703951; cv=none; b=GyFS0oiP/mehVrQp4dBBcjG5a+pyfDnEO2Znlqvxx5vcnhvlQyoq/AxYIjdLe+0KUYF7HL//iphOdOdiyje/gTKGMoBMEoD7nAZZgEjb9X7L5qLDNTufK/E+5MnS3AWljBb+k1uAuHXV+az+77kUlM+4B6vwCe5t9f1zFfS1fN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787703951; c=relaxed/simple;
	bh=6EPTE+PvrSWJYJ19AnsEhk14cTbrAiZFrjKOTIB5f7A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EFo0cWCaP5kAx3yVBLBNJ/HTxTJS0GYhJxvYV1tG5XZg76jTb/v21Mhe9yJR60onQd84Ulv32DuRhXkOsWXEfFsAqPcvvw7NXnrwF1rMolOvlPekChxGy+bao62yi5zGDN2Uu8XAj/2eQbDfqlzbUAdbrle5OUO6kqoCMiobfFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fv6SOE7l; arc=none smtp.client-ip=209.85.167.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fv6SOE7l"
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-4a451915d8aso423347b6e.2
        for <patches@lists.linux.dev>; Tue, 25 Aug 2026 17:25:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1787703948; x=1788308748; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XXT+YTQDfQ9AsMeTnldVKDSpywj3RSfjjaW3cp6Ogs4=;
        b=Fv6SOE7lGbgxsEtxbbVWHRw8WXbikidWLu4q0/5u7O4AElZNqwElvqn3jf789GbqaC
         aJys4wEwrzHq7eRGiS8jk9uz5UmXAwW3p9Rh590oGkKmaljhz8xZGmtw7stel6Uwp5iW
         RfLKyTQdnxL30QPTsUorijsOVEMN3GbUqbNBA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787703948; x=1788308748;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XXT+YTQDfQ9AsMeTnldVKDSpywj3RSfjjaW3cp6Ogs4=;
        b=bXvKdp2G6k8AkIm7/Q2dVC2BjTmI+swm7OtmAlh4cktpnIrue/gS3DzdbGX/WDiHJ/
         q76fJgHDx/T93VyJLSM0nA2TJDW7aGuNQbJVWh8WW0EF64jmAWBR7CVr/ZmNxfgO2Zr7
         A869CZVaswV/s7kkDrhrl9ewaGglEWcLiYH8nkXoXKvo0q1MWRHo70XWzD1DLWoa4ONw
         9rUd7+PsNO0XcSbOiS0EAciOdWZ/SX1FRyScCxmq8ky+H8hC113HnHPMyR+TR9hsYU6A
         SC55URX0Ft1eBJDchQiFMFfqTEqNRp0iR2lT0nods5dung0POSpPJiiK8N4wRnnZPSLp
         tYOQ==
X-Gm-Message-State: AFuF++mr+c2nJX4g4g49C8L6AFjtgqL3JF63XCt8rTQiuIZrsMy/ek/i
	W1bhUG86yI0rEHqQQehMiRtaadx/Bx+DqZnvvIiInNJ1xvRG5RP8to+bRESJEqzJBTGQac5ckDQ
	ZESKFudA=
X-Gm-Gg: AR+sD12Dr/UQ3pjQbR+d/lYLF9d1rxSM5CUq3h+NMDr4S1fcH4L58uJ2Hg7G3fNGZ9S
	XXcclixinoI135yIEuPp3SxIkRplwkwnI9z6cjxq3aLetLb1AKK8uO68j3wwr4sfe5/hP9jhtCv
	ArDDyJA0dmhY/2WsiB4d7fqGbw/+fQLxbJo78YsP8qyEl+R1rrL0F73gMxGeoIZdbjg2X9bxlI3
	b991HEGz9t6p2ikF9Q11wA3vgzf3CoNr5cOhHwLW6cI/5CVHrHcE1A4lQlvFcBBpSrtzKHpQJ12
	K4/XAf2xIu6J84acKtZcKkLXSKLr8eziPliOtHQ+rGsDE9pGXKsMt6Q94Er4RCDDjKG9XA5OOVA
	IHRidNXTOBB4NwkzZ5FygZ4jERwTrOoxUGwyvdvkdHYnR6Z0faow/svNiFHv876PNB/Gx3ng0Pk
	yf4lG3IW1+a9Q6dhkelEtfdtEW5ETRy4M3HwShqqWq97op+dQTOlk+cv/bLfP23N8WcpBoGg==
X-Received: by 2002:a05:6808:4fce:b0:4aa:cad:cb4d with SMTP id 5614622812f47-4b366c78a5cmr3592683b6e.19.1787703948248;
        Tue, 25 Aug 2026 17:25:48 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4b36a7506ddsm371339b6e.4.2026.08.25.17.25.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Aug 2026 17:25:47 -0700 (PDT)
Message-ID: <8a8b25fa-b7e9-4ca0-84ce-67233490fdb3@linuxfoundation.org>
Date: Tue, 25 Aug 2026 18:25:44 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/76] 5.15.218-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260825132541.568214149@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260825132541.568214149@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/25/26 07:25, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.218 release.
> There are 76 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Aug 2026 13:25:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.218-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
