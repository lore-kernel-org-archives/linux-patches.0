Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65D1E126BF5
	for <patches@lists.linux.dev>; Tue,  3 Sep 2024 21:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725400618; cv=none; b=iwZhLWAyY6wqGkZpswOTL8N621ZSHey/64t14G8VmRkMvNyyna0wqLXWXDd15pwyHJH11L/CpIcz6/YFexHCDWSbhQCYnL3E3D3PwtQgkU9OzT8SO+ri2ACkN7xzRPpTFzlpjGWq3i3E7h7/9Va8/Yeu5q3NOAWFbd8AP6aBhqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725400618; c=relaxed/simple;
	bh=GEvdm2ML5hAmdyHvDrjNM6tMhQ+dZYtKLzN6HrIhslg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=s1Afc3z6Itz4+HYSnCYfafYdqv7Ter1JB9sV/DZUQLgMYZkSdpwO7PPdKwfsaC08xYwJDTcVspbKcPsX6i3bubvwGblbh1j9XLDi2uqSC+WeDjmfU9WhWT/xCiTmTq0Xe3+BfVPLDf2Z48+VOxYr8i3fUUHpiZyw7H55Oe4E8z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eJC8+Ckw; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eJC8+Ckw"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-714269f312fso679129b3a.3
        for <patches@lists.linux.dev>; Tue, 03 Sep 2024 14:56:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725400617; x=1726005417; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GEvdm2ML5hAmdyHvDrjNM6tMhQ+dZYtKLzN6HrIhslg=;
        b=eJC8+Ckw8C+Hy63+l4iFqowZsu1Q4qK5cBvlwgXl/wwToxjwXRo3tsixQ2yniCCmQ0
         LLqZfCX6SjxXcM1kYgEJ6GTK0XKSX4+qN9zvh+OlbdfuaJOUJD9g5OOIF5rklbF7mfs4
         KRAU21Y95l8lKO3n5oJEs+CU+3mW3W5SjMY2uzRri2SWDEvVzz2ZB8p+GmQTtRCljegV
         UzWoXCmUeGRMwFtR3vACGVWHmzr6CYDl6swDNMPebqYBKaenJIR8L3GMdpA1bEe4W/UW
         CLIIslqUwPahZA12NJBp7pb5QWrL0FkxNHBFyMtZylJGiuBGpuSb1BGn6No0xIT+PdLF
         tyFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725400617; x=1726005417;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GEvdm2ML5hAmdyHvDrjNM6tMhQ+dZYtKLzN6HrIhslg=;
        b=ItNg6tuGQalE3DmRA+iW0GTn3g3SX1ezM83M8CBSyJdPL2wnlZIfqTwqq9xAIp+q88
         ocp9pkTi3awQOC10UPcT/fIMkOPSOeMSeafyFB1Pt2NlDUToXOPZL9/uc4+D5izzSjsq
         vdHVIr8amtYzm4VF+Dwvhtgg37P7D9/hDTMaNP5uqDwbcJSzlMFMYD/yYPNMmxTbq2Tb
         9ih1JJ0PXaKVFuklno6OGV9Ut2860yvqWLMqLfpNvvHXlUOWwauzLvQptPOPT4EAn2tz
         +8J0iPZ/AT7WCv0fAtyalJ6HuwJjBlswWMEIvhyix4e/EB6/nKw7dh2sr4ZFTSf+T6rL
         G73w==
X-Forwarded-Encrypted: i=1; AJvYcCU7Int/yghLmcAOTtTjFB5QqbrZqm4JxbexO5xaxcuFFJSGb981U9kblzxL+s4HHKysTj+BY5GD@lists.linux.dev
X-Gm-Message-State: AOJu0YziLNpEoz0AkrK5e9juo/aO5dg43pCet90OtWxrEQ3wJK0geZGC
	88ulN339tn+eCzY681q/T3eOnUF1WbOCajPY5jjypKsk03ry3LbZXogtA6uMGhpuQdHwszR4+Lz
	wbNVRl96EzamVQO2VToTe9MRP8hA=
X-Google-Smtp-Source: AGHT+IG9Ts3Rsy57/ISSeVLDpOmDsIkdYIbRhT/z7Gw6akfQlkLkFi8kvgWu54+P8ag3xH2HV/7eiTvLLg4TKi2x78M=
X-Received: by 2002:a05:6a00:6f02:b0:70a:efec:6b88 with SMTP id
 d2e1a72fcca58-7173077f630mr8952365b3a.3.1725400616650; Tue, 03 Sep 2024
 14:56:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240902173255.1105340-1-ojeda@kernel.org>
In-Reply-To: <20240902173255.1105340-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 3 Sep 2024 23:56:44 +0200
Message-ID: <CANiq72=h3xQ8+b9kBYCxzAiGfpCgC18f7=AW+yNSDGG-dHv7VA@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: add Trevor Gross as Rust reviewer
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Trevor Gross <tmgross@umich.edu>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Wedson Almeida Filho <wedsonaf@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 2, 2024 at 7:33=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wrot=
e:
>
> Trevor has been involved with the Rust for Linux project for more than
> a year now. He has been active reviewing Rust code in the mailing list,
> and he already is a formal reviewer of the Rust PHY library and the two
> PHY drivers.
>
> In addition, he is also part of several upstream Rust teams:
> libs-contributors (contributors to the Rust standard library on a regular
> basis), crate-maintainers (maintainers of official Rust crates), the
> binary size working group and the Rust for Linux ping group.
>
> His expertise with the language will be very useful to have around in
> the future if Rust keeps growing within the kernel, thus add him to the
> `RUST` entry as a reviewer.
>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Applied to `rust-next` -- thanks everyone & welcome, Trevor!

Cheers,
Miguel
