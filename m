Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2271E194A76
	for <patches@lists.linux.dev>; Thu,  5 Sep 2024 08:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725523667; cv=none; b=gw6E8M3f3W54JQbSOecasOUcrjXlA5xDxkIgaen7yPWnNxn62lImh9npxm/bKttufB4MEmvmrfpuzn2E9aDPaWBhJZiW2TMCIR4MRrG0H3eR5Q+rIDL3mAUbj7Xv5cpgMDc1amRTGDaFZ00K6z3NKkG3IXDJcOcjqAW/EI4E3SQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725523667; c=relaxed/simple;
	bh=HZnCJipsXwMP4VZBsZOkHz1xv48awVQlqhiAnpcMQ/4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SG/9Scpv74lm0tU7vqs4RZ6v8rnGiyusCycPVJ1rj8Fi/6IuLWl4EdiwY7JKsZE5FjyheYb2drHfIdbEcSI7gu2ROMOr2W9zsh9z6vx/+znrJ+RIKwg6B8vGU3AOY+Xbe0OYL7T3kvPpI3/MMEOS04RpE1ggANIE99zL9jfCQbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=avX94178; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="avX94178"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-428e0d18666so3185015e9.3
        for <patches@lists.linux.dev>; Thu, 05 Sep 2024 01:07:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725523664; x=1726128464; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HZnCJipsXwMP4VZBsZOkHz1xv48awVQlqhiAnpcMQ/4=;
        b=avX94178jraeYM00EuXwjaA2XQgrOWq6i23wR6r7/U1+9/GLOpKVbyqvUWlXAOHdCo
         4k104NamC4uxqQWiHEtkqy1qwj9Re7AgkpBMv3KuQOGxM7CbbH5etEUKnKeFjyjOkTNW
         PWEXHqkGUid+DC47HCdBx+lddc6/XJyLFlBI5ge3t7YxkaKYqJNehl+oFXdymA8qDN3O
         rGUfXf0QNooJ2x2Z/nhR+WUQ8PDdvCowHc0dX2BoZsNmfCDBWUN8BrDi0iYwS+LkgSLn
         a5E4xcDTl3iwGZhdGRFkC7aXaPLTd6jLa3Y1BVs4UNCVWjNZBA8VS4KQWr1lStFlUnhN
         KgGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725523664; x=1726128464;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HZnCJipsXwMP4VZBsZOkHz1xv48awVQlqhiAnpcMQ/4=;
        b=iKuQKayT6zo567Rws4vQ2nWVGXF8yb6ZRGQxq4StCjTht6KLoFV6AMdgPZtu+F5mFk
         IvuYASDCF1DLsyWtoBdD70CZoAs6wq1qypCOjWXsZBCjHP8ssI2Koj0jzAnS/KUqMxz5
         9/O1S7Kibi2yHTtaF6LbVxiM4nCrj1yeVw/OXZqkHexte2xrn6+x+xSNyJtd8su5rCbU
         mq96kHJ41QIbxoS5D45x6OGHMVvS3vU8uxgALf5Eq1IYllQ0sQ/DxiOdq/P5vylqyhYu
         5oGqq+CqQ4JTEuP9Tu0md46vGK1U8wWuMEVAxUvXQCzuFq2j3eNu3mCvhbnXX6A1uLN3
         QS6Q==
X-Forwarded-Encrypted: i=1; AJvYcCUZ7baHlyYbNqnPrwcLdChw9fkGW4PUUAd4OWoajqaSGVM675ulZAz/cKLOfq3Ei+dtRxRnurFS@lists.linux.dev
X-Gm-Message-State: AOJu0Yz4h5D2qkMQB7j9Y0j+41iYRIEAxi9JuqpvUGV82aEWcBit2iDO
	fGJ0eXwqkHqvpM+PGzFWz6taxhkPqECaWtoLWawG8cd50yXyeUrgQTVB3IcErGuwr1VTdJ457lX
	IftjsLB+P/HWCNBZj/5Co1aVWuDGI1w8rXnrG
X-Google-Smtp-Source: AGHT+IFhiAj/3EFHGD/JiFE+H1pUAlKa3bW4DHEc6Kdw3MES/KJPwsv1V++t7JJOI75tAiCoDGf6ibbzuzPSulZPbkc=
X-Received: by 2002:a05:600c:1e09:b0:425:7974:2266 with SMTP id
 5b1f17b1804b1-42bbb436e04mr134483975e9.24.1725523664230; Thu, 05 Sep 2024
 01:07:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240904204347.168520-1-ojeda@kernel.org> <20240904204347.168520-6-ojeda@kernel.org>
In-Reply-To: <20240904204347.168520-6-ojeda@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Thu, 5 Sep 2024 10:07:32 +0200
Message-ID: <CAH5fLgjmBQe-VmNP5RUB3sAVGh7EKi3i6GZmaP2b3WZMnGkQ4Q@mail.gmail.com>
Subject: Re: [PATCH 05/19] rust: enable `clippy::unnecessary_safety_comment` lint
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 4, 2024 at 10:45=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> In Rust 1.67.0, Clippy added the `unnecessary_safety_comment` lint [1],
> which is the "inverse" of `undocumented_unsafe_blocks`: it finds places
> where safe code has a `// SAFETY` comment attached.
>
> The lint currently finds 3 places where we had such mistakes, thus it
> seems already quite useful.
>
> Thus clean those and enable it.
>
> Link: https://rust-lang.github.io/rust-clippy/master/index.html#/unnecess=
ary_safety_comment [1]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
