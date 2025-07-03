Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EB531B87D9
	for <patches@lists.linux.dev>; Thu,  3 Jul 2025 17:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751564857; cv=none; b=rfUAq5eWZvmcDbX8Sy4tW+RqCkhZkHKgkETaXtDK7JtV35tri++9drbhc3u9DKSD6V1XFFLQKmLbXIydHkemrsTUBFqlIdPbtH0odsPaUA6w09wq17XQBxc4KXTJ75Xif6S/9eAcL5zLGJy1J5/0IuC3ubunDJYmqNrziYMxkAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751564857; c=relaxed/simple;
	bh=z/XqvfHH+o8HjoNd37Jvcw+MMU7RQAv24xWmlnpctdY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NJ1GIninRj8Y44EUR6rD6Ji3rC/EAH4jHU7IEH//hAeWwaD/FqH5TEJ33ix6LCF0YN2Lp6Zpm5ZnMTLLAX8WCNTnK9frGvEwHUWOYfBBpgyaZfrGGZ2KLe/ygY3euJhtn5OGDvqHYdstvTXDHLrXmdap9nYrFcKDnrvwQ6V0QiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cqVB7XWc; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cqVB7XWc"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-23c840a5fe7so1374875ad.2
        for <patches@lists.linux.dev>; Thu, 03 Jul 2025 10:47:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751564855; x=1752169655; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=conF8W0S8vt5NV1q5V+4xWgkkTW7kP77L1ugaCqJfE8=;
        b=cqVB7XWcrJvio4K1LR3U3IV5zD5iOrLzFSdZitUj6x64y8DZOZRabOlh6Mn03AW591
         HDzUgEmv/l0Z2PXuoU+/xZSU+Qfcf4DNLzXOQtsnRBxp4U0lRoewapDXYwS3Yn39Srde
         enJ613QFDAZY2AotKlIbF33uxky0srkZsZkZs96MMO/JXqQ3Kg+JrFWNew34fzgdDGbw
         ix6u+w/jrh8872HwOOY+zlQwdqX/trOaqS4nz6hQ9VSznzG7BTQN0nLJyW/+ky73YqzF
         INn6KJWhuHxLgeQMpTs2yOT2VsDo8bdyPdQx/+PIc3vdeeQGIw91H4E3zYgcLg6G0tQ2
         +CJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751564855; x=1752169655;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=conF8W0S8vt5NV1q5V+4xWgkkTW7kP77L1ugaCqJfE8=;
        b=HxsDrEWqEgJc8mY4yhiT6GZjwU78eJepDKZhMMZUzW1AEu/DVng7HIkk72GLAeqDA2
         OnqTMnGTRdU0b0raKDHQbj80axOCW/6k3EG2UBgbw1mfFkHjQZyXN8iahkYc+j16+cqx
         NjVRbbjRnRIW7u9pfPzrZw3E1zDsFeThSvYdp6c2T8zC0RA9jsKyFBgxN9RuIiEu6NmA
         F0Q9fQHMuJH745CrEAe69Qpw2qjDY9mjommL/fgw8yMXlpe9VtAZeoj0mAgA1yjpmJS9
         SVNdlL1psx1Hrxc8XogzJCIoHRAjW/+CQ/OQINetQ8WE32M4WvrO+s4G2AoJXoRHmlhG
         XMyA==
X-Gm-Message-State: AOJu0Ywkm+2+6V1EdVXV6Q6Ia1wxg2lUpj+6nwI4/NmLy4CspnAwzliF
	S9itcLgqGzXfYIiHMFUFbMzEyjOj3t7fXPuB33GdtVi2xdkR1r7yQVat
X-Gm-Gg: ASbGncsBNe9a+TN9FY9bzxqdw7HvdOnOzl963zjdzENWRjnd7GwDxuMEuACwrjKx1r9
	h3f5LaGZ4L9wV5tx8LO5mIMWIv48jLTCdcb40JBlYTcf6TQFuoLCKvXxabsG6DziccdPwqt6Bc3
	5Tvz3F92OCFNFPWoeR5rBlZXNhTpbTU2AUQw8wX7oWig6GeFIIIqFgQVj5+uaXWLuCCPiVy6e+c
	1AlZnFmQsZ+EH5a5lLWcr+OE1Tw5NLowTsxnXS8OZSMzp/fSyc2HA99Q1ZIqfAj4p4k1BcCuGsj
	CdvH2hi4av92cMEGH+nlaRLieQdkgR3Mia04bTan6L85i1Yf5ILaYagAQf6/HlnyB9iebDzu7kO
	FSHpqcYFWCvf9nQ==
X-Google-Smtp-Source: AGHT+IHOiMYHe86AtIZKT/Bf2Qkx52cYDf7+LG9U2zlC2Y3YltBfnE0ONWF+I6yPXSLPMfQJutsvyA==
X-Received: by 2002:a17:903:3510:b0:234:f4da:7eed with SMTP id d9443c01a7336-23c79819bcemr71828105ad.44.1751564855378;
        Thu, 03 Jul 2025 10:47:35 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23c8457b27fsm1000005ad.159.2025.07.03.10.47.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Jul 2025 10:47:34 -0700 (PDT)
Message-ID: <dab3ecdd-5375-49f0-b4e0-5b51dbb1fe3b@gmail.com>
Date: Thu, 3 Jul 2025 10:47:33 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/139] 6.6.96-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250703143941.182414597@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250703143941.182414597@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/3/25 07:41, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.96 release.
> There are 139 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 05 Jul 2025 14:39:10 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.96-rc1.gz
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
