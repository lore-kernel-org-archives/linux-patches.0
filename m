Received: from mail-oo1-f44.google.com (mail-oo1-f44.google.com [209.85.161.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B601EB5C2
	for <patches@lists.linux.dev>; Mon,  5 Jan 2026 04:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767587523; cv=none; b=bAuHYZs95v0sZYZdgDX413eLStZnmLXUOntwIyTUCmkeKXIfJECaxxTf4VJPGFa3wWCilgiOrGTsSfLW3IYpy2kfoTMG6E6mwB7xJ5Ev9MlSNCi1CHFaQCbvzT45S/2to9t0Gjtszw0gTgywbjnqyRyO6iIcEGfIDwL7tg4KWgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767587523; c=relaxed/simple;
	bh=e4mNUTVMd3pbP2gaHBEUKskV1yFr7MQyVaNr9q7Kg0Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HSKtUH/FW+V+NhXz3+LMjl48On/xtq7bqltuTpVHRfp16AOCBojiwJ2CeZawZHdG1V4TGMaSBasu2qFSRlZET0XQr6s8EQD6ouYbWVyfmSrOEO/MW3WNCOot7XNfUAtV4DZmULjA0iMlTt+4K34MWyOMm/Hu4QEJGK7+Cvkhrh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dzEtPQf9; arc=none smtp.client-ip=209.85.161.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dzEtPQf9"
Received: by mail-oo1-f44.google.com with SMTP id 006d021491bc7-65b73eacdfcso2270279eaf.2
        for <patches@lists.linux.dev>; Sun, 04 Jan 2026 20:31:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767587509; x=1768192309; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=saUVAgEsyurYO5XeH99MQT53kwNGQ/V15cZ9Ga2UQbo=;
        b=dzEtPQf9HNOz+ezkF1h2inHLRTyqFXoZ8ddFqhLgJwpRI8k9eBbkKV8wjY8w+Z+FQQ
         9UCAO1uTCWay0jYCPXyDVYCfXrgJMlX9dc1ULzpjYuv3iermef55fu5pZfmaqKL8HPEb
         gMU7Rf0nIIAEdzZ8HEqJvEwdJAWZaJbma7PIrr2lmC9/vDwFly4ImLTYvVIPF0Ms3EOz
         +NgiZQr603sMDfS0qmG7TnHPV4u3ozah6hHQHuO+lLfwfTGY0c120q5DKJ6S6LSbXVbN
         /U1Hug46mrBaelU4He/+c81u5q/qoi0OVSUKt/8AB4Ae4JqWNDj6hLdPAwWj6RqexxyC
         L7Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767587509; x=1768192309;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=saUVAgEsyurYO5XeH99MQT53kwNGQ/V15cZ9Ga2UQbo=;
        b=O0BQbcpRYvP8tuLkpk9MbTnc0naYWND7rdX8B7zlOtY5ZMHn094L4AkvyZuTASnLoY
         eJAr7XzrGMv45RVa4X+TwULGiQY2VSqWnGkL1AwT9G5Nl1gHdIWgbv9+sOtbC/eTBcu4
         PYRYaufT1i9nW5vC7aoqFS0/kRTmXS3IfhKB+v1tGmy8463tTpPnx1xC1UV769SdZ3f4
         lGgfGYMIJjHS/D2KEYpl2mX4VLis5CxzPQOzim3+C5SsvFsOHh7RYWRQs7PpZ8zXuzHt
         tyZAiIPdFOmjKES56zbxWbogLP47JjXFxXNBu3njLxSbbIPxDa5ZHVRdju0fBRnUWJcR
         QjjA==
X-Forwarded-Encrypted: i=1; AJvYcCUEwt9EtBPy6Ty2RMIy+Sr2+XCwhL9ZgYns6bq6dcJbulV+H934cxNWP1wgsagN1yZtEBGJamCK@lists.linux.dev
X-Gm-Message-State: AOJu0YxooLqZ/B43ua05sl6gywmJv0tRw1HqA8IJNoBxLPfY+p5tlfds
	apqJcr/Pw1z+LJI13TAnSSDmK3mEBf+yP0vCqBdaxIZGQOierkgnDOuE4gtA8KJbCDpPzixG4lh
	bhrqLmRJ7z5lKznPhSt35OeXb2BZ6zAg=
X-Gm-Gg: AY/fxX7ucQrtvXXzem31dEANzPZTef+XaGKH86KUTqqYn1aUOyeZpplWLEiBlXhbBAR
	OXpYBU88woKuUgP55gJ7ryUxqv6Z0IIv9bEzSTIbD/+vAIuCegztUi5NM3T7dDsyrgPs+26ynvS
	fdm02j3dg24rsqdnGa0fViWDOllFfgfTNdeaxcZoHf/ngS75rxiZ5XJHdCR+BHAMzj7tV0icZZ0
	0Ep0ejf4MM6SmxhOZHEXPJKiRd7ZClzna2J4h/fZQADWU1wEuKmVnVp5odlUavD5nubD6E=
X-Google-Smtp-Source: AGHT+IEBOFNjMVIcp+sMlVXjYpjBEZMMFX7+jPvUPM5+krXxGK7by8/Odk0UZPWbo60zUg8SgiWi2xJdtgeEwAt0Zqo=
X-Received: by 2002:a4a:b789:0:b0:659:9a49:8e58 with SMTP id
 006d021491bc7-65d0eaa85cfmr13980797eaf.40.1767587508671; Sun, 04 Jan 2026
 20:31:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251124151837.2184382-1-ojeda@kernel.org> <20251124151837.2184382-20-ojeda@kernel.org>
 <CAJ-ks9kSFp8CpyNr8zSKh6mniuXiYNrZCc8FC-8Z81GdbnaRog@mail.gmail.com>
In-Reply-To: <CAJ-ks9kSFp8CpyNr8zSKh6mniuXiYNrZCc8FC-8Z81GdbnaRog@mail.gmail.com>
From: Jesung Yang <y.j3ms.n@gmail.com>
Date: Mon, 5 Jan 2026 13:31:37 +0900
X-Gm-Features: AQt7F2qrKlVRmg6Qt0U99y98HY5qajxFqWZs4J8w3JjjhlpBLoCv1Y_qfJM799o
Message-ID: <CA+tqQ4Kiypr8hZ8d9zRgjkoTDaXcszEm6U3k_OoJL=mhGd_kgw@mail.gmail.com>
Subject: Re: [PATCH v2 19/20] rust: syn: enable support in kbuild
To: Tamir Duberstein <tamird@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nicolas@fjasle.eu>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 5, 2026 at 8:17=E2=80=AFAM Tamir Duberstein <tamird@gmail.com> =
wrote:
> On Mon, Nov 24, 2025 at 10:25=E2=80=AFAM Miguel Ojeda <ojeda@kernel.org> =
wrote:
[...]
> > diff --git a/scripts/generate_rust_analyzer.py b/scripts/generate_rust_=
analyzer.py
> > index 4faf153ed2ee..5b6f7b8d6918 100755
> > --- a/scripts/generate_rust_analyzer.py
> > +++ b/scripts/generate_rust_analyzer.py
> > @@ -100,6 +100,13 @@ def generate_crates(srctree, objtree, sysroot_src,=
 external_src, cfgs, core_edit
> >          cfg=3Dcrates_cfgs["quote"],
> >      )
> >
> > +    append_crate(
> > +        "syn",
> > +        srctree / "rust" / "syn" / "lib.rs",
> > +        ["proc_macro", "proc_macro2", "quote"],
> > +        cfg=3Dcrates_cfgs["syn"],
> > +    )
>
> I think we need to add "std" here -- without it, navigating to methods
> on e.g. Vec items defined in syn doesn't work (it does work with "std"
> added).

This was handled in [1], but hasn't landed yet, probably due to lack of
Reviewed-by or Tested-by tags. If anyone has a moment to take a look
and provide some tags, it would be appreciated!

[1] https://lore.kernel.org/rust-for-linux/6dbdf6e1c1639ae381ca9ab7041f8472=
8ffa2267.1764062688.git.y.j3ms.n@gmail.com/

Best regards,
Jesung
