Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70C0018660A
	for <patches@lists.linux.dev>; Thu, 26 Sep 2024 21:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727385523; cv=none; b=OfPlROkvImDG5wh1zU540BVDtC1GSqcCXIckCWDH5GstxUTr5Po8UgbkRLwAtuDOsG9ofdGkTOdAtGlcZ5yeNBI/6hzFJP3Fyk4PA/ZDcAISC3OHEFQrPdq33/Y3wk0DlVz65dL1FsWpL3HO6iIZ3xHOZGxH5PeH1Y9HzyE2wL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727385523; c=relaxed/simple;
	bh=w1kclsqVlQLtrr1ruKCx/k3v8gTO8jNATS/pfglofHc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oEGfWJ7AcVij1b4aawEogFgiqMFdoWKZBv0ngxGJXhokerAbnb317/va+JNXcOKB0cI1i0w7sm/ZM7DQb0yefUz6TQJg8GMHsco/ar/qnp0yuX1RKy54mNYdd7l/vfAu2lOeKZY85RaW0bT51Y+5RabHV8rTYlsWalYHTX6bRcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EGIvUSPX; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EGIvUSPX"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-718e55bca81so149133b3a.2
        for <patches@lists.linux.dev>; Thu, 26 Sep 2024 14:18:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727385522; x=1727990322; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w1kclsqVlQLtrr1ruKCx/k3v8gTO8jNATS/pfglofHc=;
        b=EGIvUSPXduw3Sp9lpGzFYtnvhKo9mFbYS7qU0a/Z5XruuIreZOcR0l3dXQSsfKHbt0
         VXs/WGC6NKCxkS1TaIIEARfFLbMhM5vMiWRKEtY3xDX28er/siSg5hoZdqoqQCZds/Oz
         36leCQCS1pFdOfirk4y+lOBL+h50nAZ6FsM4Qv8amqOe8s44nHOJUePe1F5Vc8iVvtex
         jEzFTIjU8QxmF+gzjpYWViyqR7jtVNHDwlHacmO+Pxtzw/T3bxhyyypSv7Njzn84xHLd
         z8UqFM+qizLtp1QP+gY54D1KCmNsPGgP2CJI6/oH+kFv3TQNA7UQXGatUfXFJE8ahYru
         TUGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727385522; x=1727990322;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w1kclsqVlQLtrr1ruKCx/k3v8gTO8jNATS/pfglofHc=;
        b=K+0qn1rcKWCItF946odpg4EjTkCZ4FvwrPHXXe7f4XqhAGIhTwmprjH3Lp5a6viJ3m
         fjuSslDR89JuMW6MvPjX4Vc6fTey0scYZ23NiO3T30xUYc/LzlwHpQb/tPEkxt+EcX8C
         v3prGcIaCLOGWDFiAC9bTS5BxNMrEqIYQT6kAHoRjpPnlMM4If1ICCF2IQuc0FDlRf+X
         DK5+rdB32wlFcJqWKDY9ZOyL+SPlY7f1b1WEQsxMA7T6Gy+yjdYguAIHCyV30OlZc0iH
         m/WGTnZoEl7AwOslPkxW7ZpCA+4FxL5DjX56eO8PE8yUYybNRmubaySxgvTywgsFqMDX
         5GYg==
X-Forwarded-Encrypted: i=1; AJvYcCWyEmq2rHN7c2K6Bui+TPBRuDeHx+1Bhlp1UvEwLglW/3XvbHncceLu48AgCuJ6X1ZtDxHqMfET@lists.linux.dev
X-Gm-Message-State: AOJu0Yw1sLf2n3PL4eiRMlc2fmHPLNlQDqH5NK0Fl8ay2jIwRq+MwYhy
	oQY7llzJzdOsNw2JOrvly0tN8PVlyeYvRwOCJW0X9KfOIhgKDW3nLKWKzAYLsWqJfYZIuzpC6c6
	j8eecVXmuymrvWUKkP8IXxry3xsA=
X-Google-Smtp-Source: AGHT+IE/EeYAY0BWAuVZA/I6KVCDUNVFb1hxR5KongAR5JI53gpNyt2LZUocYR7mqFv12xqOy3YDt2GBpHTFgFU2mrk=
X-Received: by 2002:aa7:8881:0:b0:70a:efec:6b88 with SMTP id
 d2e1a72fcca58-71b2605647amr749184b3a.3.1727385521502; Thu, 26 Sep 2024
 14:18:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240926124751.345471-1-ojeda@kernel.org>
In-Reply-To: <20240926124751.345471-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 26 Sep 2024 23:18:28 +0200
Message-ID: <CANiq72mYdtnFUWNNEpihRodr9XeuUoHTmnC1E3u5qZ+HtT_r=w@mail.gmail.com>
Subject: Re: [PATCH] rust: kernel: sort Rust modules
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 26, 2024 at 2:48=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> Rust modules are intended to be sorted, thus do so.
>
> This makes `rustfmtcheck` to pass again.
>
> Fixes: 570172569238 ("Merge tag 'rust-6.12' of https://github.com/Rust-fo=
r-Linux/linux")
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Applied to `rust-fixes` -- thanks!

Cheers,
Miguel
