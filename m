Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 166FB173
	for <patches@lists.linux.dev>; Wed, 26 Apr 2023 00:18:50 +0000 (UTC)
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-760b6765f36so14982539f.0
        for <patches@lists.linux.dev>; Tue, 25 Apr 2023 17:18:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1682468330; x=1685060330;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=96/H4W3C9TZkKAmavn5RuVFWXB3WOtk1dATmNZn2kZY=;
        b=M/U5AXVvVBfQ5J2iDnbfzLoFFPolUjsxufhtKyRxSAnGxxo3qmxLDpHrdGiaeiwTu9
         B87hXwWS5UfkFgQmou6LFnzBwjtJ/SCuWM9lWe40Ikm9ysy9TAB6bxzcQDIVgESpDK/P
         UpglwUHVPlX5K57nA7NynV3uwQ6engYWQhK7I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682468330; x=1685060330;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=96/H4W3C9TZkKAmavn5RuVFWXB3WOtk1dATmNZn2kZY=;
        b=ktrcUZuk4e+CNv0PMi3Fhkg90JI60+mjra+JUEzmsoHDrQ6tV/T6BgQ5ay7sdTNlab
         ZugVkN33IYyn7F03CtewcZMCpahEooeLptP42k6NQVHiVPi3ix2wm6fly+nggE83/s5J
         hoi++8UJqH0kP+Ycn5r7VyCNrbDxoBN58KRuBUXuEVtEtT8JkZ9Cg/jdGKyiBO6rPSxV
         e18D/uJjxvB0+fquIKzP7UQ4WDPawUbdYa+eLmLl5jfF7C+qS6Qjdb+KpaX0UKpq/ujm
         fFKuXVjeoGJbaovBQynztye0pwdSUwGw85Wpw+Z5qkum0gIGN4YWmJUoF4u56Q/ZlL+G
         OL4g==
X-Gm-Message-State: AAQBX9dLdyhB/85SIjKiq6odyYwwFEr4XAWw8NaqY6GOpMM3Fry7IKPK
	SLWFjDEIGqr5CYLT4d9eX9p7GA==
X-Google-Smtp-Source: AKy350bjUmbn2tJjaGXQ6+mRlj31VvU00iWebcpfegJx+wgf6pttv0syaAve8BYfSSS3bkw9O8zmSg==
X-Received: by 2002:a05:6e02:1609:b0:325:f635:26c5 with SMTP id t9-20020a056e02160900b00325f63526c5mr12617055ilu.3.1682468329952;
        Tue, 25 Apr 2023 17:18:49 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id p5-20020a92c605000000b00316e39f1285sm3825504ilm.82.2023.04.25.17.18.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Apr 2023 17:18:49 -0700 (PDT)
Message-ID: <8ab7221d-e654-855e-2eec-c7019a9ade1f@linuxfoundation.org>
Date: Tue, 25 Apr 2023 18:18:48 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 6.2 000/110] 6.2.13-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230424131136.142490414@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/24/23 07:16, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.13 release.
> There are 110 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Apr 2023 13:11:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.13-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.2.y
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
