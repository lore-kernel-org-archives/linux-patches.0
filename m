Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C1EA24F4F
	for <patches@lists.linux.dev>; Fri, 11 Nov 2022 17:31:32 +0000 (UTC)
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-367cd2807f2so50056177b3.1
        for <patches@lists.linux.dev>; Fri, 11 Nov 2022 09:31:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=prpDIZ3BYZ/cNF9JhJEHd9uz60rT0/OfMxiYhClGJnQ=;
        b=Wzmzth18FIxXSWPYBPIUIIkwKhGTOTObxE85JRHaooraLOoUdTB3Lv4DVZrZC/6Tmm
         E4yj68jnmJSqdA6uDC4woQONc4W8sqmM0Vv71nFr2DN84w7hOUNJqw2R0LK14fko8Ui7
         UlhkULZqxMSsumrcu1IF29cNq8I42ZX4KFR9p1C2j750pr4rcnXIU/MonhlAH2avgY1p
         RgYMe4pdqxa36UndBydIGE55t3nRAaPNBt+WVrz81XI0L45VFAr5YtCmS8RCGQwcSWtV
         9DxrTEIAQLIPUk50dZTIgJWoPg0XK/k91bwxGNGQ4jUgSiNdNb80JkdbOHM8XAWTTsaP
         tUSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=prpDIZ3BYZ/cNF9JhJEHd9uz60rT0/OfMxiYhClGJnQ=;
        b=wjxtk1pFCgk0xk9FhqUkC+6x04aPeBi/KDz/OU06dz3tGxM4QXK5kZgkgkGmW+t6sc
         f4NeOCZT8mQPAUe0kXWxKI2Q3aqeHRCDoN0Vuxe6nyo2zWCuQQL+UkpDN5nRspA7cZAf
         zXt8zIx0mAb3plJ70AAuGntXA1Ds/YkneIr1/s+H3z8sdZ0rsRISIwlTZYjiz3rj+Dg5
         3EXvz/9yIxSQp2bF3TPmpubdkmX78bIDHKJJFC6cIP/OHyotZJG1/gcyxgI4Aet0NOHa
         15crZrDunZXjtCBa2DW1R7CEAWMVzFRZG8Bff8IuXBttkKfaO79hRMw/PoJvJ1Xs3HXq
         BclQ==
X-Gm-Message-State: ANoB5plgEr169a0kf6G0i9wQ6DfQQ5HHGIz3p6Nwa/g9Fm11nH5K5uYA
	39NGHKhVd7yuLS5k3ZRa69zqjArAVTiFmct8znQ=
X-Google-Smtp-Source: AA0mqf4SJPcsFe//JwHzczhAEgtzUngvwNQkjyHOuLKRqKSMivaREWk3rlCM+zC0jC8KQdeC9n6CsjLYsGz43FHF/SE=
X-Received: by 2002:a81:7912:0:b0:342:4d19:c7b with SMTP id
 u18-20020a817912000000b003424d190c7bmr2894140ywc.67.1668187891982; Fri, 11
 Nov 2022 09:31:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221110164152.26136-1-ojeda@kernel.org> <20221110164152.26136-5-ojeda@kernel.org>
 <6C48433C-2B12-4D35-A93E-72CC1B41A8C4@kloenk.dev>
In-Reply-To: <6C48433C-2B12-4D35-A93E-72CC1B41A8C4@kloenk.dev>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Fri, 11 Nov 2022 18:31:21 +0100
Message-ID: <CANiq72kaqNroTms5fBW9uhPdRVrYkVfMUa+_dqPFVVVBUBeUew@mail.gmail.com>
Subject: Re: [PATCH v1 04/28] rust: samples: add `rust_print` example
To: Finn Behrens <me@kloenk.dev>
Cc: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Fri, Nov 11, 2022 at 10:40 AM Finn Behrens <me@kloenk.dev> wrote:
>
> Could be nice, to also have an int or similar as arg, but as internal the same macro is used as above, not really of interest.

Yeah, there are some integers above, but we can add more examples
later on, e.g. with custom kernel types too.

Thanks for the reviews in several patches, by the way!

Cheers,
Miguel
