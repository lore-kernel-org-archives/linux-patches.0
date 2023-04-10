Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com [209.85.219.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B04723D0
	for <patches@lists.linux.dev>; Mon, 10 Apr 2023 22:55:09 +0000 (UTC)
Received: by mail-yb1-f179.google.com with SMTP id i20so9896281ybg.10
        for <patches@lists.linux.dev>; Mon, 10 Apr 2023 15:55:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681167309; x=1683759309;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6ZMGcCTlE+zHI0tSBZIhG1RUtOrAXSPTg9DRTosSr84=;
        b=V3AWAMswbv3KXy6gRUE5e6i77GX2Q+KHI2CeJXconURp7tnipLoUMF58wfer5mZ17Y
         J0VlEPLxrm4P7JMb2jf2LRYsweR1vII1OMHBAIsV/m21CWfMtnhyeBi+nmysrBGAmxkM
         kfXA7lG2HLxrIo3C3GZhvLaFkFUAF+J9NMl3ACDvClw4ox1ahgrmi88q26dyoFrqgyxY
         KXM8Nqyw/R1AcSiAlaWbP9gc7NciM3gsYxJqH85E5qY5pi/3b6v8OBIedR4W4eOYkfUZ
         jPbpkcYr2fvh0q5EQ78E2aZnFDWdKKoNRUqVfbg3fluu+6hLm5YAYxtBAr88exiruGYj
         hQSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681167309; x=1683759309;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6ZMGcCTlE+zHI0tSBZIhG1RUtOrAXSPTg9DRTosSr84=;
        b=EnU4NMgs9oC/Vu/GgyLKN61duNUxMn9xLCd6NJQnsuklf5PD6FN2OZLZMG4klNGmiY
         EI990d/SC6eEzNj1n2I5QF42Nk1sqGw56mq6t9lu5SPbuMso9biPbHrfPYzciPfkrZPi
         nnjXyAnYsKZBYY3m8/pEYoYGM0Hn6g61v0M+9NpznhvQSlyL3py5AyTGNbw9BHSIclPx
         e/SAhsL10hRaF/YglpG8qZ9R89sIV1eU5ytztK0OqGiUYk1qYLiG85n2ldg13nclSC0C
         eBKoNk1Mb6NVrO7fdYROGYHCty4FOywwZN2eS4ssNlcnWefN9hkgQaxAAQ4Jvhj5S5z1
         7KxQ==
X-Gm-Message-State: AAQBX9fpa4h2woiZboUzL+TbhJeEQaNQqxk4RaZDFiBz+zkKwyAGVeX7
	DvzokT2rXMHHCqGdvj80PtbvTD5jFajqICAL3CY=
X-Google-Smtp-Source: AKy350bgn7KVMwsTMtrTJFSi6z+5NSo5iZGnhQdP/RRXvV29DIqkb/r7UGXavV9Ze5Tc2GnK0BI5Z+OuzTjwVW6f1f0=
X-Received: by 2002:a25:d4d1:0:b0:b80:2bf9:2f78 with SMTP id
 m200-20020a25d4d1000000b00b802bf92f78mr8219512ybf.11.1681167308928; Mon, 10
 Apr 2023 15:55:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230408122429.1103522-1-y86-dev@protonmail.com>
In-Reply-To: <20230408122429.1103522-1-y86-dev@protonmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 11 Apr 2023 00:54:58 +0200
Message-ID: <CANiq72kQ95gLdfSMNNbB5qn2WdJ7ujbXFwTpuHJQLK8v-qha6A@mail.gmail.com>
Subject: Re: [PATCH v7 00/15] Rust pin-init API for pinned initialization of structs
To: Benno Lossin <y86-dev@protonmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Wedson Almeida Filho <wedsonaf@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Alice Ryhl <alice@ryhl.io>, Andreas Hindborg <nmi@metaspace.dk>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Asahi Lina <lina@asahilina.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 8, 2023 at 2:25=E2=80=AFPM Benno Lossin <y86-dev@protonmail.com=
> wrote:
>
> This is the seventh version of the pin-init API. See [1] for v6.

Applied to `rust-next`. Thanks!

The `assume_init` patch was dropped from this one as discussed
elsewhere with Lina who sent a similar patch, which required adjusting
that patch's `SAFETY` comment. I also applied the `Reviewed-by`s from
here to there since it was essentially the same patch.

Cheers,
Miguel
