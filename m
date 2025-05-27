Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3CFB36D
	for <patches@lists.linux.dev>; Tue, 27 May 2025 00:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748304545; cv=none; b=m54o/T7M71vBHYfbU5tAz9UuUIzXSkbmVH/3atXtJ9GKGK8YtcbusX/gBp660brVWL9D5p+Cat6Hw/H9udAJbnFbb0H69wwvZgzVY5Koc9PZdk96XOfeo1tFWyS8LhE1g9bzY+Il4M8hpNPihBhk/GSTFtXP3Du1n86RdlcO2TI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748304545; c=relaxed/simple;
	bh=2rzQq5yLfjvOmTTYtmk60CDfVK8FMvHBMNx7m1BjYnI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=s3tgUPHJQ6S5pmpV20PNEyaHeLWtITT82dCNDFxd0bwLmPvhWV94eP3aOBZEdZ7mR8AWWn3tRIaXj/Y+ONx60d3XF10iFC6z8GfzIZdjTj+K013O1ydboy7Mnm5H9G7VNs2bBmOkuuJFfJxrPKn+X0GehVkjOrhZoFnlY5s7xXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZnU4JHC4; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZnU4JHC4"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-3108652400cso385645a91.1
        for <patches@lists.linux.dev>; Mon, 26 May 2025 17:09:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748304543; x=1748909343; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2rzQq5yLfjvOmTTYtmk60CDfVK8FMvHBMNx7m1BjYnI=;
        b=ZnU4JHC4ipb5qritSf2hXZ3qArvzaVkSvw58wK3IqZtTMaOwyBsgrd9aVdXNPEb5Vh
         7U2N9pUwI5s5ImE6fHiUlbFLXFuU2coY5RHPIKNQ7LUe+16zCgRZHUH8wWxlTk555+WJ
         whvwQEF/1znNUcYZY7gcmfT8BzemFOol2CUkcqT87mQft/LLs5gJv2h1oExUjt2zBV5S
         DHhPiRVariL1YjRZFrSY2ASyCIu65gOyl8tDMq1iBE/wBwCHWrOffO6NNaomuObB3iDw
         Da5R3aEdf6h3YLnYwvnUTFa8KdniSBsJwNJOMRYi3J+g1qXaAhIE2S0tALuos/7R1Um9
         /bEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748304543; x=1748909343;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2rzQq5yLfjvOmTTYtmk60CDfVK8FMvHBMNx7m1BjYnI=;
        b=nWDGCsE17H1KfXzTrEPH3n1blNMX9zSJGou/BOhmvp2wwtYfU1bkgcABmJc5lmS56F
         5pBgQry+VqQjubbJujr9cdhKuHE/CGLG+tjrS2jIZkOzLHK+9ibnl0IEuPD4kA9zsSvW
         qDSSQOaFYNH151SURYwyVhwixmIjVNfg8nlaIXZx90zeFo1h90DmjAogaDWJ/h+MeBav
         uCMSLNmmwwc8RYbSMesV1mnPie4JE9vF2+K1F+3jLNp5phDwG732/snxADLyxcdnQ2ne
         JGaZ21/XQspZK/r3rgVpudyvi+kcjmaOM1wMpIF48sPOn+dqP1X5KgxYJH04H/G1ydwq
         Um3w==
X-Forwarded-Encrypted: i=1; AJvYcCUIf729e/sBhvVqkyMTrBCiyPmXG9feFZuvXNSsOPEvFLSBnhD1lB2WQu9Qvi6NKXOFRNErKY9K@lists.linux.dev
X-Gm-Message-State: AOJu0Yw060YfXjdLYRu6tffypsUJm423iWzN/5YPVqdd1vPci9Aa9MH/
	53GRjqDIQSz8IrDfYMsKzsEBmZQeMq9jCYgYjvYi1TiChdO6OAftpRL2wgpaBEj/GqaxawaM9P7
	KX0pdSUrOiHJQ19FHaPaCHZT104RRDbU=
X-Gm-Gg: ASbGncuT/RwcZgg64eqZ61Q47RRD6QJNDDhw6AVZLlHi3N7FOpmG86Vsk0Jfgj7ZeS8
	60vXLXY3Rnh+LbatS7xjHPDZUhLaap/q2dia2kJj/xJaIldVylNHe8/OVGPxEyGIeItRxFcP374
	vEGC5if3L8tzGIluyopzNz3ZpTInlVp7iD
X-Google-Smtp-Source: AGHT+IHY6vduokEbcDZbsaJP+Df5U3wkP1/4ZR/q0IrJRApNtoX6odgNCZguNrzIkQpVmMEUhIC4NLmz4dpXZUFw1Hw=
X-Received: by 2002:a17:902:cf03:b0:21f:356:758f with SMTP id
 d9443c01a7336-23414f2f960mr66050825ad.3.1748304542991; Mon, 26 May 2025
 17:09:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250502215133.1923676-1-ojeda@kernel.org> <20250502215133.1923676-2-ojeda@kernel.org>
 <CABVgOSnTYwYtoMXCC-mUxV=A2quCrA+CD1Qe32n=qddxLKpcUw@mail.gmail.com>
In-Reply-To: <CABVgOSnTYwYtoMXCC-mUxV=A2quCrA+CD1Qe32n=qddxLKpcUw@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 27 May 2025 02:08:51 +0200
X-Gm-Features: AX0GCFuLlqQmhMR9CPFwVVMh5b02Mj0zAcZXwOB02-yOXPW14jBMHCFaWkavBk0
Message-ID: <CANiq72nhr24L-yKU8rFjCRTeY1yJ2FGNYP2RfmO=_+XgLgHFTw@mail.gmail.com>
Subject: Re: [PATCH 1/7] rust: kunit: support KUnit-mapped `assert!` macros in `#[test]`s
To: David Gow <davidgow@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Brendan Higgins <brendan.higgins@linux.dev>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Rae Moar <rmoar@google.com>, 
	linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 5, 2025 at 8:02=E2=80=AFAM David Gow <davidgow@google.com> wrot=
e:
>
> Nice! While I do think there may still be some cases where we might
> want to use KUnit-specific macros in the future (particularly if we
> have more complex, multithreaded test contexts), this is definitely
> better for most cases.
>
> I also managed to test it against the 1.88 nightly, and the message is
> looking good.
>
> Reviewed-by: David Gow <davidgow@google.com>

Thanks for all the feedback and for testing it, David! Very much appreciate=
d.

Given you were happy with this first version already and that others
want to use it soon, I did a few final minor tweaks and I am applying
it.

Cheers,
Miguel
