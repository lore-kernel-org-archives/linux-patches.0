Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88B383A267
	for <patches@lists.linux.dev>; Mon, 19 Feb 2024 16:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708358484; cv=none; b=q0/uoYNJ1LWgOSzPzk0J5b1hGaMlT+qmS2gYPeuqXjIbBPCUv+oav/G9LlIbeevNkmlYeO6yhmf46dRQjGKpAfoezZVpSWhL4LMSnj4p+bGdUkrf7s+U9J2a0T/3cgXI6wp95tIo05Zww7o9ckA5R/0FUlqM/17xDae0w7gfuEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708358484; c=relaxed/simple;
	bh=RjJaUO3UTTrFsrhoX11/20RQ9F41KV1HxKWjbf2SUaA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=k6nE4FUp2lrDxEVRm1EKfRQvzWEgYB3Hd646ejckDbRM4OjbsHWgVlOxuY2poWs4StiIl8j1KYL0D4/rumVW9hTVLBHOX1qpKvqVgYTIE5Q/q6I9OzpT4kXM/gAGbHH7RrhcbwoZghrAEnjTWBL80WBZC0ESVwTIu4ThqYe+FGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MQKvXuRm; arc=none smtp.client-ip=209.85.128.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MQKvXuRm"
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-607f8482b88so29075137b3.0
        for <patches@lists.linux.dev>; Mon, 19 Feb 2024 08:01:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708358481; x=1708963281; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RjJaUO3UTTrFsrhoX11/20RQ9F41KV1HxKWjbf2SUaA=;
        b=MQKvXuRmFs/VjwkT1hsNN4LunVkOkbOODTYj8sX+AqGBPx9tUW39uCTzClwVcnG7c2
         vlJ54InC0jhp/WJatWk1/Uc92aWlw0sRNtvCpKrt5DUXJJTtITqROBCDicqjXaHQHAWm
         F3UxysGv+FXarxxdMKU05MGnNDCJxNtIrUQurnvPKLE6lzwg9PtFHPFezoRfOj3kEY26
         YVo166uLi9+tcALSJ0IxaIAmHsr6YT+A1zQKDDHPYWIwDwHst0uM9roOn9OpjCIOxYqh
         2a4qaDmQAxznTmDBMdsIjGRwiuQREHAVxEFXbRViXRL/W/N3bXgxRmNhHnHeo727xys9
         Tl9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708358481; x=1708963281;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RjJaUO3UTTrFsrhoX11/20RQ9F41KV1HxKWjbf2SUaA=;
        b=H1FB3DGb4WD3r0+U9pdJM4YFIzz/7D9eAFVjvLa3E2mvebt+0QCHE0/eG7cIzKnWws
         SIiZ7YLBbQ0AM3U9d04aVAX9puRRf0mrwWHiMGTH3iIV8/yG53wFzA/Utt6o6nO8Q/eO
         kyFLJ9/QyH3+DL7bl3lztkoVppQyez0xhnGUkQkNJbnGKeIxUbMFgZgt9uOJUzgdRCpe
         QWQzvVWlJum1I6layc+vWX7uA66xH/gYcQEHocfiiKbLDhvwmhpkR5zMfFTjNSgSpTJ1
         j3/T+Pv6n8WhtjbeRtlQkxn1ViouWjb8u6fCJnvR+QHM1qyjm2PmVEbVApHnkdN/m9KB
         OJoQ==
X-Forwarded-Encrypted: i=1; AJvYcCW9S2bBCTEs07U5lCiGgBs+12SoZ8mto8HnYgvZ9UNjqs6Psga+u9whslXQlS0QPa+QPplW7zI7DphuDpN3yawMt4CNUsx5+Q==
X-Gm-Message-State: AOJu0YyyBRQpfLT7QZJVNr92CjNOqG9SH19iPp6kXl++ULoNJjMEs/oZ
	sGBj7xLR6UHiIi4ppBVnMOBemUIz/asclf0+Hq8vUIAysr7Wj//7q3Cle9mSCiJsvX9F7RjfHkq
	FcDj5d9saFbHDq3jXO698vUXFILQ=
X-Google-Smtp-Source: AGHT+IFV7cnfqHWd3LWv+ZHLoC4tmJGJ/Lk4xaw+zFGGTkElEoABI2C5HfHRAkYwwL44+IqGRK7P3TWcTOqJsPV5ric=
X-Received: by 2002:a81:b614:0:b0:607:f4b9:11aa with SMTP id
 u20-20020a81b614000000b00607f4b911aamr10367352ywh.21.1708358460925; Mon, 19
 Feb 2024 08:01:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240217002717.57507-1-ojeda@kernel.org> <CAH5fLgirUqw2hkEgFKOV4a2N2sW-GAGVY=KkkyzptMN+H2txfQ@mail.gmail.com>
In-Reply-To: <CAH5fLgirUqw2hkEgFKOV4a2N2sW-GAGVY=KkkyzptMN+H2txfQ@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 19 Feb 2024 17:00:49 +0100
Message-ID: <CANiq72=r9cE5ZT7EWe77g2dfprBx+DBrujo=mcA7r1hoO+=P0w@mail.gmail.com>
Subject: Re: [PATCH] rust: upgrade to Rust 1.77.0
To: Alice Ryhl <aliceryhl@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 19, 2024 at 10:06=E2=80=AFAM Alice Ryhl <aliceryhl@google.com> =
wrote:
>
> Maybe you should just add the as_ptr method to ThisModule now? It will
> silence the warning, and doesn't trigger a warning of its own since it
> is pub.

Yeah, either way is fine -- I meant the patch to be independent and to
avoid adding an API without a user, but it is not a big deal.

> Reviewed-by: Alice Ryhl <aliceryhl@google.com>

Thanks!

Cheers,
Miguel
