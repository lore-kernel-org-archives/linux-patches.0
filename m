Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23EDE2C726
	for <patches@lists.linux.dev>; Tue, 16 May 2023 09:14:40 +0000 (UTC)
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-3f42c865535so80501935e9.1
        for <patches@lists.linux.dev>; Tue, 16 May 2023 02:14:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684228479; x=1686820479;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cRWUjVainBSLk+Ch+fZFNLT9kQJZkSXu5GrlLii7+xI=;
        b=hNRIsgzrO8MWE4d56GVZ5AJ5PZuIXk5NuKmXxjOEHrctHlrH5rPw5Yvq+XRysw7YDw
         YWiNnlX8y9CZvHQ7IOKjsb55k49PEbNKtYFvzpp8OxGF6nAiPrGIVVATlEfWw+FAdIRL
         AVIEb88SGUvVkyA+1smMQHrZLXgZjHPABJa+huUyFRJhdFvRs6Tw3nMVkYiDHlNZR6xj
         wYJdJOD18qY92Khd26sLnr/aGnjBQTfNLu8W7SU5jQlJqfksSdpVHgNoB5hHDZuyzd7q
         qxNUwRQu8hwql7P61OW/KD1mlDz5izZ2eJllGkpDdirjQBawiyCA+KVpNqsgyWrpSyNN
         KW9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684228479; x=1686820479;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cRWUjVainBSLk+Ch+fZFNLT9kQJZkSXu5GrlLii7+xI=;
        b=ITMcZcIqXVAlSZACKJanqLLb5FcOoOhH6LwbZ95uuY1HzYJQumTyWdYi1/yxLvLKSl
         KW9OjNhmfH3cRjyH4ooODO5lfIATFGCMrlhzbqFe1qB1aiZn1XC96aFMqMXutrSc0RxH
         FH9EaBGemOASvOqWJyiISRvBv6FTFfF5lL12psestlepWBUZA/shC5llSWVRjK0WDHg2
         ++MZFMMQSKaEOazAigeZpbEDV1kCGTXiaNCfFht0ijNo4AFqzkaoQhTCRMemJa69LPge
         9ZKqD5Kk05uZ+uRaiTUBmo2l+WRcoR5k1k8KlumbNa1ficCbyraeM5wGWGgPgILGnyR9
         EGSg==
X-Gm-Message-State: AC+VfDyQFlUpGxhoOhNerXuMCYTOUD4KAZ99JzjWLvkKaaJ7l7YOvvRs
	//VNWhRlx5HXX9rkTuvriN8=
X-Google-Smtp-Source: ACHHUZ4f1wIwlxc0TmyeaUQQkL1OqyRolgs2zO8TgR6ZeNh2y9jWnu9DSJjEeyx0TmU2vTz0Xm0OjA==
X-Received: by 2002:a05:600c:2292:b0:3f4:fa56:3186 with SMTP id 18-20020a05600c229200b003f4fa563186mr7682785wmf.14.1684228478895;
        Tue, 16 May 2023 02:14:38 -0700 (PDT)
Received: from debian ([63.135.72.41])
        by smtp.gmail.com with ESMTPSA id w12-20020a05600c474c00b003f07ef4e3e0sm33140975wmo.0.2023.05.16.02.14.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 02:14:38 -0700 (PDT)
Date: Tue, 16 May 2023 10:14:36 +0100
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 5.10 000/381] 5.10.180-rc1 review
Message-ID: <ZGNJfAPd8eeVoCJ3@debian>
References: <20230515161736.775969473@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230515161736.775969473@linuxfoundation.org>

Hi Greg,

On Mon, May 15, 2023 at 06:24:11PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.180 release.
> There are 381 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Build test (gcc version 11.3.1 20230511):
mips: 63 configs -> no failure
arm: 104 configs -> no failure
arm64: 3 configs -> 1 failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

arm64 allmodconfig build fails with the error:

/gcc/bin/aarch64-linux-ld: arch/arm64/kvm/hyp/nvhe/kvm_nvhe.o: in function `__kvm_nvhe___kvm_tlb_flush_vmid_ipa':
(.hyp.text+0x1a4c): undefined reference to `__kvm_nvhe_memset'
/gcc/bin/aarch64-linux-ld: arch/arm64/kvm/hyp/nvhe/kvm_nvhe.o: in function `__kvm_nvhe___kvm_tlb_flush_vmid':
(.hyp.text+0x1b20): undefined reference to `__kvm_nvhe_memset'
/gcc/bin/aarch64-linux-ld: arch/arm64/kvm/hyp/nvhe/kvm_nvhe.o: in function `__kvm_nvhe___kvm_flush_cpu_context':
(.hyp.text+0x1b80): undefined reference to `__kvm_nvhe_memset'


Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/3530
[2]. https://openqa.qa.codethink.co.uk/tests/3531


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
