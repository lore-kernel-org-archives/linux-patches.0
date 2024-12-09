Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C177080B
	for <patches@lists.linux.dev>; Mon,  9 Dec 2024 18:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733769052; cv=none; b=cbIHMbFp6DZu1BhM1G93Z4PsO6vTDrC/XbIO4WadkLWm9fcenWoAzoRlBqp7/3rdUeD++RsaPRXACdpcOts+xyNV0xDkowGuZ8dQMo/fA+hK7WT6fG0N1u5A+4V4LSWXJmKGb/+D6VyQFigtAKllzT6WF8e+Fwed9nS/21nMFVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733769052; c=relaxed/simple;
	bh=UtEoHt2xQyF3sPBxmQA/6pu1gDGg2GJJyyZjJgZ3j3A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oFU28LdIDRgKmjTQBETI1TLsSte2/cmhfT3tLgg3nWO5hyQpw7Xvh6pd+45K4FiqxOVEd9e9tebuCaDUqJWK70qqu7pwhFc+nTsc+W1ccRttMuHBG2Sjx0yTF4ue3FHBuNP6Gq+RZ+ua8Fh/UNby4cE4t156hCmHLF8FjNsw18g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KRwDrjDC; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KRwDrjDC"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-2ee8ecb721dso826223a91.3
        for <patches@lists.linux.dev>; Mon, 09 Dec 2024 10:30:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733769050; x=1734373850; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qZhnISB9e+p8LIlAWs7kKYcT0D8jAeuxPpbppONh4HE=;
        b=KRwDrjDCb59fbtKecYrdOBJH2jmMc+pwEiHX+0Ki8cFK77Lm7fDqdVx5jEDIKwi9su
         RAopCFfFWFi9wonGoV3vGDf6l8fHnUIci6Wims2xWSI6Eaa49iE9cGsi8Cv1/8g4uTeh
         1mCUKL24UO1QEG7aOC66DtrZLTuhIV0GDPnZ1N6CFFbjJNCz35FDzq5VF6t3D1bPETWY
         N6EUi8KEvHCF9rmj+aAOTAj6wXr5rHFMtmU4DnY5Qc/Fco+u020k7qXhcbXyQWbRBmL9
         InwpbTVDSRnULGgdx2uG4zrIbeTYGRpUXWuMiZkJ5GqxA7ALfvBx4tBVZB73hH17Zm+C
         3a5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733769050; x=1734373850;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qZhnISB9e+p8LIlAWs7kKYcT0D8jAeuxPpbppONh4HE=;
        b=A644/zK/mw7UYa9MLkGuuHMd6HS4nfXX6Fw0ekLZf+Egje3ZFu9e+tZC0mQDvMXWqw
         A5P8ME1ggfM6lnVF+LFyEn/BFjHCpgn//FsugiUAQIn2SMGPgFs78z7tXYsCBgqyG25z
         pNYcjRU4F2gRzBsIeqvRc9LWadXxaCvsW4Q3WthdC6/ZVfAnvyCqGeTcwzMIIfOStbtj
         /uS4NpaVn9QbFgKdt3Z1/DFYzyrhQ/J+s3KVQQRp8Y3kaM+u4SJZ2Isu4tO79KeTGaBF
         whjlKvNrWV9jUYhK8TPoKWko5aKSkPt4S+cHb1+T+XYZ1u2mQIbmMXBGDI4tLnDi9Rw0
         JTvA==
X-Forwarded-Encrypted: i=1; AJvYcCV5FJdiswD8l6xWxXIteUqIkgjVximPAhtbs2OzKtEvwxooXH2zBidccdGVZMqTxCIYwkmPpZQ3@lists.linux.dev
X-Gm-Message-State: AOJu0YxLzOjzyptKugDknkHSEpx+80/s+L/OQSDyGAyzby5lSAJvRLVy
	qVea4bCm7C7O78KYpQ6a8zazcLlaUivvtwxn+VobIDNOJLYuTNaTJ+jdaq7150dnDkrkCgG3hJM
	DQpkw3dJkcEjN1BrVWV+PLrZWijk=
X-Gm-Gg: ASbGncvzDT8hglUGCvWDiCrZutwxq8YH3Jc9ITL8PfjnfJYu7fuTNR7txthhSxUf/Fq
	1BAtjLqODn0lXZiogj7piHipEpnRcEtQ=
X-Google-Smtp-Source: AGHT+IHXd62Kq2IM6B/3wDXQaXYXPWyVI2DbKc6JGiQupW7Zabp+03AxeWDUcTymkWmsVdt4rdTUsTHa35eFJAllHQU=
X-Received: by 2002:a17:90b:1e08:b0:2ee:cbc9:d50b with SMTP id
 98e67ed59e1d1-2efd4a1266dmr308170a91.4.1733769050254; Mon, 09 Dec 2024
 10:30:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241112184455.855133-1-ojeda@kernel.org>
In-Reply-To: <20241112184455.855133-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 9 Dec 2024 19:30:37 +0100
Message-ID: <CANiq72=BvnriScFay8SpLNe9mNhjvGsBJ9W9UtdzU_6v_i+woA@mail.gmail.com>
Subject: Re: [PATCH v3] kbuild: rust: add PROCMACROLDFLAGS
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>, HONG Yifan <elsk@google.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Jonathan Corbet <corbet@lwn.net>, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nicolas@fjasle.eu>, linux-kbuild@vger.kernel.org, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 12, 2024 at 7:45=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
>   - Removed "additional" from the documentation and commit message,
>     since this actually replaces the other flags, unlike other cases.

Some news regarding this: we asked upstream Rust about supporting
overriding all flags (including e.g. `--edition`, `--target` and
`--sysroot`) and apparently this was already accepted via an MCP
(thanks Oli Scherer for the pointer!):

    https://github.com/rust-lang/compiler-team/issues/731

So, in the future, `rustc` will likely get support for this. Thus it
may be best to go with an "additional" approach (rather than
"replace"), so that this environment variable works the same way as
the rest.

We can do that by simply waiting until `rustc` implements it and we
upgrade the minimum, or by implementing a workaround on our side
meanwhile. For instance, something simple like:

    $(filter-out --target=3D%,$(s)) $(lastword $(filter --target=3D%,$(s)))

would be probably enough to cover Android's use case since we use the
syntax with `=3D` elsewhere rather than with a space -- the equal sign
plays well with Make's string functions. We can also add other flags
if needed.

I will send a v4 unless someone thinks it is a bad idea.

Cheers,
Miguel
