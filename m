Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1AAA12B8B
	for <patches@lists.linux.dev>; Sat, 16 Sep 2023 10:53:11 +0000 (UTC)
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-31dca134c83so2936560f8f.3
        for <patches@lists.linux.dev>; Sat, 16 Sep 2023 03:53:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1694861590; x=1695466390; darn=lists.linux.dev;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E6++5ofz/XVp0r1sKsCzLslu6+YsvGovl/0af+/t0Io=;
        b=mFUvLYsWWazgnKHVl/GoyBnpL52xACK0CqSf7zLX9WXY20qwC67ElzxI37F0FMRiIP
         R8Wl0Na/lFCua0MI6FZuQNQ2bjdloX9YOG0/dAWfNVL4cdhuGNOIIqnCJyA5QaOIeG3+
         a4n5GYuVtRZPiH9+j//Zf7d9j/OUR+EUVuO3dXQ4cBW73mbsQCoygurSiW9FLTiBwjEm
         I9M2Oel13HS6/yBocdYSJ47NvloERUGXAToCzSuOvkQ8iflIy5TLLb+vMwYvknnolpSU
         R7S2kMBVp/UpkncC3mU07ryEvhObzxZvSOBkHsFQ+FvH1p7bXN5weHw5s5R/eGjf5nAP
         8jdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694861590; x=1695466390;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=E6++5ofz/XVp0r1sKsCzLslu6+YsvGovl/0af+/t0Io=;
        b=UgWgMA+tAm1Qpw9r0/GsHJyCVsAbfIni6CovFi22sNSstmgaW8zrfsbLp8A6D0SyBi
         1Kvv3a03AzL0GwgWHA9IRVrLNWk3XIfcHT/PvOLwy5cAjqyXtm8LOfDoogYWRu2fbebA
         EwyULm8HsODo35/seXFOACDokuRX+ZOhX33ghsy14QHGa2wupgcLuxCAjCVXldqxABQ3
         x1bGerzEaaOKM2Lyg4JVIueS0GvwHqcq0jC35c3xTKoscwadWEJihxpOQef1DafvQ2dT
         JML5TLZ5H0YCAk1nDavgt+6S1aFj5KJPLq3gn3CFkIAWxM9K45DCDmLCXn1icAHXfHu0
         JSaQ==
X-Gm-Message-State: AOJu0YykYISaHOAlE6/JUg76xbxHR1Fvr0GirpuvBgS6y5IbUAMR/fhL
	xf8mh/BcpVVqmr/GuJ/Yt/Y=
X-Google-Smtp-Source: AGHT+IE9iYdti2ESeNV0y7KhQoMbN+Ztv4NNyQYjs2YsSmiRyiYMcX7eVbsM8hDYzjaHn3x5C/E4cg==
X-Received: by 2002:adf:f34f:0:b0:317:e1fb:d57b with SMTP id e15-20020adff34f000000b00317e1fbd57bmr3282990wrp.56.1694861589528;
        Sat, 16 Sep 2023 03:53:09 -0700 (PDT)
Received: from localhost ([45.134.213.210])
        by smtp.gmail.com with ESMTPSA id t3-20020a5d5343000000b00317ab75748bsm6852110wrv.49.2023.09.16.03.53.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Sep 2023 03:53:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 16 Sep 2023 12:53:08 +0200
Message-Id: <CVKAAGQ6QV0W.3LCCSR4PNZKDC@vincent-arch>
To: "Miguel Ojeda" <ojeda@kernel.org>, "Wedson Almeida Filho"
 <wedsonaf@gmail.com>, "Alex Gaynor" <alex.gaynor@gmail.com>
Cc: "Boqun Feng" <boqun.feng@gmail.com>, "Gary Guo" <gary@garyguo.net>,
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, "Benno Lossin"
 <benno.lossin@proton.me>, "Andreas Hindborg" <a.hindborg@samsung.com>,
 "Alice Ryhl" <aliceryhl@google.com>, <rust-for-linux@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: Re: [PATCH 2/2] MAINTAINERS: add Maintainer Entry Profile field for
 Rust
From: "Vincenzo Palazzo" <vincenzopalazzodev@gmail.com>
References: <20230830165949.127475-1-ojeda@kernel.org>
 <20230830165949.127475-2-ojeda@kernel.org>
In-Reply-To: <20230830165949.127475-2-ojeda@kernel.org>

> The `P:` field allows a URI, and we have been adding information
> on how to contribute to the Rust subsystem to our webpage for a
> while now (and other relevant topics, e.g. branches, third-party
> crates, Rust unstable features...).
>
> The webpage/document does not currently follow the headings of
> the Maintainer Entry Profile, but it does nevertheless answer
> some of the questions we have got so far from contributors and
> it covers partially some of the topics there.
>
> Thus link to our "Contributing" document [1].
>
> Link: https://rust-for-linux.com/contributing [1]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
