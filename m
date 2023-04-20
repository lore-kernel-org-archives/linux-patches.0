Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E66C8492
	for <patches@lists.linux.dev>; Thu, 20 Apr 2023 13:20:06 +0000 (UTC)
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-54f6a796bd0so39745807b3.12
        for <patches@lists.linux.dev>; Thu, 20 Apr 2023 06:20:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681996805; x=1684588805;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GNWH6oFsPxt4uPBf5ZSd4rkNU90YfqXsmZC9RT6Nk4w=;
        b=iBt7XnIlW5ja5FIDgbzbXy90Z5dz+WEqL1GT5rddfr4IDXDBglyDQqL4MB3d5wV79O
         72WaiSC031h4s62DtdESzUHchGzdGsLEEZB3gkKiHP4P4QE6zXkkNfBsK/y91Wg1j6We
         p7AIjuCPht+pvxNVK++2byKRkYY48tFcv2pbfG0lW6jCN+vV6VtQiwt7sYxpRxr1N3BI
         Lvv4EeickuOUPtUEQb0T1dkxPCFzPtUueuiozLiIPscAtaIuop9+mk/+qln+j5blJS6R
         SCq13GOqi/uUtHoAw40p4I8fQE8DVKqpzbdWYqn4U+Qn77EhdAzZOvoGgHmLRHQBHDux
         MLjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681996805; x=1684588805;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GNWH6oFsPxt4uPBf5ZSd4rkNU90YfqXsmZC9RT6Nk4w=;
        b=AbIjayGkOMqj6n2XtdkxZXJap/9CKDCgSKPgzHsobgsSjPl4TFjr6AFypL705pUdXW
         eg+qM8hJrighoq9DHSdbcKA0yap5k+dFkHiERucQGip3VvmER+zED81QXkHPN00xEpHi
         7RL3ao0lmBZUMzSJiiumnCqCBZeaAzHttJYMEdnBZRSmw2rLJMZN2q7T6NWALBawDXwY
         xAKlGmghe/wVoWNyXAchUScftWJ8G4WEVgL0R6L7My3N9IoQIS3ZjAL0+2P8a9wA8Ux0
         vFTkmGrcAJ55K1L74JYmnamsXMIYr1btrYUuuFbw2+2sgA9ZRcZwISo4MkZd8hN/ip1B
         cQAQ==
X-Gm-Message-State: AAQBX9cspbyC27FukKJHJP/oVdBAvDCXMChQuB6YeliChXVtcckD+g3C
	l1JPXajvYehib5zh7Ysvdt9/mYzVfsle7oW+Phc=
X-Google-Smtp-Source: AKy350Yna17ciObxlr7T445+ng1yrw5kvVgZMoxKaKzazogoVuc+cNXRmbuMczDLtoYwXPnB4yL2NRiFKi3fLM1VgfE=
X-Received: by 2002:a0d:df50:0:b0:54f:a5ed:1978 with SMTP id
 i77-20020a0ddf50000000b0054fa5ed1978mr754804ywe.38.1681996805473; Thu, 20 Apr
 2023 06:20:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230418214347.324156-1-ojeda@kernel.org> <CAPDJoNsG1E25yYM+L_H21vVCt-5S16etx3KMxx8ySZtWMQt4FQ@mail.gmail.com>
In-Reply-To: <CAPDJoNsG1E25yYM+L_H21vVCt-5S16etx3KMxx8ySZtWMQt4FQ@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 20 Apr 2023 15:19:54 +0200
Message-ID: <CANiq72mtb9V+1a7nPEHBCeg_fob4rpPTWJZjdahnGL2Mg3uoUA@mail.gmail.com>
Subject: Re: [PATCH 0/3] Rust 1.68.2 upgrade
To: Ariel Miculas <ariel.miculas@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Josh Stone <jistone@redhat.com>, 
	William Brown <william.brown@suse.com>, Georgy Yakovlev <gyakovlev@gentoo.org>, 
	Jan Alexander Steffens <jan.steffens@gmail.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 20, 2023 at 3:13=E2=80=AFPM Ariel Miculas <ariel.miculas@gmail.=
com> wrote:
>
> $ make LLVM=3D1 rustavailable

Since you showed the output of the other commands, did this one show
"Rust is available!"? I guess so -- I imagine you edited the commands
for the email, e.g. the config changed too.

That is fine, as long as it works as expected :) Thanks a lot for testing!

Cheers,
Miguel
