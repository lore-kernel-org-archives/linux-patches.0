Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB1436EB4A
	for <patches@lists.linux.dev>; Thu,  3 Oct 2024 18:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727981154; cv=none; b=P5VHk7gbDtbB63JJSKSHXbrOkMWVMRo5Jdyg+Q9IzDd4Ggfwrn7zZ9tZZzXSW1S1DawCSxQ+ZPDIFttkWMdUfWJ2OzkzdaHVAbuFrkjOqzcmih0Gi2t1sa/0rgQL5fichWXMgjW0kMs7TXR5tpC2cgcR2Vri9rlAQGAs2qCSitE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727981154; c=relaxed/simple;
	bh=yTJYhyck+ZqmATQBYEo/WB6UMVDQB58RT56agf8BaDM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MLnR4KDs7fDO5U22jfrqoNMPbHM0U71Mvd0lDtm/nQOuu80PJlwSPSj3g+WY60R8Ts7CMmcY9tWZSUR6utkKveqyC1v3F1huhrCE71zppVzYVXpPCZD9yGn9Dcr+rWCX7MtDYil7QJJpBPItZyZxvJf2HH6Gnr8vRTE6qg6gcBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bqLBJeUE; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bqLBJeUE"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-718d5058819so200470b3a.3
        for <patches@lists.linux.dev>; Thu, 03 Oct 2024 11:45:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727981152; x=1728585952; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8+tNDiM/tR2N3VNA68e0sjoSOqWi1IeukamjpIQY72o=;
        b=bqLBJeUEOlyUVC+3UMVpASG05kRSlCDYBJYLMPCqtxpH1Uq9lk6QEpur5cSpHP0eqn
         yOroBUPbSbpEFGvDsqRK/2igpN9jyXLEk50VC8H6d6NjFiRe5/oiS8XI4N2ZYTYtwm7U
         h47HLW0C3vyTa+pkclBj4bKvHwdnlqEj9bhZSLMqwDSJp0zhlVne63RKj3vobuwYGfkc
         jtQywp9noJaIcYsL/6+ZLutLmhLGKQ8JrDri5di2v2tfrNiWTlpCQmmYFGPm2r8ebmPv
         H7HaNqC2ku8gx8IOTQg2ic2fLrhAe0zFb4M1McEXTcRXTr6CYYYrNhkFVXd661JcKhu2
         snVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727981152; x=1728585952;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8+tNDiM/tR2N3VNA68e0sjoSOqWi1IeukamjpIQY72o=;
        b=VB9B+15lFojYiELXwxaIAEX3uWhBvwevoTPM/TTVekRLLuSHNXFJ3Tk6vdQF9iyFxs
         GKIkowZPxSsB4F2SjGyOxTILFpLg99+nIYEAXVSpBAu8HwrlsSwqILpGFWPHkTeuMoa+
         XVm/6TJBm2whIAocIjVUpR3nCvjg0tKfd4Q0pMn9a2kPDAPVn6lDUZH2Avndb49mFezN
         FlO9GuUQkYT5BgAHl+eUGVarD31VFU+Ubs1DW2nDp9jgDeO5aVaiGFotfHFr1U+94zZP
         C28ackQKlz5bxT4Lj63NZMrWxZRpOHIbwVzNV7YVurCQTG4XD+FzCcX3NGrpvtwBCr1C
         83aQ==
X-Forwarded-Encrypted: i=1; AJvYcCVyB6xgvYyRE2LhSEbHRnl13p+1NOFCGKhk5ZQzRDgHX0r6rWOQM5YQxas/ncsbk91XKXHf+GZ6@lists.linux.dev
X-Gm-Message-State: AOJu0YyMIdJMu+gBPZeFHUhjh7kKrJX+K+vJyu2f/2twIv6Tk4S36tJT
	QPIFWS9645B13hvx6AJsR46E/tdFapnk4zAPFpbDpuvCFtCwHhrZdBlx+AiSD2O9DJ6wxtPO6L4
	E/PExo6w0NKIk1Q4E0S2Vm6vMefk=
X-Google-Smtp-Source: AGHT+IEEv/6WuqK54zCCgRs6EtPTdocGJ4pyvu8SL4QxLG8ZHmHC1sXwOFyFr07WrLa2YH/LxaCuf704oAXWFA5GGgQ=
X-Received: by 2002:a05:6a21:6d9b:b0:1cf:39db:2516 with SMTP id
 adf61e73a8af0-1d6dfa36987mr187025637.5.1727981152275; Thu, 03 Oct 2024
 11:45:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240904204347.168520-1-ojeda@kernel.org> <20240904204347.168520-5-ojeda@kernel.org>
 <CALNs47udN4_Gr2KHDapwWAmY=ixoJN+-9apAShVT7qFcKdK23Q@mail.gmail.com>
In-Reply-To: <CALNs47udN4_Gr2KHDapwWAmY=ixoJN+-9apAShVT7qFcKdK23Q@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 3 Oct 2024 20:45:40 +0200
Message-ID: <CANiq72kEMtB8SBeTJKtRhw5stwieq6ULk6N_X4dyDcCz_2mDag@mail.gmail.com>
Subject: Re: [PATCH 04/19] rust: enable `clippy::undocumented_unsafe_blocks` lint
To: Trevor Gross <tmgross@umich.edu>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Wedson Almeida Filho <wedsonaf@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 29, 2024 at 6:33=E2=80=AFAM Trevor Gross <tmgross@umich.edu> wr=
ote:
>
> There are a couple places where the attributes move like this - did
> this come from an older clippy version? clippy used to warn about this
> but accepts it by default since [1]. (Still works of course, I just
> think it looks nicer to have the attributes next to their statements).

I started this series about a long time ago, but I don't think old
Clippy is the reason -- I took a look again at this a couple months
ago and created this issue about it due to these lines of code,
including some examples and test cases:

    https://github.com/rust-lang/rust-clippy/issues/13189

For instance:

    // SAFETY: ...
    #[allow(clippy::unnecessary_cast)]
    return Err(unsafe { Error::from_errno_unchecked(err as core::ffi::c_int=
) });

This will not work, i.e. it does not see the `// SAFETY:`. However,
putting the `#[allow]` on top to let the comment be closer will work
(like in the patch). This will also work:

    return Err(
        // SAFETY: ...
        #[allow(clippy::unnecessary_cast)]
        unsafe { Error::from_errno_unchecked(err as core::ffi::c_int) }
    );

There has been no reply in the issue so far, but if you have any
comments/insights on whether those cases should or should not work,
that would be great.

Cheers,
Miguel
