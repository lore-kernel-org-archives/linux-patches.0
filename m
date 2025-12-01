Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1286430F930
	for <patches@lists.linux.dev>; Mon,  1 Dec 2025 16:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764606736; cv=none; b=spxgSH/0hOfmS2asGgvmNsvgiGAME4fCnxyw7wxVn4H+AoJWh8FC1DX3mD0dS8YgSq4uVzNmPMXyaHeOlP00Qy9549gBPKW6LV5Qg1Is2ecAyeRsTy0mSHrgdAdUEs3NTrkimoMDsOcZrb+KKSI5/p55RhibJH6+sBPXVrjKhIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764606736; c=relaxed/simple;
	bh=sw6lbfdaMYOrwnUAK6JJqbnSFVu5NtCzD19L3bQZnvw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ca0Xq4dFywJq+regephLU6C8jwz95cn3jDT8FH5ziiGjYJXzpeJIr/Nbe02BM/+9UnH5/R7WlIY1v9HmqEfv28ukFMG1KP/bEtB3H8yoMmW1EvSawf/F1lS2dRm9wSBngrUaPk2QUw549TRyfk47n2h/w/1wE5Roo2jK2G1KjaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YQ+jTiOd; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YQ+jTiOd"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-bdd38966c74so112812a12.1
        for <patches@lists.linux.dev>; Mon, 01 Dec 2025 08:32:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764606734; x=1765211534; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sw6lbfdaMYOrwnUAK6JJqbnSFVu5NtCzD19L3bQZnvw=;
        b=YQ+jTiOd0K9an9A8UsCRPIpHLf1IpyWQV394rlXuDt9s5nFiMztPORQ0hdDIyhin34
         QeDn2hEyQb3CJUGDXTBYtaCOnuy/Wsu+fwcMRTHfsdxMATxGAMMpOfefX9RK6RTF6pdK
         z1H/ar6mRYwbzVayAChPD/eHtkHtDgdConuTB8UOw8S+vzSzYo3zNklmkMB1wGAEHYnS
         FWG4s452iHqTz//GyjOFwKFgISQ+8t7Juot14ooaQ8g+YDluffhnhnsri24Vkj4C8xuP
         HVn598J23osaVfx2rp2BrDGDDY9XaqI6bNw+gBGaUN+o8HaiZHggQBsk469Y1huIa/MT
         SJtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764606734; x=1765211534;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sw6lbfdaMYOrwnUAK6JJqbnSFVu5NtCzD19L3bQZnvw=;
        b=rF7uXx4GyQRU6eFpPVRrlxR6sBhhdYA6Kyy3RNfokUsw4BpZu1uzYcwhn5TXtiaeO6
         IstCEqN98IEsbFJS73pXWhtZ+PR9M6HaGP2kQ732ucUS4Z/bFv4wVPh1TsgmLk8gbt4C
         Dc2TvLYWlT5ieJb8jEavMPBmzEhk6I9VVOF3L6Xs0INrLiFRV0h3u7VO2+mKl34Onsj4
         NQ3Aj9oPqNf86QVjw9Q6u6D4jrniirmi6LIvhldzfemMlID4cLdzktD+Vi/+DGs+UV01
         b0kUhpxKEQ0whp+mFsMit4VgNgKJAGn7EQR4OcHwH+dpekQ8O6VgptKZwxPV1OLPfLoz
         O4Kw==
X-Forwarded-Encrypted: i=1; AJvYcCX6FE50GzbJLYfE4LRKofOftglnWiASwbmpFOPq9EqlycETBEYlypB3a1+aB/2Tggalg2YW/8VL@lists.linux.dev
X-Gm-Message-State: AOJu0YywbeSEZ366208p6J9/g5SNhrHt8q2xQFPqf6dRse/ynS5zgrFX
	eHXGBCP/hhZ+qu5HEVhTcGUQBJP5KiazvNcKksBn13e46llpYEt6xALJ0XSekYXzRrpmKBtuSIh
	mrmwTV5d5DnDu1WT45tyhoSPRYUd3qlQ=
X-Gm-Gg: ASbGncvskuoRAu0b7wohx2vSnKPH1ae5pmbtZlfNNflaj7Cb1s94EFAANb7NrcZrcrD
	WIHIWyrSCQVS84wpJ/CE3Nfh/QXkeA+pV7HQlgaJaLlf13QHE2rrrrkmhlp5yncKwXsq2/PsHir
	uqIZeal5FWNHxA/8xZDXAS97XewQp64PW3fp8l4EmIgzep6bYDBAkBtGiLTWyBcIUiFPhpLQq1e
	ROSVb1wdSq5ghmLbGY9Mbpuy8Bxy3kYV6ZhM21gMIldtYS0MCZ/xqIp5zOW1i7eq7Nyfyb47X3Z
	p5qCfW4pR2bgDEPWuKrQ1I+u2E+6xUlkj1Qfh0vLMUUqig8KFQT4ANu0KmKx58peK/yO1n+kFvF
	ua7QHrk5xQEcCPg==
X-Google-Smtp-Source: AGHT+IFSaSNSYsK9skLd9L3+GD87nHsBSTQ18ZktTY/G96pIsxF9X+6Kz0gUfJMhuXFXa1pntC2ut2LHSu9bZOjPBzc=
X-Received: by 2002:a05:7301:e24:b0:2a4:3593:2c07 with SMTP id
 5a478bee46e88-2a7243ec7b9mr21871944eec.0.1764606733811; Mon, 01 Dec 2025
 08:32:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251201021659.1729308-1-ojeda@kernel.org> <20251201091514.0bea544b@pumpkin>
In-Reply-To: <20251201091514.0bea544b@pumpkin>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 1 Dec 2025 17:32:00 +0100
X-Gm-Features: AWmQ_bkmIhVv2rJrH-FGssiwc-d63OARlmBA3UX_0DtxkLH5hJJvHYQu-4zaClg
Message-ID: <CANiq72nvzDmhDvFoOx5eyGGmHkpNyJSy-c9mZK4yu_fDKfeS9w@mail.gmail.com>
Subject: Re: `KSYM_NAME_LEN` strikes again
To: david laight <david.laight@runbox.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
	Nicolas Schier <nicolas@fjasle.eu>, linux-kbuild@vger.kernel.org, 
	Boqun Feng <boqun.feng@gmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
	=?UTF-8?Q?Sergio_Gonz=C3=A1lez_Collado?= <sergio.collado@gmail.com>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 1, 2025 at 10:15=E2=80=AFAM david laight <david.laight@runbox.c=
om> wrote:
>
> Given that is even more unreadable than a typical C++ name is it actually=
 worth printing?
> Looking at it, perhaps some of the inner <...> could be replaced with a h=
ash
> (possibly with the last real name added) with the ability to look up the =
hash
> in a separate table if needed.

For printing, yeah, parts could be skipped. But if we are looking into
replacing parts of the mangling scheme, then at that point we could go
with the single hash (although, yes, at least seeing "something" could
perhaps clarify in some cases).

> I think that is equivalent to using a short name for a type?

Do you mean skipping the paths and/or the generics etc.?

(That expansion I showed is actually already a "short" version in at
least one way: it doesn't print add the actual crate hash, which e.g.
the GNU c++filt prints without `--no-verbose`, and typically appears
between brackets, e.g. `kernel[e6083e32b3c2ec6]::sync::lock...).

Cheers,
Miguel
