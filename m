Received: from mail-yb1-f170.google.com (mail-yb1-f170.google.com [209.85.219.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47684182A7
	for <patches@lists.linux.dev>; Wed, 31 May 2023 17:03:31 +0000 (UTC)
Received: by mail-yb1-f170.google.com with SMTP id 3f1490d57ef6-bacf5b89da7so8630634276.2
        for <patches@lists.linux.dev>; Wed, 31 May 2023 10:03:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685552610; x=1688144610;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Le5txtN+vXlkc1zaxXhjQiMsM93MRJ25LBvYo+mP45Y=;
        b=djKnNwcLL/efJ5Pk7pXVYfsHtSdffoNzj2IJRAaHP3MCrI6gxT+2gkP0w7UUNrWmJl
         lbc2Eps+jrJtZJt5ZCmV0E1NGun0EYmcjAl8eORPPkndCiH1OVmhfA4ZTcNIdh2rjT+d
         ozEXq8c7TztpD6NbtqvnJJ6FbRsaOU1Sah304sunvqWml+E0r3uw+SnTSOLFUMNgzYR1
         l68rijeFX90q3csQGzfMHkxRE8QHuy9GHa8CCyUahbC82lHV3qdNN/uPTNIx5tGr8/1I
         Oy4AM5kZznGYqw+iFM1RlAO40mhPsWwuQES1HpKQmy5CNzJDuX87nvniZMwpQP3KW8DA
         OB3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685552610; x=1688144610;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Le5txtN+vXlkc1zaxXhjQiMsM93MRJ25LBvYo+mP45Y=;
        b=kqw1cBTDdW21wo33/FY7noErg1v6NIs2yRZ81UWGZoI6SlSsHPTMExMhNS3g83Wh5L
         22wu98V7WrottCOIpCrv1dhMEzyGG0CXJqLmqRo3vyEUn5UaPfAazabjkbPhnjpPIBSR
         +iGi1Ekmzw2sl+Ib1570NBPg72/iPZo55Q3ZeZRNqDduQmbCPVkybpJXcFi+kr7JtcPt
         6hr7RwspQIqkmIotNfQaJs0B3Z8pEY0WDxwMcNrV5xahR2h01fQ2T4WyQXEBsa29Zqq/
         0hbeqoHFy7P6Td7KlanyFmTbshhJvc0vzzyel5RuKky6fVdEYb15nuzVTSkJmX23ktW+
         VtKw==
X-Gm-Message-State: AC+VfDz0YdM54up7RVxZ2eIlQwii+vcEmVzWlT8NGPpw2xvCC1v79src
	s9fTv2WQOqrKanLZY2y8wvL7RyXmL3iIh2f4dq8=
X-Google-Smtp-Source: ACHHUZ51Qh2dDR6cFedpHJtPzSS/QhdQuRfe/bLQNiMxwyNurdDRVzRDb0IH/R/G/idS/CVjPTM9lWx22TkKZTvAo3s=
X-Received: by 2002:a25:d18e:0:b0:ba8:58b5:71aa with SMTP id
 i136-20020a25d18e000000b00ba858b571aamr6883846ybg.9.1685552610126; Wed, 31
 May 2023 10:03:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230418214347.324156-1-ojeda@kernel.org>
In-Reply-To: <20230418214347.324156-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 31 May 2023 19:03:19 +0200
Message-ID: <CANiq72mNWBTTwg0a-+V02eV3u3qKA-sBMrxsrvk=yPERg0p3EA@mail.gmail.com>
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

Applied to `rust-next` (with the `core_ffi_c` removal in the `uapi` crate).

Thanks a lot to all reviewers and testers (and thanks Gary for
re-reviewing our diff with respect to upstream `alloc`).

Cheers,
Miguel
