Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB67714B07E
	for <patches@lists.linux.dev>; Sat, 17 Aug 2024 13:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723901804; cv=none; b=lXGGpgGecTZBlP1ROa/EhVDvjX6tPzzdLj0lpi7EV9G3xaUaMQox94/tEW8P90HrYzKPi+iLkgw1c+EgYeU2QbgQUfLPXDWnhx+zLrDbm72QtqiMJP8o2zyvQzW8X2BMbiouyrFDqKmtRppgz4mFOYv5qfb00YgVdyAHLpmaM6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723901804; c=relaxed/simple;
	bh=sy0AB5iz17nq7kNmhns+GwjqlSVrmhHMr067N4apBBQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=U0ccxOYczSVSRosDYdJ7UKK3ddbtY98AMKqU867kx/Zd5YQV8VKRV6NcZz/cZDqktivn9pPmr+Bmx19x+h6cQvY61uhnF6yMS/4Nzn+uHASTpiNlnoDGq/Wre+lw+1EucMEOvVy3pTgR3mflZ3J7lGLIPHKxkB8cKR+v4E84/AA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CF/xLvQC; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CF/xLvQC"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-70f5ef740b7so2577077b3a.2
        for <patches@lists.linux.dev>; Sat, 17 Aug 2024 06:36:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723901802; x=1724506602; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sy0AB5iz17nq7kNmhns+GwjqlSVrmhHMr067N4apBBQ=;
        b=CF/xLvQCd8vmLrxSm/6XWjOZqM/t5lWXFEWYc1ljapYJdjzzdelCVHgQBcCrZL3h38
         +QbZrBmF9fyLq1vFPxK5CdQuDoJHXHwb5btMhQRKvd69UwKIem2wdicDj+3W5GuyjsBp
         ILsTTmn3zJwekyVu+RFP/z2EM8ctAkLglQGfMEdVplOsX/lk2vgzjmaa8agDafhjFqWC
         R1KIBEVAe2R9u4Zbb1bJtBXnC/PIOK3qCNm22rss/ZY6EMNppXcDS87VmMWTkqZL+iSN
         bFaf9lMfkymzLvN7S1TA8h1NZv/4qkQLlr1ljKCBhWejnNnUnuweXSv/5OLHYCB0Y6DA
         sT9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723901802; x=1724506602;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sy0AB5iz17nq7kNmhns+GwjqlSVrmhHMr067N4apBBQ=;
        b=QU+tUTJdlUk2Bc/6k1JH/UL0aNEJD0yGFFEOXIi7mbkKkuDgEHC9cV2V+2qEuhchJO
         n/az0VP8h+EodGBVEfWTAWpzprEdtd7lQYkkcUwJTQdCJhVWT6PIKAGBloGfCYDfzSgV
         iF26+8Dz2nd+ZHSO48ule7VuYexWuEh97g0jSEAPjZh905/lH8RnA0exZW+MZvmLoJ3e
         XRqhreIiMhvRRbShh37ENZbeBozGKrhHJQTZpCdtwZZUXTo32JV8byTuyvn0Z9aXI/7V
         BAN7eAMm8ds2id73IRjXz7vkJVvmAI0IvgjwtzfkcDTCNv4N59EOvCPpBM+zefxXLI9v
         IEUQ==
X-Forwarded-Encrypted: i=1; AJvYcCXvO5FtyL1DbhyiIeilwAQQn6PnFE+9zMELklCihT4oXOX4aOW6fK9obQe7UXUK3gsxH2SLV19U6OaudiFBSlF09GcZ12jhnQ==
X-Gm-Message-State: AOJu0YzuEFn0iTcDGBHrNd99kRujU+377LVMquiUgKzMM/G4hVaoCNR5
	nkiV5AJ06bPoI2i+HXP/DyAhW2pRJokuF3Zv7DdP0H0sPdDII19HKF8G22rbJEaMLgCXBZesYKm
	UwOblW3hYpu/9uhKQstB8LikLI+Y=
X-Google-Smtp-Source: AGHT+IH/hAp1t7BLkopNdMC3iXYCzXWGKQyV4QJtUVk6UoW9M5nliQEfLvAArDP6hc6F2iZYvVyk4QhK2eWdtQtYbpo=
X-Received: by 2002:a05:6a20:c88a:b0:1c8:92ed:7c5c with SMTP id
 adf61e73a8af0-1c905027bafmr7184681637.35.1723901801891; Sat, 17 Aug 2024
 06:36:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240808221138.873750-1-ojeda@kernel.org> <20240808221138.873750-5-ojeda@kernel.org>
 <20240817-cute-doberman-from-shambhala-6f42db@lindesnes>
In-Reply-To: <20240817-cute-doberman-from-shambhala-6f42db@lindesnes>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sat, 17 Aug 2024 15:36:30 +0200
Message-ID: <CANiq72nkBoiLUDQjBZi57OYwMpnH8D5Q4wR7XKWMry+mdwFOHw@mail.gmail.com>
Subject: Re: [PATCH 4/6] kbuild: rust: rebuild if the version text changes
To: Nicolas Schier <nicolas@fjasle.eu>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Wedson Almeida Filho <wedsonaf@gmail.com>, Masahiro Yamada <masahiroy@kernel.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	Nathan Chancellor <nathan@kernel.org>, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 17, 2024 at 3:04=E2=80=AFPM Nicolas Schier <nicolas@fjasle.eu> =
wrote:
>
> Looks good to me, but I'd prefer something like the suggestion from
> Masahiro:
> https://lore.kernel.org/linux-kbuild/CAK7LNAQBG0nDupXSgAAk-6nOqeqGVkr3H1R=
jYaqRJ1OxmLm6xA@mail.gmail.com/

Do you mean for `core` (here), or for `macros` (in the next commit)?
(if you mean for `core`, please see my reply to Masahiro there).

Thanks for taking a look!

Cheers,
Miguel
