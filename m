Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08B6380C
	for <patches@lists.linux.dev>; Tue, 27 Sep 2022 12:48:30 +0000 (UTC)
Received: by mail-il1-f179.google.com with SMTP id a2so5015370iln.13
        for <patches@lists.linux.dev>; Tue, 27 Sep 2022 05:48:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=9gDaL9YVBu3tbVyLgkWJ9ypm85wNRW4z2AjB7yERbF8=;
        b=Hj/xPB/IR2JzM5v82MR6Pc2QdWG//UCG+5mtmTep8jIUc/w2cJMsuuPs0BxE8mWkdd
         K0dKoPPcIKHeAsrM/4wjo82Zfji4FjDenmqXBslRRPQTHm8qzb40/eBEYrDnygOXaIdt
         BUexLU0SRUeFRdesx9EldFKhqGKCLf0NMzgSjjrPg/PVqafTYWv/+sFxDtS9DSijdBSg
         L+An79cFPMVZMBKIkeRZMfa+fsw4HgGl8CU5WReHpOhQ45/HtIwd2s3ue398TaxHc2n3
         t/T2QTx/ElFyGHws6MIpIrtOT9Gegim+OeGH+kZX9N66PmT5aER8N1tJZH3EocH5Ahtc
         ip8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=9gDaL9YVBu3tbVyLgkWJ9ypm85wNRW4z2AjB7yERbF8=;
        b=RO7998iIYOSIP7X6QrI6n/X481P9UUzJK9gkSjMIB0cPU/ppl//0FzmIwj3dBehPiH
         WrF42X4pycELm1EtdYxZAfTvM2iI5bVx4DER4WGRVvKvSlKC3uAAIEFMGnSgTZdAkNN8
         DcWxvZpfqqEH/AzgoHRBivyUtoE7ky3iQMrgvE3eQ79LuGwRGEjeq2sSnsXYlAHNjML/
         NK/jIyX6ZGQIO12Q+HdqpYndqV1aFLg2YEnGGOfe+USvFQ/9Xl04dD7t6IznYuOMlL2p
         U77CpVqxo8fm1v+Cc+KLDOiIGbnFSwbAoeVR9k2FuHdZ55Br+QQg2HI2JIpppHyTott/
         Skzg==
X-Gm-Message-State: ACrzQf1RyOP06xr6u3x+F0HFmKaEeQ8eGrf4G6n5DhiVspysxe1s+8Eg
	y7KKNuSBLPAk6qz6ngTCR4TxfDnNOHhJaBzTC/k=
X-Google-Smtp-Source: AMsMyM4S1pt68/znq8Dld0WeOSq5D8rhwB9oDs25ZTH2YllCybfv3fb1w/tu1Q7HwsOj2NUxlk8ypJkkUJ7hqMNRK2A=
X-Received: by 2002:a05:6e02:1aa5:b0:2f8:739:c48 with SMTP id
 l5-20020a056e021aa500b002f807390c48mr8060152ilv.72.1664282910137; Tue, 27 Sep
 2022 05:48:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220805154231.31257-2-ojeda@kernel.org> <Yu2cYShT1h8gquW8@yadro.com>
 <202208171235.52D14C2A@keescook> <Yv4AaeUToxSJZK/v@yadro.com> <202208180902.48391E94@keescook>
In-Reply-To: <202208180902.48391E94@keescook>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 27 Sep 2022 14:48:19 +0200
Message-ID: <CANiq72nQJe4gHa2od3+MuRDbTQU7vvO1o9v1mHgmJcPST9VJZA@mail.gmail.com>
Subject: Re: [PATCH v9 01/27] kallsyms: use `sizeof` instead of hardcoded size
To: Kees Cook <keescook@chromium.org>
Cc: Konstantin Shelekhin <k.shelekhin@yadro.com>, ojeda@kernel.org, boqun.feng@gmail.com, 
	gregkh@linuxfoundation.org, jarkko@kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	rust-for-linux@vger.kernel.org, torvalds@linux-foundation.org
Content-Type: text/plain; charset="UTF-8"

On Thu, Aug 18, 2022 at 6:03 PM Kees Cook <keescook@chromium.org> wrote:
>
> Oh, that's an excellent point; I forgot it'll actually compile-time
> error if the var is a pointer. +1

In this case it doesn't, because `scripts/kallsyms.c` defines its own
`ARRAY_SIZE` that doesn't have the `__must_be_array`.

I have changed it for v10 anyway, since that way we may benefit in the
future if the `ARRAY_SIZE` here gains the check.

Cheers,
Miguel
