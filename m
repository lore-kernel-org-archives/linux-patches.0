Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A41732C726
	for <patches@lists.linux.dev>; Tue, 16 May 2023 09:10:45 +0000 (UTC)
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-30771c68a9eso13041789f8f.2
        for <patches@lists.linux.dev>; Tue, 16 May 2023 02:10:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684228244; x=1686820244;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=E3WrC4UijnYG96Kov01kzkQuuInDDpJVntlVXwo/6hA=;
        b=Ostie82+eea/bStS2f/B7xC02Hn0Bq8os2kFsYXwx7eYnHni65/Wef6GcUWdkWcL2K
         uoURmp1GjKLISQ8j5Q+EigxL1KyZeq5m3bhOOMjQIuU5oF0nCOWuuCl+EgoSzNpQfyOD
         6KyaBn78Mw0hKWcGtJmuL8ID0KdoS8EbYfZjM5/aeOwVmfWr/oe9xpFlsa5zqu1ubvyG
         d0vIx1MwAuvejni2h1IPCwDmJ5q7AxLM7Ap4RhJRzSQrffxgebg4Ojik6HmNREk6U1fV
         4PrzbJaH/SYV2acQ3EMP93ToPtXmmWXCEd1OPt2LemzNErM+21/iWc2u8BwL0kn4vBGy
         4K2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684228244; x=1686820244;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E3WrC4UijnYG96Kov01kzkQuuInDDpJVntlVXwo/6hA=;
        b=LWEHbGYlAsJYS+827phLj2HIDd2LWD4PmQRGj/ETGV1cc7yJIhptRuWldPOGETjxZv
         HhFMQvxvLIFx+y9ktBJ6EqmmGIKSNMmOdqCQTIMKcmgdkjI/ZiPfKw0YmKKcVrabMdIs
         4sT5OJZxGgFLT61eyxy66sH9l8EpWA2WdDnXSZ4tXVz0dvhttY8IT8xAaO6JI/+u4wSE
         W4822BgfI/ZuDy7mbDnvajNtCinvWq0UwOUTkd36D7sMReJyW2grNQKy4MSOl++GFE9i
         6K5ALoN8lDNJXnXSUh96EpQG4bie7Z4mR7cFwcFce1palPCtZ/NXooaeuglQfs7PGztQ
         0A6A==
X-Gm-Message-State: AC+VfDzXRxCEDV+amcMMx7LQh7sV4mA8kjsPHLZhkhAUP9/j/JGGFDJE
	JKpGHIvwvb7IHHWIvsiHAN8=
X-Google-Smtp-Source: ACHHUZ7kjXJzpiS4OttX1ykp7R4nHgdaGWWYljgv/ZxeWcC6TV3lT1cWq7MSPB1cxzUxU6uEXeqySw==
X-Received: by 2002:adf:f946:0:b0:306:32fa:6750 with SMTP id q6-20020adff946000000b0030632fa6750mr23213600wrr.33.1684228243591;
        Tue, 16 May 2023 02:10:43 -0700 (PDT)
Received: from debian ([63.135.72.41])
        by smtp.gmail.com with ESMTPSA id i18-20020a5d5592000000b00307acec258esm1927828wrv.3.2023.05.16.02.10.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 02:10:43 -0700 (PDT)
Date: Tue, 16 May 2023 10:10:41 +0100
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 4.19 000/191] 4.19.283-rc1 review
Message-ID: <ZGNIkVKpO2/uddsq@debian>
References: <20230515161707.203549282@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230515161707.203549282@linuxfoundation.org>

Hi Greg,

On Mon, May 15, 2023 at 06:23:57PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.283 release.
> There are 191 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Build test (gcc version 11.3.1 20230511):
mips: 63 configs -> no  failure
arm: 115 configs -> no failure
arm64: 2 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/3527


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
