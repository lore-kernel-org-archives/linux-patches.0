Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC4FA2F58
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 20:34:22 +0000 (UTC)
Received: by mail-pl1-f171.google.com with SMTP id 4so7355380plj.3
        for <patches@lists.linux.dev>; Mon, 12 Dec 2022 12:34:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=EG+8sQHvJPbtrrkYHAC+tfjYrSIfB2UDjEMcjm63I78=;
        b=mTLlJZmBierMpq/dmjA1zjKGWjS1eGv43PXRPUxT7W+Dg9PnwYv+inzAyVQWPHcX2p
         zIRimZwAnnAvS0I4dKj+6PWfjBXxOfhHyX8V+VOxMrxk1kZfNwmEH6X2Sk8BHcQlbCDT
         0JdOoAkdKnOEsuqcCzpiDnaf00+29RnMjHvrXtUn6e17rPlA0KXiDHupLDb95QFt5ysb
         /SFshkgaLvugT9piYuGzjChFqXM2T/2YQpHDIKVvs++DNVlv3e30TuGG2M/+2s7PVDzX
         ty/ZKzNcHgtCKILHGpRwnWihXoTO6ly7ca2DylbcYEm5GKCUUjx71gEKGY2ouW86///J
         UYfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EG+8sQHvJPbtrrkYHAC+tfjYrSIfB2UDjEMcjm63I78=;
        b=nBiU8bByf8vUuoCWdzQTaEr3UIvhwAfRRsC3zJMJOj0pQGs5sURtbiV2E+YCYQE03s
         Q6P7nKhrTNGl7oqv/q8VXwP+mG163+MhiIiV3IB8WhPIb+IZnLsETodQZmMpXBgblltt
         2lQ7wdYFX3iN8O/YV/NN2c2QsF3c+LAqJF2KFhu4qGFKfyg2IXNIgUd/Ik5gcfVcmrKI
         LBd8IgTIPbqczIRtdLKrwLiKvFWJnF7OPsQexZ/jFcGcT0/JUedutjW2PDW//V6XSY39
         0EhJN1+qb5W5glW6Tl2KFNVlPLZqhLivp4ysI6E5hJTZ4d2frTbngmkMGIf1+blkD8Gv
         qteg==
X-Gm-Message-State: ANoB5plJbp99Yim7Tuxa7ktJXe7pugk2xV4WK/ROQiJF5Kz5KwxaF1Z9
	Sn+JxEZMJNCZf5t9DzbkqhB5xq4mAgGfrjVsx7THVg==
X-Google-Smtp-Source: AA0mqf7SuOeIWIhn8efmmXZcIVZ6SpxI8F+ZrxR9F+9mHJCFkJ/Tsd/MfsBf8d5r+2pa/wVIIMOJyg/+Dkyny+KseZI=
X-Received: by 2002:a17:902:8bc4:b0:187:2790:9bc2 with SMTP id
 r4-20020a1709028bc400b0018727909bc2mr83155150plo.61.1670877262347; Mon, 12
 Dec 2022 12:34:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221212130909.943483205@linuxfoundation.org> <CA+pv=HOANBfmAqBLi4wyeejs0W1BsZtbhcHqsNmhs2WA3YxGzQ@mail.gmail.com>
In-Reply-To: <CA+pv=HOANBfmAqBLi4wyeejs0W1BsZtbhcHqsNmhs2WA3YxGzQ@mail.gmail.com>
From: Slade Watkins <srw@sladewatkins.net>
Date: Mon, 12 Dec 2022 15:34:11 -0500
Message-ID: <CA+pv=HM=kZnAYi31OKFopMLDqNc+pK_W=xTLouJc5k1vVcMvHg@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/31] 4.9.336-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

On Mon, Dec 12, 2022 at 3:21 PM Slade Watkins <srw@sladewatkins.net> wrote:
>
>
> 4.9.336-rc1 compiled and booted on x86_64 test systems, no errors or
> regressions.

Apologies, for some reason my Tested-by: didn't insert within my
script. Aagh. Will fix that now.

For now...
Tested-by: Slade Watkins <srw@sladewatkins.net>

Sorry about that,
-- Slade
