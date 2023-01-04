Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15C78BA53
	for <patches@lists.linux.dev>; Wed,  4 Jan 2023 22:18:31 +0000 (UTC)
Received: by mail-il1-f174.google.com with SMTP id m15so20248942ilq.2
        for <patches@lists.linux.dev>; Wed, 04 Jan 2023 14:18:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KKo5fPMRdKGz/7RZcIbHkPKTsudmAdqtb3BfDvd7eiI=;
        b=NOAn4CM7EZnxg3vagPtncIfpjpLv7OC9gil6WAGwp8N2XaJWrEdp+HZFRLePILULVv
         NWPB+VDRTb6xuZWPoa+qdI+fle9KwJVqkUGeL3AxCQVlZoQPgaCzwywxV3QAY8PeaIqN
         EmtZuaa1i3nk7xK4U1RdRqiA7MglylS9tYiKY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KKo5fPMRdKGz/7RZcIbHkPKTsudmAdqtb3BfDvd7eiI=;
        b=lRcutzA01xn1KI6oOs2RGnOnaw8MHADGNu43+nre79sFYVGbx/8/OMq10dPuo9uRWk
         cITltna4CFEFmmfdq+2//me8huYTFXEhibVBqK/G2EZai/2AsFL5dk1vLiIS5sTq2k6H
         54pHskVSVnyxXvjW4A/y7oJoj89elQWWDJHEn/2rKj2a7QlEv/E+f0M7FQoxWyJFuAtP
         H6SMOLlFcuTFnOfZ4sHvsqSJH4nnOnPIDPzuXq94Qa+v0iEuOagRgxiEVbQxxGd2x+jM
         rxuag/m8ApqZ7kNK47ry55I6vmowsvQjU9mNGK+iKJdKMJGSSTP3cyQROveG5rdkXEZm
         bUEw==
X-Gm-Message-State: AFqh2kpm7zF6SWx9qyM63UwDU3jZt2klTg75m79AIXR0MMtmB2Do3LoV
	nmXU2vjSLU7bdZhQ5Vnao4e3/w==
X-Google-Smtp-Source: AMrXdXthTw+Kow5gRYahz4F8OuHqi2IEJEDJjoJn0MD/pP0jU50f21tl3vta1TAJAkv9LbSf5y8SBA==
X-Received: by 2002:a92:d307:0:b0:30b:d947:6bc8 with SMTP id x7-20020a92d307000000b0030bd9476bc8mr6730778ila.1.1672870711036;
        Wed, 04 Jan 2023 14:18:31 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id g62-20020a028544000000b003781331d909sm10977580jai.9.2023.01.04.14.18.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Jan 2023 14:18:29 -0800 (PST)
Message-ID: <b7bb6c30-7f6f-80f3-cd10-b68659f6e0bc@linuxfoundation.org>
Date: Wed, 4 Jan 2023 15:18:28 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 6.1 000/207] 6.1.4-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/4/23 09:04, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.4 release.
> There are 207 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 06 Jan 2023 16:04:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.4-rc1.gz
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
