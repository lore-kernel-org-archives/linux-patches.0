Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39FAA212F8F;
	Fri, 28 Mar 2025 08:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743149980; cv=none; b=dQIzMqQkpA+oEIcvI69KoxUwhpZhrZlLrLp0+bstux4gZFv3/uhc/b1LjgMvoFj7SYiEAmcpocZP4L6PsDSHjDFUPZdLgy8Le0fzQBqc8Bn6SY+YQzPVwz7mGmn/TMjR3unjKWoffoXBTmXypo+PdTxtPDVa7UPPTNdfRnkXPF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743149980; c=relaxed/simple;
	bh=dG8Kk5eXzvdbp81i+MgQHGycYLnKTqRZKMJ2FxelLk8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tVdowRLkZ2DabidmrLbvp/fcpQfXtdDA+WziUjveoQUS9RklW57iP7bUlgqlcqT2t1SOyY8bploaF+AuTw6XKGEGhyprc5DZ0OW920iIjPjFIh9/SKVsYDklKyzD6A9MePdX5TDZHCU2kef3I5ABI5fQGjjihf7slvtyRvYFsfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VhiBO6tb; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VhiBO6tb"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2264aefc3b5so4725895ad.0;
        Fri, 28 Mar 2025 01:19:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743149978; x=1743754778; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g9unC9bRNCOdbQsHq9ldD0TFRGSKuPU7FMP0NBYOBHc=;
        b=VhiBO6tbGimigUS8JblQ0Y3SFCqrGFdonY8UfEUJM37HCMRFMgZgiBbPOfWIlXgaJX
         kA0lnw15l0fKfrWoqLNAZLw/rBdrksLqNJUaYRgN1W1hJucm3dxobEMwTHJHaZFqJyQP
         ZT4Lm4SgUHpmh+9AhjZoYKTG2cNXgnQA+8KYjPxFhSbWGSEq9KehKhY3dQkDJYNe7NJD
         m22+20OdsR8WcVpNwNTw2EycecpAVzRdeAKXyakN2u2MgItEO++3EP0XHLPrVxig8UXU
         pGT9kjpqNmTVWHYC3HGTkTde6hlWKKTkc2AID4cROyC9LQwmd/aoBn6lQ3eRbL2Z0XbO
         vUpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743149978; x=1743754778;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g9unC9bRNCOdbQsHq9ldD0TFRGSKuPU7FMP0NBYOBHc=;
        b=iQVuQLXa8R/nRGCtTfGnyDblbneTtCW4mu6Joue6maoSaTGETIMMTgcAcbkS1yAeqC
         hTBUkfqTmImHk9X+6OJIgh6+C/xrjs5TgqD37hUDAYP3xG+xrjSB8OfaY2Uy3KnFqw93
         /7xSx34me1dvVGZeIEP4e/NV82NGg118yFu31HyZapLV4rVsFmaWHJW5GVMVCa2tl7rB
         0vPIU5C58AA26uL05mlxWNkt9kgHAN0tqh51WBuTTRZVAqZx/m+TeLKS1hX4Llubb6YA
         UBYObBxwekdO9tlIYWf2G2VsepiF6cptmtT2sqR8k5GkqFCmkq9v2T9fTHIBmQbZBiKt
         4dhg==
X-Forwarded-Encrypted: i=1; AJvYcCW1ZO+aFU7REJfsxLm8VZrdkFKy4Eq1pdQJOkiqGoiQRNZk7gb3T5T3p3zWcGDsUEasCEbL8sP7aw==@lists.linux.dev, AJvYcCXlfeIZJ/V09cI4JQTwgsrBlwwiqmfBqJhobwMQc0raLzP21wi6Ks917L5wajQS5jj3f08LHQQtI4ddtQLX@lists.linux.dev
X-Gm-Message-State: AOJu0YzCkKmyBEgFx2B/BCsFgQ8Kw4nf5PpfrZYLoutmkuguPOEie0go
	0E1Z08zCDcAwDy9ok3aEraMa+tBcMMn/6ydaWiceDpn7IU+atByuH1d1IYATw20Yh5N00eYiNKP
	tzV39taRoAFhuTcPt761CF/DnzOM=
X-Gm-Gg: ASbGnct2YkugZwnhUdjVkUlaYprCS9TRmUz+xxYPuJHCT3CDvy32eISAS53nfcYNP2g
	65yPAd6YfQdPLhwLLsg+KjuWE+cc9yFj9uFt64ujNyOCjyDsSXZ/pr45TeoTQdsLrYY5KQ+j85m
	blQkSdplDgSTGOZXze+/oml5IV+g==
X-Google-Smtp-Source: AGHT+IF0//qcBT07gmUhcVUDFpY/xo2mTXg5BmPOxNGcp0uk0KKm0Mli050rUH/yXJPkHTE2qILIWhXLdoGYB2AUjwA=
X-Received: by 2002:a17:903:192:b0:215:3862:603a with SMTP id
 d9443c01a7336-22806909490mr36453705ad.10.1743149978273; Fri, 28 Mar 2025
 01:19:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250327211302.286313-1-ojeda@kernel.org> <202503280805.Oq84ECdB-lkp@intel.com>
In-Reply-To: <202503280805.Oq84ECdB-lkp@intel.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Fri, 28 Mar 2025 09:19:25 +0100
X-Gm-Features: AQ5f1Jp5M1SVPjlM3lBMbr_cReSlOrVe1dKVs1dHDt1dHT-S8Pb1bd9lKvRUvJk
Message-ID: <CANiq72ngUCVnYT9rQ9+ebTfTOUv7zuhJduXDO=VRRZ4myT1iqA@mail.gmail.com>
Subject: Re: [PATCH] rust: clarify the language unstable features in use
To: kernel test robot <lkp@intel.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	oe-kbuild-all@lists.linux.dev, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 28, 2025 at 1:10=E2=80=AFAM kernel test robot <lkp@intel.com> w=
rote:
>
>    rustfmtcheck

I will replace the newlines with an empty `//`; otherwise it reads worse.

Most of these lines will go away in some months, so I don't think it
is worth diverging from the default even if `rustfmt` had a config for
this.

Cheers,
Miguel
