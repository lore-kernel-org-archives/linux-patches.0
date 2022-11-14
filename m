Received: from outbound-ip19a.ess.barracuda.com (outbound-ip19a.ess.barracuda.com [209.222.82.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8109EA2
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 22:42:07 +0000 (UTC)
Received: from mail-oa1-f70.google.com (mail-oa1-f70.google.com [209.85.160.70]) by mx-outbound-ea15-94.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Mon, 14 Nov 2022 22:42:05 +0000
Received: by mail-oa1-f70.google.com with SMTP id 586e51a60fabf-13bb98bb80fso6121010fac.23
        for <patches@lists.linux.dev>; Mon, 14 Nov 2022 14:42:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=dWDd/MBzZEtsCg8lCXMYeDNkXSIMpUqiJyLusf/wE8M=;
        b=Ek62IgRUOn87cEM3WfVw1pK1ghk2aB7owmZWSRIM7Uau+O0vfJ2Nu60LMH4uYxOTLF
         qQnEdN276IgPrfGuThCIpYAstIbJSOeXdhYL2ECHyv9WHOZdAFgLrQdR5QKYeX0BgIgu
         4RrWUmLSd5FOeiMen5fS5N8ptn/eH9zKkYEnrbt84+ND6s/YRuNjAlC12yR4V/gbE0Ll
         vRXThrHWj85cfKQZvY73n726NhuNZThoPy7LsHsXiZze+QdBX3a36wGZZgO6KVYjXuoZ
         2KtS7tGO5F0C2jZsLZtzxr1Zj69LNZJuKFimHrCb1ixfktOm+969aFkdR9ETGHqfDVk8
         4REQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dWDd/MBzZEtsCg8lCXMYeDNkXSIMpUqiJyLusf/wE8M=;
        b=5Sbk0KKH57PSvBMP2xlbEL+5pPI9kXBYXQk9mVIZn8CMo7YV+h5Cv+ct7Yf0zTmBxm
         +lN+fKu9BKHt5DCHuhSsWIc26g/cL/WDer5iNoW71oYNO4Dn7qKVQu5aLwnjj03c5OCp
         I/2dDqjEctZq01yEJ/9hlsryXNpexxO+42/zveSR/pjupmQuaoZS9EkV8ama3dA+BGME
         2Hdfg3r52s1J81ehgYUgrwsEe4rv812TZgWmj3+d9nrt7+sO6bhPlCQnpBo2MwiuwTkg
         gSYJ9+So+kf2ZoKYrVDuO7AtIzsVj/q9FW8U3//GFKTZALipmcB50d0N9kDimbxx9vIy
         ifUg==
X-Gm-Message-State: ACrzQf1uZiZ0uNHFOunkuxmFSw5IHAvRjRUvAynaWzGPuyuMqu24VbNR
	8yOvxOT9O5IFWu3ADc7zcsBwEV4hV+yE9Dwpeafts0o/UnpUD9k9HcOE3PYieYo9ZLZICToZylf
	owdO3YJ9UlmvedCvCmzoY/cMXI9EbiGh8uGvUSUgvMdUi6wT8DZwpqSDjD60GASiVqA==
X-Received: by 2002:a17:90a:8008:b0:211:906a:f8ef with SMTP id b8-20020a17090a800800b00211906af8efmr15292373pjn.71.1668459973240;
        Mon, 14 Nov 2022 13:06:13 -0800 (PST)
X-Google-Smtp-Source: AA0mqf54TK9/wMXk1YqcBX6lX0AbuQzvLTAAcG++rlznAG6MtbzAwLLlIeMlYRitwx0z9El5SS8Av+acp9alxzg+Ams=
X-Received: by 2002:a17:90a:8008:b0:211:906a:f8ef with SMTP id
 b8-20020a17090a800800b00211906af8efmr15292355pjn.71.1668459972936; Mon, 14
 Nov 2022 13:06:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221114124448.729235104@linuxfoundation.org>
In-Reply-To: <20221114124448.729235104@linuxfoundation.org>
From: Slade Watkins <srw@sladewatkins.net>
Date: Mon, 14 Nov 2022 16:06:00 -0500
Message-ID: <CA+pv=HMzyBA8UeC_NEbe85-EWfsLHL4G+fUiursk0Z7P14ukRQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/131] 5.15.79-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
X-SWM-External: yes
X-SWM-IntToExt-Scanning: swmout (swm-pri11-itoemail0-scan.leviathan.sladewatkins.net)
X-SWM-Sent-by: swmPRISMgateway (swm-prismgateway-pri02-mail8-scan.leviathan.sladewatkins.net)
X-SWM-Antivirus-Version: 1.1.0
X-SWM-ite-Primary-Server: swm-pri12-item.leviathan.sladewatkins.net
X-BESS-ID: 1668465725-103934-26355-79168-1
X-BESS-VER: 2019.3_20221111.1648
X-BESS-Apparent-Source-IP: 209.85.160.70
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.244151 [from 
	cloudscan16-7.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
	0.00 BSF_SC0_MISMATCH_TO    META: Envelope rcpt doesn't match header 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS162129 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND, BSF_SC0_MISMATCH_TO
X-BESS-BRTS-Status:1

On Mon, Nov 14, 2022 at 7:54 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.15.79 release.
> There are 131 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 16 Nov 2022 12:44:21 +0000.
> Anything received after that time might be too late.

5.15.79-rc1 compiled and booted on my x86_64 test system. No errors or
regressions.

Tested-by: Slade Watkins <srw@sladewatkins.net>

All the best,
-srw
