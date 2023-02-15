Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 411F03C1E
	for <patches@lists.linux.dev>; Wed, 15 Feb 2023 10:01:34 +0000 (UTC)
Received: by mail-wr1-f41.google.com with SMTP id m10so9555871wrn.4
        for <patches@lists.linux.dev>; Wed, 15 Feb 2023 02:01:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0O5OE1pYPf4Bdxg8Thv2IJmSFslR0r4iXq6hhQFPsQo=;
        b=KzdJLQ9yPDlXF96+31EwfJ15d7GWeppPU2bcWbiye8OU1ANGa/s5JxHn+oYTd3j/Yd
         9gmPURkg0vkYa83IjBoBKQBZnPWguVscDRUj1vOpqktIzY78UPqTTi+pZnPCR85uxjoK
         Bh9rlMg/lzyMCy41s/85kS3a37kFDH6eaE5xvOCwMH+CO0gA/fy0ZptoeUi7LyjIaldZ
         fMERgJYu/7xMUCVwQo0cwDD6qK9atVSdWvruNj7rlW2w99oPt8KGZjbyng5Hpkq2fkpO
         BX3Ldx71gk1axXGm36btQcFoDQGuWhcx6yu0OA7xNUZbJ9XzS7y8ysZSAWgXAaD0P2zg
         94lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0O5OE1pYPf4Bdxg8Thv2IJmSFslR0r4iXq6hhQFPsQo=;
        b=rGwkZP6bYNqyCEZPZBY0OWjTigGNauovr6OVTP9ZN2C10MfLNTL4rfpu9yBRfBHd1h
         u/MySQJ0jU8xlPuykGG2pgtE3+o/p4ZA6DhJl6hJ2pWK5/oy7zy+AUqV6bV3xe2985Yl
         8PsVCtwR199MZecmLuBo44GaPrOuS3yVnnUSk90jg5+rYekPcqKOC+wFynvB/zV1zexS
         Cx2qOmBePwCr+pX+blu/aSxa3UpXtvw4NxffYyjAiBeRhQj+Sajt9NFTe8j69oJQUmYx
         MqIHUsAITBVUmCT1msFv4lGkwz8B7KpSNrPCQDw4Yws7qCJwDW/oHs+95msDwZUOyM2P
         n75A==
X-Gm-Message-State: AO0yUKVI5EAzL2n+Cmj8Zq772RS7q0TCMM9EOyrlEcFZ9+lQj7QhjSy8
	J3YXs3+n/BBQFKr3fJK6A/k=
X-Google-Smtp-Source: AK7set/syKP1KgtfZs0bsclPc0Y/kqWZICD77fWgN6l+GOibI6M9i43aofOjR0wF6puzx4glJuFFUw==
X-Received: by 2002:adf:fc10:0:b0:2c5:465d:c1ab with SMTP id i16-20020adffc10000000b002c5465dc1abmr971373wrr.51.1676455292352;
        Wed, 15 Feb 2023 02:01:32 -0800 (PST)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id h12-20020adff4cc000000b002be505ab59asm15344981wrp.97.2023.02.15.02.01.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 02:01:32 -0800 (PST)
Date: Wed, 15 Feb 2023 10:01:30 +0000
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 5.10 000/134] 5.10.168-rc2 review
Message-ID: <Y+ytehE6Kv5moEou@debian>
References: <20230214172549.450713187@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230214172549.450713187@linuxfoundation.org>

Hi Greg,

On Tue, Feb 14, 2023 at 06:41:06PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.168 release.
> There are 134 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 16 Feb 2023 17:25:19 +0000.
> Anything received after that time might be too late.

My builds have tested f90240a238a9 v5.10.168-rc3 but I am not seeing
any mail for that, bit confused now.

The result is for v5.10.168-rc3.

Build test (gcc version 11.3.1 20230210):
mips: 63 configs -> no failure
arm: 104 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/2868
[2]. https://openqa.qa.codethink.co.uk/tests/2869


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
