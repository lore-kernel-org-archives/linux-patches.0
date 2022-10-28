Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8992B15A0
	for <patches@lists.linux.dev>; Fri, 28 Oct 2022 10:35:09 +0000 (UTC)
Received: by mail-wm1-f43.google.com with SMTP id l16-20020a05600c4f1000b003c6c0d2a445so3522722wmq.4
        for <patches@lists.linux.dev>; Fri, 28 Oct 2022 03:35:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JPxeqoUuZSodtcBLnZWOHUeiam6jMOP2XAoWax7aZik=;
        b=ETdOtPn74s5ttnKtOqu1PJewRiriRRLZAkjS2Biifrge7J5HJuLyn08/QarB01QMr0
         4vkhDo09BnWezPZWkFIUVk6lKTe69s94L/0FHDjBba2h1YZg0LqPJ9JIOxcOKKb2VuGb
         ZQUty2v3ZE1kHF12Sy76w5QNfQESTjtXLsBSZBcyDpV9JZBx7FaE0Gn8uEIrgTaPwq8F
         n029p2zSMawGIunG0RBAW0lbwEfvVzRxo79VmMG/NkV1YNigOg/KU6FT1ZPfvmtFsGIs
         ya3vV0cPHvBNEnxNkGHPRO5Co9AC1tjY2ds3MVnHhgPtKHNAHbCHTiia976t042VDsHR
         l3Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JPxeqoUuZSodtcBLnZWOHUeiam6jMOP2XAoWax7aZik=;
        b=PXwhmIvzqL3gj5ZF1CeJl5Sau1v99pMA2Obpu+fncGokQHwQumMj9jmFpispRcdjXY
         ZRRlPh+JVOdBGzG/rTfbRdZvA/S2QSLhSS+doPb39Ln1tp+lqP1iTZ04O7nfcYNBSQgI
         7HYO3R7r6+MaeXBKGQAgrETl4nhU7Htw9wPE2vppRQ0RJEX4kDDLUo4cypACUofuV0fc
         isy9hg4tyiWCPtCFX8rMiRtsEVaXWY/DYMt/21D9HuNDNoSmdc0BTOC3AiSYNJRXYgch
         R8fwU+oOjRjszmNtGidLigUPG3WhWp37Mlz6/x+/kAUk3JfC9DyDvNi7yrtA3iqZhM7c
         eMgA==
X-Gm-Message-State: ACrzQf3JeR+DVcoBZgS14mZLL20lxRLg3z4+GKIKbg+s3VNSFmjzfowE
	NHm8aIFkzXMKvM1wRvCQpIM=
X-Google-Smtp-Source: AMsMyM6QgGQClPrA7zBYcsYzaOrkox2XoKdDmhRUGna1sQdflW2l1FzoRNXPTHZxypLq3F0I3QqbHQ==
X-Received: by 2002:a1c:730e:0:b0:3b4:b0c0:d616 with SMTP id d14-20020a1c730e000000b003b4b0c0d616mr9020044wmb.72.1666953307633;
        Fri, 28 Oct 2022 03:35:07 -0700 (PDT)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id c12-20020a05600c0a4c00b003c83465ccbfsm7213842wmq.35.2022.10.28.03.35.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 03:35:07 -0700 (PDT)
Date: Fri, 28 Oct 2022 11:35:05 +0100
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net
Subject: Re: [PATCH 6.0 00/94] 6.0.6-rc1 review
Message-ID: <Y1uwWUjlghS4xUJs@debian>
References: <20221027165057.208202132@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221027165057.208202132@linuxfoundation.org>

Hi Greg,

On Thu, Oct 27, 2022 at 06:54:02PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.6 release.
> There are 94 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 Oct 2022 16:50:35 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20221016):
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

[1]. https://openqa.qa.codethink.co.uk/tests/2049
[2]. https://openqa.qa.codethink.co.uk/tests/2056

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
