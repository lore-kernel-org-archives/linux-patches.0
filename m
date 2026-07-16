Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E6ED3AFD14
	for <patches@lists.linux.dev>; Thu, 16 Jul 2026 16:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.215.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784217604; cv=pass; b=dSSiU4RK8jaw+9KBQbIsFq0VqlJANs3B5Qp2mhUD+73/CaguZ/44oZmi0oGRljIOIMB+njrqeZEc/IMuMcVeD5wOoaRqWsFZ4KiFVMf7ZSarmS2Qh0MIk18NwKujIO8okM4/xpdGmRlNPHNpuBepYYnjWSO2YUojQKlYz0pa/H8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784217604; c=relaxed/simple;
	bh=QyfLOTmDKblqNf/f8CcxpjE+LTEpqUWf39doD/kMj9k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PxdPWj5I9ssU72U4TdFQLTQGXbEcIGST5SAbpyKsa7XRe6D1SDH3GYcPvX2wuNzJlZpT4XSTaR8hpqEltomeZDf2kQTv58UFhYcO+OvzYMki2FIQfTTY0i8S/wHBXOkoBtBfjX+wmgtCYhbxUTpTNxqcvKcVgG9uaniOqstg+Hc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rhL0wGjJ; arc=pass smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rhL0wGjJ"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-c9d290216d0so326056a12.3
        for <patches@lists.linux.dev>; Thu, 16 Jul 2026 09:00:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784217603; cv=none;
        d=google.com; s=arc-20260327;
        b=dhhlceyl9BU0PwB4kVYza/DkC4dHuVsto3ym+tNeSCkLu2UkVpOvy28gAwHsuK4C1u
         9MkJ35AmwYQh2yYQCrHVz384V3ZvwcvGkRlKrDWTilk6Q6vUV9RW0+85EVU8/1M+xUOS
         UWPfFtDgkLRW2R5hsjTK84KsWKCUMuBQ1cG/1/yqyUAq0aeAn9ENvO1Jjcn75sqaPMrD
         QMRjLESCDNJRZTjf30+NrD4AyyQ/5PeKaSYVzcGGxp/zwgRuBs43xY1ID2cfjzNKzcAK
         hONvE3TjRMAN1/fhlLTMF48zu1+gG/4JvNe0LQVE8tk7LovQBPtE4H3mlPTsLgsf5/GM
         UoCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=iY17dWR71qKy/7I4B3cswFVlH36Dhc9DEFHqiD07hVQ=;
        fh=HQ5G+ZvAQoDeooUJYaXZNFjuykZ7OOnIbn0v0sE2gPs=;
        b=RHmCAX8tDqaVMNbswaq7Ec5JFY4McnE7HCcYB1lgmPvcTnckfk9gjd/fo7lRamIxNr
         mljax0GDOaq9CkrIr3NMJfrWONgjiEL94xOBuJOq2bFACl5rDulq0R3N/EBmy/+2oDNv
         ZUAY5cEPTmJ/thAj40+Xe7ZnXPqIwrvk9BdtjiikBAFLlyItmHwyoR2gyc0Z85kV/RjW
         mO3wciGVRD7x4PoZFk2FtGnYkJHdo2v/yJ29prfqcC8xcFc3pahEY5B3o4ZIUZIzNcxS
         fo4fpGe2SBgTYrVx1Bih4E8gh67mY1Z5ndz3crE3HZ86G66UkaMUOO3xY41yh4ds/DSx
         queg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784217603; x=1784822403; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=iY17dWR71qKy/7I4B3cswFVlH36Dhc9DEFHqiD07hVQ=;
        b=rhL0wGjJLV+LUuvFlNZaRFLKyYzXyJ2qmuQAfhKTRvLe0vzCDBPhw5YQDnB17bdEPM
         cL2PXr5Gdx9CLie2ckZVA6x12aGho+gW+yQY8JU+IbbNbdJn1swMQvsefdj2MZRxxn+z
         ocpJxWGWbgRPoGJwOxlz+gqY4tqzDBVaWbCYS05I7O/lHkX4DoGwxzI9x7tg+w3xNm9G
         xvvzg8CvUqNpdT5dxs07lhIO4lzEDAeMlxO5TtJgG9XpAXhtJxFf+4ikVsXh8BFJmeKW
         +nXzVf5tket8SGVSOWiV/9fJBt020oDcwa1a/V8SzQTmMZIv60OQaUPrGsrxzVJkSosa
         aT+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784217603; x=1784822403;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iY17dWR71qKy/7I4B3cswFVlH36Dhc9DEFHqiD07hVQ=;
        b=rC3I5pEZczWolHidT4sBjjD7+jmnKaOeHnG57hiUNX7jkr0W38zmWWZuubhHX++2T1
         320gfPnCaQLawR/dXgl5LNrdqh/ViRC8udMLjdCDvBC8LWrpEu+Ul7l/q1iJQXWzTKQ9
         c+Dq2nnQ++/ji/YoRYgfsddCeDpUtnaN83CeUrHd7bfLDSEA0pUmJkorXgFQbFTkD1NE
         RkMOZSZs7Thx1t8LCOMLoLCEHxpOWdTzBk36LgxszgNW7DTceiBuC6DCCpwm5STxASjW
         WvQu/gW/hFcY8u8Tg8s1AT0igeEcNClOuut/LyAE42OoMazqayjiDrt9+FBW4L6f/A/F
         oVUA==
X-Forwarded-Encrypted: i=1; AHgh+Rr5jlDSVwsPcos4WftXNpU9t+tvMqCEVTXQdvaW5/TMGIyVJE+gLR2kqjhpOhmInZxX9lDzKEAn@lists.linux.dev
X-Gm-Message-State: AOJu0YyxB+kTX+xWjfvMx0QHwMZePoMrQE5yDYsDMCCUROUNGvMjB31j
	Jpo50R3UBGzmDkEh/BaRxs7ZfYg8pY1dZeZUiCczoZCe1UpLavwTF7wooGfHwNGeh6mlJOILotF
	PMz4HrxUAhJBBnoRJAAWgyB6YBtoSJBelR8k/
X-Gm-Gg: AfdE7cmqKAaEnZqTsCNLagNJFJVebiU1JMyHfFEUz1/GtRzFqIg9TVsZFiLVlAwkwJv
	8DqpWhJgdJLVlc9odCfTjdyIkL1+0wXtHIr/cAfPPJJpRFwICyDleT9gFQbTCti2mZkEclXvV8u
	fz78fyHyf/esk1v1tHaRU1YWr5asbFF16sfyYH1aKln+JkODpW+3srKmjXFb+kmpVE3hxdiLHsV
	8oZW2VjClVH3c/mdO1HCeLDrXUmTKScZFHDk7lQ/e/xWOEEAEJsShyrjRTUytTV13lTYllzbDSH
	70gcbC6rP2zYNbbK7aPdHz2089ybmxsHBuf3eTBS3x7YVZdaFsdykN/3ZL3+hTZ4TOYNCXWE+kc
	4ew==
X-Received: by 2002:a17:90b:224a:b0:38d:f0a7:85f9 with SMTP id
 98e67ed59e1d1-38df0a786cbmr13297783a91.0.1784217602679; Thu, 16 Jul 2026
 09:00:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260716133033.287196923@linuxfoundation.org> <20260716133034.168967917@linuxfoundation.org>
In-Reply-To: <20260716133034.168967917@linuxfoundation.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 16 Jul 2026 17:59:49 +0200
X-Gm-Features: AUfX_mzlN6ts9jWgrhP-ttrpXbsj6Hl4xw5ZMe12lcilwll7rvreCnk-3_-tHvE
Message-ID: <CANiq72muOR3T_yjzo5JocHOzcQRXFPCZzUky=CwSF2vyHw9KHw@mail.gmail.com>
Subject: Re: [PATCH 6.12 038/349] rust: Kbuild: set frame-pointer llvm module
 flag for CONFIG_FRAME_POINTER
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Alice Ryhl <aliceryhl@google.com>, Miguel Ojeda <ojeda@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 16, 2026 at 4:21=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> [ - Adjusted Cc: stable@ as discussed.
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
>   - Added comment with link to the PR, similar to what we did in commit
>     ac35b5580ace ("rust: arm64: set uwtable llvm module flag for
>     CONFIG_UNWIND_TABLES").
>
>     - Miguel ]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Ditto -- a script got confused by the brackets + dashes maybe?

Cheers,
Miguel
