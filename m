Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1E261A3172
	for <patches@lists.linux.dev>; Tue,  3 Jun 2025 17:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748970745; cv=none; b=XrzAe3Z8o0BbrlxzDwhWGGzS7MTfjKcwcFLbF5OrpX93jGea9xscGtDXjE7z32Ldamdm8OOcki9qhleZxUQxoHOqE+ePXYQPJc7amI5/cJDK6gruV+Q5CqxcUo9PSxK+RM0cvC/VZX3AVwZgWwVdQ6g3s+NuSz8ErUq2CzOokI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748970745; c=relaxed/simple;
	bh=aBZTPoy+j2RvyY9xp9Dng4bIGIWmvFpCRUS3iPsWumc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aLc6n5uXoNJhRjvP8AGcAezvAC5XOMjUkULCfHI7LEB5fI/tVL0Z/7qBQwWbXQwQgQLDJSDqxO7UBM9nPxc2ZH9+JnEecnvFIT4Tez1sP0+d1hKqk4ObD/G1Sh5Bj8JMGzx+8NuYp3+wlgvtYKhyKjBT7TyjtcMxsGgR+vVQvp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VdLBrTCF; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VdLBrTCF"
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-86d0c5981b3so142277039f.3
        for <patches@lists.linux.dev>; Tue, 03 Jun 2025 10:12:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1748970743; x=1749575543; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1MwMXq01gJ1aVcg4TMQoAlvogQ3BB/CkVvLj7iIXR30=;
        b=VdLBrTCFZeOY8hTpA97u+aH7OoZTAo3Rru3fYL96yZjLclv+ybXbndUbYolGtyMqMY
         x0W78jb5Q4sZXdwCFMkNFg7noFiL9cyWb0bC8Uwq5YnJJXc++xfITeAtmfPPTCt63yT3
         fCdgApj6xsCm1BxiM7PorR3oysXlB5qYbp4Ig=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748970743; x=1749575543;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1MwMXq01gJ1aVcg4TMQoAlvogQ3BB/CkVvLj7iIXR30=;
        b=hjsybBetsC9ZIlcy47MvtVzikGFPQwfcixTmIWPy2NJwAL9sBOC2AvJXqrvIEbndAG
         pjr7KnRS9epSNNreDxn5nzeg1f2P6nsPE39S8wgGIxkLevXFggA8FSSd+qhTbCN1Nk8f
         hi0FF/Aqt9ENOME3zo9E7CEi+pBAcw30SUQ9RgYY0Pc5wYs/cBBv6Ah6hpaM0LbUnQpe
         un2AbBSIiNssU3W4GKRBCe6oBDfUbnj0NWrZKwoamU4APi74xCkxYEx8npa291XV7EmY
         gVoO5NnuwVWQwiWNGRon00qUC5GgvsUvLZIdra5sDSKhKzWcyiTvkwQEmr5uDzQZM6WX
         vmPw==
X-Gm-Message-State: AOJu0YzDntfnxRyZJlTW1jl4opxyX7eiam2nO9sw5JgE0X1Y420bs/QZ
	oVDmyiEbBDdHhpG9pwn3vN6muW6ydADWru8XaxzIo5Gqg5fDyNJtB7fC80BNf15XAEA=
X-Gm-Gg: ASbGncsd/7VPZJeH/iqMt58Lu24CX0uECQ4q0hcFQhtygpLrNZAGmSUGoRlYLhO3jM3
	jaHglxeI93C3bLpNCyUl9pQncY+C6KUIS60RbJ1yWo65F2VkBvOxhcElWXLzPFPEBV+gohJdoZs
	zZYzPYLFVC3aUm3Kxhp/URTMBLvYAwq5zZSVtclR375NWcg1XJCh6NuhW0+jpqsabmKBp0GTxI8
	PDliHHVX3fkf4OPF4ZNErtxKaipZzwqDYRBJLpU2d/CRnBIwXNZcEJ9byIjEjG4qazAwpL15UbS
	bnYYo+GoxylZFsfBoliVaN+buyEEUfHWnkZipxEMawJS5Wqt6TYuk69h034Y5g==
X-Google-Smtp-Source: AGHT+IFqdE/Rv34mnRjjnq3frW36aEbqp6DknO1kuzPgluh1D3x0RxohnU3W0kvIiYd58v8VDK1dDQ==
X-Received: by 2002:a05:6602:2c15:b0:86a:1fce:f1a6 with SMTP id ca18e2360f4ac-86d050945fdmr1683962039f.5.1748970742966;
        Tue, 03 Jun 2025 10:12:22 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fdd7dfe577sm2349735173.11.2025.06.03.10.12.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Jun 2025 10:12:22 -0700 (PDT)
Message-ID: <afd3f81a-237e-4076-9e35-f478bb1b9844@linuxfoundation.org>
Date: Tue, 3 Jun 2025 11:12:21 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/325] 6.1.141-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/2/25 07:44, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.141 release.
> There are 325 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 04 Jun 2025 13:42:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.141-rc1.gz
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
