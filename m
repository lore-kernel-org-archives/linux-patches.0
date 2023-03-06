Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com [209.85.219.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1C387473
	for <patches@lists.linux.dev>; Mon,  6 Mar 2023 22:24:47 +0000 (UTC)
Received: by mail-yb1-f171.google.com with SMTP id x12so9741404ybt.7
        for <patches@lists.linux.dev>; Mon, 06 Mar 2023 14:24:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678141487;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/HcUaH1X7Qi/9+4nj4EKlp5k2Eh7c4FkvNK1y/esUSw=;
        b=d7Mv6PYebMheWEsnRKlnuNBlSyisVIT7UHqB0qDW3K/GE61M0+ebcEZ9JDPlyf6yXx
         ozMi9hC41IDegX+/ey68MvRY2ZJdCl8IOe/RAnuO4dZZQkTdT/e7O1ALJWgppNBOHub6
         XtSfoLsH7RA4ixmB2EXaBDdcpd/mHFLOVMtAG2/MXpqJwT+9JO2grSdS66Gclo1vdqpC
         sbOzvtlqdy28Ge3HsxZKF3RkfVMO83mMydWNM8wekhAxZogxZSr2u0pqKeTQTeFsHx6k
         M0pQtPxpjw6t5wHf4Lxpz0C9wupxrakjFD4RwqNhTWH9QEzs63c1nK0/97qn8oIet8+F
         7q9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678141487;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/HcUaH1X7Qi/9+4nj4EKlp5k2Eh7c4FkvNK1y/esUSw=;
        b=13o8PIcvg8J22wautaKdActF5CzXG/nBnriJ2gSblX9Rzo0PDBQv6uDht3bGQfN7Xy
         tOPm5qKwcPsumd5kmOSn7C82a4Imf4I+IOZtZYCfhF96rO/6SdKHouluX6G0LjJXyXu3
         xi8VXp1D4MfmIPsJ5hN+UhEZwkpYbsbXnUT+h4Yh5YTRkBAivehCEWU4RQO4J0EDIcyC
         uJa6SIyxXoOektAN9EA2KACO4VIjT3VsYuchLyAwNX60xU+h/KivChlzbVOq2IdW6caG
         ORvz4FD1yrsNR6tCDw1dgWfyHdboV9xmCFgw9C3122u9++PqcFWhGnDZS6pMTbtucR9o
         fqYQ==
X-Gm-Message-State: AO0yUKVTT7s6Bo51afYZKvDFeg6VHDslTv0U8dxhR+VfsHIU2vxSRyAF
	UIFjFMeLRVoPkDJf1nkrcXKAAwzEPGSBdSjQoJ0=
X-Google-Smtp-Source: AK7set+FoDileIaD0OWvYJM64YsRE7dvxESFqPRy2decGoDFbxTaGZa22p+SBzQ/yRdESBPE9Vk2vHp2udAy77V+S9E=
X-Received: by 2002:a5b:585:0:b0:b13:7a6:f462 with SMTP id l5-20020a5b0585000000b00b1307a6f462mr1581883ybp.3.1678141486854;
 Mon, 06 Mar 2023 14:24:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230306220959.240235-1-ojeda@kernel.org>
In-Reply-To: <20230306220959.240235-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 6 Mar 2023 23:24:35 +0100
Message-ID: <CANiq72kF1wy0HWTPFaF3UKOvoZ19kdWe_mCAt8KxY9364-RE-w@mail.gmail.com>
Subject: Re: [PATCH] docs: rust: point directly to the standalone installers
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	linux-doc@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 6, 2023 at 11:10=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> Thus point directly to the page (and anchor) with the table that
> contains the standalone installers (plus signing key etc.).

By the way, while it is fairly easy to figure out the links to
previous stable releases, it would nevertheless be nice to have a way
to show them. At least there is a `FIXME` comment in those docs about
it:

    https://github.com/rust-lang/rust-forge/blob/793249870cf7610ffe78dcb9c7=
acc7efdbbcc713/src/infra/other-installation-methods.md?plain=3D1#L99-L101

So I opened https://github.com/rust-lang/rust-forge/issues/676.

Cheers,
Miguel
