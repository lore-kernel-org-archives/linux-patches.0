Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0323E7E
	for <patches@lists.linux.dev>; Tue, 20 Dec 2022 11:21:48 +0000 (UTC)
Received: by mail-wr1-f46.google.com with SMTP id o5so11424444wrm.1
        for <patches@lists.linux.dev>; Tue, 20 Dec 2022 03:21:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jXvNzSwe14GwembRofkcyx2c3hAwwdfCyz2pLlFfdRc=;
        b=MU4jSemS38tVlsQiYswpcuwJNcGecNw7YNZQxU8fBDHclLKMLGBZv667yDqqTzvXDn
         cSB4B+NZr9XlM/dxYOvp+OCAL3bxmO6MlnMnDYy/5cRBQsmf+l/X1NnIXiWndgeyVzXf
         c2V553sAMdGCyfG3h0L+XjZUqGqwlkOzR+4mZsu6DkRTkWctpzpXG6rOSfz9tflNOWCT
         Q/XcWVW0D1VC/LfYIEL1GT34OXGLYGtCImbnJ6ugfI02ZoUOJUjDTeoGpuFDKj6e8vCg
         kNzQPVsls7dWzf7AvL9EpQiEQTqtgJG/qup95G9XWx3pveeb8VLCEtLn/hWoWnyygTYw
         V/6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jXvNzSwe14GwembRofkcyx2c3hAwwdfCyz2pLlFfdRc=;
        b=f0ySYMpUE2QelN0Hbmi1l4GtiKlVcNpdtZVz7jJ6BO37kdY/AZVQHEfePhLoZIQTjq
         gE+QGelqvjg2bGy3HkpF1lBQYamiZZYi7pDdWjOn0CLwyKR9AUs5HJchuvI3MpWMnR4V
         rzJkOD2VQtr6Nfo5ZS+gdXTN4ieA8DJwUwyn3ZA/6Jfk7m80XTWryePv4GCn+swaVYeK
         cY8Gqc68Y24UEUu8SyNz0L/6T2CiHa9h2ZFLff4Ts3dl/iW5UOqeOwQSPyj6racJLN0k
         vdULDHe2znAJrFfC8yrtxzLdCJ5aXc6UYn6syvgDy8s/c0We7z38uVZecEUHw+Dmsdv3
         WTCg==
X-Gm-Message-State: AFqh2kpCF7UN4+Eq06D9qoZlhI0YV7aD74RIx3fOoxld6lUu3OS+R3py
	el6uiI9567gmYJxwJZ2u0Do=
X-Google-Smtp-Source: AMrXdXtpanZSi3KG2wNuIs05bD0kXsEQp3YLAjyOipKywJY3kNlVyZYRAbIlo5AWHPqXnQRYCa5Rlw==
X-Received: by 2002:a5d:4041:0:b0:242:8177:62ad with SMTP id w1-20020a5d4041000000b00242817762admr1250599wrp.0.1671535307159;
        Tue, 20 Dec 2022 03:21:47 -0800 (PST)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id bh10-20020a05600005ca00b00242442c8ebdsm12597012wrb.111.2022.12.20.03.21.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Dec 2022 03:21:46 -0800 (PST)
Date: Tue, 20 Dec 2022 11:21:45 +0000
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 6.0 00/28] 6.0.15-rc1 review
Message-ID: <Y6GayS3t0QReca3q@debian>
References: <20221219182944.179389009@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221219182944.179389009@linuxfoundation.org>

Hi Greg,

On Mon, Dec 19, 2022 at 08:22:47PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.15 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Dec 2022 18:29:31 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20221127):
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

[1]. https://openqa.qa.codethink.co.uk/tests/2421
[2]. https://openqa.qa.codethink.co.uk/tests/2426
[3]. https://openqa.qa.codethink.co.uk/tests/2429

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
