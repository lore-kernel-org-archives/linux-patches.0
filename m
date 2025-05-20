Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 135964B1E7B
	for <patches@lists.linux.dev>; Tue, 20 May 2025 21:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747775751; cv=none; b=Qzda9azUOeAHoEX9y/v2FLh9C4qDgVjLc+IMqcx2pmKwjIQwWX2onnQzSkASltqXKM8ZKpxbN1ZFTTkos+0BTDw7q5evOSd1u7wkX5gBZmn+SvClwJd1M5MBV7V1BztjL6KNxpbAbU+8f/5WtNP5nBFaX+ux0mQJT90w9f9aPPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747775751; c=relaxed/simple;
	bh=rQ0v6aAtkhMKUAxjVR9doQu8GjSnpe4bFE7B9ZAOWRI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kMEHfFSPOle949YWoTXf5LHiasGiWw35gb1HQgxlPPGGCvha2Gc5GJTefIFe9v0dmJhf2xsmIqgks5uTsjHpwjTgbr0ql7bPouYabFYfdROt3GhQ8qCdAGedmN/Of8ABvFma59RbPD8QkVQWhXOJy4LafJKna9YDfhDN4t3QPJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CvBYX5sj; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CvBYX5sj"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-22e19c71070so9407365ad.3
        for <patches@lists.linux.dev>; Tue, 20 May 2025 14:15:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747775749; x=1748380549; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rQ0v6aAtkhMKUAxjVR9doQu8GjSnpe4bFE7B9ZAOWRI=;
        b=CvBYX5sjnuoKhHpBGGThGlShsJt4SiVHNx9+4xUwlxczEiWkOkOgxxGLoc+e8Y5QHf
         U+R0fq9cBYKJd3r5seXwFldC5UlLzmb1cKl//xMngsV0VDCSRr2W9JBE4rloRDsotkme
         aA/LWts2ZjRJ3LLP5i844quyp51TRZl/Ela8c/OnXg3JihHT/D6PL7NhNLvJpN1hZjwT
         gl/CKPut1t03TEJh8Ap/wxBLjWT2Sm7UcpYlPhr1v+CCAjLw2LleR8+Lu/pdMgdRYYLn
         OdrCqtjpO5PWWrT4hxiTJ5AEW4Wex8QM7DiEQ/JQ2h9rpBOLMNEQHkGY3L/yvvG7rS3h
         8dpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747775749; x=1748380549;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rQ0v6aAtkhMKUAxjVR9doQu8GjSnpe4bFE7B9ZAOWRI=;
        b=sMF1r6L1mwjpD5uoCeHh7S41x/t3/M93rzdqEEDW+7BR0s4K0GKKObB4KTDUjwEiJ+
         wZ032sqrwLVcuEmqkUopVi5yrl4yV3vJjf4jG7jpxKlBGYjgRQ0yQRWx2qFFUJDNiUyn
         K+Mm7x0d1tjrmxoBqd4U4YjdDFwlOvIJFzVQQhUHTMOG/4L+nWytofTCEG0HqK0TuRvR
         PebKPKzIWFTeji8QaNb7NUjE7kV+hsPEclfxDl1VstOWT6JmKoGQVo0NXf8POc2vtq1y
         bBeXXDZu4hBD7VLDeTFcIe5WvSROXN3EJOpR0AsFetkuI5An/lVHllaVFFh6YKNSeY1F
         ylNQ==
X-Forwarded-Encrypted: i=1; AJvYcCVFcr10yTXJFu+la1NumkyJRcQYznu1TA6aUDjCpJnfVFgmAnzyC1UmQ079W+lXvMUl/p+P8J+o@lists.linux.dev
X-Gm-Message-State: AOJu0Yzp5B33bOWyOOq+8ZJ6XRJso5YzhFYF8g5lfXdL8DV+7/KAvaRF
	9SdfnmHuEC8EJgLKNazDatyyjauxGA5GuthSibv3rPdDxt3DqaZSQrkuSxMFsK17WEulpjNYSt/
	XvSzBat7OchwdClks438+Mn8QtQATYUM=
X-Gm-Gg: ASbGncs3SKqo5rkqTfyJmCmA+mwpHY4Iu83tBk73YUK5AZkrxke6LWXh0WYfrNENLvd
	uTX1MCitZG6h3NZVulFQp+r5v/r738Ne15Gc+tEYp9LQTVUYXJEdAL9Jr8f4HCZSAukcbEVf/GF
	CK9x30GUDIKJM+jCr5VMkkIdMxKbB1a9h3RxdLS515w7A=
X-Google-Smtp-Source: AGHT+IGe5cmPDopFk7kzA8avugdNH9Oc/G5g/gnDbo4+tqDroKCGs5KoZRfDCQgaJ9Xn1CsSiuQtgV7Lwhr9LWD0wbI=
X-Received: by 2002:a17:903:2285:b0:223:49ce:67a2 with SMTP id
 d9443c01a7336-231d4502e3bmr89295735ad.9.1747775749295; Tue, 20 May 2025
 14:15:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250520182125.806758-1-ojeda@kernel.org> <aCzwaCkENAiaG-As@google.com>
In-Reply-To: <aCzwaCkENAiaG-As@google.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 20 May 2025 23:15:35 +0200
X-Gm-Features: AX0GCFsvA9kp6CIt8sW48iUVHIlQVdVSvDpStLMHCL5PIeI8knACDOJ3Z9bIlow
Message-ID: <CANiq72nQdaZpWmVjt3wqNtZRjibecwe=Lh83mQB0rzV8EjddLA@mail.gmail.com>
Subject: Re: [PATCH] rust: remove unneeded Rust 1.87.0 `allow(clippy::ptr_eq)`
To: Alice Ryhl <aliceryhl@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Danilo Krummrich <dakr@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 20, 2025 at 11:13=E2=80=AFPM Alice Ryhl <aliceryhl@google.com> =
wrote:
>
> This commit message is worded in a confusing manner, but the change
> LGTM.

Yeah, I wrote via rearranging a previous one, and sounds a bit
strange. I can try to clarify it when I apply it.

Thanks!

Cheers,
Miguel
