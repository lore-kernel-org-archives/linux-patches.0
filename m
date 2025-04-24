Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED62D17578
	for <patches@lists.linux.dev>; Thu, 24 Apr 2025 13:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745499718; cv=none; b=KI26BlGiqbNtjJQ7NjmjhMNIijJKgl+hLxfHqKc03j3n+DDLtqkPsWckvpGfp0riZFSd1tIoVVLP2+0qyOvsiSz+HJc8UeZpw/WYbCEoaRdgguS9PjwORnc9fnAvExszYc/UNWRD1z6l31kp8aQk9zTFpcHZIG4DSQzgvZx26oM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745499718; c=relaxed/simple;
	bh=1F2XUYXNrQPB6q9KRQqg72j5fUKRvi6UdnMTwwBvVzs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NFMxyLBVrbcjEjTSC8bI/1WScocuhuL5X2FgiBmXB1WzYr55+qvbX2kzWwX/U5Mj3OFDEGdWDwVDO+IMEUYgWmRXfV4aJpucbRUZTP3J7lSgT0KCM64XuMKzCugeINPfWN+NXhgIsZmagAn2fKaU9mHuZtrm+b6ioCEZXNwqtFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T7a32Xbk; arc=none smtp.client-ip=209.85.210.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T7a32Xbk"
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-72c3b863b8eso817524a34.2
        for <patches@lists.linux.dev>; Thu, 24 Apr 2025 06:01:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745499716; x=1746104516; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=IXaY0dXhkP+YGC1PjwJEeiUwI092bd5gxHppU4kUvWk=;
        b=T7a32XbkfdNrz4pti1aPCkbVPuPoJGcYymoWVMjy4l9p7Y0C/PtvvHfesusDri4ZFJ
         vMtgo9FcVK4oyOObc4RI5nLKqDHAoRFws0NbW5G1wzt+IE2zVz/iczAdQhxEZwE0D+0l
         mvORj3OYEYSoE0JRjGUP74rqnXHpHwzdJbnJa5LItkVpzD6ORBMMHBZZCCftl01zoZRu
         5/t+qLp/InyXD37RmrDIkGg3kwO+G2Ukm1MSTos5XTFwoPvJL1v7KjjddOK6wtvXq87N
         7NTWcYxo6JxrGEJyUDaJC1bvYXF9orQWnsiacfmHKfXcFUnLal8svI5k8TVj4rcsnsdj
         7EBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745499716; x=1746104516;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IXaY0dXhkP+YGC1PjwJEeiUwI092bd5gxHppU4kUvWk=;
        b=ISDqDRrdyMzEdGmESczi4o/tYBas9jImDr1DRy4mClRl1jURAQI+H2oUlkemCHaYZQ
         LVyYbhkGI9oHa4usfoCeH9MQv1qWW87t45KCxJS4NhRDu0PvCwQxP6WWSIQbYxlRUhsK
         zAqWGkZNIACQFa+VP/RJFc5PuHrfbP0NFkg95+cdVAkEA6dynLZCxguYMCybzRPVpw8B
         fNPUnD+OH/9lEGG9iDoSLHNLk7pehJMmaGrCMTeX5oHWAuMfW1zTg+yK+8mKnVKVcfKK
         xcllqOhg+e41lPQr5ry1iI6D6EnX2vXdkuDgNEKu3MfGeJzv9ZEhBMHCDs8mKF5P/BMk
         FU3Q==
X-Gm-Message-State: AOJu0Yx6aDYDxS+Pxd8f7fUfGWUIS0UbmMrGIQQfLOd1FjiKtn5YjHSP
	wJuo6MkAVTFuQrJGitta5t1+jwN1TTM+Lj6Z8d6+pMJaqBYaxlPb
X-Gm-Gg: ASbGncvZUp35R1sFEK7iMZGqEXB5If36UsMCvQ6Zi//RbUxKY2FWNXkFHliuNaM//NV
	uacQDgnTjEIfvBAdCYUaXrrrVrf9wTKLkb5tkKtO4LErSNOtH6u9wLTctRHhoicXKPInSJEFrs1
	28bqUuN8XiBmhtDI+xkbWAKI2hWh/hiZQE779ktPDnMUu/6oYt7cRM77ZFLVxKrjC4ELF+UBd+a
	Snge6yyV0aJGhd9zm9CwNbSqtTFdleUYGw1Y4vHtYpXanPy+fpLf5sTDquLNhrQUXaLFPBYqZNz
	syQ0Ukg8KvS/+YgbqN7B4jWPD+Dm8mKJd0jqzKO5I/WN4bihwejV
X-Google-Smtp-Source: AGHT+IFsO2jlMyW9MQpU2D5+LIkus/y6+yDCGP6+lPB6USYbWWKD/czpTi1UjozahQH8xn+1rnbviw==
X-Received: by 2002:a05:6830:620b:b0:72c:3289:827d with SMTP id 46e09a7af769-7304db526b4mr1557962a34.18.1745499715418;
        Thu, 24 Apr 2025 06:01:55 -0700 (PDT)
Received: from [10.54.6.12] ([89.207.171.92])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7304f3986besm219178a34.60.2025.04.24.06.01.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Apr 2025 06:01:54 -0700 (PDT)
Message-ID: <7146c07f-ada8-4c07-a52c-f5c7922f2e6f@gmail.com>
Date: Thu, 24 Apr 2025 15:01:49 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/393] 6.6.88-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250423142643.246005366@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 4/23/2025 4:38 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.88 release.
> There are 393 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 25 Apr 2025 14:25:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.88-rc1.gz
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

