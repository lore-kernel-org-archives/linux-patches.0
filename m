Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com [209.85.219.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B544E23770
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 22:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HZ9N4ASZ"
Received: by mail-yb1-f171.google.com with SMTP id 3f1490d57ef6-d9a7a3e17d1so3520015276.2
        for <patches@lists.linux.dev>; Mon, 23 Oct 2023 15:16:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698099364; x=1698704164; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3068ADSkqthpsqS93q+/p6HJQnWPBgqqNzVxtTtH1Vs=;
        b=HZ9N4ASZvri2DpYzmjOSfaxoxefMzNBoySdHjODHs3qJz+lvzmBWP/4ptwSqNVtBWd
         TKKwuRAAjJRY1BR0fc5gV7fSkjnlSMRy7H97TdyY251nsRd/2K10vJ7LCgiL9YCAkNS0
         FvUddAR2eB/ipifUVSNqP7tekZyvULgqUuVa2gs47PrAuLFpVoHE3uBasNIrNVTQLfEN
         F942WYvBOMGwOSOBGNY1xJkycdF7S4zgAq8N95p1b2XOIeQg48OLWirE+qXIpxgsoP+5
         7lezkg+xzPha1AJAlX/qT6dv3/V/GIThdYjj5Pi9hIq6gc/pZtQdYaWYlPD9tW4yTZij
         0maA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698099364; x=1698704164;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3068ADSkqthpsqS93q+/p6HJQnWPBgqqNzVxtTtH1Vs=;
        b=BVXdyciAKbLaY2ZbRd/Ivut9GrMRnajOisbTyo6w4115kBBfKoo6mJyYl4Af+DHUTD
         n4rHmXZlQnw1dTRQLHhRJFrpuc5fnWKFyt7SagxzkMZO+awYaGJ2MVi4qLtxAQ0Ok6Kl
         oL/Y+qAqZ5jvhoFHlSkG0hdakyKqdHKTV4O90LMWWcV4P/LyDONLxdU3uYlyk06emJHd
         hKW+cXlkfKFErTIyHIGPrCN1Js09yE3Bw7OoUN2NHWYiQmmIJqOzJy1/9yOZUGS1Df4g
         3Kbf+qjAdQ5JTo2u1qjdl1O1DVHOppd4anINtT8y4JIelwASH1wePHovhQy5S8mrYyZd
         UMkA==
X-Gm-Message-State: AOJu0YwGSxdVsmMWTaYX2E6wqH2di22X9dNTqHoYujpmM7PZZIptTQJk
	8A74D+TSDLNtajXiHrEUpm5OQ/+iYxN9S+p4djw=
X-Google-Smtp-Source: AGHT+IF8p1LuTV4Z7cYDNFOYhYTinKbuj7AVx4nc7X9tNQZkyEJtkxXHEbQAp3XO7hfv3Pmf67iQbUWSKzOhvTiWuIw=
X-Received: by 2002:a25:aaa9:0:b0:d9a:c61e:4466 with SMTP id
 t38-20020a25aaa9000000b00d9ac61e4466mr10600798ybi.61.1698099364644; Mon, 23
 Oct 2023 15:16:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231023174449.251550-1-ojeda@kernel.org> <20231023174449.251550-3-ojeda@kernel.org>
 <f53536ca-ec5b-4cdc-a340-e9c739ee30c4@gmail.com>
In-Reply-To: <f53536ca-ec5b-4cdc-a340-e9c739ee30c4@gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 24 Oct 2023 00:15:53 +0200
Message-ID: <CANiq72nTE_qua9w+EeqiPCukst4876Gi7gHeusFLofYZRoJCDw@mail.gmail.com>
Subject: Re: [PATCH 3/4] x86/rust: depend on !RETHUNK
To: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, x86@kernel.org, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 23, 2023 at 8:43=E2=80=AFPM Martin Rodriguez Reboredo
<yakoyoku@gmail.com> wrote:
>
> I'll mention that I've tested boots, both in bare metal and QEMU, with
> `RUST=3Dy` and `RETHUNK=3Dy` and they were alright regardless of `objtool=
`
> warnings. Although, if you had an issue in the past then I'd like to know
> about it.

These are mitigations -- things do functionally work if they are not
applied, but you would be vulnerable.

In other words, it is not like e.g. IBT where you could have noticed
it breaking by running it normally if you happened to have a supported
platform.

Cheers,
Miguel
