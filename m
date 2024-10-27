Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F6EE130A54
	for <patches@lists.linux.dev>; Sun, 27 Oct 2024 23:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730071723; cv=none; b=Wi1DKf5ZCCR6K1ML0TYqIV/Cob1fha37c+0s1d+iemXi3pF0hk0yQ5AQ59sKa+OkBEK2VuZ4PocBZZ4DfK4yykUaxX5eqcyLyIL0mLs6Jkh/ApNBW8nGhtWirVYm7dghk1l1N1MzneH0wm5HRbkAOKkQj/pz8Jwx3VxmcXMYsjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730071723; c=relaxed/simple;
	bh=CYK5sksRp+HHK6ke3ltM89SdmUKYCjXGNd/ci7rSmkI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LrQvM+qzHnX6QG/ObXO+ijuNRSeHm5AgAq8TTT9EQ8w6O/S2ObpQKg3kZi6Wm2PxhHnnKhs7+HZlbZgMTgBYkTQ9SpDYBVzakE5vrJwuwCTYXRTQON//MVcKPOWUoVtUcEa5dH9ncHwkPsj0VED70pxHHnpvPoziar/oEAzsqM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SRhQuGED; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SRhQuGED"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2e2b4110341so586622a91.1
        for <patches@lists.linux.dev>; Sun, 27 Oct 2024 16:28:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730071721; x=1730676521; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CYK5sksRp+HHK6ke3ltM89SdmUKYCjXGNd/ci7rSmkI=;
        b=SRhQuGEDujQOnDhN6TAyNHQM/7Hu+4nKw7IgZtcpv0L7Y4EgwZ8sQ9bLsvIBIMcI9O
         bDa5voRjakkWUAU1vOGtVGx9s+CBMHluAc3piH2Q4R/4F8L+TPJD8Fv71eAfU3MEp8Oo
         7o+18W1xmOFyT0XPCQdy/IDx3Bu8endP6EfxGTB3Fzi9MQy8IR4j6xGd+pu+tZRfRALv
         z3qqIkgOFADfmNmxVnSSlVFqkoEsUut18N6CaiI45wmp2UwBQ7fmfxhxfj0zWps9LbXQ
         JZOlcuirpSFHLUURJMeTIJSqWY8LpplLDBU6tclhEk3s6gxp7bztyviHQssvkVH7bW5f
         oVug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730071721; x=1730676521;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CYK5sksRp+HHK6ke3ltM89SdmUKYCjXGNd/ci7rSmkI=;
        b=OHaTOqzA/prDdVx3NWz2dYQjpKwgW8X9Lg2YzSXbUgXxQodvAaLusqpmlEdSTK1+1r
         mWlj6rqzd1p2evLy2RqgruF6JtQA8qNfLi6QzoBPJka9+sHtZpcYVW+/F2leoy2A793b
         7/Qt7k3+H+FoJrHO+TAIxywTBFThIL1oh8trwpiv0TqWxIq98OWaPkdLsaAFgsaiH5SF
         fWJBbXLHDgrTqDwNzDtVQLW+x/lfZwX2HFxSE6xy9A34HIY88uxZDiz8idnInmNBvJ8J
         N2C8OdmflSCHBljKVPc4LTmSzBVztt9Iww9Sgxw4Ezml/C4dSdKxZNJtoTwl5MekQ6CC
         mLMA==
X-Forwarded-Encrypted: i=1; AJvYcCU+byAV6q8RtPIqIe8pI0yQocvTSohHIePpB8c6kkOL1uX/u1DWYFADcPj8IGOYAjRo569/2wcZ@lists.linux.dev
X-Gm-Message-State: AOJu0YwqoaDRwHWUaSQi6S1v5cuYVhKvwA/pwtuPYuhSfquampp9zyP/
	jQuPO4e2fLX6hVbaEvytfkdIjAtHXaHUtSlJvIDPm10BjTeYj3r4bccjW8gycI7xT+j/wTN3KYc
	Uoh22E6RwggkPpwFGeFPJVo3IdQw=
X-Google-Smtp-Source: AGHT+IHq8rw6W8p4S0W/aeuhnIgrpHXtsRtdd+z1XCCrOBHUp853lIr5u8gfY2RgCHl2JwvNYEokrNqMnwuiiLIT1kU=
X-Received: by 2002:a17:90a:718c:b0:2e2:abab:c456 with SMTP id
 98e67ed59e1d1-2e8f1051e49mr3244664a91.1.1730071720605; Sun, 27 Oct 2024
 16:28:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241027145636.416030-1-ojeda@kernel.org> <20241027222505.GA2882707@thelio-3990X>
In-Reply-To: <20241027222505.GA2882707@thelio-3990X>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 28 Oct 2024 00:28:28 +0100
Message-ID: <CANiq72my=xgeu=TZZAZKEvRq_wKm=tr=Juv1Mxdf50MEVxi53Q@mail.gmail.com>
Subject: Re: [PATCH] kbuild: rust: avoid errors with old `rustc`s without LLVM
 patch version
To: Nathan Chancellor <nathan@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Masahiro Yamada <masahiroy@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	Nicolas Schier <nicolas@fjasle.eu>, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Thorsten Leemhuis <regressions@leemhuis.info>, 
	Cameron MacPherson <cameron.macpherson@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 27, 2024 at 11:25=E2=80=AFPM Nathan Chancellor <nathan@kernel.o=
rg> wrote:
>
> and it still works for me with rustc 1.82.0:
>
> Reviewed-by: Nathan Chancellor <nathan@kernel.org>
> Tested-by: Nathan Chancellor <nathan@kernel.org>

Thanks for checking! I took the tags.

Cheers,
Miguel
