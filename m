Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 721F0171E69
	for <patches@lists.linux.dev>; Wed,  7 Aug 2024 11:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723031387; cv=none; b=ABHi3Fp6PsRyqnpPV9UFAJaj/1/eHzY6AQiW5eHKbi+BJaMzr+0wO05HrCHmAK4hZ2wN+cixt3WldlwawWIZsCDfJibNt9f8idqZph1qlO39ib5gdg9J4uMHHYnhj6KLdzw7cjwV3EzmfD7YUgL2CQrEXWQTZTQRVLtWZkjcxSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723031387; c=relaxed/simple;
	bh=a/dC9WYEQPdmFDxHth1Lwu8KV1JB3jsWpTUlohgSUHI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ci1R2hXmsooXbYghqsvdllLma7uGSwSUAWhCo6hwtnTZngsuhW9qa8xumuzPGPYElbxAJLtbyyBz1mlFWzEXmt203kli+44u2I6YlVNQBef+Dqa9EVrd7tjAIOzSpI9Gznzgi5Qf2albqEeKY5P8xI5XPg2SqZv/t2w0dZERx+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Qeggvq0R; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Qeggvq0R"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-36ba3b06186so952621f8f.2
        for <patches@lists.linux.dev>; Wed, 07 Aug 2024 04:49:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723031384; x=1723636184; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a/dC9WYEQPdmFDxHth1Lwu8KV1JB3jsWpTUlohgSUHI=;
        b=Qeggvq0RdwA9FurYPhahvhmy4x1+BollD8zFQd5MgAMdTEQs2xrJoudi9MNWk+0HFa
         6XtjbJ0DICQfbuUZRqwFcOP2J/GYVAc9e6pXOFPwLfEU/U6Qd0Fv88wA3UifHDCYEJhe
         ga8c0L6brTLg0qEexmNX62DSoQzTRFclpWVY1HmMh7M5jbSTDrjp65f94NBnhg2xwCap
         EW9XqWvBdYAf6xwyj9/Zgi0OsgrRNPrtPq9+6Qdw10U7o+hJ+rhj5Jm9eeBby4sg9kp4
         A3C2yDoyoK1Qfi0TnBMqBr2c/TNTV4WX2uthRzqc294EqkB0801BYH+hzev0ffMZgE8J
         ufUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723031384; x=1723636184;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a/dC9WYEQPdmFDxHth1Lwu8KV1JB3jsWpTUlohgSUHI=;
        b=O3TYc1LdN6A9VrSDNNXrfdUiEpNRu7r9I2pJxrQSN3iCL5W3iUJkTzgh2lVpzAqi0p
         YPCv52zEpAWY74xg8mqPBYav2Th7lhsvDd5FjUWRUPoGiBzJSZW9GKwZ2NPgudlht0IA
         CFoZxn4ZbAwmnXe/y/5jvUS9EH47vO4nhAjsdLLVHYFDm2OLAvxvBSZBrG64LtmVUNY0
         g11gC10v4qRYtoJIv5X0nJoVkUuOSPmoEeI68M3rjusZIT0aU0ohpNe3ukQH4XVwhMfb
         3K5odmdTQiz4I6VidRIWFS7Ag6F5laumFkbW1sDuF6eaCeGtf+p1oKp3/t1yB2al7rvE
         QWOQ==
X-Forwarded-Encrypted: i=1; AJvYcCVj/8pl8AfG4aiqvR/XmY5LhDYp9ohpBxPkK/9OKokcRKIgDv4QB+3a8OYuRT4aj+uuerKUn/YVu5Hf4Y8TE6ZBqIrDO7HALg==
X-Gm-Message-State: AOJu0YxXZcakhuWP0SD/CJCSjG5RPXekR/I6jH3r936KdYFPV6daJcOl
	pm9usdpDgT6tDuBZcf0hObrYNQ8s8YhRsZYo5HK0DCPVEdtEHqOvFyJQIA9a1HwLq3rbma10zz+
	ZZE8yNqWZ/3WiGnOklTKxqHs1FkXUpMaLPa+P
X-Google-Smtp-Source: AGHT+IEtTOVqbzU4EcqZnKqzn7ZHQ6dJC1In4BJyyOOt1USL9W8GtpPF1PcUdjk686l2fHYBMyX04R1GUZOIR9Bydzc=
X-Received: by 2002:a05:6000:bc2:b0:368:6ab:ba69 with SMTP id
 ffacd0b85a97d-36bbc1005bemr12210634f8f.28.1723031383491; Wed, 07 Aug 2024
 04:49:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240806233559.246705-1-ojeda@kernel.org>
In-Reply-To: <20240806233559.246705-1-ojeda@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Wed, 7 Aug 2024 13:49:31 +0200
Message-ID: <CAH5fLgiVwsxrY-PmwCntsx2=9u24TfFkNuJCJ4aioGD6V6ddHQ@mail.gmail.com>
Subject: Re: [PATCH] kbuild: rust-analyzer: mark `rust_is_available.sh`
 invocation as recursive
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Masahiro Yamada <masahiroy@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	rust-for-linux@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>, 
	Nicolas Schier <nicolas@fjasle.eu>, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 7, 2024 at 1:36=E2=80=AFAM Miguel Ojeda <ojeda@kernel.org> wrot=
e:
>
> When calling the `rust_is_available.sh` script, we need to make the
> jobserver available to it, as commit ecab4115c44c ("kbuild: mark `rustc`
> (and others) invocations as recursive") explains and did for the others.
>
> Otherwise, we get a warning from `rustc`. Thus fix it.
>
> Fixes: 6dc9d9ca9a72 ("kbuild: rust-analyzer: better error handling")
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
