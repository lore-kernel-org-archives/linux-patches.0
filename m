Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB43A253AC
	for <patches@lists.linux.dev>; Tue, 18 Jul 2023 10:50:39 +0000 (UTC)
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-579de633419so51124247b3.3
        for <patches@lists.linux.dev>; Tue, 18 Jul 2023 03:50:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689677438; x=1692269438;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sTu0pAKim/A7bk9vOOQJzSwY4RU25mujed63Z040/Wc=;
        b=M5N/eMDG1/kcW3eSG03fAOT6edP/BE9g4cI4JE49bCv1y57yRaoC68wX4AyPNN7x5h
         Ys1FUc72GHCNLVGQgsM0T75veXDpw8SFoi2C9z+BhOLD0+whFqCWE7/D/IN446FyuNRf
         sV6+rhj+XJ+cf8bkYuSqvTC8o09vR/llHnqUTGCJE+JMYxmkVwBYTGBcli9aL6pZukzk
         wt1VnsRfDzBXVvIgccrUNLasqjlOjwknb3C+3UzBRm43Z5LGnrWY2l/LUSEYVUDn/iBx
         NbXNZimTB7Ng71gyXAzE8SVGSAjraxBtDkKhTlxhk6frz5QHC+kRPnt3l8XOUa8xMm6t
         5GhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689677438; x=1692269438;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sTu0pAKim/A7bk9vOOQJzSwY4RU25mujed63Z040/Wc=;
        b=QX9czKN2+ZKO3RB1F7NU1YxDQc5CCL9Ww1jN+Prk8G3p0MaU+WGj7ZtjV6TA926Cco
         VErYRLqE+g8qF1H6q+8/J4bjiQACsXAtC+/Zv+AsPEk9+3q46o2Vsop89EhVuubgu5iL
         nPLV9hg8rskNUDl92ukjj/zPw0MCKl/Bw2nxCkHcz2krpX8+jUcE/wXsssYz3++3oIzu
         /btTrS48KuRMNsreTrarCNIfkRD2Xzbl/KSbZaN3z/j/6cAmRan+HgYv9oVtt/um4jLk
         q4KuGmfQlOMS+ftJVpQI4l4BYVl2WhYW8I1Y2jurfeD1Tt8y7tRqF1Q/PUjkN2yf9DnF
         IwGw==
X-Gm-Message-State: ABy/qLY4Va6Tw77CkJI6yIQiQr5ck4oo/H1VeEHs+FKIgDXW6u5Kq1QU
	MvQqxuQ4HAaNbacPAmJldqxlH4FBCttUCnoUjqY=
X-Google-Smtp-Source: APBJJlGNcgDopzSyU763xeq2Rqhv/iipQR9HeEhrKycYfBFUkhb9gOIE0XtXjI2boC04P9ttrOhZdAw7klVYgvj9JGY=
X-Received: by 2002:a25:a4c4:0:b0:ce4:5f48:a24d with SMTP id
 g62-20020a25a4c4000000b00ce45f48a24dmr2543364ybi.5.1689677438709; Tue, 18 Jul
 2023 03:50:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230718052752.1045248-1-ojeda@kernel.org> <20230718052752.1045248-7-ojeda@kernel.org>
 <CABVgOSnCY66C5wza-ZXb8c8UHg8ydbFv4U_7A14UU_gXeESKZg@mail.gmail.com>
In-Reply-To: <CABVgOSnCY66C5wza-ZXb8c8UHg8ydbFv4U_7A14UU_gXeESKZg@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 18 Jul 2023 12:50:27 +0200
Message-ID: <CANiq72m08qGAa7k37A0rQNf7vvBc1o8JjSY8jNd+m2XzVOT9rw@mail.gmail.com>
Subject: Re: [PATCH v2 6/7] rust: support running Rust documentation tests as
 KUnit ones
To: David Gow <davidgow@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Brendan Higgins <brendan.higgins@linux.dev>, 
	Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Alice Ryhl <aliceryhl@google.com>, 
	Andreas Hindborg <nmi@metaspace.dk>, kunit-dev@googlegroups.com, 
	linux-kselftest@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 18, 2023 at 10:17=E2=80=AFAM David Gow <davidgow@google.com> wr=
ote:
>
> This is looking good and working well here.
>
> One super-minor thought below (the generated C file seems to be using
> 4-space indentation, not tabs), but it's not something that worries me
> enough to hold the patch up if there are no other issues.

Good eye! Of course, please feel free to change it when applying
(though from a quick grep I don't see "[ ... ]" comments in commits in
the KUnit tree). I am also happy to send a v3.

Cheers,
Miguel
