Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 558EA3F0761
	for <patches@lists.linux.dev>; Tue, 14 Apr 2026 17:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776188587; cv=none; b=hUIrVlzseuKQOZ+LVeoTGxVehzzOZ0cQaj/sPBoubML7lbkrij6EuIxErAhgs/1EgpqbxrU6YTiXlkjxVnbUG96KH4SrDZxEph0gdeuucleQJp+8bBmW1ss1ht+wy0uKniVKdAHZH8uKcJ1QYJIQoaBPfxMCch8rwH4p1fnRv4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776188587; c=relaxed/simple;
	bh=q80Y8P4sULfv+4YLiooFnrEYwgToO4LQ4u9beuChQtQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YyxplhkO7SFh068AhiuJBmMwFZePPHoXDDo1aRRg0cgWTS72uJ7lEOClN7Tb9f1WnXwx3gZWsMT+/oT4OftpGvUj79ySHifrs34FwcDBMEZtnruTLQEQwtJdrXXj1CnwFM/VcSTrOoqy0E3QnUnrMy+Gz8v+SOPG1rky2h5HnzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZEc7yqbn; arc=none smtp.client-ip=209.85.160.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZEc7yqbn"
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-408778a8ec4so3574365fac.0
        for <patches@lists.linux.dev>; Tue, 14 Apr 2026 10:43:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1776188585; x=1776793385; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HJSheWUUr4b3jsPKJtA1yhlnsQpQ94Oy3AOCaPKGFxE=;
        b=ZEc7yqbnO5AgIxkJ4Ny8c3gMFUwNZbqJs2eqmgqRjzBVf/PUh6ruhTW2q1uRzqC1Jh
         NvZBRxhTO2BPwGZieM/exZtdk95QACj3logO/lQkd9wcj4sUZSubAOcSpSqCz2GD8CL5
         uMFgOHNn7pUmz4w/TOEqLNq+eohZ/WabRpOjY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776188585; x=1776793385;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HJSheWUUr4b3jsPKJtA1yhlnsQpQ94Oy3AOCaPKGFxE=;
        b=ZtK23ywZyvG/qRbeWB4CIlIh6QSwpZBK8WgYWBdeUb2KdwsVe1W1sWJAyErcanxS4A
         14pdnTweIebM/HgnjoYm73FOVNGZ7Zujv0l9hmea1ZfoZg5nwDu+5eX33phIKDXQIEH3
         J6dLq+5uyzTIxPyKxhFkWKMFDudx+PXWd4GsoXZUFLxmocdLdvdLjSehb8xW2Ac6uj0t
         c7716KCdO0wqN1uzjw6MJESdN6xfz2eBGEoPsyrv9YEhQvn82iJk28pDqb/uWLAQeOdA
         2PeTMzzoOuKgzxVd4B+NkYfgsthR/sFFbZfuliYK9fk7ee4vF+pLnQ5afeNubSntjvLO
         nqTw==
X-Gm-Message-State: AOJu0Yxbgb0v7ViN3PUHLZlskX2lcJBLBG3Se5eTuoHQG6kIdaTGFNjb
	pIccnI/5kPk2Gs+xqynQvroeZw4gjbn3GQb+PAq9/baWX7wWjPQQD73csk4sr9rr8WI=
X-Gm-Gg: AeBDiet57ubGv9V6PlhktQ/bCrE1dZrqrN3W+QG+fkzd+bIMoIg8lnnnCrVoEaO1Ysn
	KfTTT41SqvPMWYWnk5X1p9o1eocFdzRmtQsLlqRLeJGees4BWFGTum4zd5H53Tdbld3TyHX1oih
	hhQtrIXKvz1PJLgeAxDiiEq3uoRhIxxoAgOBXrIxkr8AItl5SrF46+H7Yz5a4dNVsDu/VN9VZAn
	hzwIBU/RVSEHarkdIM1yH41Mvs/jtASXuAKXMBulaBBzhwkjef2+PIJFK10geb+u0aZrK0FtLPX
	m+Vv5gJHZ0BztzjyWrglnY6CCoyIh/rs2m+XYaQpN0DIyPklYxSoMWQ+B7FRYM2kpEKiB1hp9rK
	RM5AdPzbaMjaqGKdIYwP9i6zrpb9Oetk7SQ5DdpVP+i4M1pHJKx7SpX0ijWbHOcS0N42qxd/0zG
	xRI9Yh+djFgWrdBMlSmTHn+4JLhBbs79c0hmgjBvOlQg==
X-Received: by 2002:a05:6870:b621:b0:423:e06:745e with SMTP id 586e51a60fabf-423e1128505mr9110158fac.34.1776188585315;
        Tue, 14 Apr 2026 10:43:05 -0700 (PDT)
Received: from [192.168.1.14] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-423dcf9726fsm12270998fac.0.2026.04.14.10.43.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Apr 2026 10:43:04 -0700 (PDT)
Message-ID: <b66bcd0a-2fbc-4a0f-9e30-96e819839bcc@linuxfoundation.org>
Date: Tue, 14 Apr 2026 11:43:03 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 00/70] 6.12.82-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260413155728.181580293@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260413155728.181580293@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/13/26 09:59, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.82 release.
> There are 70 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Apr 2026 15:57:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.82-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
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
