Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45F9817E2
	for <patches@lists.linux.dev>; Tue,  6 Dec 2022 02:51:58 +0000 (UTC)
Received: by mail-il1-f181.google.com with SMTP id x11so5132666ilo.13
        for <patches@lists.linux.dev>; Mon, 05 Dec 2022 18:51:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=V3MdnT2Q8jLXM5s//gvYhHT+ZNu/mw7aKngm+TpuXkY=;
        b=hljquEFxWH9gVm57LzSmKa5Boz6niaLrsVzNGCkHuXXgG5fmUXJSOBgnQgNm+WEyJh
         QwdafYwlneQ2GWZ4PuokY3E6jUevpx9z5rKxnDS4j/d7P1znBQ82Vw5FGDtrktYlbusb
         v8vk/BkqaPmWIl0uM5gfzRIGko6MGtsZPdAlM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V3MdnT2Q8jLXM5s//gvYhHT+ZNu/mw7aKngm+TpuXkY=;
        b=AazE8Pz8q65RzOST7qVHzkSPI2WjXJEGmBlrvPnh/bw+2p/JcRUimU57byJiQSownl
         UqGBwMob5anrNH1uFI7oRXDv1wF9qMznWTu+EsOzAZsOElba3tbzizFz9xYhGKmxGB8R
         6kVqSeq7iP2lPvRUz5qUfA52jMu5nxw6XMfa/oN0ekdzX3Al+VOjAL6GiomMcCCebI8O
         ykojVl7C4oOwfhPdAnOct/hfe5gUYJ7ri0d5qnpme9m/lKc39NOChHSOWLh+61HDvehz
         INTM8BsrSi1Emuy0gTfZAxbEYBPOXP7TxXhsJUTyKSvjd6CgKMOlptGTbNDoaadwwV2o
         DQ0w==
X-Gm-Message-State: ANoB5plfXt9pLFTo7G/OCEglraGbpoxHHTgH2I3x6i7t193j86Nar45A
	NOcECDz4LcmuFaWHe7X+aU4aQg==
X-Google-Smtp-Source: AA0mqf4vnfK6800d5tmO8ssv2j07jmhTqhELwF6Y2JSA95pjebZYddw96ZCfwuZg/w58xuaEIu4Lwg==
X-Received: by 2002:a92:db42:0:b0:303:26c0:e1fe with SMTP id w2-20020a92db42000000b0030326c0e1femr13434267ilq.102.1670295117272;
        Mon, 05 Dec 2022 18:51:57 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id n12-20020a92d9cc000000b002f966e3900bsm5672414ilq.80.2022.12.05.18.51.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Dec 2022 18:51:57 -0800 (PST)
Message-ID: <33b0b34b-8d51-a0f8-e559-5d5bea4e2008@linuxfoundation.org>
Date: Mon, 5 Dec 2022 19:51:56 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 4.9 00/62] 4.9.335-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20221205190758.073114639@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20221205190758.073114639@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/5/22 12:08, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.335 release.
> There are 62 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 07 Dec 2022 19:07:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.335-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
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
