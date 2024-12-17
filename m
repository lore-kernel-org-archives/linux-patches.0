Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 332F51F869B
	for <patches@lists.linux.dev>; Tue, 17 Dec 2024 23:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734476805; cv=none; b=H7JFCpugAkEVCLv9LNmCBUZTO2FTSP5QtlPowwICbnaLDFP/Rd98RDbSj9+wxOIn9vc5ZzUtrHd+JyV1HZhWawcwryflO5LKAESkHMXmyq81QFu3KcE5pXnx4hpY+LLP4Q7boWPeZKy1pnmDqs9J80exo3C8xvDMtwmCBRF7Zy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734476805; c=relaxed/simple;
	bh=cR99iEt2Ag614J04071UramutW5hM1LKb9eLRFtmkOk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R5fs8ZAL198XAEKQEPwGR28nNjBGfEDWjyMmYSfVWq0+8IMD4NKqswd3BCAHffbsNbZKlukqxtAUUeKO1fvMcgtUphXw3XGdXRCM6U9KvbcSBhXSjZ0ll2T6cPht5+C26Mwi//+f4WpBx7aEVS9qTSiBIIZ01RZwMolM7D7JJfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JWGVN+NO; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JWGVN+NO"
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-844d5444b3dso8731839f.1
        for <patches@lists.linux.dev>; Tue, 17 Dec 2024 15:06:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1734476802; x=1735081602; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NXfHXyPVex2Nr1hfyjAUCuTtuBcvIXAg/0lIIloW4A4=;
        b=JWGVN+NO909yyYJGHKA/yPHtEoIxmo0B0BAx1Tg9K5dx49+HfbYK0r/NaD8gvOek6K
         WTgdCYoskvt9lxSYkg+jl9HvYCN1GbW+nZ64GfrD7247B0mtfgzATN8hcjgR0iB0KkUw
         HayNlT0SPtgY7plgzmHtAy+VnmthdPbn2sDmA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734476802; x=1735081602;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NXfHXyPVex2Nr1hfyjAUCuTtuBcvIXAg/0lIIloW4A4=;
        b=kyILl6ey8oZT0o0UiTv70G2yBmwU9pbEqbrwwOCxqEOf1/3uj71zs46iRswyWc7aOT
         lrISThLvgRLIlk1WVgd5jSDc1r3AirXNveUibX9EZgF25i/VCPyw3fKWG3aAY4Hk848h
         eoK4ONHP/clSPdh3kxoUBfAtjdF7haI1L6dmUgVDEKG48z84UI/nTy6C5uIqGaE64+I1
         Z3Vrg+MkYjRXzJ+sCJ0DmQjPSSPlOFk81nYXHxK9Dr81Kdh4Q9g3JHU8atLa6ZBKKBov
         GX14sWB8NauXYcbudTeOtVcaoAW35HBNJ9FSQAaKaHRO5os3YPkPIKRpquRKbhnNsM46
         dkaA==
X-Gm-Message-State: AOJu0Yxx6laFh9Mp0naknHWwMk2cf3oR5xD5qnbZWtiEy9tAnGOBNBMu
	DGsJfdZUxh5yfvSQiyqF1so/WIej3Xxo7pmhRCWzr8xRr1weh0riuvcthkZCWOs=
X-Gm-Gg: ASbGnctRPA3Qm8kON7GzlTh6XF6JzOuVi3F8dB7blFHigGb4nwYHw+LJG0Zk/vxb1IK
	PIc/QJrqYHfGcFfMVUXKW5ndmwPiKQ6LoAX+sCn2H6S9aAlr0IpPIL6bm+myGLqDzFcZD9b2gSD
	b5ledDYUnaU58AK59hweEZ2kMS0brD9lB8EhPsgoleOXZLvHOKsUjN9sJcIXT+d2E022UXY2n/y
	pVcU9uKCm5XrwnVTalGD7N/tAVuz0uZ6f+yBWpUmPZOTDb63hNYGzs2KEZntcDgi3Ag
X-Google-Smtp-Source: AGHT+IFyxmU7yFCGp/RCq0l8NrfmfKgDtm6oDQd4bDB4w1nxhIj0cu9yqlIx/+d/pL4cpNwTFaiSzw==
X-Received: by 2002:a5d:93cc:0:b0:82c:ec0f:a081 with SMTP id ca18e2360f4ac-84747e081c2mr438079339f.4.1734476802401;
        Tue, 17 Dec 2024 15:06:42 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-844f6239971sm188469139f.10.2024.12.17.15.06.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Dec 2024 15:06:41 -0800 (PST)
Message-ID: <644fc4d1-9438-4f0a-92ba-d1e4f60e6b84@linuxfoundation.org>
Date: Tue, 17 Dec 2024 16:06:40 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/51] 5.15.175-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20241217170520.301972474@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20241217170520.301972474@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/17/24 10:06, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.175 release.
> There are 51 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Dec 2024 17:05:03 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.175-rc1.gz
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
