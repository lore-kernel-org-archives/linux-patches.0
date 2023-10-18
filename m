Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com [209.85.219.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C77573D382
	for <patches@lists.linux.dev>; Wed, 18 Oct 2023 16:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nIuNmSZW"
Received: by mail-yb1-f179.google.com with SMTP id 3f1490d57ef6-d9a7a3e17d1so8240467276.2
        for <patches@lists.linux.dev>; Wed, 18 Oct 2023 09:36:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697646996; x=1698251796; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=muPYN+h5m0NQxmc9aOMQOWiJMXRbZ7xmKLB8WJtuUBM=;
        b=nIuNmSZWs1S6abW0OHaZicxZOPAQNmQIxDcbnW8lQi4w85UFNf051hxj93pgff5J7t
         gHH3ap8tcpG4fXWg31JqlCmmjDgJhdw7RFrJ0Fr0Z9m+tZa41Lh3bsorFvwoqSRU17Nu
         o1YcHLPxhXezM24q8REFoJJYDAa9wXnP5vJ61RTiW5IrqV8Pqb3ltqlC/VMjNS7VR/8g
         cPcZKN0Ma/8RMykCWdoHFJtudP7H4sOk54n1i4nOO6QsGNI6hr+ozJ/e4kAR0tJxRhIP
         kDsJMGpzwq8IQxLwq+unJ4yTKp3k7prWsmiWR2JT7PCq9xl5kUUnVN6zUXPrRNiY7HJN
         j+qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697646996; x=1698251796;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=muPYN+h5m0NQxmc9aOMQOWiJMXRbZ7xmKLB8WJtuUBM=;
        b=TA2gtpbv6eK5FHdB9Rc5RLrPWRLUbMi4ckF49qThAtIItAc8uSf8USyVvyrue3XKKv
         ceaxGODPxyElgaVhDQNQ/2kMSwv9a5/nmgHNDsNYYH9N0SGeBDOnkKTw6avf4btNEgy3
         udtChfxvF4gO0Zb/Oto89YskUq+oHpdEnVm3z7zNdMFdIsM6iuyikHnFGoMeI0BY9TS3
         iHXsGb8BTIPS51VdhiWpFHfZuLqajYGoCxAyUOWH7R6TFejYUsKfRpCT/pExh72vSG0w
         MWrvVYca3Ud7bz5Szx+fxbITGaEpDq2aLf/7ghDKyzPTZoUzubg/ygduWS2gPT1u4qH5
         C+fw==
X-Gm-Message-State: AOJu0Yy3LbYyYuEkD3cSpGZHy5gOrSRTDUIL/I7W2ig/T2CZqzyz742T
	iTAo7EnUUWHRetZpBJe/TswUw6exEGiEINskSXM=
X-Google-Smtp-Source: AGHT+IFN2ShsAR/vt4lfDeqB/Tiw89GrzRBQZEOB9gpbxR7f/kvg0uhlf4ib/npOczI8Rxj7dDdnVfkQ1znwcC9kr4Y=
X-Received: by 2002:a25:ab2d:0:b0:d81:754a:7cb8 with SMTP id
 u42-20020a25ab2d000000b00d81754a7cb8mr5743619ybi.65.1697646996757; Wed, 18
 Oct 2023 09:36:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231018155527.1015059-1-ojeda@kernel.org>
In-Reply-To: <20231018155527.1015059-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 18 Oct 2023 18:36:25 +0200
Message-ID: <CANiq72=bEcVgwJ=Cyps1q09V0LYfooizR69fKJxswm=S=_FXhg@mail.gmail.com>
Subject: Re: [PATCH] rust: docs: fix logo replacement
To: Miguel Ojeda <ojeda@kernel.org>, Masahiro Yamada <masahiroy@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, stable@vger.kernel.org, 
	Linux Doc Mailing List <linux-doc@vger.kernel.org>, 
	Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 18, 2023 at 5:55=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> Thus update it to have the Linux logo again in the output.

Cc'ing docs and kbuild, by the way, in case they want to take a look.

Cheers,
Miguel
