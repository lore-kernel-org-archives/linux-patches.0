Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA7D04C64
	for <patches@lists.linux.dev>; Tue, 21 Feb 2023 15:00:58 +0000 (UTC)
Received: by mail-wr1-f51.google.com with SMTP id j2so4576260wrh.9
        for <patches@lists.linux.dev>; Tue, 21 Feb 2023 07:00:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bOHnaqumSzvCkeAdCi/JvKB/RmaESjli5/JpvR7XJaQ=;
        b=TJRIv4K9Y005WXgOmnzBfsBi7OZwRev7SsWnoqIIMZI33gso2oXRcs0dYcOwFnWHdH
         N0mY6OOkGZypHI36Fcn24ElYS1uvVSKQk2MiemFhUArVR/2TDjaY5FJtoC2QdZ2mjyl8
         MImTvpNTk4pqSFb5dV+VmXiBOQ58urpu6ufQ+O0piYHURbkLX/EPMPEhw4buag9z/6mM
         fTb33CbMcYcemO+6KsNc5uGyxHC59jorV4xcgJTtY4kIxpaldWM+QesELmndD4eYcHuU
         EMIdwUTC9q/l0xnBPPpD16ajIwZKb7U22twdSgzDkteJuif4LUbPoAqzoCkzzgGeeOFN
         jAbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bOHnaqumSzvCkeAdCi/JvKB/RmaESjli5/JpvR7XJaQ=;
        b=Rjn3VNN29I6+qaaZue/XRNNfZZ1Gfa+3rbZP43pUTKEyiIppculimpFJw4+iL/OHk7
         ALs4GP73gW9bww0uqI4AdpgFC0ld2YAqSA89cKn9QuVw8/oEbMowbLr4h1Snrzzh/EK1
         U+gIQ7OG8FZAyoJQl890KaNqFOwr/vfF6NautOnaPq+iJo+4g9FW+Y7h+KJUXXFuJ43G
         VFHIityyTKzZ0adh/tyOOtIlEDgw8ohQUzAh63DAMVbZmsKJZB3DDRkb9wDA0vULSeCZ
         sC6n6nJvo4sSzQ9NOBlLg4+m6KfmB/GezoYHYjfR/bH+o2iNqJd7+flUDpycovXBv5iw
         Zk+A==
X-Gm-Message-State: AO0yUKWfOjhqc16BWTlP4h3QO/vLkcQU+vgZPyQEBJqVyeuhfMe0fgpp
	+VJ9eLl308+7HQrh63o98rE=
X-Google-Smtp-Source: AK7set8fOwARuarbsrKvPo0bsg1/oz8pvXlTOLIEu/dsO0MVjoWl03a9N2+ebT9YQI6DQ59mNfAErg==
X-Received: by 2002:a05:6000:110d:b0:2c5:5d18:4311 with SMTP id z13-20020a056000110d00b002c55d184311mr4537306wrw.21.1676991656918;
        Tue, 21 Feb 2023 07:00:56 -0800 (PST)
Received: from debian ([63.135.72.41])
        by smtp.gmail.com with ESMTPSA id d18-20020a5d6452000000b002c54f4d0f71sm6098316wrw.38.2023.02.21.07.00.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Feb 2023 07:00:56 -0800 (PST)
Date: Tue, 21 Feb 2023 15:00:54 +0000
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 5.4 000/156] 5.4.232-rc1 review
Message-ID: <Y/TcpkAHqW4+n++/@debian>
References: <20230220133602.515342638@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230220133602.515342638@linuxfoundation.org>

Hi Greg,

On Mon, Feb 20, 2023 at 02:34:04PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.232 release.
> There are 156 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Feb 2023 13:35:35 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20230210):
mips: 65 configs -> no failure
arm: 106 configs -> no failure
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

[1]. https://openqa.qa.codethink.co.uk/tests/2905


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
