Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E15D3310624
	for <patches@lists.linux.dev>; Mon, 17 Nov 2025 07:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763363082; cv=none; b=tI5xi9zg973QcG0mwbxxto4eLB4ax/RkpAGYRgVxY0f18VsWkIoEPKVnLNx8tk5iioQFrYuXU5Ypa6PlMLpX9T1PIhtJ7O++zInW/kH9PACYy8DDpuPIy2e5sXzYBfKro0lC7v1y6gv3gcHzL69ZKoC3c8IgV8agBF/Fa7rVgbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763363082; c=relaxed/simple;
	bh=CYPw329zmkubMZ4Oqp3vAoduc8Bm9/LkBfg4v4vKqr8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bcsl2qav5oKFW+vE6a/VCuzbE6xVpTl2Ls+sCtuSPx2IU6IU8PRONMppmGjQyq86eWGWz0JWqvRG7zXUuTJTUSZDhaA23/WoHLf+w8iSYKfHLZUsxfuMBaCxpPSGddRCZGYwgC4divIfYtRnaQopTHDRHLdLboCZESUE/T4048g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ntqiJ2Tq; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ntqiJ2Tq"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-b9a5f4435adso328232a12.3
        for <patches@lists.linux.dev>; Sun, 16 Nov 2025 23:04:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763363080; x=1763967880; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CYPw329zmkubMZ4Oqp3vAoduc8Bm9/LkBfg4v4vKqr8=;
        b=ntqiJ2Tq2zLJETBrvOwYL80ljEAWAHzhll4MAXHaJX2cvzZz6wAz/UAJCsDA2+7ccW
         zXvdDsoHBzTzoOpu++x2J2+vC4qZNsz4X7/FLC02k6UWH3rF2Ll3WQTUoclZGHEqzm0d
         f3IZcUOofS2twzA+s/lriReIqrNp76FkwA2G0S6t7Yd7UM+UitNzn1j9vuogQAFeKJ93
         BVVWmGbIHiOMJmndkjJPRmnsKsAyfHHMCvheORqnb6o0BePn/P+h6tWMVN8VRgOuoFr8
         hiiSSyH2A7B7bhETxPZ00EJN3qZEX9kp1ene+YSGXzkG353COuKuutOGfauxkbmaiW1o
         Vj0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763363080; x=1763967880;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CYPw329zmkubMZ4Oqp3vAoduc8Bm9/LkBfg4v4vKqr8=;
        b=bmgBfrm2lenvpC8vbYI74tXlJ0TNVF7a2bo0BhBsiLpuoDdhkpjkFY9qIPiwHdZZND
         fyLGOsOlXkfTeiJACGcdHl7VGh52laSmZxIsLOrXmZZrIjBkadHhXtpaeUbUow155YIK
         2f3DvNP3J82eqBM+QHP2SlMIvLXEmsqzvj68bfIjlT9oeIgcuRrE42S1PyFUwu0fOYFK
         Kbkl5MgQaWTpGPLeqee4CaRKHD4kYbpSpQ93xaM+VgHuFoAqNnxV+usb4ABYGr6h+Elw
         6A40JziuokM/3+J2A9ES0Sf8T1c8bvKkuw1DIJ8mJI7yXD85EAVmtRNFhpr7bIP2Hjo+
         tqrg==
X-Forwarded-Encrypted: i=1; AJvYcCUKEy2Qy6LE/vfkc0BaD83/3mzBrRZKASjRN++6Kp6b+R3MwBeyj/yJNzZaCMN4MEgO2rB3Y3jO@lists.linux.dev
X-Gm-Message-State: AOJu0Yy3sQmgdL+S/0FcZIT4hWWKIs+2a7bGKAz52DAvehMUYIfKAd58
	Qt9gsWG/zYEvf1e34XmT3dEbO9wYlNJ+h9y0zrD4Lw6aFFt2L2YR2YAfTJq1yvgYdY8tfdTaAk1
	NyEDzAaeY8DbMvt7s9QVfcHVdPS+fSSo=
X-Gm-Gg: ASbGncuiExTFhxoYMo0E35MTDZc+GxvEPgrEPELru2fjA1/9k/T2dy+c2JHfoeohJUd
	viOqEQ438SyYEFy+UV8tVP56j5jFzwH/1LRBmAb49fqy69uwEbDa+ZeKrNJQ2abRqvWFCmS8Gjj
	e1AuFQbHuxG+pmJq16Dz/hAwN7ss0fnbMz6gHNMjD7wqJwnQXD4JEyCIqsb9chdyV0NaeqTPFoQ
	V6nGNZJxAY/qJobaeBBdmszi1CGh9Eyjo3x3Jq5z8eX/v0AlE+FsxEDRIiujcFrEcPYoA1lmxPg
	nHfgU/ao00OjTKD2ONPiMniciGycIwuPyFGs5WTQg/xJkPSgJZ5xtV/7WsaE4FiXCVkXLmjySuK
	MIwU=
X-Google-Smtp-Source: AGHT+IFF6tPDT0L4yizZVI1c10ZclGyviGsHkCQk4kxS7isKo2vtxkOxYRW0hlhC0Uw2BCeIjdVEY0/KECyEd/erkGE=
X-Received: by 2002:a05:7022:e0d:b0:119:e55a:95a1 with SMTP id
 a92af1059eb24-11b493dbc02mr3847201c88.3.1763363079884; Sun, 16 Nov 2025
 23:04:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251110131913.1789896-1-ojeda@kernel.org> <CANiq72mjFobjfQEtNvk9aA+757RkLpcfmCCEJAH69ZYsr67GdA@mail.gmail.com>
 <CA+icZUVcHfLru9SRfhNGToiRmyOY+fLw-ASEvQakZYfU1Kxq4g@mail.gmail.com> <CA+icZUWqLbzK4ANrx=MDhhY9UFzazX6O3izbQeQ8bF0obuhT0g@mail.gmail.com>
In-Reply-To: <CA+icZUWqLbzK4ANrx=MDhhY9UFzazX6O3izbQeQ8bF0obuhT0g@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 17 Nov 2025 08:04:27 +0100
X-Gm-Features: AWmQ_bk19CSqQLRlb4nj4Al23oXTqmCbs9eMIWMN-W6GK2KEEvtJiaTpGvDsumk
Message-ID: <CANiq72=4-pM50mp+_0_+gEsd+Yu6m7yBaajnq5YZzdGOz7iGkw@mail.gmail.com>
Subject: Re: [PATCH v2] gendwarfksyms: Skip files with no exports
To: sedat.dilek@gmail.com
Cc: Miguel Ojeda <ojeda@kernel.org>, Sami Tolvanen <samitolvanen@google.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, linux-modules@vger.kernel.org, 
	linux-kbuild@vger.kernel.org, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, stable@vger.kernel.org, 
	Haiyue Wang <haiyuewa@163.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 17, 2025 at 6:28=E2=80=AFAM Sedat Dilek <sedat.dilek@gmail.com>=
 wrote:
>
> Tested-by; Sedat Dilek <sedat.dilek@gmail.com> # Linux-v6.18-rc6 amd64
> with LLVM/Clang v19.1.7

Thanks!

Cheers,
Miguel
