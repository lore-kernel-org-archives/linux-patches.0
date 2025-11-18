Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C12C43730D1
	for <patches@lists.linux.dev>; Tue, 18 Nov 2025 16:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763482867; cv=none; b=An+n393kozbrYXm8joM92IIhhSvXeIzHV8Wq9mGeRRvPf0BjWJ8uuadcluE0xWs1P49kp2oCajTOu9OxnW1Se8fUZAYIl6EVTDIfH8Q9I4NqzJo8yiPdxwmZKTp/sGveQcHQ2FWU1pCfo3KyRRcfClypguf48hBYXxSNLocHd0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763482867; c=relaxed/simple;
	bh=faOfBULiO6Qp0WVmE8McFWL4GEnAP8ye2ZQBGtxMog4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ppA6T/AxTec+IlXdxYqrKcNcge/FkuoKeUwzyQbrwNGpgdXDdzM0LiPPmX/u61OxPCGHZli54iInadLGcVgfAknuUTSj22Iy68hmsQgJ7d84LAWhDqNZaPbWWqQkwFPEuUgepONDAuAZf6pOAa82Gr/UIFn3o4IRZzc0jmOmGYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aX9IRVj6; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aX9IRVj6"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-7ba92341f07so263429b3a.1
        for <patches@lists.linux.dev>; Tue, 18 Nov 2025 08:21:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763482865; x=1764087665; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=faOfBULiO6Qp0WVmE8McFWL4GEnAP8ye2ZQBGtxMog4=;
        b=aX9IRVj6E1yobXvmX3lmf/RBill7IpzUrv8soa7CX8ijCCIkdol5Ai8laU6Usqin81
         QO9Uq8xdCdB04X1trCBZ5jO5WluRsByh1Ddunrcxd4a8nJ0+q5t4U/vtvSou2FEK5/Jn
         /Qd4ccn7NDfV6XzzEOKv+005X2OOTTl2N7SNGlDKssd7IsDqpxv9QJKR5jN1Av3h8BfJ
         NDasYceTAVLcN6L8OmKuIpP6oqw/lkehUeuKmyQ+iUn+GLf/ftuNaYXatOZWy7vWKihR
         55WnwNoE00TtPKahb7tcuvQtqq+QcRFpsZaOUOTwy/IFdkb7BlD2Z8G/DlwWBpZaHg6w
         MxQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763482865; x=1764087665;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=faOfBULiO6Qp0WVmE8McFWL4GEnAP8ye2ZQBGtxMog4=;
        b=WVJ7QF5lWB4lgXnF3AtpEx90sdJZA5r+UVhSbo7aKSlc1+iRMDxZSOc53wtM/lxQns
         xPAT3kIkIhxRkgFsCGokvMRSmxZPgjVSKDu5azKEc7H2YLYgxg/HHyCJZ6aHSPE2iZmF
         n+rxRawRDDx4OQ0eg444JwTc3MGMFsmaTXc+MNozZB5kJ3UNeHZIFciQ6tZPAAsZE58U
         ZbH8L34pJtSfHKXj/RxGYp+rwRmT20VoerAiewr9eMSq2HrqeeJUvEeSZBrqUhqWIr3x
         r/yabRZZY+xPbBDcfuwZGtbDECqbFPRwA+OMFMsaX5IRYqODpvaa/m22xT3xOnN48Ze5
         9dHw==
X-Forwarded-Encrypted: i=1; AJvYcCUy5/QyuHynrOhxC9MICDIBAAHLMin3GHx3VnubVH4BtqpDbqnv1PO6SatzoGnwN1U+TTkJ4rVi@lists.linux.dev
X-Gm-Message-State: AOJu0Yx2JAbk13UWNzTmhA8WmnMwDzSmD5RAth6GuuGsUZoiBAv7Bjlt
	GwRoLk5QktVSWs09iAg9RTRkP6DbviOiApBbXGbROodysuVy4YY2kV6DTlszmRu7dcVj/Acb1mF
	LBzkV9gd/HFHmcEsgOaRsVV6SvJ9uyZk=
X-Gm-Gg: ASbGncv8wFKhAsPz9LMWAc2sUyEnt5ZOfWgTxM68gQS9LTT/zRBbV5jnckZvYBDNm9Y
	BmR9c8krYEv+QqjJS3emPcEfCHUKn9V/jwolSAI5qgauyQtbqI6OLnQYY4ZnWR8LUHfJyJnm6xA
	gKC2BG+iVynPu6/HGqe7ri+twSq9I6ivitBEPlTiz+c8YDsg5Ts7Zbd9gXPu4TRd9ziCHicCId5
	AMZ2aTWcyJXPIiN8gm5BKTfS77TqIzoAaH9ScDHqlLUsnuLjMdUtwhFu6bqJeqC4TnTUZJzje+1
	kEtyPyxdgcEk2vTOC9dwDfYUnNNonmVuaHCQKlV622Wjk8nvAd6VbEOxb/7Mm9nWnBwwHOxnQEc
	qyfAaJLBYztnImg==
X-Google-Smtp-Source: AGHT+IFVRdNsejBm6GKYlYca1Ngn1yJHjVdLnMU26Ia9C7PKBAIRtq1oGRAnFqiiyXtONzw3uw69CCzFP8m6+uCM7y0=
X-Received: by 2002:a05:7022:ea46:10b0:11b:65e:f33 with SMTP id
 a92af1059eb24-11c78ddf633mr1026663c88.1.1763482864497; Tue, 18 Nov 2025
 08:21:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251110131913.1789896-1-ojeda@kernel.org> <20251118145741.1042013-1-gprocida@google.com>
In-Reply-To: <20251118145741.1042013-1-gprocida@google.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 18 Nov 2025 17:20:50 +0100
X-Gm-Features: AWmQ_bnVmxUteFT3dr5VfpkhZiAQKyOG1ub40EZh79PVRCrhks9ZqnFaWxh_hDc
Message-ID: <CANiq72nsU1YH3ihkaTiVjF_YUZY2nSKbc7j3xLTcHDC-4-Y5iQ@mail.gmail.com>
Subject: Re: [PATCH v2] gendwarfksyms: Skip files with no exports
To: Giuliano Procida <gprocida@google.com>, Sami Tolvanen <samitolvanen@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
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

On Tue, Nov 18, 2025 at 3:58=E2=80=AFPM Giuliano Procida <gprocida@google.c=
om> wrote:
>
> This results in the -T foo option being ignored in the case there were
> no symbols. I think it would be better, consistent with the
> documentation and expectations, for the file to be produced empty.
>
> This means that just the for loop should be skipped, say by adding the
> condition there with &&.
>
> If you disagree, then please update the documentation to match the new
> behaviour.

Sounds reasonable. If there were users relying on that, then it may be
best to keep the behavior as it was. But up to the maintainers what
would make the most sense here of course (moving Sami to the To:).

Since the commit is in mainline and it seems you already thought about
the solution, I imagine a patch would be welcome.

Thanks!

Cheers,
Miguel
