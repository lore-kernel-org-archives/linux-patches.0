Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27DBA2F24
	for <patches@lists.linux.dev>; Fri, 21 Apr 2023 22:46:22 +0000 (UTC)
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-555e853d3c5so12181067b3.2
        for <patches@lists.linux.dev>; Fri, 21 Apr 2023 15:46:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682117181; x=1684709181;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N8J/G7dB6fCp2xG0xoJDui4DL2plxJGL8yp09N3bKW4=;
        b=gB2eMgT6zWwAiSi67l6PzypippJp7OT/IOWEB7PCGz6MH5cxWm/7b/nr2F6Zrgu8NG
         Y4yvqSW8GbF+gpDeIGrRfRBfHJMpp8ysLmxDL1OQVzl/Jdww0cL6Z5S0TBwEgnMPWQXR
         4VjW/+Wu+jJgSKfWcMh/QrBigO2iCCK+iCV6dKIXIF6LTNSA/t9xGsHk1qbwww7lVRjN
         A5fFUKgvjtg1xNpr6ex4MLTRbVj0ML1O95Id0iJsHCIc0L5ut/k9MlLBC7qan6zYVbRf
         EUjcDBmzgb5CwYSDyj1OcE/n/kvlQFVDgOqLhyyczfON2RoM/mfpVZ2IU2zIRVLGn+tL
         DZAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682117181; x=1684709181;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N8J/G7dB6fCp2xG0xoJDui4DL2plxJGL8yp09N3bKW4=;
        b=Ume6vADX0K6WM8fIcCP9WlwE7gt0OJXiCKcjFu5Bag8A4R9eoOnn9iAYwYOWQLgdHf
         r5EtJMn8hkOEX4IxVAINVfFQ37XrwdLgQSp9nQShwBR/L0KS/OYvbtHgBr8gCJH3YhhD
         W0ogjxSGEwDgxTn30ARiidWf2lfVKebnP7UwyiZZFWaSz1aI7YsBMQ7jshm9U++faMIC
         Px8xhf7udkmLl4GqEVgRACybI4Zp2z9IGlMejEW16LGKuIpQhb3LVXvk3U5M4XPQIIit
         SZow5HAVojyWnhzddM27AW/O5iOx+AJpS/+kicJ+u6mF2AflvTrkTaJqheUzA8N+hvIH
         8tFw==
X-Gm-Message-State: AAQBX9cSWGuiC651NzrRZsWP4vM5Ym2IZxZ8TdAfrVj3GjFlvQ+HgiVK
	3bG34dDI+Rxgqtr9fTZo7VIKZN0oAHDwQAPImeM=
X-Google-Smtp-Source: AKy350aszP8cZ00/JsNBnpsbsv/FVIPIsSNMgOkdQvwGWf4dPX0KcyvMOTtmYL0KqMWU85US7GqYqJZcvsBxeVeB2JY=
X-Received: by 2002:a0d:d742:0:b0:555:d20f:6572 with SMTP id
 z63-20020a0dd742000000b00555d20f6572mr3014437ywd.12.1682117181137; Fri, 21
 Apr 2023 15:46:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230412221823.830135-1-ojeda@kernel.org>
In-Reply-To: <20230412221823.830135-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sat, 22 Apr 2023 00:46:09 +0200
Message-ID: <CANiq72kXNi+bKxnVy7NcogvA8b4KbVD7zBf29oC5EE5VbF_YvQ@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: add Benno Lossin as Rust reviewer
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, Benno Lossin <benno.lossin@proton.me>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 13, 2023 at 12:18=E2=80=AFAM Miguel Ojeda <ojeda@kernel.org> wr=
ote:
>
> Benno has been involved with the Rust for Linux project for
> the better part of a year now. He has been working on solving
> the safe pinned initialization problem [1], which resulted in
> the pin-init API patch series [2] that allows to reduce the
> need for `unsafe` code in the kernel. He is also working on
> the field projection RFC for Rust [3] to bring pin-init as
> a language feature.
>
> His expertise with the language will be very useful to have
> around in the future if Rust grows within the kernel, thus
> add him to the `RUST` entry as reviewer.

Applied to `rust-next`.

Cheers,
Miguel
