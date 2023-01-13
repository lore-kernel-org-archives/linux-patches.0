Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA6ED364
	for <patches@lists.linux.dev>; Fri, 13 Jan 2023 00:28:55 +0000 (UTC)
Received: by mail-il1-f181.google.com with SMTP id o8so10180688ilo.1
        for <patches@lists.linux.dev>; Thu, 12 Jan 2023 16:28:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hZNOgWY+wu8EUCGbmL0mlYj31vUExbZVXvIO41YhhR0=;
        b=CNspTNQkDq9EkGxcnCIF52GD8/2v6qM+FJSawc7AAQPFXKdRni6xuEoA/UQzCEbFCf
         3evm+EFZr9JIJGYMnrfbWQBl012QxML40ztJOdfM/4Ke3WcHRzoXVsHu7TELR0wr/FNp
         NzN/WtGoWZiIt3fYFsE1gAUtQ2fmKAPxni/3o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hZNOgWY+wu8EUCGbmL0mlYj31vUExbZVXvIO41YhhR0=;
        b=mYyxHiI58mzIYQbkK/ohjrusZ9cv5LQb2JPu2Gvwhb+OlDMvgqRAxwBHvGPqTVV9yf
         KiyXePtg21LcAG67GI+brT/5GX5vL/b2Y4pQ3O8AEruG5EnibheysO0GZVNXdFO00MET
         x0Kwcmjy8qC//kcZRzwQS5CAgSqB2pN5fl+YHKdDcT+tV7HjtSyHTvUnxVGdNMNiQy++
         YkZDB7wUnpLiKsQ178eSCSTxBaLWS6CLGeDGWvJ7YevYHO8pahMLJfXKM37JZEIVqj8R
         3eI/+C/p194QEtwK2VJKXXxpkciMsZxq6bmGvw9hZGbSZugIw61FLYlh785FW2D9SJAh
         8t/w==
X-Gm-Message-State: AFqh2kqm0u5STy0QRh2ZTMB3qKqv85YmvifvjGlbGFmNNvWsFFwRbFeq
	38NgXcTFx4IxLu/+o5L7CE+IRw==
X-Google-Smtp-Source: AMrXdXt+Bi81AbfqN9L6DgUrkp/sCjlIomXOKfRQ6hklPuFZkFrN+bR4FjsNoAtpZ02BQ72CTM7hJw==
X-Received: by 2002:a92:c9cb:0:b0:304:c683:3c8a with SMTP id k11-20020a92c9cb000000b00304c6833c8amr10953621ilq.3.1673569734911;
        Thu, 12 Jan 2023 16:28:54 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id e7-20020a028607000000b0038a007a26e7sm5802331jai.126.2023.01.12.16.28.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Jan 2023 16:28:54 -0800 (PST)
Message-ID: <561054be-bf12-e758-ab9a-9b86786130c6@linuxfoundation.org>
Date: Thu, 12 Jan 2023 17:28:53 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.15 00/10] 5.15.88-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230112135326.689857506@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230112135326.689857506@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/12/23 06:56, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.88 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 14 Jan 2023 13:53:18 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.88-rc1.gz
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
