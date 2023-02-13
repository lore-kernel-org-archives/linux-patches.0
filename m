Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8687BA31
	for <patches@lists.linux.dev>; Mon, 13 Feb 2023 23:33:09 +0000 (UTC)
Received: by mail-io1-f47.google.com with SMTP id y7so5137096iob.6
        for <patches@lists.linux.dev>; Mon, 13 Feb 2023 15:33:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1676331189;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WcecfU/edwS7AGp0sYBsDhgpFnK48au1GjUG6IZeTp0=;
        b=f2/HZweqKXZU+CpwEr7Cl1OOoV9Aduc1XdOQ8Pf1qbQD6diDEQ6+NFOWdAzICR1NbP
         rrrxm0rP+JCCk2F41Z+7qq4TQRiSF8dp7RVPRqV30zEtzFWd1dZftYO4r+aLSF2r4bP5
         KtcxwiZsoQcSFKcbpG5FFU4jKyO3YqGZ4tRWE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676331189;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WcecfU/edwS7AGp0sYBsDhgpFnK48au1GjUG6IZeTp0=;
        b=cloZ2KMmh+bcQc/LuZKLSRyL8+7RwISFCLj4D9RK483k1PqbKWH4z4gIx4+Gne3C+e
         5dZ+elDjdJIXmu5kJMBCo0PJBcht+tNz6W0I9aERAyp2mTBJmviOcSpMi1xi67lDgaZJ
         e33vPyTbIQdIihwaxsidNIfeuURMeRcNBfvqffnmykNw5zXO74F1gp21lywPrZn6mg4Z
         SDAiWkXPVlnDFEEhUYeOmWBMP+evzUun/fIm+lxpWYBTkOSxTlCsX8e2tirKRRK4L9qi
         YeJUVdN7edM+aksSc4o4H6RxvY7XoPWrXpjS6Zf1jxCwhCFEHqZJQuiuBx/571d1v691
         NTNw==
X-Gm-Message-State: AO0yUKXXOSWcwxVBpWgPBg0Tf8JJB91AGwm7Xl9peMsAUqgUb8vfscQc
	3aytFWXvCb/myhcOPMM3lYDIPg==
X-Google-Smtp-Source: AK7set+CX5Ojyt2t9CXcj4bboO8JFe8jXHIgv/Q/yAuQX8IkBAtuJyg+dKtVEWZ9rISdwGVTRudQ+g==
X-Received: by 2002:a05:6602:2c92:b0:718:2903:780f with SMTP id i18-20020a0566022c9200b007182903780fmr263014iow.2.1676331188775;
        Mon, 13 Feb 2023 15:33:08 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id x17-20020a029711000000b003ad13752c9csm4118474jai.72.2023.02.13.15.33.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Feb 2023 15:33:08 -0800 (PST)
Message-ID: <130a351f-2113-e333-83d5-0e19e92c8209@linuxfoundation.org>
Date: Mon, 13 Feb 2023 16:33:07 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 5.10 000/139] 5.10.168-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230213144745.696901179@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230213144745.696901179@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/13/23 07:49, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.168 release.
> There are 139 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Feb 2023 14:46:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.168-rc1.gz
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
