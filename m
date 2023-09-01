Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9034E23BF
	for <patches@lists.linux.dev>; Fri,  1 Sep 2023 15:35:29 +0000 (UTC)
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-1c134602a55so495067fac.1
        for <patches@lists.linux.dev>; Fri, 01 Sep 2023 08:35:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1693582528; x=1694187328; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hTAgaIHV2Rbthcqd0GIeKy9VSrzSAIC0+RYFwEdspZM=;
        b=NhXn2ur7oK6kKtvRid3rj6uWKYVFSQtz/4UYCTE5syOKq37LrrKWE+t9EQB/9rhYXx
         FKa5tmd675/zsjI6wnZLs9+y5J1pQa5vwWezpgRZksW410788zMhE8bAP4ak96WEYuJ0
         KXkmVsBDfRN+/6QKXZllptwPZH1Wx6l46jSe0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693582528; x=1694187328;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hTAgaIHV2Rbthcqd0GIeKy9VSrzSAIC0+RYFwEdspZM=;
        b=QYPPsPKiwEv9h45/hseM9shiux8Yuy3YSOonV5KnJlNXeLXxHcNCrZ6mAQe/Qt/Z8F
         TN84V/Aw+gzuy90k4aMHjkErU8WEaZGLoose2nypNADqVzLuRFDoa0d/THxA2NFhz6xe
         IKCM7r4JmGd0b3NXMqz9050InTvjCg7knoU2wDhhH1hGaCkQX3+4DnWbtrsbZtMDcdxa
         7JN0WawAXo6gdhyUvyiBEmadN/qwuSbxLCFCzNMCcthaPiwdf1opRlgcCaVSTRCrkh3f
         70pAlviui+voObIdzBb2vbUb45E3Rqze1rYqaTEdWKNFK+qpHnvwklnw1BeC7PNoZIMP
         zALA==
X-Gm-Message-State: AOJu0YzgSZKU4jPAh49T6XyqXG6lNJdGDxIB2QmZ9VmS+neL/cIHShoB
	wSRW5e9EqyDZX2Dnr8J2C209SQ==
X-Google-Smtp-Source: AGHT+IEOeZ6seXktCwZa24B3/OHNkOBSaxYQj8enZl/xf5knmJu5UdOWdrgkCFQ8hgO0zYD/5uIMjg==
X-Received: by 2002:a05:6870:ea9e:b0:1b7:5e47:5b75 with SMTP id s30-20020a056870ea9e00b001b75e475b75mr3199400oap.4.1693582528479;
        Fri, 01 Sep 2023 08:35:28 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id d40-20020a056870d2a800b001c4b473581fsm2258172oae.12.2023.09.01.08.35.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Sep 2023 08:35:28 -0700 (PDT)
Message-ID: <1d74a326-1271-e21e-3a11-ea7ab05b0f23@linuxfoundation.org>
Date: Fri, 1 Sep 2023 09:35:25 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 5.15 0/9] 5.15.130-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20230831110830.039135096@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230831110830.039135096@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/31/23 05:10, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.130 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 02 Sep 2023 11:08:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.130-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
