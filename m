Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5D461EDA29
	for <patches@lists.linux.dev>; Sun,  2 Mar 2025 19:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740945154; cv=none; b=JYMn8HDAY+oZEIqk8uvsC8f1A+1MY9p8Su+ZI4/ky1ZODBvZGY8u8GpChhAtPG3g6pvcb0ghxzJSj+Lt1ECWWM670SMBhKItS6PAiV4kreuq9by9QtgO0imircZCV59BY/P6ctmv34SzQWWQa6uQnG76cF5cW03X85p79fUsr+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740945154; c=relaxed/simple;
	bh=hHXySMyyjeDeeoBzepTdnF20WqV9PuveI92RW7vhLSc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SpzSqmaR/3et6LqUa11/CTt/UvRlAUUBY8kp9fv6jDY5KItAtVkUZweICOjsCe7rA4Ov+6PLU8k+KS/7l+AOPYF4YqxJ0r5wrYCP3s3jkkZ5Rul7/Oe+mRAk7FNG8VeAuxrpmNtDVz8SrJOHzWUnuq6sc+VvFlJeFwSnJ1Q4twY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lQVuacu5; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lQVuacu5"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-2feae7e56c6so982323a91.1
        for <patches@lists.linux.dev>; Sun, 02 Mar 2025 11:52:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740945151; x=1741549951; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hHXySMyyjeDeeoBzepTdnF20WqV9PuveI92RW7vhLSc=;
        b=lQVuacu5/ooCUpQORJqje+BswFJ6M/Ru9DmXoSHzTVD8WEhnnmNHHpVU6kNLQq1Wo5
         u/2I6XE6ugmSoxa3wU2SsYw+6rsMSUYEJfOftga1wwlw5bQ3GeS9mGo/DOrq/YJwz681
         cjXsc1SC7BcdJMyrn2dq2Ly4hMHBuBuvZxEC5PWzWoJsfJZvDL0IG7o5ilAFoCW8D8ov
         k4OqyhnWQB0yptFCUMGETeNGjWU7gclhlUXu/NJqJl0OipJxtiIsvmKNv6a1j5k2yNGo
         1p2auEfvS2HJrspSX2z1Izam4IDAFGFz99/0p8CdigjdwClvh1rJJ6OnV7Vsf3PthdsL
         46DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740945151; x=1741549951;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hHXySMyyjeDeeoBzepTdnF20WqV9PuveI92RW7vhLSc=;
        b=pQIcYAxKo5/orPb/O+5BefOEdDn7mZny7ZRbXUepB/I51S+ox/KneGunLFiAlSsb04
         HoNK5sEiBgoBSKtwJOQ70H4mpYulHkK/vUGipajBGzaJqWfYUkKmuXnOZu6yad22U3qM
         D4nX+gsLaxxW0Xf23tCzdCO+kYCc8mrdZFyLQIrGJw+lSzmR0xcaltem640SQ9Geqlzx
         EzfEc8qB78sUwlLZmR/QcQ41yqqq2D4iVnCqdVb/Nr7uyHEHoVHzzRJY3qWRU44uspvy
         kK9MVt1EKNLG4IuU7CKNZhtaT24BfYzFIYcueUNvxTez8WnL9Xhvc4vXjmarkpqrqdQB
         7+rw==
X-Forwarded-Encrypted: i=1; AJvYcCWSB1uXWeW1+skaZ9qOxxJbSnvlkuNHv1AJXydSkf8lBCatHe7mDDDxsvJPHVj2Tic6DTpCsWUr@lists.linux.dev
X-Gm-Message-State: AOJu0YzUAEYk7dqeVFX+1kpTaDKiT7MFrVUK+25umoyr6WWQoHwXHJh+
	8xWnYhiDHrs/6hMU0v9PAbv7fk/iFOP8XAIt59l9byTzuZPs2tRm4aOYv9px3PL2Go4ffFQhy8o
	NxLsPmG+Vef8Xh78i+EMgP1rL+n8=
X-Gm-Gg: ASbGncsY+xAcceiw6L/Oc4SUDw5uGOYTrJeT5hFnmV8OLqeQNAyCaensLkuc9Zp/p1m
	n3ozEhrEcyCThtcf7/Ty2mKvpnAE0sr/WjESh5WRgqkBr3OE2oN9Gl5kBftq6Js3m3wtrjk8s+8
	4JfJrsASJ/c/8jY+KwCxIRf7LMkQ==
X-Google-Smtp-Source: AGHT+IHnXTvUBTPtGobIrGFeedrO+dD850F4DUxvbbOgGEBNLvBYSu46PwNNNejdcvKsptIh1mncfr4QWRX4VhZrMPM=
X-Received: by 2002:a17:90b:4b87:b0:2fe:b54a:78 with SMTP id
 98e67ed59e1d1-2febabdc238mr6445294a91.4.1740945150875; Sun, 02 Mar 2025
 11:52:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250301231602.917580-1-ojeda@kernel.org> <20250301231602.917580-2-ojeda@kernel.org>
 <CANiq72=69XAOapYBurbwsQOEaw2uamZ6ta=DT6cC-om9XK3dvA@mail.gmail.com>
 <Z8SMTiWzTDjIwGfO@kernel.org> <CANiq72nQNFSa0quEwLYMUVw-2CH3FwrV695k-rWfoQn5r0Mo0Q@mail.gmail.com>
 <Z8SkCA5HD2WxR_W0@kernel.org>
In-Reply-To: <Z8SkCA5HD2WxR_W0@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sun, 2 Mar 2025 20:52:18 +0100
X-Gm-Features: AQ5f1JqoqH71Y7MXZ8zAgXFrFSAcx9pl4ZbmzXyaWyiug3l2Kok7TN_oewmQwdg
Message-ID: <CANiq72kPF5sS7tDrtp5vRnucWLkqvzDj6EY2UbyA+X+L72xszA@mail.gmail.com>
Subject: Re: [PATCH 2/2] drm/panic: fix overindented list items in documentation
To: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Jocelyn Falempe <jfalempe@redhat.com>, 
	=?UTF-8?Q?Thomas_B=C3=B6hler?= <witcher@wiredspace.de>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Alex Gaynor <alex.gaynor@gmail.com>, dri-devel@lists.freedesktop.org, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Mar 2, 2025 at 7:31=E2=80=AFPM Jarkko Sakkinen <jarkko@kernel.org> =
wrote:
>
> Ah, ok, I guessed that you might have some backing idea on what you put
> :-) Thanks for the explanation.

You're welcome!

Cheers,
Miguel
