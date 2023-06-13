Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C65A37E0
	for <patches@lists.linux.dev>; Tue, 13 Jun 2023 00:48:12 +0000 (UTC)
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-7748ca56133so40622139f.0
        for <patches@lists.linux.dev>; Mon, 12 Jun 2023 17:48:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1686617291; x=1689209291;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PEdxNFFhVohCl010Oq82D/VKe0cD6dF1PQkmM9OWJ+M=;
        b=WbzZ4rPId/ujKc9WfnzgJNR6zbmZn5s9u1PAGgP008Id6mmzPyoucJQsFkrPVkyljv
         mIB2z4iKTYdDovO98ughUdbkI9XzQY6XiJVOeUXTmYa0nzSlXoJ+koOXr0jrRIk72cyS
         j6hH84lAerhQ5ikOD2bMXj0lh07gLLc3Y/dmc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686617291; x=1689209291;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PEdxNFFhVohCl010Oq82D/VKe0cD6dF1PQkmM9OWJ+M=;
        b=iGPTei0BtS1m4x1JE344va/Fu84kxEGAHvcKlR3eGHQDDmG/UkzS7+TBKSnfpXK+1/
         Ix7+ND9mr61HjIvq+qgAHCpY5bQX5/a0qaCr9Po2A9JDDFY4AEs11vnWEHKfa44gsdp/
         EIGhl/N3tKcmuZwf4p+cKLyiQkh6bkHh6CzIzvk+QLOy0d6akLlJOr5sLbk96yPDh8C4
         ulXUHGJloq3waIe3Z/F+5UBWnsNsgPhlsuOmg9iq6v21Toicoe1JhCFbLo29vfn1lhFo
         fDD6kiqB4e++ANFM/to36iC0a/YDsAVg5O1nxxCeyO43t1Xick2EvCcjAYkA5NnQPqov
         9qvg==
X-Gm-Message-State: AC+VfDyV6NmD+5wG0KulL29/ewKmZ/+OUHOWpTKyl8UEUjmwzIpEoskB
	0Yk/vsPNaklioA1ZnA4zFkdawg==
X-Google-Smtp-Source: ACHHUZ4lnovdMhPjCWG1A9w376G/N+ye/8qOsLdzIQndElmSaEWOXslLI5f3CVxXZ02VqJUevgg7xg==
X-Received: by 2002:a05:6602:1789:b0:777:b456:abbe with SMTP id y9-20020a056602178900b00777b456abbemr5708330iox.0.1686617291699;
        Mon, 12 Jun 2023 17:48:11 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id l22-20020a5e8816000000b0076c872823b7sm3499208ioj.22.2023.06.12.17.48.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jun 2023 17:48:11 -0700 (PDT)
Message-ID: <52014a4e-7968-0c71-029f-9f7f45bea683@linuxfoundation.org>
Date: Mon, 12 Jun 2023 18:48:10 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 5.15 00/91] 5.15.117-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230612101702.085813286@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230612101702.085813286@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/12/23 04:25, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.117 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Jun 2023 10:16:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.117-rc1.gz
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
