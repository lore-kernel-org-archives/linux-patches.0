Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9069F1B0414
	for <patches@lists.linux.dev>; Sun, 12 Jan 2025 14:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736693237; cv=none; b=u8QPkYGX8lKAUSkZFWcoTE5HKBwc/sf9sfD+FanClraOjJd05MgLXUJhlBVheCmrBTUAS/ItrrxgQa7PfG/0DUm0SgAb07hscGVKZ/VRotDeNY7BtUiKvGO4gPRHH+0GOk2rfmF5GsWlVR/Fhz08fPEf9nT26xsClEcd17qGnBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736693237; c=relaxed/simple;
	bh=sYm+b6a271AERSbamgy9m3KH0LP8SVZIjMoiBZbQjuA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ff7PG/MOP6S+f92yenw010qc/pHCBgDPBIZvhTcfmVhwx/G0EhNxzwwVIxbAB1ZmM42TIPo6xp2S30K2dnnJyfakTBPppRp+ul/Xl0S4RPd43Q0koA3Hrbj3cqDsz4isTxlxz6XIXr77Jlz9x86Dlo4YfdLJUTsoPdwWzjuryqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Lpgy1MD/; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lpgy1MD/"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-2ee534d6800so820939a91.2
        for <patches@lists.linux.dev>; Sun, 12 Jan 2025 06:47:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736693236; x=1737298036; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tE4fq4FFdl3mipmmIEQXBMJ+EXT6JLW50zf6NtrgmJg=;
        b=Lpgy1MD/tz4miqRe7pgWntDA0CGPJ/j/4Qjh89upg7cUu3azknJZ5ogytgowfD4+9f
         W18AXr9zZzqz3tOsku9Egj0sUM/v4l3vzFT228u14GcZjiJ6flfYL2GPQRj4yEMM8Ir+
         TrxQLNNq39XL12ujAkNUZ9hKQi0yidbDy8PPr6mcV+LNBkw8Ofrt6K1aq/nqM4Wk5YYA
         c4iVaNBwy1++C84FtBtrVPaKwgouq2d6D3W3NRIV3qkJLtMFpD+rYWLJszylFr68cY9C
         ttskNBao9zeNMF38edsjTdCo01kO1qI6i8RjxAAe1zM/AYBSHmJAKc8754hM2MpZ2TzQ
         NjIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736693236; x=1737298036;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tE4fq4FFdl3mipmmIEQXBMJ+EXT6JLW50zf6NtrgmJg=;
        b=v3nHHz5tRf/dax3MdOBE2Jpm+UBLsc1Y5Fb2H+8EW1Q2vMNdEAqwtIPZg9sDmtQ0v1
         o+e8mSR8GzCM3eZhdVY3EQEjVgpqIXrXq8duvBYKnIDjnobzJIfVZBaoAUPU7U469nIE
         nIbzR14LbKmYlRlsPow4Z2E9iZM7GZ2U1OQQu3oCHuwcXLAA5QQfq6IdQn6sw0K8YUh3
         25hrZvzjAHIW+MaHE9vGzeC0RTFgYLez5EES1IqU8qBK7Uk7ErCysADPVJCg+irLtjca
         WNmeaCxx4GQ8SEah4n6GD9HyKQMDAi4VfCE5aQSmxktL3dg7iSLzz+MikYnON/jzAolV
         ny9g==
X-Forwarded-Encrypted: i=1; AJvYcCUZChEsYAQF9QnlR2PYFg2I1+eqfatqOcuvBiMzniB/JITAJzP7C89xYiqRFdEhAsUMDzXuF0Rn@lists.linux.dev
X-Gm-Message-State: AOJu0Yx7vZhr6j0sdnxy9IYqT7g3eoUcagIZSKmHIFdO2EVctT62lEAX
	+z4E3NpAkp/8DA2grzzEB6l0zpipt9t2nqYfR85eGnAokmMNVg88XsvYMiG2ref+X263gImMMO5
	Az0Jx9ovs7b1+MmU1oQQntQC9ycQ=
X-Gm-Gg: ASbGncv9fr6oRQbfcRpMaWqqLdOd963Vut01yKyoNrwNrZ0cB8d+n0Eq0y2Ad+nJwUv
	tEX0pwDbKf4QTYQ/W6JmpEWXHgAfsskjWSL9jLA==
X-Google-Smtp-Source: AGHT+IEuRenyy2o5QaqN4nyEdk23ezwMIoLC8nom6dD09a6ALhzLdfeY6rB4+NUxuJMQ9fOJvDAxJPuyDUEO3F9KwNE=
X-Received: by 2002:a17:902:ec90:b0:216:30f9:93db with SMTP id
 d9443c01a7336-21a83da3f36mr97531635ad.0.1736693235892; Sun, 12 Jan 2025
 06:47:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250112143951.751139-1-ojeda@kernel.org>
In-Reply-To: <20250112143951.751139-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sun, 12 Jan 2025 15:47:03 +0100
X-Gm-Features: AbW1kvbzYm7hp8g_4DWQtGhIwWcoM5284oJgC7S23IarUKB-GcORr_DyMpUCpfA
Message-ID: <CANiq72m=O6LHrj03nTLEtn6wqxe-4ra3UNxV6eUXOQOAW58Rsg@mail.gmail.com>
Subject: Re: [PATCH] objtool/rust: add one more `noreturn` Rust function
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 12, 2025 at 3:40=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> See commit 56d680dd23c3 ("objtool/rust: list `noreturn` Rust functions")
> for more details.
>
> Cc: <stable@vger.kernel.org> # Needed in 6.12.y only (Rust is pinned in o=
lder LTSs).

Greg/Sasha: I didn't add a Fixes since it is not really a "fix" for
that commit, but if you want it for automation please feel free to add
it:

    Fixes: 56d680dd23c3 ("objtool/rust: list `noreturn` Rust functions")

> +              strstr(func->name, "_4core9panicking13assert_failed")     =
                               ||
>                strstr(func->name, "_4core9panicking11panic_const24panic_c=
onst_")                        ||

Nit: I should have probably put it after this one to keep it sorted.

objtool: happy to take this through the Rust tree or not, as you
prefer -- it is not urgent.

Thanks!

Cheers,
Miguel
