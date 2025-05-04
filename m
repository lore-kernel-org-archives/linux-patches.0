Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEA5D10FD
	for <patches@lists.linux.dev>; Sun,  4 May 2025 18:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746382536; cv=none; b=kpQyv/D9H+I7MfIBML4jWFiTWr8Ul7jGI10+cafnQeA4gJWTS4hWdmkSy0IR2R6bsan1i5vdhB8t6QxTuEsMAVQs3kd1vthALHIETDUvDi8Hw0ebD2c3nztDEhCVSLWuMe6xScQ0n225Pq301wkvOqwnb/a/CEx9KXCuEgPsNMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746382536; c=relaxed/simple;
	bh=iHDK/mT+8VpYoXqj3KoxisbDMvRsGiCNPD9pvfdaYBo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hS0SynmmyAxeuf7CSma1EHSJBDD9J3pY8B0soRQ/KbZn0WecZuKAALl5v0tDikhXw0WKcTfoC+V6q0O7jipIhOzkOifWspKit8isDxHjndWB2SIrPeEcxeKVu+cFb9+zt+iDMlLlT9XYW5rGpW4eOHokEU1dSeOvIhFYSykBFxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Pl6O73UU; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Pl6O73UU"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-22e163543ceso4063335ad.2
        for <patches@lists.linux.dev>; Sun, 04 May 2025 11:15:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746382534; x=1746987334; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iHDK/mT+8VpYoXqj3KoxisbDMvRsGiCNPD9pvfdaYBo=;
        b=Pl6O73UUKdqaitgOA7yl0HoneNtt/WN54BC59iDr8pE8agtpDW/xbDbbZGkAgpZnDO
         5MjIyQRJJi3isyOZC4T11fziFKIu9lpLQVpii27gL5xv6H/X10i7AOFuyklbYiy1EJz8
         UQxo9eN4HIOJqWxsVIuTmU/SInvxVGpjDtXThz5X1xGhwyEK+EWDrJ8Jgn1WJFOqbf45
         rlWQoD2hey7NBH/ZZXjO5Oag74FZCPpEf6Tny6hjDErLMQ3S/VVQm3mdyDXAyv/3Alq7
         /4m5f0IWRm1wVsNbg0l2P4nQY+fIfoa73Pf3z4Q1jajKURVXcwsYb1prZKvvLeHSLn7L
         tOSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746382534; x=1746987334;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iHDK/mT+8VpYoXqj3KoxisbDMvRsGiCNPD9pvfdaYBo=;
        b=uI7KkGIfIZuxZagrI/fFp/svtRsAWXn5i0clpxba9FWTzuiHghHRNq1Yk1UKZvFMyc
         A1zuE+NsxdMFQce+ttXrztmUyZaoFklEC8UDKxfHRmjyOVHFoittbU7Wn+/da5/6klun
         wltYa/CQmlHVybwRTnjKqsTfwE/heLsR2f3qd/H7Mse2XF1fotzWanxgL0yn8dtCu6FT
         pyc3TSfv54TM9AQmUj2FWrZZA1Of8s3eRVVQFz4wiOwuRbXA0mwzz8Qq4D+P8qL63p9N
         lNhM88PQsCLm4to+6OO5pug4AtC8mhR7mEx7b16KNTi+TYMvMAkkcEaksJ0tg0v7dhXU
         aDaQ==
X-Forwarded-Encrypted: i=1; AJvYcCXU9aQHZmscal1INE+PnFGSAvH/5A2qPjEofBmUpVJr/i3AGet61lztmY7aY7SvxYDCpJDfut+5@lists.linux.dev
X-Gm-Message-State: AOJu0Yx7LaC83iZnOyrug3xnMp+c6w3agc/Jk3asJ67tspo4D+sz4hPp
	i4YwUfSZUwxtnc0zoyYpql2rKXKulrrp3VHj2CUoc42vALFTyOFO3R/fswkD4RYtr55y1ViC8wj
	XYmqlFfQc/GTR9TL2TNWynxPQ8RY=
X-Gm-Gg: ASbGncsUB+slrqLVXPgZ4XOhn7xpwUExyhttHFgH+/VoaJOfTPvnbc7kMXV72iVUpSv
	TEpRvsQCixLX8F+jei4G7FE9yGLfd2te7wO4CVksB3ktwzZ7dKNq/cFUG0RKT6dmeLASlT2Kki+
	31MWeVfLwloH0tzUyWbE6ecA==
X-Google-Smtp-Source: AGHT+IEemidPH6vW5/TRDN5e9+d9JcDfBVlErQobuzLmwdwFYyViq34WrxjvT1CZdT1gVv6+ZWIoXvKFcZ6rObHPb0g=
X-Received: by 2002:a17:902:c945:b0:224:216e:38bd with SMTP id
 d9443c01a7336-22e102cd13dmr54711965ad.5.1746382534079; Sun, 04 May 2025
 11:15:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250502215133.1923676-1-ojeda@kernel.org> <20250502215133.1923676-6-ojeda@kernel.org>
 <CAJ-ks9n7u3WkYmJCVc18c_cKod6DaB7KrA7NXbOuD3E3TYbvpQ@mail.gmail.com>
In-Reply-To: <CAJ-ks9n7u3WkYmJCVc18c_cKod6DaB7KrA7NXbOuD3E3TYbvpQ@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sun, 4 May 2025 20:15:21 +0200
X-Gm-Features: ATxdqUHvCBKb0VeR7w6toc9zpMWghyfk5KguE4071p5IEpYEVUX2PY5b1ywME50
Message-ID: <CANiq72nEHy5wvOyPzW4DLu9aE_MxTx1gq7AJ-f_Ny4E6bbOJ5g@mail.gmail.com>
Subject: Re: [PATCH 5/7] rust: str: take advantage of the `-> Result` support
 in KUnit `#[test]`'s
To: Tamir Duberstein <tamird@gmail.com>
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

On Sun, May 4, 2025 at 7:30=E2=80=AFPM Tamir Duberstein <tamird@gmail.com> =
wrote:
>
> Alice pointed this out in another thread but: one of the downsides of
> returning Result is that in the event of failure the line number where
> the error occurred is no longer contained in the test output. I'm =F0=9F=
=91=8E
> on this change for that reason.

We could perhaps customize `?` to help here, e.g. printing a trace or
panic, with the `Try` trait or similar.

Related to this: I thought about saying in the guidelines that `?` in
tests is intended for things that you would normally use `?` in
similar kernel code, i.e. things that the test is not "testing",
rather than things that you would want to assert explicitly. Thus the
actual code under test should still have `assert!`s in the right
places. I did that in the sample. That way, having `?` would still
simplify a lot of test code and yet allow us to differentiate between
code under test vs. other code failing.

> These changes don't depend on returning `Result` from the tests
> AFAICT. Can they be in a separate patch?

Not sure what you mean. The change below uses `?`, which is what
allows this to be removed.

Thanks!

Cheers,
Miguel
