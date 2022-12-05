Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 827CC7C
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 13:54:05 +0000 (UTC)
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-3bf4ade3364so118466727b3.3
        for <patches@lists.linux.dev>; Mon, 05 Dec 2022 05:54:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bc4/MjN/YjTPQ9EZGEra+4fgjSY8zygUtk0AgsersU0=;
        b=XuY48gARX1ENE547OqGANQPwOeRc2gRM3s9AirKaB5f7QPn2LgH6QY+/p5iN7FiaDR
         3CGX4FGzaQtIrLyvdndr7xdF/D9mtI9guwQWgJ7AS9Z0fnEYwZi4oCG9mtxDGGH40+vT
         R8ez7KsxFQtLHrKvTvhJZpskWdlNPMQFy0T5umLohosgOqmBqcHW7gkoRQBnv48EFiks
         OjzPsJWCMH/PoOktEwc9W5U4Ez6iElLwZTDVmFv8FV7MwlnXHv+h/Dze/3utINPe4Hoo
         6F7BeH/uSy/1K7myyxp7xfBcKLLyBOWpPBrMr7Gv3VgPkHR+Kg9eJImc6UHoB6fjru2U
         xCLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bc4/MjN/YjTPQ9EZGEra+4fgjSY8zygUtk0AgsersU0=;
        b=3Db8lcAC7F/C3V5TGoU87xD1WeLEv2iDHCK+8oSzQkFjQ50MUBp9KMir+/UHfpWWsw
         5fQV7/N9g7Y5LlHLc1jrL9nipkAtaImlmSFySCCVUC63CE7YKpHac4iHXcFTeQ7CfCY7
         ThU5woqnxZlhNPsjpehUSpjSctooiwudiHn8/6ENqxR0gIVRSX565jgZ7wroPEhVHFiH
         NEULW97Jd+TdeQDlcSXpQl8FsA/Myi44WTCIbVEV1gfz0Ab/zMSeik96u1UOzaF+pG89
         jc7ZVc7NZsXBjpov0RgeBy5exUnnkQYrAwQay2OMuF18qKw9GGJBm4S6OJ9dXecKuU/m
         T5ZQ==
X-Gm-Message-State: ANoB5pnCHOJmEdJXi4HlZv3ZEkVlnHW9KOqBAUVLzo4Lrwz7fbcVaGmp
	cehqSoFY254oKXIrblNAHvJH98gHRhZYL8VAqhI=
X-Google-Smtp-Source: AA0mqf57yGmLoBnvvhGrWpWKkOSHlBQkM4Cadv4sz/Tocdkosl6Gp2yYDACuYMlP/LhWj7GpigOHueOZififfQBdTYE=
X-Received: by 2002:a05:690c:c9a:b0:3ed:90d2:2ab8 with SMTP id
 cm26-20020a05690c0c9a00b003ed90d22ab8mr3864513ywb.67.1670248444418; Mon, 05
 Dec 2022 05:54:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221202161502.385525-1-ojeda@kernel.org> <20221202161502.385525-28-ojeda@kernel.org>
 <Y4qNR+Nn9utDftHq@localhost> <20221204103153.117675b1@GaryWorkstation> <CANeycqpNW0E5fQqD1Qzqr0p-3cgs5k5KgLusragaSWbrmcx2Nw@mail.gmail.com>
In-Reply-To: <CANeycqpNW0E5fQqD1Qzqr0p-3cgs5k5KgLusragaSWbrmcx2Nw@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 5 Dec 2022 14:53:53 +0100
Message-ID: <CANiq72ns7U3mWxt=gZVPTHB49as5gaY7=kR5TmxGAoMQx3qgbA@mail.gmail.com>
Subject: Re: [PATCH v2 27/28] rust: types: add `Either` type
To: Wedson Almeida Filho <wedsonaf@gmail.com>
Cc: Gary Guo <gary@garyguo.net>, Josh Triplett <josh@joshtriplett.org>, ojeda@kernel.org, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, Wei Liu <wei.liu@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Sun, Dec 4, 2022 at 6:36 PM Wedson Almeida Filho <wedsonaf@gmail.com> wrote:
>
> It's also implemented in `std`, which the kernel doesn't include.
> (Which is actually good for us, since we can't really use it.)

We have it around in the kernel (the `std` one is a re-export), so one
"could" replace the `Either` with `Cow` in the case of the commit
message via ignoring the to-owned side of it (but I assume Josh didn't
mean to suggest that).

Anyway, it can be easily configured out from our `alloc`, so I will
send the patch.

Cheers,
Miguel
