Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C0AC37865
	for <patches@lists.linux.dev>; Mon, 18 Dec 2023 23:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NKlYkLnM"
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-7b714a7835cso46252639f.0
        for <patches@lists.linux.dev>; Mon, 18 Dec 2023 15:56:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1702943802; x=1703548602; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=l4hTBdhcHDhfzRm+cFBqMHZ+qbiNMQ567f4rRt8qp8A=;
        b=NKlYkLnMUoDJ2ootqosOb4szch/J9Uo8sT8Oacaaqovct/dJ+wAtv0A2QOt1WsdNRP
         EHePKdpW9iV7q3hL23fIFKR4Pd6E5sz6TTFweg5vcoHePWqUkUGT2I4i9rl9XDzbnU6W
         ufEThXEs0pthx1EBSswxE8puhU3bN5AqxzHHQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702943802; x=1703548602;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l4hTBdhcHDhfzRm+cFBqMHZ+qbiNMQ567f4rRt8qp8A=;
        b=mF+s4eFtgd2faaw6Kr6g3G2IfGL0sULlxkz0WyL80vOgZpoKZzmGpurX2nqjvqK3Zo
         qQKJUN0NQ2nBlSz2HENvf4ZuyEa1w7L+tds5dplQQNiW0LrGJK8InyIwxrnkndbRbkSC
         oKCynSodaUZNexO2zHnba6BkiUQ9mHR2oXLGc1pPaVDbEtHHu3xRvsJQWyM87wlXzINw
         dx59pQbjX3MDOxiVVsillYf08yElFFNBZ2v3PTb5AMGY12BIjIt/nV49r2cv55BFWV+k
         il3qvDq4jPVBJGwW2S19gRBHWRzecPTu6+cUMpPnycqzHf40do1TtmE65UFLXFQgOK6w
         gsfw==
X-Gm-Message-State: AOJu0YzMR/YRTjBR6sDVzBdrVZT5uBqycUTggF11aqk0CwjxVu3yk7cw
	z/asvCT2dE8na3bF/mNaoJHReDIenYONCSUxcG0=
X-Google-Smtp-Source: AGHT+IF/8fpCvEIGDrXmUx5N5MNaa0wK6SMmJplMmiMaT3yCHBMZrOlWz4Sysy91zP5hP4V6Xw61NA==
X-Received: by 2002:a6b:5a12:0:b0:7b6:fc49:a5f9 with SMTP id o18-20020a6b5a12000000b007b6fc49a5f9mr27717992iob.1.1702943802279;
        Mon, 18 Dec 2023 15:56:42 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id ck27-20020a0566383f1b00b00463fe3a0860sm1039606jab.142.2023.12.18.15.56.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Dec 2023 15:56:41 -0800 (PST)
Message-ID: <36c7b425-7e03-4722-a477-67de35895386@linuxfoundation.org>
Date: Mon, 18 Dec 2023 16:56:41 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/106] 6.1.69-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20231218135055.005497074@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20231218135055.005497074@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/18/23 06:50, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.69 release.
> There are 106 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 20 Dec 2023 13:50:31 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.69-rc1.gz
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
