Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 774A6A3D
	for <patches@lists.linux.dev>; Tue, 18 Jun 2024 00:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718669198; cv=none; b=S04GtedCDBiwOWdolbh6DDPKOB15xCEP0SbwWBLu15EnJpv/miapxgM+btbEr6b0HV4iSOposo9XAUg5kYyTFhjpdlc+yayhWIGUz9mR4i1iFiW6VPPhOnsgH4GXazyUy1VT75/4cbmrZy48nh1gGvagnMBXEB3KygHcxyX1q3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718669198; c=relaxed/simple;
	bh=UGatSlxeogA3j0K+wKO32ig6IQDTDriv/UTII2rF8aA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VYoHjuG+VYMdYLbhZxgg6kcgTCQidTz2Zoe+18h5SFDl25BXmhWL4TW8ZC4O27yyXmlAP1Vec9QjQymfKyinBbpFxt/MCiCaFhpZUJu4iz8bkOuNGiCx3V7t661reIWbC2AUwC3lSoX9Ech94nJr88b6kgMGiGnlkmFrJRBNsAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net; spf=pass smtp.mailfrom=amacapital.net; dkim=pass (2048-bit key) header.d=amacapital-net.20230601.gappssmtp.com header.i=@amacapital-net.20230601.gappssmtp.com header.b=jpLI516B; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amacapital.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20230601.gappssmtp.com header.i=@amacapital-net.20230601.gappssmtp.com header.b="jpLI516B"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-57a4d7ba501so6075201a12.2
        for <patches@lists.linux.dev>; Mon, 17 Jun 2024 17:06:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20230601.gappssmtp.com; s=20230601; t=1718669195; x=1719273995; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NhBCdjZfpxKVO+6tjifmXo9LRGWI17cs8I9O4iYikok=;
        b=jpLI516BgcWp8SD97dKNXymkYyqHiCTUYi0BkUs3FfwUtfCRv6CQnoznhENJlF1h6t
         YWOEBUodiFcbLHs667tYZnduLjtGxDthWW5I6sGwkRxib2zY8vwv9+aqjN9nnO2NbU+s
         lpATmGJ/52IBRonkQkVU+6Ez4SUdAJtHi/vUAcRwjPUy1chPjGQX1ADGMIOn5kHDt/ce
         Y8A8bff/dTjg7FHtga7I5LG6FbcZdAEGVg9s2VUORDfianUtpWZDoGMb1DD3VHIFA7OB
         Q3oP2jeTJBPT6PRDrrP4TSmssSgG7722jvtwHQllvFxg8nafM/6r/EH/QSf6yALWjXuF
         HPeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718669195; x=1719273995;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NhBCdjZfpxKVO+6tjifmXo9LRGWI17cs8I9O4iYikok=;
        b=TeiYZF+Kd0hVXlX7UhYbq2Tf5ky8Cpz4nI+Scs+Ux6K77SD/GHDzNOtRHJPA3RJKYh
         19Imy4r9moO+aHWNSxDjwOHeiUiZibJLp8D0am7Bwmd63H60jdEOJbHzcULzuZL55/+y
         9svramw1wcPLZD0WgpMy+Hya44TKKBu5hw4kJ8FZOzR1r/gVPPOzVZXyq3uwprAWuIgY
         a6YxAXkLCcHxw2GFK9zviD9/H0hSbdMWBZHzGguI54YdEdp6Jv2pDahjGWW9G3vV5p1i
         LCkt43OMXQE7fPCeInRCtL77ylPt647iyKKI46Ff5w+XNewr6ZAuCAIkqEr/XTXuSBMn
         G5VA==
X-Forwarded-Encrypted: i=1; AJvYcCUB9XgJYNNi1cULM6QButXb5AcnoP67DI9h3m3Je3/IrZsNKlV50L+w/YFAJceWD0dq6hVIU7HfWz7g6uG1tR/aFFghG8hZyw==
X-Gm-Message-State: AOJu0YxrbV0A4hO0irmvZXXX0+TT3j7Bj28TnxBQ77p4Syv//X2Yyiv4
	1aEdpI5XFab4luhqZRaZBVb5l23v1Lhn0xY+rnRhKJmySox9+gHGewxdZBDO7HZr7YRu8DZFil/
	ROHsWkRVfwMQmiJOiZ10PPwMl858150RkmvP8
X-Google-Smtp-Source: AGHT+IG4GxHatmoy2CQa4K9NAS5MI8D1mWbcUvj+Npci2j6Mst8MU7YuWAjJuO9TwNpePI1dphaTrN9ug+F4RXaI42Q=
X-Received: by 2002:a50:cc9a:0:b0:57c:61a3:546 with SMTP id
 4fb4d7f45d1cf-57cbd67c8acmr8252492a12.21.1718669194582; Mon, 17 Jun 2024
 17:06:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240614190646.2081057-1-Jason@zx2c4.com> <20240614190646.2081057-5-Jason@zx2c4.com>
In-Reply-To: <20240614190646.2081057-5-Jason@zx2c4.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 17 Jun 2024 17:06:22 -0700
Message-ID: <CALCETrVQtQO87U3SEgQyHfkNKsrcS8PjeZrsy2MPAU7gQY70XA@mail.gmail.com>
Subject: Re: [PATCH v17 4/5] random: introduce generic vDSO getrandom() implementation
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev, tglx@linutronix.de, 
	linux-crypto@vger.kernel.org, linux-api@vger.kernel.org, x86@kernel.org, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>, "Carlos O'Donell" <carlos@redhat.com>, 
	Florian Weimer <fweimer@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Jann Horn <jannh@google.com>, 
	Christian Brauner <brauner@kernel.org>, David Hildenbrand <dhildenb@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 14, 2024 at 12:08=E2=80=AFPM Jason A. Donenfeld <Jason@zx2c4.co=
m> wrote:
>
> Provide a generic C vDSO getrandom() implementation, which operates on
> an opaque state returned by vgetrandom_alloc() and produces random bytes
> the same way as getrandom(). This has a the API signature:
>
>   ssize_t vgetrandom(void *buffer, size_t len, unsigned int flags, void *=
opaque_state);

Last time around, I mentioned some potential issues with this function
signature, and I didn't see any answer.  My specific objection was to
the fact that the caller passes in a pointer but not a length, and
this potentially makes reasoning about memory safety awkward,
especially if anything like CRIU is involved.

--Andy
