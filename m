Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D087DC94A
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 22:17:30 +0000 (UTC)
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-54f21cdfadbso426260817b3.7
        for <patches@lists.linux.dev>; Tue, 18 Apr 2023 15:17:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681856250; x=1684448250;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rb2s/DWEwvCew7IiBKqmaCUL3AUYlAJqbW50mt5B9Nk=;
        b=hDtShXc3PhXwEbKRY4G2WLgsSyRF+JlOKSwb7zF8RpLSWYw1Ui0KT7RIu1xgItuaxI
         86GyFY1+9B+v7UwYAl+PRbu6tHmqgKonS3DRDuLmbC4R2rzGfofv4mXSqo7UPX8POTs3
         DcQpSzckH5HDYYfmb6xSuDFxN2RjgBuWjvPa31FSQwFs3WqvlFVF1ar742iW/0IIEAB+
         UTWwyxQRGX2nJuUC8I3xr/UHfXUcmwOURrTqMvXsCYiAY6GvoL7uqdw4DUKVxS21uRAP
         ElFkX5TOvMm1Mzwxw0o/yrRzbJ0a5lJvP/djpsBn0k9QzcK4lbWWiFzwkSyEFFviJyQE
         YUsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681856250; x=1684448250;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rb2s/DWEwvCew7IiBKqmaCUL3AUYlAJqbW50mt5B9Nk=;
        b=QEsRrZbGu4C3NKP+CwseRXV/3RityQCs2pEjf7CTEDvF3ZmOp4IPhZ541BA1sStn4Q
         nlkdSQWb52Rwx/7mzmRAMmwtKmIFrRbW/qF/NujZKDDLxwbS271xon1ZDXDZvcPWWVqY
         0EWad+aGM9jrPS87Raxj8hfrVvLt9saxQJnAf+Oa/Vm0pAqguHHzv3kkFom7BfjAklg9
         QH86VXut8Y/gMCRGhvEboVPi1ohel17o7vCoLCQ/YTuHVjj4PR/U18+kDjV2Qx6r60S7
         tJzA4bpXeeryiI8RrVRRLza0+r5OPoCckHyl7nW6qDq01q/TbQnRMoALiVOqizNwQGAL
         sCBw==
X-Gm-Message-State: AAQBX9c0bxUP1NgzIK7s6u8fRU6Lf6lyLQqor9lLPsIzft9cRvUzYq+C
	I0NDfiSQKgRBBylBgECij/y7CpPZcihi4r/Ix8GNSeX2ZhY=
X-Google-Smtp-Source: AKy350aKpMRZeEGfnc9bETCHrbDggSQVw30EgyEAxHgEaM9A0/+OWAUgagoXXsySH3ULOC9RpQdNrADkLYmFLckQmHw=
X-Received: by 2002:a0d:c185:0:b0:54f:cc36:2fae with SMTP id
 c127-20020a0dc185000000b0054fcc362faemr1431271ywd.41.1681856249759; Tue, 18
 Apr 2023 15:17:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230418214347.324156-1-ojeda@kernel.org>
In-Reply-To: <20230418214347.324156-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 19 Apr 2023 00:17:18 +0200
Message-ID: <CANiq72m1TpRDscA9E6PrZRtEogDsSXF8XQZ6bbhXCfptb34tbg@mail.gmail.com>
Subject: Re: [PATCH 0/3] Rust 1.68.2 upgrade
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Josh Stone <jistone@redhat.com>, 
	William Brown <william.brown@suse.com>, Georgy Yakovlev <gyakovlev@gentoo.org>, 
	Jan Alexander Steffens <jan.steffens@gmail.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 18, 2023 at 11:44=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wr=
ote:
>
> This is the first upgrade to the Rust toolchain since the initial Rust
> merge, from 1.62.0 to 1.68.2 (i.e. the latest).
>
> Please see the last patch message for a long explanation of the upgrade,
> the policy for future upgrades and some indications on how to easily
> review this.
>
> The series is based on `rust-next`.

The third patch may be too big for vger -- for those looking for it,
Lore has it at https://lore.kernel.org/all/20230418214347.324156-4-ojeda@ke=
rnel.org/

Cheers,
Miguel
