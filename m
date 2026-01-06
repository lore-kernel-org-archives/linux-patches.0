Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87A0E337686
	for <patches@lists.linux.dev>; Tue,  6 Jan 2026 16:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767717027; cv=none; b=kV/z/WnSFJH6mVljAwy/OzyBhlq5Gn+u6xTUpWv63DL6Avw0BDSgPUOW1mKc2RmTgwKHeD/7w910qB/NSaZgXrPwOF6AgJZZSaEV9nK+qt4vcYCuikLyY5OPBaU/hyLfb1yWvhgvCDpE+dOotB1qoJLOcWFcbSfxuk2qKwQRknQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767717027; c=relaxed/simple;
	bh=U0j51mleQ1XhvbVqXphZJy29E+snKGgnLb9jc3YD3Fk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rus+Kr1hj/NzjMNcr+3xVU+sfQUiNNbBcu6JNUEoQp6d+XPfxUqbkh7TvocuK2oWFPPCMCBr4GfUysVFxPuZUOss6GghvU/KE49giYODmrvlgD6vRj87ioUKAXPLingLzmnU8o6LId3B3gy1Ti6N1uMFD44s+JUzJ9GioBfQdg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=elpWYXU9; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="elpWYXU9"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6505cac9879so1823387a12.1
        for <patches@lists.linux.dev>; Tue, 06 Jan 2026 08:30:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767717024; x=1768321824; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=YFywE2icKNJ+cB7uTyuGoCkXxbifngq0AAd5tIXgGGI=;
        b=elpWYXU9Y1EEsIfgqBz6Tl9mxko1J7+4lBuq+espkCQqjbIMB9yqw4QVOiBvIb6fWj
         SuzojjQ8X3gS4IkwUaHbPdnqtEpE/heIjxpcP3Z7OjGUi47R6+3jzHn0K+WVO7NEbKRx
         Ey4ZHM3EVsUIdZH0F7VAegK0IxSIxOqYMqC44YEA8lVw5pNFnpavSlwDCUdSso2Wx8zL
         +lO09OBJT8MqS1MFzZeb7uHM2+J5hGsNXdJjZMlrcKsx3fYIw6RgC91F5+bkK2Mtt4dM
         GCsO3wRcwWMX8RIvhLGc9V7kW37QffKlkda71rWF4krqFcBzIl9qz+OTg8LRaSkxZ+TR
         jWFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767717024; x=1768321824;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YFywE2icKNJ+cB7uTyuGoCkXxbifngq0AAd5tIXgGGI=;
        b=RtXJs089mbv8fVo45ICQ6TxDf4VcJQL41f2wafnBQnn5XK7/ngN4+Gw+9QLmdMVAUa
         ZfaYzJQF9oRNtcu35iIoaU4fyB2Pqj4yjQE5e8bW7iLlFriuqDbZCN48L1FVBgU8C5kt
         uMCNAfjnSem1nl71BA5R7IR1e0c3l80BConGgb2T14bhgdIVTFYZvc+MAo0+LQ3XoyBR
         4p48jd4CWo6jdSxsACB3FuhPsNHGeCZGkZ1teqgSl+G55Am+1AeepAwPbBqdGv4oDsgj
         eZI3Mqhbs9eETKo5/749F3tRYC/+qZqao0bXSIdSM7tzBrOLiad3tTpa7nJpRp7Qm3Cb
         uMdg==
X-Forwarded-Encrypted: i=1; AJvYcCXYfLAeF2D1Bih8Dd1iEO9xv1VTojX1QqsPIHSggKl+2hmGoHOdygJ20JWtwHsKBm8d9Y2ArpzT@lists.linux.dev
X-Gm-Message-State: AOJu0YwKM3WuTkkPaWV1A8K/2ER0qSsRkVOkZS4AAsbpWUtKhrIHwLgd
	2lS1UFmsdn+Rm/14REy+l5cLuKT1gPYAaB6b//yyAQ1UO1cu/DHh5lOaaSW3Mx9yq/mdxC7KnHW
	CjPZLGtebPBhYSRcWMSRmK2cetmhBMbQ=
X-Gm-Gg: AY/fxX5CtVNPb9n/soE89gFmeJeWIhYZ4JtoxeGfQq0Tc4g/z0ifFkQP7IcAFctwAYo
	P3qrQP8jy7iLRBOXGLKnI/INOKwUrHSN33U17+/lRRwu1vvkhjvygQEQ4hKHIvbVElhaPDdDYUq
	K27i96WyPv3aDCYge5VAf5yVEKNANaccm2N5ONpQN0xb3hHCdjSox4fQBHkbfL5KBro7zkpeY2V
	BV8jFMK5liaY7DWzA4D6IQsa5tgb+xRDJUd70u3n5JiyBsDAM5AFZwm2ox5SVwki3jLD7T/
X-Google-Smtp-Source: AGHT+IGiqs1gDfUISyBczs4HyJmVzzzKZpgRC6NkJpj6fa6eM1SDvFi4fb2rgcGA7Eu/T1LDB0EY4X8+Kh2dwLV669s=
X-Received: by 2002:a17:907:c15:b0:b7c:e320:5232 with SMTP id
 a640c23a62f3a-b8426a49324mr367887766b.5.1767717023650; Tue, 06 Jan 2026
 08:30:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251228063440.2623595-1-safinaskar@gmail.com>
 <20251228063440.2623595-2-safinaskar@gmail.com> <CA+=Fv5Ra7fFTd2wA77iM_6X7NooApfoMJX5z1j60cXex_uxm7w@mail.gmail.com>
 <alpine.DEB.2.21.2601061310110.45251@angie.orcam.me.uk>
In-Reply-To: <alpine.DEB.2.21.2601061310110.45251@angie.orcam.me.uk>
From: Magnus Lindholm <linmag7@gmail.com>
Date: Tue, 6 Jan 2026 17:30:12 +0100
X-Gm-Features: AQt7F2ryRckCS1QLF5YuAHz3r2RQu9Pt7ESbBtlhCipsrDrEYweGbF2trlCO0MY
Message-ID: <CA+=Fv5Rw3vJGLsEyuKOBMyZTcQd=ayV5jT6bhWNn=uzXKsw13w@mail.gmail.com>
Subject: Re: [PATCH 1/1] alpha: trivial: remove ^L chars
To: "Maciej W. Rozycki" <macro@orcam.me.uk>
Cc: Askar Safin <safinaskar@gmail.com>, Richard Henderson <richard.henderson@linaro.org>, 
	Matt Turner <mattst88@gmail.com>, linux-alpha@vger.kernel.org, 
	kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

>  As a matter of interest, why would the presence of ^L characters cause
> any issues?  That is just another instance of white space and it has been
> commonly used across some source code to separate functional parts, e.g.
> in the GNU toolchain.  It can be ignored unless you actually send the code
> to a printer (which I suppose hardly anyone does nowadays).
>

I guess you're right, at this point it's mostly aesthetics. ^L is just
whitespace and the compiler ignores it, likely a relic from the old
days. Some editors display it a bit oddly, and most of the kernel seems
to have pruned these over time, but a few still linger in arch/alpha,
which fits the age and heritage there.

Magnus
