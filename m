Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 551261C2BD
	for <patches@lists.linux.dev>; Thu, 26 Sep 2024 12:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727355174; cv=none; b=i1siAn3RD1eJZfDIUvEEjmDQB9zBGzyet8R/+0Oosn+H7GHGL2D5q4MCdMDN+oS4ztQe53wnVKSUkLYuzWsx/a5tz463saIFfrhND7VJuR7L0JCeU1oFHjFazuOx7DhVSyGNpN54Jv0c2woDhx4WnYrJVF4WZeNOWw/InGWu7kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727355174; c=relaxed/simple;
	bh=pUpI01rYEYl8lEF1U+rLDPbRTp9AUUwCxq5GUhTAozM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OBU1E5UXQiWu0lSw3mCNi/INAEF1ssLXN6nVxPHm5msYJWzpD9Y767q3C+Qk/8ZY1CqqQhCLpbLi2avxz3K29yAHUh7QI6ZxBR063Ud1ipXEZ14VOEJhS9kNWzVlZjdKOdWx62pHCbhnJhm1RGFKLn9I0Ubo1XzQrBHpyTeVV/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GuhL82Gb; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GuhL82Gb"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-71979bf5e7aso721132b3a.1
        for <patches@lists.linux.dev>; Thu, 26 Sep 2024 05:52:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727355172; x=1727959972; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pUpI01rYEYl8lEF1U+rLDPbRTp9AUUwCxq5GUhTAozM=;
        b=GuhL82GbfaYu1tfS6XIhEzD4AMAUG4S2lhLuAI4G/42xZKSTBIXV+U7DuwNLEOQKEO
         WhPs0DCWfa8GIqLRovU8aOdBDhKQxr+ApX1DI0NpVa1ArMEvRKsKQlKwbSs1LjEfhz6I
         ryrV8kj6BS20hBpnazg9aMztst8L0O6UmvJohwzGEzSXLfjTa31jredRve4cd2quSrt/
         D2guIF318dUTtJzl9EbTUNFlK8jhEQHEl8XkTA/k0u3Fc7cXHqXVxs1qmly6qVPaXbVQ
         22e0PJ0jah84OW7SYRd4FOJaJAGT2xWwM52y8Y3oHTNB/e4xeECElhDYTzQAj5YrdqxY
         yuqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727355172; x=1727959972;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pUpI01rYEYl8lEF1U+rLDPbRTp9AUUwCxq5GUhTAozM=;
        b=N9NYAhPrneFmt+NP2dUBF5h8lCtF4CoQhhUilipndeXe9E/8bNWVbbA2BLtdGkqeuj
         20lkuZ7uSgmmjVHzV+idAFfXWZBepn2ziAHhXSMtbQPKwDazSUWmhoXfK5/P4jN1h7yG
         /enrrruIOXAAwCMWXu+WVNBtfG7ioLb1yQHrewMPgxGU6OW183WCjbK/19ykkiEv28nZ
         kU2RSs9rs6W/sXxe2ALcrUFc8IgUf61XVNxNZyAfHfWp2Je1rSe+4cfIbkdBVKKGT0SR
         qpPtU6QsZo1O5qOOy8aDlH8PMAWCGtyRWXvi7WLB2SCb6EX2+5xUlXRBOPPfscLyZMr+
         4dUg==
X-Forwarded-Encrypted: i=1; AJvYcCU6YCb5BfmcKxJTKAtJqW757CnFLXhUsTKVp8DJGDjwiEDmrqXuD//c245rtrPeyX4IDOQfsUtS@lists.linux.dev
X-Gm-Message-State: AOJu0YwgutAaqVd/ctneZaCBZGbt/uY68dgqG0C1d9s2zO6czyfMP9V/
	MU9/wE6G03BDI8dip2+fDxFNr3418yrqHeF8IfpaF7+OiDpcz/7E8EQlNfSe1eQYTgKr1LTWsLo
	WKN9Ou43qbNcZp4zshypkyPjxskWHFJuUCmJW
X-Google-Smtp-Source: AGHT+IEWKTQjnC7Cgd+zNjTKvb1kAwlHpzLu9nyHOTqSz08Qcm69uWAB1guPeiKTZTqyc1H+BozcQhfNsTBjkEkGSV0=
X-Received: by 2002:a05:6a00:198a:b0:717:9154:b5d6 with SMTP id
 d2e1a72fcca58-71b0ac45f47mr8660601b3a.22.1727355172204; Thu, 26 Sep 2024
 05:52:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240926124751.345471-1-ojeda@kernel.org>
In-Reply-To: <20240926124751.345471-1-ojeda@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Thu, 26 Sep 2024 14:52:37 +0200
Message-ID: <CAH5fLgg8v8Oy4-tKavqZYaHB-2pSU+14DwTPQOYL7d0cNww-jQ@mail.gmail.com>
Subject: Re: [PATCH] rust: kernel: sort Rust modules
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
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

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
