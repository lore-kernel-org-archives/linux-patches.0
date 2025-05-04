Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B4AD1D555
	for <patches@lists.linux.dev>; Sun,  4 May 2025 18:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746382986; cv=none; b=B/2qFmvSnjESC5/YZ9okFBSuTeo35x2dNmrWEHverS6A2s1iPhEiPQe8j7ce/qxMAfd0uvtMgExV4atuJQJmG2+zFlsnhLem5ss0PU+2+P7RWvxnuNgY7+0YoeA2sC1XHS3rC+rmt1/hYLsyZdryCjl5iXxb9FkPHtQgr7hJgI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746382986; c=relaxed/simple;
	bh=NRoTU3EhPJ5MsF4mOID2yy4hxBhLzxcpKGxQ3VUBgts=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ODVwUjNZUhMdUAUg7EwT2HhWqE8bnXtn3HnPL7c9DfSCqREkj0mmkbwmSfSWndltaq30FiD8mCqy52fT8vMELpISTfQnN1oM2SDnfn6uNDIUI7T8MXNs8X0t0vlVJ0j71nNP4fNlv5rSd/tt3m7uXi4/wJia0Tx9yn4xiBLtjlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AAFrTcIW; arc=none smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AAFrTcIW"
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-30bfed67e08so36056521fa.2
        for <patches@lists.linux.dev>; Sun, 04 May 2025 11:23:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746382983; x=1746987783; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+XhcjTb4W0KddGeDKGrQ3a3OAZovTIwLMmR38oMQTDM=;
        b=AAFrTcIWfHzYzwJhQgxCH+sfEe2upn6xp3iLrf0IrSEdiu/P8vDar7Tm1UoWcdc0xw
         vpNlGbvIfgomiT5HVXdnJox8/0EG9N4hiL5DAQ6cY+jRzNjwLhNI6z4cJoz2xqL9oBb0
         28c4CajBig+Y5YyockkVTw7zV3BV4X88oPwNUd0Ja35ii7ccdoSzEahiS5II9Ijb45av
         vZvncG3Y7N+cumh89qnI3JLbjFGAIlTmqylvG7dhDXc2a9YqUGXMogQMnqrNbknxbUuN
         Foe4eHabzUKdje5/WRfo0pPmQyjVZJkpSZ9GSGfZPG93qR91EuLssGc+2F0LdsJHshC8
         5zJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746382983; x=1746987783;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+XhcjTb4W0KddGeDKGrQ3a3OAZovTIwLMmR38oMQTDM=;
        b=GD8GsgBSlHa44MR+937wN4WVyt1wwBXkAqRvX9J2ufqD2dvQOTpuCPiM53GqCmiaVN
         7ZPzK2UtKSOy5y8YP3jrUu6MVSmSzJY6qoisV6qs93pcyQP1WFuEqdtV8X/JAGvo6JST
         nN8z2Y7VfNHN/XZlsCTSrsMw8Hag2iJi+6s9GQKjKmTtjVG37xPG7zAmcmSn+U7tsKkd
         V0P2KL/WiR1VSKOacpazVzE0MqdUNtMBF2IQWJOpZYVyen7iV2wEO4eaO5cms4axCcNS
         PUrSx5i7NzdrYFxMBdZkx7+uUbjeUfW/BB9LNG/nfo+QJsrIdJxIx/XN58hbBSaqRBkQ
         UROg==
X-Forwarded-Encrypted: i=1; AJvYcCUayX/s970YEUJIUmNekwoWNXX4p/qA5bkBoTd7d0q11tubbTIJqNeJsBfcJ9XcBk4JVkQfpZPi@lists.linux.dev
X-Gm-Message-State: AOJu0Yzd28wDYBYJULfwOHeI5UuLQcOywXMLwFRuOo9MVhYVVJ5DOelV
	Wfn4DGllOJpbyTOfl+tud3WWQKU1Vb7Gd97DRtWAcIi8hp4ZqUlxdxRtc6uIozW2jOcGzBgfg6G
	lUXB5ydPbABaYMNxZ3JdcLEOqsUc=
X-Gm-Gg: ASbGncvF/0ZGY6uLC72/ag1FUvJkjUT/ZhlQ3aAX+Y94YLq2b49+11DI0JhFnAiLf1M
	9wNjiVZpGKxTDmRfstm73yhXyDx/wsIg00OdT/s4xkW9XyIAGdjjgg5nhE7bC5ARRuol4wpYzdh
	ajXRmnA7vvSZIEO/fHfmE4oiQ/6zruBTm8OoQn1FLQi1ye6VO1O90im2w=
X-Google-Smtp-Source: AGHT+IHSewq7mdLrxjK+vevTX/WiVDVEg4IYgv9T71zxpZE7LcUHsuSJbg8EfkKEWa79PebPla5TMC7VhhAOKWGapOY=
X-Received: by 2002:a2e:bea8:0:b0:30b:a4f6:bb35 with SMTP id
 38308e7fff4ca-323490564e0mr13143181fa.22.1746382982891; Sun, 04 May 2025
 11:23:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250502215133.1923676-1-ojeda@kernel.org> <20250502215133.1923676-6-ojeda@kernel.org>
 <CAJ-ks9n7u3WkYmJCVc18c_cKod6DaB7KrA7NXbOuD3E3TYbvpQ@mail.gmail.com> <CANiq72nEHy5wvOyPzW4DLu9aE_MxTx1gq7AJ-f_Ny4E6bbOJ5g@mail.gmail.com>
In-Reply-To: <CANiq72nEHy5wvOyPzW4DLu9aE_MxTx1gq7AJ-f_Ny4E6bbOJ5g@mail.gmail.com>
From: Tamir Duberstein <tamird@gmail.com>
Date: Sun, 4 May 2025 14:22:26 -0400
X-Gm-Features: ATxdqUGfMI3KYY_di8D8LLhpwzQrp-ESsq5HMgnbqfcQ7rC_Yr8vP3dgQ2T2Pik
Message-ID: <CAJ-ks9krSxo_DWFJdccP+SYJhX4WF0hXdq-20Rtf3doMp_2zDw@mail.gmail.com>
Subject: Re: [PATCH 5/7] rust: str: take advantage of the `-> Result` support
 in KUnit `#[test]`'s
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Brendan Higgins <brendan.higgins@linux.dev>, 
	David Gow <davidgow@google.com>, Alex Gaynor <alex.gaynor@gmail.com>, Rae Moar <rmoar@google.com>, 
	linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, May 4, 2025 at 2:15=E2=80=AFPM Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
>
> On Sun, May 4, 2025 at 7:30=E2=80=AFPM Tamir Duberstein <tamird@gmail.com=
> wrote:
> >
> > Alice pointed this out in another thread but: one of the downsides of
> > returning Result is that in the event of failure the line number where
> > the error occurred is no longer contained in the test output. I'm =F0=
=9F=91=8E
> > on this change for that reason.
>
> We could perhaps customize `?` to help here, e.g. printing a trace or
> panic, with the `Try` trait or similar.
>
> Related to this: I thought about saying in the guidelines that `?` in
> tests is intended for things that you would normally use `?` in
> similar kernel code, i.e. things that the test is not "testing",
> rather than things that you would want to assert explicitly. Thus the
> actual code under test should still have `assert!`s in the right
> places. I did that in the sample. That way, having `?` would still
> simplify a lot of test code and yet allow us to differentiate between
> code under test vs. other code failing.

I see. Up to you, obviously, but ISTM that this degree of freedom is
unnecessary, but perhaps there's a benefit I'm underappreciating?

>
> > These changes don't depend on returning `Result` from the tests
> > AFAICT. Can they be in a separate patch?
>
> Not sure what you mean. The change below uses `?`, which is what
> allows this to be removed.

Even without this change, couldn't you apply

     macro_rules! format {
         ($($f:tt)*) =3D> ({
-            &*String::from_fmt(kernel::fmt!($($f)*))
+            CString::try_from_fmt(kernel::fmt!($($f)*)).unwrap().to_str().=
unwrap()
         })
     }

and achieve roughly the same reduction in line count in the test module?

Cheers.
Tamir
