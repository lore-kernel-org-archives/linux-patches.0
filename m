Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 754A117BA5
	for <patches@lists.linux.dev>; Mon,  9 Dec 2024 21:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733778364; cv=none; b=hH18SiwWgC/nrlcBqqGBjbM1hlKDHQGL9mCZTkWIYJuZFgDMMbwqqKTTq0tiqgKDaqGHb6GsPNkzLJiNI3bCJquTIdVfVihbcdinjx+09nyjZPHeIu2TFSyEeiH10m+fL3hOvPyVbAMCxyYNMcI0mGgJl8X+oPEq2EupK6gl+Hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733778364; c=relaxed/simple;
	bh=IQz7I9YsENov3q06x8KJv/iXVsOJdNRaOPPv+jZyDqA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=osSWit8YtcEuBQKRYYSbmopt+f2JH0ssMy3udjrRiXcDxaW7U+HYGpck9O4oEyditghdx3NpMTl4qhEyEOvIcfwq1CFL/eV4/N/3IASp94qFQ/FWKUDGMDm0QB41FB4smoE7bxik2x+JTQ7PSIyFbHNoYg8o3rQ/pe27u4ab7+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=S+1MSWCi; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S+1MSWCi"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-2ee534d6800so826531a91.2
        for <patches@lists.linux.dev>; Mon, 09 Dec 2024 13:06:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733778363; x=1734383163; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IQz7I9YsENov3q06x8KJv/iXVsOJdNRaOPPv+jZyDqA=;
        b=S+1MSWCiKNQPbcddsaCNg5taJvoTkUxgBQJA1Xvu1t/ift7zKJJou+mdNbQBIVNGY+
         lti2o8iPMPHlaUTqijQeWvuHpRtur5x4EIjVY8kDF658BeWv4QlE3DC1c+z+32+P4w/q
         AfRGDHaCVuwzIW6MxDcLaaWuFlzinLOQc7ES2ldlvyYDRtXelrZe7cOLG9HlAZrHPs9y
         14v+lvDzkX5S8a2ck4QsJcVnqMrPjVwSWoEg8DKiJ7XM2ajZfbKO3fO0Eq1sTYLsOuna
         tVWtY0fTMT9Jflllxgzu57ZZ5NIR/Nqs8XNpRsANIeodDG4HvxYu2rWACdULsZ/Pa25+
         +PVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733778363; x=1734383163;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IQz7I9YsENov3q06x8KJv/iXVsOJdNRaOPPv+jZyDqA=;
        b=g2NuOTVXaU21lFU1TnUA9Ui8lY8pj7pqAD6/i+EgIAc06CVr9ijmYLdMfxHQWc9FrU
         IkjK10fuoQI1z/ejHO5yiLdGbyr3BTC1JeEEghmvMRvZpQZXRBeLOt+QaFO7timq3NJA
         T9UHRFlCR7RcdGzQKsReE4ThVj790XTJuuJBeK1XtWHHHS59X0hnq5VpQgNPF85nSn+o
         jhK3IwgyRelExpxRpXux5vSW6kBW/NyWUMx1K2/ZJJTa4ER1Rg/GqzQDCbGqmKr0adPt
         kpYJmrRur8uKQBojcj0E7EVOBy7xIetjEhu8qdDvhv3O2UJzxuE9V6eRq0sgAhvmbGFU
         /Eig==
X-Forwarded-Encrypted: i=1; AJvYcCU3te6A1fA3yJsDCM2MBahJnLsHZXsmI+5poDdCMqtixEbuLzm/Wo+P0eBEV3AIm5hupHzNS6GA@lists.linux.dev
X-Gm-Message-State: AOJu0Yw79ktagz5TNSEh2RLoBTOzMX1d8PPHFsKQHvN2B7ctQRaQY4H3
	+DnXneip5O7fETQW/ziYyn0NrwUlzpGXcBAmHkhH3/o+JKuU8avhTT4/npJcjQD0SP1g+djHzDH
	QmjZUyvx5Atmt9kKJsk6ZRs3+20A=
X-Gm-Gg: ASbGnctlYVZAna/Dl4ZZmea5nULo8XlH+10C35cPBnnMnWNzH+KTFgLKGq18OGJASZe
	V7ZGocB/bYxjzG3/xsfnAdnkDYubXLN0=
X-Google-Smtp-Source: AGHT+IEJuFSakMcUFac7J+27s9Uiqv0/HxdJEeZ6mEWsh67Ic0D1Vr0Ysw5dq2xEnh2AhHs3kAjxKYrNJLgxZGF1gY8=
X-Received: by 2002:a17:90b:38cd:b0:2ee:6a70:c5d1 with SMTP id
 98e67ed59e1d1-2efd484c303mr569161a91.3.1733778362678; Mon, 09 Dec 2024
 13:06:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241125233332.697497-1-ojeda@kernel.org> <fe2a253c-4b2f-4cb3-b58d-66192044555f@redhat.com>
In-Reply-To: <fe2a253c-4b2f-4cb3-b58d-66192044555f@redhat.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 9 Dec 2024 22:05:50 +0100
Message-ID: <CANiq72=PB=r5UV_ekNGV+yewa7tHic8Gs9RTQo=YcB-Lu_nzNQ@mail.gmail.com>
Subject: Re: [PATCH] drm/panic: remove spurious empty line to clean warning
To: Jocelyn Falempe <jfalempe@redhat.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 26, 2024 at 10:04=E2=80=AFAM Jocelyn Falempe <jfalempe@redhat.c=
om> wrote:
>
> Thanks for this patch, it looks good to me.
>
> Reviewed-by: Jocelyn Falempe <jfalempe@redhat.com>

Thanks Jocelyn. I thought DRM would pick this one -- should I pick it
through rust-fixes?

Cheers,
Miguel
