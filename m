Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D3F7C
	for <patches@lists.linux.dev>; Sun,  4 Dec 2022 00:58:27 +0000 (UTC)
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-3c21d6e2f3aso84728217b3.10
        for <patches@lists.linux.dev>; Sat, 03 Dec 2022 16:58:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=08OqTfpjEPIElzgm0b3XrsSLNPOJHA8nk6UGImZBGMo=;
        b=G8bd266JZeEMVezTktX5sBBXee/WS2YVaOVvlcrBqxqKaj30U4vEvZZTLGf50yRrgG
         Hp3OsMSGRd5eXDNQg/IuK8WCKLqnlMyPeWWSvexkhxZML/9L0n1QesgbX+nMTneYatRq
         cWUVEaADZsCVnZUkBNDUQUbTGksxgbqY0+9aeIWee6RTI9l74A3NShjoSNsvGqU1lazQ
         hn1IiKuZ0NYyMW7Mkpu2mla2xwRfCfbZDuY0Dt8CaLe+YeoTmLWEAG/ab6ffdFEppxGr
         ylbest2ijb8/Zxz3RevXcShDX2f8DW39oClIE0VDtpBuUHb8A5xBN38/fxvqwPbXCPaw
         +jeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=08OqTfpjEPIElzgm0b3XrsSLNPOJHA8nk6UGImZBGMo=;
        b=P0xM8QJDczXEv+QnxaEXvpM9prULfkrwRgoSRXKSqJ07D0uQaSG9EavGuKP4Ip2gPq
         Kwsnv3jtEOWg0KuqcX6VM7IyGIGZkxrZni1Cy1DU9spmhgXeoFjMkeBQwx75PphoKpat
         4lbd7BaJBndIPL6N8rU5pL7kGykaLY9FRr6DSxSYWtH+pbwrUdYKpb7hPc3SqfH0o0o2
         3DOb8cnA/qsvyTkaPcBwV7NuIznpBGNJIQIkGTlwmLabFzusYh3foFhdR4dStHsUkk79
         /RB/T6rQaseAZNW5gBAX2Z86vcg0sp6GEmrskDQghChx6lQFfSi9KctRk55UbvqZDJHE
         EvoQ==
X-Gm-Message-State: ANoB5plDcFobu76uddzWThm40Ng71xh5amrhl+iCOBol4i+Tas6SnzDq
	x65/JDZYv6v/nqFS15YD81Fjv2ATomLUelwXD8I=
X-Google-Smtp-Source: AA0mqf4lZ7z7AnfKCgO0Ru5daFq4rf8z+ZDnC14H3+AUPNFjDCq6S7DQJsZ4081Jt2vYSF1s6sVJgzlDIU1M+WrrzqA=
X-Received: by 2002:a0d:ccc7:0:b0:3d8:8c0e:6d48 with SMTP id
 o190-20020a0dccc7000000b003d88c0e6d48mr15165100ywd.462.1670115506664; Sat, 03
 Dec 2022 16:58:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221202161502.385525-1-ojeda@kernel.org> <20221202161502.385525-28-ojeda@kernel.org>
 <Y4qNR+Nn9utDftHq@localhost>
In-Reply-To: <Y4qNR+Nn9utDftHq@localhost>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sun, 4 Dec 2022 01:58:15 +0100
Message-ID: <CANiq72mY97PXbEev1b-ZO=RV-oeAR8Hr6W4v8ndZuegByqz0jA@mail.gmail.com>
Subject: Re: [PATCH v2 27/28] rust: types: add `Either` type
To: Josh Triplett <josh@joshtriplett.org>
Cc: ojeda@kernel.org, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, Wei Liu <wei.liu@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Sat, Dec 3, 2022 at 12:42 AM Josh Triplett <josh@joshtriplett.org> wrote:
>
> This specific example seems like it would be better served by the
> existing `Cow` type.

Yeah, possibly -- it is taken from one of the use cases in the full
repository. Perhaps it was deemed simpler, or providing a way to go to
an owned instance was to be avoided.

Thanks for taking a look!

Cheers,
Miguel
