Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7895DA28
	for <patches@lists.linux.dev>; Thu,  1 Dec 2022 02:20:04 +0000 (UTC)
Received: by mail-pj1-f49.google.com with SMTP id k5so522251pjo.5
        for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:20:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6y9AUyAqq0punB0p25H3aQ8RSZH3MKAHnozHOyjdT/o=;
        b=GkZbysRbQz2Phy3zO7CnVjp8oZ3E1AIXTQMfBWKR51wcKg9K6ymnCmz0eBo5jCz4oD
         Zm1cqfAb1ajgztTvYr6L/QakMxwGWXUbhljQb9j1L8NuvFH2hKSNdCkMnnCvXkAI5pp5
         rmdZ4qDJ9egcNLwVa3hiQV+RnGbY5AfJ4+/t+H0uWlpneNWcBmVfOJnalZo0vW3urCBn
         teX13Pdl/lMyiasmQftLVuyzEQ0XI5gWV0+d4OGlgAlm/JDTU9TUSg9uLSmf8i7mi7La
         yIriDqpDX23oOTtowOdATtzKYsNyvG5ieGtPnAxieuBWOuvwX8tfpx20xl5EOSyQt0op
         vTGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6y9AUyAqq0punB0p25H3aQ8RSZH3MKAHnozHOyjdT/o=;
        b=ohD1AtKpu5kRsmxjR7plU6tKgZj4d4a0I9ZMWpplbJIaHwpsMIvN3uqEw5NF8LKBqF
         DAtgp8Tl7cGPVTHphiGTGhzQdt/H/ySXjnifMOjmTwBCfAl59fck7KCWkC7N9JMYA4M4
         HEdQ9xc0aBsPm1Zksw5cK+aUd07ikBn0bQeG5KhP2iMKuuk2yEg2GwkmpIRXj9oEPqRX
         MYuJrYcfD+6uWbQXgZpIwo8gVj+4vWMhdEgmEKS4O7c5sbw9mEEgvPRWiDmQytluV0wr
         FyQ38bDOG+EAWMr57iqxz0/Opza3RSppLKy/JJJYBIKD22ZVeXHXn4VjQ5mFMFWATRYN
         aijA==
X-Gm-Message-State: ANoB5pnTKfugcLeTWOjk6GkUchBoMhlpMdaJsedMp1G5sL2WsFpq46eE
	6EiBjuTxEZvZlDlibvjJg4MtjW9qaM1ZVpx+Fgs=
X-Google-Smtp-Source: AA0mqf5rVSN3sU8H7annQKroyzCuVfNG6TOykuN/kwAF13K5JIWuu8skyrXchhhBPXYsKpgRNQ8TlQ516IH3mgc28ME=
X-Received: by 2002:a17:90a:a88e:b0:213:13ab:c309 with SMTP id
 h14-20020a17090aa88e00b0021313abc309mr67274062pjq.80.1669861203738; Wed, 30
 Nov 2022 18:20:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221130180544.105550592@linuxfoundation.org>
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
From: Zan Aziz <zanaziz313@gmail.com>
Date: Wed, 30 Nov 2022 19:19:52 -0700
Message-ID: <CAFU3qoaA-_ixnfFFZXvnSp3t5YPTQzY01US4gOyaJedfFg56aw@mail.gmail.com>
Subject: Re: [PATCH 6.0 000/289] 6.0.11-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

On Wed, Nov 30, 2022 at 3:16 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.0.11 release.
> There are 289 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 02 Dec 2022 18:05:05 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.11-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Hi Greg,

Compiled and booted on my test system Lenovo P50s: Intel Core i7
No emergency and critical messages in the dmesg

./perf bench sched all
# Running sched/messaging benchmark...
# 20 sender and receiver processes per group
# 10 groups == 400 processes run

     Total time: 0.710 [sec]

# Running sched/pipe benchmark...
# Executed 1000000 pipe operations between two processes

     Total time: 9.551 [sec]

       9.551475 usecs/op
         104695 ops/sec

Tested-by: Zan Aziz <zanaziz313@gmail.com>

Thanks
-Zan
