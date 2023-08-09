Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com [209.85.219.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 878D18BE0
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 09:01:07 +0000 (UTC)
Received: by mail-yb1-f180.google.com with SMTP id 3f1490d57ef6-d3d729a08e4so7264345276.3
        for <patches@lists.linux.dev>; Wed, 09 Aug 2023 02:01:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691571666; x=1692176466;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X8p6/0KX3fVxDGykNsAB8y9ONKtikHgYp/M2932Yhtg=;
        b=a+Zu8NL83uIaY2kPK/hzZzHyi7vS7ZDBxBzBas0D7lsWImIDv7Qwd1BiEcv6FKTPP1
         BdMSYMPzdND5JC7oC8v9M124xkp5LnmnJE5/klfgAzt2xAFxC8Ix/ATgHA73sGHIq6M5
         8OrafZcJ9GdZPgCALz/hIhLavsI9b/Dr6TdEQlqt8LZqcG0yWZaerqRjYwnLJH58K7vt
         JQ3+FbcofYPvCtDrlcpkILNmTu7Hd19Y/cUYPc+r6qC4noDNhfIpgilb6dDWBQ7jRR1L
         /D8Jy5DP8f/9nxAZ93mmMJwTgohGO38fsuD20oMAYUxgObu8MmDLJJ/dTzqsykEe/tu+
         mlnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691571666; x=1692176466;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X8p6/0KX3fVxDGykNsAB8y9ONKtikHgYp/M2932Yhtg=;
        b=HsDeQhJQq68rb6xNqg39g5ORioE8SCP0hq39PyXipKOYh1zd6bGERyz4cQsb/oOlR8
         IioQ/tAVAYs9OpME0qN4obrzZs6ETDtCsdQl0CmrgPdqtoSAs1klFf2+ecGS1Vrxm7pj
         BfsKrBA8rA71TYr+PlBVI7+N6nhEkepfZeutUeYfhDJ7FKesy2orA24swOPxHTm4n862
         YPrnui1DLUZZTIAYnRzfHuYUbFkaRMiHQP3mlm2GvcGM5MmsXtkjFzVHrydEe3x84sZH
         libybn+8NZZQPIfLWit7kUqgMmS/JWtJO1Pb7eYow+D4kM7sUIjaHsohlPMNZ72qFQ9H
         ExAw==
X-Gm-Message-State: AOJu0YyubXkh2268lBCK4gb2Yl4YFwlNK/seaUbIu2qIlj4SS4YOeN61
	fypUr8thngktlA04OX1zh5eZTpZCdwnl9fX1oxY=
X-Google-Smtp-Source: AGHT+IHuTiTRTDu7yLIKac8kPi++wFPcYqkZyXa6gABjSHv6p2rSzxLSrZKIX6NfdlXPlBCmD9m9fopnnqjOidvHgH4=
X-Received: by 2002:a25:e704:0:b0:cad:347e:2c8f with SMTP id
 e4-20020a25e704000000b00cad347e2c8fmr1661550ybh.39.1691571666128; Wed, 09 Aug
 2023 02:01:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230720152820.3566078-1-aliceryhl@google.com>
 <20230720152820.3566078-6-aliceryhl@google.com> <bee24ff5-444c-44f9-81c8-88ff310b401a@gmail.com>
In-Reply-To: <bee24ff5-444c-44f9-81c8-88ff310b401a@gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 9 Aug 2023 11:00:54 +0200
Message-ID: <CANiq72mHU7n2jTPFsO=tjfqucrbe2ABSUYPUG6ctEerh4J+U_g@mail.gmail.com>
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

On Wed, Aug 9, 2023 at 6:34=E2=80=AFAM Martin Rodriguez Reboredo
<yakoyoku@gmail.com> wrote:
>
> Please provide links, at least for the doc comment.

If you mean for the commit, then we should follow the kernel
convention instead. Please see my reply to Alice above.

> Ditto.

For code, we are also using the same convention.

Cheers,
Miguel
