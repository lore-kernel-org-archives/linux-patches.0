Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1858E7470
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 18:21:04 +0000 (UTC)
Received: by mail-qt1-f172.google.com with SMTP id cr22so17745577qtb.10
        for <patches@lists.linux.dev>; Tue, 07 Feb 2023 10:21:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uNoCuvF8k/IGVgv9MTdzYZCHzKUcqEKM38i1vceSI2Y=;
        b=QdQ71qYYT0xgyoNJdybVu6bekywG/lSvp5wx6rU5hsJ2AFd2ia5f8Ph/6NHAe5LXvM
         yIbiTtMpv2qYiM61f69Lez0/bP2x0TqWbe8ew7/1nW38tkG33CP4zCJsry/SmepvR9lU
         bYflQM1HrvqymwOAt1OwBRM0Nd4JWlpYBk6fWITv/grNz34I4aOAykUJ5bmXq9ogA8Oc
         vQwnGB5Z6cSiCx5Wf7iT46AWJbbtbwUUoDouMowKJkPqiL2BaFl8XF84ITq9xVisOyEP
         FuKg7hBmze3nvJ7JfdkClDMN82eU3T0wEzQzYDoBJeGoghnB8Vtzd+BypUcera2UZeJn
         IsTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uNoCuvF8k/IGVgv9MTdzYZCHzKUcqEKM38i1vceSI2Y=;
        b=xAAat6Ftd9cXC3cWu1LaSjhP77hwZYV4/FJvO41Z1J2my1cPvmKSqYAWI1qIGhq2JC
         0XehZQL1Q7oE0r4TrFQJ4yGhVQI2YqP14Wjr0KmytiQ2ss6Dp9xSGtzg9yQUgZy3WCUS
         p/RDVvz+6Yx7Z+HjqtLqWEGN17Czz5aaeaoHF7yFGiZe9LreY4gdIYEFY1CkwU3sZ3SX
         HtLh37KG6zN78eMJuPA6RsA3an7Fketw0SiRv1wklkFF6AOhej4czPv9/daYFxF64+61
         mRharWgM0synLHp5LncYkJjXpw9b6BwVNHogkVXQ6AV9b6RPrKjbJSCE8K6RzhE4hU8x
         rwLw==
X-Gm-Message-State: AO0yUKXGqXrJN+If5bugqQEgXtW/xcKPW2oFqjgcLCsJjw3JZ64wT/7+
	6otdpYtfS26fyvVOODU/TlU=
X-Google-Smtp-Source: AK7set8P7XEs+Z1mylqUEpNqmN5S6L1etKNkQzg5lRXZj0sNtQz45dsph1NS3hqwt2mCcBsBFjitTA==
X-Received: by 2002:a05:622a:18d:b0:3b8:aa16:82c1 with SMTP id s13-20020a05622a018d00b003b8aa1682c1mr4725673qtw.60.1675794062929;
        Tue, 07 Feb 2023 10:21:02 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id g25-20020ac870d9000000b003a7e38055c9sm9733458qtp.63.2023.02.07.10.21.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Feb 2023 10:21:02 -0800 (PST)
Message-ID: <ad03daa9-8317-a289-865e-9cad591d91f7@gmail.com>
Date: Tue, 7 Feb 2023 10:20:59 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 5.15 000/120] 5.15.93-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230207125618.699726054@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230207125618.699726054@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/7/2023 4:56 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.93 release.
> There are 120 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 09 Feb 2023 12:55:54 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.93-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
