Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8318F149DF4
	for <patches@lists.linux.dev>; Mon,  6 Jan 2025 19:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736192511; cv=none; b=a1v5vKhnzIQZktARXKOGKWtM7Fi0q+JeAGblXnT33R2XrKMq5m4maYJJ555ihPgCKf0oz3rjPKddLmDQEIBucx2U0i3WgukFcbGXGhU31fjYa3Pv1KYXccMD1vkCUBq1e0Shl5gr/7uRJ872/YHwsKoJclKeNxA/b8x0Uqifaos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736192511; c=relaxed/simple;
	bh=twWyptULTcLkSehsQFD+iTHl4e4LK1hECGZumDPToNk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Nn9lFB70rD9LpNW+OpPZ7HZNnGIH2dwuSFwwe7DutCKE1D0q4R71tQIuqk9cKrTqLDwd0JWkLzuRTXnj6A9SLNhY2VTbrA2JsEcbpgIxDBn0MLZg9lkAVaaAr0T8pGqxhVhLHF10638o1JxyfBvzTx1ckjUlfTSuvuAKhCaJK/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KHCJB9B/; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KHCJB9B/"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2ee534d6800so3134820a91.2
        for <patches@lists.linux.dev>; Mon, 06 Jan 2025 11:41:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736192510; x=1736797310; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KJOqsTsaOkpL/4SJIvdzBqE2nkiOG9fRpxVp/sO3wZ0=;
        b=KHCJB9B/uRAASFDvrchSNJPIx8ME7anJJ2AVLnldio7BSsRfgDnSUdi9260Gy8vj3G
         LlYzVblEreqLGXPdu7obo5B4zKXXFTl0XWPoPM3As8iXOnhr2uDU8vL0qgoxSPzc87B4
         rQ4t/qjxGOJWUPMRojKKeNTYXsDqfJwWHV4qLj/lY6zocs8zMCxVYMlDtJ6JksAA5lRZ
         GGSSGEhNb9HebV1X7TeoXZCkzGE3upuzQOVOlyX1kFkj1u8J90Dp48PLW/YXEvNydcY3
         TR2BI8SPlAP9sZ3HChk5n4p3FLRDP7qYcjYRXrPAg5d33I7oBGddup2nf3ehmNzfvCWY
         w8ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736192510; x=1736797310;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KJOqsTsaOkpL/4SJIvdzBqE2nkiOG9fRpxVp/sO3wZ0=;
        b=v8Uz96Hk6w/i5V4dN+fw1uQIdTmaygBgR1yUxAOGybDXRdnmadJRsAsWCmqKaB7g2b
         IWk/4bG6Be+2fr91sr1FRC5lJXhAcLnVPUnqXROP+dYJv5A3jXfPiiYVLT6cTS1vLkgF
         Tcx6Gtcd1LPTdjErpj/5olF43xfxplLoLKeVO0I/r5p9aqj4Vzz7crFKI+KYKoXmXtI2
         DHHRLZetgmozrLijgziTqbyFf1YoQ0MpHzGrnGmLnPykDwRwxYrN62eGvXSA2XlphwkH
         DROJzYbEbFLGQxCYuvTmOzVMkXpF2ue2JL7erkUgPsxNz4z++G05DbhdHFVZk9NYsj5t
         2xiA==
X-Forwarded-Encrypted: i=1; AJvYcCWKT5t1XSmHes3vPZE2cVLLsHe0OTsjAEnoFw5k5PskP/HfgPQm+/lgD1XCtrw3IF5pEHKSVTLn@lists.linux.dev
X-Gm-Message-State: AOJu0Yz+Y6+R9VKKZqZ9HhyA5Rfyfl2R7dfao3gGKI24yz/zLP+VXivp
	1s5Ya2zk/S/U2SkwNLxLRg3F+s/3xrBwCvFEEM3zVTdx3wts/gpuDftwKydxsF3rQwPuz2uslni
	7fJSZq6ViTe0Z+nYEWex3VPeu8kulanjg
X-Gm-Gg: ASbGncuk+H2oXnzI04m23qzXRId8m3GZ1MkNlU20QbYa9TVgegts/bH2RxTzNUomLDu
	AdlBSYScBz/Jz6QfSPwIbh83In4MGeW4jP/Lpmw==
X-Google-Smtp-Source: AGHT+IGIQ/c46z7ABVvNz3micMxqEy1D7Lszu9Qr3NMZCuaGtumRtZHM2Kq2ESOGWiyNvTBLi83wSLWjsCy7QvuNZIk=
X-Received: by 2002:a17:90a:c884:b0:2ee:b665:12ce with SMTP id
 98e67ed59e1d1-2f452debc21mr33898293a91.1.1736192509816; Mon, 06 Jan 2025
 11:41:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250106151150.585603565@linuxfoundation.org> <20250106151151.253706204@linuxfoundation.org>
In-Reply-To: <20250106151151.253706204@linuxfoundation.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 6 Jan 2025 20:41:37 +0100
X-Gm-Features: AbW1kvamIE7sQQgCjP_D-FznednX6MxT3LGEgKrgqq48FMAOJ5ht2LIxceZ0ZKo
Message-ID: <CANiq72mdUv29ufH2iUc=PD3Lhqi9EJOc28yrsZRWbP2p2in42A@mail.gmail.com>
Subject: Re: [PATCH 6.6 017/222] rust: allow `clippy::needless_lifetimes`
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Alice Ryhl <aliceryhl@google.com>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Miguel Ojeda <ojeda@kernel.org>, Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 6, 2025 at 4:23=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> 6.6-stable review patch.  If anyone has any objections, please let me kno=
w.

This should not be needed (because in 6.6.y the Rust version is
pinned, unlike in 6.12.y), so both Rust-related commits can be
dropped, but they should not hurt either (built-tested).

See https://lore.kernel.org/stable/CANiq72k9A-adJy8uzog_NdrrfLh6+EgHY0kqPcA=
5Y45Hod+OkQ@mail.gmail.com/

Thanks!

Cheers,
Miguel
