Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69C184290A
	for <patches@lists.linux.dev>; Wed, 18 Oct 2023 21:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PAYUtP0y"
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-5a86b6391e9so49870207b3.0
        for <patches@lists.linux.dev>; Wed, 18 Oct 2023 14:05:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697663149; x=1698267949; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cXgwpoEmQGe1TS0FZv1gFNd3LQ65wOIduIw3gMeeQsU=;
        b=PAYUtP0ygCZbxb0ZnCwGFCtlb44ftUfRTqm/hmKmtAT2fEs80d0t/30vCOqNeEEWhE
         SpfNmGjrF0rHqAPgV1DF/qMhHt9+cSe1KmaQkaF247qkQAbQ2t2+MLsHUN0Bp1iFBjBe
         7+jU0Fn6hGk7eOMJJ2/DK46JCdUV1HpzVHZwdKpV+vuxkgskcY2lmBSjEVnoTBK5BLts
         DtWvjMS+uBQP8SS5TlMUvDNAQT1QlFyx/tIJSKtEC9os02KqYMUn84mAsagp19APVm+n
         rQYEg4MrEFl4jT5OwnaWwd2lrD7BLACTLYgAZjs7TkIDNrDFr6F1nB5x/R4SZGBPZbMx
         65dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697663149; x=1698267949;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cXgwpoEmQGe1TS0FZv1gFNd3LQ65wOIduIw3gMeeQsU=;
        b=V0FIrxlkRQSgI6/blP/PGBi3iSrroym7VJsuMPx7d3/NLzmoMj3SXK04jlgFROUbeG
         SpJ3CfcQDeV7Q3RbN59Q7dbCLJJuN7TljTAe0k8U5Kg/pBz5geO0XqIF47FtYO4C0gMO
         ujHi2RBs+cZTqZUu8gcHIqcY8jfv0MBlqkIrDSLeA78cFgPakq09XNgzanJxDWGDmrOH
         LYhDtGPFE0bOw53YVHVMMTPGl5FlojH27jRfX61Xt4bD7Xiza/sSs2eA7nGmSwWKQ3eS
         XAOwnV+c9bNFJ+ry1iNXFChycLQGhzZ0ISJKu3OHpIcROPD+ECUjmXQywwWd70IIgSyw
         Yiww==
X-Gm-Message-State: AOJu0Yy5dOL80TX1Ln2qS1A7jD59gk9/zw97vXP7keumldQlZD4A2TQr
	zmCeIdCq2vyXJFzHCixb5IoLUV8OxNpE4h+THNE=
X-Google-Smtp-Source: AGHT+IGcIykGrNxI2WdLHRb+V3eXK86nmXV/VsdlJY1JvwzKBV7IrtCvoDXzBglo1nYM4Mc9IH/xMBMekjcxEFHS5bo=
X-Received: by 2002:a81:b40e:0:b0:59b:c6a4:15c7 with SMTP id
 h14-20020a81b40e000000b0059bc6a415c7mr406578ywi.46.1697663149202; Wed, 18 Oct
 2023 14:05:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231018160922.1018962-1-ojeda@kernel.org> <d47553f1-1832-4c69-8a8c-71c58048ff30@lunn.ch>
 <CANiq72=E7TPLcq-yiQF9E8a33ghbogPcbv-yMqFKBxMQ0oOxNQ@mail.gmail.com>
In-Reply-To: <CANiq72=E7TPLcq-yiQF9E8a33ghbogPcbv-yMqFKBxMQ0oOxNQ@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 18 Oct 2023 23:05:37 +0200
Message-ID: <CANiq72nmtkupLXiCVyTivS2QL_UeXu5y5g=JBra6Wik1a7E5dA@mail.gmail.com>
Subject: Re: [PATCH] docs: rust: add "The Rust experiment" section
To: Andrew Lunn <andrew@lunn.ch>
Cc: Miguel Ojeda <ojeda@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, linux-doc@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 18, 2023 at 6:41=E2=80=AFPM Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
>
> We can add a note to the Kconfig symbol too -- would that be OK with you?

Or do you mean you think the Quick Start guide would be a better place
given that is perhaps more likely to be read by end users that want to
just compile the kernel?

If so, I am happy to move it there.

Cheers,
Miguel
