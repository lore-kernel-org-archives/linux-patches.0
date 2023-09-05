Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB601DDB6
	for <patches@lists.linux.dev>; Tue,  5 Sep 2023 21:16:43 +0000 (UTC)
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-790b9d7d643so22501439f.1
        for <patches@lists.linux.dev>; Tue, 05 Sep 2023 14:16:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1693948603; x=1694553403; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lN5fpIYRwWULY83XeFrIApl3PJ3oceB+pvimMrfAuCE=;
        b=Mo8U0te1O69CjH7kvJ0CK3OH2kaCTGDtSQ7vU79n74wNuo92yplR2bK9f8QnAETpDB
         vrXPsrJ6sKO+YkF9F6prujtpzXQu3w243Pi+5++VBpYpCpXohnLfniEQXNUd4mW9NXAT
         tROcdBLkJGzo/ga7eAHIvsZAVoAOgLT42NvV0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693948603; x=1694553403;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lN5fpIYRwWULY83XeFrIApl3PJ3oceB+pvimMrfAuCE=;
        b=UXyo0//jlgSX76nk7nh9J3hTQFVUxQozDc3tFp4/48qiLo0m+ie0mbV2F9zQ636BpG
         r9QRuPeITLC2xwQmCciPBrAkiTsFoj7gX1feQCemmmoX5ds4IXVU+Cbl3kV37mZ6tyke
         piq35M4tVkwC0Ns4a0f2yIqoY+2nS6TXlmO97cr5ncSbB30ORhEyVgFsc/M2bVE3JpBB
         bYmk2inEzca+iQYdVeFpWF1MfCVbfqmKk+WMzTSmVtiowRCxAzTv57p+DpFdSy4XhcZv
         5HUBuX2uVTuM2ha0j+fl6Hi1iFAxZlkmb79On0ufe54R4axfa2xzEMp5LpEvCPX+Qp+7
         SPVw==
X-Gm-Message-State: AOJu0Yw8o8qHOyFsaeGgyyJy4AL93Ur885oLhdSmaIRykCi8JAtfvWAJ
	bhvrFtMctDl7Ua4P+VNgS08IVw==
X-Google-Smtp-Source: AGHT+IHEPY4lFmXX0Ow6iJOiyRNqTd9k5SNtoCEfUz2WO8gHrcXjl+GBxtNwXR+mSJe6ze4lMbh59w==
X-Received: by 2002:a05:6602:4192:b0:792:8011:22f with SMTP id bx18-20020a056602419200b007928011022fmr12640055iob.0.1693948602750;
        Tue, 05 Sep 2023 14:16:42 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id v6-20020a02b906000000b0042ff466c9bdsm4449092jan.127.2023.09.05.14.16.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Sep 2023 14:16:42 -0700 (PDT)
Message-ID: <3c819b63-19be-62a6-a3a7-5c4430f7827c@linuxfoundation.org>
Date: Tue, 5 Sep 2023 15:16:41 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 5.15 00/28] 5.15.131-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20230904182945.178705038@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230904182945.178705038@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/4/23 12:30, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.131 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 06 Sep 2023 18:29:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.131-rc1.gz
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
