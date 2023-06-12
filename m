Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6856D5229
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 19:04:45 +0000 (UTC)
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-6b162127472so2718101a34.0
        for <patches@lists.linux.dev>; Mon, 12 Jun 2023 12:04:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686596684; x=1689188684;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8OOA/ytQLN+B3gWqHcQscrH2RGfHUDPpsGBgPoTwMwU=;
        b=mqmplgHYcbdHCEUJBJPwAOzEH/KkA5KlZpIohsz5YZEbmJGpEnMObhD9cebeOTpo+E
         uuIT92aZjFYZivmy5hQVJHX8fJFJDPUVMx1aYMVEHgA4At2pgLE3V053Wb/t2L8Gb8GO
         a/kwFV/O3Ef/8b2fADgHY32cyyyO/dTmTsutoQYiejCaccDScUBH60nXHRTlfjTl3LGt
         AF/pb/yU9DYO+kjNLenmrA1nRXJMpNwQggfrSTbC+9AS0m92c9DL6Ms+A3/wOVAej0EK
         lNybC0/qHKkH+rFA9cMlXEE4QLyS6CVZXzSTYOyHm3XMG24Mjiq5BfndBHNwMyXlQ/Mg
         QLKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686596684; x=1689188684;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8OOA/ytQLN+B3gWqHcQscrH2RGfHUDPpsGBgPoTwMwU=;
        b=IZAx6ZCIRHLtx1nW7U/QaQoyI10cNM4S6yZwRlrkw0J3bqfPNOIFi6as3euVcRzhPt
         Ty2usAgKy62YEhFkmlJzXJcyzt7Fl8xaKo+7LysvrrhW4J1tHwEbbh0pvEydKycqZIyk
         hf2ZrVVxEiVPKfppcbgUjy3xTsq1jP00l+zoWVbKWc//GaNV5Ir0S1WXfqWEn5tYEnnH
         Eo55bR9TbnPOK/1i+SBnb6QSmdzvAh2IHACISM9USo4jgir11KDuD7PXZQrTjYrEByLC
         pgfTCKR7X1ClH++yX86BwpVSaJkK6xysrbq55wp8ILJWvhcfARGhrQTNZ3CaK1LvaavT
         7Flw==
X-Gm-Message-State: AC+VfDyorgM9hafm9/ebTXGWoUBGcGBSmJMrcm1oAcrFVWZyowp7HqRY
	6FfdKd9ZxT2zU/yK1JSEMO6Smrxni0rOvaLp6O4=
X-Google-Smtp-Source: ACHHUZ5kJ9Ts8hH1r36b3HYZo25DalArBDj1PkqRJv6R/2FQYkSp/gjvpguhX/6PkBYsyURQiz7scSpqX4offUdreoc=
X-Received: by 2002:a9d:7acb:0:b0:6b0:73fe:cf10 with SMTP id
 m11-20020a9d7acb000000b006b073fecf10mr7185541otn.5.1686596684199; Mon, 12 Jun
 2023 12:04:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230531174450.3733220-1-aliceryhl@google.com> <CAGngYiW_3HfebWZO5S=RXFqhNnsbnix-NaA0UGYRnRLd4SK65w@mail.gmail.com>
In-Reply-To: <CAGngYiW_3HfebWZO5S=RXFqhNnsbnix-NaA0UGYRnRLd4SK65w@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 12 Jun 2023 21:04:32 +0200
Message-ID: <CANiq72=DJBW82L44icrrTo=_jrv=BS3cd10s6WuraXX7suW4tg@mail.gmail.com>
Subject: Re: [PATCH v1] rust: error: integrate Rust error type with `errname`
To: Sven Van Asbroeck <thesven73@gmail.com>
Cc: Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, Wedson Almeida Filho <walmeida@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 31, 2023 at 11:27=E2=80=AFPM Sven Van Asbroeck <thesven73@gmail=
.com> wrote:
>
> Hello Alice, as we discussed through a separate channel,
> you have my permission to use my name in
> Co-Developed-by and Signed-off-by tags.

Thanks a lot Sven for the confirmation!

Applied to `rust-next` -- reworded for clarity. Thanks!

Cheers,
Miguel
