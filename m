Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC6C533FE
	for <patches@lists.linux.dev>; Tue, 27 Sep 2022 15:43:23 +0000 (UTC)
Received: by mail-io1-f51.google.com with SMTP id q83so8047877iod.7
        for <patches@lists.linux.dev>; Tue, 27 Sep 2022 08:43:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=RGfTD4NBOLWMCkradB21iOUt0wxo832XK6CrqAqR2GY=;
        b=FRmqHXAnA0Nlr7CuCFa/vix9iR1N23MYD3UAIyxIrWl3zMGywdKlliuS+7RvdJLp0s
         AOp4ynTOO5Dw1uoCO2t6YKv+AEutCv6Qm+TF2dlX/Rsc94zPvoiWdWDWfbhx48QrnVua
         B8Rdk5ZI5hVFb09DwXb3dvLS5z47+wzRTvQfCcN+2nEDjnHjirh9TekDHGXtzlxPepYQ
         hd+OhA9reVu234odrbQBh/Hbt20ydVYftwxy6YDwqJtl9pGAqXlXC6cog6jNnHp357Ze
         b6aLaGVCgQiotev4H0qmTYFG/U8MfgaJkw3rPXOo/5XGR8IyHUeWxnyj77iepW02vFmi
         6E+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=RGfTD4NBOLWMCkradB21iOUt0wxo832XK6CrqAqR2GY=;
        b=lp5WPGegiduyWVQDp3/QjIdZQDDFoG7B4vOSkX5KNOdfxEZndZurepg9A2SAPF+M2e
         WjyLzIALUUkOeA2zDQbAutjlZYS49STNUL5AvZI5/ouQ5jLmlsLgqb0t6CFOkyKPUTPk
         m0Zl3iioYzogCxSqFBPtf704Z2RNUmucr+ORiQAg0/hYA/tHJXEcahGo5ZSM2F80g71E
         tQfDqrV/SLEQID0g7JNm8KA6/cUcHqXk79/0sw5uh960L2rNWztaAksRMwTqK/a0/lJR
         rRzd1/rVKbJaF2cCOaMWvNUW4RkLOGvCNxc3F39wd6+sA6m8ivAa7iSlaWQ032aPKwVr
         C7aA==
X-Gm-Message-State: ACrzQf0F36ImtRRX8gFDDTvfq4J9t2oPYj4Xoe0t1PNCg5CYW5efTaEp
	Kgo3TsjF3ysKoGxyQv44TSHUZLOXYwUazXUK+RQ=
X-Google-Smtp-Source: AMsMyM5638P6n2YDuzc4zVDow6i/V+t/qyQWRPEc72Q9aoMVNm+viu9quW2HEvNYC/icgeKNC0a6wPTZ5TN0vtRaDjY=
X-Received: by 2002:a05:6638:4115:b0:35a:2729:fc6b with SMTP id
 ay21-20020a056638411500b0035a2729fc6bmr15445039jab.264.1664293402668; Tue, 27
 Sep 2022 08:43:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220927131518.30000-1-ojeda@kernel.org> <20220927131518.30000-13-ojeda@kernel.org>
 <YzMVLkr3ZlbENMcG@kroah.com>
In-Reply-To: <YzMVLkr3ZlbENMcG@kroah.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 27 Sep 2022 17:43:11 +0200
Message-ID: <CANiq72n86arq4isngUXdn0VYBkMDDyu81WEkfUDwGw32Fk8iBQ@mail.gmail.com>
Subject: Re: [PATCH v10 12/27] rust: add `kernel` crate
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, patches@lists.linux.dev, 
	Jarkko Sakkinen <jarkko@kernel.org>, Wedson Almeida Filho <wedsonaf@google.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Geoffrey Thomas <geofft@ldpreload.com>, 
	Finn Behrens <me@kloenk.de>, Adam Bratschi-Kaye <ark.email@gmail.com>, 
	Sven Van Asbroeck <thesven73@gmail.com>, Gary Guo <gary@garyguo.net>, 
	Boris-Chengbiao Zhou <bobo1239@web.de>, Boqun Feng <boqun.feng@gmail.com>, Fox Chen <foxhlchen@gmail.com>, 
	Viktor Garske <viktor@v-gar.de>, Dariusz Sosnowski <dsosnowski@dsosnowski.pl>, 
	=?UTF-8?Q?L=C3=A9o_Lanteri_Thauvin?= <leseulartichaut@gmail.com>, 
	Niklas Mohrin <dev@niklasmohrin.de>, Milan Landaverde <milan@mdaverde.com>, 
	Morgan Bartlett <mjmouse9999@gmail.com>, Maciej Falkowski <m.falkowski@samsung.com>, 
	=?UTF-8?B?TsOhbmRvciBJc3R2w6FuIEtyw6Fjc2Vy?= <bonifaido@gmail.com>, 
	David Gow <davidgow@google.com>, John Baublitz <john.m.baublitz@gmail.com>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, Sep 27, 2022 at 5:22 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This feels "odd" to me.  Why not just use __kmalloc() instead of
> krealloc()?  I think that will get you the same kasan tracking, and
> should be a tiny bit faster (1-2 less function calls).
>
> I guess it probably doesn't matter right now, just curious, and not a
> big deal at all.

Yeah, nowadays I think a "C helper" could have been used instead.

> You'll be adding other error values here over time, right?

Indeed, I removed all the ones we didn't use in v8 to reduce it a bit
more. Sorry for the confusion! :)

> What about functions that do have return functions of:
>         >= 0 number of bytes read/written/consumed/whatever
>         < 0  error code
>
> Would that use Result or Error as a type?  Or is it best just to not try
> to model that mess in Rust calls? :)

`Result`, i.e. the "number of bytes" part would go in the `Ok` variant
and the "error code" in the `Err` variant.

The benefit is that then you have to handle them "separately", i.e.
you cannot confuse the number of bytes for the error code by mistake,
or vice versa.

> In the long run, using "raw" print macros like this is usually not the
> thing to do.  Drivers always have a device to reference the message to,
> and other things like filesystems and subsystems have a prefix to use as
> well.
>
> Hopefully not many will use these as-is and we can wrap them properly
> later on.

Definitely, we will have e.g. the `dev_*!` ones:

    https://github.com/Rust-for-Linux/linux/blob/fcad53ca9071c7bf6a412640a82e679bad6d1cd4/rust/kernel/device.rs#L479-L502

> Anyway, all looks sane to me, sorry for the noise:
>
> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Thanks a lot for taking a look!

Cheers,
Miguel
