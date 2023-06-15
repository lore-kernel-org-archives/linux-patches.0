Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com [209.85.219.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAB70525B
	for <patches@lists.linux.dev>; Thu, 15 Jun 2023 09:31:50 +0000 (UTC)
Received: by mail-yb1-f175.google.com with SMTP id 3f1490d57ef6-bad0c4f6f50so925272276.1
        for <patches@lists.linux.dev>; Thu, 15 Jun 2023 02:31:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686821509; x=1689413509;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=di66cKm4TSNTvyJIxIEt8peXod16WLfPyBmGUqyjx8A=;
        b=e02FzfAAe7TAzqPFI1NcUDpyeWS8RO+q/51tmwLU9bP2Ro8bCXmKckt2kbm2ZjdxCy
         fm3Pq8acrGSYhTJgQHto02XStVs4+X5cV9PGaXc5+msESCBYpbGe15S9IQI/7XBPHVwD
         Et5+5hXyrvQPTLNccgcN3v0KHj6OJrr6m910qVknvd6M1PsQ+viNQr5lzG39v3MJhpV+
         Jk5Is0s1GXsPATCc/FDmcNqhY6QK+J+ADjZ39RCzK4j9Fzi3I6gdP8DKLx6Hawkw6Voo
         7D+tt1yiS0+fP1ivNHykUxMZEcYv9lcgG8NSDc/OBAluZG/NvPPUlVzz58O3TgCAw9pE
         +BZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686821509; x=1689413509;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=di66cKm4TSNTvyJIxIEt8peXod16WLfPyBmGUqyjx8A=;
        b=Mc7Z4CpTlXUNeC6FqSVoYRjt3NYI+WjNo/EsZ6GVXQqZpulcOQu+O5z8HID2guvM4H
         sJ76TYwOWmhxDz9mDXYE4WJka1re84tFmTHLSKl7TaSmVamw5i4EDrldffpDBYyNYDkF
         HoyzL76HUBJHpt5Tgvs5V8N9pCtVTi9aG9vKGr5PLssqc2t1REuAA4AHlU8WD/xqsful
         /5cXckauKpHyhzLQXlhSYLoTZSWqKLdlG/1wZaroAlLN3VEKL3MiFhpglIaf3ZJGqzLM
         GKxrKttboY7ycwdyoviPBMjoUWRODy1eRkfiIIzJlFydp943VR4AVrNSE/qhZQ2bRVHr
         hlVg==
X-Gm-Message-State: AC+VfDwOv2C98CykYaDietQOuZVDalkBsgDzmc5o+NgnP+J2oeCd4SWB
	EgR2+f/cOCi9kCucXsqUTSXdRUoau7JcVpMdizE=
X-Google-Smtp-Source: ACHHUZ6gTgwthX4La0xbY3vwt2dDYdqybB2xqWiZHioIDURaKg4OHiGOZ2lS1gUUCClyR9i4ST922OsezwVW9+gw8oU=
X-Received: by 2002:a25:7316:0:b0:bc4:f2e5:5343 with SMTP id
 o22-20020a257316000000b00bc4f2e55343mr4915969ybc.28.1686821509582; Thu, 15
 Jun 2023 02:31:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230614180837.630180-1-ojeda@kernel.org> <20230614180837.630180-2-ojeda@kernel.org>
 <2b4b23ce-316e-b998-7faf-e529b121a8b4@gmail.com>
In-Reply-To: <2b4b23ce-316e-b998-7faf-e529b121a8b4@gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 15 Jun 2023 11:31:38 +0200
Message-ID: <CANiq72mApAXEtoWgkaLvZJu6gn=9CkyogRXVfbYxPsR5TeFUVQ@mail.gmail.com>
Subject: Re: [PATCH 1/6] rust: init: make doctests compilable/testable
To: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, David Gow <davidgow@google.com>, 
	Brendan Higgins <brendan.higgins@linux.dev>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Alice Ryhl <aliceryhl@google.com>, 
	Andreas Hindborg <nmi@metaspace.dk>, Philip Li <philip.li@intel.com>, kunit-dev@googlegroups.com, 
	linux-kselftest@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 15, 2023 at 5:52=E2=80=AFAM Martin Rodriguez Reboredo
<yakoyoku@gmail.com> wrote:
>
> Little question, what's the purpose of `FromErrno` here?

It was because `Error::from_errno` is `pub(crate)` in the `kernel`
crate. I should have added a comment -- my bad! :)

If we decided to make it `pub` eventually, then this `FromErrno` hack
can be removed.

Cheers,
Miguel
