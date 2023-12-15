Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5400BEC9
	for <patches@lists.linux.dev>; Fri, 15 Dec 2023 02:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eS4gLx16"
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-3b9fcb3223dso215717b6e.3
        for <patches@lists.linux.dev>; Thu, 14 Dec 2023 18:58:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702609096; x=1703213896; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dEuYNRBlgzXCt6dLMDXZjmgpWHVvzha3MPNxQgSpSX0=;
        b=eS4gLx16E3XbSWLhDRtbnmJAWf70l255t2YmVN1tkMrmIOEbjH2uNeK+0RAmVIATSx
         XTWpClWWzvC0lqREfoVAN3MlY74pDga11p7HEh1XIJy6M0nsGCs4D1xa1agQt2bxni2J
         kdjuAoBG9c4q2cKNl1cZpExdGIqt3+MEWmg1c6zexU9RIYatzA6poDg5b6SlGAYm1X6o
         UAUJdNaW59tO7PsAACClMcBk0vTO0YM+p09eN0G4ytZRq5XiTC/sgD2hu92F3rk4DvP6
         l7gXwFOU5ult+qxviahR9VGSCQCRNvHatoOPFqhpnjgM7PC6Qmf0p6r0tjneMhAgEIQe
         WatQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702609096; x=1703213896;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dEuYNRBlgzXCt6dLMDXZjmgpWHVvzha3MPNxQgSpSX0=;
        b=WAZSTnvs1RgniO5pLpZ2X79XhiaTEsElrefpn1KH43BarBFt6/RljQwXPE0bQ6F0KR
         rwaStFUwqImuX00Xfdq8K+ha7x8Mwm99LZpFC/yOEoJ3U3a4OfWO8FRrzZroUxC2VJpL
         T294ApZ6FgOzR9PnoWxSZghBtfTRx8Dj7nNhm0PbM/zYyb5GYU4oW3sBAlK//o9uKd2r
         Mwh1j856Rwmn12Wr+T2jR3bBn34jvCuPAle9jRWHhdX9zl0Ua8Hr1DsZszUQCYcTHbZ/
         7gfj25LnvIypTpjf5mMTItx+Em6RMF99cEFD+CEderUt9Ky+dMroFCr11sD6W2kXU7Nh
         H+jA==
X-Gm-Message-State: AOJu0YziVuCu9BpdYVlRidFujFYUA7E3fezXrGOkdeHKwE1rxud3WcT8
	P1ZA5R7tGsQLKibZwVeJuys=
X-Google-Smtp-Source: AGHT+IGda2uOu7tUCWI6/kdPBjVtdx5P6FD+g5ouxNnOF4IFpNT0gSRZmMn/eMLi7lrKD9L6eqauNA==
X-Received: by 2002:a05:6808:eca:b0:3b8:b6f6:4f8e with SMTP id q10-20020a0568080eca00b003b8b6f64f8emr11950143oiv.65.1702609096352;
        Thu, 14 Dec 2023 18:58:16 -0800 (PST)
Received: from [192.168.54.90] (static.220.238.itcsa.net. [190.15.220.238])
        by smtp.gmail.com with ESMTPSA id i11-20020a170902c94b00b001d359db2370sm3143684pla.152.2023.12.14.18.58.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Dec 2023 18:58:15 -0800 (PST)
Message-ID: <f09fa249-1425-429f-8f16-e95fb2d2cac3@gmail.com>
Date: Thu, 14 Dec 2023 23:58:10 -0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] kbuild: rust: add `rustupoverride` target
Content-Language: en-US
To: Miguel Ojeda <ojeda@kernel.org>, Masahiro Yamada <masahiroy@kernel.org>,
 Wedson Almeida Filho <wedsonaf@gmail.com>,
 Alex Gaynor <alex.gaynor@gmail.com>
Cc: Nathan Chancellor <nathan@kernel.org>,
 Nick Desaulniers <ndesaulniers@google.com>,
 Nicolas Schier <nicolas@fjasle.eu>, Boqun Feng <boqun.feng@gmail.com>,
 Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, Benno Lossin <benno.lossin@proton.me>,
 Andreas Hindborg <a.hindborg@samsung.com>, Alice Ryhl
 <aliceryhl@google.com>, linux-kbuild@vger.kernel.org,
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
References: <20231214222253.116734-1-ojeda@kernel.org>
From: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
In-Reply-To: <20231214222253.116734-1-ojeda@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/14/23 19:22, Miguel Ojeda wrote:
> When setting up the Rust support via `rustup`, one may use an override
> in order to select the right version of the Rust toolchain.
> 
> The current instructions at Documentation/rust/quick-start.rst assume
> one is using an in-tree kernel build (i.e. no `O=`) [1]. We would like
> to provide also the way to do so for `O=` builds, but ideally in a way
> that keeps the one-liner copy-pastable and without duplication [2].
> 
> Thus provide a new Make target, `rustupoverride`, that sets it up for
> the user given their build options/variables.
> 
> Link: https://lore.kernel.org/rust-for-linux/20231207084846.faset66xzuoyvdlg@vireshk-i7/ [1]
> Link: https://lore.kernel.org/rust-for-linux/CANiq72=mvca8PXoxwzSao+QFbAHDCecSKCDtV+ffd+YgZNFaww@mail.gmail.com/ [2]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
> [...]
Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
