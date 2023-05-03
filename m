Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com [209.85.219.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73B941109
	for <patches@lists.linux.dev>; Wed,  3 May 2023 09:50:16 +0000 (UTC)
Received: by mail-yb1-f178.google.com with SMTP id 3f1490d57ef6-b9daef8681fso3626599276.1
        for <patches@lists.linux.dev>; Wed, 03 May 2023 02:50:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683107415; x=1685699415;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QekGgvtyEzq9qE+03olGY6PTWKf2S/rVt9efjf9645c=;
        b=WsTIAv3bpWOgkPRuIYqZmMp394vBVAZM3e+78YksbATEi6TYx4ncIdBp2gkiI/Dn0J
         g7ixO5LtBI9/wl5AveftdXS3FFfJUZlG3ZPDUWRNTZAUco1T6IOhftsb8O0Phf4PLbgA
         jjf5T5P5bnKzXbDMgnMcT4iAIUWEgY1idOvKAvnRH1hH5Nk7wVFwUM0XfSA8zkPzm0hj
         Pd29/tulY9tynfFbxQonA2XD6aZuFBLLAdm/7o8xG73OCngG2GFgpQHlD/jTeRh8ubpE
         LLUQpwqrePx3HWMl53EnRxveDxItayIq9LHi4Sr89Rf/E5mZnk6YjVILEsbRFG1gxqGy
         tLGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683107415; x=1685699415;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QekGgvtyEzq9qE+03olGY6PTWKf2S/rVt9efjf9645c=;
        b=a7wn+rjqEUcni3mbNEqpfzYuKJXYcJn4EQdwbDgAziA4gdK/mblAr9H781uzCoAmvp
         XQ13Xblooq+CUsGqdp0T/QL4KnjrthtBOk2SGskczW9xVtJ1WjQhjQdnONsJ1p5hwuBy
         fdmuAxgJOaVlJmi1vLruVhWfvIpfkLICKrVxC+8ceVdOX9Z2k7mrEVIgu+78lEtYutVU
         mTFKZ6ec1kAKFyQqk6644NIlEsrIM+yz5PXpeSOONPEFOqRKOGsTbgUfzg3w1IufoWFn
         zlp2OOIDZteZVgCzpUpcn9RRCBCv4Stt70KCWKhUdmiwekw9fVhyrq6dKzNlndc6Iqt+
         VrzA==
X-Gm-Message-State: AC+VfDxEoQ3iIsB3bPTn1ZM50JUsJsS8VeHGWVSG94q9NT2QSIT5MziZ
	ePVDqDwwoeZbJ1OuzRbCtCVw95L+nVDeek3jO78=
X-Google-Smtp-Source: ACHHUZ51tM2esQU/LFCG4LG2gkjQEPdQQLrnENbaAmdLcdpeRoGlsvShOAlPwpg360fmYxWwDUfBitbPDNG576Eefko=
X-Received: by 2002:a05:6902:723:b0:b99:8359:b485 with SMTP id
 l3-20020a056902072300b00b998359b485mr22675047ybt.18.1683107415347; Wed, 03
 May 2023 02:50:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230503083941.499090-1-aliceryhl@google.com>
In-Reply-To: <20230503083941.499090-1-aliceryhl@google.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 3 May 2023 11:50:04 +0200
Message-ID: <CANiq72mz7rjsQ6kP4ttsMwSozwFWk-CUzChYf+vkKtTV6QtSOg@mail.gmail.com>
Subject: Re: [PATCH v1] rust: error: add ERESTARTSYS error code
To: Alice Ryhl <aliceryhl@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 3, 2023 at 10:40=E2=80=AFAM Alice Ryhl <aliceryhl@google.com> w=
rote:
>
> This error code was probably excluded here originally because it never
> actually reaches user programs when a syscall returns it. However, from

The reason is that commit 266def2a0f5b ("rust: error: add codes from
`errno-base.h`") only introduced the ones from
`include/uapi/asm-generic/errno-base.h`, but not the ones from
`include/linux/errno.h` (or `include/uapi/asm-generic/errno.h`).

Given this is an independent patch, should we introduce the rest too, at on=
ce?

Cheers,
Miguel
