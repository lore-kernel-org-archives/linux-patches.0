Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB1B3D967
	for <patches@lists.linux.dev>; Tue,  9 Jul 2024 17:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720546018; cv=none; b=BoXnUCF6gPNEjHjbQx4jAZjKPV2urzH2KnKgImhXwXm3mAPFrW3N0a5Qk+3Fd913Q9LbBDLRVSS3xUKA92h0jiqDA/CuIcme3ppnHtjKbmPqNiTxtsbHmEcykpGkjxcpm2LKh5jZ9VnIE5HY5NqaIm8eDPBg8aZ8HD1UL4NQtqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720546018; c=relaxed/simple;
	bh=xEGa7zkjzsiIbiqcbCacwWsNu1ijTpLI6cSiJFBTmDM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ShkPZJdcKIUtSX88zpy0+gkEKFWImP5clVdYHRnQjy5barDbZDraqngfR3DDleC6bNI+LrHV1r+kSuCjX5GRYpWvbQb1ZAs5kbb/6sLaiytv+gV7UC6P6d+D0C3tfO49Idh0C3FCjBpskq2t4Jp/xIfyDuik4Y7CCOYkMy7UEgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RUwSY7PK; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RUwSY7PK"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-70b0ebd1ef9so2696414b3a.2
        for <patches@lists.linux.dev>; Tue, 09 Jul 2024 10:26:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720546017; x=1721150817; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xEGa7zkjzsiIbiqcbCacwWsNu1ijTpLI6cSiJFBTmDM=;
        b=RUwSY7PK1R6VnlO7JyCEBuFMCcv807SHcAONc+Mjik+r7oBIPuhYwt+VXnz3R1D7Wt
         78fApipbDXrrAarzJdYM0g4Y28FYH37NbmtYydSCU/xy4r7Ex1wbEoBdCFEFi/v4TgZA
         QgcMvm1uQxCDk0VL7xjcEbH1ddIQcMqjifMiZsCIz+xBMDWPkiG5jtPpuWJXHuDoNFrl
         Nw9yTNcYRqPWAC0fUKFzv7V5VS607JFkpxgklI2qkTwVyAHlbBYHlwY36smBbdhxZQCX
         8UQ/pfgnzSgtNvmPUeQKWLQzrK/29NZBFa879RtreTS479xeCIbyPrvRI/5rdlnzehMj
         HHiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720546017; x=1721150817;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xEGa7zkjzsiIbiqcbCacwWsNu1ijTpLI6cSiJFBTmDM=;
        b=Z7C4XFxmdhwK1O+Hj6NIk5ZB8e5R/kUsE1qMe7sgh8o9xtTRDexnlrehshOaiSg79I
         lbwg6oi6S/HXFu2Gi5kAVVqsXbIjj374sGfEH6EUTdoOj/3rI0HeO0LAbNQBmaIGE/df
         0ShnLvEjW2ahd5ymWaaapeNuBmProNw3V6YTXGw65YMJ+24y1tfY0YirQV75jkGufyJO
         qMlJjaDQuUJMjVoSaJaUMYu2FHaKCRhw2aEkfEE4Stbh1e6TWrwHi65pf7Gd8KF+dN+I
         LunCzlaiIOotxJb+jfDZDv/YDEP9zJIyDGDXQs/ePIsvaxbnkwsQTF4+8P9Kw3aC61Lr
         PPpw==
X-Forwarded-Encrypted: i=1; AJvYcCUMGKAFW9mDXCJYX0vHxsf/M2iiilDwFrnPkBZ51lwcfeAXFzqEmv1OMghfBy6aVyeaREJ55FWQiaTKwDuM4VQu+H+4aUXUug==
X-Gm-Message-State: AOJu0YwcmtK9De1H9vtqdNhatQeTqNyF1aXdFGql/E/roc9aBIkqKOZ0
	HCgYnD3oWbKtEY+eegbTfasaI1jcbb1IXw0qdhru2QQrTwXRNgH3bfO6Fy09srV6eAZOVpE4yfw
	f5JVkYP9OX9R1FkJ6/aOxXfZbwu4=
X-Google-Smtp-Source: AGHT+IFD/VyEdp6BX4ESg9u5UEPG6dtbbRDyeOinfTVoM+xlvEchxrjSSX7hROo3qyMmwbS5fz9U9VEDbFyQRuqBE/k=
X-Received: by 2002:a05:6a21:194:b0:1c2:9d88:f2a7 with SMTP id
 adf61e73a8af0-1c29d88f3f1mr2016849637.52.1720546016963; Tue, 09 Jul 2024
 10:26:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240709160615.998336-1-ojeda@kernel.org> <20240709160615.998336-12-ojeda@kernel.org>
In-Reply-To: <20240709160615.998336-12-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 9 Jul 2024 19:26:45 +0200
Message-ID: <CANiq72=kCJB-g03s6fHtSYBWTG_MT3yMW0YvehnAhHP_edHPcw@mail.gmail.com>
Subject: Re: [PATCH v2 11/13] kbuild: rust: add `rustc-version` support
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Finn Behrens <me@kloenk.dev>, Masahiro Yamada <masahiroy@kernel.org>, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nicolas@fjasle.eu>, linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 9, 2024 at 6:07=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wrot=
e:
>
> +$(error-if,$(success,test -z "$(rustc-info)"),Sorry$(comma) this Rust co=
mpiler is not supported.)

Bah, this is broken, I just noticed in my CI that I didn't handle the
"Rust not installed" case.

Anyway, this patch (and the next one) are not important for the
series, I will just drop them and send them independently next cycle
to Kbuild instead. I should have done that anyway, even if they were
correct.

Cheers,
Miguel
