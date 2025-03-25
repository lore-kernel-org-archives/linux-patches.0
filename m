Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38AFC1C84DD
	for <patches@lists.linux.dev>; Tue, 25 Mar 2025 19:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742929506; cv=none; b=QXQwz+ZGBxcMJD0DUs3vO2V8bM973LOcX7xBJ81RL6g/ipViHWSE11NXA6yHmc9/DPy7GZiLcQ8Lm8tOELq+oKxg+b/yw7q37lpl2pZNVKPPQLiOtvnolys+Fpr5/k95nFW1mcPlWX6rGm1th3eEce1l4+8kMhzQPE8q6ILtt70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742929506; c=relaxed/simple;
	bh=6TMgaEW+9sayzHvoDGxPrtSjxiQA+4hzRkywj2TAG0U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ouCnnS/quqHd0gn/JFjQjFsyp5vsoiDUt/PxmM/1SPC0IfVOqAI/mEKw/A8/KxYOd/6F6a8nWsJBc47Mq3ICIqe54BqtfGn6SWd9NewBXy8ZIiVbmT8nDyPiJPrjS9AFd7Gczn6/J+JMncMAMKG3GSHK88lWtIEHBQUMKkJ0Hs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DrRR5uDO; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DrRR5uDO"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-3032a9c7cfeso1222788a91.1
        for <patches@lists.linux.dev>; Tue, 25 Mar 2025 12:05:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742929504; x=1743534304; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6TMgaEW+9sayzHvoDGxPrtSjxiQA+4hzRkywj2TAG0U=;
        b=DrRR5uDOAQ0m2ITclj4yOthcDkf2hfR3++jnTGz6NbqHaj0regjcqKz2Woag7uug9t
         fc7J7c60yXSBCMkoJFaH639rTlxrJ+2DPv/TwPIrDvd3jcZjIJn3RRf5af0EICvnRloE
         Ubwzv98yIykf4WlZXGINc/GtYwp2mI+zw4EW/1eHIT2jpjtaKdUO9lfuCMDiQsvlOtQH
         GRxIYmfhmCrXoXcln8B6G5xkdlkFxQQKzcV3TgR3FYx3/i0w/VOsXgDSK64g0eZVOc+Y
         Oo4JQ40X9XCAEKdKK6v94UdHAQYtfUQK6jhRqGawTsoY8Dr6mEC0PaAim+T7sckxJ/n5
         3Tzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742929504; x=1743534304;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6TMgaEW+9sayzHvoDGxPrtSjxiQA+4hzRkywj2TAG0U=;
        b=sCODlXt4Es0gVSYXm4EvuN8oDi96XZ3r2FEBj3ZibEkQtemYobb/brVl/QrR3csAw9
         bEsTZSdGl9uCQCfJA6GZTksi/DT+ZhuNT5goqMsvcDgrV4BOeEC9OeIO6posseKyskvp
         4c5cAz9c1PfmI3HJqXdgFXA6qj7/AbZJ22hYn6w/v3NuVy+BoR8oaM8bzVPVbpnl3Fm2
         u6Kr9Le9+QYEb9MVJ3I0+cUsDj6tnGtDRMbf4m9fHivSKP2gAUZOqGW/W+hKgTu9udKA
         cmCou9hWRRupI3E1d2th176tKm3ZBEGcJbZHC+Hz1GcczTiG7sVehzKIfdqGhmrPDk69
         VUOQ==
X-Forwarded-Encrypted: i=1; AJvYcCW0SMgXRsHAozi7goZ3n8Ot/Ni9QPGKRqZA7kuGYZQs7pHjNVn5ruzyXdDymYiboRFRBFlQP3OW@lists.linux.dev
X-Gm-Message-State: AOJu0YyH0vc2knylOloDT6VW1jMrJ8MnxS8jNYzVokOIdMLJWgoxgow2
	iYKuwZRvLWI6Rl7Ybsra32cSAXwiUygZJ8Oyl4V3G/219GsUAsfbM7JiBoHZQdMb4T1K4ARbsq5
	vH+j3rAAeo/jwQocaIHXny7x9zM0=
X-Gm-Gg: ASbGncsgBtsyi+dKnTe/RV5n4Lx5cbuHOxr0qo3M/cxbGUvyyslLsrJ1eR7mBS7eHp/
	xRsZzCj6AKMCW0E02t04AgYcraPwN403jJgjVoSsbT/AjrtEy3nDHQc0ZfnlQCm+i7Kr6globMa
	stwEhszFXr6KIPBb1xpyedi4kNxg==
X-Google-Smtp-Source: AGHT+IEaXErss0xXwV0lJBIcOaPCzt+p7KmJRqpZTTvZUvZnCO8fOgnNeypm8mZP1MAMagB1I17kUy/UdhjTcObxQRA=
X-Received: by 2002:a17:90b:3a8d:b0:2ff:7970:d2b6 with SMTP id
 98e67ed59e1d1-3036b4abf73mr2506809a91.5.1742929504147; Tue, 25 Mar 2025
 12:05:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250324210359.1199574-1-ojeda@kernel.org> <20250324210359.1199574-3-ojeda@kernel.org>
 <dd1616d5-4808-46be-9167-6fbfe76e0c73@redhat.com>
In-Reply-To: <dd1616d5-4808-46be-9167-6fbfe76e0c73@redhat.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 25 Mar 2025 20:04:52 +0100
X-Gm-Features: AQ5f1JpmlWonQlCTJ2hC2bel5qL6r28Y6ygrNFDOCt0MmPyi13zbtF_Iod_7f3o
Message-ID: <CANiq72kz9SW8Rexj7feZRvTAhgF+cBwarpFnqu0TSk6C2r9SRQ@mail.gmail.com>
Subject: Re: [PATCH 02/10] drm/panic: add missing Markdown code span
To: Jocelyn Falempe <jfalempe@redhat.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 25, 2025 at 10:05=E2=80=AFAM Jocelyn Falempe <jfalempe@redhat.c=
om> wrote:
>
> Thanks, it looks good to me.
>
> Reviewed-by: Jocelyn Falempe <jfalempe@redhat.com>
>
> You want to take the whole series in the rust tree?
>
> Otherwise I can push the patch 1-2 to drm-misc-next if needed.

Please take them if possible, since others may want to take them
through their tree anyway, plus it should have less conflicts if you
change other bits, plus these are independent fixes anyway that can go
in on their own whether or not the lint gets eventually enabled.

Thanks!

Cheers,
Miguel
