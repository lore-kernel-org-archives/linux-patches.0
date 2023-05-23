Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B38EEA1
	for <patches@lists.linux.dev>; Tue, 23 May 2023 00:22:53 +0000 (UTC)
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-76c56d0e265so38721839f.0
        for <patches@lists.linux.dev>; Mon, 22 May 2023 17:22:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1684801372; x=1687393372;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EDrPFB7cCQge/xsQrtC99WHAQKaVmSUwNIX8SNPBsTY=;
        b=esGuiS1F6Qx8FaANbYrjs5R7eDPydPhGIWU3FV8BvrecKb+wVBaiw4pC+BdOUupp6J
         eO3WFrESYiuXDCEB0i2b3j1IK5DocXlNzqcoS9yK7KuvLU3XfCC6R8xRVGKXVQGPY4co
         OuT4xvwv3+eVmaLFd/z5Lf8bIKYLA16iNwEbc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684801372; x=1687393372;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EDrPFB7cCQge/xsQrtC99WHAQKaVmSUwNIX8SNPBsTY=;
        b=BzjoGnvnoIqkfMyH02aZ+z/6DaoGLnrzpIVLELE7fZEwhwi6EHz98h3RjJeCp3D1mO
         vEDhmy0xF1TEOfGDV4lNGUDiwAl5X7YYR3ADy3UKERrxxBv8pcJ+0z2OCAQisBfvnk4i
         NU0SQRYeDdzyi1RuwOM9EQQGh9Mt7gB6sW352RWHAALMFisGdoLB0GmQSTdVR0asqTmg
         tg0HrL1btbU3S9YLVGoKu78kW9GXw/PjtMTfNTMDDL4gDXH3rko2M2M2tnTW7VxAkFhK
         cUuPFoTsS4KrdjoTA2hKprbJm8Jf8ig7VxAJ9ZNzZESi4AKeALBISP2kEXD6T88Z7qWL
         Uvug==
X-Gm-Message-State: AC+VfDycKko3OqwrXeCP9ZTLq6zwJBVtET6kheMLGWyefCCR0kE7FJdB
	c6FrnF2TtP66vYQjphH2A6NCOA==
X-Google-Smtp-Source: ACHHUZ4v+BfxyYUBkyFFh4IJ1Vqv2gi6rw9PcXY16lQ0rZibbfAq6y+X/Da1ZMfAh5GVwE3XfJBSXQ==
X-Received: by 2002:a05:6e02:66b:b0:338:1c2a:fb62 with SMTP id l11-20020a056e02066b00b003381c2afb62mr5891766ilt.3.1684801372152;
        Mon, 22 May 2023 17:22:52 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id q19-20020a022453000000b00418b1c5cd64sm2070908jae.93.2023.05.22.17.22.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 May 2023 17:22:51 -0700 (PDT)
Message-ID: <c7eee355-a430-1d05-d06c-431a97bc9297@linuxfoundation.org>
Date: Mon, 22 May 2023 18:22:50 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 5.15 000/203] 5.15.113-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230522190354.935300867@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230522190354.935300867@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/22/23 13:07, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.113 release.
> There are 203 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 24 May 2023 19:03:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.113-rc1.gz
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
