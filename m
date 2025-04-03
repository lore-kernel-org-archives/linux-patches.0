Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F9B72512E3
	for <patches@lists.linux.dev>; Thu,  3 Apr 2025 17:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743701773; cv=none; b=jO1qfVGn5PgHwBYk2e7m6GjwTyMOziT2KeRktWvFrtBeUBlb681kC4GuYMxpMTuDTJzz5zQUtvXZv0MZcHDT3ufF0jKG794ALbBMxHWQGRcL+btHtcbYG9x3RCMmrY6kg6HKE/RhiIqm0JbmxEBbamymf0GrWBzOrNyqFTOzLQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743701773; c=relaxed/simple;
	bh=wUGCmmOo2C1eoS77TbjLuyHor/JBQbJ1BdThFBZP1TE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qC+SNwfu9S7m96/ve5RqnnoOcbFAw7c+ujiAi4oOZOsURd7fWfL7KJOjpmkRcs5TUrty9bAtleUVnHEIBbuSJmlcC7scEWqF6nwxq5hMshD9/NJDHdKneHZDZZa/BNhmVhej9uBPQ0d2nGyczVkExLv7la8Lco8eclmu2/MKTJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SybtAra8; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SybtAra8"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-301001bc6a8so153748a91.1
        for <patches@lists.linux.dev>; Thu, 03 Apr 2025 10:36:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743701771; x=1744306571; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wUGCmmOo2C1eoS77TbjLuyHor/JBQbJ1BdThFBZP1TE=;
        b=SybtAra84R3utB6meEynjYSyLCtDSxoERAypXXbnh75hRKDCNYHtq5KJPH+tqWEsKv
         1dS30Zlh+cM7j3kd072FHkPoVBO7G3MifdU7ufyVPBgBIqndCgnJ1WVqBX+km7veC833
         uL6UDf9Vp7CsXBd6cL1dUzBA4f22WWQn4ear2fcaL2H4fnn6TcVrhiPCxHyG2qfIGlMW
         tcZ0H0pCt3UZo15H1EMj84PvnbVcTKuOISbwxh7CbADQ5D8paRs2IIuetE9eAhh/Trrf
         9ri80IOf4n++W7gAjb6ikUBqSPjbCB/lTE5HlqzhQodpc57t6i6MEnRp4UisnQLpCsRJ
         A8vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743701771; x=1744306571;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wUGCmmOo2C1eoS77TbjLuyHor/JBQbJ1BdThFBZP1TE=;
        b=BkKVV9awHl9Bc3hNLgPKz8O1/Xk/vMZPPckjK2JZTDTBKYf0cBj48R0QpDSXnateZB
         p6UwUu+exUpseXsKbOJXkG0D+KTS3cIgeYPrmh30JOO/1zjJ2PhnjFD4c1MDkwVg7Lzf
         lsH5o4X7nJD+CMJD/5jFSd0sUOE2VB16k8gmEtedu+wi4o/DRRVCTstc9Bqgz/hOKiuK
         4pEuBJGh3aWVnjVZdSwgSmYmykzxoBbO9hByVTdbpKClCUdWkM7EqkrK7WdQbuXSVsEH
         UZViGiv1Dh2IYPxNesBeXyDCuBwi+ioN1aOKfVcMAFFA7y/LvhIZtJ99yX5sNE64k2tz
         Dznw==
X-Forwarded-Encrypted: i=1; AJvYcCUk4irYNi2hWU0vTJ2Mcc34cCHnox4AIwoplxyKg1UHKUxANZmpYGuGxKE6rafon0vBeflPPzRY@lists.linux.dev
X-Gm-Message-State: AOJu0YxOsJG6fsS26sgPY0wrT1dbRv9HKFNaMQsqTkK0gLSVy4Ifuue8
	UflO/fk7BcVCdNKAR57Kjc3WEozh3Oaoop97mM8QyJte2fxI2sT3XpEfmHJ2RKeJYufuupFwDrh
	UHxpuWb3SgG98GcpadOpyZU20Suk=
X-Gm-Gg: ASbGncvSzQGRbJuAWFrqPTO1LAjDdAmpuzou8jcdpL9+x23PywdKPJgGxCULltOXFkL
	HLgCIH1f0RSHms4XO4Oz/UMa1PC4XwjR49sotMDLNd4nKp0h9BtGhyITZag2qvwZsrI5Lu4roZU
	28snSk/WV8cAuwrMaqQr8i8I9O7w==
X-Google-Smtp-Source: AGHT+IG7VQfKhUI3ewajC5k1DnE4SbEI7NRFqrdHZB62bG69IvTMR0HCLjZM0+G09K4O2LAyweHi9oVeWXxsvbbGPII=
X-Received: by 2002:a17:90b:3890:b0:2ff:5540:bb48 with SMTP id
 98e67ed59e1d1-306a48bf3f7mr213677a91.8.1743701771512; Thu, 03 Apr 2025
 10:36:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250401221205.52381-1-ojeda@kernel.org> <D8VPGBN60E61.1Z48FQW6TL3A@proton.me>
 <CANiq72mdvnHvWbVNQbiXSRxd1xrF+A=v0RdJO74xeY3HyhRmcg@mail.gmail.com>
 <CAJ-ks9nAAcoJoFF+qNPbhsM32kOh9u+LGYUwFN_n9qqudB6YhA@mail.gmail.com>
 <CANiq72k36Tvwbzkg6nRdxB8VNRHLf8QzLeCXZq7sEPewccsWNw@mail.gmail.com>
 <CAJ-ks9nfEg=sdn_-q+xOc+k9mU0pdMuumwRb76LXzE3RcOtg6w@mail.gmail.com>
 <CANiq72mERwbmXYq-pi=WUAZ_VYGcBVS7tzH4P5zSUVCMcL4-CQ@mail.gmail.com> <CAJ-ks9kJiCGAkzW9M6q-62kcyvwBea5Zt2EoeeY0T3aN7jK+ng@mail.gmail.com>
In-Reply-To: <CAJ-ks9kJiCGAkzW9M6q-62kcyvwBea5Zt2EoeeY0T3aN7jK+ng@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 3 Apr 2025 19:35:59 +0200
X-Gm-Features: ATxdqUHj2RySMUlzfIJcf0gmHpZ8mus-BT_w4kJiHspLhXKJ1gM7QUWT0uqBcBI
Message-ID: <CANiq72=Mo71rrVSnPzg00EfiY+PCf9KCA-EXmaoNUCb2-adAyQ@mail.gmail.com>
Subject: Re: [PATCH] rust: clean Rust 1.86.0 new `clippy::needless_continue` cases
To: Tamir Duberstein <tamird@gmail.com>
Cc: Benno Lossin <benno.lossin@proton.me>, Miguel Ojeda <ojeda@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 2, 2025 at 11:09=E2=80=AFPM Tamir Duberstein <tamird@gmail.com>=
 wrote:
>
> My experience in industrial settings is that this happens very rarely.

We enable lints from time to time -- this would be no different.

> =F0=9F=91=8D
>
> I don't have any new information to inject into this debate. It's a
> judgement call.

Thanks for the feedback, it was useful.

I submitted a new patch to disable it and sent the feedback upstream.

Cheers,
Miguel
