Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EECE015443C
	for <patches@lists.linux.dev>; Sun, 25 Aug 2024 20:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724617791; cv=none; b=Ug2Nv8QMMBLXbHDWHU/bN+s7C2AirFRKLNFbxqX8I7VzRIewi38E6bKIaT4zTY0Y8/yQtNpJsHoHb51HW5i5eME85tafOpCc/jXzdox5x0PyFCd1EneS5HGGtFaCNzisB4Z1dFCKBxozlAmb5cvJ8f9Ume/hv3QLiip1FGdm4pY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724617791; c=relaxed/simple;
	bh=Tabtq3pbe9qAyEkgCDeJgXpNUAzPs0xWGHdygU8SfDU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WTXk5tD0sKxyb8plr5dEt8QZ1+HKBPD6rv4PZJwC0gisURpdeUp1IJYpZhqvvWTHakJzXacfSrtlQMeQmvgamAScsolZE1B50pyadtCGUbad9GlTZ6KelLbGpmp9OOuCX0yGwzsTfR/lmYRqvsN2cymHQf6PbT2l82Bt98If73Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CK5L9LHz; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CK5L9LHz"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-2d3cc6170eeso671343a91.1
        for <patches@lists.linux.dev>; Sun, 25 Aug 2024 13:29:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724617789; x=1725222589; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tabtq3pbe9qAyEkgCDeJgXpNUAzPs0xWGHdygU8SfDU=;
        b=CK5L9LHz9qCQMbMUEJ8OHEy1+IEOoOg/nBZ35ldVKY8JQ81pwN0/HNjZ1nNMj+6idS
         l8Hn2t9DMSdocOUjmNTluu7cjJ2lPC7Q8cT3V1rwKehcGb5/rI+oyTj/KsI556GSthC4
         GS4rk+aO87rDMn4q5jqYxDkOn8bp+9nak/xeN40BFqLdhuc/v1AmT7AT4gzg25v+JxKu
         MDfk8gZsJJzEgcOubKN5dJm3UahulawottVlf8uxq9HLd4KXRppJLJmWC7gdp7rO7LU5
         5otvg6O2KexQssq9QtJQWKmbkb+P8l8wgCGcDQuPmGZUUh/1wzB3HkBg/bV3WnHu6uAW
         DfJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724617789; x=1725222589;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Tabtq3pbe9qAyEkgCDeJgXpNUAzPs0xWGHdygU8SfDU=;
        b=nMtX+CjsDtgvGmebqtFc7LctLx2KORcRwrAWNxAzkrX84c8bN9y6qCqAHLSWk5P0Bv
         zy6d/tMNLKV6stcBVTiz79B6gJdIXbbb8othr0Sw7oVTReT/GX5QDorBIZWNXTvc/0qB
         mRvRHwo3/In0ZnMb2sPnzmy623iAogo1fdCG8UHAEk/pp52dIeKajAhI3cdxurfeQTPt
         mBuXnHiCoVxlMgD4Sjf7oO00wU1B3qSzVtMxdXQrNsak8zKMMzmtUxQewKlToeKCSi4W
         AqGPD5xSkYn0mCk+GCHSqSF25XDeiN4bZDDn2S/yLGaJjj9Ux/8vTAoqjiJsGEby+Oup
         Lbew==
X-Forwarded-Encrypted: i=1; AJvYcCWU5JD11TmNk3H4owE5adbHLJz9QVaSqk8XEaY3sdnxAZHXYGEN+IK/jyhi5JoC5O5Al97pSr7S@lists.linux.dev
X-Gm-Message-State: AOJu0YyIHSEkZnEYQxQjCZMat7sNpyXIBa30zUpS6YiXvRaAymiheTeI
	9TEvEGcvpfqSfPRhUP3DE5CmrwLvAGbcB+dq4dhSy7nUc1rDe2wtn5HW75E3k4kO0Fgb2GfAjlt
	IC6d9p+7w+g/3KZE6z6X6ifU+rAk=
X-Google-Smtp-Source: AGHT+IGJ0vPpx4EfP3jAuDeWFpMIZNHlyFSDsmJuLjEou2DJG7XpFM0CJHn7XJgN5N7kJO9sAW70557WPT2I2byI400=
X-Received: by 2002:a05:6a21:6da5:b0:1c4:d312:64d8 with SMTP id
 adf61e73a8af0-1cc89d6442emr5691191637.3.1724617789154; Sun, 25 Aug 2024
 13:29:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240818141249.387166-1-ojeda@kernel.org> <CANiq72=amLCxV3QRVqK0gVKnGZe_YeqB79LkydEjZ_hJ6_K4QA@mail.gmail.com>
 <CAAOQCfSi9sMqgBzh+v42XGOh2fopytBSjxfPp6kd5DUcGtq20w@mail.gmail.com>
In-Reply-To: <CAAOQCfSi9sMqgBzh+v42XGOh2fopytBSjxfPp6kd5DUcGtq20w@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sun, 25 Aug 2024 22:29:37 +0200
Message-ID: <CANiq72nCJNGRSJCyYXn4+Xgq83doxB+oFE87P62pFtqpk6CZFw@mail.gmail.com>
Subject: Re: [RFC PATCH] rust: enable rustdoc's `--generate-link-to-definition`
To: Guillaume Gomez <guillaume1.gomez@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Wedson Almeida Filho <wedsonaf@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, 
	Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 25, 2024 at 10:25=E2=80=AFPM Guillaume Gomez
<guillaume1.gomez@gmail.com> wrote:
>
> Don't hesitate if you encounter any bug to tell me so I can fix them.
>
> Any feedback is also very appreciated!

Thanks Guillaume, that is very appreciated!

We will hopefully not have to tell you about any bugs :)

Cheers,
Miguel
