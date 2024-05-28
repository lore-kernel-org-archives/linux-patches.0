Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A8A216E866
	for <patches@lists.linux.dev>; Tue, 28 May 2024 13:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716901704; cv=none; b=Ei9+A8GpKMSNWdOvtuYYd5CeTiC8gjL+ICncJW4T4/wGMJpMkwh+rcWXPkLxoVKuQ+gY/wbcTHvC81DxoSonWQ7ADUg+yil7nCAgtchrVybchPujlNxX4sEYGa6ns5d2bDIMT3pRgVC5k1jKNZ9WOxbyyQazE0MuYjSF0DPx0VM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716901704; c=relaxed/simple;
	bh=FL/IHmb6BMmy3C8suNCmO3xRrM+w266zhUsBJ/Wh0OQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XsGivI8fiSnpaRrieQF5cDo0q3HgH0ioHlmPB6mnRFpT43Oqq7QkNb6FHsqq0sh+TBDBLVpowsBoUG0C1gebdWIs2N5IR7ZYew9lPjDoM3Uex+WDnwMlukj1byqJyc0muZNdPMYSXeSZSDBsLG00kr+SU6jVU78XK0BDzQrtfCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-2e724bc466fso8138651fa.3
        for <patches@lists.linux.dev>; Tue, 28 May 2024 06:08:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716901697; x=1717506497;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1ADNlLgF6T2svAn5d+KaQRdOL4An/XIqcqDrDRQoRSA=;
        b=deKXau6WDeUyGNE8doDtGJrogsbgi5zUJugWgr0o0u/IzwIjbTDAcH3FA/DNoz4J4L
         qOP9WaTTJ2cqPJBR+g7h8rYNKMhXtGZsZDwMw1WoGjsOqUGgPbH8+sN548O7QX4AyDbd
         ydVbLNdUnzBTXbsgRCbAeMs2DKX81nl4kN2vpnDg8xN2rTuLVrm8+rTRu5NMGPyEXjvU
         m/0jSK6ZRG97VaT+Orxa315UO2ar3R/N2meBVejmaWgXec4kmCUMFZ3u29cYov0c5iJo
         jMSL3LpLNptjbc84+JTZkjtnJmkt+QUfPpymqN25KmKHCV0w4cAz660EQEHm2oUSpUut
         X8mw==
X-Forwarded-Encrypted: i=1; AJvYcCVWveVPqFPOOKU0PF4fPf6uVlUN4l3BGZEmc20/Lv2851DMj3tqhD7XYdileEuiq6ZnRp8Lw0LHNBMwvd9O5EBvukEHIDYAcQ==
X-Gm-Message-State: AOJu0YxeomcgMa2nBFl/D+lCXdCQvN6+8rmOy5G7gv3g2h+JcHsI8L/F
	U/YwaiUd+z2vI6X6FqDhRJLMJZydlEVLofqIEiwrZz9xKWR+2YNorhSTyo/qeeM=
X-Google-Smtp-Source: AGHT+IEvW4WnBGznNrLnHvjZDcrHpWcUCKTJ7xY7T2405LxztT40+zOyt7yPPA1psigAh0OqaPWX7Q==
X-Received: by 2002:a2e:9b97:0:b0:2e7:174b:8c1c with SMTP id 38308e7fff4ca-2e95b256336mr114139741fa.38.1716901697126;
        Tue, 28 May 2024 06:08:17 -0700 (PDT)
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com. [209.85.208.170])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-2e95bdd14c7sm22107861fa.97.2024.05.28.06.08.15
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 May 2024 06:08:16 -0700 (PDT)
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-2e73359b8fbso8942751fa.2
        for <patches@lists.linux.dev>; Tue, 28 May 2024 06:08:15 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUtpLMBwtWmGdjwWu66C7HpSzJvNiI9NA2jSnsPM9MQmRUf4m7A/OGTbEiYFfJZcwtFSgcXLYmRAFpUyKDconTkRQqTS/RRJQ==
X-Received: by 2002:a05:651c:1992:b0:2e7:1e4a:31d3 with SMTP id
 38308e7fff4ca-2e95b097761mr137091911fa.16.1716901695021; Tue, 28 May 2024
 06:08:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240528122352.2485958-1-Jason@zx2c4.com> <20240528122352.2485958-4-Jason@zx2c4.com>
In-Reply-To: <20240528122352.2485958-4-Jason@zx2c4.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 28 May 2024 15:08:00 +0200
X-Gmail-Original-Message-ID: <CAMuHMdVJ8KpaqnWeHCMbJdf-Am6uY0N+uFM+OVxWTZH37TQvxw@mail.gmail.com>
Message-ID: <CAMuHMdVJ8KpaqnWeHCMbJdf-Am6uY0N+uFM+OVxWTZH37TQvxw@mail.gmail.com>
Subject: Re: [PATCH v16 3/5] arch: allocate vgetrandom_alloc() syscall number
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev, tglx@linutronix.de, 
	linux-crypto@vger.kernel.org, linux-api@vger.kernel.org, x86@kernel.org, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>, "Carlos O'Donell" <carlos@redhat.com>, 
	Florian Weimer <fweimer@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Jann Horn <jannh@google.com>, 
	Christian Brauner <brauner@kernel.org>, David Hildenbrand <dhildenb@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Jason,

On Tue, May 28, 2024 at 2:24=E2=80=AFPM Jason A. Donenfeld <Jason@zx2c4.com=
> wrote:
> Add vgetrandom_alloc() as syscall 462 (or 572 on alpha) by adding it to
> all of the various syscall.tbl and unistd.h files.
>
> Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

As of commit ff388fe5c481d39c ("mseal: wire up mseal syscall") in
v6.10-rc1, 462 is already taken.

v17 ++ ;-)

Gr{oetje,eeting}s,

                        Geert

--=20
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k=
.org

In personal conversations with technical people, I call myself a hacker. Bu=
t
when I'm talking to journalists I just say "programmer" or something like t=
hat.
                                -- Linus Torvalds
