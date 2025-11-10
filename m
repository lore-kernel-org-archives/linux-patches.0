Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F042731283C
	for <patches@lists.linux.dev>; Mon, 10 Nov 2025 14:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762784438; cv=none; b=TmYgVVt6GvXoU6bhtRU6esurVr+PkWf5BL7zM4z61nofM9tutkcUxiUhW8EG+YjAy5sbXBnQGA7j77IB70wY5DZgIvz/QKUMY0vct3YjiCRnkINCT3DD5/thWdMjSJV92WiPf0yyjdZYn2UznRW/WHQYK8DCQMlWr4dkqj/S6YY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762784438; c=relaxed/simple;
	bh=5RJhHiiCQwpWrTvgzqpoOfkmMP+cjTCBSE/GzQfeUmA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ikp1pQVF3rkrhwSHRb5K43cp6LtSWrt296MssQat2b8eioKJK2IYPkJmJFHi+cGJQup44mZsz5FivJasuHCW4iGjOS16eYdp56Olu9ZLdlxNExVM2EJ5IPPVhq5xrO0zgUVRcPVIQFyOE8+USaxWAsetIVHuKUBYIrRBLuilQCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PxzNiWRs; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PxzNiWRs"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-297dfb8a52dso1832615ad.0
        for <patches@lists.linux.dev>; Mon, 10 Nov 2025 06:20:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762784436; x=1763389236; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5RJhHiiCQwpWrTvgzqpoOfkmMP+cjTCBSE/GzQfeUmA=;
        b=PxzNiWRsUAFEHzBKD2xu+QDj4qhMVBG4xaI3dU31CYRnfP1aBdUXZ44HPomLcu4erc
         DOpJkAKxCvysBn1ATVe9wFjXRqCdazHLKrWXcE6AYjRrubeJKyoAfPAT+BrLRt3K6ON/
         fjKQEoxFKySAIV2n3d4F734r8SS3w241/5BVCr8jprD0m9VGi7qIrARz20BexKLjR7BC
         LuxY8rAxu+EUjZmpOhXd/1tIbu5DNpbKxzqTfpcweFxyKn2/HnWsFeK1Qg9V9WGHLvx4
         Ki3lBjuCR9r7GPsnrnjZlBGeybBmsxeGscRei5aun2l7BhUIV2TS8YcTKswyOKHcErt9
         h/UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762784436; x=1763389236;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5RJhHiiCQwpWrTvgzqpoOfkmMP+cjTCBSE/GzQfeUmA=;
        b=foruHZHH+VxE5CpuhTYMPzDQVd2AWIEtB25X1tVG+gDGAANC8E/iZNO6LombLXdn1M
         PvCmoXcjQCH8aILhQuWGZbzfdescWIozxJEBV5MFUehL7E/+AzHa+Dg+JxEydLSoN443
         Ifr2ephY3UFqpl9ewXV7GxfI0AUfGdCgwYn5oUbl80c8UkUS1QWCqDfVa0hsQk3xMB5e
         tXkoIUtPMu/4lKFGJ7SDqG9ykrPvs8kET4+tdEgLgXxX8445eFaukKywjoWRCfrnQHAx
         oC6XNorpDkDLz5Lvjq0as1JjogOZL+RiQasIMaO63/bhkY5ORxL+4icvGmXYS9b7P9B5
         eTvg==
X-Forwarded-Encrypted: i=1; AJvYcCUYI3FitULurrbG+Y2vpSmkvgp+TIx//kidPFdPD1NnXoFINnIVizzhVuqU9PHYXvhOkQ7G1Xnl@lists.linux.dev
X-Gm-Message-State: AOJu0YzoclMSUC4nlF8ONV2mZlzspTItE0K3oYUVm+nZ+++8lhhULHWZ
	wWTibVSw3+qHnJcdi+gdN91sH9gawul11EshMnYqdmeZEk93f4mtbonRg1XBJsugIUIkadS84FJ
	6blK4uLVyL8F/kbgzsdrTv35Hz573PYg=
X-Gm-Gg: ASbGncvOH7vCHR6GdkdAYJQ9FCpAhtjxi7Wj8aln0xL2ISvd4y09K1Conv/Zhdo5FEB
	JLSLbWdNPgAn+CcjyoS+XpevAF042u+H6DREeznTT8hahQg/sYGsrzpIk/Prfw5V34T2ohh/vsx
	p5M0Ynk2Ba7Q0eWNFKWIYFeKird9iGKwzn/YAzC9f7GC+mbzwo4vKTMOSbHdsanh9vvmqhPIuHC
	xKwRfz5ADuYSrzPA6UknJVw9YTaqz0UbVawjlr2JPoF79gDjLDYPNqbCG5Xp06P0+M0u7ovVgt2
	AQTDW9lClWynbiuNIhjKRj7NVkU7p6J1lkgMbNltAtLofc+DnXsAuXhIWDzu+qlU+RDdHA7DO7C
	yqug=
X-Google-Smtp-Source: AGHT+IGZkiX1aUs0nv10YP1XlBKx2b0IQf5b14V0qJA2D3DBZY4ttkzgbksRaQa0wfRvU24Ndk4q5iwI6HlbKZJm+ow=
X-Received: by 2002:a17:902:e353:b0:297:e604:598 with SMTP id
 d9443c01a7336-297e60407famr37566705ad.4.1762784436127; Mon, 10 Nov 2025
 06:20:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251110095025.1475896-1-ojeda@kernel.org> <20251110135927.05d83da2@eugeo>
In-Reply-To: <20251110135927.05d83da2@eugeo>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 10 Nov 2025 15:20:23 +0100
X-Gm-Features: AWmQ_bm2tVFpKh5HhJeEvZYuh2tSSNBK7puyKDd5qGaAhmDUcRORxxihnStSDk0
Message-ID: <CANiq72km0fyL+ueULZZCcg+2Uc5HTtdE_C++WfigLFnqE4sZ=g@mail.gmail.com>
Subject: Re: [PATCH 00/18] `syn` support
To: Gary Guo <gary@garyguo.net>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nicolas@fjasle.eu>, Boqun Feng <boqun.feng@gmail.com>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 10, 2025 at 2:59=E2=80=AFPM Gary Guo <gary@garyguo.net> wrote:
>
> Thank you for creating this. I have been wanting to use `syn` even
> before RfL was merged into mainline :)

Indeed, you were definitely one of the biggest proponents of `syn`
since the beginning! I could have mentioned a bit more of the older
history in the cover letter, sorry.

In a sense, this cover letter could have had a
Supported-by/Wanted-by/...: Gary & Benno et al. Actually, I may just
add that :) And/or perhaps something about the history in the actual
commit messages or use the cover letter in a merge.

Thanks a lot for the very quick reviews and tests!

Cheers,
Miguel
