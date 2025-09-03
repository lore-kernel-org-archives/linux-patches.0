Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A23522F28E0
	for <patches@lists.linux.dev>; Wed,  3 Sep 2025 09:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756890771; cv=none; b=re2UJkrdj4dzOFliLHT9tlkJNdk2PkfBR0Zb9VO32pPjHaHBFr5K1w+ZpGBj0EfPI4dWaySxmU+BZrQVy0txe6R/RQaH6fGiEobbtgRWrwgAV0pGsZu0mGMwvqNTYSEUUcgwP3odMxuiOHDAD4IgsuSec3LUUISFhQs1EXf5nSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756890771; c=relaxed/simple;
	bh=u1dUo+ncWnByrkiVnzOKVZT2Xjkh2cB3EGgl85trqm8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iN1e8BWZ2DNl6QxgTO8tlnFbhrN+qe12C4chJhh0hNnR2kqt0VDWE7xTyESpd84I49F5lIoLGFAjC4n7jahs54UtrhErY5ik8m8mO+frVFGUIFZrUtjEnMfW4uvqNrk5rg23JuIV90gR4vlyQ+ArV0YjIrvEbBizdi/QbSS0efw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X9jT1AM1; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X9jT1AM1"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-24b1331cb98so2930695ad.2
        for <patches@lists.linux.dev>; Wed, 03 Sep 2025 02:12:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756890769; x=1757495569; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u1dUo+ncWnByrkiVnzOKVZT2Xjkh2cB3EGgl85trqm8=;
        b=X9jT1AM1rGLf0roSqFFlBen0ytwyTQbTV+QhDy1u+ozeSRc9Hj625htgqmJOO3Qmjp
         RsMV6K2W/RmFdQxknX76Jll3LDpvP1sZtCCWTNeJmteK+la67NH8Ia8EVXkp8Ribj/lg
         vHhGLpkwydO5zD63hhOOusA/pjMEB0vlPcqVDaGdH5RdSxWBBccMCTWou6yQnZQFkXd8
         W0MovJWfSQWhvAfRNOevKNOuEyj2tjM03C+dBtrg4kxu+j7EOOB05KCXDLTYCj7zZ4rL
         HK8G+CY0VijsGOGKw5+j72uhKF13YXAlYNUVIsnaOogG5L/Uaxi/tT4UokpXIqIMvocl
         6IWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756890769; x=1757495569;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u1dUo+ncWnByrkiVnzOKVZT2Xjkh2cB3EGgl85trqm8=;
        b=gt4wZE1YowmyipSwyELmXRaBSgSIXe07JRZPoYFcAVwb6pQYOqqA1mGLM+7MS49opv
         rTI+Ff8owIRxuNd4fMBb/I4g5hFhRhGaGDxWti+vhOVtgBkrqVPyreyP1nvJb3MPfvwZ
         0huU+VbNfV3WxZKcBVBRDkjUdYwINib4EpsDd7ubIfspj5Hy4NR5NbiXwV/7ELn2i2Pf
         lLxw8uNwhK7gKj5NXCRDcsZOsXreN2W86FXEeEYlSwcrQZiuREiqfWkIyuT8b3ykBYVY
         z3Lk7RwFn9Tn06YAF/ZvCWJgJ/C06swTIZEY8IdwHhHv/DuYxJQz0RBL1BPHM39CvJEu
         XNkA==
X-Forwarded-Encrypted: i=1; AJvYcCXAlG7vCXr/nwopLW1tKNhz+UFrgy8tr83fBQd1lzXeyMRAQ9JHFGh4ZH/hBUd6f6IQ4bzVG4lV@lists.linux.dev
X-Gm-Message-State: AOJu0YyyOQljJZgdRZinXNk7RDUNOyTlRUi4+pHyE2I4NfPxxAzUe2dM
	LBBX/lmQ/Sgvm/Lhb7/Stlb0DpVeOCrgnzXURittfwV8dU0RtGTToxXG1BRdSpcfUQLbR7l5aKf
	63RPSQx+KGzi0QG/gmJP3E6raXNG5bqA=
X-Gm-Gg: ASbGncv4CdKSos8Wfc0AvX5xAY9f7bC+v71tmXsSDBF63XQoI/sxOrIB1DwMnH/qwYf
	/Ld4iNf/k+Xi2FkHLch88HxmoFh4xjCC2/k/C8sDY5lMjjEyxqgIpGNEKQuPNYZKYK8ZK/TI3c8
	hzEUeLB9tm6Dw/ixXJEpxyd8mUE0HEIxpcPsWQZncUC04LfgkSUirFnTFbyz3Mc/YfP1HTlvep6
	4LOFcDwJ0gx9qwHCwH/05A/TyvtTYy6v902MsFPsI69+BWZ33CUJP6nnEFQeahQIhTBUtRhWu0a
	n9qDjZ+mEj2qF0QDxlKpDdSOThE4ieMOzVgf
X-Google-Smtp-Source: AGHT+IFy+V9mXKNgGUInVKnO4rUD7VlssVnjx0POASZsCkyJ+rfepXrTHaYt+5C8DyDBAIFxdX2YSb9WPGAXKP6wep0=
X-Received: by 2002:a17:903:41cf:b0:248:b43a:3ff with SMTP id
 d9443c01a7336-2491f246be0mr103559945ad.8.1756890768748; Wed, 03 Sep 2025
 02:12:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250408220311.1033475-1-ojeda@kernel.org> <20250901-shrimp-define-9d99cc2a012a@spud>
In-Reply-To: <20250901-shrimp-define-9d99cc2a012a@spud>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 3 Sep 2025 11:12:35 +0200
X-Gm-Features: Ac12FXzVStDccJZt9jg6LxgcDhbP5A9e31eO3h_DSesybX7nfJW90L6qE4tU3Nw
Message-ID: <CANiq72=hD3No2R8-8znrOsL+AEs3rCVjNn3sn-d7qKSKZaGWvg@mail.gmail.com>
Subject: Re: [PATCH] rust: kasan/kbuild: fix missing flags on first build
To: Conor Dooley <conor@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Andrey Ryabinin <ryabinin.a.a@gmail.com>, Masahiro Yamada <masahiroy@kernel.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	kasan-dev@googlegroups.com, Nathan Chancellor <nathan@kernel.org>, 
	Nicolas Schier <nicolas@fjasle.eu>, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Matthew Maurer <mmaurer@google.com>, Sami Tolvanen <samitolvanen@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 1, 2025 at 7:46=E2=80=AFPM Conor Dooley <conor@kernel.org> wrot=
e:
>
> I'm not really sure what your target.json suggestion below is, so just
> reporting so that someone that understands the alternative solutions can
> fix this.

If you mean the last paragraph of the commit, then what I meant is
that we could do the filter conditionally, so that `rustc-option`
would work to test flags that require the `target.json` for those
architectures that already do not use `target.json`.

Cheers,
Miguel
