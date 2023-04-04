Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D29ED7E
	for <patches@lists.linux.dev>; Tue,  4 Apr 2023 02:06:46 +0000 (UTC)
Received: by mail-pj1-f47.google.com with SMTP id gp15-20020a17090adf0f00b0023d1bbd9f9eso34651235pjb.0
        for <patches@lists.linux.dev>; Mon, 03 Apr 2023 19:06:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680574006; x=1683166006;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Yg3KNpCzYxCqceie9nt7XenBxro5Ywoy7Y4Y9DpdSFM=;
        b=DBiuoKI1ikDniO1QuGcwGSBJm72LeyTWYYhVIQpD1W/ggc6GlKD+QoASovoqGckd3N
         HmctTNwNuB40ijA+8CaqdC7F5UgjGfH02ek/007m4kqutkWX5Z+ZRNdvzJbQTzkgZmRL
         uut0Alg//Ouyb4HbDa9r5VnF9GiYEz+wLPHs7VezI71LHMEN1eh0nhceAo8aez3GAjIE
         xINaztyY4k/EdmhV4E42xfj/TtkMVL4QYc/c/OWwd2WUyaez+4ZnevwJtWfFLr84nwlq
         pu2EobVq+kcacI5hTrFdWM5flwm1CJMwIJKHcL34Me7+nd0lDyrOkQBQSrEisyoTipKW
         6GbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680574006; x=1683166006;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Yg3KNpCzYxCqceie9nt7XenBxro5Ywoy7Y4Y9DpdSFM=;
        b=CrqrQI5FKzGTl8b/lR5UKMwUpiT4Rh0i0kyQm9hd3E5elma8XOPdme5odcjg5bGIu5
         jGoowMTSqFJl+9DtvBxfA4eM1AImYXvyLMKdLkWPk9Bo/oF7SqMNIkI+I//4oLDkjiag
         a1x1AWs919wAMcOtpRI3l0m/mpnvH6ahof+aS/ewUlg3Tvt0bNl/TLsoHqk5YoS2VSlr
         Sw9LFL62fZblcdKBpc5DLWZ0rM66uz/3kVDORGddBl4fUwYIn/IfviL//DN0RQEX8ny/
         iAEK2NLVQy+CZdHy2/B+zZkwA3kTrnQUFV4Ib7BeENfh8m2bvZd8yf0TW+Aj9MXzoQDj
         Vtqw==
X-Gm-Message-State: AAQBX9dj6KlZe8nqKq1mAmKefzO80wmoD+BlMA95d+Wj14XA/wU1RUPK
	Y1Agzz5o5GTf0HnkI746eFc=
X-Google-Smtp-Source: AKy350ZGZI0VU6EqvF28Y4dxd8lFGL9GZNgPLJ7gytxP3dBdmMLA9NNZivOxYXoruWMWw2lWVbmK7Q==
X-Received: by 2002:a05:6a20:bb19:b0:cb:f76c:ceda with SMTP id fc25-20020a056a20bb1900b000cbf76ccedamr804946pzb.22.1680574006178;
        Mon, 03 Apr 2023 19:06:46 -0700 (PDT)
Received: from [192.168.1.105] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id y3-20020a62b503000000b0062e11842b84sm3180946pfe.169.2023.04.03.19.06.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Apr 2023 19:06:45 -0700 (PDT)
Message-ID: <d1455286-455c-3a30-e9f6-452546bfac44@gmail.com>
Date: Mon, 3 Apr 2023 19:06:43 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH 6.1 000/181] 6.1.23-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230403140415.090615502@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230403140415.090615502@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 4/3/2023 7:07 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.23 release.
> There are 181 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Apr 2023 14:03:18 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.23-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
