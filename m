Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com [209.85.219.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3433A613F
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 09:09:37 +0000 (UTC)
Received: by mail-yb1-f173.google.com with SMTP id 3f1490d57ef6-d35e565071aso6827858276.2
        for <patches@lists.linux.dev>; Wed, 09 Aug 2023 02:09:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691572177; x=1692176977;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4ZRqyHdN+bb6JjBx+blO7CBOqR+vtAkWtIczQCNF/E8=;
        b=Vljv67WcCWPeKntdb3UPEU3bBrZSQYa8jxfh1h9QnK/XV98cHxr6j0Bal4qB9v9Qo4
         EkWjXbov5A+PAY39tnYkElkqzoo6WUb6MB6eopabCJNmcKPZPrhkca0TY+iu73iujQ8I
         1kr4lcXU2tVcFppRdfb97vBaI332NZtNvQzT3tvel10z6M1lnVhiqG+GNS/tdfw7rV2U
         /eV3aOdWsakwGVV2JN6boFdyRj3Ebkx7DKyCeoeKLGk6wM1CNbgrbOjbZyZOu12iwhr8
         Fd4ov14gKvxbU1WOMBhbvxMJn+ppB7Z3llr3sWQgg+R8q9q31P/LrU2nLUrd+H9IhBfb
         I6Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691572177; x=1692176977;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4ZRqyHdN+bb6JjBx+blO7CBOqR+vtAkWtIczQCNF/E8=;
        b=J3/FLliSdP+Bvlf2Po/QQ7v18b2+Q55IRBvC/FX5nEiYvFx0rqAFLMn4YW/4hfVx3R
         XFsuZEYIR6/sKcTj0nCSPVTgjpbnC2LmmloFl1p9qWJyh4m2y4POV3Bi4RUyfUE3RR6o
         xkpCawwP2Vl+sQFu6DIm8TOTl/UjmvbZZO8wg/6sSSTzmNlQYFQJVZ5AdvC5p4ZD2o9R
         et1Y1uSihYP5eLzARaQNYAVrPAxSZro+7DjKiQJ47OiMJrK22wJDtHWzGabQD29TlGXR
         6RGJU1kqNbYvOsTfw9psDmrulC1wgCWFXr4Hl30tpGdqProGQTYRe7ySCR9Clf8bKqOi
         5auQ==
X-Gm-Message-State: AOJu0YxDb3oC8tz+1096qI5ncgwyrlkXr93I47lzh/cZF2/7MiPz8Dow
	ucxKbsNmA5+0AoQzOIyKfQ8ZTbUcNh7PDFj76Ow=
X-Google-Smtp-Source: AGHT+IHYrGM2sNe8AaJmcFQSYvY+3ZVZmxRS/X5P4nJUNrhefBxGURmr3eFs3XSlOQdA1MhdArfePH5CX2RXeqHTtHw=
X-Received: by 2002:a25:db88:0:b0:d10:7acb:24e0 with SMTP id
 g130-20020a25db88000000b00d107acb24e0mr2113431ybf.41.1691572176991; Wed, 09
 Aug 2023 02:09:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230720152820.3566078-1-aliceryhl@google.com>
 <20230720152820.3566078-6-aliceryhl@google.com> <bee24ff5-444c-44f9-81c8-88ff310b401a@gmail.com>
 <CANiq72mHU7n2jTPFsO=tjfqucrbe2ABSUYPUG6ctEerh4J+U_g@mail.gmail.com>
In-Reply-To: <CANiq72mHU7n2jTPFsO=tjfqucrbe2ABSUYPUG6ctEerh4J+U_g@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 9 Aug 2023 11:09:25 +0200
Message-ID: <CANiq72m5tbj2_N_s371d5N_4H1xpE2ahTHOUvFtUd+N0Y=0tsA@mail.gmail.com>
Subject: Re: [RFC PATCH v1 5/5] rust: file: add `DeferredFdCloser`
To: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
Cc: Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, Miguel Ojeda <ojeda@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 9, 2023 at 11:00=E2=80=AFAM Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
>
> If you mean for the commit, then we should follow the kernel
> convention instead. Please see my reply to Alice above.

One extra note: if it is a external repository, then yes, I would
definitely recommend adding a `Link` because readers may not be able
to easily `git show` the hash. But if it is the kernel tree, then it
is not needed.

Cheers,
Miguel
