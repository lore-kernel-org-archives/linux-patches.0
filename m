Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D21721E492D
	for <patches@lists.linux.dev>; Sat,  8 Aug 2026 00:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786149121; cv=none; b=QrB/d9b4G61SgAK3skS7x8KomH/xpbdPyQ+4jew16MP5hBX4f8Qkc32PR/EYBDicm4SvVFn5I0zeFkDNRvGzBjzyHna/WYlOwLU4D4yv+Huubkj59+OJDzSdHhazh9iJqItvQoXqxCieQZ03q2VNy5Vziq6QIf3dhSyfjKDe1uE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786149121; c=relaxed/simple;
	bh=GwicImTJVl57xDBC3k+8BZf7Zh5Jg5n/dXvN7dGVD/4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C1hS5CYDDMPZ7WUjf0St6CrLcBe4rbeY5N7mjaEcte0LDFF/jM8zaSxgqwPbVaKwrh+Lb2hwWfOME8fbQ3RJwVTSlY/jhEzOeKPOsGUnOLRXhLYnrLj3qNosDqv0pnmJFRTubnnsK1omdAKRG614P8mSgEhLhIC3baDUf1DdIlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FcwdKGrI; arc=none smtp.client-ip=209.85.210.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FcwdKGrI"
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-7e9ecd7216cso90406a34.3
        for <patches@lists.linux.dev>; Fri, 07 Aug 2026 17:31:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1786149118; x=1786753918; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=C9Q6wgg96tW/ysuHo9TVqBk9IK20Gh89rsTXRCAre9A=;
        b=FcwdKGrIGzNqItJgkMCjLLirR2OlDO4wyUi6gfz8i8tg/Y1h/tSFeSj3MjnGZQfk9A
         7hbnYhZN43ESvTpkx7tGaUlHGr+isEHEiA+jjxSQFcMlvZWUaUU02g+itsCHGD3w+lcY
         EEnElOS3+NcvQP9FwbP2/rRPecjWfGgJVxYrI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786149118; x=1786753918;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=C9Q6wgg96tW/ysuHo9TVqBk9IK20Gh89rsTXRCAre9A=;
        b=QV0VqQh+K4W7c3QGWKR3A2VJUY9Ed+ql3wa6jYgLmWSv9HRhSX7U1xnSAP+sEh78Yn
         JOFsxTMN90PyUI/QgvUzWkBekdPa/g/eWU31Cq7HKC/m5dA0Kn1CsgBFGE3lxCUWuYmC
         eayXu8liC30ZAqEM3lzt9MBrabDm4tn893toJT/iCo+PhgtLU3c7hieby0ZsfbUsSNfd
         450z2copQFd+CaaiQmAK/KNkluQeTkKOan4Pw+4vNqkJ9Fa1KUU+NSHUo+NYIHC57gfb
         77n6Cj4aE0JPLbpX9Ebw2vGW+uRnUV4xJQ88z4vcghxpMib1RxVBueKQU0UUdB+zgmeo
         bkQA==
X-Gm-Message-State: AOJu0YxXaf/Dr1rkZeFw09eWCFKU/ZH6dARUF1j/3utm3sX2uXFJh/P/
	0Ft09w6hnw8MNNV11qUwFv4pcuyZjHMI+RmWPD0XODLq92z809NvVRqMSl5LEEFJVJQ=
X-Gm-Gg: AR+sD12N3Y2HLUgMSVz9kxxf7TV5OXqQ+NUqboDCKFEaec1RmzBskN1UDQz5H5aK9Yi
	icnwWKmOKzg0alNHAfgF3cGz5tidHEjdSe5hP+7VbV56mDXRXgJ0YHSYWn/RxZc7aiRYXLrrgGe
	zZ2CDh6NqGDb9Et+xfKYnkA9vuAuUKyjUb8o2lVJtSEodS/NzpKD3PlF90XeXTb2yQMgikdKDN/
	qkq1IqtoED2TH1lJitmJkvYZtGi6HGKvHxGfqPdU2L42+Kgg3Ws9ZTnywO2KjT9f9oyPTh5CWRm
	7Uydu6Tv9sUCnLG7t91+W4eQjAbupG136j45ejeIZBHH7urNubYKC9GeYTjuJWOsU+NgZ07fcV1
	HbZNuOo5X95BVouz5z4cwgWnUm903pJ8gnV/MtGIrUFCImmoZFbxxdVHRu78/ln1jkZU+/0NAYf
	fPtFgqGOlGPVq9DVT41jcSeeOvWHc6oOPzR1xFzqjJSIJ1nAHypx317pmv5VR00gikxL+law==
X-Received: by 2002:a05:6830:4425:b0:7eb:c8ed:71d5 with SMTP id 46e09a7af769-7f369371f06mr2788345a34.14.1786149118694;
        Fri, 07 Aug 2026 17:31:58 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f35b7c4c3bsm2256783a34.24.2026.08.07.17.31.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Aug 2026 17:31:57 -0700 (PDT)
Message-ID: <d310ee05-41f5-46d4-afdd-c28265d65723@linuxfoundation.org>
Date: Fri, 7 Aug 2026 18:31:54 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/396] 6.18.44-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/7/26 08:32, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.44 release.
> There are 396 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 09 Aug 2026 14:33:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.44-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
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
