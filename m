Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 669BF7C
	for <patches@lists.linux.dev>; Sun,  4 Dec 2022 01:05:32 +0000 (UTC)
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-3b56782b3f6so84779757b3.13
        for <patches@lists.linux.dev>; Sat, 03 Dec 2022 17:05:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=PyzqHyFdLyWqEa3wq8Yy+PDfxLYF/6Em2FYwiORm33Q=;
        b=L4+M48l9rcWzyolaSijYXQFCbAi6hbhgfhLzhDqdjmpgHxyZYu5U9FFfPGEGE+oeZ1
         T2Tzh0ckkeHDo+nTOAxU27Qx8XlE7IfncZdanD7R/9fBeXNVU9qq63pN+aDxXUtPPdFY
         M+mpQiHfVgtf+bpfcSMmrUvE24/1ODgzq0e/PKe/KZI1Mn29758ftB04K7cP1XlD7N/m
         wnMQvI1QtDFBwGYwUlXlbRIXLetiDn3ZtG29HwnZSuS9CX6j5qTrWlS1As6OoaodcIA6
         MGlYzbQUkiPDOMpkQeGVQBKILPbb3i21KEVt7y12Lk48GtDS0boyAz2MrFGs//bMPEq8
         8Rbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PyzqHyFdLyWqEa3wq8Yy+PDfxLYF/6Em2FYwiORm33Q=;
        b=TXYgMXenSgStsdnAS8GIZoV1rVTyvr8R222St0EhwOCShsjFJ9JilXbU04CICwZc+C
         s22+se+raajQjXVPpo2KyvruvNvqq3nTQmxaUZPKmI4be/z+mA++5ovWoGVi2Zd0tf/R
         hwzKlEXhjYuoa1JbjoPqS1cLPP3dmVBUYrXPRPrb+GvYJrqU0sQA58+3JUz5/lbXQwns
         EZCESdSXzygdBqE6R/EiHmYHAPE5p5dgn8prf1XHy46UrREoi8PQ9/k6xkzkvIKklKpl
         8AZ5/otGG+W47/oJnQIUt3dSUHftlPLmUNWAGqCHu5T7KXMJlWnzqPuY9TmY9zs/mVay
         CABw==
X-Gm-Message-State: ANoB5pl3bMzd3DIe7m1hQlVh1riqGnqhAs0kyU1M4caEPJyRN17WQjwu
	3naXrX2f1xmbOAzPomHoxPxVoG5bIjBEh1vOIh0=
X-Google-Smtp-Source: AA0mqf73ytY7NEhaiUQ88o7BGRcthtw6HVGT2ImvUh2R+g91gcPoiv6IEmOajAAeWOKh63qXEf2Le+v5ObdG5e2oBJM=
X-Received: by 2002:a0d:e6c4:0:b0:3bc:7270:cb70 with SMTP id
 p187-20020a0de6c4000000b003bc7270cb70mr39280836ywe.83.1670115931392; Sat, 03
 Dec 2022 17:05:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221202161502.385525-1-ojeda@kernel.org>
In-Reply-To: <20221202161502.385525-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sun, 4 Dec 2022 02:05:20 +0100
Message-ID: <CANiq72mO5L+DppmMO0pnBC-XWivaOc98EQYe92FWtJ+iHc6ttg@mail.gmail.com>
Subject: Re: [PATCH v2 00/28] Rust core additions
To: ojeda@kernel.org
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Fri, Dec 2, 2022 at 5:15 PM <ojeda@kernel.org> wrote:
>
> This is v2 of the first batch of changes to upstream the rest of
> the Rust support. v1 is at:
>
>     https://lore.kernel.org/rust-for-linux/20221110164152.26136-1-ojeda@kernel.org/
>
> I collected the tags and applied the agreed changes. The full diff
> follows (with respect to v1), since they are minor enough.
>
> I will be applying the patches tomorrow, since v1 has had more than
> three weeks of review time.

Queued.

Cheers,
Miguel
