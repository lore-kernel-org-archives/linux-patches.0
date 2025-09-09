Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8144122172C
	for <patches@lists.linux.dev>; Tue,  9 Sep 2025 22:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757456548; cv=none; b=G75eLqFnw9yXn8knZXiHuwn+YyaY36rg0onebUKG7vaXlD5vACpriwurG1QAYtbKWe4MxxcQaaiW+2sK4RtIWmtg5aos1itEuzUmZyX4bnUzWsMdk1qPtuXVlpSS/1b9/IAsGQdB83mOU1M9J+POP/XL+ftRDGXnwryCrH16vCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757456548; c=relaxed/simple;
	bh=Y1+lVOHdJgc/PJLxgnBu4EYLxexrbOv/c65GNuXU3SY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TdZRJbH+25XfDfZkjoq/ciDjSP3VIWrAuMJU1qATXM20C4K2xrf9Wa/nTmbhMNjFNaUs6nELHfsvQaIt1DeQNcxj+baMzvwfOaggze0Ifdce/4Bxck04u74vaGFMYjTT+d5eJiUdKakhtB19iwNnSrElaKWR3aZutKXfcdoLPhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XX70HTZJ; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XX70HTZJ"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5607ac8320cso846289e87.0
        for <patches@lists.linux.dev>; Tue, 09 Sep 2025 15:22:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757456545; x=1758061345; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=14zKoaawmL+tkb0ufqaatkUvQTDgaxwDhKzZv+iGXOM=;
        b=XX70HTZJhmPqMsdvqkYYKdcuOLgDm8zjeXBH9l9W35E1eCE239aZMKhqVJOMbG7i0t
         NyPaTQE3VnWz/xwzGyIeS73SYvDHgGdoE/KLY2I4/v4BQNPeQ/mwzI67mzAHcWk3+Xt8
         LNOlDDVlLx0IRI6H4h7w9KtudBbo/4r2G/JCtbAHW178XoLyMrlwgnn1KIOx9q0jl7Uf
         sMMLUlsoNzmHfUE2pu9l5x7AYU0JTTwvEpapzZOIaBz6sF9XWEqrmcydt1uwSu/q4mqv
         ZfLctg7JcdfBxzxP9xi9DImqC5J7sfvupYNrAQGQI2eVXH0FQ50DbkGWl8AmMToMiNc/
         XBjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757456545; x=1758061345;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=14zKoaawmL+tkb0ufqaatkUvQTDgaxwDhKzZv+iGXOM=;
        b=veLO22KfHsT8xcGGlCF4L2vpnMkVHGXwIJrG3s/ubB2RsRK+rV5105BlDsfEogRxUN
         2s6mKdIPd0N4c6QgQxLoK1m7KDZb2v1Wfp6HJEuAurOPQTJUEySh/oeEYEjcbLltilrL
         +xbUpHbTb2O2IJIYMeoF7HYl1ZCACatmAzO9kwiVqqtk64/OzZLwUqhI0CNqEDLV1xUB
         KIAvyDQYgY7oPX8xRPEWs4CuPdGrgUZBFlV20dKiIcdi8qrjcaCAzBsujd6ymE1ClSTK
         8nBxwTAhX1HMQxV4D8IPrJlsucImLAEcJsdz7WAPTSLIG8ShbafQxz/ctWccpURo+2m+
         a85g==
X-Forwarded-Encrypted: i=1; AJvYcCXQcY21ti7kKwxSYZsOzNK6fBjieFdOtS+/aoc/GIHr0s555hrwem9qXKSPolDSQjSgcnfHhzH4@lists.linux.dev
X-Gm-Message-State: AOJu0Yztmjx4XED1OHhcRAQUF18JxH216mYVoM7umkj/yLptR6glUXf8
	orDLUtautlUtvkrOHPTdWt9lrrwIT5RcEBD1FGvchQRtC0ZAfYA9+n/X1NQ0VgPWyWqlTcHq28e
	ofnGiFAU4gm7ekgpGsnI9lizYgqJSSbgDtbVpwhHJVw==
X-Gm-Gg: ASbGncvG8s4KhBjjTgNCUCZKvYbVcsF+R8xo8pQcRgL43IkWvT2vKAj9IZnYh4nBrl1
	79yWKsDzezB57XXY9l6CzTd3bt38PA1mU+zP9zbZ/EzeSb73J20f5GQ0MdXAhyP2pwX5PI4UAtL
	5//zNYto4KaskPJVS+HMl9MeSCV1QqGDCOW8pNgc5z4X5uvmKJXlx9nIUQ7Qb9Ar6ZQgMJovTEB
	gmftAOHSfwbBbsXHQUikr37HuN6EuRToipSgyqJFu9K2xKnuTbci5kj9cXwPR2i6xyfeSo61gBP
	sfFY5JO78xGgVE1+cAz1Qt8mN9NOkKb5ONjzDmULvvXHZms=
X-Google-Smtp-Source: AGHT+IFDuCYxLQfV628Z7phqsroB85psQfsmvFVoNoEg802fzEjgvQkjguzByvEJEMk6c6/YwQXKAJTtY3UGkeA4SR4=
X-Received: by 2002:a05:6512:3b94:b0:55f:5965:e4e5 with SMTP id
 2adb3069b0e04-5626275d96bmr1967969e87.6.1757456544495; Tue, 09 Sep 2025
 15:22:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250829192243.678079-1-ojeda@kernel.org>
In-Reply-To: <20250829192243.678079-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 10 Sep 2025 00:22:08 +0200
X-Gm-Features: AS18NWCf2pIbJBXY_TohxQA27AKHeeu88lGrE2tNqE6BO5-_LqyV8PLVSxBYSKA
Message-ID: <CANiq72kS2OFaW+FEgSXGYup=kC3VxxJb32f+ZDs946NGREXUnQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] Error improvements
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 29, 2025 at 9:23=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
>   rust: error: improve `Error::from_errno` documentation
>   rust: error: improve `to_result` documentation

Applied these two to `rust-next` since they are straightforward --
thanks everyone!

For the last one, we can discuss it a bit more in Kangrejos.

Cheers,
Miguel
