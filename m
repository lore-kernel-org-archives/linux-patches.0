Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 668CA15AE
	for <patches@lists.linux.dev>; Tue, 12 Sep 2023 09:00:56 +0000 (UTC)
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-401b5516104so56684535e9.2
        for <patches@lists.linux.dev>; Tue, 12 Sep 2023 02:00:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694509254; x=1695114054; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8rV3D73n/4g0Ho3wzqMSJx0WXLNoTiOvH9lCB8cr9hc=;
        b=DKtUFjfXAVg1+I4NWBuWI6MtUSRv4fq24CgrsG1ozAQ7AGXEdCyLHxsGFKNMQ36DNJ
         tzVe//MXxFxA65rTCpMjWrDg2b63bsl93BK5qi7WiwE3QAn5phUxFj7Mq4N4EXFBcWVr
         m/jlIaO9CXEEdw2UNoMp8wczkZq+VMgiBoZew9685IHz8N9UFdnx9KIp3yJOHHNUqPad
         dqE8keBV+WM+La0nkGf4yCGCMwCAtGOpuxVe7HmoyrnzRGmi0PXuaJsPYQ5XFudsB5if
         XJ354JcVof/fx8r6vw9YYtoNqUlHtMbJUXgx9vn7KqIkWt8zcvhb7wpe4WWaDwe/9aLj
         zoLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694509254; x=1695114054;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8rV3D73n/4g0Ho3wzqMSJx0WXLNoTiOvH9lCB8cr9hc=;
        b=N2PlUjYzk9JoPb7SdfOgnK7Nq5Y+BoeKG75OJi0vCaOkxUUazcJcBGGbfJJnjVMvlw
         qDg76U6ISpQY7CQ9NLaCOzrIShxWPlB6eJcK3a9884uIlRvzYIi7qWVj+vMkpPFLDDkM
         92vdWQQBrcstjihGII3IP911HbY8GggjY9uShKgZnqQhuz1ttJaExrSn8dQR+uIslyAd
         zmgW8ETrbw8AFwNKoHf9qRE2s9yISpldEblkXJEePJxywfs3OXlUYVT5Y6dfm1RpayfB
         wGUSoYojO1JyEQcSy6J4mpxIMvY1WylQLjlN3ZBxQA6TXWFy739jaFPufb/VuMFAphFx
         +W0g==
X-Gm-Message-State: AOJu0YxYnsPufZcAPnkk0l1OQgHbp0SYNaYrvAY3Xlh07lAVaQdN3HGp
	HM5OAZgIrdPgCV83ShVQseA=
X-Google-Smtp-Source: AGHT+IEvLajAPVV972MBmGyk86DNVPmr1wsQgB8aX54G9X0nBNspdlg6SDntMJpDeko1hwS0KZg0fA==
X-Received: by 2002:a5d:6812:0:b0:31a:d90d:8d9f with SMTP id w18-20020a5d6812000000b0031ad90d8d9fmr10559533wru.25.1694509254299;
        Tue, 12 Sep 2023 02:00:54 -0700 (PDT)
Received: from debian ([63.135.72.41])
        by smtp.gmail.com with ESMTPSA id g10-20020a5d540a000000b003176c6e87b1sm12186392wrv.81.2023.09.12.02.00.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Sep 2023 02:00:54 -0700 (PDT)
Date: Tue, 12 Sep 2023 10:00:52 +0100
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.1 000/600] 6.1.53-rc1 review
Message-ID: <ZQAoxIS7sohiB1Vk@debian>
References: <20230911134633.619970489@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>

Hi Greg,

On Mon, Sep 11, 2023 at 03:40:33PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.53 release.
> There are 600 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Build test (gcc version 13.2.1 20230827):
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

[1]. https://openqa.qa.codethink.co.uk/tests/4999
[2]. https://openqa.qa.codethink.co.uk/tests/5001
[3]. https://openqa.qa.codethink.co.uk/tests/5000

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
