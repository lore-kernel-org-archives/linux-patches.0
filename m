Received: from mail-yb1-f182.google.com (mail-yb1-f182.google.com [209.85.219.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F364514294
	for <patches@lists.linux.dev>; Wed, 31 May 2023 17:11:42 +0000 (UTC)
Received: by mail-yb1-f182.google.com with SMTP id 3f1490d57ef6-bacf5b89da7so8639397276.2
        for <patches@lists.linux.dev>; Wed, 31 May 2023 10:11:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685553102; x=1688145102;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ebXJVsSOUn2ugmT4rghMz7fEudpo4P8yANA/KrthHSQ=;
        b=rWOXBBOyOrBpuPMg0lDoyufRLZkgu0GznDnPFyWVtJFifHw7Tw6NjeMYjynx7qz/46
         SbPowBCnn5Lk0cECatibpEFOHYw25O9dkF8KZTssbGCQvS2bETkGgaFsDoPaVQFCgFF8
         1Ag+EMJveJF1qPYsr7gYEYsuMPnSYtYucxdk8ZEODhO03hSbn8SKM+wKE5ZTsAfKfoGz
         TRKvv0kCsk4cQuTvEyzYhPpwcN13N2MsgYpBhyqaUG77IHqcoPNzESguACv0Xag1z7x+
         2rNMIFLpeUGL9PyE50gUuhWvoXnhXrmkTinHm30tpSKqm/dDqJU2GcxhmqFSrmAG1rnM
         xVJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685553102; x=1688145102;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ebXJVsSOUn2ugmT4rghMz7fEudpo4P8yANA/KrthHSQ=;
        b=BwhvDw0/GhiMxqcP9KQiljJUt8mYkz8MrGd+crv73K/dJUW3rLibnPYiCpUUNlt9i9
         GIFLXXVaZGEQehOkI11RJyut4EDoXL40l3mi3/8+rd2B9OMIV762V7lHX5JlLGsAogmw
         snMJS0D5PgZaXfo4NIzLcvc+IOl/3UYUjoU60On8EZflJaaey7N8lTcYVITiGrKUmW0j
         rLTHki0qYiqXmoa2QFQ3dPW97huVwBipBU43iNyOSkw7VrT7UbbQE01zFC+UCOvQYsuS
         RWgp6eDwk6FEKTiAnfyVMFLYWoTHlyqKidFzWe49t3IekpPmhtFX7eibmWmDTJUrSYmu
         grFg==
X-Gm-Message-State: AC+VfDxWpqHcWDWV+v3+mTfIxeaSlNgbaoVNI6TjNFO1+uznYPFrwLKT
	JZOE5878+rcCgEEZI8plKHY7B+2z7C3v1IUVYY0=
X-Google-Smtp-Source: ACHHUZ70MMpnGtaiZiK8Wa0uRar/BTF3XWEcNJkZ9HluytIz1Q1g/E693M33BQVNFcwmkJ0i279u/zrdRM/51wlt1/8=
X-Received: by 2002:a25:af54:0:b0:bad:13c4:3070 with SMTP id
 c20-20020a25af54000000b00bad13c43070mr6775546ybj.47.1685553101927; Wed, 31
 May 2023 10:11:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230504064854.774820-1-aliceryhl@google.com>
In-Reply-To: <20230504064854.774820-1-aliceryhl@google.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 31 May 2023 19:11:31 +0200
Message-ID: <CANiq72=S+gUXcsp1k1ZUnRbsecnP5KCKVW-tJoqZB_NsT-2K+A@mail.gmail.com>
Subject: Re: [PATCH v2] rust: error: add missing error codes
To: Alice Ryhl <aliceryhl@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 4, 2023 at 8:49=E2=80=AFAM Alice Ryhl <aliceryhl@google.com> wr=
ote:
>
> This adds the error codes from `include/linux/errno.h` to the list of
> Rust error constants. These errors were not included originally, because
> they are not supposed to be visible from userspace. However, they are
> still a perfectly valid error to use when writing a kernel driver. For
> example, you might want to return ERESTARTSYS if you receive a signal
> during a call to `schedule`.
>
> This patch inserts an annotation to skip rustfmt on the list of error
> codes. Without it, three of the error codes are split over several
> lines, which looks terribly inconsistent.
>
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>

Applied to `rust-next` -- thanks everyone!

Cheers,
Miguel
