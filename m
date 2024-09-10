Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C3AF188A3A
	for <patches@lists.linux.dev>; Tue, 10 Sep 2024 23:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726011029; cv=none; b=aYyx5GHK47oQMZQcz4pyv64Ip5y6Ro8dEaqSW9BkylKXibSN1ZFJAf2oQysYn35lwsMfgClHRnRq7gjQnrgqR6dswHmYFm41zMZDzgwx/UT7QsVYu71zWJ2mIWuIPsRicLpN2qoK1N2/0AlUKgZVaXyeI+uyCVnqWlD9EF4Hc6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726011029; c=relaxed/simple;
	bh=4TVxpoRFLyRhTv/wGa6Zm40S7JkSsaAPbOW9P3O2zqQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gvLc/WCFL/6ZR8j6/wtf76oV5/hyhhYtRctlw8F1spi+fnQUaozZKYmgPtmk3qFiQB9ErljbYx1eMXi3JVZERpe6LvzR3UN2p1vmXl2nXuUHEZC5SJ26xEbAltGZOhqUsOX9B8wsnvGqxLIaNRsu0copTaUPQDy+5S2BNG7A128=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f92SpnZq; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f92SpnZq"
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-82aa93774ceso236770139f.0
        for <patches@lists.linux.dev>; Tue, 10 Sep 2024 16:30:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1726011027; x=1726615827; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Iffj2BsuxCNv0UMNZmAM2WMYEZZUMVSrxQLbOKgNCQI=;
        b=f92SpnZqDwuFihgISLl6Aui53zxh9ytPne3ZufPA1WA9pNu+9F/fpDHmTfPBm9oFjx
         7I9OOt7Q+xmJBsDL4IimmEbhCGh2GkVzLE4d5MQ8KjT0f/zRAYTbUqzZgqT3W2t2RYRk
         vZPCiyvM/f22zSmBVSZzjtvlVYMP+B0VQYOL8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726011027; x=1726615827;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Iffj2BsuxCNv0UMNZmAM2WMYEZZUMVSrxQLbOKgNCQI=;
        b=LTq6lWm+0Boy8KskdMLyJ3l5OsllVIGytRqmyGZ1ArW5VUwZZ425CTANwEN7AjXfB9
         jsnkUc8YTXzKgY/iUBlNCEf4tNS0IswFpnouioq6/eGlkVBhjKIjceHJgyXFxqGwrxdX
         gxZ+D8GHweep5DZhGLAXxEw8KaLgyqu/SsTNWHR5iqWTs6C5XDp5c/3SPwuPdOKkSxO7
         dDxth2HXCCI2TTaQ6zSEa/dC7LjGt3cs/SRtLWQo6bd0ZwgRJ5VB5d3xZQEXR+OaW5sv
         FwYPwdWSLRAK9NfauSe4e9JOn91jeWb8ndhIRPoQ4xa679wgq8q0qA/Pj7t8CcBaF+oy
         9lTg==
X-Gm-Message-State: AOJu0YxIHIm0fe/5VEDzCxYYNHRaSKPg4gsU4vpVRPc1hRPLgykrT3b+
	lNBwAZJOwt7ryRdyJ1DnzH5/Gu0sKChcWsyMG24IW6MUu/rN818X40GiOvu6xb8=
X-Google-Smtp-Source: AGHT+IGbJ2XZTYauikJ4CJjr15uK3rTfbH5hnk3HNUgenOsWQ7PsaMxBzNJScp82iwzt4tQzDHQOWg==
X-Received: by 2002:a05:6e02:1a45:b0:39d:2507:6abd with SMTP id e9e14a558f8ab-3a052254035mr152504595ab.13.1726011027160;
        Tue, 10 Sep 2024 16:30:27 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4d09451dc5dsm1852226173.14.2024.09.10.16.30.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2024 16:30:26 -0700 (PDT)
Message-ID: <3a7c5032-732c-4f59-ad2c-64042daf1555@linuxfoundation.org>
Date: Tue, 10 Sep 2024 17:30:25 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/192] 6.1.110-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/10/24 03:30, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.110 release.
> There are 192 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 Sep 2024 09:25:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.110-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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
