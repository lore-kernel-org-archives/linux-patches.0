Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com [209.85.219.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDDD537A
	for <patches@lists.linux.dev>; Tue, 11 Jul 2023 23:44:59 +0000 (UTC)
Received: by mail-yb1-f180.google.com with SMTP id 3f1490d57ef6-bfe6ea01ff5so7213042276.3
        for <patches@lists.linux.dev>; Tue, 11 Jul 2023 16:44:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689119098; x=1691711098;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kqagiTUmZB/5CFgUf1pF1GfTaJyc9bRwpeqvA9m39kQ=;
        b=XoT0SZ2pcH+fLkNz8tah/GIkgFpsyRNFrGuwdykAPATYOvc8Uh2hdpzCj82Jl9s/B7
         pp4t+YFaWVM83bO2XJ310WUSBtxX2cqELm6tyZMtdizpZrhghKW4p4ifCHo4FsYfv2hV
         SqwhXxPtnAKRSjpYhcxIylzI/D88chilt+zuvTcIeOvcpDtOQohXbieQj1hG30x5K/+E
         aVJQrO8I+EzZIu3v2r/4JkS9pis7SQohptXbGXn78I0mlLXlbEwmOWOn599/g5cGD7lz
         Nr2S8d1c1r11JsFoEbqBFKBUJZwjY/K9BkBfMW01nSL3PUCT5irpcoSNTljklIGo3fao
         fIDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689119098; x=1691711098;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kqagiTUmZB/5CFgUf1pF1GfTaJyc9bRwpeqvA9m39kQ=;
        b=U9Y2oAGLutSB0D1/LqxLnFFIUOoj8CwM9zbfQhub3R2s3/71Ik/2sQSZPOK7LzFNO1
         L8e2Q6235U3aPcM+ZyzLa3gX0D4hnNmetqUEFFAT9yKFPvkYEiV6RqtchTfYTU8mhyGV
         hUPcHKEXYNxkY3q73FlNMKL26Ag4bQW2HvaPKQXYpN2P8fkwXI4i7q926xrxe35nFgWx
         Dh5k6GgRvesAEsrdjoP/6kHKAnSFVEsx041PTtHyOPliTIKlg61DOBcCIDT7iLanink1
         +VHjwhQTNSIrkEzUUTKN5ljVLue4ilU5clwzrUJ+uKr15WUN+ZgLQM7+zG90LnPRjfct
         /pcA==
X-Gm-Message-State: ABy/qLaqP9WhJOrqFgkiaCD30uD8poCTSTIWF/Z4MpexRZ2trCTmJgGy
	sNrxVGuuAku5qasZ9yi+pnWbXL/xq4TTzrq/Nxs=
X-Google-Smtp-Source: APBJJlGqWFfcEk/Yuzd7pg0bifj+QyCg9f3zWHFbBvad184C8din+q5CRZcghJectXmQ/PKE9FofTcznqbOu7yRztKo=
X-Received: by 2002:a25:b988:0:b0:c13:7b11:e786 with SMTP id
 r8-20020a25b988000000b00c137b11e786mr13933242ybg.17.1689119098672; Tue, 11
 Jul 2023 16:44:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230711093303.1433770-1-aliceryhl@google.com> <ZK3VEPeBEyErmerR@slm.duckdns.org>
In-Reply-To: <ZK3VEPeBEyErmerR@slm.duckdns.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 12 Jul 2023 01:44:47 +0200
Message-ID: <CANiq72nktgf_j-+S7snysQgwqeqB12sfjc-vrLsnOUKiZZ5WJw@mail.gmail.com>
Subject: Re: [PATCH v3 0/9] rust: workqueue: add bindings for the workqueue
To: Tejun Heo <tj@kernel.org>
Cc: Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	Miguel Ojeda <ojeda@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>, 
	Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 12, 2023 at 12:17=E2=80=AFAM Tejun Heo <tj@kernel.org> wrote:
>
> I don't understand a lot but the part that I understand (Alice helped me =
a
> lot, thanks) and the example usages look fine to me. While the interface
> leaves some workqueue features uncovered (e.g. flushing, creating custom
> workqueues, queueing on a specific CPU), there's nothing blocking adding
> them later and this looks like a good place to start. So, from workqueue
> POV:
>
>  Acked-by: Tejun Heo <tj@kernel.org>

Thanks a lot Tejun!

> Please feel free to route the patches through the rust tree. If you want
> them to go through the workqueue tree, please let me know.

As you prefer -- if you are willing to take them and/or maintain or
co-maintain patches to it, and it is not a lot of work for you, then
it would be great to get you involved, of course. Otherwise, we can
apply them to the Rust tree too.

Cheers,
Miguel
