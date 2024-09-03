Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAD781A42BB
	for <patches@lists.linux.dev>; Tue,  3 Sep 2024 11:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725363393; cv=none; b=tMB/UkExm7dyNjtrjx1mg7Gt8e1G5dlmC9mG8NoFC7XS5oiGuBAcq5kijky/DYYbtfODq0PdWkHGo+wbv7pWDLj0kybOhI47+9/YIBaE17uQDGYj3uDlnjsbK+WkNO3K+/7KnfmFt2qXZq0zq5fOHSrL8C/u0Z1uhBpTH3PF78Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725363393; c=relaxed/simple;
	bh=asARBpP+H7LVbvgp5JjvVY/FQLEWo3k/g+YSUlchH5U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NBL8UpySc4mVtkaPWLyk6cPQX+s8/fe2HTaMzRkBX2r03SFoEjfHLkbMaI+jl/kwYYS7LBwFp136WSHkMN1Y9mMWURQ20xA98UbmN2B63WcNco+TjF7HLSjSsjWK1ScktAi0upb+PSOrfCiCB2PRuHji7iAztuqtzQuZoT4bU+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aqD2BhtM; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aqD2BhtM"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-2da5acb95d2so125903a91.0
        for <patches@lists.linux.dev>; Tue, 03 Sep 2024 04:36:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725363391; x=1725968191; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=asARBpP+H7LVbvgp5JjvVY/FQLEWo3k/g+YSUlchH5U=;
        b=aqD2BhtMdyy9UJ4w2BziD8jQLFuW3fELGndiKtQrHKeNXgJxBMPsjq22oh1NJJIjbV
         HwVxLFBZXn15cwG4m7ks6dXLkwko1c94MouZ24CG3rFV1F++Ptf3RGoMeTZboXLP2PPP
         62NMpS5jrrkvDUYm23qH4CYtfQ7R3IGwZVZ4A5VJ3LGn6TojBjUy1PxNzYcEtEqicSwc
         CcutTeOIuztwKIXkkxa20AArDoe9XiegwSPMg2TsCuGOViKyxTAOMDQzRfFaQwNHi1T/
         RxIo0aIIzrtNnj9T0a0sJaW+LFppHZe7gCxXxyswVDKFjf+k+wxR+xGjFAAPIEF3dJs2
         wh4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725363391; x=1725968191;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=asARBpP+H7LVbvgp5JjvVY/FQLEWo3k/g+YSUlchH5U=;
        b=DGCd+L+0JXUTF36AfXjMTZbiUn6qAESX7zsZr5RQc9XWOEuZfqGTqZLwvEn2drfdys
         nwdeUkesLAQPN2X2yG08Qqb7Hepz3eF5EGQj+PScoFZLQtLryvH3VxhWlbctasfyNkL5
         BNxWTrsU0kMLerT9DyfAl8nK0d1SAEK45Hfsp7x6rFuARPgypexrd4T7RGyE+tU/2DEM
         VRB29vDObKqRFMISy7dwtRCt7tzja62osOUvsTWLEiU1AqA6cU7tJGvaNuTQ3lu2/HgX
         9jpJfC1QZ4Ds0P9nsDlWILUxSb5HOCNSvn5loK5Hckxyv1/NbRcoJI6pODhizVz3usnI
         oMcQ==
X-Forwarded-Encrypted: i=1; AJvYcCVUyGUt7UGAAauW3P5kqXYTefpklkDDW4RfjDoiBsyRYT5L9ecoZQhNCvzrEUpOd8Zzchd0CnQq@lists.linux.dev
X-Gm-Message-State: AOJu0Yx2n6dGNhvpEsiW/WaFvjd+PkSvpktscx74dZ3JqHeVwmP4zvF3
	LnNjSMgifL4aT6AUhJBcY/Ye5PfILTXmm1D+ujQ37gAnpVT+51GRXhk/ozJ8kjJIW0KP089lWYw
	WdcuwWCbcqpQ5rf+uJL7KUdY67Yg=
X-Google-Smtp-Source: AGHT+IF0nZvAxjKxJ4VeOA06CHiHeMYoBFySFmOJlju68zlsJfRDVeV3UZu2EyE/P3zBUs6sodo1eGyKTp/XKD3YpjY=
X-Received: by 2002:a17:902:e303:b0:205:40f5:d1a with SMTP id
 d9443c01a7336-20540f50db1mr61267385ad.6.1725363390792; Tue, 03 Sep 2024
 04:36:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240902165535.1101978-1-ojeda@kernel.org> <CAH5fLghEz-6HtcpD5N8qXHZt8AK-8DUXHKXbHgs0YQ-pTJrTtg@mail.gmail.com>
In-Reply-To: <CAH5fLghEz-6HtcpD5N8qXHZt8AK-8DUXHKXbHgs0YQ-pTJrTtg@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 3 Sep 2024 13:36:18 +0200
Message-ID: <CANiq72nr+ABsmRC7E-vMp5vR=pKMxoNW0=oLPmA2bEXoME79tQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/6] `RUSTC_VERSION` and re-config/re-build support on
 compiler change
To: Alice Ryhl <aliceryhl@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Wedson Almeida Filho <wedsonaf@gmail.com>, Masahiro Yamada <masahiroy@kernel.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	rust-for-linux@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>, 
	Nicolas Schier <nicolas@fjasle.eu>, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 3, 2024 at 1:35=E2=80=AFPM Alice Ryhl <aliceryhl@google.com> wr=
ote:
>
> I re-ran the same tests as for v1.
>
> Tested-by: Alice Ryhl <aliceryhl@google.com>

Thanks a lot!

Cheers,
Miguel
