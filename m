Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com [209.85.219.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB913171C4
	for <patches@lists.linux.dev>; Wed, 31 May 2023 17:04:07 +0000 (UTC)
Received: by mail-yb1-f176.google.com with SMTP id 3f1490d57ef6-bad142be0ebso7963529276.3
        for <patches@lists.linux.dev>; Wed, 31 May 2023 10:04:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685552647; x=1688144647;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8KXdktmKQSTfg49U3Ho2uouVM63rMaQ3xxjCwRVDkuA=;
        b=ZW9TJc8e5wW40L2EWaaanO2FC2j67mAPBfqnvCuQ8BSAsGyxg9zbYAnnQQQKiQSVv1
         pvISI6kcIgeLGNGg7/AdfDRNaofDpwhMCGeAIK6ro2JBgq58eU97/1cgYFMvQWR7CzJU
         xwoA12qihjPMP/lZdJyp+OsTrUz1ssjITCHgkYhA62UAdXSaHvVr1sY5O0rqm86DeeVM
         be4ZjGdImPqMihtqE5rjtcanNQMt86JU1uHQgNTayhumLF1y7grq1oRzk4xl1BEWdqPy
         CjT+vxiRr2all8AJPT4by9jgL1nhLhDuDEha3snm6XT1o16s9ncrce1rF0ruR8MULn8L
         p7Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685552647; x=1688144647;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8KXdktmKQSTfg49U3Ho2uouVM63rMaQ3xxjCwRVDkuA=;
        b=QqpZ4JF9ell4agf2mjFywSFp7RQAe0P0dMJelPqaXGejKGxgSHXsCWVPVF3xzSQOlu
         TsTmx0okJ63SO0siiIJBaGx9e6YrA9MeEzvYQXhW4p6xIh8JBkqLcbV4zO+rQP0JROyM
         o5YAtKpulq5/UAFuGDCH7DndHcQZd7RlV3Yhp/zjUKSLtHkvg05I0Z+p0lY3AacGCX0/
         BCoPFRxAoBEyyYPcWI6A+LUD7gOTZqZPMGtT1tphDMnDbuf3q7p+KGM8IM7nLQ9rYUF0
         /1Fdw2bacC21aDcW4un2pt7tS3POCtjnefdpOI405noDdJ8f4qZ1iXdjoaq9noySreV2
         7k6A==
X-Gm-Message-State: AC+VfDz2q3tJhiRqNvNDOkFa9mWmsytvdSUV0TzqNlUz0wfgKUDhYe7w
	1JsRITvMhZQEVwDX5WDbVsJ0aCqWPG/zCx68jQn2/GPq0jymFA==
X-Google-Smtp-Source: ACHHUZ5pB1GtDTEFqlJRc3BAMpPDaoSK6i0zWlcLo+S/LKo7Zk/+s3mGnujsY/caFmwOWmyEmIF0OgoNkbIi+4ncAFM=
X-Received: by 2002:a25:2fc1:0:b0:bab:dedb:522d with SMTP id
 v184-20020a252fc1000000b00babdedb522dmr6246137ybv.47.1685552646624; Wed, 31
 May 2023 10:04:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230418233048.335281-1-ojeda@kernel.org>
In-Reply-To: <20230418233048.335281-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 31 May 2023 19:03:55 +0200
Message-ID: <CANiq72kR=QzZ9SH-ndnh7oShBJoFCKSiPWSJ88wJKaEmvvCtrQ@mail.gmail.com>
Subject: Re: [PATCH] .gitattributes: set diff driver for Rust source code files
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Masahiro Yamada <masahiroy@kernel.org>, 
	Stephen Boyd <swboyd@chromium.org>, Jean Delvare <jdelvare@suse.de>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 19, 2023 at 1:31=E2=80=AFAM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> Thus set the `rust` diff driver for `*.rs` source files.
>
> Link: https://git-scm.com/docs/gitattributes#_defining_a_custom_hunk_head=
er [1]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Applied to `rust-next` (with an extra link based on Gary's) -- thanks
everyone for reviewing!

Cheers,
Miguel
