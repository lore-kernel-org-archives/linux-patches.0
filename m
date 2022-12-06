Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C86915CBF
	for <patches@lists.linux.dev>; Tue,  6 Dec 2022 15:45:05 +0000 (UTC)
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-381662c78a9so156233667b3.7
        for <patches@lists.linux.dev>; Tue, 06 Dec 2022 07:45:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=xyn/5OOpj6fuvvU8fDY8RxPX62J9zsQGOj41hMQD++E=;
        b=k8z+ItRXCJIZn49dArRvY9i2iLkbpKITT2yKWV7GhS15NtPNWTLX4W9gPJiA+n5QUF
         NcxMp5umXW3D3lkSQYDFn7B92I7NQD79r09dTxc83Lmc5+iZ3mZf0H9JklZhxWkedCCx
         RpF9jzuAYx3dFugt2ZfmjVuwhv5hqi8kn+Bk1Rxc5NQ3z4D7cd+oL1Lwu/EiiXu2VG+Q
         C5bKbdEhWEhJd9hsfJdsXVrnwteuyekAYTIGcYnp6jX96HE1/jDe93IFNfCY7116GX7k
         yFIipMpUPbzTNYVwr6pmiOnumxQXAfCg1qlTYyF8vX5PXphOLeKRirj5QQ7lXXVb12Ww
         A9Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xyn/5OOpj6fuvvU8fDY8RxPX62J9zsQGOj41hMQD++E=;
        b=JuF7EhvHTH/N/xUbG9EqiEqcNamMnmzsacytczb7F90ctK2QxOUv+++ToVOWt3djje
         GYFFOqTbCisUu7XXCPzZRmoekDE+FjDAKLvEUTBVCu6KFp9ECt360zdCczycii4KaPVp
         sa7jOYg3arO/iowP7ByKb+L5c0xath23KFERCsP9I+fMuuEh218Z2FdGG/m+pZ55vUPz
         ZqvCdfJ6pz3y2phbg6f+NCQzBRcjJXbX4Ju7QiuUuy+kuFG418sS35wkTlNMGkzw06cS
         2wjOHZgdyjpDaW/h9TgCYo5XME+1aVEkOc8jSiqgpbUCa797ZlOmkPrfudgfiu8++CNp
         IE5A==
X-Gm-Message-State: ANoB5pl3hiJbFNUl0UMyW1cs3x9IiAwMnconrP+vPVEVoHG7xXq9ONnF
	SnMzyVBIChNqaJbz/2WgpEkPdpzeOzjiMABPG2Q=
X-Google-Smtp-Source: AA0mqf7yhwfAtr/XG/SmzqtvjyIx0HdmN3mODQ5NsTqnY7yPgIynig5Nt7kqbdksBf+abg/7ApTsX1Zkryio5SQeUns=
X-Received: by 2002:a05:690c:b03:b0:3f4:6e40:89c3 with SMTP id
 cj3-20020a05690c0b0300b003f46e4089c3mr4057837ywb.266.1670341504250; Tue, 06
 Dec 2022 07:45:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221202161502.385525-1-ojeda@kernel.org> <20221202161502.385525-7-ojeda@kernel.org>
 <982F921F-08BF-43E3-95F3-20329AB59A69@nyantec.com>
In-Reply-To: <982F921F-08BF-43E3-95F3-20329AB59A69@nyantec.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 6 Dec 2022 16:44:53 +0100
Message-ID: <CANiq72ncU_LcNgFBgLorHgiaP1ybGrtvi=xrNittX47n2WE5JQ@mail.gmail.com>
Subject: Re: [PATCH v2 06/28] rust: macros: add `#[vtable]` proc macro
To: Finn Behrens <fin@nyantec.com>
Cc: ojeda@kernel.org, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, 
	=?UTF-8?Q?Sergio_Gonz=C3=A1lez_Collado?= <sergio.collado@gmail.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, Dec 6, 2022 at 1:50 PM Finn Behrens <fin@nyantec.com> wrote:
>
> Reviewed-by: Finn Behrens <fin@nyantec.com>

Thanks a lot for these, Finn -- I already queued the patches on the
weekend, but if for some reason the series needs to be dropped and
reapplied, I will pick your new tags.

Cheers,
Miguel
