Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED149287245
	for <patches@lists.linux.dev>; Sat,  1 Nov 2025 15:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762012454; cv=none; b=mGdmDP8LtGvN82PQtjk+TNKbSFIinU5cfM0Ks+9xpkEMnRE6Acf4twxZImRjxmLYnkfMoOUPAXzxVJeU/cLzDYTNYkSL4AdHV6CVyzytatFIZQsH7kmzDTIjV3mfJG2XZf9lHg/CeeFKeW+c04/B4ikJMUjU6o/OzN21yzk7g30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762012454; c=relaxed/simple;
	bh=DZxrvCuj4VcRfVXQNKcqrzWO2/nyvtlkEBnmNGrmT9M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=D1d4B1lKackRaQswtZ8deGOANpLn/uuduVzww+081yvfzkeO/PkWxwJXpYzogLwKchKBjBCeAQyvMG78p7ASVpbg7Ho5/1MMuNogNqec/HvMhUpK5rHdNfWriUnFLpidNiP/3zKFfm4zcmKetbA4hwraghL+D3bFMa2VxypwO0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YSkmc2c+; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YSkmc2c+"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-3404904539dso553381a91.2
        for <patches@lists.linux.dev>; Sat, 01 Nov 2025 08:54:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762012452; x=1762617252; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DZxrvCuj4VcRfVXQNKcqrzWO2/nyvtlkEBnmNGrmT9M=;
        b=YSkmc2c+sEB1LAiChHeLpiYdCIHnGTAmpu9FKxTTx/yzy7HTENyIKHCV4yYGSBK8F8
         et8gv3fu1jwkFeYk41dfTCGt7TzMB1pzMrWe90XrBiRu1QLYCysaFy6A4ZI4h2hgT+GX
         WEq7VmDMMSHnuoldi8XR7l5FEgIfWmz5OvT8uvrjRtB0ShAQYNTF9IJOWTHKNcA6GpfD
         Vcv5r6MJCDOr+ruKXUU21s4Y0AZOovUGWtbH6JmAIE4NFq/A1SjHwidgbD+0201xItg2
         Aaz8vxt38JgYNZUbhMLTbBv6dD9I7Km3ZLEqm7OzRrABeTOxDcBX4ADm/yzZU4BihWyo
         iSMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762012452; x=1762617252;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DZxrvCuj4VcRfVXQNKcqrzWO2/nyvtlkEBnmNGrmT9M=;
        b=NcCqkcVCsN/BfyYJvreH7TvkLo5ck/96n2p2guU+6If2hL2u12U32EHjCRxGOkkbKN
         v+FONBJ5UXttbYgkEc/Z4z5v3hR1UR/VXNl7mHVPjRbU+HwJf3bGkfUa77Gyk0nsudkZ
         LrejqOcGlYhH+EmepmtD84p3yzaAU5I2OtP0uVsMRgkj3YqzyDntRq7YAf/13cPRkAQI
         f3nqzLraNgV4Rgg1E8exvRi1HoBlPZzLv2eFDJmjauSYleuYpCglvefZCCZqe7UzZwpz
         vpT/N2fTkLaYb1wxUrC7azJfLkEM235iKY57dgBqJSEvby5ZsF3iSLs5NNjVFD5F2SWc
         uT0Q==
X-Forwarded-Encrypted: i=1; AJvYcCWy20rD3semoa4oY6Xoa8r9kXUB6Fjd9e351WPBRGYsI2n00ygXCbSMZCdCxNbohZIPsj5B/oNm@lists.linux.dev
X-Gm-Message-State: AOJu0YxOyMfkJ0V8t3WoZwEAS6UaYoLwtRfRcjyXCr81S6BowcQ6TzoT
	zrGU+VG3pmFOvRT5YeTduEm4vjWlCkUpu6dui6HTmo8Td07bHw3Sy5NDcvlVu2lUIbG/xExflqQ
	SMH20F2BRT2T56lUgsnFt4tC6pvwvYfI=
X-Gm-Gg: ASbGncvJRKa1zqBOOBzIPueeDKuaFcOJqWSyeLkdsjQm6s2nVHwfVrZ1IFz2ddxwox3
	kL1Nmii1KI0f4H+ALcSHBpnycOB7InvNmKzlR8YkWcMCdeZM+rMamDsYPuNC4k4pDwSNnWzY4Bq
	kdjU5ctrn18DNgDHJtFQBXjaKk29c0NE2kjKfH06Dl0b8Eb1LoOsdbMB14WREcHRjL00QaKnuDZ
	gn7NU6bpQDfMRuFKuV1p2TaqxoanPZFy7t8BWwQaQ/qet+PccrsHMd4kg3azg8n/6caBfScyie1
	ND3mHpiL/ip+6rkTDtVgvyfNLXlZf+0mH76ooFCe2MYioqyzf28ps52Lt8GaGpnGKox0eX2Tj0z
	wuYs=
X-Google-Smtp-Source: AGHT+IH98SKG2dNVCAgDMWAsxf7IghHixGwIwUQXBJWnv1yD4/76UJbZrqEwBLzCN0HeDuDp9PdZmiEDyhXUpHiXB1s=
X-Received: by 2002:a17:902:d505:b0:295:3f35:a31b with SMTP id
 d9443c01a7336-2953f35a4edmr28620535ad.0.1762012452072; Sat, 01 Nov 2025
 08:54:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251101094011.1024534-1-ojeda@kernel.org> <CAH5fLgjC20QmK0s_6ht1edL8wSR3d-yrJ_viuwdOxTCQRpMmgg@mail.gmail.com>
In-Reply-To: <CAH5fLgjC20QmK0s_6ht1edL8wSR3d-yrJ_viuwdOxTCQRpMmgg@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sat, 1 Nov 2025 16:53:59 +0100
X-Gm-Features: AWmQ_bmfFv9e45aUeUVbkE-t_FDmtneqkzR5nipR7SAGPuD1TLzugXVWW0zvQak
Message-ID: <CANiq72nBEkTq7vos1Lv5Z1bgdZHt+UQWbauC0nr8xwxhuVBJJg@mail.gmail.com>
Subject: Re: [PATCH] rust: kbuild: support `-Cjump-tables=n` for Rust 1.93.0
To: Alice Ryhl <aliceryhl@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nicolas@fjasle.eu>, 
	Huacai Chen <chenhuacai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kbuild@vger.kernel.org, WANG Xuerui <kernel@xen0n.name>, loongarch@lists.linux.dev, 
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 1, 2025 at 12:15=E2=80=AFPM Alice Ryhl <aliceryhl@google.com> w=
rote:
>
> Does this need a CC stable too?

Definitely -- I just forgot my usual line:

Cc: stable@vger.kernel.org # Needed in 6.12.y and later (Rust is
pinned in older LTSs).

Thanks!

I will apply this when upstream's PR gets merged and send it together
with a couple other fixes.

Cheers,
Miguel
