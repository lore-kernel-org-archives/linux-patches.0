Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDB714683
	for <patches@lists.linux.dev>; Thu, 18 Aug 2022 17:01:37 +0000 (UTC)
Received: by mail-io1-f43.google.com with SMTP id z72so1532019iof.12
        for <patches@lists.linux.dev>; Thu, 18 Aug 2022 10:01:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=T7igz+JHo+DrCDKUS4xWUJ3/Lp268Fiqe+ivN8o+tCA=;
        b=mSmp9rHtVwSbvQYUCcl1B6+4w12c4NZupPfwhitjKwp64SgVF4OpQZTM5OjLoTUTq/
         bvlbPn/LMeKbRiglU8JNMoyfa9evwumI8CLFupqetQdHEK6ASSyTUQKMARKS6+J8d41C
         syh/FDLqz69ZOMnbwXYSw27NnA/SdwWXPsCZG/OkbTJ3TeRryGQaM9pefDmG20OB855W
         Pg/ZEny4IK0cVtgltjxaukuxnPCqRSVwGGN3R+gsz1dnG13VOb8meRsL2IYZz+ic/ZYT
         3+DVKOsefTIeUcl4hA+wuKfu9fKsVZ5i0F7XDoWk47lyfxro942KIc/TnSD31+zljHZs
         2m+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=T7igz+JHo+DrCDKUS4xWUJ3/Lp268Fiqe+ivN8o+tCA=;
        b=L7XoEK12FC22mBBN37qa7v2bb6Jzq5ag69yV8KDOH8cH9uSfoCA7dGsOwgUGDT36Cs
         wk3TRQzPa4GV74u57KyLhaAMqMVHpLoMzkPG9tp00/lzO8EDIBpuDbLE9OEY0+LMYaFB
         vNJ9DI8XobC5/kv1hR1UR6opIqXkHt4iJvYP2XzkCk4K7hdhm1+CsFPsZw1Kmsxqw/QD
         qkH1zj4uGTQ8JiC+9nu//Iv8hxBeiSTaICJfgbsO019L5kJSBKP6GSSRyZ2qCIsB9xPj
         6jlIeJukewErgJg1rV5Y7unjkM+pWujS76Ea441Am/KKK7ZoeEoeCpKhJ28HrBLdtUAx
         ALmw==
X-Gm-Message-State: ACgBeo0rHR+irBJH+6en60n27eOkG9IsNfI+uh4Bep5IOZXhThT1FcK+
	mqQkFXyRkgB8xU8ZS1Z5odzGGd09ypXj+SnnGK4=
X-Google-Smtp-Source: AA6agR5ue0JYy9T5byXdp26N17IarelQjKYAQisDC3hxB9tZlGD0vKInrJQ3a9Wk2MjOxtbHTGvUCzfa3vGBxwGqww0=
X-Received: by 2002:a05:6602:2a42:b0:678:84be:c9ec with SMTP id
 k2-20020a0566022a4200b0067884bec9ecmr1767428iov.64.1660842096984; Thu, 18 Aug
 2022 10:01:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220805154231.31257-1-ojeda@kernel.org> <20220805154231.31257-7-ojeda@kernel.org>
 <202208171240.8B10053B9D@keescook> <CANiq72nR2eAeKrY6v=hnjUjvwfecMsSC6eXTwaei6ecnHjia8g@mail.gmail.com>
 <202208171331.FAACB5AD8@keescook> <CANiq72=6nzbMR1e=7HUAotPk-L00h0YO3-oYrtKy2BLcHVDTEw@mail.gmail.com>
 <202208171653.6BAB91F35@keescook> <CANiq72mqutW7cDjYQv4qOYOAV6uM8kUWenquQyiG-mEw4DURJA@mail.gmail.com>
 <202208180905.A6D2C6C00@keescook>
In-Reply-To: <202208180905.A6D2C6C00@keescook>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 18 Aug 2022 19:01:25 +0200
Message-ID: <CANiq72=BbV-h6P1z7pSg7oMjXoMOuUjhaiB-sYGJu4uyE0BPKQ@mail.gmail.com>
Subject: Re: [PATCH v9 06/27] rust: add C helpers
To: Kees Cook <keescook@chromium.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	patches@lists.linux.dev, Jarkko Sakkinen <jarkko@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Geoffrey Thomas <geofft@ldpreload.com>, 
	Wedson Almeida Filho <wedsonaf@google.com>, Sven Van Asbroeck <thesven73@gmail.com>, Gary Guo <gary@garyguo.net>, 
	Boqun Feng <boqun.feng@gmail.com>, Maciej Falkowski <m.falkowski@samsung.com>, 
	Wei Liu <wei.liu@kernel.org>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, Aug 18, 2022 at 6:08 PM Kees Cook <keescook@chromium.org> wrote:
>
> Please, no UB. I will take a panic over UB any day. It'd be best to
> handle things with some error path, but those are the rare exception.
>
> C is riddled with UB and it's just terrible. Let's make sure we don't
> continue that mistake. :)

I definitely agree on avoiding UB :)

> The simple answer is that if an "impossible" situation can be recovered
> from, it should error instead of panic. As long as that's the explicit
> design goal, I think we're good. Yes there will be cases where it is
> really and truly unrecoverable, but those will be rare and can be well
> documented.

Yeah, that is the goal and we always take that into account, but there
are always tricky cases which is best to consider case-by-case.

Cheers,
Miguel
