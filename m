Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1651364
	for <patches@lists.linux.dev>; Wed, 10 May 2023 08:51:43 +0000 (UTC)
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-30639daee76so4487323f8f.1
        for <patches@lists.linux.dev>; Wed, 10 May 2023 01:51:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683708702; x=1686300702;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lBAQkABlotf3PtL7UuZ32vX557RAQRNFDyqEv9QHB24=;
        b=o9Nnu6hBs5qkRk6u1eGyHO1dEJpEipCw75/my7SJ5m8jGmfUL4+qvdde0MhtOF+CFb
         0wgzxLrcqZDCH8FTrlYyYntgERHJfHr/N3E0JdnPjHwfhXrBX+VhNR0zWWqJkp05GTTc
         oTyvzGuFYMJ31EAqPA4+tqLrM4O036aq7P3PfdHVPzMf2D2glK51vzglUf4QAa/osb9X
         wJF1LSLPpUpyB2Z4eJwDoPnCxlhZsbKNA1+U3cgu1yAyXx2l+lUdAsC+HOUmvrC38itU
         dPet/tZxHwdn70+BOMxJHqSoetl5Vs/Acp41ZIeewHe2rSAf5pcSuU3e5VT7wO2vhofb
         3yOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683708702; x=1686300702;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lBAQkABlotf3PtL7UuZ32vX557RAQRNFDyqEv9QHB24=;
        b=Slvg6U24SifKWBV5ueCv8ON8D4EHUFUknqx0caleKOoXutwe/+cvhl9oekJbGXNSWz
         UFakZvWsUl7lGeP6p93kBnVNmkwE9qlgfZu+TcnUKiXMXBhtxL8xR6NE4DrOUqQuvYCn
         1WwO4XKhAJGqJ3iAc8ITF5KX0Ol2jQOGTY3i8LZhtHt0B3vj5WV+IKHC3uXZ+taAQtVy
         EmSabUVVoD6fmAql9jRrGxfI2QdVrvdMJOd5rMZItdMIjbxo8xdoMUvZFvOLCjK1wjE2
         byOiDGFKskgT5HPyDvkT8T/4y/klEhiwuCO8AlAQet8LTi8Nlt8V7dkgT69q4qBa4Tdt
         oD8Q==
X-Gm-Message-State: AC+VfDydJr0dFgQGweplOqDFDbN88xIoeUlQP6SFtCjZaeM7fUknJ+00
	rRxXtvgJ7sjuTR/3sa5QYDg=
X-Google-Smtp-Source: ACHHUZ4scNMNQ3ruGjJkawvo9rbTfPPl0+LvDkkmxs+BSuEdIohp6UmgT4Lkd1FhqsqAxT9yzCKBcg==
X-Received: by 2002:a05:6000:1362:b0:306:2a42:d23b with SMTP id q2-20020a056000136200b003062a42d23bmr12594532wrz.6.1683708702057;
        Wed, 10 May 2023 01:51:42 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id z18-20020a1c4c12000000b003f188f608b9sm22063694wmf.8.2023.05.10.01.51.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 May 2023 01:51:41 -0700 (PDT)
Date: Wed, 10 May 2023 09:51:40 +0100
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/370] 5.15.111-rc2 review
Message-ID: <ZFtbHMFe6ThVMfiO@debian>
References: <20230509030611.521807993@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230509030611.521807993@linuxfoundation.org>

Hi Greg,

On Tue, May 09, 2023 at 05:26:15AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.111 release.
> There are 370 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 11 May 2023 03:05:05 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20230501):
mips: 62 configs -> no failure
arm: 99 configs -> no failure
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

[1]. https://openqa.qa.codethink.co.uk/tests/3488
[2]. https://openqa.qa.codethink.co.uk/tests/3489

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
