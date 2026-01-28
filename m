Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23CEC374744
	for <patches@lists.linux.dev>; Wed, 28 Jan 2026 19:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769630333; cv=none; b=tt6frhbtJgLdWH0hzBD2I2sr57j/5SDpaHx311Bz3fIbRI3gmHMClMYZ0/VF5itjlZeN5nzzWgY8Xp2deNa5KVCfcYfT0e0pBDaApXN/RtohpucuZTWPjDOKikwwjyfx1oiVaKX3rpvEANCVzAgaU9X0rja45seS4xxx7Bovx48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769630333; c=relaxed/simple;
	bh=SkBfThcnAxPNUJ+YE5E7BDTixCjNonkAOYu7XIATugE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=W0ScnEjVcqi1gSo34gGi6WVH4H/I211bBqmXWjFRKJBpokcTK8x4VZdGGXfkmvgaY0uoDHhzo9WLqBnkYHE28FrNgiuEG9okwp3fjEQ9v8pg/fwj+rsyeDSBYJZWfdeiJT+ZWLfn01wpvBhTYDl0XAup6Qyy8R1JrSDX/U1+dI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DlGvLCla; arc=none smtp.client-ip=74.125.82.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DlGvLCla"
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-2b73112ab62so302504eec.1
        for <patches@lists.linux.dev>; Wed, 28 Jan 2026 11:58:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769630330; x=1770235130; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oR1WIC8OivmdFh8o5Yi+JuAasxytY/KAwOdHEBcQkkU=;
        b=DlGvLClaYc5dGVn9EEvsOX7n/+F+s5s4Fq0k63gp05ALAGRC6kg5cd68GQeLwzw3zq
         FCLMNw4yNVFU6orttzhYJQe7bwFFjeJb25CNKnqaWoyVG/m5L06J1j+AW9nDnkXQNK84
         SWN2aG/SE2OA8PQ4PDWeJcBCRqQ2IlJsXoa0yQKq5Q4VkyBRrUWIgrM7FsRKH4VC1IqE
         bmMvdcYjIG3OOejwVJdvXHmcHIEhjHtyD9z3rh7R/SaGYdVuTURPrsIbU6DNwdHiLbYM
         ZKdgS2PMEoYQHRWip6b3picNPUfe36s1vGK6ePF7CMqDanKIZCL/lWMN+jxuamO52q0u
         LULw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769630330; x=1770235130;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oR1WIC8OivmdFh8o5Yi+JuAasxytY/KAwOdHEBcQkkU=;
        b=tIMGb4zVQW31c7HFQAGdqnsow6427kjg6gb6n4xIz5uoSmojEzfCtZLbuKqcd/chHq
         6Mv483jex7hO+S88LOxYFL7nZE2vroV4gZUzU1WjuyaneNA1clYeC8vBoA3ZP1CfOMIa
         F7FEBQqmYVaqj7wbyQoXGg7yY0UNn96h2H5paXlOaQ/uTtvMoXlZSGSEWGdQpRXilycf
         lw8jItzHkya0jg6GviwdYj6o8smOhT/nvBoK00mqQ4UY3tvNp3Fqb693mAmxckuNGMEu
         JQKsfd9KaEhv9H47cfQRNse0c/ahxGRi1MAVuzcgie5P8boZiqDC9ot8CLqt94VuxSAn
         Xk5g==
X-Gm-Message-State: AOJu0Ywe/zu0Lme4B0NcwQ3/XZAZ0pxaCkQSiONRkSHTJY89qUtDwwLh
	pX0ArnH82gSYAY0Qs806rz9H7y9RlSLD9xj8+PmJnz9FF5z1ZG0I+wSy
X-Gm-Gg: AZuq6aJbAgUaXFsyqbW/BYnHw41oXAcnFIUajtJf2QEzZHRxEktT35MVZFgYRJhtwFs
	5IfCnNZNpw2DowGNeNnaerdnyWyiLUfe2fdKqhjhvu5kmZdrO9SAeFi/m2KXy6ayZzQAMq0xVQ5
	B/RlGDb8QUgF9BRSXBPDrBpVWK2zzMTmqq1Pq8YlLY5xxaJJtnMiNzmojKLsncrGfKkTKdVMjto
	bo0PLd6d3Wlq3IrJsuZcHWd4++2DQZWA6UZdPkUtg7jBYbMlFLu/l4jRGFdF9vp1KQIVkKV2QdL
	nxtXjd2VPb4QqKodZAmnJzK0Qr+A6osVFk+BDSP9GPq7SaLBRCQDSmpc6BofCxn5Cr5IYup10pJ
	+49cr0zYpYzremwTGL00lSJp9VPIPOEly1SjnB7d+jz0Nbwyg2HeKdXlWVR7ozcssYUuX9zeQjB
	8mRu1J0XOkqr6s+gOWRUBilPGUKUIIEys5uxL8Rg==
X-Received: by 2002:a05:7300:bc8e:b0:2ae:60fd:6f18 with SMTP id 5a478bee46e88-2b78d9f1bc8mr3966294eec.22.1769630330118;
        Wed, 28 Jan 2026 11:58:50 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b7a1af88dasm4456562eec.32.2026.01.28.11.58.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Jan 2026 11:58:49 -0800 (PST)
Message-ID: <276cc8fc-b909-44ff-9f94-1abdcc33631b@gmail.com>
Date: Wed, 28 Jan 2026 11:58:47 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/254] 6.6.122-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260128145344.698118637@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/28/26 07:19, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.122 release.
> There are 254 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 30 Jan 2026 14:53:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.122-rc1.gz
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
