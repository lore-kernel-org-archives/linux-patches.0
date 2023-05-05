Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D21B3FC7
	for <patches@lists.linux.dev>; Fri,  5 May 2023 09:59:16 +0000 (UTC)
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-55a1462f9f6so14039677b3.3
        for <patches@lists.linux.dev>; Fri, 05 May 2023 02:59:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683280756; x=1685872756;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5d14VMN/dsF84pYxIA+HqaO2W48hhJ6NH76UKybrOHI=;
        b=WhLJfFKieiNArlBXBw8k4VHZ/gQd6jJfyapaDf5LZ8depVowiY48yU9MB8qKG363Yh
         dvPU6ODE0dykQlianl3bbpt6FHeJ8Ph56WmSAtwIWsjlk1I8q0BckQti2OxsdRrVTCpI
         vlQkwJwURbE6QHR1jxhzr6GhUEz+iWjkaDv5ZikyqOE3oBmgaJkrrG7H6J3I/qIHKzS4
         BP5rpCjVh7qNTw+HJv2vkJ9InryWiHgkSqz2G+gyxw58FTvj/eBj4ozsP+Lo2bUmMaA6
         yZLOGRaiOv3pTdatHSs3zpx38vOWBCk6u/TP7ir79d8XCm2vw0wjRRe87LpJNcb0fOwJ
         Ge9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683280756; x=1685872756;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5d14VMN/dsF84pYxIA+HqaO2W48hhJ6NH76UKybrOHI=;
        b=KWVYQ8V1PFyX0CFdVpnthcT6F4Fz1XrZYJeTrHuncy5QLGtKYy1q9DBMPkck2a4U4x
         MluOnzCd5OP/I7bEs4fhEjt4oJeCr0ol2FI53b9qagWyoTAQMp+C+lyhLCEvVAhjsho4
         AOXIs5eyX6jxtAPQ6dyHAfH22w9Flz7qhjTzkMrVkrJMi7fNiMkGx/mCNWGvnKiVwPHq
         V+ahcjmv8RyGT7el+hVAbaSAuDHCHY5oYwb0ebrjGU29fAmSC4xZ9icM2sTHoP2uFrF3
         ccZ6ci5DYKaHh31XHdWQVjU6fDXDK/9kcEaKjq6pARd17NWI1B847SeDp+vb7cdolcuv
         OlmA==
X-Gm-Message-State: AC+VfDxk7SK1e1eRqDxN4PbPRBK6wcW0k6HUhX1isI9iy8Lyt7wFmPCt
	I0bjoRccTMmRT2riR0gbMBoUIXJrmXIY/NzDF1o=
X-Google-Smtp-Source: ACHHUZ598taEicUanJWBqC5xD3xyd3QwAlvZRfXr/O+pf/peYRpl819lf6glbrOTTHFtXPeY54wv6krCM6jXRtuDkkk=
X-Received: by 2002:a25:38c:0:b0:b8f:5340:b052 with SMTP id
 134-20020a25038c000000b00b8f5340b052mr1134211ybd.15.1683280755967; Fri, 05
 May 2023 02:59:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230418214347.324156-1-ojeda@kernel.org> <CAPDJoNsG1E25yYM+L_H21vVCt-5S16etx3KMxx8ySZtWMQt4FQ@mail.gmail.com>
 <CANiq72mtb9V+1a7nPEHBCeg_fob4rpPTWJZjdahnGL2Mg3uoUA@mail.gmail.com>
 <CAPDJoNvGQBNN6X6fs26tjUy7LbpJjWwPvQuf=1+nSwj94aa6LA@mail.gmail.com>
 <CANiq72m7zdYo566PxX3g03+XPpHnrQy7GG9WkgEP82mK_2JBpw@mail.gmail.com> <CAPFo5VJpGq70X6efWESDoCYE3J0pjgMB1c7X_ACA4Q9MxnoHQw@mail.gmail.com>
In-Reply-To: <CAPFo5VJpGq70X6efWESDoCYE3J0pjgMB1c7X_ACA4Q9MxnoHQw@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Fri, 5 May 2023 11:59:05 +0200
Message-ID: <CANiq72ma+kGPWVGocuPoY6YL13PzCwEMgKN2Yi2Ok42jxBQdTg@mail.gmail.com>
Subject: Re: [PATCH 0/3] Rust 1.68.2 upgrade
To: Fabien Parent <fabien.parent@linaro.org>
Cc: Ariel Miculas <ariel.miculas@gmail.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Josh Stone <jistone@redhat.com>, 
	William Brown <william.brown@suse.com>, Georgy Yakovlev <gyakovlev@gentoo.org>, 
	Jan Alexander Steffens <jan.steffens@gmail.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Fabien,

On Fri, May 5, 2023 at 12:28=E2=80=AFAM Fabien Parent <fabien.parent@linaro=
.org> wrote:
>
> I'm getting the following error when running rusttest on top of your patc=
hset:

Yeah, it is expected: the series was based on `rust-next` which gained
the `uapi` crate later on.

Thanks for reporting it!

Cheers,
Miguel
