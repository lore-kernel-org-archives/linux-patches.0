Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5904AB641
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 23:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L+3e3TsA"
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-79fab2caf70so18851239f.1
        for <patches@lists.linux.dev>; Mon, 09 Oct 2023 16:00:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1696892429; x=1697497229; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=T2BWZbZhytBka0EffrJfj1+89PYtChbCcDgjZSFmqKc=;
        b=L+3e3TsA4I72M9iy2pWWsT+/M6ywXdz8uehG0bNaI73+U3m/AFx1fmkcsFKtGR20Sc
         +QLmc67pS3iCmSE4Uw2SX5JsXguFc6YuI6E6ZVgEIBb1jbOl6SqGV8Z3AatuidBcyP0D
         VLKICLvC1UC4RjJWNdwIaSR4hCX6KVnXaBT1I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696892429; x=1697497229;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T2BWZbZhytBka0EffrJfj1+89PYtChbCcDgjZSFmqKc=;
        b=YMDVPtMo0QU/m0MCOrQnqHMV3nkQGKY9Lsx9xfBdfXrTbjjLqgWE6oOpjnDo62MWaL
         D7q+sbHejpVNomQpMvYwiLr4b8xmLgdE5AjnViYqk2VrdzehpeagFN1u891Rj9S2rK0n
         jSeaHpqf+Du3ppW9mZjKmF4MxNiuD8hvK1f5xjuQRdbD3u37U6S8Y+eEzSVW47F3fNJW
         REtIEyaPa8mwfHoKTy4nTViqovYZ4MfDzEV+lfaSLBcPVMdd4AhFzz7twtZvfJRmYo+4
         bc4eK/quqkLgmLkE46slJqw7d3Y1UtWA54g833l4amVt4Y8C9EZnIVw4CcIxQxiRdojz
         qgyg==
X-Gm-Message-State: AOJu0Yxxqo5FHRa+lxpSEoWzMMC6E4/9DpehNW71y3w4MWLwtp+0XItR
	+RFpfRHSHvvl0Cx7UPzqXpK89g==
X-Google-Smtp-Source: AGHT+IGXrpYolpV2262t6JGutia7xDeNmPzKKe5RBMLoyi0TT6PWVTZdPMb4J5AvS7LFikrBXw3jSw==
X-Received: by 2002:a05:6602:1a07:b0:79d:1c65:9bde with SMTP id bo7-20020a0566021a0700b0079d1c659bdemr17554425iob.1.1696892429339;
        Mon, 09 Oct 2023 16:00:29 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id s8-20020a02ad08000000b0042b3a328ee0sm2328655jan.166.2023.10.09.16.00.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Oct 2023 16:00:29 -0700 (PDT)
Message-ID: <f252a3d0-8e86-4c74-818b-4d9063607607@linuxfoundation.org>
Date: Mon, 9 Oct 2023 17:00:28 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 000/131] 5.4.258-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20231009130116.329529591@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20231009130116.329529591@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/9/23 07:00, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.258 release.
> There are 131 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 11 Oct 2023 13:00:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.258-rc1.gz
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
