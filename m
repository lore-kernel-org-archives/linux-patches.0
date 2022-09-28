Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C5D281F
	for <patches@lists.linux.dev>; Wed, 28 Sep 2022 16:36:16 +0000 (UTC)
Received: by mail-io1-f49.google.com with SMTP id v128so10572668ioe.12
        for <patches@lists.linux.dev>; Wed, 28 Sep 2022 09:36:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=TzxuSkFY1lkU+KFzHI4Ik/1IQbyTkGI/h/ZDb60baw0=;
        b=ghh0QCywbcq9KUctQSaKs+ZzF6e5x1tsi7CRIHXbI+VxyVjv28yERT2n9Bd2auhS3C
         L0JLhdZq3yI6hteiem5oShET5qpTbX6vU0KLg/xR96SkCedgU0H1pR0H5cUP4DoVX8FQ
         GAy+AQpq+uGZnnBfJoUmIPi2AIy+X7Sw1dqDjzFFt0IBxCOYbuE9InEdf5/v3vAv66t+
         R/DEdTwIrqzbhpEjtT4nC5VEo8uyC24+gKTDYIbI7ws2j/rdgvg7bd/NZG0FUzSv/yhf
         xP4fiPZoTQtQXWJJXAJJ7GNC2JXKan8kug1kSWuQgT8x37t6IYa2G5ECC0a1u+0tnZmk
         9KUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=TzxuSkFY1lkU+KFzHI4Ik/1IQbyTkGI/h/ZDb60baw0=;
        b=DpjwrjbrrK9vR9BNNl3NVWWLzWf3AB1LQAWxeuucFZ4r+nnTz0sTZwb8fUaaNtQGfP
         zcY937W9Z6bgLUnY0dMrUm4mKOF3VQyhQ1Xh7SOT3AUQPyLIfoKaIS/S24tO4iRiyQIo
         pNoYd8up7nyV10TETeCtqC0tZBS8/oUQzpoVyN6vP5gW84cxaqEJrDiwfLV04iJqZKCm
         ALJtD5FXvl8mjKfq693KLeSMDuNOGthRGOLSGtpjec42QShpeSBdp36RFSRdV2hFOzvl
         f2D8D8BTTA4DrFoPC+3JClHsj+DfczzVO9iU8rS/TqbpP9JXu5AxjHVViF/vaAE8wcNy
         JFzw==
X-Gm-Message-State: ACrzQf3ILzuRurbOFdXI3b1tfu52c0GVlE3kRfmAtlQypYxk9NPq1N9n
	JT26GQn5cRhtZo+nYCXCFfAGl7s7gmGnFacSn/I=
X-Google-Smtp-Source: AMsMyM7s7gTrjG5ymH3U15IUsSK/Ewsk3Nv/sC9qIh/OUwZPjVtqqFjgvJyAbTuiV9RabeXQphO5cy2c2GW3Yq+W2es=
X-Received: by 2002:a05:6638:25cb:b0:35b:b1cd:c411 with SMTP id
 u11-20020a05663825cb00b0035bb1cdc411mr395294jat.308.1664382975350; Wed, 28
 Sep 2022 09:36:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220927131518.30000-1-ojeda@kernel.org> <20220927131518.30000-11-ojeda@kernel.org>
 <YzRoZwhxE4182cm2@liuwe-devbox-debian-v2>
In-Reply-To: <YzRoZwhxE4182cm2@liuwe-devbox-debian-v2>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 28 Sep 2022 18:36:04 +0200
Message-ID: <CANiq72kXHQSbGjavdOKgDK4FnGYCeC3B4ZfgZDU5KD_ZLKn7RQ@mail.gmail.com>
Subject: Re: [PATCH v10 10/27] rust: add `macros` crate
To: Wei Liu <wei.liu@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	patches@lists.linux.dev, Jarkko Sakkinen <jarkko@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Finn Behrens <me@kloenk.de>, 
	Adam Bratschi-Kaye <ark.email@gmail.com>, Wedson Almeida Filho <wedsonaf@google.com>, 
	Sumera Priyadarsini <sylphrenadin@gmail.com>, Gary Guo <gary@garyguo.net>, 
	Matthew Bakhtiari <dev@mtbk.me>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, Sep 28, 2022 at 5:29 PM Wei Liu <wei.liu@kernel.org> wrote:
>
> Just a general question: what is the house rule for adding new proc
> macros? They are powerful tools. I can see their value in `module!`
> because writing all that boilerplate by hand is just painful. Yet they
> are not straightforward to understand. It is difficult, just by looking
> at the macro, to fully grasp what the final code looks like (though the
> rsi target will help). Is there a concern that proc macro gets abused?

The rule is "use them as last resort". That is, they are not banned,
but they need to be justified: if there is an alternative that is not
too bad (e.g. in terms of ergonomics or implementation), then the
alternative should be used instead.

Nevertheless, sometimes they are very handy. Apart from `module!`
here, we are currently using them in the full repo for vtables [1] and
the Asahi M1 GPU driver is using them for versioning [2].

It is also possible to make proc macros easier to handle, for instance
if we end up deciding to allow utilities like the `syn` crate.

[1] https://github.com/Rust-for-Linux/linux/blob/fcad53ca9071c7bf6a412640a82e679bad6d1cd4/rust/macros/lib.rs#L99-L148
[2] https://github.com/AsahiLinux/linux/blob/3c8982e2c78c219bf96761445c8b73c2b3034fba/drivers/gpu/drm/asahi/fw/buffer.rs#L43-L56

Cheers,
Miguel
