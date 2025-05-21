Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5226214EC60
	for <patches@lists.linux.dev>; Wed, 21 May 2025 14:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747836102; cv=none; b=GHg2KrodUMJIgniJhiDmkvPamxsCInE5Tb2/Eqq2cB81f9r3U3orP4SrcCcIeBmvuTK5FaaJYHe9vbLWrep55PRHdnU/ZUZ4qYQKWZjpe+ot1m7NCHKU6xudGbAwl5J0JpdmWMMDE8f2mdtiwZb6qL/+PjuMrvgdF272A/fNdwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747836102; c=relaxed/simple;
	bh=8aUOwg7cfjAHrLpnuG3R+zcViomLhaw8dORoW3xOm94=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Z3Gy9nlFmguP1hIswUSNvX1cISZy1GXw160F48SS/d8bhf0rsEUxpxeOB8OugScChx8kKZCOcRllDe/eWRK53DEZypN4WLQVxuw6Dyax44F4/83flWx2KgfMSfACE/Q4fQn8jPJ1NZ6KqSqVx56sqI8w3KcKXWheVjyl5qD95ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YuZnCum6; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YuZnCum6"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-232219cc6d0so2771865ad.0
        for <patches@lists.linux.dev>; Wed, 21 May 2025 07:01:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747836100; x=1748440900; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dMGXupCFm/jDQdH3BwXg85XBgNeRBVeHk/IerHW/LbE=;
        b=YuZnCum6liwAeEfn0ZwKoBLEkUVbffF0qruSt6olfvwK1+WH0EOTRIcv9OM01ArHA4
         pwMF8cC85CGxJ74snPvK7WGSACweDLn5YO2mne9AA2eGuW5lJNPRIihHTrLj5D+KU6r4
         omOSeHTHJg+kZrsUUADXcG5kApzsZ0n0UJKF6Pbn37rrRsdISsT9M+CzMafIjZq7tWXS
         Svz+SEknKZzYXY53R9FMPU7uc4Ync5pmbKxYD94PJjEEL/3vRTPm6EdJR5BOV5GOBdoQ
         LH3aOfHgWjmqrWQBPbV+955cMcmt/CsK8cuWoG10k8lBOkn4Xk8SzLnobBVMqZBz5SA+
         sYBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747836100; x=1748440900;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dMGXupCFm/jDQdH3BwXg85XBgNeRBVeHk/IerHW/LbE=;
        b=lCCOTjs8w8Zt+TMLN5T0LIGvl5kQfdZ8YkUlI31NUXinEAlgw0XgZinOHQlJyAn+Hq
         3fwN3FIaD3OFFVtLmndc5mdpU06Dq0N+FHzKDgMsT2dvQst1h0dYAoF4MpNsaKYtUgtz
         slYbe2WFDJYauRUTFv+1WeqRTjGTSrjwdycFCnLabEUP8TBSiiC6d+HbDX1bHO9JJwvf
         jGnBV3F+lfSJQUhaK80CjlllVKeQqVtJhCtW8B7HuE6C8wHz4bRshyHQCC91ms+1jBGa
         ets7ZFl4eFl8Z+LIIip0w5Rjz9F2Uf6+XVm4/mjD1nH8Gu+TySXGk6dkDXzMzP9eeIa7
         /OLA==
X-Forwarded-Encrypted: i=1; AJvYcCXV+98dW5kEuy/i8sZtcXlhmvNQsPj+XwUfshWt0j1MAYqKJjK1G/xSocZWOs/bvwPhgjEGPnjZ@lists.linux.dev
X-Gm-Message-State: AOJu0YzAZXMBjABWnu0954AQ7NUKCOPPIOFgEDb9KKA9mVATshEuXM6t
	lmc6tMqORdVOeAmJqb3kjJO9e41JlThwMoz6nWjOylVX2UiAUoT1FdNl0liBF0mDaXnMYVsw5vC
	3HgG49LRz3XtBERo0G0KLjybivb6oCpA=
X-Gm-Gg: ASbGncuVSd07wlttP/YWURRnGHzXaqqMRBZKFFBnB5ZhWLSUpqApPhft3IQKmrI1wvt
	jeUs/T+SLKaTtyuvVwSrATtfAcoTCjRCMtOMs8PZXnwPxUjF3K58ikrYRClIZELzIrmrAAJHCJB
	rN1UI/ZDcql7w+CipVU+r2j31R4zYd6cRv
X-Google-Smtp-Source: AGHT+IEf9pI5auX2gp9RvC6XVZIT3qjdAUHxHeINEyS1iniHrOrcET60vaOXe6WxV+Ndo4dwUNM7er6CEi5Ut3dwZOE=
X-Received: by 2002:a17:903:41d0:b0:216:30f9:93c5 with SMTP id
 d9443c01a7336-231d43b7cb6mr111674645ad.6.1747836100471; Wed, 21 May 2025
 07:01:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250324210359.1199574-1-ojeda@kernel.org>
In-Reply-To: <20250324210359.1199574-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 21 May 2025 16:01:28 +0200
X-Gm-Features: AX0GCFu9hbn7oACBtc1sC-LprsFwQEelpoqzdJdMS9n5B6L5nTBBjtDwqqKl-gg
Message-ID: <CANiq72mBHcsCpn1ZJRJ9Qa-Ass1MsoKdKcFpiFF7hNwyOXjAOA@mail.gmail.com>
Subject: Re: [PATCH 00/10] rust: clean and enable Clippy `doc_markdown` lint
To: Abdiel Janulgue <abdiel.janulgue@gmail.com>, Danilo Krummrich <dakr@kernel.org>, 
	Rob Herring <robh@kernel.org>, Saravana Kannan <saravanak@google.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Miguel Ojeda <ojeda@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 24, 2025 at 10:04=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wr=
ote:
>
>   rust: alloc: add missing Markdown code spans
>   rust: alloc: add missing Markdown code span
>   rust: dma: add missing Markdown code span
>   rust: of: add missing Markdown code span
>   rust: pci: fix docs related to missing Markdown code spans
>   rust: platform: fix docs related to missing Markdown code spans
>   rust: task: add missing Markdown code spans and intra-doc links

Abdiel, Danilo, Rob, Saravana, Greg, Rafael: anything against me
picking these ones up?

If you would like to pick them up through your respective trees, then
that is great too.

Thanks!

Cheers,
Miguel
