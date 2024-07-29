Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD5E2148826
	for <patches@lists.linux.dev>; Mon, 29 Jul 2024 12:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722257247; cv=none; b=AM3H9fF8V20BBacYU0PxE1oyNNYEaCRq1MlVGVBsxUW9qktMdLdNk1q8a13AAwwHWNQM7/ApeMk1igsTXtQRqWTRTJ7Kw4f31Lf9xIay5qEQPpZtc2aorvecgrrkV6p/dQuZb3OYshsTrQE+mhTJDa+D0J0kCo+HmiUBUOI6IVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722257247; c=relaxed/simple;
	bh=xybrMFv0tLvK9ZzP0ZErhnNVRB+K6vPelKBUKtae6+Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oZS91Jmt95oQStsZWAW3kKAFkvqYcU0Hw7ijKIvI3hZphNsKvvughSMxzpvaHyToJDrMoCcxcAdwzOsEfJFdH2fUyTexnaLv8XiCRJj0f8Pz0lQCX1tM/t/RIQxQLfx2yDG1KeMFNiC6q/mZLLfMJwXchW4/MeqNEZAR5xIUIFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=irW8Twkq; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="irW8Twkq"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-79b530ba612so1882668a12.2
        for <patches@lists.linux.dev>; Mon, 29 Jul 2024 05:47:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722257245; x=1722862045; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xybrMFv0tLvK9ZzP0ZErhnNVRB+K6vPelKBUKtae6+Q=;
        b=irW8Twkq33A+IhKYpegxrwLlPSnoAzdw5t5pUQvNz85ac+HPTQvDzqvr0PSrQIFVMK
         TYISEdQfxqLlwEyRz7Q66D/8N0t5saTpPu6GWgkxIJWHByBYpNkj+KTWFqeTr43nMRTK
         DCrG+PbYsfT1WuSSTLrGucX1RnZTGlg/UrL2baufurt0PmSwvk4mzQ2xu73TFjMQT/WD
         fNYTnuZBuJ+Y4Sr2VxJWwkYwRQj8fB+uvXGC3KgBPQPnX5yYd7tWz4PuX6e2CeOjzv/q
         e7s+FSr9fvJ9XS1cNn4ofS/86q/82+5pp4CIQIBD8zyrLCwCur5kliQdg6i4YCeL3w4Z
         gc9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722257245; x=1722862045;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xybrMFv0tLvK9ZzP0ZErhnNVRB+K6vPelKBUKtae6+Q=;
        b=L8XQNgPsa5RRSLG4AjOlpW/PkTXdCZZt/gXk/HTZFuVMNZTQyqgfnHhaIoQdy+sv4Q
         ZCOxC3NwtccHennNwe1PT47XqBnUZVOqUS80g3PsUt254eIkNuw4DM82/wpmc4C9eAjW
         jfLTQFi/MCbUTIND0xtmzHDZ6970pVvN2exG+mYD5fhxvKWpRM/vo4rgRPbPNeVVCCn6
         +euaXjfnx0JcGaTvWQfbwUoARtniTK0EFy7qksOs5MTaaC/3MhwWTxSETa7FIJ5Iblpu
         p/ZNLOuStWLZ8Vn8PQr0NvkwLhVwmo1I0tIs/mU9De7dY840HJV4sO5gdfuQuDNUr+p9
         sALg==
X-Forwarded-Encrypted: i=1; AJvYcCWsHvQxNYA+WLmLbUffkCIazs9UlXnZnKYv3dt3z5Eq6CrvUiJviSy3YoKcjoJEkYs4Y1Iu7LBDnVgQ6Bx78nBbDKeXMUuLcg==
X-Gm-Message-State: AOJu0YwLswcNZrka8nbpIfb/rY9GDplbxtD+q9SbnAhNgp0/ls0Z8cIN
	SIuIHTCiChw9TbII0wW6BrYrwcykW3HlmkWwIED4Stnf+5//EVO7CJoc6swtwlx6tyYsTVr66V8
	nvGj6bA4ptnim8br9RLQxBX4Qvms=
X-Google-Smtp-Source: AGHT+IEnmV87/lZZE/9HhfyMADvh6qBGRtFi0cyC1KcMUMEI73XyuibiYqA3Ia9nZODzBMO7wFPNvBfiyCXyd9IAf1Q=
X-Received: by 2002:a05:6a21:788e:b0:1c4:23f1:114 with SMTP id
 adf61e73a8af0-1c4a12aeaf0mr6026445637.20.1722257244884; Mon, 29 Jul 2024
 05:47:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240725184644.135185-1-ojeda@kernel.org> <CALNs47sFD_GqhXNa7v+eC=O96A+SpPm4QtZ3=GbSxZ4zkTm3Zg@mail.gmail.com>
In-Reply-To: <CALNs47sFD_GqhXNa7v+eC=O96A+SpPm4QtZ3=GbSxZ4zkTm3Zg@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 29 Jul 2024 14:47:11 +0200
Message-ID: <CANiq72k1H_LzugFju23UdNEzcYHV5xaqVSL2Xan__Jiyvi-_Mg@mail.gmail.com>
Subject: Re: [PATCH] rust: macros: indent list item in `module!`'s docs
To: Trevor Gross <tmgross@umich.edu>
Cc: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 26, 2024 at 1:06=E2=80=AFPM Trevor Gross <tmgross@umich.edu> wr=
ote:
>
> Not much needing review here, but
>
> Reviewed-by: Trevor Gross <tmgross@umich.edu>

Thanks Trevor :)

Applied to `rust-fixes`.

Cheers,
Miguel
