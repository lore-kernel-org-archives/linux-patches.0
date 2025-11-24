Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AC57313E3F
	for <patches@lists.linux.dev>; Mon, 24 Nov 2025 16:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764001410; cv=none; b=cBKoqNGjsY8639L1VELLZr4+Banmnga6eCcLEPUBnO7oJNT5j5cw59ABG8UkA4rlH+T0Ybhzk0ybmOauZ0vIiSkrY5rGmZb/Ajly8mDzlTFb0lPNHwC7Rrn1SRmFUT4fEx9xFm1Vsf66Nc7GobV/HXT/FSM6Q+athztisgigxeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764001410; c=relaxed/simple;
	bh=NzPDQKUXesN2tFTrxAWwSFcXk8odbWGEX8DQwzKHvdA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=io6L0z38mYZQl8nIZH5d/CZUeeMQg3W4P0Pw30f8c9YlDs9mTrfSkHVflgcm8M+Yb4MflyX4+85tNan3Az/s9EXAZWVZmM5cDe6MhRbx0B9VvO2R/rvuj4azeZgHoEvE7nXZRljZZLYTzzukLila/4P0UC1pTvYdZPzYcFdfPJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=htbkYYvu; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="htbkYYvu"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-b63e5da0fdeso372189a12.0
        for <patches@lists.linux.dev>; Mon, 24 Nov 2025 08:23:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764001408; x=1764606208; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M2J0sne9dK3n8ebmX/80sgM1htWpoO6vvwfgujnWbIg=;
        b=htbkYYvuBjTonmhlqGO0ZCd3wWhQL231cRtj6i/edd6XkCEqocoLA3FrlhbVjezH28
         ZgB+q4OxFO8san5uAx1W1d2VIoodIzAEdqFYuf3lSwTWDScHe89+I+Gs3LQbY9hGvLwZ
         j9zqwwkqHlmzZ3km9/UfCs1U0g8BArW61hIenuUJJACP8prVd5pOA43D+yNKayS25v3/
         uuHCNU4esYGrE9C2piIjiPlK1IZvKwblxnolqSV45CZkX6j6nJgmt3ad+pLhP9bRQqyx
         64jDg30+eQvva1nYkJ9d47TaHgvUZfy3YUVk+EwHxy328WkYFBDH/4bxl6uQowB/S4V4
         n7aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764001408; x=1764606208;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=M2J0sne9dK3n8ebmX/80sgM1htWpoO6vvwfgujnWbIg=;
        b=Fc6N91ANfuc9xFSYBBu75kkvxDDa5jxYTw+kWja8fdYvGCVKk7MFMjtOZqXmvdDdrB
         ckLgzZXKF+EVFxQakBOLmlWWzmXG2cgNBHBbWu4r5ugm4kOwOR1DQWpepOwSTvuq7crX
         PffNNItwdHAMAkSfr51peKo4Ddi2RMS7mdjr3ybnOtSLAPI1q0nNhxa/HztJxqmaSOvA
         xlOgbVroCI2/J7sm6dkRJFMubhEDp3iD0HOd3ImWPMdooKb1wxXH6VOT4Tmk5PbmuP/D
         Ivz3g7b8cexApK/mYCAXkLk3YnlYYrCrvzweexwx7BN11Ww4GbAfPf3qokfH5tB3BZxM
         3Hgw==
X-Forwarded-Encrypted: i=1; AJvYcCW+MkqQx262rkrl4twISv8l7mt+o3Y4Tj8m2HBgwstIJa9fedKQ3DmcJjXY3RC9Ts2Y8rImfKh0@lists.linux.dev
X-Gm-Message-State: AOJu0YxJZATQM8KADAWaxpzzTkR7hAWCyuaj/GF5liAcPu54VHECEWYY
	wJtMIBmrkZNvEB+w2x4qaEoKXOnvIJHzkfSFa2kLJXLMswvBzyxoVlm4BmZ8zzkwRKQHeP8lZ7o
	1raH+aiFnJEXfjPOLX9jSy/YPqwOB1i0=
X-Gm-Gg: ASbGncsYDbdtiwPvcFFX3fXcmmWascdAy4RanKHtyNoIbSo+u7O+VxFekZfpDnBVljQ
	FU/L/1qWQU+ksJUvHU8otAKNtwOtyb6XWAMbUVAEFQIQuYQ55py+bb6JX0ps1c2Cs7e1prWbm8z
	lc5rMXlQRaIeDNVJiwTBHNO3dFMYKSNPIgq9wn+mCPpxvpnSSrYLKEM4pQjoR+9Pw9wnR6fUb39
	Sb//vvu6FimW6+z9kwfJ9bRuSVqLy0zb/Fge4ju4gdGWQpuFoGnN0ZX8iV1cFTqmsQiuk+eAuTd
	3KAEpHIyf0GY6T8RF5MMi7cnUMSqnmfqpj113bDX/MzjPgb1PDoBQ8Zihoj6hP8XCfGOeYjz9F1
	0ZOk4uMDiYHS/xw==
X-Google-Smtp-Source: AGHT+IGwXl0ZV6sCuJIMY3nmCYvEqmx2yNHsP6C5DZXOUJriOekXZR8ClIwnhdXq7nRGAKTyK7rmfByoSAzp7B5Pcj0=
X-Received: by 2002:a05:7300:dc93:b0:2a6:9dbf:bbe1 with SMTP id
 5a478bee46e88-2a719324a83mr7221018eec.3.1764001408335; Mon, 24 Nov 2025
 08:23:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251124151837.2184382-1-ojeda@kernel.org>
In-Reply-To: <20251124151837.2184382-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 24 Nov 2025 17:23:14 +0100
X-Gm-Features: AWmQ_bmjzzjuGyZbSwxV4iB0sa35jisCYH7BCVB9fd0FJ3BHVjVHicd2rDqz0Ns
Message-ID: <CANiq72mLMHF35UaML0RqiTOkVORr25W3Ug06uttYL_H4XCW=4w@mail.gmail.com>
Subject: Re: [PATCH v2 00/20] `syn` support
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Nathan Chancellor <nathan@kernel.org>, 
	Nicolas Schier <nicolas@fjasle.eu>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 24, 2025 at 4:19=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> This patch series introduces support for `syn` (and its dependencies):
>
>     Syn is a parsing library for parsing a stream of Rust tokens into a
>     syntax tree of Rust source code.
>
>     Currently this library is geared toward use in Rust procedural
>     macros, but contains some APIs that may be useful more generally.

Applied to `rust-next` -- thanks everyone!

I mostly sent this to show how it will look like and because I will
use the expanded cover letter as a merge commit to keep it around,
since it has now even more context, and it is a nice approach for a
long series like this.

Cheers,
Miguel
