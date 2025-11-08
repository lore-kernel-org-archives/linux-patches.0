Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E26F2773E6
	for <patches@lists.linux.dev>; Sat,  8 Nov 2025 02:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762569075; cv=none; b=tmaYdOqtDsPotLgdRxVHUcnNeJ6kwOuglwyBE2K3+EeZVWpVFOaImIlcHVpzI4xWSg6lqinMJaZhO+dLnatsNTUZPrCn+g41lrCird7GLfxPfuwpGXvdZlxSL1nu8fZRtpZhp+TgpI+VBrCHsMfyfaKzInC5BHRm4wXNK3bh/yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762569075; c=relaxed/simple;
	bh=hEsds1aJcMa/MFnGEl+oWU8IGfV52JAmFi/ogcjALRA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lAmixpWjXBF29YvSEySBYCjR2zzWWNmarRbh+OSoPYH3MD4lrgio8UdkLJpDh5Aqfws1R8ccyWveC1grAb2FIB8r//yR64qNgNoNtgJpAgWpFFrrVXVA2fXPD8AlKR67KKV2EGfa4KtZzTs2Oc6qdhVFR/sBftaHqL0XqJW6y4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c5oRG3Gh; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c5oRG3Gh"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-343641ceb62so124833a91.1
        for <patches@lists.linux.dev>; Fri, 07 Nov 2025 18:31:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762569071; x=1763173871; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4Ywt5KnXkAWuPtF4O67B6+CrKeKvSZlIbIOBaVjdLrc=;
        b=c5oRG3Gh7qfvoPij9LR6mR7vUrJPbcXb+Fu/R5Xsag5XG4e48wDIrR3L8yr+kHak1O
         37BdJdq+bC4FbHPG2oUzHK4G6a0CGhn8SJKfQcqzvcpK/B2hfTl4b5UJTG/sZifiBzvQ
         8kLmhJ8AI3b3ueqzsuYjtxkwIJc1I+Wx+UUrGR5i6ojJ1WPNNTc+ImUfNkbO50yVUMax
         xaO9XqGNHg10BnpQvcbFIKyKkger1vDuoTBSrmIQueODLy1BwUM/DVJJojrV1ykid+OG
         YOwLnYtQL2Opuc2JzeepWZOTZhmtA1MLhiZ5fqQu92F0OgUyulsQdpX1FIBmqQ/xkMSz
         5UDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762569071; x=1763173871;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4Ywt5KnXkAWuPtF4O67B6+CrKeKvSZlIbIOBaVjdLrc=;
        b=fQeja0MpnnmA6Yt33Wczu0F95SrqtsAd4vywYjF6cmCPWlhctL0TynFeTGihxY24iI
         AKoAoxkppWoyqHwB5YN/6tCGrqqMwmo7zRVEiim+By1ESUS/u8uwA6PVFaCd4vxwqudc
         KNoZ1WPj0ch5Prx5IaZqpJAy1nywaN9tADmnWNhwVfeouY6s1kncy+uNQmI/+aK3cu70
         6fd7UJ5ytbplBD1uBHR24jz4O5qrcAdgpV8/fghbDLNuumF/tH6NfyTxPm/M4KGWzY2h
         MTM5apD5myhRkVEiSPgHeenGxFk+Ca/2GpfcXD3CKByG4Pi2YU7ZTw0/I9lbbx8nhovO
         p+9A==
X-Forwarded-Encrypted: i=1; AJvYcCVzDsOBXkhK5Rv1K36IeznW4uVVi+k2pGQhZJbPmRtWnqaswLr5O/Qv3GyGEThD4OBXB48d067/@lists.linux.dev
X-Gm-Message-State: AOJu0YykPCdK/krnnW0smbIe6UVDrZfMNDtcg7EFVP3ae0V/z4XOWtWe
	5+YgJdb0R3Rf7k+7+wYYazDKAHt8lY1NXq00+a6+CIEyC9NiolaaBJb6Xe/bxqMUwu75S4D8l1k
	ibNuRdxXiO7//FcJQIbjD1UfVtPBJGWg=
X-Gm-Gg: ASbGncvmZzJndMPFGfXk9Sgd9D9yoEiKlbVTpNZAJcZ37II8Qojwab3J/glW4ds407d
	gLboyQRptVRmAPGEN3YagQBcw0+DcqpV0hYP5LVRsJzMbBl4UmGETqfnmp+swAmFyerVHFfrIbw
	bwjhd/R24fbBdmFaiGNJ92ydS8leLM5NhtedYhKPHSEhcK6utNIlCbA2i7oH893QdvZL0fmH+mn
	4rNL6WpTLuGeR7xKXr6adbblEGl5uYbGm35yiucYj0OdaMODtfPY3SI1sgMWrQARKk/V+fEfB16
	J/iMKY/mZhYmRbQtCS4/Non0DlnHnJpb7CwFU7LfSXNSX8WPaUzVTJ0H/onkTLwhYM5d0SR6wUH
	3FLM=
X-Google-Smtp-Source: AGHT+IEPt/zum4mIPzur6pOWm9ugmaOB4ZnZwdF37jH/QJbMUq5i1HmGSC61s/z25m7jSEylTziMZI9njr8XmEb4iEk=
X-Received: by 2002:a17:903:ace:b0:297:e67f:cd5 with SMTP id
 d9443c01a7336-297e67f0dc3mr6100935ad.7.1762569071389; Fri, 07 Nov 2025
 18:31:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251108014246.689509-1-ojeda@kernel.org>
In-Reply-To: <20251108014246.689509-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sat, 8 Nov 2025 03:30:57 +0100
X-Gm-Features: AWmQ_bntWx41R6dVeerjev8Ne9qVeKQ30TdFKSebUZNEnjznMYZ4D9bO5nuNd7o
Message-ID: <CANiq72nKC5r24VHAp9oUPR1HVPqT+=0ab9N0w6GqTF-kJOeiSw@mail.gmail.com>
Subject: Re: [PATCH] rust: kbuild: skip gendwarfksyms in `bindings.o` for Rust
 >= 1.91.0
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, linux-modules@vger.kernel.org, 
	linux-kbuild@vger.kernel.org, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, stable@vger.kernel.org, 
	Haiyue Wang <haiyuewa@163.com>, Miguel Ojeda <ojeda@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 8, 2025 at 2:44=E2=80=AFAM Miguel Ojeda <ojeda@kernel.org> wrot=
e:
>
> note that `CLIPPY=3D1` does not reproduce it

And obviously this means we have to special case this one too...

    $(obj)/bindings.o: private skip_gendwarfksyms :=3D $(if $(call
rustc-min-version,109100),$(if $(KBUILD_CLIPPY),,1))

There may be other cases that disable the optimization or similar,
plus we may have other small crates in the future that could also
suffer from this, so it may be best to simply force to generate the
DWARF with a dummy symbol from that crate for the time being as the
fix:

    #[expect(unused)]
    static DUMMY_SYMBOL_FOR_DWARF_DEBUGINFO_GENERATION_FOR_GENDWARFKSYMS:
() =3D ();

With `#[no_mangle]` may be more reliable and it also gives an actual
exported symbol.

And then later do something in the `cmd` command itself or teaching
`genkallksyms` to auto-skip in cases like this.

What do you think?

Cheers,
Miguel
