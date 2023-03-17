Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4769020F8
	for <patches@lists.linux.dev>; Fri, 17 Mar 2023 10:11:27 +0000 (UTC)
Received: by mail-wr1-f44.google.com with SMTP id r29so3898628wra.13
        for <patches@lists.linux.dev>; Fri, 17 Mar 2023 03:11:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679047885;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ywd0zlvs+Ok8+NCtUrmMkjPrLX0hyvij+lHU7CL6uzw=;
        b=PxKF0LKLaz7mpdWCzu7DSi1rKQ2iIRH4zjjR5EheliZ3I4AOf0r5uvbDl0iVjRAYnZ
         w58gHBG8ZuqkG1PegJ27Fn2hJBs6xY8bIW++zH+BlutkQjIwpI8MZhJaQ7sYjWlU0Hmi
         sdW/ox6tDQCiL1l2GPwzZQCl68+Y8ryiZdNnhYvwZsbzf1KTcKeIpM9/CRUJ0VOqE2ff
         sxPvfDyLTa0mE9aZqejCYbrWhGfH1v0inQWD+4ekoEQMUuNd+7da2N7Z6Ku6ZAXysvHP
         EQaUOIp4Wtd18MMoBwfAhxySzigegopwlj5KPMvs1oEM6gySBV1oNO8BkR/AcpUVF5r0
         QPDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679047885;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ywd0zlvs+Ok8+NCtUrmMkjPrLX0hyvij+lHU7CL6uzw=;
        b=02jPU52c7+fJvX0oTBOUCV+6GrzCAYQpwwkb4ctrqSu6nVTcQdXK/rIzpqDY3jB9xW
         RY9G2AzMtEGdh2bHlWtiFVOYhuPsh7WCMrPLYZx2Oq3fVh9JsT2iA4zGc5WpDSqRBr99
         CP/+v9t6XO8f5eHuqgN8ifrcmKhL57gj5M3f0dlpjU1MVtSbQUCXcgq3kqA7LwxweutC
         eUq03z0BGU3GFk0XCVKCqm2bm0VNRdz17cpvV5sw5KQAOjkxKYEyr+wjQ8VzZPUiuxt2
         cpcA4qL9QzJN8vGqq207BQsgE73JGWR9LaWGej3hBZDurDk16xGlcA4xDUnp2gjM2c05
         QABA==
X-Gm-Message-State: AO0yUKU98EIjNBn6s6qFiBzJYXpQGDW6+FjBkk3+aPGuADW7UCTh5rbv
	2pdE/Ur+YsHIts0tpLEcGxc=
X-Google-Smtp-Source: AK7set/iFRs8ppYToM4Wd+e0OMERRL0dSQg3ICgKebjeYyFNLl6Kk+ipUdF/tDN8+Ay8lGhnFl59Mg==
X-Received: by 2002:adf:e34e:0:b0:2ce:a251:6956 with SMTP id n14-20020adfe34e000000b002cea2516956mr6186771wrj.66.1679047885321;
        Fri, 17 Mar 2023 03:11:25 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id b7-20020a5d4b87000000b002cfe0ab1246sm1593401wrt.20.2023.03.17.03.11.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 03:11:25 -0700 (PDT)
Date: Fri, 17 Mar 2023 10:11:22 +0000
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 6.2 000/137] 6.2.7-rc2 review
Message-ID: <ZBQ8yqfk3FgF06Fe@debian>
References: <20230316083443.733397152@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230316083443.733397152@linuxfoundation.org>

Hi Greg,

On Thu, Mar 16, 2023 at 09:50:31AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.7 release.
> There are 137 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 Mar 2023 08:33:04 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20230311):
mips: 52 configs -> no failure
arm: 100 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
csky allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]
mips: Booted on ci20 board. No regression. [3]

[1]. https://openqa.qa.codethink.co.uk/tests/3136
[2]. https://openqa.qa.codethink.co.uk/tests/3147
[3]. https://openqa.qa.codethink.co.uk/tests/3148

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
