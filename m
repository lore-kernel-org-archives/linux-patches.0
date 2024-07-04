Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F05CA43AB3
	for <patches@lists.linux.dev>; Thu,  4 Jul 2024 15:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720106809; cv=none; b=rLNMUhrvu0m0dTCALwlO0DsagyWvubecIi8P1DXqynn2kzLNrdRbaJiSgN/NkoJkuwfGcXgFaI9vmhTlWbF+UFXejRkJGv5UxUjEDyQeyOIZCmqOYIZGHPXiIH/dIar+3c+hGV7HpVQ3mO0e/JQYVf74Zuem/5ExIAVN7Zzcuik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720106809; c=relaxed/simple;
	bh=MSME/Bhyf+gYGe96NNTB+BN2oAnq+gcEg2DaDsIkQ6k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BXjziM+b13K7VLP73QayZ245b/UO0CdiPHgoo4B1PHOtQNi0GO9eilWTMuQGXdnCfV5EeBcree0fl87rT3iNUx8jXRSkALIuQT2opGpJa1c8Ohfpb6yI6bMGsk2n04YXGpPWq1Bnj01DvEZ3WzsrpXYXCKmKQPYsFUpOHPj1eQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VXhnNgqB; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VXhnNgqB"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-2c927152b4bso550561a91.2
        for <patches@lists.linux.dev>; Thu, 04 Jul 2024 08:26:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720106807; x=1720711607; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MSME/Bhyf+gYGe96NNTB+BN2oAnq+gcEg2DaDsIkQ6k=;
        b=VXhnNgqBMy4OeCEDLoKmhiMbj0Hd1bjb4MMRfEVbtW1cjKwlr/E+kUtV7VXYVGLGwE
         JzQx6vIlDHGrkPvb+hO6VHjruxu6hcUOSZqqkwpP3oIxeDWFHQrlhsHhf7E54LA+iVCE
         Ao+7K9qXTvkX14ub/wYxJKxIVI3Ybt1BLJRA9PfanvUPl0giCXoPkJcdhhiskMta6HGT
         BMmIqsMNHObUbWL1cacdPLfHOR7MOzL/Yxz1EMWeKSkpiUvX7xn2Rl68NB5PKiHXdK/K
         x4Xv7z2QkuW9TT1OjtkJM4i+Zk05K5/5lAicL8H+pXz8OVdqYoRDAyNQoVG6ORvBwB5W
         AMRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720106807; x=1720711607;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MSME/Bhyf+gYGe96NNTB+BN2oAnq+gcEg2DaDsIkQ6k=;
        b=IDvXTOCT+Vs/La5Ina8VH2JEceWOqo4DphessB+rLIXE/vVnhGrs7M1pQwEw7wA+Fi
         MMmV40cPk8YtXgarRV0BfkpN1Kvm4ssNUDPwk27sdgvNSjH2jWouRExoNKAOuY4kZmBa
         xYcaT2eC1ejH+i79GMqPnK8lmUzg+bzf9w7rbYwcrAJ/xP+xChoa0B5OEClQfGXdG7fk
         U+OLENZO3loXWpjZoVTJAiQfkg2Q12jBwNlBu4DDkX2/V1njNA9X4w95BVH/Wf7jD/bc
         1rsVaKenzPM7I0eGaQWsuQFFbvDLRf32swmxK+GFTc8um55b1X926Agy+GgfPLDXupKf
         KORw==
X-Forwarded-Encrypted: i=1; AJvYcCUhSMTp36VeZMk7rx8jcLU1StqMg8g+XOelqyW4R8ef+y7RvWVG9KuOWMN8PoDmIJsFNw00wOdLZGi6stkNQRqxCyHnTV/cgA==
X-Gm-Message-State: AOJu0YwlxbyoTH7aOMeBhz+9km/M1BzWyL3vb2/q7zeKv6O6s2IqunV/
	LUR88PTXbfQzd4QVL5nlKyFw6SuhBSvZK8vJTozcbupqm8YQwYQW63OGXUJlX9kPQQE+MaET1Md
	CKRvM7biTJsYrjvKa0nW5DayBwwQ=
X-Google-Smtp-Source: AGHT+IEkUFA3sOH4ngyuIImRoRx17p6zqMQ7VBlnOblzn2dve9nvHTgy9+zJPLllYLzX1QFWuCt41+GDCTfChLoPZSQ=
X-Received: by 2002:a17:90a:b88d:b0:2c9:98c2:f6d7 with SMTP id
 98e67ed59e1d1-2c99c502d4dmr1502962a91.5.1720106807206; Thu, 04 Jul 2024
 08:26:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240701183625.665574-1-ojeda@kernel.org> <20240701183625.665574-7-ojeda@kernel.org>
 <70F3F3DD-AAE6-445A-AC16-C71A06C4EA06@kloenk.dev>
In-Reply-To: <70F3F3DD-AAE6-445A-AC16-C71A06C4EA06@kloenk.dev>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 4 Jul 2024 17:26:34 +0200
Message-ID: <CANiq72m4Js+ym4Tuq2sNfVGyxPqx=pZ4VK455dfocd8OuuZUxA@mail.gmail.com>
Subject: Re: [PATCH 06/13] rust: start supporting several compiler versions
To: Finn Behrens <me@kloenk.dev>
Cc: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Jonathan Corbet <corbet@lwn.net>, workflows@vger.kernel.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 4, 2024 at 4:45=E2=80=AFPM Finn Behrens <me@kloenk.dev> wrote:
>
> One idea below, but fine with or without it.
>
> Reviewed-by: Finn Behrens <me@kloenk.dev>

Thanks Finn!

> Would it make sense to not advise the min version but the =E2=80=9Cmax=E2=
=80=9D or just latest stable version? Min version should work as well lates=
t could potentially be a bit more optimised if both work either way?

Yeah, that is a good idea -- we could just say `stable` there.

In fact, it makes more sense, because this is using `rustup`, i.e. the
Rust-provided binaries, and the Rust project only supports the latest
version (so far -- there are proposals about LTSs there).

Cheers,
Miguel
