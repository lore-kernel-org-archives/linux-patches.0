Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CD073232
	for <patches@lists.linux.dev>; Mon, 12 Sep 2022 16:18:54 +0000 (UTC)
Received: by mail-il1-f178.google.com with SMTP id s11so4785304ilt.7
        for <patches@lists.linux.dev>; Mon, 12 Sep 2022 09:18:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=dKtqFa8Lj7sKVbipP1evfO/jZ1JEKgMyQWZPo5L2svY=;
        b=LYJrUWkBI5r0+ftj5RafEIHZV3TKIYV+GtfpLp5bklqBn7NVcwrDDRIvV40oAViNnw
         PAYijJ1aNQ4wlDinX3lV3rhtEr6tMQHvjF4Qpem/VsESXWSpyHspJurr8+MBPgRUnyS1
         JSyYvDet2ykXQxZD7W0xJQ/PbXRNVY8laRRXUVrXu8sLgFQQEl/CQnZve/OUnnSCjOC9
         SWBwhTCcO23qhLn2kVpDFhkjIR4NmaqXoDjc0wRMDxkqLUhcCuzscCc2alA3Bl4rAfUt
         b5JxVOVq1YMz+KhSjV168EA76QkBJyrj/895rj3CdO4d8Ut7a/C9fvaelZoVGDGCEllR
         K/2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=dKtqFa8Lj7sKVbipP1evfO/jZ1JEKgMyQWZPo5L2svY=;
        b=KRlxzSH/xhs4eQlxxQURBaoG8xNJIXhtbVcIod88q73XAKop43eOmkzK8t7w8bco9j
         fz42eAKMPnTezWhm/U6l8LvIuCXRZOXO3xXR3w3vKcPzbMuZ83y4xf9OiU0CECUDKpdX
         VLYYam5FEt8dplw5/Pr3d8gNqw93fP9kTVqGK12sNfOWfSRqMWbcAr454a54c4UnX8Hb
         tBuPfEeLFd18Wwz9R3AcRRhIHiy1uC92GS5c6FEL3K0iXO0PO/oI3Cycv4GNG/LtLr6U
         jmKdqGWKH+IdR8wNc/ty6Ui2lA2VJeII2swSyQA8HYGlMz5esXThNykBMUcyrtZzc5vi
         2HnA==
X-Gm-Message-State: ACgBeo2jwchAgE7PRRZ2z4xRPv0Gor8Ak4I7QFeuEuzCNG3xrpUVomTI
	UqTWjlj3+pi5HJnTteapYInsk1K8ClNTTlaNNTU=
X-Google-Smtp-Source: AA6agR6MemFAoJLParyi3ed9uKb3AZKl39DwttCreIuRBOy0bqj7TVF1woYsiMJbd8RxkweMyI0pKSKSOrXHyq4gx6o=
X-Received: by 2002:a05:6e02:1aac:b0:2f1:94e3:1805 with SMTP id
 l12-20020a056e021aac00b002f194e31805mr10813730ilv.72.1662999534105; Mon, 12
 Sep 2022 09:18:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220805154231.31257-1-ojeda@kernel.org> <20220805154231.31257-24-ojeda@kernel.org>
 <CAK7LNAQ=JfmrnGAUNXm_4RTz0fOhzfYC=htZ-VuEx=HAJPNtmw@mail.gmail.com>
In-Reply-To: <CAK7LNAQ=JfmrnGAUNXm_4RTz0fOhzfYC=htZ-VuEx=HAJPNtmw@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 12 Sep 2022 17:18:43 +0100
Message-ID: <CANiq72kZEqAwr_m14mAFjHsFJTLjj7i4He0qyrprubpmBfOFdw@mail.gmail.com>
Subject: Re: [PATCH v9 23/27] Kbuild: add Rust support
To: Masahiro Yamada <masahiroy@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, rust-for-linux@vger.kernel.org, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, patches@lists.linux.dev, 
	Jarkko Sakkinen <jarkko@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, Finn Behrens <me@kloenk.de>, 
	Adam Bratschi-Kaye <ark.email@gmail.com>, Wedson Almeida Filho <wedsonaf@google.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Sven Van Asbroeck <thesven73@gmail.com>, Gary Guo <gary@garyguo.net>, 
	Boris-Chengbiao Zhou <bobo1239@web.de>, Boqun Feng <boqun.feng@gmail.com>, Douglas Su <d0u9.su@outlook.com>, 
	Dariusz Sosnowski <dsosnowski@dsosnowski.pl>, Antonio Terceiro <antonio.terceiro@linaro.org>, 
	Daniel Xu <dxu@dxuuu.xyz>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Martin Rodriguez Reboredo <yakoyoku@gmail.com>, Michal Marek <michal.lkml@markovi.net>, 
	Nick Desaulniers <ndesaulniers@google.com>, 
	Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi Masahiro,

On Mon, Sep 12, 2022 at 5:08 PM Masahiro Yamada <masahiroy@kernel.org> wrote:
>
> I have not figured out where this difference comes from.

It is the `RUSTC_BOOTSTRAP` environment variable: it allows to use
unstable featuers in the stable compiler.

We currently set it in the global `Makefile`, but we could be more
explicit and do it on each command if you think that would be better.

If you want that we keep using the global export, then we can add a
comment explaining this to clarify.

Cheers,
Miguel
