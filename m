Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 906F216DEDE
	for <patches@lists.linux.dev>; Wed, 10 Jul 2024 09:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720602293; cv=none; b=qN+UeIOFGqI5E654yhtU4sEutC3k7IEBJDnakQwKIe+bG0ENAktKhsVKwUi6i5GURkgnHjSQGcJXeRdwmXMCv6AP+rVHfQZmd/rFOzrwlnk/dgiGFEl6tP9idfouRFNmenHMOGhcC451RiX3/U3iLgNizc7QMoWKj9juoW+vxPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720602293; c=relaxed/simple;
	bh=DLL1xT0k5HfjitQkuRMZipxTQ7kPrbtJ5x/exRvIFJE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Yz+GS3Q1rw1yBwba2EkK2pN6jBy+Svc/HiEQ/ghWSg26TNkdcD2k2tBWoPHfLtHdNAQoRhhQTxakdZpyevYBMh/lNn5LOaMNWm17/EpbwFHDzUzFann5DDXT23tZfOU8pWCV3kS1dLRs5RhtMARp9otxgAHBBm5nmb+EO6XQ4BU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FJEKAuAs; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FJEKAuAs"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-75cda3719efso3083866a12.3
        for <patches@lists.linux.dev>; Wed, 10 Jul 2024 02:04:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720602292; x=1721207092; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DLL1xT0k5HfjitQkuRMZipxTQ7kPrbtJ5x/exRvIFJE=;
        b=FJEKAuAsixsXcEQoghW4RoBP+q/NWaffYFc9BshNH11/Luy1+87hm+Mq2EDsT1MHqC
         26FbPx+ZOlpTQdjiuDLhE4BbHyfGgog6vZYaFB8ICfOgfX3rpaYPeGthLptj8PMatBU0
         SAMYqZgu8gMF04lj8XK/oJruXXbdVd4fIAfoAwyzOZz9CtIOmWuviKhhoF24gTz7x6ZG
         KUMjmip4UGx61J4oKckwOTVd/5udt3Ks7roWWr8JB602XNctiL1QIZ4U5CTs7L7HR6/W
         36scY5uMD9Dzr+pDrXWN5bKTaxqVAOvbhNsRVYTkEPXTfyGuWFzOwYO+393O4CKzA1PT
         7Rqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720602292; x=1721207092;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DLL1xT0k5HfjitQkuRMZipxTQ7kPrbtJ5x/exRvIFJE=;
        b=lh72ta/TeFo3I+DU0eT8r89ifZEJC3tnYWlu4XDVT3NOkeO76qNR4MPCYwwgl9W+Uk
         OJGC895nRGPgSuxa3f/8ZmtBofNagYkRS6/bdP8n6ysTvfbODJQ9tVH1jMRQAERMpikU
         2YoY15VPJb38wmB2bHz2TBlVxy7X2Zd8NvQpW0u0fiMzGT+IX4weamgA2vcxXgpPo0I/
         R3/S6n8bnKERBmYSEwWTiIP8OuV3id/YGfo4NZzLZ6q59ZaxTNkUbqd88+WUknt3DIPt
         /64R+D7DMVM6rIIChak1wndQo1ViE/SrbjNP3429izBvTu8jxZIy/RDb0G3q06a8k3pR
         UZMA==
X-Forwarded-Encrypted: i=1; AJvYcCWKRhnSCgTr0d6qsq/kxez6Ee3yZ2iAogrtB8V91LiKqEiDfrD82dzwyWtZWkctHjIXqM5fzTLZK9vYfN5/BwRF77wI07xJQQ==
X-Gm-Message-State: AOJu0Yz1Ih0uPujyKH+rlfYHIPb8dLHmlU9CaYkX64bWey0D8aypPu38
	tjAV5egIEsO/oozIWO++bdyi5h+/mLEshowtyvA7EZW9LqodJ/wyH+VYN/VVgdus07a/n9orssQ
	KnSsV/TJgJufBz/Byt+fzLJts0sM=
X-Google-Smtp-Source: AGHT+IGd/ocnQeH814AHjmzEOnDp2IpB57VMlUlLakN67CAmTn7bF++fqYN7Y9GbomXoia+gsVx4qX4rLya4UThHdk0=
X-Received: by 2002:a05:6a21:3285:b0:1be:cea:d381 with SMTP id
 adf61e73a8af0-1c298226c3amr5645713637.18.1720602291779; Wed, 10 Jul 2024
 02:04:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240709160615.998336-1-ojeda@kernel.org>
In-Reply-To: <20240709160615.998336-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 10 Jul 2024 11:04:39 +0200
Message-ID: <CANiq72k9C2NY4nYyRQ_KKPbNsDvdaSG7vPQ-fzo+2J1x_-prLg@mail.gmail.com>
Subject: Re: [PATCH v2 00/13] Support several Rust toolchain versions
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	workflows@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 9, 2024 at 6:06=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wrot=
e:
>
> A few things improved here and there, and rebased on top of `rust-next`.
>
> The changelog is attached to each patch.
>
> I kept the `Tested-by`s since most of the changes are on documentation
> or comments, though I did remove them on the patch that changed the most
> just in case (even for that one, I think Benno's and Andreas' setup
> would not have made a difference).
>
> I plan to put this series into `rust-next` very soon so that it goes
> into the merge window.

Applied into `rust-next` -- thanks everyone!

Cheers,
Miguel
