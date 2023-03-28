Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F1932F2A
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 21:06:20 +0000 (UTC)
Received: by mail-io1-f48.google.com with SMTP id d22so4933692iow.12
        for <patches@lists.linux.dev>; Tue, 28 Mar 2023 14:06:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1680037579; x=1682629579;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fh1p9EqtypVK/FU1PKqg+wt7kdvoTdm3/SCa+JJX8Ck=;
        b=b3ICo8AGkcBYTVMqEwoP27yNuHsqoxH3gzS1yJX1qPxvm6x88wiBkduSJcW77czSU4
         Ks8izqJOE7OcybjyJKDMX3QEEU05MWDKwOBaw0xSB7jwHYAq86f3ryIKfo/g2uvWCMzf
         4pQzsT1Qbn4JxggEkaiKkVVL3ywvSpnOafPzo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680037579; x=1682629579;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fh1p9EqtypVK/FU1PKqg+wt7kdvoTdm3/SCa+JJX8Ck=;
        b=7RDR+X1bnDJaeRQ8EYNCpswbqM6U1lf4nj25sLMqUzHZC6m+gCjky6jvmPUvXo0JfU
         jx4zmT0TH9CfotrqC7gVguUrN1IBhDXBHO5ymyCgocv/o4GmK4oYVw+flcg2AQl+LqW5
         68ANO5+GAD69YcFwrCuREIizISwjDquK+kwtFaEOxOwDngHpIWsDR9GpQtMH/qEHuWC/
         zTxd4+SlcljsEvJ3nWoh5Wbu5+q+8TW1munHXwPPbWHfRv+Kq/iUnevsrjoWPa0gX97G
         CrRTtF6VGPE9QaTSB2xugXjKbmbv2EhZhvW4/l9ZwGlesyVC13inMNRd/HILGiD5pddp
         9ypw==
X-Gm-Message-State: AO0yUKUwtxeSRfIqs0b5hM6HnUwSucoP09VQfUdfLC+1+G6MhZpmmKgl
	C6PGWzWkHtjOEf1d2rPg6lYmuQ==
X-Google-Smtp-Source: AK7set98fryjX5VQtWqqGxbEj5ekYdOc/twUQ9Ozgv42EacGk99K4Q9qOmIYBq2cfoF0ItshG8Qgrg==
X-Received: by 2002:a5d:9d96:0:b0:757:f2a2:affa with SMTP id ay22-20020a5d9d96000000b00757f2a2affamr11128697iob.1.1680037579430;
        Tue, 28 Mar 2023 14:06:19 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id w7-20020a056638138700b004065d5d1447sm8416688jad.171.2023.03.28.14.06.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Mar 2023 14:06:19 -0700 (PDT)
Message-ID: <e45b5a19-a613-beae-4465-b4ad6e55e7a5@linuxfoundation.org>
Date: Tue, 28 Mar 2023 15:06:18 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 6.1 000/224] 6.1.22-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/28/23 08:39, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.22 release.
> There are 224 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 30 Mar 2023 14:25:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.22-rc1.gz
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
