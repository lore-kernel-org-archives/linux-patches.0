Received: from mail-vk1-f172.google.com (mail-vk1-f172.google.com [209.85.221.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46C1379CD
	for <patches@lists.linux.dev>; Tue, 19 Sep 2023 09:04:55 +0000 (UTC)
Received: by mail-vk1-f172.google.com with SMTP id 71dfb90a1353d-49032a0ff13so2301060e0c.0
        for <patches@lists.linux.dev>; Tue, 19 Sep 2023 02:04:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695114294; x=1695719094; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7ofKdvgR0Mp7BMJehnfbK34RyoaC5p+eN21rHFUIhas=;
        b=Y6xv2WsGuDEZZ5JKwhSk2NSrQ6ZPWsBphVoWPDQ0vFQZAt1pCGUVGCoBrQdXOrXEOu
         k1j1llSar7+0R4nksaH5+MK/JUcCf3JrBtDoSAZuDpWqGMM3axQW24iAL+S/ew+t5H7Q
         lHt88XCcEneaXP1OArtg1dLyVeO+cw0YUGrHwecDBQo32o+NjCbeUU562xNCziFgm5zN
         QcjLAI6A84i1RxvCKRl0Q7ituXuOeHdty8uVpnDC92pkh+no+SWxfnReZScpeauIXVd8
         hMnwGCGPxyf9XNrsX/YVxWUw2/iQHg4lJBUvza6A2njuMIUZg7dBVY2vmxSwt+LooLNb
         mVvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695114294; x=1695719094;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7ofKdvgR0Mp7BMJehnfbK34RyoaC5p+eN21rHFUIhas=;
        b=OwngKcOgiW2QvHy65RNNVgFVvrGnFRIJ6t7LX7xkxFe34xV3YAr8nUbto+xZvfR+hb
         o3WbVL349+EsiKbD+YbQOB2E7jdqwQALK2CqFNGpdQwcbOgY0ik4E2xRc8APcCjnf8T7
         wt7Zm5RW4oXSYSYVNxjgCfhPz0beQdbNZFqzD1zZltCRafzXUeO/+bmxGJS59K+bMPVA
         M+oszaS1MVhqchWhLbIM8oVP5lG/Myoh8zJEb4T1p6TJ1HSS6qFvDXInWeiOxx9bZD2u
         dVbWGrIV9mR/S9BH1GUcNmZtrVRD45oc6G3Dq6H5Rb36YSFl1GD1pxFeAbnrv7q105sV
         QV/g==
X-Gm-Message-State: AOJu0YzDEKtNUeKmjTKW7X9fUycnXMdkFfUzUEEaggH9ny4BR2EWSiaH
	14zfz0SEOtRQJKkPuJrOcZCLIZ280UBX2fI0Frq7Bg==
X-Google-Smtp-Source: AGHT+IF9wWLmsx1f7jpe7ADkq/lXgpDNO86t3lHVkZ79WCeZacV4Y43fgL+YNhZyVI7fqNj6fQdT/fVBkwek9KloEqU=
X-Received: by 2002:a05:6122:4699:b0:496:ca46:f0c8 with SMTP id
 di25-20020a056122469900b00496ca46f0c8mr3925766vkb.16.1695114294084; Tue, 19
 Sep 2023 02:04:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230830165949.127475-1-ojeda@kernel.org> <20230830165949.127475-2-ojeda@kernel.org>
In-Reply-To: <20230830165949.127475-2-ojeda@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Tue, 19 Sep 2023 11:04:43 +0200
Message-ID: <CAH5fLgh5=cDu1BZBn82dGeboLinTV=rzU3=rn=eD29jKq8tH1g@mail.gmail.com>
Subject: Re: [PATCH 2/2] MAINTAINERS: add Maintainer Entry Profile field for Rust
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
> The `P:` field allows a URI, and we have been adding information
> on how to contribute to the Rust subsystem to our webpage for a
> while now (and other relevant topics, e.g. branches, third-party
> crates, Rust unstable features...).
>
> The webpage/document does not currently follow the headings of
> the Maintainer Entry Profile, but it does nevertheless answer
> some of the questions we have got so far from contributors and
> it covers partially some of the topics there.
>
> Thus link to our "Contributing" document [1].
>
> Link: https://rust-for-linux.com/contributing [1]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
