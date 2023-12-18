Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DF53740AB
	for <patches@lists.linux.dev>; Mon, 18 Dec 2023 23:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YKfmYZ0x"
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-7b70c2422a8so43728239f.0
        for <patches@lists.linux.dev>; Mon, 18 Dec 2023 15:55:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1702943730; x=1703548530; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tAAwxG448biTn8MtDNLxgJZ4OzA1M5+6aRFoz6CAg/0=;
        b=YKfmYZ0xMqYtQoAcre6Ass7Z1PLlgucPq6yyu2mblm+UmGHkCFBUVRNZXvN7JpZuH8
         9N5W4YaplPQyznVSUohGGshQ6xMTYJRo5k/g4LqI46n5ZdqMbpd8GmwUCtZJPyfYjcU8
         okCdTBzSJ8ZnmlkRlwmtjW8vbeODtEj2aXwU8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702943730; x=1703548530;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tAAwxG448biTn8MtDNLxgJZ4OzA1M5+6aRFoz6CAg/0=;
        b=jEZ42Gr2UuZBcVrnc/vjYX9sr5OBddkjy9fcen6FD+U1It/4Xl5eUTvWoZytpAj6oN
         2X8KvPj9xy8sBnohY09zo11AygY4IKcaeuRvS7FQ12R+z8uDexzoPAe4Ioles14jXttZ
         IMqqomeBk9zioyiLrmMeUfg2jh7Uy5Y9VeypqXn2m6YkeUO7lBCK43wuKC80AJeph9sA
         71AxwzQgwP8FeQvO7POz/XXa87+zEmGadKJqtVY4IC/bsFdaohHQtp/ODmIsPIPNSHmn
         YP7KesubfJoQKgbLrGyINgp8cdBmIFbXJ5h+2GCblU9IfFvHEbutreFNYuA+jjkR5EGj
         9EMQ==
X-Gm-Message-State: AOJu0YwqgX0Sa2nmTnouVux6Nwq5g8x55OUiqHstxizmnbpVxmIe1aQq
	s/smG+4o9EKW3opnJXdvjqIXzQ==
X-Google-Smtp-Source: AGHT+IF5zl2TkZasMx+z0wTDiacZ/lZvxYR6zMJCtjlSizQqf2MRKaABbf+I/RYFqBPfX+p7KjZGzg==
X-Received: by 2002:a5d:9f05:0:b0:7b7:d4c3:65c0 with SMTP id q5-20020a5d9f05000000b007b7d4c365c0mr3538714iot.2.1702943729908;
        Mon, 18 Dec 2023 15:55:29 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id ck27-20020a0566383f1b00b00463fe3a0860sm1039606jab.142.2023.12.18.15.55.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Dec 2023 15:55:29 -0800 (PST)
Message-ID: <2f2f76ee-c333-46c0-ab0a-8930848a3276@linuxfoundation.org>
Date: Mon, 18 Dec 2023 16:55:28 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/166] 6.6.8-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20231218135104.927894164@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20231218135104.927894164@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/18/23 06:49, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.8 release.
> There are 166 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 20 Dec 2023 13:50:31 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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
