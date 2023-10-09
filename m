Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C3494420
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 08:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fg6bWJuX"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-504a7f9204eso5082811e87.3
        for <patches@lists.linux.dev>; Mon, 09 Oct 2023 01:48:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696841327; x=1697446127; darn=lists.linux.dev;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wgoMovMkZSAvfqa8PGZ/v+zEqtovHRzU+CUakuAURFw=;
        b=Fg6bWJuXwLPDsYqOKm7QEuTtUvCKxyEerNypIn4qtg4tf2AwVTeWOpUKTVh2j/nb2B
         Y9cmE8/gvvppvfj5Wr/DXcTqE5MQqeha3OInfKGBSiVl+Vj380UkCzqrzSK1iEW4vttF
         lKOgu+6/L8EdYIqBlYoi/qSqcKPjt+5l4MwiTpFHFFoVcmYgeSm9spwosiK8JF9HiQHF
         D93JE0KhT3j4Ic9nDBg/Ou83gPIs/p25od5YpOqdCVyq/DH1hGClQAD0h0rfCv2+YP8D
         tjAxlvcl9bZWe35dF1C8Fz80LjkFOPewHWOvNnCjCMcIH/V1f/AFmo5PpIzve1557OJE
         Uztw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696841327; x=1697446127;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=wgoMovMkZSAvfqa8PGZ/v+zEqtovHRzU+CUakuAURFw=;
        b=T/J/jqxgH2b4hqf00LFq/ZxNkFrGeijUnmli75TRwPhzsYCabEduB1fySVm6URkc3B
         kXsruZU1NPeBEkH//AmbuVJ/crOkzlvw0P8ThSxzsrN9DjuP0KfxQCjd4s7gAstQAIBj
         oOlG8eAESYeuXT66dbO2fWXuY3HHpJXvGy9PJYk91WzJeYolaq44df1TNiirLZVCeAqc
         7pE+2bOqx3BRd9bLM+2PQQlZ9cprvRncrJ/2KaBIfrnH3DcvNCTvr+uiS9RJDuzMylVF
         3dRK92WM1ZU7cbdzF9roBzSgH2h8mIlF5JTwT+RuiGgQxIdneV2bEf+pHVaEz/mkLgfC
         hQIg==
X-Gm-Message-State: AOJu0Yzbxy8UTkQgAF+DNqtDdgzRefuH0fqI8tKz82lg9wfx7gWBQEs7
	RVeBxLGPiMytt9+X2luLCJh55zGF2yDc7RNq
X-Google-Smtp-Source: AGHT+IHhcU61xBBMKUOeAY+GkinxHfngiCQlhzFkKDaovUc9VGDTf0uGVwn3pv1PsqFdx4nfWpAV0Q==
X-Received: by 2002:a19:8c48:0:b0:504:3a7c:66ce with SMTP id i8-20020a198c48000000b005043a7c66cemr10896001lfj.68.1696841327347;
        Mon, 09 Oct 2023 01:48:47 -0700 (PDT)
Received: from localhost ([146.70.182.19])
        by smtp.gmail.com with ESMTPSA id y2-20020a197502000000b0050467be30ccsm1361737lfe.89.2023.10.09.01.48.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Oct 2023 01:48:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 09 Oct 2023 10:48:45 +0200
Message-Id: <CW3S1RNMMQKE.3DP29TLAE53AD@gmail.com>
To: "Miguel Ojeda" <ojeda@kernel.org>, "Wedson Almeida Filho"
 <wedsonaf@gmail.com>, "Alex Gaynor" <alex.gaynor@gmail.com>
Cc: "Boqun Feng" <boqun.feng@gmail.com>, "Gary Guo" <gary@garyguo.net>,
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, "Benno Lossin"
 <benno.lossin@proton.me>, "Andreas Hindborg" <a.hindborg@samsung.com>,
 "Alice Ryhl" <aliceryhl@google.com>, <rust-for-linux@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: Re: [PATCH 2/3] rust: print: use explicit link in documentation
From: "Vincenzo Palazzo" <vincenzopalazzodev@gmail.com>
X-Mailer: aerc 0.15.2-211-g37d5fc691aff
References: <20231005210556.466856-1-ojeda@kernel.org>
 <20231005210556.466856-3-ojeda@kernel.org>
In-Reply-To: <20231005210556.466856-3-ojeda@kernel.org>

> The future `rustdoc` in the Rust 1.73.0 upgrade requires an explicit
> link for `pr_info!`:
>
>     error: unresolved link to `pr_info`
>        --> rust/kernel/print.rs:395:63
>         |
>     395 | /// Use only when continuing a previous `pr_*!` macro (e.g. [`p=
r_info!`]).
>         |                                                               ^=
^^^^^^^ no item named `pr_info` in scope
>         |
>         =3D note: `macro_rules` named `pr_info` exists in this crate, but=
 it is not in scope at this link's location
>         =3D note: `-D rustdoc::broken-intra-doc-links` implied by `-D war=
nings`
>
> Thus do so to avoid a broken link while upgrading.
>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
Reviewed-by: Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
