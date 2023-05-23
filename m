Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F34B1F931
	for <patches@lists.linux.dev>; Tue, 23 May 2023 15:09:55 +0000 (UTC)
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-3f6094cb26eso11497485e9.2
        for <patches@lists.linux.dev>; Tue, 23 May 2023 08:09:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1684854594; x=1687446594;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=E8b9MpzTCglN7HI+qZ7EYTlHwVoKr0imEe2dKuGSUUc=;
        b=oedF/OpaSzR0ty3V7END7dGpEbKtM9xZFqWV75o4kqKtimqL14VCIbfzEeX2RK4svX
         vxTe8PsCutukTy7lfsL2C1C8OdHQyQqAqIO+2v6etis6aieDlewgAvQqdy7iKuxlj/ze
         kJSKUdJlLYTMdPLGgElYQ2/WJGcCBsw6Zm9GKGycBR9BZs7CKmHF3darLzJ4fUWT8Kwm
         lXO6X85FLpXKuoYLk07ZsOJCr/3NiJqFywVt+zDzED0lLsFJ+vPYkvCeA4sZDPv+roE+
         XUZfldjTcau4V7yYACc2RTLfe1c4FXOeA7qaJjwDEVo28mmoB2g0YCB/G3MW2i6gG6l+
         Dgqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684854594; x=1687446594;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E8b9MpzTCglN7HI+qZ7EYTlHwVoKr0imEe2dKuGSUUc=;
        b=OouJpxXu5tt4JFaSZpkzlzjeZbjUo/0S0fxnLeaIyMJ+f7qzHDaGfWJLkJxbYz2nGz
         jLQ6cMydtlXAYCsPQIykN60SKtoCpKeW92Ghepbb02Q0pRrl/5XW0tloeLO92/qOxafq
         aKcgQOXgvQuYXr+ryF2B707l3B2J6XR1cJZyutuhhKlzkIHeRh9FV4nHSrQLlehuAv8Y
         snaGcMRkAMF/DqsEGQ1p5yWcp8Md2+IGaglVos3sVP2N1WZ7azwv2bOIIMzDN6350ziv
         VqPSQ61vqmLD0a16OeLD6co9vcZRSzJzgOPsL7kDWcn010Ty7Ccy2sEm7IWnOOxojb4K
         14Lw==
X-Gm-Message-State: AC+VfDx9/Um7nVmtNclpN+M5c/601iGltGAw2fS+4ArVvn3eJrTzEfX7
	HjKPhmkdgRC+NByA7xaEyxA8JQ==
X-Google-Smtp-Source: ACHHUZ53ALZt8ITA9PYkpa+ddvkzqMUvuxLGadsY4TgcTyLDpTXlK3mlv8nuCJzmyUKUbpLaMhQxSw==
X-Received: by 2002:a1c:7716:0:b0:3f6:f56:5e82 with SMTP id t22-20020a1c7716000000b003f60f565e82mr717086wmi.3.1684854594086;
        Tue, 23 May 2023 08:09:54 -0700 (PDT)
Received: from ?IPV6:2a02:578:8593:1200:6cb1:7d36:3be3:30d? ([2a02:578:8593:1200:6cb1:7d36:3be3:30d])
        by smtp.gmail.com with ESMTPSA id n6-20020a7bcbc6000000b003f42d8dd7ffsm11930110wmi.19.2023.05.23.08.09.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 May 2023 08:09:53 -0700 (PDT)
Message-ID: <457ea968-b2dd-1a9b-7eab-0b0ec825304d@tessares.net>
Date: Tue, 23 May 2023 17:09:52 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 6.1 000/292] 6.1.30-rc1 review
Content-Language: en-GB
To: Naresh Kamboju <naresh.kamboju@linaro.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de, LTP List <ltp@lists.linux.it>,
 Netdev <netdev@vger.kernel.org>, linux-perf-users@vger.kernel.org,
 MPTCP Upstream <mptcp@lists.linux.dev>
References: <20230522190405.880733338@linuxfoundation.org>
 <CA+G9fYs4zoTUQUnkvncEpPWvfGD6sDSXi94KXji+udMrvfm5Rg@mail.gmail.com>
From: Matthieu Baerts <matthieu.baerts@tessares.net>
In-Reply-To: <CA+G9fYs4zoTUQUnkvncEpPWvfGD6sDSXi94KXji+udMrvfm5Rg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Naresh,

On 23/05/2023 16:52, Naresh Kamboju wrote:
> On Tue, 23 May 2023 at 00:53, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>>
>> This is the start of the stable review cycle for the 6.1.30 release.
>> There are 292 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Wed, 24 May 2023 19:03:25 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.30-rc1.gz
>> or in the git tree and branch at:
>>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
> 
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.
> 
> Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

(...)

> selftests: net/mptcp: diag.sh started failing on 6.1.30-rc1 but
> passed on 6.3.4-rc1. This is due to changes in latest kselftest
> (6.3) running on 6.1.
> 
> test logs:
> =======
> # selftests: net/mptcp: diag.sh
> # no msk on netns creation                          [  ok  ]
> # listen match for dport 10000                      [  ok  ]
> # listen match for sport 10000                      [  ok  ]
> # listen match for saddr and sport                  [  ok  ]
> # all listen sockets                                [  ok  ]
> # after MPC handshake                               [  ok  ]
> # ....chk remote_key                                [  ok  ]
> # ....chk no fallback                               [  ok  ]
> # ....chk 2 msk in use                              [ fail ] expected 2 found 0
> # ....chk 0 msk in use after flush                  [  ok  ]
> # check fallback                                    [  ok  ]
> # ....chk 1 msk in use                              [ fail ] expected 1 found 0
> # ....chk 0 msk in use after flush                  [  ok  ]
> # many msk socket present                           [  ok  ]
> # ....chk many msk in use                           [ fail ] expected
> 254 found 0
> # ....chk 0 msk in use after flush                  [  ok  ]
> not ok 4 selftests: net/mptcp: diag.sh # exit=11
> 
> logs:
>  - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.29-293-ge00a3d96f756/testrun/17163977/suite/kselftest-net-mptcp/test/net_mptcp_diag_sh/history/
>  - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.29-293-ge00a3d96f756/testrun/17163977/suite/kselftest-net-mptcp/test/net_mptcp_diag_sh/details/

Thank you for looking at these MPTCP selftests and for having reported
these issues.

We are looking at having MPTCP selftests supporting previous kernel
versions but that's not easy because our selftests are verifying some
internal behaviours, not just what is exposed to the uAPI, e.g. what
network packets are being sent, etc.. Also, some socket options and
counters -- like what you reported here above with diag.sh -- were
returning 0 before being implemented in MPTCP: so we need to accept that
these counters might not work, that's not ideal for a test that wants to
check if they work :)

Anyway, for those who wants to follow the evolution, patches have been
shared on our mailing list:

  https://patchwork.kernel.org/project/mptcp/list/?series=749868&state=*
  https://github.com/multipath-tcp/mptcp_net-next/commits/7220c4c22b88
  https://github.com/multipath-tcp/mptcp_net-next/issues/368

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
