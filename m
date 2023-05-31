Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com [209.85.219.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 853E117736
	for <patches@lists.linux.dev>; Wed, 31 May 2023 17:09:25 +0000 (UTC)
Received: by mail-yb1-f181.google.com with SMTP id 3f1490d57ef6-bb15165ba06so883658276.2
        for <patches@lists.linux.dev>; Wed, 31 May 2023 10:09:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685552964; x=1688144964;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UqDH4yuf9riVSA5V9W66V8AzL16NatN+7DvngwJVYHQ=;
        b=caLGCJsLWoGXEsdVIpGLUQt+zeJNOVI+LboWHPMIqBJWAnIgJ+242auCr4nUiBn5Mk
         hBnHQEitvKnQqFL7tBD57Xzc92LoREi2W2dR4C9s13QGZFqO520W4FweLarNlIDsUoTM
         p2zOOCZowyHijyUm0/VLa6QGp6JAMH8wfdoEKVdVVNMj42qxckZh/zr1oNhzYTXBn5cd
         67OcyM5lpazmLs8sZawR0AQvVA2c+LPakLZ3RlpDosOT9Y1dNwB2rm4dI/2sxnRirlSX
         MY5FdLAsdIEzXF38+2el4+6sXBSAQtN4Ojvd6vUtxr54YVSybND6VdspTprwDnNqvIqq
         wZ3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685552964; x=1688144964;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UqDH4yuf9riVSA5V9W66V8AzL16NatN+7DvngwJVYHQ=;
        b=DnMEQHsYbvNoyIu/HNNvfUyZCD2yN4OnP0/Hu2JgtI8E4lTVSBHFeIpqFEkIht3g+3
         HDuHmyMATdj2Bx4PpZvwtGzE3rWCVlJCoDAqAo41cwn0ByiwDqP/5IE0jme3Y5gaHaf3
         oULl1U0WKsEEcgAbqfk9BvXQOFJIu8fOw5lH3Y+Z3jFCQcu6RIC8yiPvO3vpq6B6Vycg
         71NKZoCRET6GxbfGvK5YLpSTfswOcYKOjuXzg+Wgkh3E2Bg+jE29knQHgrai+xF2jDVY
         R8DyKIHwSej7lB6+9DC26uQlyVKyxIBcq2Jd20BPybfbg1qUJ3CT225D6vJyyJz4u6JX
         1GAw==
X-Gm-Message-State: AC+VfDxm2msaaHVxBdwjzorAfFkfDULH6Mc6wBe7zSHUk65J8ugUDNAT
	BLWihclVyDl8J1v7oINc/Z6KSGv1L7cX8fAJ+0Q=
X-Google-Smtp-Source: ACHHUZ6YRP+7GOjalS/xwoylUY0eFkX8MPFV32qCf9SvGRbSl26p2DWv6GCFWqaC5hFnT6ZojaI6Kh3uKPqGow4WfEI=
X-Received: by 2002:a25:f80e:0:b0:bac:f582:eefd with SMTP id
 u14-20020a25f80e000000b00bacf582eefdmr6912007ybd.35.1685552964512; Wed, 31
 May 2023 10:09:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230502124015.356001-1-aliceryhl@google.com>
In-Reply-To: <20230502124015.356001-1-aliceryhl@google.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 31 May 2023 19:09:13 +0200
Message-ID: <CANiq72=zXOqvdttGjxGrbGoNvyz=QNb5sCE1FKROgKo5yEkfBQ@mail.gmail.com>
Subject: Re: [PATCH] rust: error: allow specifying error type on `Result`
To: Alice Ryhl <aliceryhl@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 2, 2023 at 2:40=E2=80=AFPM Alice Ryhl <aliceryhl@google.com> wr=
ote:
>
> Currently, if the `kernel::error::Result` type is in scope (which is
> often is, since it's in the kernel's prelude), you cannot write
> `Result<T, SomeOtherErrorType>` when you want to use a different error
> type than `kernel::error::Error`.
>
> To solve this we change the error type from being hard-coded to just
> being a default generic parameter. This still lets you write `Result<T>`
> when you just want to use the `Error` error type, but also lets you
> write `Result<T, SomeOtherErrorType>` when necessary.
>
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>

Applied to `rust-next` -- thanks everyone!

Cheers,
Miguel
