Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E59B42147EE
	for <patches@lists.linux.dev>; Tue, 14 Jan 2025 22:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736894826; cv=none; b=JUPJKT5YEDXpM01mybyGaSmVrIIPcBMp7u5rSw5NUzcRWIE8G3wUtfhNfwLe4Lel80xXQCcElMGPvwu/ABMTZ6+aC5opqTTgmJzl0a/rIPsubgj6F5z5ocKXo0FI7kFnYBxjam4wHjZNOIxkO62qVmOFjW2EKE/AxX1yyb+gMLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736894826; c=relaxed/simple;
	bh=IXANTz1bJSDyjXEnN8PxknznKsE2jL8seUW9FVQiReU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=t5Gy7stTJdW4MLH2IRJfLB4n31/ZecSGcQ+E9V2oqOeYHnUrb3xnMp3eI/OuFKT+/sCFO8UYF8J0a0Bbm2kzeB4ooODNsVMc3IZHPx6KfpvJ7YurEbEgwpExBsPNvmWZugfnOwTbrPm+ViUHmB8st1qw6W/GkcODbEGEqzEmEA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WoevlAxs; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WoevlAxs"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2162b5d2e1fso11806085ad.3
        for <patches@lists.linux.dev>; Tue, 14 Jan 2025 14:47:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736894823; x=1737499623; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lozpaj0g3GYjPfEclpw5ZqeH+g5/kYsdh3R22/oSzT8=;
        b=WoevlAxsuw2gUoA1rEHXUJj7Z7Lx6fiG5vjRS/tv/32HxpWlAwyAdiTBe+N+z/fyup
         gX3D50u2b9bpkh/gHnf/blLIjA3N2Olr9DDjCnW5p/v07S9ccFmX58PYk+5rmBOUxYCV
         /gtxuwJUatQxhD8xv1hWsTBvh5sZ/Mh/d+dTftmGBcYO6H4mkbWGSQG4YfztQjhKYmnf
         txZS8v4utCfy3cF7gIgKgKjgfS8GAkoSNyJf1Ji7ADf+TNDjbTQuHuB9H17Lt+sYd+FX
         MwouuDE+I0k8Ydp9kvB9qBSKKuTs0zRMzivCB1oCDmOGQ6VbDAVdY61Kv/ujwE7o5U/u
         ltlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736894823; x=1737499623;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Lozpaj0g3GYjPfEclpw5ZqeH+g5/kYsdh3R22/oSzT8=;
        b=bl009CPvDEA0eKY5E/XgqOykGdyV12SxCnJP1DOAoPukYkuvoAfVcQGZqC3wS3Jqxh
         4VjbCkeWag/+170aL1fdCvn7uwMln3viBd7z1wWG/VDKpn/n4J5AjKHgRDxUPPMgM7Xv
         nBCNAZrpYOV/LcrWYLyomS0BP1e6Lb3YYgYk70zLSJSGizNYryLb3t+6JHt9YGNyf3tp
         j/AqCUSdlEor46T2EevsLh0zFmmHz+XW3Ve9loPj3KnOm6CFLIMO++VEpl+28C+xC6w/
         0ahDdo/ciYvoRGl7/Kovvy1JweHzUi0kYatefzkCnBV1SQASgq1PUfLxTOb2BEUKL/6K
         2Wkw==
X-Forwarded-Encrypted: i=1; AJvYcCXfOtHWnXjtgZ+Yr+NH+Htn/rHpFrZEZZkuTFOO+LJ3qeBq+OXtPyzYZWf2ncJA3nMCoxbEJOxS@lists.linux.dev
X-Gm-Message-State: AOJu0YyHZBeRVZfaHoB0a/FoVoqYvkasENrgHPCoVRZ5Le5ekqpZ543J
	gLKI8dU0kalLbq/z+CjSrNM/eOAs0ytGg2AlQ13JvWePx+zNdABWbbaYEgcAoGp7f4HyGE/ybc8
	f3yaVQEX9Uu+jEGrPs3vqK7mnV14hzsXDg8s=
X-Gm-Gg: ASbGnct9OpWg1UTy3S8XWa0xan1RhaKZZVYYPHusFQfi9OzVrSD+1LDXn9YTKVY6LGR
	OVGN0yQTF7Ecy11McTO9RZeZjMHQljTFsNUiMYQ==
X-Google-Smtp-Source: AGHT+IGevwfPXGCAQQVOp/Ab1cBDzyCJ8G1YfMVI8AtOp+xUdHCuOY6eWeuJWDZfjx7Z2eYbdSZVK9tX1UXrXPJHYgA=
X-Received: by 2002:a17:902:e545:b0:215:435d:b41a with SMTP id
 d9443c01a7336-21a83f34893mr149435055ad.1.1736894823228; Tue, 14 Jan 2025
 14:47:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241112184455.855133-1-ojeda@kernel.org> <CANiq72=BvnriScFay8SpLNe9mNhjvGsBJ9W9UtdzU_6v_i+woA@mail.gmail.com>
 <CAABy=s12gOZadhYC+=6=TbbyN9j5L0B19ZLSGR_VFEdt1jhwEA@mail.gmail.com>
In-Reply-To: <CAABy=s12gOZadhYC+=6=TbbyN9j5L0B19ZLSGR_VFEdt1jhwEA@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 14 Jan 2025 23:46:50 +0100
X-Gm-Features: AbW1kvacpMeTqUYlQMLS6S4D2USApAhXAr5atLy2VwEVUQxisq97hcv1qVOPz0I
Message-ID: <CANiq72kQKGG7j61bpsORnE0vzNo_dzwMZMLx=Z0xOnY0wefv6g@mail.gmail.com>
Subject: Re: [PATCH v3] kbuild: rust: add PROCMACROLDFLAGS
To: "Hong, Yifan" <elsk@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Masahiro Yamada <masahiroy@kernel.org>, 
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

On Tue, Dec 10, 2024 at 1:51=E2=80=AFAM Hong, Yifan <elsk@google.com> wrote=
:
>
> With https://github.com/rust-lang/compiler-team/issues/731 fixed and
> this idea of appending flags, our --sysroot flag should be able to be
> properly overridden. But the -L and -Wl,-rpath's remains, and could
> potentially be disturbing.

On second thought, #731 probably only applies to `rustc` native flags
only, rather than those that are passed to the linker (e.g. if I pass
a dummy flag, it is passed as-is, so I doubt they will start checking,
and probably they shouldn't), so it may not help here after all.

> So if I understand what you mean correctly, with this:
>   KBUILD_PROCMACROLDFLAGS :=3D $(HOSTLDFLAGS) $(PROCMACROLDFLAGS)
> Android might need a separate mechanism (another variable?) to filter
> out our -L/-Wl,-rpath from HOSTLDFLAGS. (Dumb question: We can't take
> -L/-Wl,-rpath away by prepending/appending more flags, right?)

Yeah, we would need a variable to provide the filters, but it would be
more complex and possibly less flexible. I think it may be best to
keep things simple and use the v3 here, which already works for your
use case.

Cheers,
Miguel
