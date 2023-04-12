Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com [209.85.219.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70C639474
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 20:15:53 +0000 (UTC)
Received: by mail-yb1-f171.google.com with SMTP id a13so13189147ybl.11
        for <patches@lists.linux.dev>; Wed, 12 Apr 2023 13:15:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681330552; x=1683922552;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OjWPW5g/tI7kRaXJYWv/Y0jNJBy/VRCl5rMUtgvvIjg=;
        b=hB3C8eZ9Gfj3V5MenI/wgzALzYauvc6YP7uwtsx2OgPhWmdP5PxyKRSIFNmk6Qg2ts
         pUuDSnQVvlE+h28ETo8X3hKVAykXnk6qq+gZGe79VAZqzybDfLGCw3hMeHm7n8iYU2pR
         3C9LitPPel4kH3kG3KoEoPjCVJLwWJTTQqHJYL0y3dXja7qmqmt35PS2wgMX2l8hpVa5
         2vnDL+pjkPfjYnE0VAzRbV7lJEsIzHo22u/dsnXH5QQ03uGfSddOBzdcLiC9DhJYjwGJ
         p7jd8Xhcrg95AEYQVNCVb8hh3RSAuPpiOSyFma3288I1gcYM9kKnlZk7jXx3HgZ8cRXJ
         vezA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681330552; x=1683922552;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OjWPW5g/tI7kRaXJYWv/Y0jNJBy/VRCl5rMUtgvvIjg=;
        b=lIGqi7u75qVM8t3tcPlqQgqoTVM6rwLlSS4iFyCRtri7216sJxtGA0tHPw9kvlEsE7
         /l9pIkBAxp5StyyRrcjTznAN3rxfaG3U+eOMwfoKV6iBFTTo65X52LJXjo4/pSG//6bZ
         mB1ieRwYRhuquk4VkwomUbLFrYsSUGMqFDUNZKs6EObS52qvlbrWo6qN6VJ7Uajp8Z25
         0//S43E7q6XwSkPz+moWYLhyu7DaBxUoFFTjk3NQfICX3sTGrBRrpdwjccsggQ9rpWAZ
         OOxUCaKeKRrpq+M4EDUzshXM5VUFYNb+1B+u/y2QKVMrVSU9SH2X4KRZ521WZ/qUFCCr
         fPbA==
X-Gm-Message-State: AAQBX9fGIM4Tfunb7OISe8ff8gauUHlhqWqZ5S8aM1n0HAAqOkgMI77J
	5lLlidHqse9Riszc/y06QCyGnMYveHSb9EMYP6A=
X-Google-Smtp-Source: AKy350b9E6cd+NcqFn/q0TD/thUquuWGqAf5xaJrJVUDw1lxXwBCQg+m95Vi9zfGFCE2tvaCX8o9SUZOIM4xKbWpMFY=
X-Received: by 2002:a25:d8cb:0:b0:b8f:566d:2570 with SMTP id
 p194-20020a25d8cb000000b00b8f566d2570mr59526ybg.11.1681330552418; Wed, 12 Apr
 2023 13:15:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230408122429.1103522-1-y86-dev@protonmail.com> <TTE27GJ76877W-sIzVb_b80o8dCEf-CSDOKHLMTeYD23mET-2EymYGp9PII26HWZb0vF-emqnkIVdVKNwEqQHmWNZq_7P_GiL_U9Eyk0R58=@protonmail.com>
In-Reply-To: <TTE27GJ76877W-sIzVb_b80o8dCEf-CSDOKHLMTeYD23mET-2EymYGp9PII26HWZb0vF-emqnkIVdVKNwEqQHmWNZq_7P_GiL_U9Eyk0R58=@protonmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 12 Apr 2023 22:15:41 +0200
Message-ID: <CANiq72m-GgYEyest0n2i9L_mApB-3LL32Gmvh7jghicc0HGGPA@mail.gmail.com>
Subject: Re: [PATCH v7 00/15] Rust pin-init API for pinned initialization of structs
To: y86-dev <y86-dev@protonmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Wedson Almeida Filho <wedsonaf@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Alice Ryhl <alice@ryhl.io>, Andreas Hindborg <nmi@metaspace.dk>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 12, 2023 at 10:13=E2=80=AFPM y86-dev <y86-dev@protonmail.com> w=
rote:
>
> could you please change my current email on the patches from
>     <y86-dev@protonmail.com>
> to my new email
>     <benno.lossin@proton.me>
> Please do this for the Signed-off-by tags as well as the actual
> git-author. Lina's patch to introduce `UniqueArc::assume_init` has
> my Co-developed-by tag, also change the email there.
>
> Much appreciated!

Done in `rust-next` -- my pleasure!

Cheers,
Miguel
