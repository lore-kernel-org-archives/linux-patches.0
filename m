Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D56C0256F
	for <patches@lists.linux.dev>; Fri, 31 Mar 2023 12:03:46 +0000 (UTC)
Received: by mail-wm1-f45.google.com with SMTP id n19so12754765wms.0
        for <patches@lists.linux.dev>; Fri, 31 Mar 2023 05:03:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=metaspace-dk.20210112.gappssmtp.com; s=20210112; t=1680264225;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=IRLPm58nvNy/2NFW9neC7Qw5GTvVFQCMvaYOxcSEPmA=;
        b=0BgaJCtMEiEOlcg8O3FcHhdaMk9i73ICEwE5v97F1WAbUlcHbQnGsqNMz9brTOGwyr
         JSHjHjyl4I1quIv6hVdfYZBXMJt/hodKk8vQRw7fbnZXx1kNutcXsYfDvjTIKw9VUr4m
         e49tfQLIXGiv7p/nWI2pIOswlc1F6NypOwJKw8EGiBfNuwnd9rKsmmT1T1pie39aHKPb
         d+ACBxPozHIeMPMwYWMX8eaJDVATpJZErWLknavTpM4kt0FHdieULuMZOm+9IiyQh/5u
         U50IcPWGOsih/HqfdWiEoOqYF6z1gIslXeGClJI1zaDEHNR1BEeO/3y/lpul5YdUU71K
         v25A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680264225;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IRLPm58nvNy/2NFW9neC7Qw5GTvVFQCMvaYOxcSEPmA=;
        b=Osk3rtix03yPi49VX2ukDIOgM5gsaKV/Mcz0/iDLKmhN5EkYAaTEooYnO36E/jDIjG
         o+opNKdIrJN7hXrzJXxAlm+UPyIZa6lOV5dQLjD9F9kA329LmC59DxreVqNEJpAVGdQJ
         r1vcYLPNpGsSPFj4Eoqrxo6bk7yJvWcvbGfXwZxzLcTRQWdsNnXpcJUuRvgYNgJyEdZE
         FfA3uhWtxt3acwPQPRbdpxdZF5dSAX91d6QpOKuZY5ESLh/KGj041Qh4uxhjUPjNrMMT
         AVgyrznX4s3b7mJLIj3Zw6a30l7yArNRI6C7ggzEAe4OyPw9JFjD4Nm1D+xoB/pZ3NUQ
         DrrQ==
X-Gm-Message-State: AO0yUKWyIQVPYuTKKJ/lqPBQYFPPWpVM7UxZZvHs0OZ4STGKI2BjDObI
	rA5LHXVcjFNBPAtJ5P9LhQMD8A==
X-Google-Smtp-Source: AK7set9z+4TYwXvwxxS/ReumUqCrNxDNO7RSbX+Xb7eBl+H7zYeDXuRhsdk3E1jRdTpdbc8wKebjAQ==
X-Received: by 2002:a05:600c:218d:b0:3eb:29fe:f922 with SMTP id e13-20020a05600c218d00b003eb29fef922mr19875265wme.29.1680264224939;
        Fri, 31 Mar 2023 05:03:44 -0700 (PDT)
Received: from localhost ([147.161.155.91])
        by smtp.gmail.com with ESMTPSA id i2-20020a05600c290200b003edc11c2ecbsm2517307wmd.4.2023.03.31.05.03.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 05:03:44 -0700 (PDT)
References: <20230329223239.138757-1-y86-dev@protonmail.com>
 <20230329223239.138757-6-y86-dev@protonmail.com>
User-agent: mu4e 1.9.18; emacs 28.2.50
From: Andreas Hindborg <nmi@metaspace.dk>
To: y86-dev@protonmail.com
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>,
 Wedson Almeida Filho <wedsonaf@gmail.com>, Boqun Feng
 <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn?=
 Roy Baron
 <bjorn3_gh@protonmail.com>, Alice Ryhl <alice@ryhl.io>,
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev, Andreas Hindborg <a.hindborg@samsung.com>
Subject: Re: [PATCH v3 05/13] rust: init: add initialization macros
Date: Fri, 31 Mar 2023 14:02:47 +0200
In-reply-to: <20230329223239.138757-6-y86-dev@protonmail.com>
Message-ID: <87o7o92km7.fsf@metaspace.dk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain


y86-dev@protonmail.com writes:

> From: Benno Lossin <y86-dev@protonmail.com>
>
> Add the following initializer macros:
> - `#[pin_data]` to annotate structurally pinned fields of structs,
>   needed for `pin_init!` and `try_pin_init!` to select the correct
>   initializer of fields.
> - `pin_init!` create a pin-initializer for a struct with the
>   `Infallible` error type.
> - `try_pin_init!` create a pin-initializer for a struct with a custom
>   error type (`kernel::error::Error` is the default).
> - `init!` create an in-place-initializer for a struct with the
>   `Infallible` error type.
> - `try_init!` create an in-place-initializer for a struct with a custom
>   error type (`kernel::error::Error` is the default).
>
> Also add their needed internal helper traits and structs.
>
> Co-developed-by: Gary Guo <gary@garyguo.net>
> Signed-off-by: Gary Guo <gary@garyguo.net>
> Signed-off-by: Benno Lossin <y86-dev@protonmail.com>
> ---

Reviewed-by: Andreas Hindborg <a.hindborg@samsung.com>

