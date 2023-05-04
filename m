Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1311B7C
	for <patches@lists.linux.dev>; Thu,  4 May 2023 22:28:08 +0000 (UTC)
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1aaebed5bd6so7431125ad.1
        for <patches@lists.linux.dev>; Thu, 04 May 2023 15:28:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1683239288; x=1685831288;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=14Y397b4BvvmmP2dEn/DY1zpvluNh4u4ZUFFXog6oMo=;
        b=XSfEEbqKaI4xnyRsCgpfDXeW73mBJo4ioGGPcA3EgvmnsFS4C8tVIio4NfkUMQtLjh
         3uaOCUodHmac+zBMOCMTwbb9h7W5QaMBpP/jF4F2Uo8hDxgAwaUuqtbXA78Tu97UJHUt
         zG3AgPIGvXUZI0C8Pa/oSjWdZdccqRLRck/ZBe1uQecrKD/4zMuAUPCagIwxg8e35780
         JfHE3UZ0hE180g53GzqaVTByRZhjS4wWVSlJjTbGXkz4mz0+DniXWzd8tXMetX1YKn72
         lYruzcN1QoPZT5k9wOJHBtutw5H9zq1Tf/AcXP9mAflLZup62O/48gCMoeMj/tfP/+3M
         NeOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683239288; x=1685831288;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=14Y397b4BvvmmP2dEn/DY1zpvluNh4u4ZUFFXog6oMo=;
        b=jFxl9pKAfMEryRUN7WWMXK6JtW+K2bCr3ncVKO+Mh7SoJej6qHS3cFN6mZMh8DPPNX
         paHbuHpOn+mt25W+4o4xu/mHASr9DBzhELvNNg1ph1Z/yoAm2bCVmwfbNVZcDqOxsgAI
         AvLtQJjyo1Q5A/dxYp3r/UTeLvNTMimaiKk1PLgBhJqcHwGwA2YEQDK6YHDSuUlD/58x
         Bn5aeAkAfM+HRVVPFT1zw3+VxfL7V49zVCnFv1mXzQuioOutv+iC1Ryv4L9I15X30Ch3
         2aaAaQuZ901j8FoxpCJewFAEDiAFTvZh1SldrK+mIA65s3jpaWXo9YOD/ixuLZnT/+jD
         AtCQ==
X-Gm-Message-State: AC+VfDyGBbW2yDpOAK5DKk1TFdVFIHkdVnybm0u98j6jICwGnml6Ytgn
	GM6JGWOsjdT9cmLnwhFDHpix/aUx8OJo1kwP+WpWNQ==
X-Google-Smtp-Source: ACHHUZ6r8wbeiVxPGDv1nvrWX0mu3liDZBBew1HY0J11ZfzafuKGlLj7woEc5lgEFX8fsZihe/a8kRXXcvNFMYOZLz4=
X-Received: by 2002:a17:903:44b:b0:1ab:f74:a111 with SMTP id
 iw11-20020a170903044b00b001ab0f74a111mr5019402plb.63.1683239288468; Thu, 04
 May 2023 15:28:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230418214347.324156-1-ojeda@kernel.org> <CAPDJoNsG1E25yYM+L_H21vVCt-5S16etx3KMxx8ySZtWMQt4FQ@mail.gmail.com>
 <CANiq72mtb9V+1a7nPEHBCeg_fob4rpPTWJZjdahnGL2Mg3uoUA@mail.gmail.com>
 <CAPDJoNvGQBNN6X6fs26tjUy7LbpJjWwPvQuf=1+nSwj94aa6LA@mail.gmail.com> <CANiq72m7zdYo566PxX3g03+XPpHnrQy7GG9WkgEP82mK_2JBpw@mail.gmail.com>
In-Reply-To: <CANiq72m7zdYo566PxX3g03+XPpHnrQy7GG9WkgEP82mK_2JBpw@mail.gmail.com>
From: Fabien Parent <fabien.parent@linaro.org>
Date: Fri, 5 May 2023 00:27:57 +0200
Message-ID: <CAPFo5VJpGq70X6efWESDoCYE3J0pjgMB1c7X_ACA4Q9MxnoHQw@mail.gmail.com>
Subject: Re: [PATCH 0/3] Rust 1.68.2 upgrade
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Ariel Miculas <ariel.miculas@gmail.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Josh Stone <jistone@redhat.com>, 
	William Brown <william.brown@suse.com>, Georgy Yakovlev <gyakovlev@gentoo.org>, 
	Jan Alexander Steffens <jan.steffens@gmail.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Miguel,

I'm getting the following error when running rusttest on top of your patchs=
et:

$ make LLVM=3D1 RUSTC=3D/home/fparent/.rustup/toolchains/1.68.2-x86_64-unkn=
own-linux-gnu/bin/rustc
RUSTDOC=3D/home/fparent/.rustup/toolchains/1.68.2-x86_64-unknown-linux-gnu/=
bin/rustdoc
rusttest
  RUSTC L rust/uapi.o
error: the feature `core_ffi_c` has been stable since 1.64.0 and no
longer requires an attribute to enable
  --> rust/uapi/lib.rs:11:12
   |
11 | #![feature(core_ffi_c)]
   |            ^^^^^^^^^^

After manually removing line 11 in lib.rs, the error was gone.

Fabien

On Thu, 20 Apr 2023 at 19:20, Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
>
> On Thu, Apr 20, 2023 at 7:18=E2=80=AFPM Ariel Miculas <ariel.miculas@gmai=
l.com> wrote:
> >
> > Yes, I've edited the commands since I've run them out of order, let me
> > include the output of commands and my general setup.
>
> Thanks for confirming! (and for all the output!).
>
> Cheers,
> Miguel
