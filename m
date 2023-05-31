Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AD7C171C4
	for <patches@lists.linux.dev>; Wed, 31 May 2023 17:05:21 +0000 (UTC)
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-6af6f5fc42aso5631347a34.1
        for <patches@lists.linux.dev>; Wed, 31 May 2023 10:05:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685552720; x=1688144720;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gnVlMYKUBLV9HUzSs68t1blEmRLxmElAxhgHhe4Ab6g=;
        b=LObu1CyQEOgrJqwtg8BIxxNa9IyYSEU6G4ejrrgtIh0hV4Z4M2MfgfeXFzMGCnGo8A
         RdTYMhlDAoH+s2JutH/e9prQVCl0LpYOyyibxFY5/ixg3MbJ4c1/oHgvspuHhdHWt4ws
         xV87IGi2Q5QGuZd9zA/XvrdbF+O7/KlMWohjUFZSlplYYD1KvxaPTFzbs0RM6Qc879XI
         nddWb1qKutPfHDC2AI//Opx3AmQY19vGbgJ07FMZ4nqm2c6I9LCgLCKxRnAtuHNYZF25
         ItphmW9iTqitZn9/XfHVEjI2PeCzxRkNNtpUr7cpi0pw4cHXdbvUB6GPs0O2GIEFN29B
         itcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685552720; x=1688144720;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gnVlMYKUBLV9HUzSs68t1blEmRLxmElAxhgHhe4Ab6g=;
        b=gsecd6Tu/rOK4fsM/4i9G4V0SNaQbxtRVTa6h29g/j8payH1xQH+T3K+SNF8tWd31m
         o9l8j4Z4N7iMN+knbTKkwvRF+HLPxnmQyoMAxP2LmOZfNdcEdWR4bk0yzR4GtTX0TAI7
         X/1gFB0aVrq7FnD8lqhzGQ1rrfNV1eqnrlNoaB8IsLKf1wsgz16pk9D9KLodAeOwIPP1
         +rIrge4dQnXkOCtoOB4i2KaR7xiqKgsyUlAgj17eZ9KpGaCrWz11J4Xy3dyKxfpSg4ja
         lkygZ7+oJGqtDyzYz6SdzqF3/ztFaVYas2X3zdNkr4Jeb7h5yikID3jJ5kX/KPuxa3/1
         tnMg==
X-Gm-Message-State: AC+VfDzFiQhKmCgWS/zzuUAnFpv1nBz3iDWiDYjn9fI22hNzm+Gh2v7e
	H50p04DuxOuRzNH+eLJ5dlP47590EAMGlMf5OAk=
X-Google-Smtp-Source: ACHHUZ73RZ+kXBFKRhveo7QTtajTevWdAwLtHSNQQGxqC/rFsYseQ9lyLFW/3X3dANcpSkOp7cZ29Tt66OszSzx0/gs=
X-Received: by 2002:a05:6358:6f08:b0:123:1741:dfa9 with SMTP id
 r8-20020a0563586f0800b001231741dfa9mr2427191rwn.25.1685552720406; Wed, 31 May
 2023 10:05:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230306220959.240235-1-ojeda@kernel.org> <87ilfcivzf.fsf@metaspace.dk>
 <CANiq72m_y=eCsJLxRP+bFvhmR5yAVK7=W6Hijb_CozWnL__dQw@mail.gmail.com>
In-Reply-To: <CANiq72m_y=eCsJLxRP+bFvhmR5yAVK7=W6Hijb_CozWnL__dQw@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 31 May 2023 19:05:09 +0200
Message-ID: <CANiq72=cCq=DqNrqtf3xwu8_A_YuudS3m82jqU7457OeYTRAFQ@mail.gmail.com>
Subject: Re: [PATCH] docs: rust: point directly to the standalone installers
To: Andreas Hindborg <nmi@metaspace.dk>
Cc: Miguel Ojeda <ojeda@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	linux-doc@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 7, 2023 at 1:45=E2=80=AFPM Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
>
> I think I will split the sentence and add an extra link to the other
> fragment, since there is one for that too (`#rustup`).

In the end, I did what you suggested Andreas; in part because their
front page has slightly different instructions (opened
https://github.com/rust-lang/rust-forge/issues/684), and in part
because adding extra links to `rustup` is better done in a different
patch (perhaps explaining what `rustup` is, too).

Cheers,
Miguel
