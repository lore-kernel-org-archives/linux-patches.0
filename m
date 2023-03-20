Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5ED77B
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 23:02:00 +0000 (UTC)
Received: by mail-io1-f42.google.com with SMTP id o14so6197851ioa.3
        for <patches@lists.linux.dev>; Mon, 20 Mar 2023 16:02:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1679353319; x=1681945319;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ol+B8Rm7LVaQanwklijT53+0nw4R6I7B4CbLiSGN/Pk=;
        b=PR98NuIACi6GbtffTTQ7GRyP4Rm4we7JytqtLL0DNMowMIpj6lwi+zMMLMW357zcV6
         YdebfM1/BAdRQY3RkxPHtNVbJ0GYit4yBNH7E1whw/0NeFAWrn4AEkkLVkT+jZmar9oD
         SSq8qzXDLWndR0TLSaixDGX1C/o57uvdI+4N8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679353319; x=1681945319;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ol+B8Rm7LVaQanwklijT53+0nw4R6I7B4CbLiSGN/Pk=;
        b=2LfhJQA41NkrvXLIzkjRWNovIe7wDgxPpkhJK9eVXsFB8ao/s5Re3LnrZtMBL57Zo0
         iMsjcJ0xdCla4ziZ/880ufE4acnPDzAv3sne7mDJdVRe1bZZhoINSNuOtsAy1UoBmaFI
         4FETqCfhcOvkks8bdndaKTzWqwcoldagaAGhR/G3Mtr3NIt94iaag8bVK4juaqXwVgoI
         47sKi77xN+pZzVCSP6P5/+8169u/faC+vljNZplOhRwVG1C8WwrwK1khHQLSJw3t/jQW
         VoSxZ2gquXIRSx8HV+YSq4Yza869k2OETqX64ijmtueTcAJMijgqt9r4PCqdB9K53IOy
         OnlA==
X-Gm-Message-State: AO0yUKWoJbLlvjTt+k+PtYPYEMSU09cOJjIG2vOMXai9ElCfcXcwEO2l
	ik5tAODLa5Ciaoi9qyIeAl+0Gg==
X-Google-Smtp-Source: AK7set+J2U/lAYm7gRWd7YMrfKnfYIGgwX40P085kk4oMiavf4S1Ehp5iZ4v8YfjrYKAmn+dfxfwDg==
X-Received: by 2002:a5e:c817:0:b0:752:f9b6:386b with SMTP id y23-20020a5ec817000000b00752f9b6386bmr690135iol.0.1679353319570;
        Mon, 20 Mar 2023 16:01:59 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id g21-20020a05663810f500b00405f36ed05asm3553624jae.55.2023.03.20.16.01.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Mar 2023 16:01:59 -0700 (PDT)
Message-ID: <9d8e16ec-4336-f26c-a132-d95cdde2a4a1@linuxfoundation.org>
Date: Mon, 20 Mar 2023 17:01:58 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 6.2 000/211] 6.2.8-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/20/23 08:52, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.8 release.
> There are 211 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Mar 2023 14:54:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.8-rc1.gz
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
