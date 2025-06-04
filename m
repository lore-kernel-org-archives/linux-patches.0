Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7414D28D8ED;
	Wed,  4 Jun 2025 12:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749039876; cv=none; b=mDhi+JiP/F6Ioj05YEu1kEAAmG6BDzASR0NUGwTl2+8UYck+qMXiNUVkqnlk3BLT+5pQ18cSX3Yk5dxkvr0aYQtHdyHTd46hNABDJ+9kfn3MusJLyqBO7Kuo7BgLOFwt1SfrjjPoqIGdxquEcQNI2bOBai9+k5kahILI1QgwRyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749039876; c=relaxed/simple;
	bh=X5HoV4A18Es6cQsPxWdpN/6HMNSRex6GTYKxJ1FSTdI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=u0w38aqnCbCE/fPCJJr8/eCDD0GhqXkFuFDS0i+Ilrs5eEI3/eWPHzOgh9dLfLh2oDjDatAVDUUzowwD1/6dJeMHNRLDLONIQUDH422tNxqaAAKo51vmDlGwWea0/bPzaekQB/5xyOvk7RkHezZB+BcE6AS5Z66glNOKHnCdIZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KmpgWISn; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KmpgWISn"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-312f53d0609so189804a91.1;
        Wed, 04 Jun 2025 05:24:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749039875; x=1749644675; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X5HoV4A18Es6cQsPxWdpN/6HMNSRex6GTYKxJ1FSTdI=;
        b=KmpgWISnG0vuacOBzsuZxqGI5dsogH/IgIvONxs9QuW5e1L9hKPJaOA5AnGdRbudJ9
         qE/a2ZvODQ+/tOsNObb5YO7utXjifP5xXqkInod/n0WJhM41sXivpKL8MSuUTRmPXqjC
         yWSkJFA+7jWN/sOKO/vgUWyeRyqTqYHpBA7QImRi3yyzcs/xwUHopIxQu6lA5g6SPGrk
         EZu7rgmfm+wcps5WZ8yc5VH+aS2ju0uemo6vH1lAm4fTssTNLlU9YZ2f+gBoJaTgiNLA
         u6IuQOfk2KF9MqrflT+g5pcefejPFSBAFXZg3unhf3g8RmdfMlC9bwtalITIlRx8HcS9
         hjgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749039875; x=1749644675;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X5HoV4A18Es6cQsPxWdpN/6HMNSRex6GTYKxJ1FSTdI=;
        b=f4pqPufIY9hk6FolWA1/XUntJ+JwCQCKyIqEs0QYDrO1X/OpkAuCvSFdhnVgqB4r5v
         kklG4Z4ccvKPyWylfaEYpqhXsalaEPJFETmokrmX1okUZRY7fFlHEaNS3gnwDUX9czmx
         chZj6Q7rMEzY8wh6q/P/SVKg3H5QFD+LW8pnY93ZEwOHhU+hk7B6G14Lx8hI6xtju+5F
         9XRlcbD0WDJlhjMHTO8EByUl1h8JBmISrCnDqrBEoj3quGwLQQPp143opJ9wXkNarJiD
         bew8hj2j++fR4vC0h1U8vNv6gcAKIiV7EOWmRC9uGA2Db7Wm8TKTxv+66PAeYTOmfef2
         tGBw==
X-Forwarded-Encrypted: i=1; AJvYcCXSzemh49tPfBQYUT+AxLANz455+ru8TcwbEqIqhc2Yhf5REvZ8IQJJG0sU7kYsl+kkSzkd@lists.linux.dev
X-Gm-Message-State: AOJu0YzhtiG3lz0lRfg0GPdERLmB3eOe2JcDuVlsgW9jJgxVPApAe7eB
	owl1//OHC3OfPA+SI9nb3Nb4/w79BsEDPbps+m3DiWjffnbknMOzzvZE40MkKMnlmBXIzHgQvQP
	TVFinzi4AJg1skq3XkqRT2xHKVB74obw=
X-Gm-Gg: ASbGncspp5dIesUv8iWyTyCPuH35YmSIIdnNEwyoRJIELc75wUD+1GHnO2Pqn6xbXN5
	uYBKDgfIGTRVtXDad+AlzAWCnmFRJpDwT5zCheuswf/SBa4zkKSwQSCVGZvL+tzfpYptQuC7eFf
	fQM4i3nBmvR6bAu7sN8NRZMsQeRBqSpPj9
X-Google-Smtp-Source: AGHT+IErLwtGSYQMv8xDY353kuF+fsT1I4lfY5UDw62Z+Lk5yJh2j12Usxk6xWco51Ijg6BndcQq9Kq/vDbhiZClOm0=
X-Received: by 2002:a17:90b:1b42:b0:312:ec:411a with SMTP id
 98e67ed59e1d1-3130cd3ce2dmr1484250a91.3.1749039874684; Wed, 04 Jun 2025
 05:24:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250604114923.208380-1-sashal@kernel.org> <20250604114923.208380-2-sashal@kernel.org>
In-Reply-To: <20250604114923.208380-2-sashal@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 4 Jun 2025 14:24:22 +0200
X-Gm-Features: AX0GCFsrP9iFTYtJTClz9rDnEXWcTEpyeBtPkQnKTXB_q9gbKp89nIFoYXOWykw
Message-ID: <CANiq72n8oZGOkUVU4MAjDb0W+OwX8PuEykA_2Z=DY+onvj-T8A@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 6.15 2/9] wifi: iwlwifi: mld: Work around Clang
 loop unrolling bug
To: Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, stable@vger.kernel.org, 
	Kees Cook <kees@kernel.org>, Nathan Chancellor <nathan@kernel.org>, johannes.berg@intel.com, 
	miriam.rachel.korenblit@intel.com, emmanuel.grumbach@intel.com, 
	yedidya.ben.shimol@intel.com, shaul.triebitz@intel.com, llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 4, 2025 at 1:49=E2=80=AFPM Sasha Levin <sashal@kernel.org> wrot=
e:
>
> Now let me analyze the similar commits to understand the backporting

I think this ate the newlines from the AI... :)

Cheers,
Miguel
