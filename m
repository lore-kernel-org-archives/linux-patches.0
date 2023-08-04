Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com [209.85.219.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB6DBE6D
	for <patches@lists.linux.dev>; Fri,  4 Aug 2023 15:22:38 +0000 (UTC)
Received: by mail-yb1-f179.google.com with SMTP id 3f1490d57ef6-d18566dc0c1so2531953276.0
        for <patches@lists.linux.dev>; Fri, 04 Aug 2023 08:22:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691162558; x=1691767358;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VHCF9fKDds1FJUzMr1VGs/NaEo+emI+wbuPv25TLjM0=;
        b=MuR2SN4aYLm1GiLgd5/KilEg7EL+2slAUiEErfzFvhBiuRCeNgpTwbFy5KDTHawMxu
         CoV1hiJ6rp117BeTruF8jpAtu0mmWPF5qcXy2a5uS05Bgii2kK5W6Xq3BQ9A90ogEMjc
         I6EQ6pWSPOgmM6nT6ohJ03bfwDKsZwL+NtbLwToHjorxsM4xLQ+c7SEhG5OZpA0ykH6y
         XvNcbCuCygnnMuKLoU5wJZ/5F43L7gQbvn7GYrGhuO0nFzjCl6qAb7i39HFwkBb2eA3a
         wy3LpzNF9JfNhbwRFxiW1Y+0Btlg/0uuOQULrYCRfHghYCxPKK1j6VsaKzDZDE6mJB21
         a4Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691162558; x=1691767358;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VHCF9fKDds1FJUzMr1VGs/NaEo+emI+wbuPv25TLjM0=;
        b=b8eMbb3RHWJTindl8pu3jUBI1afB3PFbLBBXEyd2crUeeRXDgWkmm6CVBXJUTTz77y
         HTJOaLkFCzpL8cDawihJ/Bs+pcBR62FzIelOmUWri8/1EkYYxbzl0PF4eKc0VWJYG0kF
         8Wxq2qMZrCXomCsWDxq4mdWNotAwb9i+kGCcE9VGFpIGBc4K8x44eML30YNPXG5VMgdQ
         z1dmgANXK5fzByVtVClKeXxOfNN0QmohZHyhvBQRrQ/0c2EAR3M2vjq/J+EGg/vRQp/6
         5pH1uPYZly+qt+9DipVn97acZbFLmpyGZwNh7wPnHuyfOvGU8xI2e2eq1Oppr252O4h6
         2niQ==
X-Gm-Message-State: AOJu0YyBxVA0qBWHu6rgW5AhrLzBSjMWkFdbYADpt9ssVLIToJccA8fm
	CC92Fypl9bKaAfgdYlNMiXkn4kt7IpDt65vCM08=
X-Google-Smtp-Source: AGHT+IHSW6KSyVijXTnHLVhmSKfARRFqrCNhdB9A+IPeVKDWWkxJJl5HK6FI2+xM1ORovZnaC2mV8iYnIXcrNPq3Soo=
X-Received: by 2002:a25:74c6:0:b0:d43:34a5:fbe7 with SMTP id
 p189-20020a2574c6000000b00d4334a5fbe7mr1829727ybc.26.1691162557951; Fri, 04
 Aug 2023 08:22:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230729220317.416771-1-ojeda@kernel.org>
In-Reply-To: <20230729220317.416771-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Fri, 4 Aug 2023 17:22:26 +0200
Message-ID: <CANiq72n0ivS9huBQfkPhEANbco3V46KhKRgWAw4Oj6uAMJj0rA@mail.gmail.com>
Subject: Re: [PATCH 1/2] rust: upgrade to Rust 1.71.0
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Alice Ryhl <aliceryhl@google.com>, 
	Andreas Hindborg <a.hindborg@samsung.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 30, 2023 at 12:04=E2=80=AFAM Miguel Ojeda <ojeda@kernel.org> wr=
ote:
>
> This is the second upgrade to the Rust toolchain, from 1.68.2 to 1.71.0
> (i.e. the latest).

When I apply it, I will update to 1.71.1 instead, which got released
yesterday, since I assume that is what most people would want to use.
There should be no difference for this patch apart from the version
number, since `alloc` did not change upstream.

Cheers,
Miguel
