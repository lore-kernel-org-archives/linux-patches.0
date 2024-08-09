Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A702A168486
	for <patches@lists.linux.dev>; Fri,  9 Aug 2024 22:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723241460; cv=none; b=DrdXz1eJA/60n2F+ZqNHFVD+uITCIC5QjgoATDwCHgiG3bdaa0bKAbsDJh+sMNBAm0ckH8dRPR4dXluweu45vARjXrWVEyXHyhL91LYS6kgSTwHLe6ODYCFii5nGUetDAiGMXqTsmHaBeBOtrA9yr9L+ZAbHDeXCkX6fGJv5q10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723241460; c=relaxed/simple;
	bh=oV3BloVbKuXLOtjJvcR1LOLMc57zeGyQ8iA4HgVEU+E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jI5ZtTeo4mPEUIaHMZYWT2Fba5BhEfmMzSfnAwiM48hzrCPU6MQJragGwJqlcIAlvMILbHsWqa7eZLzgNbtxr1sqphZVAQcxq/UMKoLz3b8ogFhLcshrJi//CvAZKux7EpYohQshCLg42uZMzwOWk2mSTCAwHpCpN7gw1bjfxJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VkpUfd2y; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VkpUfd2y"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-70ea2f25bfaso2056280b3a.1
        for <patches@lists.linux.dev>; Fri, 09 Aug 2024 15:10:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723241458; x=1723846258; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5ZtRC13ZBchav+u1uxCwOczYv6vnhbRu71MKK9b/fwA=;
        b=VkpUfd2ycxWlt0PopX0MZiitpoAUOL+HDy8heoZxjLIDFpZvkq/f8DIz0OLgO00Pwc
         3yq7MAt3PDEY7bR+Z3uhKMGjPwWqLPFUvQzPrDp4TVup6R2sxE9HnEn45y1B8tUbnt2n
         j3k+2WfUIHKc/1j+7oW+Tfe6y0z23/PYTEfP2Y6sEpDrlOm/7yOPNgAkUYKGubmrnnNS
         uNfwAmAxDR0yVJtXmxCbxK3VKgEn/GDRypFIojqSCvSP+OEYDfwgfslc7Phxz1dzvMgV
         Tdqd8SsZdc9MflPAs3Iw5YPCOohP/miF/NDi5O8CjJOZVT4hm+HXVgsqS5+OhqwpQrKI
         770w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723241458; x=1723846258;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5ZtRC13ZBchav+u1uxCwOczYv6vnhbRu71MKK9b/fwA=;
        b=WeJifrVqyhr6FHLhmfW0ZSv78/8XHqVLvEAwxY2vCeCvFoOphDMVyesZkiLCBpp2QS
         20CaV9UGC4cOtjFN7kfMoGs5IAKGaJmemcbe59Mer0wjrC8xphz0uw77iM8f30fcq5Q6
         J+xN99ChfSe0d/sf0Az6YPUd/BsYrcYCLQPmxPNsF9IxZFgQm3pNMdtNslWaurBeZaTb
         D4HPs0bLEZ+84B8zeRrJCYDb3r8TCmKKdoS5He+7mQkRpWCLc2GcA+EtJJsu/bhehNKE
         62y8MLkt+TpkcE2wONHyuKTwRCl8+bSkfCZHNxHq95qT5deevaFJfiDMkDlBcgdeYoKa
         z+RA==
X-Forwarded-Encrypted: i=1; AJvYcCUtCfR/GmYMdit9D+UPyWw2bo7+RGcZx9xu3RpmxEFq6HJXnKpTeoOGhb7PUmPMzw+2Z9ve7/0ME/DNV7UEsvBO4I1P01qbIQ==
X-Gm-Message-State: AOJu0YxDrPTMb0pWfAVtvHRztgKJ+ZehqA8gHIZK7K+XFOxoNe4zIC1x
	LeeCy2DFIyv9zw7ZDGaQFtopz5ckjGxltAJ5PhCHUgUaYg5pg95+8VYrEZdzZQNLN157wthRI+h
	esNQuttfZU0jK3XWOduQ8M4FR7EI=
X-Google-Smtp-Source: AGHT+IFYHFP4kSBzrnb7VzFHvO7PwEgU9Soz/rqlw3dbZs+l0O11QKxqnszd0Cfg4OCUtiqIzF4xXch/WAOOvLf6T+w=
X-Received: by 2002:a05:6a21:3414:b0:1c4:23f1:114 with SMTP id
 adf61e73a8af0-1c89feb0bc6mr3293218637.20.1723241457989; Fri, 09 Aug 2024
 15:10:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240806233559.246705-1-ojeda@kernel.org>
In-Reply-To: <20240806233559.246705-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sat, 10 Aug 2024 00:10:45 +0200
Message-ID: <CANiq72=JrDceFpoAd6gr1fm-j9B_xszyo8a4xJATtQ6U1t3HfA@mail.gmail.com>
Subject: Re: [PATCH] kbuild: rust-analyzer: mark `rust_is_available.sh`
 invocation as recursive
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Masahiro Yamada <masahiroy@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nicolas@fjasle.eu>, linux-kbuild@vger.kernel.org, 
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

Applied to `rust-fixes` -- thanks everyone!

    [ Reworded to add a couple more details mentioned in the list. - Miguel=
 ]

Cheers,
Miguel
