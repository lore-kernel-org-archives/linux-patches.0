Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75BA81B597
	for <patches@lists.linux.dev>; Tue,  5 Mar 2024 18:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709665022; cv=none; b=oIr495J2FAs8YLDsxhsybkm9YZbo8xXcq1xo1iRrI4v3y5PWi/LEYPHTQd6nT9RBdKKFYSOirqX/0cdBbajCiDnJf0riul0DYO7usgpoGOg4okf2CTnptbzkITG+qMkNvuKukyThNQ/N4lPoAcCdtjv0W3y4rQQUW5Y+hIKZED8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709665022; c=relaxed/simple;
	bh=K99fQegOZJjtC/2VmKxfu745XKqO10+Riz596Tnvz+w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jOORe34aKmy44iVzjDVr/y6k9YpvZjFvd5i1VIrWOyKxImmuEpr922BI61ukg2BUP+hJsHrdYvCTZ+oRtkGY7SWXohn65Y4v8Bmu9q7zPxppxMO+uaMIF9U1X5NLHifZSaNASAFrr8H1mUkYZcOLkeJrz9Zc/sI3r4PCuQ1jAEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RX5QGw0e; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RX5QGw0e"
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-7bff8f21b74so69107239f.0
        for <patches@lists.linux.dev>; Tue, 05 Mar 2024 10:56:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1709665018; x=1710269818; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GRGkWo4Pf2rp0wd6ei0m6Ry/mBXk2gBBeI7bR03vhAs=;
        b=RX5QGw0eRJZGqdsBKYIl+Wx8mGTkcDNKvuAn7IP8PdoHjNx+5b+Kpw2wHfnrUVl4lc
         43C01Tvy/yaxAXyLQtc1klFgTzCZFeF+80oD4fX0nGGm9ze55RhwTZhG/sMXq2xpgCU5
         F9DhKgIkfXkKLXGdd3Jr07ob/MOoy3YkADblo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709665018; x=1710269818;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GRGkWo4Pf2rp0wd6ei0m6Ry/mBXk2gBBeI7bR03vhAs=;
        b=PKaxjkp0/5H+qKt5JSQxovvk15xje+GSpM59SHoPiVGiCHy2lY9+5B64hRXHlatLRa
         bvCLl/TXdZKjgCuWBlUFT3UD5O77G7uLKBDzUGlfFta/DsMltqOBZe0reY+Gt+RAThsc
         Gk6QRTFptaJX4GRek7XSSiwpsLJiGKDY+jJXHtU8YM8wkSWVfPfI9L2suc3C618hHmSs
         G5mrMkmRbTyuoNIJVPXoattzcqp+lJqlwnRJirrFeM91rSOA4ArZGUyl/ktIRHR6TjST
         5V5bKrky3KPG/rY7fzYQkE9Z4VqESOI5mlyxuW2Ar5l+HGt3FjzXVxh2rSvFtICBfIH+
         PvHA==
X-Gm-Message-State: AOJu0YzXg94bAXkzfAB2sG4gsqVW4DB2bRY2PfmXcl/SUvQeQmG19Drp
	KYqSQIo/HiA6JqX33eeRAHq1OkcOXbfs667oBoMyKCKhY7BYFslESCJJOPqZapc=
X-Google-Smtp-Source: AGHT+IGUc1QdxwJe+0fGU/iqLTA7slDiGlfZzyzYgjSq9z2JtuDXc3CsYNy9JFnsKnKspz9kY/3fLQ==
X-Received: by 2002:a05:6e02:1d87:b0:365:3fb7:f77 with SMTP id h7-20020a056e021d8700b003653fb70f77mr1252503ila.3.1709665018609;
        Tue, 05 Mar 2024 10:56:58 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id w8-20020a92d2c8000000b00365ab9e9799sm3256963ilg.79.2024.03.05.10.56.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Mar 2024 10:56:58 -0800 (PST)
Message-ID: <16fdb81f-7b19-49f4-9f73-447de3315562@linuxfoundation.org>
Date: Tue, 5 Mar 2024 11:56:57 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/143] 6.6.21-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240304211549.876981797@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240304211549.876981797@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/4/24 14:22, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.21 release.
> There are 143 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 06 Mar 2024 21:15:26 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.21-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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
