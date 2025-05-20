Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5341B281539
	for <patches@lists.linux.dev>; Tue, 20 May 2025 19:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747770973; cv=none; b=r6AO8CMhMZbl384Dq1nYlsBNi0oRmgb4iEPq/qDOS+mz1Eatg8et0hX3LuUUmJk9xBySypw/6qGPX4MOxXfe2HuNSSUOmHVCYB2p5Q63nfPzO2q+aEZ5EraduhFV2qs/HOlTxQ8dJ37vEJIPhOf32w0f6aMvmgwptcgBmyKBPjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747770973; c=relaxed/simple;
	bh=5rxbJNyob37QGi62KumFHH2u1FmRDF19BAX10oWgC7g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AC6zKf2vNE6shVf+US1E/s14V0DWR1rW8Dsle5IOb53bvpKNBWIRdr14Gk0zhE7SLzWpMTOES7oDne8V6vanZD2Jiqm9gbDqgpognhEyZx8QGfqdGgWtp4MQWqru8rhrFEYc4aZ64PecEXbpp+woRCJFahoNGpoXF6pnFUYMeZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gOJVky8x; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gOJVky8x"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-af90510be2eso481891a12.3
        for <patches@lists.linux.dev>; Tue, 20 May 2025 12:56:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747770971; x=1748375771; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yRXK3+jUaFquyfrpafb1v4VMZEAhC0R7dGXYOJ0ETTQ=;
        b=gOJVky8x5Z2EkaetsM9IGjtxvelr+/DElb/7xFtqEJzD4FgavUtCJUYlimxn0SuMWU
         +2yX1bC8F5AAUbE1ToA27PWcLKtP47wHW0016siZRVlSnytiCN7mcW8ubWwZQTp2Ie7P
         2lsqa/IvnKFraX+ICn0MpA4tVrxW+NaHPut0VEw08ORvNwzm0xBdwL7yN5Mn4PxIpCwo
         ujk/N66cvKaH78Km2EEtPM634kMbRaqAdKxGk/b9S8fPJC1h41w2vO9UARdbT2NzAjXt
         hVh32G+xW0NGS7X8XjLt4iP0Qx6ZVFaPjrtgAURVm+fNOrLuUFvtdA7nLHw7EGvfLT+N
         dBUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747770971; x=1748375771;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yRXK3+jUaFquyfrpafb1v4VMZEAhC0R7dGXYOJ0ETTQ=;
        b=VhjsFA8PTCEIo+lWL5yLYWcFehLQJki+YUFcDQVjDStmZ2GfGZPkoaAii4QhLC7KuE
         wJ7EBdI0qg5t6MeUxQQ1Q5ZEUg54JcdYlymLkY8xF+C5M+Xumd4hyN5EDLCakbR6n4yI
         JaJ3V6uClQV/+c4BYCmFmeX+JzYKQvqEw7rMSwRJxdPTLSvq/iM8SxHyPxqMJELiQpck
         dj4fmWpcnWalcaIhTHTibBnFKnZR/TZ4jYYm2fvXBDab1eqE5hzp6J1f7AOTx+S/DtU5
         grcTgZZ8IvJ0+MuQrjyeaLRLvyCim8Imm9SJYIfTTwEt8VLGBS9JwAG7xR6nDiqOw4HV
         QwPg==
X-Forwarded-Encrypted: i=1; AJvYcCXi8uL7m1cwyvCrtFCXkSUh38oO8GxOXgCY1+Z4fVIRtTVDw5yV7ZRr6mSTHGgw9ZhwrEh0zWBS@lists.linux.dev
X-Gm-Message-State: AOJu0YzdQSgvsL85HLk+gdbq0RvENOOXgr3OLqN0aPlSJVSbiht/vYuE
	YAxiO7cqWKs4AQFTCLUl6hPdSAxaRGCA5wWDbNXYcLleCoRonWz8Ezlm+oUOIf0NZgg+BtTORIh
	eQM/4VCk5wdw9ILSJ6k4GEO96fEqXa/U=
X-Gm-Gg: ASbGncsxJWypMGB0xoV9rsvYSPzW1GYnMukThPvQQlPEGVELXepcNI0MgVNBf5FnFMx
	0rIOhPZwtYz5ljSmRkfTOR5JEtWALdgD7kVP1SE2wIHuo84J/7xlAb1RDqCAkK3qnRoX2rMEkiw
	sT9BZnvQgIn9AuvZVDDgWM0FKTKbiZysOr
X-Google-Smtp-Source: AGHT+IHMBgCvJ0ltoJP8XtyEBtuP89NjkLllHvz/zazFd2sBhpBWXHheguiDfnpgLDlesaU0sRxIYGwKHYkjm3yfw88=
X-Received: by 2002:a17:902:ea0d:b0:224:1579:b347 with SMTP id
 d9443c01a7336-231d43c6220mr96308575ad.7.1747770971470; Tue, 20 May 2025
 12:56:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250520195345.905374-1-ojeda@kernel.org>
In-Reply-To: <20250520195345.905374-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 20 May 2025 21:55:58 +0200
X-Gm-Features: AX0GCFslC1rHS0JBz-WpDnFZ7XYTlMemOVnCBI8Wl1ZLSvxJ1ZydC6LVz9_6R4g
Message-ID: <CANiq72krCWthBMDe8XEJP6knDS9dHn3jSkTBhF-CPBUgmL4oDQ@mail.gmail.com>
Subject: Re: [PATCH v2] rust: kbuild: rebuild if `.clippy.toml` changes
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Masahiro Yamada <masahiroy@kernel.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nicolas@fjasle.eu>, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, stable@vger.kernel.org, 
	Tamir Duberstein <tamird@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 20, 2025 at 9:53=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> +ifeq ($(KBUILD_CLIPPY),1)
> +       clippy_toml :=3D $(srctree)/.clippy.toml
> +endif

Not sure if this is worth it (see v1), but I think it works, at least
from light testing.

More testing for v2 is welcome (v1 is "obviously correct").

Thanks!

Cheers,
Miguel
