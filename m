Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F86679F5
	for <patches@lists.linux.dev>; Fri,  9 Jun 2023 08:23:34 +0000 (UTC)
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-30adc51b65cso1439198f8f.0
        for <patches@lists.linux.dev>; Fri, 09 Jun 2023 01:23:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686299012; x=1688891012;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hESlPtiMkKprbYVZWF5WJWN2aGL5r7t0ApI5+mmRyB0=;
        b=BQyDsaqkDyBWYVZF/AVcBKzt2B1IFlTWk9a2CX+OmiEwmU7p4VG3sfQ/1wLolnbXmj
         CMBy9TA6yNyhQoL5ZP9U+b/Vk38QvvEnJZIUWuRs2l2qr5Wf8g5R1XEANbVzOGJffFcX
         7nNar+XWU+5xgPih6aVJIhvjvqbl8v/XJt6kZciF2F15JedwKSkmg7Ee2MmbQ+vobj6M
         DUdtxK/JBNoMXBfKBYveCiho7nQHzmep3uPpiGOScv4SRyxhBZwqcE8U1Qjf/cuNoPCQ
         V2fLHiclsWPc0dDcN3N6CqwRfFZiGOxAq/IthD/cR0VP67I4LgiVrV3njkl56AmrelNC
         bBOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686299012; x=1688891012;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hESlPtiMkKprbYVZWF5WJWN2aGL5r7t0ApI5+mmRyB0=;
        b=hqHE5nR1VsfX8hnOTWlPsm1iU0M9Y5e0O7x8nCJLkdSbD8/Pa3CrHIInOyqFRjPKww
         lhzK0bEyyzyxrRkGbTbR3awGPgJ3hJCuiiyDdraUn91fCUKDYaRllaxRN2Y02rulkshr
         3XeQc0OcPqeeOJC76rPWm805bCsok6ZGoZCTvPc14pnqNW3OYO73bjGIrrafSoi3sO0P
         7NQrP0z7TQpAwJFXBGBUP6YGgYk3O29VMI8DheCet9X78C1ZRM5/Oq+WxRrWj4XvRzsn
         9NmoyFzbctbe7nrzqoc9NlDqV6B9ycXeCSUJr4q7Yg1mUAKZrp8GeVWW6AaSQcxJQKld
         4q4A==
X-Gm-Message-State: AC+VfDwx+PzT0E/ruS2pQBjd3t9mqVTwl7pg052t2Ak4/vHZ6+WtdO4z
	UR+07HdxwCHhtSCIh9XFcVQ=
X-Google-Smtp-Source: ACHHUZ4CRzvbhWxHia89K6HWPpQFgfp0h45TKT5cng/bUltErsyatSXCh71jmSFAwQhCw0mLEr2rPA==
X-Received: by 2002:a05:6000:4cf:b0:30e:56d9:d7ad with SMTP id h15-20020a05600004cf00b0030e56d9d7admr476807wri.71.1686299012331;
        Fri, 09 Jun 2023 01:23:32 -0700 (PDT)
Received: from debian ([63.135.72.41])
        by smtp.gmail.com with ESMTPSA id m7-20020a056000008700b0030fa166d8a1sm1126605wrx.34.2023.06.09.01.23.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jun 2023 01:23:32 -0700 (PDT)
Date: Fri, 9 Jun 2023 09:23:30 +0100
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 5.10 000/120] 5.10.183-rc1 review
Message-ID: <ZILhgiQl0Twzknr5@debian>
References: <20230607200900.915613242@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230607200900.915613242@linuxfoundation.org>

Hi Greg,

On Wed, Jun 07, 2023 at 10:15:16PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.183 release.
> There are 120 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Build test (gcc version 11.3.1 20230511):
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

[1]. https://openqa.qa.codethink.co.uk/tests/3821
[2]. https://openqa.qa.codethink.co.uk/tests/3822


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
