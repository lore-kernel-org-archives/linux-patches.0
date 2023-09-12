Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0481A15AE
	for <patches@lists.linux.dev>; Tue, 12 Sep 2023 08:58:38 +0000 (UTC)
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-31f6ddb3047so5184450f8f.1
        for <patches@lists.linux.dev>; Tue, 12 Sep 2023 01:58:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694509117; x=1695113917; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OqgrnIE/Nleiv5H2zORysEJ88F6QQ39FuzEgmdDH2Mw=;
        b=I8CsdURkrD4dxB/CAhnJ7EC0H4SfeCaNkGu/qjUxBI3s0kthZzl0gun7yYUuS+IPqh
         PW8FXqZYh3rmhM/yqHqInqOEkDN1g09Cp0MW0bE+Ky9n1T65WCvBXVS4fEXf0iduC9AO
         J89ZlUDgZilwO39hK5Do+Ppo8k1V5bVpip8IQpUn/QtMdbib6slgM4vAB3yHUH2lmdbK
         D8X2eEBAWrMEy3qu0FQV001qCuE/XjnvXHfXHic1b8pzGY2rKdp1GVLWI/8I7XipAYTe
         sbiUWfzsZWHIuStpRPJEuHNt7Pn5wHwsF8+3KmgIe4LKvPaeIV5uP6uyMJdJh2RKrJBh
         oIng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694509117; x=1695113917;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OqgrnIE/Nleiv5H2zORysEJ88F6QQ39FuzEgmdDH2Mw=;
        b=fuu8ppbYQnrQFzTkxCSbmaoT3x+vaEsSvmrJnIiFPU8WTK1WIkhZrTaIHU3fxz8VFs
         bOwzyRl8E/8adb1JkOpOsylrUKMn6pL5yQsE8pxZnFHoqkzdfdLErUGDQHZHARvWGTA6
         yXY2cVPzyfKyd3jghI6DeTKQ65BTCDyDBkRjiydYYpxF3Fa66rCnQhbbKcHWBDKE7Cha
         TqBPMG0HKOyW1XWtZI7dPfvSk5NduWIQ/N0A8qtG4WnUIHGiJkxhB1yhOkeLUXPc9+WT
         pqG+teg3F+oTZkHe8ZCAlROix28WQnkA0ASSD/YSlsCVkFf+ObpMoSfcKGm7+QoDj5y6
         B5SQ==
X-Gm-Message-State: AOJu0YwfatGooih6mC3iJ43cIZJ27Hja1KWp+t/XOueeeiqQ3Z74xZCI
	yzxmipWSr+xu0GAXV3Q4Z/I=
X-Google-Smtp-Source: AGHT+IG1E3JmKEJWylxvVmRipV3cHZc6eCG3bX4xM89DOWLXXJcx0EYwaTGkXBUJ5VWqopy3YCxO/g==
X-Received: by 2002:a5d:6510:0:b0:317:ec04:ee0c with SMTP id x16-20020a5d6510000000b00317ec04ee0cmr10090043wru.47.1694509116834;
        Tue, 12 Sep 2023 01:58:36 -0700 (PDT)
Received: from debian ([63.135.72.41])
        by smtp.gmail.com with ESMTPSA id a12-20020a5d456c000000b00317afc7949csm12315234wrc.50.2023.09.12.01.58.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Sep 2023 01:58:36 -0700 (PDT)
Date: Tue, 12 Sep 2023 09:58:34 +0100
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.4 000/737] 6.4.16-rc1 review
Message-ID: <ZQAoOpFsahI9Mt6H@debian>
References: <20230911134650.286315610@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>

Hi Greg,

On Mon, Sep 11, 2023 at 03:37:39PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.4.16 release.
> There are 737 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Build test (gcc version 13.2.1 20230827):
mips: 52 configs -> no failure
arm: 70 configs -> no failure
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

[1]. https://openqa.qa.codethink.co.uk/tests/5002
[2]. https://openqa.qa.codethink.co.uk/tests/5004
[3]. https://openqa.qa.codethink.co.uk/tests/5003

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
