Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1123613AC1
	for <patches@lists.linux.dev>; Tue, 29 Apr 2025 21:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745960770; cv=none; b=E7wZyZodA8j7sIUoUPuYirAcvtJJCb/Tm9q8bIUSCJ1yYEBnEvEJooiABMuSTWMi72JXEQ3183ldJgPWXlGXT395Dp07BtunkXMbFzXm3kme5Yv53bhCmwPIvsEcxH30lKptdzdXe4gNLsvuVbqb2m+741sq9l2Do4grNLQ2ll8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745960770; c=relaxed/simple;
	bh=RzYDec4OkUoNNepxzZ4lUv/mU5kGCwxZnzY5XUXzBI8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WFU9NGS5QbJpVQDwG8pc7ENT8YTsV9ecq8EmuYTjD3FhbCHvTKB1Dp6HOQd5XFx1Q9T3SIhJcwmmh3gnavBlEr3pbOMxQqh8DQVqxRvQthub3HWAZZMyjBRvVUq2prnce7LZfQiYre7JaTV1WbjNXx5GflWiKoNC6wz3uPOYU68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e86jCmgz; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e86jCmgz"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2240b4de10eso13230935ad.1
        for <patches@lists.linux.dev>; Tue, 29 Apr 2025 14:06:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745960768; x=1746565568; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RzYDec4OkUoNNepxzZ4lUv/mU5kGCwxZnzY5XUXzBI8=;
        b=e86jCmgzyzogaY8hJvvqjIxuFZGY6TUH0X41wJlZHLU35U2HDlZVd1EVyoRoEs1U6P
         yrHg++5ATsfGxMX2hj1cTQBfhpdqEoW7L01uwgPpRayh2t4bo5xDqH3TBjytxvOO2dP2
         ERpe3RGyunLPmPvfFehrsbwiSxKg4PywBkzPQvLmXq71BXF748f+ye3sfF30rSWs28Sa
         mq/E9+Lxtk2azJvN/Gp59gak+fpf9xzN5cuw78+TrjKMGodUnRHLKXdOMQ+C1uTNzAxB
         2tkj2zqh51dNcStKVEBGt3drz2fhJEdXLSFG8P19McojNasy08U401uFjOC+KxYpvEV3
         0Thg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745960768; x=1746565568;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RzYDec4OkUoNNepxzZ4lUv/mU5kGCwxZnzY5XUXzBI8=;
        b=AD9qbWXgpd90rHSwSCB7jIZV6b+QRp1pBlaV1J1n0AHBaIHDofiMkzB8BO0e5K/lWQ
         VaHau83/InZ5KG+CYo5m5bfjT5m6sNAOg2LXlCcTlOPBsNd8qy7XAb1jfYsvnWU6h9Dd
         3MT5otwT9GoZrIB4JP0+KINI+pqyM0glXD6xT3S4+sIA7VVBAfikWoK2P22hv8nSVlcT
         XeYAPDv4lqq0eJjW7+LfDbjWHIvSs97g414czvB/nE1isDSx3/jmpulz4DYsvwEZlR3b
         rGuxdIKenc39ncU8wzjlA777QlwXSrinG32VQNicldQR3iBO9+EwEtru9/DFjlpqEH86
         3aZw==
X-Forwarded-Encrypted: i=1; AJvYcCXuwx0/o7uR4lqE4rm7YHAPWbWQ0CnWZ4u6ILgOWuG2h+juXOZTFLkFp2mC3NOHkqDkqf3C02a0@lists.linux.dev
X-Gm-Message-State: AOJu0YyFo857nZtuVQWls0NeZjbhfxSh+mMPsr43cKr1FVfNedwKx+6g
	226l5lO/OFSAVk/wGwEurNADWUvzv41oqL8oailojwF37K58G4JLGL3mzGJ+/dQnlITjhtdbrer
	PfWv0dyY0Cq7Dz7jHC/LkX2WjqUs=
X-Gm-Gg: ASbGncvuW8JrKjxjkbiJxldG7bFSbGD2u6Fm24pQcfumHaGSTZddXfPZ8yUc3Z5pfjn
	ki8OAI6XKAAQIED+4Cu3QfTUgZ4ooaOQwPup0lQ4AsEEKYqXIeX25AFmr2y95bMHUi5yddCHngO
	3xGAobM1UkYa8wvbNwcCPRCw==
X-Google-Smtp-Source: AGHT+IFewB/iZu8YBL7iv9licgKWpCeJ3akfnuCA15ddgmQh6O79GlP5m1SYAeybuWOt0FWlzEQ3UzhLhfJQQC+RgUI=
X-Received: by 2002:a17:903:3b86:b0:215:a96d:ec36 with SMTP id
 d9443c01a7336-22df5789ee1mr111155ad.5.1745960768311; Tue, 29 Apr 2025
 14:06:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250429150346.392050-1-ojeda@kernel.org> <aBEXUG7QH0ymRuLm@pollux>
 <CANiq72nf86+OcMTNPQVnF=pXuaJVw0bFixMxs6qwS5vTh7RWxw@mail.gmail.com> <aBE8qQrpXOfru_K3@pollux>
In-Reply-To: <aBE8qQrpXOfru_K3@pollux>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 29 Apr 2025 23:05:55 +0200
X-Gm-Features: ATxdqUESGlgll5eIXdsnljOXRn_rEs7-l9d2t102HYDNgJ3Xon0Dx10c7oqOVjQ
Message-ID: <CANiq72kf3HY1FUwRVTGGGQVOXxgBkfurHustX6VfM3kYrz-3iA@mail.gmail.com>
Subject: Re: [PATCH] rust: device: allow `dead_code` for `Device<>::parent()`
To: Danilo Krummrich <dakr@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 29, 2025 at 10:55=E2=80=AFPM Danilo Krummrich <dakr@kernel.org>=
 wrote:
>
> Well, that is much better, thanks!
>
> I prefer this then, I really want to catch if some other code starts usin=
g this.

You're welcome! I will send v2 then, in case it is not "fixup"ed.

Cheers,
Miguel
