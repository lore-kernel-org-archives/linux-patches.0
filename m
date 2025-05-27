Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34EAF1FDA
	for <patches@lists.linux.dev>; Tue, 27 May 2025 00:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748304155; cv=none; b=HIxapLAS6A97vhM8hrp/iSVLjygJt5YbV+PVDtA6iXksRfoCWfJjEW4OFISX6Ip91oNfzqbqJ7jqfpR3hzyu7xfyYfNxZQEWONJy3Vq3wlqymhCuJSo+A9L/ojdwevMsEBjQRs36wfg8jq47k18YNVJLCANnpB11YVWD8MWZlHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748304155; c=relaxed/simple;
	bh=f+8nvxqAogtH+5lnlaOWfFsRXBDYOv09eJ8tjN3kC+U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SISUCpOmBk8Mo1bPo2SnI04mKd1mFrWWJZc82nsNjUR5yg8JiCtBQAdFo5toMIametH9gzLoXPL/5AjMYvD1gtVwCW+Qj26hCrdL243/KDvXaU46MQLl2V+Qesjy+lPCPc6/cYkAXlLGWA0PGaHjcWanozAigsJ+KedfGFTE3gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lZbQbeEJ; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lZbQbeEJ"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-b270d7e0985so206514a12.0
        for <patches@lists.linux.dev>; Mon, 26 May 2025 17:02:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748304153; x=1748908953; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qo02AqQm7aPI5AXw08SD3FnZ4W/ANkIsGd8/cxnS2ic=;
        b=lZbQbeEJJLEZrqdJBz/eRikQ5sld9SLr8x/quh4EZcPSenIUcBja/sJdbsJN4dDsFe
         UccW/3a3SUGMII4J/HejWNH9MwwyfjNceMcIDdfXATfKTE0neGdcN3FArJ7ORDLuSI3a
         t+u6yd7CF9jC1V+V8MFHu5BfYv72GlA5NJqAArbF/kOof9PGSAGNmZMSOJiBKkva0Fi9
         ptaxlvmKmW+clsRuiW8r7RLW27va0W9LmbT4NoHcuw1IKB79LboNJV/qs7+b+5L+mAhq
         0VUcmt1wHjSTa5PsXdJtf/ILoq2rpOrG041VOrr/OwF1MxnRmPaERXL9JMAzbC8dCgXH
         oFTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748304153; x=1748908953;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qo02AqQm7aPI5AXw08SD3FnZ4W/ANkIsGd8/cxnS2ic=;
        b=mYnXOupGdJIhGID3VgrnJWXAmtrkoYg4zHsAPdnM06bx9XRs9s7KhGbJOmHD8ht91D
         zf5XfZUsiQBUANVddFaKpR6e5+Vbz0ceu+1F5U0tiIsnJ+uHX4rAkNo3Lfd6rKGnCOgM
         Eo1WvxKAh7fRnuamUUfn7SyJns5LOjoCLvFqGoDXClJ81hrLzFMDGHGCc6cmEWddPbHa
         bKbN3c/MIFoOfbmxYCxVWh/g1VY21dgqoRu4RrMX/nHNMI+jztYeKWTHZYGVxJwJVSak
         tgiV38rCskDLcDuyJKQ7EOeSHhb3wQJ7riWd6tltu46WjGehVXcPaFfrBGVd7C90mJEo
         E85g==
X-Forwarded-Encrypted: i=1; AJvYcCVDaCWepitN5RtyD6Ofi53eqwRbsRdmhrrSe+WmSuCcpd8J7m8j1sMXkjA09UKT+jkVjop9ocDc@lists.linux.dev
X-Gm-Message-State: AOJu0YxuTcqNjY3Ciphc481lYd0yVlo6ZvSBzjF1hC+bOa59+f4RuGN9
	4AQdRAFLlXqQYnoJbDvD0LZfiUqoFPHGNZ+1ZDUOYxpbMKLZLT7O9COJrOBiyT9g40+jbrSmxIY
	Ppg3+LmogOdUSiQ24FmXhh6iylNiagcg=
X-Gm-Gg: ASbGnct7+ktzNF8ztZ6G81+mibSUQd0mwPk0LRpaDC5L6THfuOeEw67QdMPqhyO2+ts
	NK2DAPXHTCuctiWV+5z/48MZYzyRc/XLN7IcHGK5Dr9Jz+a6GxRiPc+rl9hsrCjLgHX7y7QJl8G
	Y4MbJ6OQ7nFkJ16+Dll4TgLiGCuPk+qWbo
X-Google-Smtp-Source: AGHT+IFLR5Hpmi57Nu9/l8Jb/vmsnSGEkmpsKnlFA/5TAMPItHxsEnKoMcGdVwDZxw1QGAebInPuw6+aOLDpLWBXEVo=
X-Received: by 2002:a17:902:f546:b0:212:48f0:5b6f with SMTP id
 d9443c01a7336-23414f9ec0cmr57708035ad.9.1748304153325; Mon, 26 May 2025
 17:02:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250502215133.1923676-1-ojeda@kernel.org> <20250502215133.1923676-2-ojeda@kernel.org>
 <CAJ-ks9kARZT5TMrfXvAqmGdsMD+EgdaY061tyhm_n4oerFLOfA@mail.gmail.com>
In-Reply-To: <CAJ-ks9kARZT5TMrfXvAqmGdsMD+EgdaY061tyhm_n4oerFLOfA@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 27 May 2025 02:02:21 +0200
X-Gm-Features: AX0GCFtkmg5n1i3Rkj3QS56FAgXX8HJxYKe8JvyvMOKylvsvamZOsGINzJRln0g
Message-ID: <CANiq72kRMSLpXChRtLHgeHUsO39iSBNUygzcFXWmyCfetdC6mg@mail.gmail.com>
Subject: Re: [PATCH 1/7] rust: kunit: support KUnit-mapped `assert!` macros in `#[test]`s
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

On Sun, May 4, 2025 at 7:42=E2=80=AFPM Tamir Duberstein <tamird@gmail.com> =
wrote:
>
> How come this vanished?

It doesn't lint anymore -- the lint only appears to be intended to
work with the standard `assert_eq!` macro (and related ones), if I am
reading its source code correctly.

I created an issue upstream and linked it into our Clippy metalist,
similar to the custom `dbg!` request:

    https://github.com/rust-lang/rust-clippy/issues/14903

> nit: why not String::new() for all these?

I prefer that too, but I kept it consistent with the other lines. We
could put that as a "good first issue" unless someone gives a reason
to prefer other methods.

> Could we do this (pushing `assert_macros`) before the block above to
> avoid this body/new_body name juggling?

We can use a new variable, changing the line below (i.e. it is clear
then that we are "assembling the final body") -- I did that.

Moving the new variable then is also possible, but I think it makes it
a bit harder to see the three "main parts" that we assemble into the
final body.

But if you have a better approach or I misunderstood, please of course
feel free to send a patch (or maybe a "good first issue", since that
would be a good one I think).

Thanks!

Cheers,
Miguel
