Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77FBC1C3D
	for <patches@lists.linux.dev>; Tue, 19 Dec 2023 00:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O2POTcS9"
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-7b70c2422a8so43824739f.0
        for <patches@lists.linux.dev>; Mon, 18 Dec 2023 16:03:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1702944223; x=1703549023; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=M3nxwhiECCoWLgEtzUzPDkiqRnO0Qsuov5ea33tjs5E=;
        b=O2POTcS9r7iycVokwd3gGfPw0GvDJmCLzMwPujWpheMVI9viWO95hqwu0JOnmx5O7W
         n8Pt71KaOzIDzbv1KJP1oFD7SFIeo5mMWEO+/HxZNHeXsvBYPbRm0dtRA5kjeAZl+bU8
         ZCU/frWeOU99Ho7IbDE3hgAgDQ2+uiNcroCrU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702944223; x=1703549023;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M3nxwhiECCoWLgEtzUzPDkiqRnO0Qsuov5ea33tjs5E=;
        b=ULeDy+eL5Qny/gnUcyC8Ld+jd/zcyQ2GzP3wf5KA70rFA5QWtTumHyv7rUwBJumm3s
         isKwLE8f8RLhqYl8b33JT1k8NOVBsZhvMooA9fHSEkZ21RwCLtxRUY/hPf6/bE4yVndQ
         mHKWRCNwWN4HSrYNGfz9yPOM81YUUxWYTbWk1ZcZQ5TAHCIAe6BLtFxJ/raJ8gj4CCbs
         KFwalAyySdXmGtCQkPnL+at2B/9Y78czW+plV2A2L0HEArA+NRcjMNjrXre9n7EMyS5V
         omFMgwdNeAnIefdza3n7cJEcvwH7pkZANeEMKttOUc7uC9SHQ8rDBsJp532ChLFf9UK4
         jvtQ==
X-Gm-Message-State: AOJu0YykY8j4cfXeA97Wjz5BX5JYrSX+hQnW4VvcCoNsnibqvmKzUBdF
	Wo4U4LsyuOJbExAZFoijW0E8Hw==
X-Google-Smtp-Source: AGHT+IFF7dtbONQfvQN/BeK24S0HT6I7PY6oVRGpq+yc0rUFEEh5AEK39tn43qgOOUaUAacaXLzkUA==
X-Received: by 2002:a6b:c996:0:b0:7b7:dc6b:ee33 with SMTP id z144-20020a6bc996000000b007b7dc6bee33mr2882373iof.0.1702944223605;
        Mon, 18 Dec 2023 16:03:43 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id f24-20020a5d8618000000b007b7ad8d8c64sm1927157iol.48.2023.12.18.16.03.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Dec 2023 16:03:43 -0800 (PST)
Message-ID: <f9d0ca9a-7f64-4f5d-b829-9e6e96016a55@linuxfoundation.org>
Date: Mon, 18 Dec 2023 17:03:42 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 00/40] 5.4.265-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20231218135042.748715259@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20231218135042.748715259@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/18/23 06:51, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.265 release.
> There are 40 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 20 Dec 2023 13:50:31 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.265-rc1.gz
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

