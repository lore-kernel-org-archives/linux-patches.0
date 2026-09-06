Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87CA13002CF
	for <patches@lists.linux.dev>; Sun,  6 Sep 2026 01:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.227.140
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788656689; cv=pass; b=qapM1hBGAiJfrzLO5vnioAunB5G4zlEnZIZGcpAbLeO0WqDr10daSn6qWOQMKB2n90Q7TNc/SDr8vNYY5lDPTK688SdX0LG+roqWADIHUYggNuw/XUQAk5ET+LO3fI8fyi3q29LmVbR0jY0zV8J1xcnD21s6OsdLBLMqz152Gyg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788656689; c=relaxed/simple;
	bh=6v9JT4KWbHlAzSBmvHtzBswCMCsqSOF/aCWlorwgI/E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=r1r+sXUqWD4E0wOAWaGQJ7sIiaEI9Ya/cShV6K732seThA+7/Wk3vVRMHLfaFHEtjmEIxTG1/OcsaJcers8nfORhG7Mt9rxOrcEA9dk/TyWQyDYMU0sDGCtoY6COew2u6YDg5oiXV2IIyC7f2odA/uCVugmqtjFgz75MFXc14r0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Jhhz5qEc; arc=pass smtp.client-ip=74.125.227.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jhhz5qEc"
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-396673bd283so278627a91.0
        for <patches@lists.linux.dev>; Sat, 05 Sep 2026 18:04:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788656687; cv=none;
        d=google.com; s=arc-20260327;
        b=bnJHjcoCZdreKuPaqv4QCcYN/U6rHY+0sY9BsW/tUizz1IhNpjt3xkqcvXDtKD3oS6
         pTf8tmGowwkDK+M8hUnAyZcaiDYdWgkX7RAxZhbComwLgpgnRfd9edT58RdbOOARXJ67
         D1gvnIO2VApKK/Kpq/SXzkepz7G34yViuQZNuQXv4N3QutHZd3en+T/EVuGXNV/H79GJ
         LSY5Ez9yUi1wJCAtMPI6tqsF+EiaqiDNvbSFUxJUZPG44SlSTOaRZKKH+q1w+P/b821+
         lpWhWQMNJejOF3Ftmdj+nWZN8BtH3DcJ6fWzUMsSW1eAleNcZhILDGg6NxKwbCJCiOTK
         qE8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=XfakRqp8F96veZF3ZNAhymxMT3EzOfSxeJXjQ9JrCuo=;
        fh=Gyy0+0bYSFv1xfAelM7re54Dgy8uHrAGX/Usfh71la0=;
        b=Y5q4iygUTtXtDOFH2/fRHuZLyPQwLoMZ1xCFBtK6FLL0H6G8QpiLzvpUjdosWEwoQa
         0XZhf0gakcPurK9dWEw4HXXbfAiaZd7w5xR+xOmZb6FyT7ErN6WSm2m/9AONOlMBvuyR
         JgVLskDwncKYL9iNVtrbZ3zroC7xjw17Fsb6bORnoxgxVc2UeVkY+GuS43x6/FRa0mDi
         gQ5FqGH0sogLqm1qk9HtVli6hZOXSWOlY4bqh7Ru/YHmojx2ic4BZVucjg51ky9unT7O
         citqaoQw7GOG4RmJDHLMbv6E+mD0o5S0yAca4hOPVak1+buHIpTBXihTXfC9ERW7l/U4
         bp1g==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788656687; x=1789261487; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XfakRqp8F96veZF3ZNAhymxMT3EzOfSxeJXjQ9JrCuo=;
        b=Jhhz5qEcYNTHZorpYl/rLQLn0AAhj0AL1Q8OLTJZd8pAUNHYDggIYC8LAh6cEO9zvQ
         Q3n5GUpy/F3qjlzOGANNNfXafRQHVhBO94kVb9mtpu+nb4f6GUw0D8gB9wBcBoTdoskK
         rVjUwtH+nB7gKDxLloZlzYOdNexttV/KlY/lhJUtMh7GtMPU4wRaGM0ciy8no5pzoXm/
         J2QeTb9BHwecxCBzos6qtDASuwJawSTdsWrrTsDxorXnRwSuBL5JxrEL0HxRSB4vVrNj
         7evXdidP9cA6L3j5MnrToEPh7eB6aD5jwGNOFNI/Xt5p5zQtFXIu5cYZ6B58cpmIWZD8
         kbrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788656687; x=1789261487;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XfakRqp8F96veZF3ZNAhymxMT3EzOfSxeJXjQ9JrCuo=;
        b=AWGhX3g/WQ/Xn0449ujdxAbMbRqPnLBuTZKfftpeuwRS+TJ7HHxV3hyuJAmFhKnuDc
         RZbQCWbOnf3XIyK734RJC3s/Xfn+7nb/wj+tODARocB5fSsERgG8O24K0mMig9DFxgN1
         vgrapgJ6sjXx5B/dq4ARNNRumQlCWP74yXFT4QF2I07mJkD5U8GBENpuyT1Fw0XuezCt
         ATyU5CEYUsfq05fev8FEAU6X9flFV4pzqs8YN8VXPk2pgo0p/OydONEUBUo+LKanSqP7
         PkhfkZctd+5Pn2qeMF/PZyOFuVVqY1Lrj2+xXLDpCeOBdcIF34kziapK06Oc+MA48Tut
         bB5w==
X-Forwarded-Encrypted: i=1; AKwUvBxoD3a6C+0Z+ur+tissTlGOVb7SSVLGVN83cDhm02JdiXjlwj1EhS1YeGui7Sx30nThRQx0sEDI@lists.linux.dev
X-Gm-Message-State: AFuF++noaYKqH6jt0lHl2NI7maIupEe3A0cNmtaMtnFdZvR/IqjfWXPT
	4ufb40EDSrs0LQol7OKbAL1mcSW0Te/cqq+kaRT86UN8F16l8DzCwLk/STpI6Z2nGpWzmAHEFHA
	egXqYGiU94YSxIgBjmdJ1uU9OWfWIy6c=
X-Gm-Gg: AYBFou1EApiEV4ZOg6pOx55dJRpqxUII7fLTJuTWRpN1Wh+gw81jwahtkoWle3JhJAy
	sXRq9k7L551Q22RKmzZePw0D3Zy6+kc1p2nYbV2u9yRzjb0v7OdNlyrULQCTvrSQRdYMZ4Mg9rs
	tFH2h1avNdY0txO002p7v8jKBMmInzaGMgEIKWbUD+0AIVK6lViqwMz41G6WwLPb4V0QILv21f5
	jT870VCJr0COVgG8MmWsw4ngQg1QYriLbUv+8nQhjB72F9WG4ezb2LCVRjCThhH1xJohZmu0foF
	JqkP4lVAz5cJ1gLqEloZ88tMMM53s6MbLEX2ycDjrxmsZZEnGpgjgVVeV19JlQmpxmTWAq7dtoL
	HEdf6xEDxoCz8KzGpQogrf7slq+SfGgj5EverMKgM0+9i2DEIVC6YvehKuKWMZ4WmEdZzYQo=
X-Received: by 2002:a17:90b:4b41:b0:398:bad2:c0f with SMTP id
 98e67ed59e1d1-39b3d8310d0mr7481550a91.5.1788656686629; Sat, 05 Sep 2026
 18:04:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260904045747.813364717@linuxfoundation.org> <20260904045748.373148168@linuxfoundation.org>
In-Reply-To: <20260904045748.373148168@linuxfoundation.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sun, 6 Sep 2026 03:04:33 +0200
X-Gm-Features: AcwNN1WEVmNLRk5OAmkHLSMfaNhjTk_FiTinpZME8xNMMBHr8yOLjbuFrkxEBxI
Message-ID: <CANiq72=EounScE9CxhQVRYTMe6XxgZzfid_cJZ5dxmkz7MQ2kw@mail.gmail.com>
Subject: Re: [PATCH 6.18 024/552] rust: bug: fix warn_on macro build error on UML
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	FUJITA Tomonori <fujita.tomonori@gmail.com>, Miguel Ojeda <ojeda@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 4, 2026 at 7:41=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> +                $crate::str::CStrExt::as_char_ptr($crate::c_str!(::core:=
:file!())),

In 6.18.y, this needs to be:

  $crate::str::CStr::as_char_ptr($crate::c_str!(::core::file!())),

Cheers,
Miguel
