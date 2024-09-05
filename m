Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07232194AEE
	for <patches@lists.linux.dev>; Thu,  5 Sep 2024 08:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725523942; cv=none; b=HibsQaWHMzW439BrYdUAVGkPP7B3mJVCyNrNshujk371X+o1BULyJX3uMijGNypvo1mVBdzdL6HSj+t9kd18SrYXfHarsxyyAFCricM59so2F08lUwgKYaiirLyONMlCuxAe6XZxxIOi2elJMq1NCfFYn6c8/fAEBPiosHs+UJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725523942; c=relaxed/simple;
	bh=rSIoNT2lPLs96YVVwRh5JllJcJJ2SY8FNEGfw3S1XSQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ujC3PFGXjesQr4tA0dnwCmpqTSVppgEKwfvpfvRXHdVaaVozpBt07xIm3KzGKVL/96R3PHHney+72teKMvThVzlmofaj3RFnNi0A8XiUClaspRfCpeIOsyLIjGlCWiqH30KKCJ6ccA5YFZU/++ezeFI7QvDz/j2xnVgj/8NdaWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FEZHViek; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FEZHViek"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-374c3eef39eso236709f8f.0
        for <patches@lists.linux.dev>; Thu, 05 Sep 2024 01:12:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725523939; x=1726128739; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rSIoNT2lPLs96YVVwRh5JllJcJJ2SY8FNEGfw3S1XSQ=;
        b=FEZHViekRcZsd3dIpCpGZpCqOcj5vkc6cyMZ1ufA3h0H5vXHhdEJAL/T56kMJhvb44
         eddWzdfz32gg+8GtKf7AvapaNCY5BzSNaMHJIUUlRRqL0B5k4sh/MPJ5Fxqc7lo78jkw
         3op1OdRSv6dInSWGvzdCm+YV3lD1IoAizzUe1itBowLetZj+jmVrmPI0ZDmDuRy7cLXf
         dtDxFhMLAn59BJa7YSuPq9nH1IprPrU/r+sxRwpfmE9XC8LqLWYLRED0TmSlyxotFBX2
         GDz2By651yLuszse+mNVduPVNfR7hA+q5c9MsaICXlYKOUgqJgO5Gbu2+XxyNNluvSk1
         Vfuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725523939; x=1726128739;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rSIoNT2lPLs96YVVwRh5JllJcJJ2SY8FNEGfw3S1XSQ=;
        b=uicmkQfchwIaIBLmtmD6BDoM7JOaxVDITcDOpMNnT2GcK/qPT8ud57Eydk+C9i5/se
         SYqN7vGy8O++p5NDdhV+osS8215bEqU4XMzL4JN2DATgpTQSalvw0fmy8El8OWxJZfc+
         3cUErQ69hhZUW4f577FDcqqIsFR8xQr3MGAKbMdF5DNlghEp6Au0YxnfLpv4i8hSGb8+
         /SCIHywwdapgkyUdKe0ps98/4sa1ret/W+nYvFXDIEQajBWfhd8BIWtVFwv1zZSmjtun
         DsyrA2ngk26H7DCimbhgMgsewyyeP8638T0wfQV6b29j+ATm/NGbrZC6nzNMLUcxsAWH
         ZPBg==
X-Forwarded-Encrypted: i=1; AJvYcCUFhMtvIbv+5/NF5UmFxm7S/Uf6jcpgvB5Mq0tDlUHDpn0j6cg34HtwUNzHQmvj3LrvjO97tByZ@lists.linux.dev
X-Gm-Message-State: AOJu0Yw0IkjjWRnwRjlo5cBMn3NhTGj2Gunl/JF/dkp7YFav6pmaOtmQ
	onDMm2Js8TzJTNDrzzpwTjotxq+XudgC73fyUYMt19ZP43X79AHgBkSsA9A2mCkiV/PjRpqAmR4
	eBfbyla25mlPlPfT+uUJCEljkyaTSm733n4ZX
X-Google-Smtp-Source: AGHT+IE62Epsi0v41kZrmq00wKSCQR34/0qV3MJKgYftCiq9+X1v5PTgR44xXkcmKdvrW/zHlM01xfs3FnBHh4EANoM=
X-Received: by 2002:a5d:424b:0:b0:374:c64e:3fe7 with SMTP id
 ffacd0b85a97d-377717f4f33mr3567902f8f.59.1725523939035; Thu, 05 Sep 2024
 01:12:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240904204347.168520-1-ojeda@kernel.org> <20240904204347.168520-12-ojeda@kernel.org>
In-Reply-To: <20240904204347.168520-12-ojeda@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Thu, 5 Sep 2024 10:12:07 +0200
Message-ID: <CAH5fLghOG3tSySfn4vnxU7v_Y26ZQcerQT7-4pUJZpYv1zGM4w@mail.gmail.com>
Subject: Re: [PATCH 11/19] rust: introduce `.clippy.toml`
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 4, 2024 at 10:45=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> Some Clippy lints can be configured/tweaked. We will use these knobs to
> our advantage in later commits.
>
> This is done via a configuration file, `.clippy.toml` [1]. The file is
> currently unstable. This may be a problem in the future, but we can adapt
> as needed. In addition, we proposed adding Clippy to the Rust CI's RFL
> job [2], so we should be able to catch issues pre-merge.
>
> Thus introduce the file.
>
> Link: https://doc.rust-lang.org/clippy/configuration.html [1]
> Link: https://github.com/rust-lang/rust/pull/128928 [2]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
