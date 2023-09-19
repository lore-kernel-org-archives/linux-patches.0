Received: from mail-vs1-f47.google.com (mail-vs1-f47.google.com [209.85.217.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 331CA30F96
	for <patches@lists.linux.dev>; Tue, 19 Sep 2023 09:02:42 +0000 (UTC)
Received: by mail-vs1-f47.google.com with SMTP id ada2fe7eead31-44d5c49af07so2244420137.2
        for <patches@lists.linux.dev>; Tue, 19 Sep 2023 02:02:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695114162; x=1695718962; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b8BNF8SyaoWs65BmwfDbTPimCmJcSZM1Pv8M7mtxSrU=;
        b=3BfoIO0xfjEuTA680c3y1K57scn+j80PkL4wZfnlbWbM0zqfSrADaMLVHpUawW19KJ
         YIj/6nuTqM3Mw6WTgBN1M/1MwwsMs8WXhtBK93omx7Y/9FEzGipINDFsrGLn37Go2kL1
         fwEL5nbH7MLJixv0AQbRA5EE8K69cr1+KjRVD8pxGiHiLNlUkFSYJkE+HnTthww264LQ
         PQRsFW1y9AhuUASba4hXZYTUSRMgSI6OSp76I9ZtJBeUpVBu+oPuUrIaZtMgT+AxvhXR
         WZtJV2VExMKlDLBhZv5ouSYo7oUQ8nCppBwQmA4fwdiqrkXKm+zDiTeaZeUf9rLGP6Lx
         eUhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695114162; x=1695718962;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b8BNF8SyaoWs65BmwfDbTPimCmJcSZM1Pv8M7mtxSrU=;
        b=l6wmEhF2q4EDw9YkSL5aGc62ljUFxJtSKvEE1AqYIH8y5H+ig2p7/bvZbNF1fmdSjU
         jIZVQrcIOgQ9sh4gFr0v8rRPGnp2EJFVJfpBWTEW1GgBDUmmQ0mnaLgetT23GXKV4OZ3
         OLJy/wc3f4qKXLI6X7wDRa7HbPVvyg1G8HpMIxVJiNo44T8VQi08Jz4NNxC/3Hr7LSmW
         EoR2rosumSlYEopeshksJiBHIs8cJVIBV+55hfFSW34WiXaNcc+cL5aJ+cD13LNu/I8B
         qa1SNiCkK+L8j9RZIswZBFPbKhBtAKcfIm4ooZ3vZS3f7yELLadqBi3+BpOwFGnOv1Rj
         CPFQ==
X-Gm-Message-State: AOJu0YxJxph16bU8yfNZmfaEbixJFyqhRpfVbjz5Z7nX05EMGKwu/Dbr
	ixR+YvC88FqTt0JUrZACeEj/Tso/cDNC4VFW1YVy7g==
X-Google-Smtp-Source: AGHT+IFqyvdBFTnep8FohepGzwyRCUws0u1wdBbPd8761vCQv7yNF+VJALMthM9VmOr0rU2e53MBbCN5siFvMPl8k3U=
X-Received: by 2002:a05:6102:3c93:b0:452:8999:fb76 with SMTP id
 c19-20020a0561023c9300b004528999fb76mr1501179vsv.21.1695114161968; Tue, 19
 Sep 2023 02:02:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230830165949.127475-1-ojeda@kernel.org>
In-Reply-To: <20230830165949.127475-1-ojeda@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Tue, 19 Sep 2023 11:02:30 +0200
Message-ID: <CAH5fLghh5vxv=HnXRFpbZEtr-Rx+rr434N8ORGWz1caam0wpsg@mail.gmail.com>
Subject: Re: [PATCH 1/2] MAINTAINERS: update Rust webpage
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 30, 2023 at 7:00=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> A few months ago we started a webpage for the Rust subsystem and
> the overall Rust for Linux project [1].
>
> The current `W:` field of the Rust entry points to the GitHub
> repository, since originally we kept information in a `README.md`
> file that got rendered by GitHub when visiting that URL.
>
> That information was moved into the webpage and got expanded.
> The webpage is also nowadays the entry point to the project,
> and we pointed the "Website" GitHub metadata field to it.
>
> Thus update the `W:` field to point to the actual webpage.
>
> Link: https://rust-for-linux.com [1]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
