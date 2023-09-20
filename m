Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02D8F41A87
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 21:35:43 +0000 (UTC)
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-7748ca56133so2443739f.0
        for <patches@lists.linux.dev>; Wed, 20 Sep 2023 14:35:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1695245743; x=1695850543; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wnjLBTOoGB3BEH/QsYYxwDhaW5W429+ymNjcE88GaWc=;
        b=cQRiEcyQv9xfWQh6E6czB6y0jG0vetS+Bf9buYAIRHsh5k98G0WN4aAwHU1ozecVAy
         A3ElcKD2T8v8aVl/7HgF+J/Xfj4+vZHfU+NI8VhuKjaeBj3ppwMJxzjbkSIlXYEharNA
         EDSePPH6myoBOabaPmEQGtrvmtmYSaKpqlMN8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695245743; x=1695850543;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wnjLBTOoGB3BEH/QsYYxwDhaW5W429+ymNjcE88GaWc=;
        b=KbyFsqoUJvhzGp7H+5u268otxcKT434xZsHMP6mrC9hJPcH0sncvSxrGZzLTFiewwJ
         ZaN4BVMdIFYCpk8Ob8APywMiCsG+IL0fsM2COr52Yij5LuDlnwImoYEVz/aZnu57UsS1
         qM6oVpkq2FB1aaWCWjwIB9KR2neLZeLHUFQjqrMhMB1dLVKVnK72G/OOtf1G8AFRy233
         Nuk2aBjFXYmhWYITjZglqZc42tixzImYUmlSPss9+2B7mNPBxbXhgx1LAKz+toOzOzWZ
         JZt8hKkD1Hb1MmXphFJClW1aBQGGmx1WsME/Tv3xePYnj8bafFjBdJGX+T27IfjD5BRT
         BISw==
X-Gm-Message-State: AOJu0YyH6qj5DFUF/xwGWkJCt5rXBrUYbTJcNr2y4ErlzVAR4VY43HxA
	e+euMIEuxAO176KaPk/ZKUh5Jw==
X-Google-Smtp-Source: AGHT+IFJemHteVc1ljGTNwHf12PlSt6hsHhCIWqr117Co1UpKaEaeNRR+7WriBQWOyoXCTlNDe8TRw==
X-Received: by 2002:a05:6602:4996:b0:79a:c487:2711 with SMTP id eg22-20020a056602499600b0079ac4872711mr4715130iob.0.1695245743114;
        Wed, 20 Sep 2023 14:35:43 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id x15-20020a056638010f00b0043194542229sm4126541jao.52.2023.09.20.14.35.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Sep 2023 14:35:42 -0700 (PDT)
Message-ID: <b581fd37-1e31-1d9d-b87e-23e916bc2116@linuxfoundation.org>
Date: Wed, 20 Sep 2023 15:35:41 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 5.10 00/83] 5.10.196-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20230920112826.634178162@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230920112826.634178162@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/20/23 05:30, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.196 release.
> There are 83 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 22 Sep 2023 11:28:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.196-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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
