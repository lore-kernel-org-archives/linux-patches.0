Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E074171B5
	for <patches@lists.linux.dev>; Tue, 24 Oct 2023 08:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BWvCYjut"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4079ed65471so34724185e9.1
        for <patches@lists.linux.dev>; Tue, 24 Oct 2023 01:51:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698137481; x=1698742281; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AeBNyWOSZJ4kGFSxFtfrCpSWWHWhFOJFGqG73cu2x9o=;
        b=BWvCYjut/sesICoitHoP4XNCIAG9asFYKtCUxSbPLMFIWyMDRqBb2vKM1G2wk915/P
         oSNRWWOuWELamZq4dy0COThGsTrkPPp6blAPyakP8KLpj8H+XTigp+leLsepi1gHloeG
         xacAmkQTnokscLZLysjkUq8Uy9jdiLTHP4MfkbBPJ7kVkeplgxYmg5iObkKTVeXcY7zM
         tuASzwRZ52BSRmamK4sBiIZX8Xj8rTXnj5pNeFzlL3DJu1l7r9Gk3uGbG0sO1ypagJ0Q
         Hnf7N6rC+J/GDc/2JgYyppTlOgfw+STP7Lip314vKfzn2zrfUqpkIrxEW8DC15UMsbzn
         CsGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698137481; x=1698742281;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AeBNyWOSZJ4kGFSxFtfrCpSWWHWhFOJFGqG73cu2x9o=;
        b=a6XxZH0UU2YambLMjAAatQpPR73JUy2x8/9/iMU+qlNuEvMLlPoD4oTaNCURDlAJoE
         nw9HAkSJ4Zbo++G+zYuNX93lGv5ksxqme+ewT6UoDQMNAc7EgPI1pa/V0ODxyv9wxa3I
         hDRAaPFwF/lcaaGnbZJgpkS+NRDyUGZ910d49RSvPCmv1/act1PNvuwmIKgKFvmn+qEx
         h/A9LXKnAZQ6Fn9Dg29lck0LlQelOVKHjwjnQM2bNSUUTlY7F7BRmcqZqgcL2qFmeKx2
         O9xG8IN3e5UHR9JgXjf76HmTXvhkAemATaBs9/jUglVbQFeaO06XGyxS75NcdYsoIMMQ
         68Kw==
X-Gm-Message-State: AOJu0Yw8gjdsT9pfHLIC3RfgaoQHP35RPl03BO56LyPtVDGuAPV5Gy2s
	v3uwpf9CAACJ//2Zdr6oyug=
X-Google-Smtp-Source: AGHT+IE9w6D63XEl5hV9qFn78ltfdOdyg1FtcX+URY3X/3j2HmjScxhbqOllBeM708t69ULHBZJXfQ==
X-Received: by 2002:a05:600c:3d87:b0:3fe:1232:93fa with SMTP id bi7-20020a05600c3d8700b003fe123293famr9195220wmb.22.1698137481203;
        Tue, 24 Oct 2023 01:51:21 -0700 (PDT)
Received: from debian ([63.135.72.41])
        by smtp.gmail.com with ESMTPSA id i18-20020a05600c481200b00407b93d8085sm15948043wmo.27.2023.10.24.01.51.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Oct 2023 01:51:20 -0700 (PDT)
Date: Tue, 24 Oct 2023 09:51:19 +0100
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.1 000/196] 6.1.60-rc1 review
Message-ID: <ZTeFh0eCFm-F4A1s@debian>
References: <20231023104828.488041585@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231023104828.488041585@linuxfoundation.org>

Hi Greg,

On Mon, Oct 23, 2023 at 12:54:25PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.60 release.
> There are 196 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Oct 2023 10:47:57 +0000.
> Anything received after that time might be too late.

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

[1]. https://openqa.qa.codethink.co.uk/tests/5361
[2]. https://openqa.qa.codethink.co.uk/tests/5363
[3]. https://openqa.qa.codethink.co.uk/tests/5372

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
