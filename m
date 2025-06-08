Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFBE32110;
	Sun,  8 Jun 2025 16:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749399970; cv=none; b=I0Wq9rjTFuvgr5+z6NnRP9qpSL1qySfEiu2FprCNN8hTxYAmNcVJMXxezF2vGGW1gfeztjZ49Swd6bROHuMoc6Bc/zp53gn8y3K5mJ/6kpjdjVV105pYsNcYi3yNRM+X3v35bAiWcF/D1WdPeXxBtW4oBIPVb1nl1jTZlzMRvl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749399970; c=relaxed/simple;
	bh=PzzNW4GYkHNomnaRXPXgFq59NQwY/BC5aMCaRCMv1HY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=s3Nsc3VsGG57xQKtat4blUJPHYEHQny8IB9a6P+yyGYIZ/5S4KhfEmfd9qrK4MCOmITklcP0GpXZe/h3eN/R3b32MF77i3fxaYMsGJfIx1XNkaSyuadh9SMn4ceT/qnIX8UfUqmF8ZVdHjbAoyX7pmH1ZKrpqHPpNLrZnI4JhkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c4MDjs6p; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c4MDjs6p"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-313862d48e7so54952a91.1;
        Sun, 08 Jun 2025 09:26:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749399968; x=1750004768; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PzzNW4GYkHNomnaRXPXgFq59NQwY/BC5aMCaRCMv1HY=;
        b=c4MDjs6pmObJ6LjiTwLxRRc+Aj9czL4zrVatfuNYvkuqRlJutzbMIYtLasE+jRM0ot
         I503G+y8j4VJp/Wt1y3LgQUEh+5hKbwrK52aHMIacuKu1IwNS74+O9vLUheGO1Tk0Jzb
         KQldpvWyiGG1G1wrmobbkDQhqnVLQmHWHch/pYxF4Zdw8aZUJvv7PiFyKtN0MFVrLz9G
         FsU6oJq9SRmJWk+Bro6Z57ahQE0+Z6V3EKJIrBCcCm3gtQJx+eA5vXzfRVgGPjFVDZ3V
         dwjmpgi5M/ADb7Incq2eSrMbBQ//CKZBM4SA3aF17PF8UZ3yy9kj7QWj8s5bdSpkPtWp
         BTyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749399968; x=1750004768;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PzzNW4GYkHNomnaRXPXgFq59NQwY/BC5aMCaRCMv1HY=;
        b=hkgE3Fe8KqvM4PDcUnEukjGZLWVNVTs+kdCN/Tc+8GVUI7C4N5hRQ91D7P0m45WWx4
         mjXIaheCADDeXiCzGU7/wiHYFImVD2q3LZw9StOqmvZxNZzRBkn3+TFppcOSHa0TY/kX
         GcwI6LlpKhjrW05PCr7IUEGwzhdG88SsMwLjq07N/obAdTGp0nKzkgr7Thf+Nq6ZL73g
         x0e4Etltf3u1r0Jkmp1FQjfmTZ8Flncrbh0xAAk1dKFj5skoId9hTh89e/OV/MNqboPL
         mT49B4FLBrwBM7FSLxdAtIESjOEPVjffJfdsFtrCeY/HZAs/zqFZfI9rZcRbsluOsbmH
         tOFw==
X-Forwarded-Encrypted: i=1; AJvYcCUoZcavj92SY5tixcYAY7HGgH8bUiY31NgLJdSZ2ddXOczf8GXPcZKJ1H5ObbeWqB9wqqNz@lists.linux.dev
X-Gm-Message-State: AOJu0Yz9fUZ28kAuZF33CovDSplWQR1zbmgSyNZv6kNULnBmVd6y/vpW
	Y81zPuKsHaux0Rfg484FLjX+8c0kDZFmvqeEoiK0Dc2O3I0rVlqqFw+pKDV3xJVvEBF/YodLACo
	XmvOUuzZcwPOPOgsjt7PHHOGd0Kx1h6I=
X-Gm-Gg: ASbGncvLm6ifYDZBiHlq6uVCad9REeioIfs6Ohdx4IevqsaOrqVcanYHKC9NN8R3rqT
	GqRVQxxlcOl50W7AfLoWl0ev3F/UVfNGDxviGBb0J0DOWgWCF1DdN0mFsc9nrCsqW0wExuQjYsf
	b815OqDZGJNQvkyQxykw9hVKaROc/Q8srQ
X-Google-Smtp-Source: AGHT+IFwz+44MRpwrGOU7zTWXbEpeH22WJSUgw6M8gaL3W4srWY+3hAGTSCTgwmpWoQa5N5u6N7tE+Iglj29c0oFr/4=
X-Received: by 2002:a17:90b:350f:b0:311:c939:c855 with SMTP id
 98e67ed59e1d1-3134e415d0amr4910510a91.3.1749399968124; Sun, 08 Jun 2025
 09:26:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250608125427.933430-1-sashal@kernel.org> <20250608125427.933430-4-sashal@kernel.org>
In-Reply-To: <20250608125427.933430-4-sashal@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sun, 8 Jun 2025 18:25:54 +0200
X-Gm-Features: AX0GCFu-XvgktcoXpc-hI4_GwrH820AkN_9rLwfDQdu_Z3TO0m2kpatiNuDMY90
Message-ID: <CANiq72mGuSUb=mKs1MTL4DUYCsh6T_O5AsseYOfOyZdRZvU1dA@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 6.15 04/10] rust: arm: fix unknown (to Clang)
 argument '-mno-fdpic'
To: Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, stable@vger.kernel.org, 
	Rudraksha Gupta <guptarud@gmail.com>, Linux Kernel Functional Testing <lkft@linaro.org>, Miguel Ojeda <ojeda@kernel.org>, 
	Naresh Kamboju <naresh.kamboju@linaro.org>, alex.gaynor@gmail.com, nathan@kernel.org, 
	rust-for-linux@vger.kernel.org, llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 8, 2025 at 2:54=E2=80=AFPM Sasha Levin <sashal@kernel.org> wrot=
e:
>
> **YES**

Yeah, this should be backported since support for arm (32-bit) started
in 6.15 -- we should have marked it as Cc: stable@ to begin with, in
fact (even if probably not many are using it since it is a bit in its
early stages).

Thanks!

Cheers,
Miguel
