Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E61B32D877B
	for <patches@lists.linux.dev>; Mon, 17 Nov 2025 07:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763365614; cv=none; b=ijmIkMcIEer59PE99CLLCQnvr4QJERW6QNR1kw0sEQuqgy7wuumx8+VL9WReiuRb1B5QENdzPgIGKSWqM8f9y4vTaSlU7hs152lS3sZJOPPabNAWgk2HA/zGlyoU0fFFh9Qyq2j/RZBKBCTDTehBW50FhVL1AqJF/SDnbJ8Zn9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763365614; c=relaxed/simple;
	bh=ObmpRVCC1Puh2FN4TUTSDuNBSGR1J6ACRGZuF8hCM1w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NmV3UwrRHKgCTHcMsz9zn4lfT+/57W8s2dftxYuOzdtzUQc+ID1GmIh47fekXWWEARlUKBebhyp7hDP+RwZ1hqJa9FqrtAEWzQZ09QWF9ByE72ByOqNzn/G4P1b5molCCZ5YbikFHvMiBJDKgP3q6bwilTRPJ8At4T7Qi20iIU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d3gd08eL; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d3gd08eL"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-29800ac4ef3so10783455ad.1
        for <patches@lists.linux.dev>; Sun, 16 Nov 2025 23:46:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763365612; x=1763970412; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ObmpRVCC1Puh2FN4TUTSDuNBSGR1J6ACRGZuF8hCM1w=;
        b=d3gd08eLUlM/BJ2daDn09kzZAB7sixharLEnxS7KdB2Fi+EUem87o9o54+Xo+Qa6Nq
         gvfnhwJN4ffY/BSmg0PAUULLX4mUQjUQ2pBrB5iTC3UbQgtwn6iitx21pg3SdqfB09Yz
         nHj2wojOO0ilWX6ucVVP0YL0NxTpQ0uq8/yPVu+X37RdonhpOOA7DuoMtp/qYz6l5O2M
         YwqM05YMmuAAV33wCVOHK+LT1PLuLmt+06V5sSUAdAaDmYB8txqfBZZqVz0qgC071gGA
         +YgGkeQ+rUMTVYV8Gg/cOY+1SroAuz4Tl4psHHWkG6OyL+Zsy+5j58B+xRI7/S5HCqfh
         OVOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763365612; x=1763970412;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ObmpRVCC1Puh2FN4TUTSDuNBSGR1J6ACRGZuF8hCM1w=;
        b=lvZn7boC1XLCvHaaZv78SwQ4gesEUHEI0dwNdqaIpc44g/y3yBWJEyXSZ+Qe5diyEw
         M3BMo0fh+o0k39j4H2MNHKJ2dmR4Hujx3oBSjqo5OYgS2PN7UVQIRZEe3AWLibVprJFj
         IwjzLpNpv7xeoekImpooPQZvXs5C2iEBNppQCW0p2d9pV7pPTBTqzBXKSMVWbrKiMc6q
         gxAkcwPa5FjXSXEWD1bbStLuJp0R9p99tGuF4hyg7wb2rF849mE5E9SjUJarmTKbla2P
         auKLvcH17oe1dvVdR7fj2jsDh3U87xE09ev08wf/1IePNnp29kDk1OadOjrvyfK5qKzE
         eYjA==
X-Forwarded-Encrypted: i=1; AJvYcCV2Y6CUSpgAnAaUTGmSSLk0WjFx8PfN02xnh4UL6eER8/FjY7oAKDbwdwme9PSpkGboQ70IxC1I@lists.linux.dev
X-Gm-Message-State: AOJu0Yx6+HnvmYwAvICG88MOr22FoUFJdBnVYlgeaEHSNojL3HOVEm18
	HaWa2DFiV+daweNc7at4jORuQ95+Un7W2GeAKVISuVvvXPmUJ+FIhK0rrX8mG/6d1w4/gqO9/3S
	0M8qsHNfsfYpwtOMmVS8fzslQP2SMdYw=
X-Gm-Gg: ASbGnctrGnhG7lAL9C3D3toJzSCiyMFDognPZ0CaSnifXmpWPkAmS2ZErdITQTObtJR
	nh9ZKIqfcULR9VkSUJK5Qx1Y1J/CDt75tr3j03P7u7RqN+EuE/kK8xFY+XDmdnyXZE9+HaOBmZY
	JK42VT2SdVZGUL9Re3ed1CMw0+9lMcaUuSHN6UrD0N1u9b6lqCE8e6YPo8CtVCoTq2CzbVjnW59
	yqncVR4R9dTkZKQQc4QkNgfUrOFT/6pW16twZOMPnu3fs+/esl5tNbhqiI8+82dvFRXENOZHOnE
	viQFDQsS0FsIHlL2WT+PKW74QmWQgCb5fZM3wDUNwz284rdC4XFRM0FozoPGlCBntxoFva44d6A
	FLlEfQ4Mw36KoQYplYT0Xcfll
X-Google-Smtp-Source: AGHT+IHcyHCJS+XHOfR1eZy7OnTrmnx2eonBofGVOY9uvH4vy2lj6EpJkn3+qRUAndgLxU1J4hPJkhNm7LJiEaSgXd4=
X-Received: by 2002:a05:693c:6319:b0:2a4:5129:fe99 with SMTP id
 5a478bee46e88-2a4add16638mr4149911eec.2.1763365612090; Sun, 16 Nov 2025
 23:46:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251110113528.1658238-1-ojeda@kernel.org> <20251110113528.1658238-2-ojeda@kernel.org>
In-Reply-To: <20251110113528.1658238-2-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 17 Nov 2025 08:46:39 +0100
X-Gm-Features: AWmQ_bknbkpZ3ljEJgnqzyAN5abYU0FTf1nfb1wVbwRK92rcRHx3LRnBCnh3VYA
Message-ID: <CANiq72nFxpNP3JH-ENKRM72phHXYSMfp_7X89-q4UuGH-OyT-A@mail.gmail.com>
Subject: Re: [PATCH 2/2] rust: device: make example buildable
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>, David Gow <davidgow@google.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Rae Moar <raemoar63@gmail.com>, 
	linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Miguel Ojeda <ojeda@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 10, 2025 at 12:35=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wr=
ote:
>
> This example can easily be made buildable, thus do so.
>
> It would have triggered an `unreachable_pub` warning without the previous
> commit.
>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Greg et al.: a quick Acked-by would be appreciated.

I can also pick the first patch without this one if preferred.

Thanks!

Cheers,
Miguel
