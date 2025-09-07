Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEC0C224AEB
	for <patches@lists.linux.dev>; Sun,  7 Sep 2025 22:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757284209; cv=none; b=FtHyqrKiYGRP4Bsk3uJdtFcuvDf3VPlzIJH0Twvw+NhLZlTSWFysKNl7NIhTZCT5EGylCpq1pbmJnlUTvHPPRLDtBYcc4pYIWzctLvd20QWi04whBy8Pv6GdgR1EBIXpMoEKwVlgWcO4v+K1TfpVTZFq71DOlc725BlKEyqiOSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757284209; c=relaxed/simple;
	bh=YiYQFvOAi/L3rfcO0B8Dn3oJyiTeX8xkf4kbnG9dX4Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CaaEglupWKXL0sFLDWsle0BWQiJVUZxYOgaVoMg4u3nfvIbO90EvMpn8b5gF04LEYm6sHlpHI7nq00gOoCWL32+RISapw3v/f4BFK1ojP47p2lKmil6GQji4/YacCZ01Wq5zA2zhwXDkI9o9RQO5WldIC7UB33jmLi+3VmqSnJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SK6R9XRQ; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SK6R9XRQ"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-24af8aa2606so8100685ad.1
        for <patches@lists.linux.dev>; Sun, 07 Sep 2025 15:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757284207; x=1757889007; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YiYQFvOAi/L3rfcO0B8Dn3oJyiTeX8xkf4kbnG9dX4Q=;
        b=SK6R9XRQi9RFet99zioNkVHFdcOG8N5HNxPRgAapqIbDAkKzrSr3i9N7BcfzEgJjmd
         cEKhLpUX/4P9PGEjre+XPIC9z4A/0yeX6VLAw1rrwCKrFVwVIzqMITk9AWVe+QF+ukic
         diEK0hiT6ihyl4G/7fW9TH9gzxm86jnVaBDelEc2eRw8U4UXYFISW+iUump/mryUGDwO
         ZnW/jvHAqRuVKQGDweVDacC+0LD1rvd/PNVzF0CbMLSY8u2rv6a8we4xMZe+kbc5qoZs
         3NfNt/+c2Qx2PFi2IrvxzoMyrMciVSfkgPvMb+iVG3DkrAjxcPL5f95fVhuwnZHRbaym
         ohww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757284207; x=1757889007;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YiYQFvOAi/L3rfcO0B8Dn3oJyiTeX8xkf4kbnG9dX4Q=;
        b=U4H2Hkkljp6CeShSqomDwAs2erYvjdPvkj0GZbJIUvs4oKvB5jgbl0RwalGpfr/RAS
         cAsZqjDZWw1/JpJZPqiDXoMVITwFBtncNC57wNag33g7xooQC3nOeOA/F/8o38h/Wzwp
         v7oNJDqVZdw67ucVeLXSEPxWuWRM30xV7u+j1vTrdJwPKPkEud8JL5G2ljEbgeS9y3P/
         shmpe+reh/hZxEIlpUS5LnwiTr5vcKusqymQqD5wdDxwQS0VVhBVPe1zf0wHsniDKkLF
         Wa5wz53OnFCL0F6eyEMdZr+aXid3IgOA/l9zU/XVgaUJu9OPBlsgpLyGmDrqEZdEbwpJ
         RE3Q==
X-Forwarded-Encrypted: i=1; AJvYcCXCu2xkrPUrgY5JaLQh5PCXCNCPjiuvNrwPe9VPNUI5ideToVYqBgoxC59lGEo85nvHKLtgX4i4@lists.linux.dev
X-Gm-Message-State: AOJu0YyVnQazbP+aSXq/QfV6AHQCz0WnkmJj7WNBUEoIltnp/HLEhlHk
	SGlIZlaNdaiMPeO4pDnk1mFtqUEOsmfSZs9XwwQnKEiV4H7q61ITKP7pUJDmjVVhl6iBY97mWoL
	swegEwYiJYkoi+awbL9QylJO7W6U+p+o=
X-Gm-Gg: ASbGncuUMNqtrbqmXRViARKi8ZAwImuHS531u6uMHdb4xZKsyNPgh8aqvV0TCbQvIYz
	rdnlvjo4n8cK6KizO78s1T9qCAtP+Yb3Nu0PVgospJHTCTCHbzX8VK0GUkiwkVaJhg1kAfBzOVh
	3jQ08jnEGyZc6VrBmgJmHt5KkO2TM6OH2pOjgWx6rnBOll+juxwEQDAbhuo/KRh0mfvnc111yCj
	UiTPtFVEJ3sO/U4mR37q72FApav6/MEpR3YDTclYFnkv3qGa4nvorh8Q5K29HZNeeO91Ihcg5e/
	p0bYDbo9V4j3bfu16G8sRmmsBg==
X-Google-Smtp-Source: AGHT+IEJXHXVeEXiUuxDDtDL+F2z+Li35l5mEMwus84iNqmeDyb9GLSYacR9e0Qf9AaGo8FSywEfNdNTn/METasbJfo=
X-Received: by 2002:a17:902:ce83:b0:24c:b881:201 with SMTP id
 d9443c01a7336-251757ba959mr44510665ad.9.1757284206873; Sun, 07 Sep 2025
 15:30:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250730130716.3278285-1-ojeda@kernel.org>
In-Reply-To: <20250730130716.3278285-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 8 Sep 2025 00:29:54 +0200
X-Gm-Features: AS18NWDiFBEztBvhh545-DHfsVGSBiVzynGVpEdm2_GOyJiuoW_17RumQHpRyQ4
Message-ID: <CANiq72=gYXqcXyVK1vq36Y6ofv4QQiLLgnAY=zhFVV8CGYuziw@mail.gmail.com>
Subject: Re: [PATCH 0/3] Fix broken `srctree/` links and warn about them
To: Miguel Ojeda <ojeda@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Boqun Feng <boqun.feng@gmail.com>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-block@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 30, 2025 at 3:07=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> This fixes a handful of broken links and introduces a warning to
> prevent them from happening in the future.

Applied to `rust-next` -- thanks everyone!

I added Cc: stable@vger.kernel.org on the fixes.

Andreas/Boqun: if you don't want the block fix, please shout!

Cheers,
Miguel
