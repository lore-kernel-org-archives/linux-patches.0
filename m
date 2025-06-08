Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F11B819CD07
	for <patches@lists.linux.dev>; Sun,  8 Jun 2025 16:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749401914; cv=none; b=lXVIzo1PLBD+QMdx7ik+whgA6b5DJlKUobQQNb8GIp93yICIXNBqB7AxiucBKbSPECi9rj8ophEr9iUJP+YO1XqGjyjEd+XYJGO19uuBn/g/NaMvPvsPHO45KFWQBDCN/biubVlX7XPD98qAOu6G7k3CnvANtpT3+JjdHFcIM4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749401914; c=relaxed/simple;
	bh=ES1nmazJC3eHPE4Dm72aaF6T8bwJef75vhIHbVci3TE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=M5muTNbFvFoWQpfG9m59IIvZY6ase0l6ZtST7LYhHSIG7sLC69LUwF3O8lP8j/LHhPdYIchcIJzBymTJND4024GUbos7QmeVjLmVU9EveQiXYRvOY/e86en4EOc9tz4aRft0iCHZZB8gacPV5NsCl6k9DyRl8CLQv2+3D/mxLNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WRYSEx8c; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WRYSEx8c"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-312efc384fcso581188a91.3
        for <patches@lists.linux.dev>; Sun, 08 Jun 2025 09:58:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749401912; x=1750006712; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ES1nmazJC3eHPE4Dm72aaF6T8bwJef75vhIHbVci3TE=;
        b=WRYSEx8cpJGZJ+GjJtClQBxg7M0YijrVsne74VI36/wkHwgsksqx7lyTLP/s8Zxm3H
         QWd1IKvx5JbGPBuQqixu1DhnH6Inujri9Pssl4s8Cvnb5WtoSy/cr6SxjV8t5QV/2yub
         Vi8x6RVbn+IGBYak7Lhjo8yg47VzG4xi0uB4NZWTPUia9q5mLDi1Ij1BevUjjrX/YSsd
         mORMQZkxi3JGiFHAuak+C7llXKCVWCcu8FvoK6tTrZZLYbuNRWIbUfOBC4yyTdacgw3f
         nzIbKjwOVSN4TXvMAYaRSUQuolp2qj4yI6cov6anXkH1CA4DMTz+K3Z6YkwtMs+8f3Tf
         c3Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749401912; x=1750006712;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ES1nmazJC3eHPE4Dm72aaF6T8bwJef75vhIHbVci3TE=;
        b=h9VoGRAdd4E8MrC0irxmIv6MO+60tE0AJnq84zeRL33VVgoRz5mlmmMlxjztcdF7/c
         QFjB2cGkRaP0GUvKO5p2v1FPlAPEMonacTWb4/na/ofNrwX8Ke+l+p5AOGw3ZLjbzs0h
         NwkWM/9U5sA8esJHQhFE04Tr3vy0qCuOSgDjwxilS6rBt43swild/dAq4nOx+nZZAalG
         o7KfQWOdwP0j5YsizZxUSt7lTNjnsbAld6gjqRpLmDcvoMTzlMAsZp5uhvZ9DEIxzTx9
         5eIYw9nf2Ux7Zw9E+wyXgvEDrpRLeufplRZlc/gBjf6zWPy+UiUk8Ku+zCJQIJmSSYHg
         FIBw==
X-Gm-Message-State: AOJu0YyFzO7m04lsCCl2fXRiWNe2lvBNTeXWq8nz8H+vhaEkGfkQlRHW
	ykNm+mDxHdgAqFd3Tz/gjgx8cjxCv8RRqdggv3MHtYF2yFYUu6VS7hdaSK8x45mTpNjbQAOtrmC
	GFtZYrYq3/wynotEdQJVoLziSs91ayg0=
X-Gm-Gg: ASbGncv0o+DsIUGLAH7R9qxbOzuGjBZBatBx7WXO8i8/RxuAK8I0LuNK7B2wMEBch+w
	0nXSG/Pv/KdN3coEhJ/XBTFMOoGgJU+5SWkbGB86mtCDVTMvriCDsYVYYLYNMugC1qreco0yUPL
	GoIJOKr3npSxjogmYZJ8AsT5/Qsq29LdDfcNS4eYAgYtY=
X-Google-Smtp-Source: AGHT+IFA4cilCp8konvSgiPyWQ58lP38AAeVmHos0qjl+W3YgE9/ft3sxbiQd2JYm7oZqsNfKL+FHzrJ6/JGbHhlXxI=
X-Received: by 2002:a17:90b:3890:b0:2ff:7970:d2b6 with SMTP id
 98e67ed59e1d1-3134753c519mr5493581a91.5.1749401912214; Sun, 08 Jun 2025
 09:58:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250608125427.933430-1-sashal@kernel.org> <20250608125427.933430-3-sashal@kernel.org>
In-Reply-To: <20250608125427.933430-3-sashal@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sun, 8 Jun 2025 18:58:20 +0200
X-Gm-Features: AX0GCFu6iiku9uzFUJGAP-W5yV_jv3JQSJcON9tf2s_TFjM-Gj7pUiRoU9T2fA0
Message-ID: <CANiq72nq8Yhj28MMUFBk1RbmuWaLssXbu3mz4rO_C6pV3GRE0w@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 6.15 03/10] rust: module: place cleanup_module()
 in .exit.text section
To: Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, stable@vger.kernel.org, 
	FUJITA Tomonori <fujita.tomonori@gmail.com>, Jarkko Sakkinen <jarkko@kernel.org>, 
	Miguel Ojeda <ojeda@kernel.org>, alex.gaynor@gmail.com, lossin@kernel.org, 
	aliceryhl@google.com, dakr@kernel.org, gregkh@linuxfoundation.org, 
	boqun.feng@gmail.com, igor.korotin.linux@gmail.com, walmeida@microsoft.com, 
	anisse@astier.eu, gary@garyguo.net, rust-for-linux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 8, 2025 at 2:54=E2=80=AFPM Sasha Levin <sashal@kernel.org> wrot=
e:
>
> **YES**

Same as: https://lore.kernel.org/rust-for-linux/CANiq72kEoavu3UOxBxjYx3XwnO=
StPkUmVaeKRrLSRgghar3L5w@mail.gmail.com/

Cheers,
Miguel
