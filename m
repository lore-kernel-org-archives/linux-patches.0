Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B9E724F35
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 18:42:43 +0000 (UTC)
Received: by mail-qk1-f174.google.com with SMTP id z30so12345210qkz.13
        for <patches@lists.linux.dev>; Wed, 02 Nov 2022 11:42:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UnB/iiYCoj9JxhGUlWNmGFpgfzGIDKnr6BfjYADidfM=;
        b=mgZDbBqMlbMh24yUr68+4lerWRJfeVoKfI2iv82gSDPWwx/LVdWnJStgX/Ka/iotY2
         utIv4j7In63e5ngwgX3ylMqRBSG+ZlS2uXVPIOypL6hIdur3q9FL/OihkE+j6moRJWyp
         h3mLySPrO/cH24MG6TlkusGDAER5WGvxtRfeBHKum718fAxuwjJSx5lUPMbCWhV1yl/R
         sXf+BGqUaR7VNqRYG2vfmkcdEXg2fSDKOWx3l+BLeRhmJVTQqXsAY8M0uy2i3x0O0AsG
         /bnqaJsxFW2IluthjPeY+0Uc0EfJwLkKPRg4lC/evCE73VNe0Lmkl/JUkd0C4Y+PskGz
         CXaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UnB/iiYCoj9JxhGUlWNmGFpgfzGIDKnr6BfjYADidfM=;
        b=GdXs0giaBlbW7e2SZ3krGa7U5Tl+zQGOVgpGpMlfV0xSxiid/2j42wqDmDBK33Ra/q
         /CwLaOij/CKSBDYw9EGylIVp2E8V/cyoJLgwIDSR1p6ygI3Yi6umRzY+dIpwb67rXzv5
         ut+GDA6c+eL5RyeZjoRLiEdwAEjp9G3cw7hEm1tf52VLbJd3D8OD7MYjL0tKxCOmcf2+
         M0PIvSnd6XpvAVyUa3Fme6pP4IOjFf8s1odcsb59sc4uCXkmwSSgJ4hSnbshRKW00+lR
         xmozyqAmJcI9yO9TurAac2QjFAZenquzf3fp51stIUxS87azVi3cWw0qPmmYUYkfmrza
         S3eQ==
X-Gm-Message-State: ACrzQf1kYvBPVl85K4XCOdfbx7E2x0dxnTGSFHh3IAJQcmLph/sQgQPC
	eeJaAAtlgod3hNmojx0UG8Y=
X-Google-Smtp-Source: AMsMyM4yYZQoPSoricm6jRD97DoXPAV8DxOXgAY0RZ6i0gSA3F4L+U9CDZ/vSWBUORa0fdRnenQX6Q==
X-Received: by 2002:a37:5e41:0:b0:6ce:79e2:68af with SMTP id s62-20020a375e41000000b006ce79e268afmr18698594qkb.239.1667414562785;
        Wed, 02 Nov 2022 11:42:42 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id w10-20020a05620a444a00b006cfc01b4461sm9189729qkp.118.2022.11.02.11.42.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Nov 2022 11:42:42 -0700 (PDT)
Message-ID: <2bf50933-802b-8340-4146-cc6c409d372c@gmail.com>
Date: Wed, 2 Nov 2022 11:42:36 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 6.0 000/240] 6.0.7-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net
References: <20221102022111.398283374@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/1/22 19:29, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.7 release.
> There are 240 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 04 Nov 2022 02:20:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
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

