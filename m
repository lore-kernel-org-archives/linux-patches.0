Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99DFA32AAAB
	for <patches@lists.linux.dev>; Tue, 11 Nov 2025 19:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762890293; cv=none; b=qYalUPtiGU39FMo+jxy6lRJFrnYV8nidBbAM8e4tooOae3nCbyNusLnC14L5W7E3XxDyAT6O9Xgu7RhOmFAaXanXev7V0JQNV7PoZsp72zFJhLK9lGjSs+q3ngB8/uDdFIIBbEn9auq1q2hGIyFcq5hMYp4+FgjUdyTTsnxUMq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762890293; c=relaxed/simple;
	bh=JiUjPFE5L6L3WUSoWqtnqWCucYId5dZy3dcTcIJ6lbY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=McfFst1j1oZIuqxIfS3gej2urTAFGTj9S+syStElu2pplyop1uOdylkZprCIFdEtuyYJkAPSqKo224OSkLKNC/sxtMIWs3CQaJf4j/SfuG+mqCLYgED6O+4OG5X69iN4SdCjrPoQQ7EtkFyBeg/VGRgeWtZ/0Iy8yKTVi/08hHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PZuKiqS5; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PZuKiqS5"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-b63e5da0fdeso14600a12.0
        for <patches@lists.linux.dev>; Tue, 11 Nov 2025 11:44:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762890290; x=1763495090; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hBwIkGZr5oeEH/G4GQqW+JJA6UiGsteAP6cGwBb+I8s=;
        b=PZuKiqS5kiSyuCFbAelh6gwkRLk1mmglloGOkcAUp5UhQKIlLtoxvgyC0B9k0EwhCm
         ma+i4K4dYk8ZCiatDuItCNflF7koFOlofAUZILMU2oVrERTSPY5wF8v94MFs/lIW5GPV
         QzQeGoJ0TQtnZOrSphLnfj/bgu7bfsbl/wca07r5H5lxTe89DEIcFaHvnYvHpTnbkQF8
         3f1LARqDj2j879TxiONI/p0FyJ1ApZ5DxPI0vX/hVwgdGYuOw+ObrPGMDGzxT0l9/OdL
         0qKHG2ru5kBRGrgYaaDsK0EZpjExh2pdv6oX9q+BnxeLRY76lJC7kSbj7w6SGgeXEU0m
         YsVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762890290; x=1763495090;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hBwIkGZr5oeEH/G4GQqW+JJA6UiGsteAP6cGwBb+I8s=;
        b=H4szgdLq0MOUFGJ5zuzoZWZ4how03lmPPCVcmFiKCT7yoFx7PXL8y65VjqDrzJtoSk
         0qMGy7c5tyBzB0BFDH+OnE9aQEDcYwuUHQnBUtwGE5VBQbvvYP1S6VPuCrqZX2VOYzm/
         wfGa+sZ2CBYx/D6upG20b8Z2aLPn2GoJQLx7ImqEtQqSh0p/82tidwejOcd2O7JaXuIc
         4DugwU0dpcpXM4S97akYEk+B5dMPH+9Z4KKvVqb0GJbCLU1CWCXtAiLdsdKwRAFZpEQ3
         dKlqprSM6QKrpplX/h93sjccbCwmPW6PIQGQA+9+U1NBlc/H00Jv5ityva/imwcHMVxQ
         Pr8g==
X-Forwarded-Encrypted: i=1; AJvYcCU2RYe/Azl0OFcpiZ1tOPrs3nqd+8ZtF907FYi46Kbwl7s1wVs46y5j/P7aAC3/YMGIpyx3Gp+R@lists.linux.dev
X-Gm-Message-State: AOJu0YzCpf/w+b9MbCNanh1jTj+5OaZeYdd4n+ZEn1TVrA8/8hMTMPfy
	9bZ7JW8ixsgAgv6Eajv6zITlZxXy6fyuv3EZ3y0ALRf2b/rUGUcSBKE8SWUQ9UCDYDvclJcJmjB
	p1/DNZfB+gODXf0v0eHulnc+XgHFCAdg=
X-Gm-Gg: ASbGncuNp3EfLXuUYW9F/MPh0O2dXA2UQJuwpQBO2mu4m0Aq87mXugDIxMnWtTbH2Ff
	Ojm4G8SMjKvFYftu2MJMNT/exwbYtzsf7fhx3L7zyA8iyzfSJBRE+sYw2YcqEyUUmmiX0cdjRze
	kUdc7S2U472F9xEQRJsyb2nUFuWcae+BnMHrhwj90mhmcihxnOWDMfOmpoSuwueWkdta34Yp30t
	DpoRYJq4qCTFWScjbOHNHOmjkBs68eFiPClgrPUuWrNDseuGgzXZo0ZsLV6uN/t9pO1G0RLztAi
	9gQOiw5VpFMWyh5GPgp4SHX1EMzb8L2xuUR+bozW0iEzVh1haJx/SjYyCCsbQ2/UxnG/gfLJiSO
	BUM0=
X-Google-Smtp-Source: AGHT+IEIgD2TIb5lI+JHX8EN36MOz76t2fs8U9WrA5lSIrN1Ee1RN3oycFlI6xL09eb/igzj3iXymu1H+QisdP+gzoo=
X-Received: by 2002:a17:902:c951:b0:295:f926:c030 with SMTP id
 d9443c01a7336-2984ed34944mr3301345ad.2.1762890289896; Tue, 11 Nov 2025
 11:44:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251110131913.1789896-1-ojeda@kernel.org>
In-Reply-To: <20251110131913.1789896-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 11 Nov 2025 20:44:37 +0100
X-Gm-Features: AWmQ_bl0uHm3iTs5smKUuF4u87o5Gft8n3MmJwhpnH_Cho0hzrCzkBHz2YKCGnk
Message-ID: <CANiq72kOOieyK03wukCDRaG8po1nmH6BFnyEe_Y7Do42BF_S8w@mail.gmail.com>
Subject: Re: [PATCH v2] gendwarfksyms: Skip files with no exports
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Sami Tolvanen <samitolvanen@google.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	linux-modules@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, stable@vger.kernel.org, 
	Haiyue Wang <haiyuewa@163.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 10, 2025 at 2:19=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> From: Sami Tolvanen <samitolvanen@google.com>
>
> Starting with Rust 1.91.0 (released 2025-10-30), in upstream commit
> ab91a63d403b ("Ignore intrinsic calls in cross-crate-inlining cost model"=
)
> [1][2], `bindings.o` stops containing DWARF debug information because the
> `Default` implementations contained `write_bytes()` calls which are now
> ignored in that cost model (note that `CLIPPY=3D1` does not reproduce it)=
.
>
> This means `gendwarfksyms` complains:
>
>       RUSTC L rust/bindings.o
>     error: gendwarfksyms: process_module: dwarf_get_units failed: no debu=
gging information?
>
> There are several alternatives that would work here: conditionally
> skipping in the cases needed (but that is subtle and brittle), forcing
> DWARF generation with e.g. a dummy `static` (ugly and we may need to
> do it in several crates), skipping the call to the tool in the Kbuild
> command when there are no exports (fine) or teaching the tool to do so
> itself (simple and clean).
>
> Thus do the last one: don't attempt to process files if we have no symbol
> versions to calculate.
>
>   [ I used the commit log of my patch linked below since it explained the
>     root issue and expanded it a bit more to summarize the alternatives.
>
>       - Miguel ]
>
> Cc: stable@vger.kernel.org # Needed in 6.12.y and later (Rust is pinned i=
n older LTSs).
> Reported-by: Haiyue Wang <haiyuewa@163.com>
> Closes: https://lore.kernel.org/rust-for-linux/b8c1c73d-bf8b-4bf2-beb1-84=
ffdcd60547@163.com/
> Suggested-by: Miguel Ojeda <ojeda@kernel.org>
> Link: https://lore.kernel.org/rust-for-linux/CANiq72nKC5r24VHAp9oUPR1HVPq=
T+=3D0ab9N0w6GqTF-kJOeiSw@mail.gmail.com/
> Link: https://github.com/rust-lang/rust/commit/ab91a63d403b0105cacd72809c=
d292a72984ed99 [1]
> Link: https://github.com/rust-lang/rust/pull/145910 [2]
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Applied to `rust-fixes` to start getting some testing.

If someone doesn't want it, then please let me know.

Cheers,
Miguel
