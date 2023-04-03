Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03CA9A954
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 22:53:09 +0000 (UTC)
Received: by mail-io1-f50.google.com with SMTP id bl9so13548988iob.8
        for <patches@lists.linux.dev>; Mon, 03 Apr 2023 15:53:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1680562389; x=1683154389;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tLK6AdqZPI9EeXBosaGOeKpzPEQa7hz+RpopKNTQo+c=;
        b=AYCHQXvVZwr6X5YuHuzOFwRRF/mBLkQstvtj0g5rfvUxF1x0Bj+MdPfqfmCezkM8yD
         Ne5myODgElK4fGwDFTrgv7pTg+BKcgzsjMvhga9XTcM7voWfo8GI4LGXOr5+9ws81mhQ
         cyaoNMVRSFnZuzR16uD0P31+BhKlSO1+ftNYY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680562389; x=1683154389;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tLK6AdqZPI9EeXBosaGOeKpzPEQa7hz+RpopKNTQo+c=;
        b=ECWLpOFyoYfIu78h2lIbBh7oR2M2avo5nxm93dzmPdjdrJKZwfUR9M+0QHgtj8kkQj
         YaHZtvUgRuvrTN8uS1bZrfA72AgB1PbAwKU7MGb/gsHDsm2f8IX4MP7jTfoR37k4GwGt
         pIe8Dwju+wGdMeSuysjDiz6BNlb1IhmONpUaj0Ix/q3jg3UG+81L8L0INxEBRlo9qLhi
         7wf9m9GzjXcd7mWWCRpVBK37tSHk1iA49TcbnaPUcQiWOMyLmk1GvDp2iJlBA5Nzeig5
         TuJwkLNkH+kPjqRJhRQIXT4zkEkqllpU3fpcMoLh6xCIY7qwxP+wKl9YJ737xclRARVX
         u4Mw==
X-Gm-Message-State: AAQBX9eNfsMeagE8tdEOcntltMWYQ4b5Vg0Pa6QIiyHWiwcOGbtOv08t
	ddWFT/UDfRSE9227cdBsELDsYQ==
X-Google-Smtp-Source: AKy350aTKuwwIcsEDaHiNpYkLiOBKcIvE+GAjegn88GlnaCO4rB5agwNLkjViXB2UpaC3zqjYqnKaA==
X-Received: by 2002:a5d:9b15:0:b0:758:9dcb:5d1a with SMTP id y21-20020a5d9b15000000b007589dcb5d1amr707944ion.2.1680562388902;
        Mon, 03 Apr 2023 15:53:08 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id ay23-20020a056638411700b004063510ba19sm2983780jab.101.2023.04.03.15.53.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Apr 2023 15:53:08 -0700 (PDT)
Message-ID: <857401fe-4af2-537a-8450-42ca6ae10b39@linuxfoundation.org>
Date: Mon, 3 Apr 2023 16:53:07 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 6.2 000/187] 6.2.10-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/3/23 08:07, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.10 release.
> There are 187 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Apr 2023 14:03:18 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.10-rc1.gz
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
