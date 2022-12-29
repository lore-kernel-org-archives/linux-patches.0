Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 935F21105
	for <patches@lists.linux.dev>; Thu, 29 Dec 2022 04:01:02 +0000 (UTC)
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-14fe0e9ed11so10734735fac.2
        for <patches@lists.linux.dev>; Wed, 28 Dec 2022 20:01:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:content-language:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2BDqduqb6ENB6ect47hdnA/HnzbGe7Z34rN6m3i2/LI=;
        b=l8XXenh096e3GNy8CjcUgsB4J0pjM2n6DpzWoKe1hXQKzwtse2ongdLFrVuyQak6Xd
         Y/OimK0A3KWeYeCmfC4egSAk4h/DNN4kpYl9udTzSIF2BrU3FjaFnESzrRzZMeX9EHoT
         JHsgpExIEJSDsWammoJ0Pr53upuwmJ6sJSfVPwveM3V/IX0OfLGc176Katg7EEC14BdM
         K8VNQwnEDomWitzFkkxjIqhuCDqoSCto1ltoV84tUOMlSOt469uOWEnQ9rnSqqmDyvuX
         ueEAYjRTI4aMLqDH8VrCTE4ESIwjJCswD37JR4UjpqAcxXPVRDM4GesTNED+zjgV9HEN
         s8Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2BDqduqb6ENB6ect47hdnA/HnzbGe7Z34rN6m3i2/LI=;
        b=iRJxO+0BN36LgTPU2pa+k1RRHT+o7by60kqJvjx2ixVBf+/bLe1QcQ+ZiVGQv2syxY
         Pu9dnLf4ZSdZHA5bIYXhtT113Bn2YVC6UCGpq63Orqenfb9wjCFVGHzqGSjUITntxOg0
         Ab1Tv0zjzNQDswy2zxa87oiIDmd+rYgOqRgzjZKPXo4tJ+cjojF6NExwjVMHm54WABzP
         5CLjHmH4ApeNF2xhh/PILPFWXExmiiz1zSD28qM8mRmIkM5HmhBW8qXEw2jIhSD+tELb
         UDqH8NlUdIy2eHU1b/1L4VuSFQdFvxz+DjGBoA5n5L0BkozQzJLnSPmzMJQUMof0qIfW
         i4+Q==
X-Gm-Message-State: AFqh2kpIiMrrTIdRuA0I2XyW5zvD0hJIT7NZ5b4iQZ5imK8m+Ya4vcf1
	vHsGWDS7I0Al/zHUY6hh6/xQwA==
X-Google-Smtp-Source: AMrXdXtwQN5WQkPMfMqdkUGY2ukaQzlupyadCdigo1ZFao/pbOwF2Nav4Yqv/nDDJmoGy1Vl2isIQA==
X-Received: by 2002:a05:6871:5c8:b0:13b:1f84:b7ee with SMTP id v8-20020a05687105c800b0013b1f84b7eemr24415006oan.8.1672286461520;
        Wed, 28 Dec 2022 20:01:01 -0800 (PST)
Received: from [192.168.17.16] ([189.219.72.83])
        by smtp.gmail.com with ESMTPSA id a11-20020a056870b14b00b0013d6d924995sm8216333oal.19.2022.12.28.20.01.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Dec 2022 20:01:00 -0800 (PST)
Message-ID: <0328eb25-f711-d6ca-28f4-60601b6e0bfe@linaro.org>
Date: Wed, 28 Dec 2022 22:00:59 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
From: =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Subject: Re: [PATCH 5.15 000/731] 5.15.86-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hello!


On Wed, 28 Dec 2022 15:31:47 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.15.86 release.
> There are 731 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 30 Dec 2022 14:41:39 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.86-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

We're seeing the following problem, as with 6.1 and 6.0, with GCC-8 on allmodconfig on the following architectures: Arm64 and Arm; with GCC-12/allmodconfig on Arm64 and Arm.

| /builds/linux/drivers/mfd/qcom_rpm.c: In function 'qcom_rpm_remove':
| /builds/linux/drivers/mfd/qcom_rpm.c:680:19: error: unused variable 'rpm' [-Werror=unused-variable]
|   struct qcom_rpm *rpm = dev_get_drvdata(&pdev->dev);
|                    ^~~

Greetings!

Daniel Díaz
daniel.diaz@linaro.org
