Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F35C6125
	for <patches@lists.linux.dev>; Mon, 24 Mar 2025 23:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742857328; cv=none; b=RU05ufUAlhrSPR5ikDQOYxrIYlc2aV3CQocjXuUmjHx9uwAZtBB0p/szWpy9OUWOg4olHuYxJMbwmcglzDmeh4ZxRE3XiN22DnUayJa7jJ5Ka6HKcjVFV7K37ItBVtjB3BmsjimYCFd0r9vlQmkv6uXd2db2qP+3UruWI91d3Ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742857328; c=relaxed/simple;
	bh=Sm/shJ53dQVUaek3eh5J6vClMZ+mhRTsX2hjr08eZAo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ccOvhTolSGLk5I5v3Id0g2A1GrfGNtkigck0mauU5cjETwp+phsKr4ofPf6mr8I6um6wrTuZv5KNjrn8EXWM6aQsBaYKEqVkDW3WrVWQ6kNFR/un0GonjjoCvksMz5aYG5C7K2b15JCXOwZgB6h6s8zVJmT/BHtpMDkGloHjyOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZMdDntrT; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZMdDntrT"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-301a6347494so1250670a91.3
        for <patches@lists.linux.dev>; Mon, 24 Mar 2025 16:02:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742857326; x=1743462126; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Sm/shJ53dQVUaek3eh5J6vClMZ+mhRTsX2hjr08eZAo=;
        b=ZMdDntrT5PJgMefZOdgRhPcq8d4eHyAkPG82OyXfc8OX2+nZjTtVO1PVb+d7k6nUm1
         3CkYIfRKuP1esU3NvhUydfZDytFPYUgdR51MMd+yryONLYi+VriFx3dC8tP8cHCB42bd
         PT2EFxF4loIajyh116jiMlFALNSPp77Niy8ihFJvieFwSJvTt5N0PGYbDGHA04PheWUX
         PjsRAJtWbiUmQ7K8qsLb3ViNbUcSdjcz4B9+r35UWriEfIZ4Ilbatn9sIiNIINGDrGxq
         8Vnmje3VG4Qq6SHAUdJcJ2YRL3avcG1RvvPlIIoPeOKtRKXwg1GFvDLB6pjfOYB4Rwgf
         PKvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742857326; x=1743462126;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Sm/shJ53dQVUaek3eh5J6vClMZ+mhRTsX2hjr08eZAo=;
        b=scEdFQ9YHmPw5meNENJBapTRDxXApow8JIQFaKp0k7hPPyRoM5n5JGJmQ8oEvs7ysD
         sSZQ2ATEuN5snRGz0WtGNVVszlmMyBuJPNe2EOwJtama53GM4Jtvl8Hnz7NkxF17ZHe4
         TUehthEyHGw3ZfWXPG+PeB6GLyrt67NCqXQkeIikMedrzNZVD1uw7gkXgVxafDdZ+UOU
         kAkyytQqfPG93R/loKKoGqjufy2bjHwSfQRvrAnqc9hQHJqsKHoBQKq1yT3FjI8IOdyI
         UMlZHyWxOw/w/I72/eQgVFCxVbQog8pqOsD6Wxnowyhy/nBGvkqO5TZctybpluq84t0i
         buaA==
X-Forwarded-Encrypted: i=1; AJvYcCULcMjiMPqoK96cFNxwi6N09Lj0nC7xdoJyD0j9fHod6uv64Lljg7hkzM7psphx/a7EexBYpGvp@lists.linux.dev
X-Gm-Message-State: AOJu0YwZjDvtn30LYQersiMk4tg7Srp7Nx9EN2dACrz0+BUf4H00d3yi
	L6e5k3iT3T0f/z6u/G3R1gow3T+IIFFbJ48Aa4D1OLKBB33pIVHh+akDMiLgtuXmlqch+ntxHTW
	D4E5QQP/QUClhGwwdhBNisExGjgs=
X-Gm-Gg: ASbGncufBgIuiho3yHytOCIOYhbd98j8IUYD6eDdmnhBzdCZRB3qLZyGxft/4uW8G/i
	+ZLdbnYjX1wptR0fkxll3SXLQhiCys5IT4n/o4hR9iThWP8neDq6I1Y7zIfOLQxzQzrj3CJpYRj
	9AhFykPqBTGTh1exGUxm9Mi9uRvA==
X-Google-Smtp-Source: AGHT+IF0N3IVoZm41r+EPPfeHaAlJgTDOk4ghAT1O/mKxGfrCPY/HsBSeXWetofbrS+dczLITSUjUfjwMphj7YT+nAY=
X-Received: by 2002:a17:90b:33d2:b0:2fe:91d0:f781 with SMTP id
 98e67ed59e1d1-3030fe534b9mr8779881a91.2.1742857326284; Mon, 24 Mar 2025
 16:02:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250324210359.1199574-1-ojeda@kernel.org> <20250324210359.1199574-8-ojeda@kernel.org>
 <D8OV6JF1S63H.NG5CXUZDQQP6@proton.me>
In-Reply-To: <D8OV6JF1S63H.NG5CXUZDQQP6@proton.me>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 25 Mar 2025 00:01:54 +0100
X-Gm-Features: AQ5f1Jp-b9ijstGk-lJRPks97YVdRTn8tjg1pmMJXHRdMAlOigQ_u0TkE93n4J0
Message-ID: <CANiq72kMGLYP9RzraKy8wSSYJ2e3PmBLyoSPjUbkhTT308Yr5w@mail.gmail.com>
Subject: Re: [PATCH 07/10] rust: pci: fix docs related to missing Markdown
 code spans
To: Benno Lossin <benno.lossin@proton.me>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Bjorn Helgaas <bhelgaas@google.com>, FUJITA Tomonori <fujita.tomonori@gmail.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-pci@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 24, 2025 at 11:54=E2=80=AFPM Benno Lossin <benno.lossin@proton.=
me> wrote:
>
> Wouldn't "([`struct pci_device_id`])" make more sense?

Yeah, definitely, it should have the `struct` to be consistent with
our usual style.

Cheers,
Miguel
