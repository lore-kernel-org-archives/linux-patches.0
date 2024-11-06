Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 501BA208988
	for <patches@lists.linux.dev>; Wed,  6 Nov 2024 18:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730919556; cv=none; b=uj/yco7q5LnmNlyuyK8T85P08b2fI7DwX77j5komWxmJl+RCwpFFc2faekklxaM/skhrIPEKx0IPTNfJIVSm6ffJHq1gnizhl8XFtKotC3rz06rWrDtfnUvz0OGEE/y03I9IbNPinOQhbWBMKPLuc95m9SCy9bYEJLJNoBnt4h4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730919556; c=relaxed/simple;
	bh=fPkbnEtILsrm7fBv+gVTn8aiRWCGWwF4GT3/vtF1utc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=p5EMOybWzJQqOW4hOnuUjHLD0GFvTElHndPONDOQLMCckUt5pJKXdYIZpygkkh1bwT5eFsyN46J5hG1ig2vaaNIR68zJ53Zp+8k3RRv0YkKbCrcqvsVdjVElD0H+pnVvTRerDX8hC+Un6xtFZDw6owEXvgnZzx713dlHX0Jg4SE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B6T5N342; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B6T5N342"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2e56750bb13so15385a91.2
        for <patches@lists.linux.dev>; Wed, 06 Nov 2024 10:59:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730919554; x=1731524354; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pfyYHlZiiHlOJ55Ga/XIjofB2OSEpcClJAHmvQ8Zg1s=;
        b=B6T5N3423HukmqE10zKeFkKfEy51rrQIvImxoxkeGm8XWEL3PMGvmCGAAPIVo7APZP
         YqSH2LR3qq1cPUbF/EHBj0SGfEv2TYD1hd9YnIb6Kj+SLr5LjRwx+BOmS2ApFIxp2/eC
         wzn7Ee2HvwYANHUH7/AjJw8YybwS9kRbC5mE+qpaPUjXKjfINJHChU9FyrqIyNyGQ6nu
         0XKUV3fauPtjWvCIIFT9YX4hbbBmYhCjFoM953UmwsdQe0Dr2hXm8tJxslED1Wo8IWeQ
         QjV9mvYdRaywnug09PkrB98lcrJBYcGKDGTNclsdUS6fYd9gBGtsfZHCEzR6qhwmwmwA
         C9Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730919554; x=1731524354;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pfyYHlZiiHlOJ55Ga/XIjofB2OSEpcClJAHmvQ8Zg1s=;
        b=jbdzGfsQVLqJM7m7UVY5GIlq8JwTbpg740CNj17hTtpO41c8QZDAXcIq8/Sw9MKVy3
         3hfeirdqAJf6YQ3chbBpeIRvzUvKVS2knj+17ZlxjN/UR/W2wXD3k2+7Aux3W9u2sr0b
         u43ucZJS+A4VLt18cFUoWn15dpe+uKc2t21POlOApcBr1/P8scT38S9Tr0snzo1vs9cC
         ofhuczdNOTbFWXQKeXQlywYHc8LIZ3lbT+fbrfOdaxwFbQab4a2pnzUwAvhFVsxbIIOc
         RtIR2o/lBDcO36Su4RdRAAdSpAiQCcwXDhpqJ0qJfjTlEVS3qSDhsiLMK1psNuQvowR6
         mOLw==
X-Forwarded-Encrypted: i=1; AJvYcCVJbJwbhlue+AwcmGhLbolCtHZ9WwXJnRXG4x1O6RaaQM1ftqaWz9Znyo1nPH6TNB6tKxngf12W@lists.linux.dev
X-Gm-Message-State: AOJu0Yyj9DancliPoI2cRvrzB9aqi4qI63DRUg8jA/zlo1o2ipym6n4n
	CBXUDcTNWavJLNZY9z+/xyylm4Dz+UOBXdyKWk6yoHQVscXWV6PHngR6OhwLp0cVQSuKWYPDyNN
	8/I4XDw/bN1ZDeeguXimftv1rHsQ=
X-Google-Smtp-Source: AGHT+IFv/9wDlQ5Gely1DQOECBzo8gp5c3KiyzJWairSWFXE0bi3KYn8VYndGnT2orM2I8hGeGgB5IeH+L8Zd7su7Vk=
X-Received: by 2002:a17:90b:1a90:b0:2e2:c04b:da94 with SMTP id
 98e67ed59e1d1-2e9a4b246c9mr178569a91.5.1730919554594; Wed, 06 Nov 2024
 10:59:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241106120303.135636370@linuxfoundation.org> <20241106120305.369505633@linuxfoundation.org>
In-Reply-To: <20241106120305.369505633@linuxfoundation.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 6 Nov 2024 19:59:02 +0100
Message-ID: <CANiq72=a-qCB++wQjx9bZKdHfNg3Lj-1HMmjf1usdHSzAbTYZg@mail.gmail.com>
Subject: Re: [PATCH 5.10 079/110] compiler-gcc: remove attribute support check
 for `__no_sanitize_address__`
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Miguel Ojeda <ojeda@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
	Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, Arnd Bergmann <arnd@arndb.de>, 
	Dan Li <ashimida@linux.alibaba.com>, Kees Cook <keescook@chromium.org>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Marco Elver <elver@google.com>, 
	Nick Desaulniers <ndesaulniers@google.com>, Uros Bizjak <ubizjak@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 6, 2024 at 1:40=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> The attribute was added in GCC 4.8, while the minimum GCC version
> supported by the kernel is GCC 5.1.
>
> Therefore, remove the check.

This is fine for 6.1 in the other thread, but for 5.10 here, it may
not be immediately obvious it is: GCC 5.1 is not the minimum there,
but 4.9, since these two are in e.g. v5.10.228:

    0bddd227f3dc ("Documentation: update for gcc 4.9 requirement")
    6ec4476ac825 ("Raise gcc version requirement to 4.9")

So the patch should still be good to apply, but just noting that down.

Thanks!

Cheers,
Miguel
