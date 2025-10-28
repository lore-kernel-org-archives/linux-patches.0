Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1948033C521
	for <patches@lists.linux.dev>; Tue, 28 Oct 2025 19:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761679671; cv=none; b=my8Nda0t+SAba5XxWp98RkdYc00lsSO1Mvu3rXKDcWEQ0O6swnupp0/0O1zfrO36x+2pEcJZJENx/y+GUBilDB4/TnBHe4G+Pth4m1wC1Q4Ox6HcdXQaotwhwrdOwkTA2pX8WgNL/tcpDOZJv5ev7ZNk2Nx/qsC6x418utAA/08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761679671; c=relaxed/simple;
	bh=e7za67gpaMzXAAnduU0aQ85fcHm086VfI4xydx3Us9c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T6KmfHjV/Sby4jdYKoKzcK3kx0F9z+GvCczbIBxtuM9MoGQWJ9a233kw2+GAVNTwIkf9b2hXGwSlUTF/DhgEzuU21Su+nx6/hiORwHYISkbb+ZrSvgxUSzXSPAI1g2BojMaz6LBzgRx1B9fAx3Jj2hkcSuXIrvb31FdgpS2Qn7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XUVumNsN; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XUVumNsN"
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-430bf3b7608so67532865ab.3
        for <patches@lists.linux.dev>; Tue, 28 Oct 2025 12:27:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1761679669; x=1762284469; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PV1bENIf0l3RXjjkTJnnKUbQWBjIIJGeXOMl9S4eqCQ=;
        b=XUVumNsNgBWpQfXQeq35qHnzZCaBFmgqjQC+dm6AN+KhAMXe4+815PUdzQT4JzN59E
         hbI8nh9NGNIxEFjKCLSn1eyRwlef69zQBmfY9sRcLaAeEcTQ7TsGPNKhDmh1/eGtiYmR
         YK5OjZ4sbPQRgFJUfT2KeWwF7TtKTFVkgl4N4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761679669; x=1762284469;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PV1bENIf0l3RXjjkTJnnKUbQWBjIIJGeXOMl9S4eqCQ=;
        b=jDk1v5kqJZtD1PQCLxlYDM+m0sf6HGLsAq2T278u79uBx+l77Ixx4TbwRTaeVDmFHu
         kA7mXQbPN6HeqawzysYs/q2qFtBckIwbt4YuG2ctGDEh5mk5UlQXnnjCO2iCizTgC9n2
         qeE9ecaYeoTnt1ondWm71/H2OUYd1AU8/xCMpk636ydejfryAm8HBHbp1Z/MUZ1hXob/
         YOLIE8S2nkhTK8CoQM+KSK3CrRd3FYegNsvqG4o1aQwi6CBpt76F7YXs25Leikwu/ia1
         6o7F8y0vVycUd1UExzPhcNaG3E0TkTre9anW21qGBdyNgjZiSk6kXvUuGo8bQ4BzvOEo
         ZMww==
X-Gm-Message-State: AOJu0YyL13A9fB5TbD/9/t07IqoVhxAiBwBCLGkrhua/tG+dDxgUg3SZ
	uIazaThOZigk7baLaaxPQ9mKe9/BDREvTZ1NB2RngnXXxJFUUdsoxtwZZowWf+s5wQ4=
X-Gm-Gg: ASbGncut6GotZVaCgGyCrqlpIhCWa6+11Ri3A+ThwxMN4cpPtId+ZxAUrLTRAxC+AQD
	NnosSSg4AeHjkVq7CAJKu/B+TlqvtMF/+0VS137E1s0cS97tqnvjmYXRSRYwJSZ+fUMbtmDjA3W
	IqVh5WbH0L72DckTUfMNEnHpBprSMsILbnEIvKlDLys8gJXh3rubVebuhiMOS7HcbeKgVvFQdzl
	6y1szUw1ON99iIjRV8G1a/6VjBNaSaSjIC7DDfCxfIyk+idzhj5p+lA1SY6sQy80eEvnVsZbRJ2
	odrHBM0I3fBKxbS66CMCexQyZn2UEsq+FQDgyueJIc0WCgJAgKa7sbxVCHtkbjhfSVzUwfsE+EU
	EOSnFLsSNWKK56DtOmYBRzgoExw9jmNnwtkjzJpXVMIw8VRTqSeMp2hhVxWwT6xWbv76PG3SO0E
	bHTUAMJXoKwruM
X-Google-Smtp-Source: AGHT+IGCnaJwEiI5H45X8uH7EHHZvYqawVyeXkrh+JuUvou4c5LieEIEgsLjfsVja/uVxA+aAgX1bA==
X-Received: by 2002:a92:cd8c:0:b0:430:ab98:7b27 with SMTP id e9e14a558f8ab-432f9064bd6mr5104435ab.20.1761679669136;
        Tue, 28 Oct 2025 12:27:49 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5aea73dc10bsm4734334173.7.2025.10.28.12.27.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Oct 2025 12:27:48 -0700 (PDT)
Message-ID: <cafe791c-5f00-43f2-85eb-f083c499f978@linuxfoundation.org>
Date: Tue, 28 Oct 2025 13:27:47 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 000/224] 5.4.301-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/27/25 12:32, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.301 release.
> There are 224 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Oct 2025 18:34:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.301-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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
