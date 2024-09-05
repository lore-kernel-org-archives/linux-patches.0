Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13AFA1922CB
	for <patches@lists.linux.dev>; Thu,  5 Sep 2024 20:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725569250; cv=none; b=ZGVk9R5afUdeokbp+a1JJgSpAJiiMiLsEV7Te46jZ13vRj2Cie9iasLjIjp3IFzknI+d5JiC8Dl7Q3A/kn5yD0V+S4YFVBmBPY3Gy4YU5+SOtltjYoT44OdmfHeO/7nxexK6HHpJrsPyEMNLxRxT96pr9q5z9xudW89nBX2mMR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725569250; c=relaxed/simple;
	bh=4Hf3O01u3Ljb1Ba2rss1ItqwhVifdhOzdjDqnEMWUE4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bo1rtq8CbmnJb3cCsGzOWiMck3Yn6tQcqQmzhiTvNq4DnSTK0oMzbKLL2/P340ROiSkQFVjW2KMeBS1tED4QToaWB5EC3LrfVzD9LOwLly2FNKoclGEUAgECsgeC2yuAwSBVJL/bQUu5Apk1rkL7SKbSyMEdrfl1/RIG5MjVA7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZUQ84iYw; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZUQ84iYw"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-7d74dfb97a8so24007a12.2
        for <patches@lists.linux.dev>; Thu, 05 Sep 2024 13:47:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725569248; x=1726174048; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4Hf3O01u3Ljb1Ba2rss1ItqwhVifdhOzdjDqnEMWUE4=;
        b=ZUQ84iYw//E1ARewyV3Fmf+ud/kpbPgpFGXuEApxMG4CcmhkOKGvOEdMJ+mMHqB2da
         97XGXpUzlwZJBzPeCfqKrf04wROH3GRaRrbaUMTWMUOblKnnhnY/2z7/13gYiDInYZYG
         PgVH8/vFlBVzowHsly3G02AlNghpomov/qtb4rYKzCtC71JdKWOgzDWqRPVqZpAG4jsl
         kimXSrBR0F2cpMtjXA4oCerDCGeTpDUskIeIo8tpa/AsqqtyYalsj2ytH5JkzH8S2j4g
         ZRVBvnmdXOtj2vWfYDO+aPG7Dgtj+uo5+Cks2CBVPFEW/1KHHaC3W6VwS4AjAdKZafxP
         yE0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725569248; x=1726174048;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4Hf3O01u3Ljb1Ba2rss1ItqwhVifdhOzdjDqnEMWUE4=;
        b=SJW6bH5Y4zWBonrZ4CtuowIsTmeGEhZ5iCvY/3Q+rWmRUVidL5y4GzE0uHo/GwITvn
         iizgnrzDiIu3MKPAe2foumFrpCqh1eiF4zsfZ8KxwJOboQ3L3QFCVcwu7hrQiifqxHJx
         DbLKdFU4LwhkuN7dhV8iyQItXS3lW7zULOe7XcvBnr7PwScgADLnKLV0XyGVi21aqYMH
         29XBj5a1BaW/5durWonTT1EDofMU++xU9s98Oz0jBTC40NfHedsb25ev/uipKxmvweX4
         z0jBGoIp/4aLSbb1lcOeT8TCs9fr4OHMHVRTgFL9PbHvwc07KTBwGEIZovxw+OKT7aKg
         O/IQ==
X-Forwarded-Encrypted: i=1; AJvYcCUPD4O1nfqX3RePPYPKJE5scQWSeASGYTWFcODvXrXHQFhsuO9LjuoJfslizyo8brFACeWrBrHd@lists.linux.dev
X-Gm-Message-State: AOJu0YztEzdA3OsyNmxe7fxRfk7tuvKR+E8ngSNQooDgMUXY4DpDEqcC
	4YyDGe3QbkbeOp5UDsW7rw7QW4R8xwzX+OJMJ//76LvhDISTxQ7DLdhHcKusOfXkD+uHHaDVrmo
	Oq2empG+nnqU3vUc2YYOr82BB5SQ=
X-Google-Smtp-Source: AGHT+IHBnfpvUZLq+D5rM3HmOAZ3FYHbbKHggg2E/Uzv4UBeQqK6HMzVh4XmZO3Ym2cWB8SqmfZ246AVIfNPRB5HY3E=
X-Received: by 2002:a05:6a00:92a5:b0:704:173c:5111 with SMTP id
 d2e1a72fcca58-718d5f310demr244784b3a.3.1725569248195; Thu, 05 Sep 2024
 13:47:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240808221138.873750-1-ojeda@kernel.org> <CAH5fLgh9Moq_9M+zMu300ohK=mPqkLyS6cpQ6An2Q3THCPFjaA@mail.gmail.com>
 <CANiq72kUBPnua1Pob++-6SJ8MeGxQMfrePY9SQVd0DZp5VU-2A@mail.gmail.com> <CAK7LNASHdd8Gv6OpXnP3tywrTA6iEZVqZGLb0V-vV_VUR-ksWQ@mail.gmail.com>
In-Reply-To: <CAK7LNASHdd8Gv6OpXnP3tywrTA6iEZVqZGLb0V-vV_VUR-ksWQ@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 5 Sep 2024 22:47:15 +0200
Message-ID: <CANiq72mtaSGtDx5fn2VPYfyBNGVDm7adQAYxJh3tvd6esLiaRA@mail.gmail.com>
Subject: Re: [PATCH 0/6] kbuild: rust: add `RUSTC_VERSION` and
 reconfig/rebuild support
To: Masahiro Yamada <masahiroy@kernel.org>
Cc: Alice Ryhl <aliceryhl@google.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	rust-for-linux@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>, 
	Nicolas Schier <nicolas@fjasle.eu>, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 5, 2024 at 3:19=E2=80=AFAM Masahiro Yamada <masahiroy@kernel.or=
g> wrote:
>
> With the nit in 1/6 fixed (No need to resend if you fix it locally)
>
> Acked-by: Masahiro Yamada <masahiroy@kernel.org>

Thanks a lot Masahiro (nit fixed and tag applied). I guess you meant
to reply to v2?

Cheers,
Miguel
