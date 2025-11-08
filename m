Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA26528507B
	for <patches@lists.linux.dev>; Sat,  8 Nov 2025 02:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762569447; cv=none; b=ntILWzXiZ/Vqa070pKVRdwpWTBbX4EgJXMkCiMTB589jw/AdPqhGoqPFI//Rejzgm/TixR+SmCu9469kwW7CXp1s3LNt3eXrlklGQkz0rPMXPD6vMFUg7S7GBqcEEF/BwBIT2z/00valzTWDuMrChl9hFyPsLfl/ASj6xxcnGc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762569447; c=relaxed/simple;
	bh=pZs543aQJXGBiZv1p3fT4nEMYNcLibbhNgR3xp64diA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZafAlbImp7ggpCGHZeZHUdNnGBHzaKNMd+5MOM6MMg+TWwnY2cIR6+4BZGXPONFeOx1MOVshC3njm7G6n3/wOda1pdoBr26DfnQvFafpVVkJ9fx6KovOK/j/S0WYIlI9t7yHTz0goFqmvQ2dcTdd1BjAfIezSIuryItfo5+rblM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VMu5HeDu; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VMu5HeDu"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-29498a10972so1211855ad.0
        for <patches@lists.linux.dev>; Fri, 07 Nov 2025 18:37:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762569445; x=1763174245; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pZs543aQJXGBiZv1p3fT4nEMYNcLibbhNgR3xp64diA=;
        b=VMu5HeDuNYzRjSOF3j9mpQnfNo/yvUjDxObdogfAtWncAQgcsXfGnbmThHlAZKsD7l
         FBEUZAEYSyGj1CSC16+4wIgZICFJgtnksyM3Jcc5dhX5Wg9z2ZVwIhVEk0KlrokRXGzj
         B2m7rVzx9W/ANU9T09sCY3HHb3siNabmf1ztf79RM+yvUs3MJctn0qoTUfTrL2EngC2s
         /2elGupBGWf5vyNSPZ9ndpL5jAuJp3wiTVKYD/PYe3LCJWduuc9ttaaao4P+ayIrz5hj
         SUl9cS3iXbhVNiNwBbfvKmrH2oSUTnj/QwXJ/n2n7y1ZF3EpqkRR575ld1hCH1WrvsFY
         u3kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762569445; x=1763174245;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pZs543aQJXGBiZv1p3fT4nEMYNcLibbhNgR3xp64diA=;
        b=D/SOAqlX+Rn+oNFG4NkoCvazzY81/AZrxBdYTfILvp9R/qLyzGWbS277ffL2M0hnKr
         0Qodd+X77ipRopV3ghxRiNrC3xrPLVsNxX7Ho+j0CUPGInuMUbf1lg6neUFWbjJcCZYo
         vaVDJBzH1EDBsB9I52kJdysvSpn299t+0miHGJ7ghyhhBazR/ttjuN7BIxxox93fbCud
         3lgiZaIIanub1S/CiIw+Jltc8NX5e8XRlU7bVfnCg+aWD8lh7xHPLhF8IfkthegtME/2
         IWGby543Zsduv9eMIcBsryuZSJx1xeNbqaXfw4bhQmSEGqusW4W/tx00Nz/4FpcvCjVC
         NcSw==
X-Forwarded-Encrypted: i=1; AJvYcCVuzf+9xWsmj+Np5xeiEJipAAdlAUznL4Am2vmoaDk5TQ03Ec2UEfoNaJOVJdnDfUONTDC0b5iK@lists.linux.dev
X-Gm-Message-State: AOJu0YxN9e/J8E3wbaq77IHixWHY3SvjDCguxnXt904dQvB18CIrMAO6
	WbIXEs3VhaO99P+rLMlEDPbz73a/ck2P2tdOA8F++fBSDoARttZmh8QollAVipvnbmBQ5YJbctV
	NGVEe/Ns7bg6F8mnvw+vQpNPRoYjn+ao=
X-Gm-Gg: ASbGnct/hcYs/HlfmtZkX8UXa4rQ3AD1ObcGzIrgXZ5zJ3+CNPY0lc+ACvf93qbDAzH
	2b58wopawsrGtNIPgWGhcNFmy1S7n0eVFwUJh4yNJXnopy7Daq6MHinjLu2HInd2bLQWm2mcDnC
	lQfWkz+5RJxx3yAG6WlC7+Gl0UrLP99wZ5350r6hAvDFlufa06UF6ZC5GMHsKJdzDTaI/2uLmcC
	3AOZhqFU8otAYkAfylKeln3t56kGWuvnqRTKNb+Wmjcse+7KQICHK9iJ3LdkW4LaTSxwfqtRNJy
	nF0IAbnqlZpBtkrEchrwZWuoU2s0cgXxSsishL3faXfAtpJ4Qq1rVx4Gp3fUKZrUlydRw2pvDKL
	Ji+pS4E6BXdSZ7A==
X-Google-Smtp-Source: AGHT+IEovvjVicfDdGQT2CYmrDOWKJSfWNjNZjATvixUw1CuI60OG2r2rmWY0cQTlJoWG3OL54m2HoMu3xt+gxb8f9U=
X-Received: by 2002:a17:902:c409:b0:295:3262:c695 with SMTP id
 d9443c01a7336-297e5646bd4mr8325045ad.3.1762569445056; Fri, 07 Nov 2025
 18:37:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251108014246.689509-1-ojeda@kernel.org> <CANiq72nKC5r24VHAp9oUPR1HVPqT+=0ab9N0w6GqTF-kJOeiSw@mail.gmail.com>
In-Reply-To: <CANiq72nKC5r24VHAp9oUPR1HVPqT+=0ab9N0w6GqTF-kJOeiSw@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sat, 8 Nov 2025 03:37:12 +0100
X-Gm-Features: AWmQ_bkkl97L4KdKe3MLMAG94NJvyqaB6LbDFgvfVIDBf_nqC8JcMtGIqLcDcT4
Message-ID: <CANiq72kWWe_w-0088SiGvKFrh49P9wRcPxQvkSoU=SOpSrHbKQ@mail.gmail.com>
Subject: Re: [PATCH] rust: kbuild: skip gendwarfksyms in `bindings.o` for Rust
 >= 1.91.0
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, linux-modules@vger.kernel.org, 
	linux-kbuild@vger.kernel.org, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, stable@vger.kernel.org, 
	Haiyue Wang <haiyuewa@163.com>, Miguel Ojeda <ojeda@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 8, 2025 at 3:30=E2=80=AFAM Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
>
> With `#[no_mangle]` may be more reliable and it also gives an actual
> exported symbol.

Or `#[used]` to keep it mangled since we don't care.

Cheers,
Miguel
