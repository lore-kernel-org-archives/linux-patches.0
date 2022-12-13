Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A11332F2F
	for <patches@lists.linux.dev>; Tue, 13 Dec 2022 12:02:53 +0000 (UTC)
Received: by mail-wm1-f46.google.com with SMTP id o15so8094435wmr.4
        for <patches@lists.linux.dev>; Tue, 13 Dec 2022 04:02:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6mFtsYasizY4EnEvFPGcZwDwtORvegty1UNGXXDdlcA=;
        b=aNB6GU0HK7lNhwrGNZxozn2hA5HH8ZpwCJiQD3sHUlLl7UQ/NlskbUp+6gvfzu+Zcq
         2fUK3Fm18A7zlZH20l5dprEveToDg4Zz6Wx2gfB/fmt1tLJ4kc0awDLhSc6ggZrnmSEt
         9ftM0VvqRI4CQAqJDanPcOqMEcJdVzItBYU0PQQOsXOK86eTEjzT2BZF8Ow5rOGjor5L
         4po2iPo7jqEkpv67a/AzTYHeV1HLSCD6AQ38gw+xNAan7sCEGegGDSzJfBBYlQQvo4wO
         UA5pFYR56WzG0zFCrYXNSKUqhayeAzVfEycucLHmvLkolkdLqKeeRF31+BfFsV6mQxiN
         hwgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6mFtsYasizY4EnEvFPGcZwDwtORvegty1UNGXXDdlcA=;
        b=NgnSj3tugVVTY5jpxEzg39VENB82/Vyk3DdmfjzmsFeJi8jAG7UkHwovZCj4mD8j+x
         Nibb0k0l8AcSINx+M2kiLyMhUhodd0WgR71gQft+wvAu4TzW7sPmsbc2JGmnFnTD9pi1
         nBxCimTYZPeH7S6SWJ0JtExsxGUrFHRkTQ65XI8AykP/smJSicGh9h0SyeZtG7tDDXUJ
         S9WNU3+pTuaw5ReIRJn37CNsrpZ5FClR7zxqrSSzUcyCi6MsGdhMFy7qMuzcmTtWJRFX
         iIyDTzztAmFRonAmQwbgvuVxfqX5ShPSCF+kB+DWPbU5LVZJlL5eV0MmCZUPEz1h8y11
         vXsA==
X-Gm-Message-State: ANoB5pl3nBM3SMnMLF0VxNYAHpkEQa3ZwCFqF/PKwztnXerqc9OWaNMA
	BSjxG6Ht6bitzimw0+fDWGI=
X-Google-Smtp-Source: AA0mqf57ul3/Zzp1LTiqvkWkaYPsQs/LREr1jt08JLo6fAl7aakenGYUskTQCdJ5PQwGSwDwFe+qJA==
X-Received: by 2002:a05:600c:4448:b0:3d2:813:138a with SMTP id v8-20020a05600c444800b003d20813138amr12934792wmn.35.1670932971854;
        Tue, 13 Dec 2022 04:02:51 -0800 (PST)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id i2-20020a1c5402000000b003c6c182bef9sm15335531wmb.36.2022.12.13.04.02.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 04:02:51 -0800 (PST)
Date: Tue, 13 Dec 2022 12:02:49 +0000
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 5.4 00/67] 5.4.227-rc1 review
Message-ID: <Y5hp6RnTARlHT9YD@debian>
References: <20221212130917.599345531@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221212130917.599345531@linuxfoundation.org>

Hi Greg,

On Mon, Dec 12, 2022 at 02:16:35PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.227 release.
> There are 67 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Dec 2022 13:08:57 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20221127):
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

[1]. https://openqa.qa.codethink.co.uk/tests/2338


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
