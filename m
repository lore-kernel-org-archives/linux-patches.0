Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EFB31640F
	for <patches@lists.linux.dev>; Wed, 31 May 2023 21:27:43 +0000 (UTC)
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-4f3a611b3ddso1831862e87.0
        for <patches@lists.linux.dev>; Wed, 31 May 2023 14:27:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685568461; x=1688160461;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HmGRIWXBp3HvZBL8UWz5wMSP/7nqOL/RMhMi6KYkHks=;
        b=FcpN/mh8cXkbNo+CIlVmIrUGdutwSm4/R1pMOT/IyhLP+I83WWkChubz9sfDC/kuqn
         p7ClzAQ65KzsACCu+go1zZnqt7FGXsQS2bKayXgqP5hTAGnw3ZhXiEAtzzer0JEebME3
         xNvkJ6uLwkzGJmK9wKQvaaXrdsRciyVbm8Tc8YkIZZGKb50hTzblYXsFAccwUJuEDFFf
         WvEAFs+kFyw0zQ7LVmb9PatmBSVjAN8jVT9wvu/qDzAmbYuNosmc2bJEYhox7rXQlett
         tMGDHOphJoUjepHjumcdOJ6SBH2x8F171xzexjuDB8zn2xYF3267ebNlMvvdEqd5W7wi
         Op8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685568461; x=1688160461;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HmGRIWXBp3HvZBL8UWz5wMSP/7nqOL/RMhMi6KYkHks=;
        b=Qa9AccgSXbjXzydXOedbuotg5o7CWAbcvW1aqrMJVc4XcRLJbZD9nZIT3qGrKa7YYm
         AntEI2WHedcadGipvA6e8w8j/G1U1eHsj+HASpHrClOdqqVLBYjUyK7hCmeKFY30TL7e
         +aQbxu1ey5G0ljq8Y3IyJty4KGHf7omkvoQX6kg9gzVzIK5b06ZKOkYGvMDTyK+qPBac
         mOhPe9Xz3I6UXKs354zH9NZXdcN1hwyXcymlBzgIZm3CRh4erJWxUIvDBDGedde5VJqh
         G9ykHbWuwlDzwWGXYQBQdHWYSw0GSS3TQy9K9UCTNucXsKRP1VLkQQlDLQwsJHgfDSf+
         8ynA==
X-Gm-Message-State: AC+VfDz9qr3wYctyN6fd4pIDSRNyncikgQBJ4rsEea16aDVGpGjWJxIL
	qH/W+9WB/P10baqpwrlJy3i7iGpJ14FuJLnLqWw=
X-Google-Smtp-Source: ACHHUZ5Xg3flrGOmNSIrwETWIc0iScTUfmpexxAf15uqKG+Hq+PHPLzlZ1IpahHdKGlwqsGnFkKrYJ82lMO98YSQTr0=
X-Received: by 2002:a05:6512:4013:b0:4f3:a763:ccb7 with SMTP id
 br19-20020a056512401300b004f3a763ccb7mr122967lfb.2.1685568460892; Wed, 31 May
 2023 14:27:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230531174450.3733220-1-aliceryhl@google.com>
In-Reply-To: <20230531174450.3733220-1-aliceryhl@google.com>
From: Sven Van Asbroeck <thesven73@gmail.com>
Date: Wed, 31 May 2023 17:27:28 -0400
Message-ID: <CAGngYiW_3HfebWZO5S=RXFqhNnsbnix-NaA0UGYRnRLd4SK65w@mail.gmail.com>
Subject: Re: [PATCH v1] rust: error: integrate Rust error type with `errname`
To: Alice Ryhl <aliceryhl@google.com>
Cc: rust-for-linux@vger.kernel.org, Miguel Ojeda <ojeda@kernel.org>, 
	Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, Wedson Almeida Filho <walmeida@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello Alice, as we discussed through a separate channel,
you have my permission to use my name in
Co-Developed-by and Signed-off-by tags.

On Wed, May 31, 2023 at 1:45=E2=80=AFPM Alice Ryhl <aliceryhl@google.com> w=
rote:
>
> From: Gary Guo <gary@garyguo.net>
>
> This integrates the `Error` type with the `errname` by making it
> accessible via the `name` method or via the `Debug` trait.
>
> Co-Developed-by: Wedson Almeida Filho <walmeida@microsoft.com>
> Signed-off-by: Wedson Almeida Filho <walmeida@microsoft.com>
> Co-Developed-by: Sven Van Asbroeck <thesven73@gmail.com>
> Signed-off-by: Sven Van Asbroeck <thesven73@gmail.com>
> Signed-off-by: Gary Guo <gary@garyguo.net>
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
