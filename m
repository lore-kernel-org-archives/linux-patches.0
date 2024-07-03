Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 048611849C4
	for <patches@lists.linux.dev>; Wed,  3 Jul 2024 17:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720028451; cv=none; b=DeUrz6SzwjRVDeXPhhQdcPwyIcAvAB1Pi7R9PP/yzoBUV0cY7eZHQV+OqTfbZZ0rmDFJC5h4u1CZjESwm7uCmn+0W6I3IuxaIaRNhVHp01Wptskffsh90wo5VKFX2wU4Naz91D4+n3/Mm9yjxaw9gnpTSjRRQnV3NZzuuBHRaaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720028451; c=relaxed/simple;
	bh=wex0WKk5BhdokWgF9E4s/kjdWipRk4923QEoWYHdIBI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=irBWpAwZPWZwrcke15qktINdr7j3Do+4ds1PhKkJHZSVLANpN9ZTBSoKKTZdS9b+jm46ad9VtLzXfsmP4k9rFTRKK/CMPRg5SpHgdCyaICYciOBM8Md8+ED4D7cx1Uk/Cw3KKCMdz9x30vqf4STDXIwg7XsG72piBgUYxAbn0Cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VDbxsA9x; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VDbxsA9x"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-2c96f037145so1165891a91.3
        for <patches@lists.linux.dev>; Wed, 03 Jul 2024 10:40:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720028449; x=1720633249; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wex0WKk5BhdokWgF9E4s/kjdWipRk4923QEoWYHdIBI=;
        b=VDbxsA9xWOoVvBoyIbGqC+X63aeY/nbTPmTyESAxg3MbtTy1w3LRW3oZashKzMYJVk
         6gQdWkZ9G+urmDzMFtk7RT6VuBdYFNMPgJPFskGpNygp0UBEAjsXunqmiu8XvyNVJv+E
         t4C62ssDxbb2536m0ediKnSQfzqxwyr7UbJDTbK5pMHatE7+xhPiJY9c9pgw055owNz0
         Zinp9TPDbB0nQkvLR8jQExI1Hx/Aj1Y2EiIYtVpe6kC6biTw/rSDm5xgfsMrGl5htpGL
         /w/aDWhYSc9GsFYkhF1jlawM0Y5kmBv8jvLkaFiosui81sD+451kGrFft9M6qj1fhLWL
         YnqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720028449; x=1720633249;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wex0WKk5BhdokWgF9E4s/kjdWipRk4923QEoWYHdIBI=;
        b=kHicTK8cqTm6KZDxhh+2lBEJzeSq8bBT92JKHlan3Wdl1jq3hnmc+E2RpuEQEv1z9w
         GxQlsrOPTdCYR/urVbIepFCk9FcE9QkWwFRBZFLuhXBe6Nw5TLWoljOJhrxu1eVcOjXM
         vT8WyAQ1jdCqXrUEZQ+Va2MJovCV0s9BMaVVojTFZm3cWqoDII+ieG7R4oRPn/OK5i3T
         F3MypzH9uP36hQOQlJOm6IsGPTccDIRs2Z3td20VlWEb5PCdyYfLFXqclI12Y+UJZpXc
         aYLKTec6b4K0DCiTvkBfboeL6gUZB9mXAyhDWGNem5ZpIP5z6UODFnrxv6RNInHixhBw
         7J/A==
X-Forwarded-Encrypted: i=1; AJvYcCVf8abmwE+jIaknBxb0A/L57nMA7qXCD1GfE/ZceT5DC8xJow/bBOAhvbnlggN8MQ6Bj/jqfiN3rYPZfQeM8BvmJ1Z0v/htCQ==
X-Gm-Message-State: AOJu0YzP6OUB4zUdM3hdLpywHfgUortWI2+OX4hhNG2V0raWiJG78FM+
	Ddz0oTCJy1/TJNWRYsEsTIuEsbVc8ywfI28/EJAM8EwUecrvbJ4U2xor7CEibnd743XjGi36+yF
	JHUUHSmuLVOA3iq8F4w+TfUrg9D0=
X-Google-Smtp-Source: AGHT+IHnHwx7IyZ+IzlqzxWdkn4wR99KOWTN8jBuurLTZmQaR3qi3+Z7MUlwkpOnAOop3N9MbKy0n0WLIu0QPmbUo+s=
X-Received: by 2002:a17:90a:fd8a:b0:2c9:83f3:1291 with SMTP id
 98e67ed59e1d1-2c983f3130dmr1320549a91.34.1720028449186; Wed, 03 Jul 2024
 10:40:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <87a5iy8jlm.fsf@metaspace.dk>
In-Reply-To: <87a5iy8jlm.fsf@metaspace.dk>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 3 Jul 2024 19:40:37 +0200
Message-ID: <CANiq72nPyZJL7TA5wXT__wKp3z5Eoue=RB_Yphh+NCe_AkRpGA@mail.gmail.com>
Subject: Re: [PATCH 00/13] Support several Rust toolchain versions
To: Andreas Hindborg <nmi@metaspace.dk>
Cc: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 3, 2024 at 7:35=E2=80=AFPM Andreas Hindborg <nmi@metaspace.dk> =
wrote:
>
> Maybe because I am on v6.9?

Yeah, you need https://lore.kernel.org/rust-for-linux/20240401212303.537355=
-4-ojeda@kernel.org/
-- please see the "## LLVM's data layout" section in the commit
message.

Thanks for giving it a try!

Cheers,
Miguel
