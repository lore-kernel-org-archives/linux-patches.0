Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73FBB30F931
	for <patches@lists.linux.dev>; Fri, 17 Oct 2025 06:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760683270; cv=none; b=GhegW4cpH829j2AmWXuW+ef5TbvJte4UkdTJ3Nu36yv8Ags1RmeOsLCJvD8b3ke4HZdh4HDeqHJWSv3v7lKKqed0FOwPiJUmxpVY4WK0Wju/ihAvamVYjHWDM3wT3VgqRQ+jQMyO8Lg4734j4UAY5ndODtBrvtYHYY7WbSir0N0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760683270; c=relaxed/simple;
	bh=HEI/VMPAQm/lLBFNuj+LnsxSRZt1uuVXLn4zoDoHKcA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WVseeUrHFecUe2tTCAaY3OgWyR2PFdLF4hvoOzGHH3ME7C0kjULX59vafYgczX+A9WpUJ+SNEmToihhzopYM0pKtxhApqkWE7XrI5wNwsDBiLk7ovjZQurN7JZ9OIWfl8/1XHjr2C26foBqw4UVDAwq9MR7xv5I9Xm+l/edyJLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uz9NQD78; arc=none smtp.client-ip=209.85.160.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uz9NQD78"
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-30cce892b7dso726267fac.1
        for <patches@lists.linux.dev>; Thu, 16 Oct 2025 23:41:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760683266; x=1761288066; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HEI/VMPAQm/lLBFNuj+LnsxSRZt1uuVXLn4zoDoHKcA=;
        b=uz9NQD789TMh5gbNkwBRzuhoQEJz8YQElKJzaG7CToyvUVcM1ZgJjapiMfoTmVWrms
         /ygH89J+5pKSSRAZjjUBrfdJO5TO0XWxRmNcD0p7geMud10Wf16v+z+QzdYcEuaAuovA
         xfvLz/k/B1UBn5lijMJaBXZMxy3fOLW/+5EVZVv2E8R+ZywX98Rb91K7145p6KmR4Hiy
         i2VHLEc7JA0nwjhg9aQHfNdwbWUQYzJfp76cZ6A3KpA7SzIhv6o0rYcGN42B0+LD7K0L
         BojriZQ4qc3upDO9xZy9TSy8gIKSDJpwetBLIuJt3Sso44ON74OsNFL7IwWcXaaceHnA
         Y5lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760683266; x=1761288066;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HEI/VMPAQm/lLBFNuj+LnsxSRZt1uuVXLn4zoDoHKcA=;
        b=KTmIexB/jeyf/ti5hRu9jF25lEnDXM6+PKUKNWPUueT+/0fNXz29kh7FogFijUfZiV
         gNDfR4KobTTAMbLlI5/HvPCA2uUXd+IeCTa+lmYS6EfPsgBFQRsRzJj7o5zAHJdBvx0O
         7x7EnraSW7t3GIEWQAWwu20YUjuaY8yKPP2Pn4fkMU9Ne7MyB4y3Ks0m0JZymZFwrqpp
         z/Sw4Yv8MWSdLusB6k49YBJTW4OUmz+gFY/U3/m3xyQs4qPDWfwHNrpH/vrrmxTMvXzG
         DOquzxMXSiKfst93Lyxgs3elALLDPeJOX4aBH5ApObk6IhJ9oLov8JEWQfUU/b6n/6rA
         vZAw==
X-Forwarded-Encrypted: i=1; AJvYcCUVED/h0nyU1e/Yc9ghJNfwzkcSYAUJNDHoNOI5OxLsZxDo88Tus7uYiRlRGVpxPKSJ1cPL3kpl@lists.linux.dev
X-Gm-Message-State: AOJu0YzHiX5EyV6qlslK6BzTDSRpORxDDQ8/G+GVQ6Mo3p0LfFrOQKO8
	p2Ucm2ESYSQHsCtjhOJnFCKrkWOpMrBRf7ycOGNMttKTEEMQXm/VdKMbACdro7rVCRvuWBKCPfW
	BtDaMm2TLZkkxtVlJlB139vGdOZet3OtGDU1OKwHH
X-Gm-Gg: ASbGncuVN/CnmuvXCDLz0zpdElOqNpSDI/8YVSuRE2uGgvf/7yRW2EVciaxXOe1OgHO
	pzul00BjIy7qV0SoTwj/H5gEuL2d5yP/ORhREzjC+K6zQroaKqTqDqUY2PEFna+OHlYWsOoKIqd
	t7dwW9AMHE62zzQwPdmt981cn+XbzAbyhaY8g3ifxMhbT8bjO2scfuiWSLtGFVNyL6DI+AH6wDJ
	fZZyUu0zw/nmd+3yVIo1YzA1YXJXCnhku6smaNborgqZ7WrzBGk2z2tfwx0hXi5FSIBK6z4b9Mp
	uSy1pXMBwtgynA==
X-Google-Smtp-Source: AGHT+IEVtA11UBYxqTUAD8SJlzk4igtsVuiFNGs1Vhi/4XOyirUuja1zneYwNbjp9heEcW9jRoymFU8GQqzMWhfMiik=
X-Received: by 2002:a05:6870:255:b0:368:e03:c3d5 with SMTP id
 586e51a60fabf-3c98d0fb311mr1107954fac.38.1760683266224; Thu, 16 Oct 2025
 23:41:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251016232118.1419895-1-ojeda@kernel.org>
In-Reply-To: <20251016232118.1419895-1-ojeda@kernel.org>
From: Burak Emir <bqe@google.com>
Date: Fri, 17 Oct 2025 14:40:53 +0800
X-Gm-Features: AS18NWAA1df5ukuaz1ezqHuBrLDNG8qPNJzmhm1IkYGRA3GoDbqAJNDFS4-e_5w
Message-ID: <CACQBu=U6fDA2MHB3PsWe-+gEjcGKZs_hGftFKuLjhW2z3LnkhQ@mail.gmail.com>
Subject: Re: [PATCH] rust: bitmap: fix formatting
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alice Ryhl <aliceryhl@google.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Yury Norov <yury.norov@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 17, 2025 at 7:21=E2=80=AFAM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> We do our best to keep the repository `rustfmt`-clean, thus run the tool
> to fix the formatting issue.
>
> Link: https://docs.kernel.org/rust/coding-guidelines.html#style-formattin=
g
> Link: https://rust-for-linux.com/contributing#submit-checklist-addendum
> Fixes: 0f5878834d6c ("rust: bitmap: clean Rust 1.92.0 `unused_unsafe` war=
ning")
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Burak Emir <bqe@google.com>
