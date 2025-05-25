Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46CC71991B2
	for <patches@lists.linux.dev>; Sun, 25 May 2025 21:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748208016; cv=none; b=mNfYiEEllcrnRIoicbk8h1KCiiiASZ4YIGikpiPFpw50ob5wPj8A/b+wP38ehClJa1z1iGbuY6E2/fp3f/4ZU5oB1VVtbjxySY1+GDuczdrNR/kPVgRaGQ9T9IBo4TOhIBSt/1Z7VxktyGjleoi3A1z0mKR1PpUTFV5F3NgpZok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748208016; c=relaxed/simple;
	bh=CtxtRwDTR28nIt7yQX7wy/U1STuHSVsVc/E0okr7YUo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=g2Op1VP69CC3/hVIm4JgXbumE9wLDO1zsUqzoWRYaFmuQMiCjPnzijbovQ3va0Tw/mW2Hw4KBn2qRunb6z1SYejQTrVDKr0+htAbQCYQwO3ifk+OpvTHmPpW4z/z5r7S8olCRZ/LoLY23ZowIyA8FdXd+mCZ2nS34SCqspfgOxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=POjBrqEs; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="POjBrqEs"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-31141a8e6c9so249289a91.3
        for <patches@lists.linux.dev>; Sun, 25 May 2025 14:20:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748208014; x=1748812814; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RmWnKirvTrbRAF99NBR2VG1q0jOLkLFX2IdBmlI2PXw=;
        b=POjBrqEseppYXc8XLHGIjzQ2ejYovfmTanVoy5Bl6GzCQODxpX4R388+iOqJgfrDw0
         P0AsCRFvKJNA8OFDk0ScNuzd8xJ6YN3+1yMPihKdEXTeSJkAFblBI7B/baPorbGwbnGO
         DBuQNbsFvl33aOz204haHU/7I7YN4y1GGLJzd7/ScomT6wOEadLWl5URr6moDl60Y5Hv
         5Hg4TR0QXg4oyG6CjOUBPibyHAZz2EMHqe4D2KEFXAGE2gr9g3aQ7Qef4KOTzpYUwKMv
         cmLNVMuxRFtK7GCdeB7OPFJYDgHKxwKJstGSMTUj8/MpMs9YBl1IY+KofqteMFicIvXI
         2P7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748208014; x=1748812814;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RmWnKirvTrbRAF99NBR2VG1q0jOLkLFX2IdBmlI2PXw=;
        b=PDCwa+umuzmeMLBQxjB50u5bxhratCqjm7Qin697PQ061zP0hA76Mi3dQ7F1Qp5WdZ
         2VPlcZcM0NvGAhawry54eCENnOUOkVBeQn/iVkEek+/vO29W0v6YK5fUfzrSEsT51G98
         VmejK8lKA7JQHPMaFxw/8ZE6UeXpRN9uouz3FWSb5pB8JE7pMi7fJrVsrgCHVcQtICu+
         js/KoLXgU0dn/OIoEm6Vr/zbtzIHwcfSd2cYczie4/E13HylSeBBnjjImhNNs99pqeBd
         DzRwWVJIqPK9xSO7faiGwHdLWpx1iVSbuqgy2gyfVhg5Siai73ofe8AmYL9sGf2w+mdZ
         fJdA==
X-Forwarded-Encrypted: i=1; AJvYcCUUO9pS8u85RFK9YApfg+bRbcbTrn/HOeJjH55DLFud99PzJoijdyLFMPOxVVYMOoMz0O5Yludx@lists.linux.dev
X-Gm-Message-State: AOJu0YzhZUcxsISclspnl2P/imEqHHxFwMzFAdwgW3ShIk2VDKaWub9H
	bY52RD5ilp5zJogJHugknbEsFCybFc6T+6mseZq7MSoP0t791n1gFU/jD2RSrsshee0K6ZyATIW
	c4DqKTSjCdrlQ/0/I98m4WNOdgE6nKFdsbfNkVs4UuQ==
X-Gm-Gg: ASbGncvXCgjNVhAm0SoiOMApDOdo1wBgN8Ee7ghTAbNApZywTYw2o4vOsWtQcBb5JKm
	dnfQt1q6hyVlifr10nuOT/9kTDqZnqUVezTRAVES4+7THZZlYREmXCmE1yOZzVdIPu/jKPSF12E
	gVEMzH0Nq0MZaSd53VdaQPNO+bE3zuWeycu8vzQkCd68Q=
X-Google-Smtp-Source: AGHT+IFI2L9HEpcXUL2n1dOY11pYnE9SYgzumm6Zp5ZskDrngut5ibiWGR/QoaPWKN2gBGmkQN9pV4HPpMPvEyovHrU=
X-Received: by 2002:a17:90b:3891:b0:30a:80bc:ad5 with SMTP id
 98e67ed59e1d1-311108a46ccmr4050471a91.3.1748208014391; Sun, 25 May 2025
 14:20:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250324210359.1199574-1-ojeda@kernel.org>
In-Reply-To: <20250324210359.1199574-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sun, 25 May 2025 23:20:02 +0200
X-Gm-Features: AX0GCFtZP7bKNBRZxMsP9gqMbVfG1KIKxBTIvF-5yVsuAAVeygiPhHKFp8-mJAs
Message-ID: <CANiq72mRtMDaDmgv4v1+wgN=NbyLSDSeXB=e=r6sNydBmvJXww@mail.gmail.com>
Subject: Re: [PATCH 00/10] rust: clean and enable Clippy `doc_markdown` lint
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 24, 2025 at 10:04=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wr=
ote:
>
>   rust: alloc: add missing Markdown code spans
>   rust: alloc: add missing Markdown code span
>   rust: dma: add missing Markdown code span
>   rust: pci: fix docs related to missing Markdown code spans
>   rust: platform: fix docs related to missing Markdown code spans
>   rust: task: add missing Markdown code spans and intra-doc links

Applied to `rust-next`-- thanks everyone!

I picked the ones Acked by Greg and Danilo (thanks!), plus Jocelyn
picked the drm/panic ones a while ago. So now only the `of` one is
pending, but there are new cases coming, so I may send another version
of the series to clean them and possibly enable the lint.

Cheers,
Miguel
