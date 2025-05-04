Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 302442DC782
	for <patches@lists.linux.dev>; Sun,  4 May 2025 21:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746395688; cv=none; b=R3wOjNIVTa70GJGLWtP5DcLCYLsgD/jVK6F1lp2dJ91DqdDDnPUJndvLcEPJf2mwkJLgUknPh+0bnesQitTU0DwSYlkHYUDLCilcVAQxoKQIQmLFlaJvSIdFFQR/rj31lihUq2qMn6n7P0od9GPzECBzoRrDAAvkS7kTtCGHqVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746395688; c=relaxed/simple;
	bh=/l+1MvI7GiT5veI5LytixczDbnMXe1+igUv8pI8VedY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lip7Dq6k7UzSoT4LKiSc2yeLspGthA3ase+6f2+dfjSTd+WF9AkfoVLX+c6+OTN3mKc8bDktzxhLCBRQ8FjCRNk8/MX5rAniPSDEg19UlbUxYBuc4LfDZGR3kAGjFQzSRieTGdwF/e00AXzyQ4vtXTsupNyI7fx25Pby6YDCGYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V1lGf8p0; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V1lGf8p0"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2240ff0bd6eso8307975ad.0
        for <patches@lists.linux.dev>; Sun, 04 May 2025 14:54:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746395686; x=1747000486; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DJZjw8+wVh7l3iylx7BP6JrAtv+cQBGrHFy+Umlf40Q=;
        b=V1lGf8p0JZIjW+5LIFexoykzZR0w5AR+RIzy2BloxBLQTr8di+siX9o16H1T8DgPxn
         aTVcV+zps24oPoDIaGK6GQPh08qj7Y5ljWsWuNIWjuTWpJR/8LsSRwKLqdd0feHkMI41
         oj6F9xl4pX1pbScTUdaslaRNDlF7w3xT8o4db1BZmoDTF1xNrkJV/+hxoBYNXmzT3UeA
         rJlYQRdTx8bCVYzIfC53gjQ4Fq+I0N0Y5K/11JGhqKFgrcjW1wR16U09MuK5n31w7KhG
         ivoyNT+FD27KuT2hlUDzt0ne5jgZi7o5/oaIwblVMVNefUnucRMT51psGz+2BWYTbvra
         oPWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746395686; x=1747000486;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DJZjw8+wVh7l3iylx7BP6JrAtv+cQBGrHFy+Umlf40Q=;
        b=HVM1op43oyPisApOfF3aSQ8Y+wDgVQXoStnNuJFeypHoUtYgR9uq9cAWIJKZKEXuwW
         Fyo2ypuWx057l9daCNrVGgJfqSFbSvAla6KdmY/JC9aQrGUT+DPTRdMWBiptWQyForNN
         jKhUPaw/mJLPJ49pdpjxbMjmtqesg8SAVGHsof7Hnv49P0LsVnV8YoIYIg/lj9nzrkCn
         VjHyJ+FYN18ENEPlH2n5/ZNmbjBXwsxgKMUMCw2i6iqJ59Soe/HqH3DOm3AnVwk1Gnbz
         oBx9fxMwZTsJWGzDWHWp38UQVTViidFAbAu1VNJL7BeWzx23cWWBqSAcPq3MABka5a45
         YrkQ==
X-Forwarded-Encrypted: i=1; AJvYcCW7rOJ/M1fO2OTuiuRjSd8MunxHIzHsgNkjOjWte0Jl4eP4gWcsdvlxDIgNtS0TiqdvPbrbXAzy@lists.linux.dev
X-Gm-Message-State: AOJu0YxvNim2gt5/lH5whbf5CdR/Rj4hMUvOdgAGNGSXS7MNPQurMpni
	/HWmN5BEl6nzIGRKRgtYPCVc1Q7ZQWkEtTaumTOMSz0pEZS8dR/PPy1VYYNL7Q0tDP+c7+Edpa1
	e5+lNkxCSwq+yaQpMo9yZMBWLr0M=
X-Gm-Gg: ASbGncveNycRSbWYOWw13+/S+ZopDH1BqE1qo4BcnSk3/BwfkkOGWc6S0JGM+howdtA
	RapqdFeeWBDrMvd4rJn+JBfMgQAHk7nn/II917O2bXlhVfIFGu4aNZF1AdB9UI15Zt1gsitcGgP
	aKwzRPL9p1ZSUSFuz68p+WjQ==
X-Google-Smtp-Source: AGHT+IGdRAz15W9ZI5e1vtLXdhvXxSEUGSGPLW8JUTr/B9AnQL9gWGgZkz1pkGpOe9LOvI/UmsARew+FCAFE5sAYpws=
X-Received: by 2002:a17:90b:4c45:b0:2fe:b879:b68c with SMTP id
 98e67ed59e1d1-30a4e6c1a1cmr6287602a91.6.1746395686405; Sun, 04 May 2025
 14:54:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250502215133.1923676-1-ojeda@kernel.org> <20250502215133.1923676-6-ojeda@kernel.org>
 <CAJ-ks9n7u3WkYmJCVc18c_cKod6DaB7KrA7NXbOuD3E3TYbvpQ@mail.gmail.com>
 <CANiq72nEHy5wvOyPzW4DLu9aE_MxTx1gq7AJ-f_Ny4E6bbOJ5g@mail.gmail.com> <CAJ-ks9krSxo_DWFJdccP+SYJhX4WF0hXdq-20Rtf3doMp_2zDw@mail.gmail.com>
In-Reply-To: <CAJ-ks9krSxo_DWFJdccP+SYJhX4WF0hXdq-20Rtf3doMp_2zDw@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sun, 4 May 2025 23:54:33 +0200
X-Gm-Features: ATxdqUHzESE1JbgdxZ5Ox-DqWnyCuIUC7SNpfqlQ8QGc4FkMOFcuq4OR1DTOBFg
Message-ID: <CANiq72kLz7nXOKR+f=pNCu=hEEs6XQV_oDr9-xB_sq7N+svQ3A@mail.gmail.com>
Subject: Re: [PATCH 5/7] rust: str: take advantage of the `-> Result` support
 in KUnit `#[test]`'s
To: Tamir Duberstein <tamird@gmail.com>, David Gow <davidgow@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Brendan Higgins <brendan.higgins@linux.dev>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Rae Moar <rmoar@google.com>, 
	linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, May 4, 2025 at 8:23=E2=80=AFPM Tamir Duberstein <tamird@gmail.com> =
wrote:
>
> I see. Up to you, obviously, but ISTM that this degree of freedom is
> unnecessary, but perhaps there's a benefit I'm underappreciating?

Well, having this allows one to write code like the rest of the kernel
code, instead of, say, `.unwrap()`ing or `assert!`ing everywhere.

So easier to read, easier to copy-paste from normal code, and people
(especially those learning) wouldn't get accustomed to seeing
`.unwrap()`s etc. everywhere.

Having said that, C KUnit uses the macros for things that require
stopping the test, even if "unrelated" to the actual test, and it does
not look like normal code, of course. They do have `->init()` which
can return a failure, but not the test cases themselves.

David perhaps has some advice here. Perhaps test functions being
fallible (like returning `int`) were considered (or asserts for
"unrelated" things) for C at some point and discarded.

The custom `?` is quite tempting, to get the best of both worlds,
assuming we could make it work well.

> Even without this change, couldn't you apply
>
>      macro_rules! format {
>          ($($f:tt)*) =3D> ({
> -            &*String::from_fmt(kernel::fmt!($($f)*))
> +            CString::try_from_fmt(kernel::fmt!($($f)*)).unwrap().to_str(=
).unwrap()
>          })
>      }
>
> and achieve roughly the same reduction in line count in the test module?

Sure, the line would need to change again later, but that is fine too,
we can do a separate commit.

Cheers,
Miguel
