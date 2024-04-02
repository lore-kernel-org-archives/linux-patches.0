Received: from mail-vs1-f47.google.com (mail-vs1-f47.google.com [209.85.217.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9627A58AAF
	for <patches@lists.linux.dev>; Tue,  2 Apr 2024 09:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712051747; cv=none; b=iW4xMUeBcYD09UrGlKXbmHK8jlmSrz3wU/EdjaZtNPTkpoUY8p9hNCj3npI34LDQH2jzeM6u0QJpXR2IBDH/Jyv5OCLNLvvoh/R4WT2cfuQBuZUBuymcl4UCMR+MozAzGbcvwemGE1E24N6ZksgCRz4KB2coUiKMDcgK1hGbWyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712051747; c=relaxed/simple;
	bh=a+YljDVrbcAwyR/tcUOKBAwbhaSbQeo8lJMXH+opy20=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=I+0EcCJDeMzjjQGOryQsEcXWKLZKXuxzesHfahkBoxnRypzBBznDZPQMQi63qxE2ukZjXfB/5fZWVMXVcu2fvT+CuLOAnTP6ibq7wu3DlVhF5pyt8Bh6gyJcB8+GGs08iPv72zH0TY9dr0Q084uPzkjk8MbP5myHgBmQSWE76KQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=u0gKcu9f; arc=none smtp.client-ip=209.85.217.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="u0gKcu9f"
Received: by mail-vs1-f47.google.com with SMTP id ada2fe7eead31-4765cffb446so1510223137.0
        for <patches@lists.linux.dev>; Tue, 02 Apr 2024 02:55:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712051744; x=1712656544; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a+YljDVrbcAwyR/tcUOKBAwbhaSbQeo8lJMXH+opy20=;
        b=u0gKcu9fcS9H5vvo8uQ+4HK95zdh/IoMRrEB17mVBG1u3eFRNclBU8JP8PD7/m/VBL
         PZ1uu59G1M7ZQeW798/o8ssYND5K8A22CRVUF4//V143sN7Arm+cogGl1mXBMUQ/2yR0
         VLeK8ZxSApXuaNHel+coIrhuY5gDDo6fJ2l0hcmZfMh2uYkAXBwGsZtysk93s6wtBtKG
         iBG07T31dlU5KF7INq4TKeDweLVJMyDGi9OWPqOf2bNcsRxbWbb724j6HTL282uo8GGB
         91pR/5Fz8yB0xZHLBY3rdSelwTrXsRovnL9rSB5mfwTJEXjMEr/rKVwmdxFclZ7trxAN
         0TqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712051744; x=1712656544;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a+YljDVrbcAwyR/tcUOKBAwbhaSbQeo8lJMXH+opy20=;
        b=ayO8eNxVtG88pIEcWdjUf883remSirGlIWllefPRawQPmf/ZB/dM2fwN2KJgyoBfno
         MS5l5Vp//NIuv8c2RyLYZBGOhQPKL/O5C8m4gkLwlVh16V58RwG94iPQ9gmYN4yhZn93
         rEWsETpxq77M74XX3T2V/DZ6B1Sbw9kno3HKGuVLtwosXNewmXbAYeEBI3/Ol5ONgJqB
         bor2xo+FbZfTznRls8iqhuyIJXbf1x1gohu+Bbea/ieq/9aDooy85lX7HBZCEomhwGkU
         paqIwdntI58txs4OKsdeUG7cBUzThf+1WN34JmbrJ07euXpq/v2VgprWLmcxkRaauuW+
         RLVQ==
X-Forwarded-Encrypted: i=1; AJvYcCWUVBXqJsK4eLDLkMUg2TRaNMHDUJCudvZkGQ7zP6cRpaTMM4Wghj/pKXfz1r7X6+nLBFCB0KSb4piJB4Jx2Y+3ydJCA6z6Tg==
X-Gm-Message-State: AOJu0Yy5rDr9g6XWlZIGpMKz6xWnNzy/FYiq8XGGv+cWlkfSzRnCr1wG
	10VEdFs0l6N97l7pal6LSJR76qjCIbCaAHyMelI1guerVLdshXL+rtt3jg25fXcIrrw19gdCMSi
	CnnGpENP4EbfkuN6KFpf3UJGvZTFwyNHQWiNy
X-Google-Smtp-Source: AGHT+IGv3VAH51GyjjtjsnXbb/DrFswdNA8szNO89cktWs1ewiqSuc3VC/AWKEjqHLDt3jRpmLOWygntlWniMVRckAo=
X-Received: by 2002:a05:6102:378:b0:475:fe59:f33 with SMTP id
 f24-20020a056102037800b00475fe590f33mr6501047vsa.29.1712051744314; Tue, 02
 Apr 2024 02:55:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240217002602.57270-1-ojeda@kernel.org>
In-Reply-To: <20240217002602.57270-1-ojeda@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Tue, 2 Apr 2024 11:55:33 +0200
Message-ID: <CAH5fLggb8jr2yaQwcQFmrP935_h+SRPT=xH+tRQe7dngiLB2fA@mail.gmail.com>
Subject: Re: [PATCH] kbuild: rust: use `-Zdwarf-version` to support DWARFv5
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Masahiro Yamada <masahiroy@kernel.org>, linux-kbuild@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Feb 17, 2024 at 1:26=E2=80=AFAM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> Rust 1.64.0 introduced (unstable) support for the `-Zdwarf-version`
> flag, which allows to select DWARFv5, thus use it.
>
> Link: https://github.com/rust-lang/rust/issues/103057
> Link: https://github.com/rust-lang/rust/pull/98350
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
