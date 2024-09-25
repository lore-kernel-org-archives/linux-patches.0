Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3CE117966F
	for <patches@lists.linux.dev>; Wed, 25 Sep 2024 13:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727269598; cv=none; b=QcLXzNcK7cDyXwbXiXLLavAViLnGo+dfnzrQUd90fbO/VBOYLAdv5r5ReAwdaXNg5nTvyxckYdEZ6W/tx3eURieOURwkJIZ6Wa+bBzclMG3jYjeWYSqda+sPlRgFcMEUm3iRi2hfxH80B5tROwnzTBBbqM16EyjTIY5T+69JMcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727269598; c=relaxed/simple;
	bh=iB6hdwxjFFfqGkel1dMY8vFpPFOXTTJKCe8eW4+Bi5c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ej1VdUCMXVvaMoA491oHE5pLssP9zosTK/DTzMCz2/7FvHN4D9ep2gfe+tDEx25yGK1RyYJeGyLRY3SbJbJvDLWknR/MZlunCOeqCro5QhNHAlLJaP0PuheqdrxO9npP5u4DsKG70kL99cMBRAuSkKaxGcLKOilECqgwp709/vA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FTwUsKPN; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FTwUsKPN"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-2e0752be2d1so93940a91.1
        for <patches@lists.linux.dev>; Wed, 25 Sep 2024 06:06:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727269596; x=1727874396; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iB6hdwxjFFfqGkel1dMY8vFpPFOXTTJKCe8eW4+Bi5c=;
        b=FTwUsKPNQEScq5zAMLX7BNixboNOJDcfMJ7UKq/n2GJ9Nc25otLVpyJZf16TVDrE5p
         f4IGxllBKIw5dW7J4edKiMK7sJip8Hr9S7vK6IQxqJm9yKst/Q+qGuFELGZssSbc812Y
         cHVPC18iedt8XHWhvue32SCyizxY1LiopD4Hz6/FOoXYSOJ0oQTeQktl5gWStWY58xzz
         DN7tF8r7BvDy1VF+xR7wKfFq7SVPqxsJlUk8vx6ZxKbM38gkWiCZ/ENxls9yR8RGgcQk
         VHZbPWwsXCKGFuCfrtb1A7e8tPHcHKfAeTkqTBNYdtiqdZs6zyrMTMRoqJgInkt9l1UM
         bjKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727269596; x=1727874396;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iB6hdwxjFFfqGkel1dMY8vFpPFOXTTJKCe8eW4+Bi5c=;
        b=Sno1ZaWL8adAfD6Eyh9pp1uwPAYEKRLLRNY6ht8VxccvlomY89oH2PXmWql9MOTCFL
         iyGwbLGTycz2Xc4I9BK8agRd0Vd34WE7VW1GWdOV6t59Y1j+Rq87t1vTkOXl1qwc15Rl
         /FsSQ/ycc+b5Jhg58t7pEs1stYmNqAvWbQzilZtWPk13ivpIv61QdZIaF6Xlqj9FNYjz
         i2dBgrYVKqZCQCJRLvobiLVnUfIvVlAXphfrnU8HqDjNwI6U9LKCNdz+Y+9AxBRVGcyQ
         /lfTVJL8KLu0GqJmL1/mssJfvO+7vZ5Opn0M7uCf6N6nbqbtlnC86HbiwzhbE+qD+BQG
         /kTA==
X-Forwarded-Encrypted: i=1; AJvYcCWM4vN2srFSgTVnILydp6mrpyNLgkGw7b98KWrwXfn75auL9lDgcqlaz7WLGIwieLFLGWyUgqJE@lists.linux.dev
X-Gm-Message-State: AOJu0YzTTMYiXwWdCFjh/8cVNsrnb0Qwz/+l0B04JTqZtfCoXSzpFQ9e
	g3B6FE18qc9AmKuX5SuTj3UTk4HsHMPI2IwUIMrPcC58BU38CJkMqrNRlrEDI80yzkDKRjb+gNn
	oRlbeSH/nuU/KP3ndiwcVpYpSyjQ=
X-Google-Smtp-Source: AGHT+IF7dd2wxaKwlXRqdkEhcjMFw4qV18UITJsIdeRTYuV2STRNWFgGJI/WJ2qnF1mkzpyinwhH0XCUdaEJWAefdRQ=
X-Received: by 2002:a17:90b:30d7:b0:2e0:8c23:fe5a with SMTP id
 98e67ed59e1d1-2e08c240880mr232340a91.3.1727269596173; Wed, 25 Sep 2024
 06:06:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240816181545.45789-1-ojeda@kernel.org>
In-Reply-To: <20240816181545.45789-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 25 Sep 2024 15:06:24 +0200
Message-ID: <CANiq72=y3uy4ehCY-UHgywO8T_EOrh5da88sFt2Xg__E1VAHkw@mail.gmail.com>
Subject: Re: [RFC PATCH] docs: rust: quick-start: add Ubuntu
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Zixing Liu <zixing.liu@canonical.com>, William Grant <wgrant@ubuntu.com>, 
	Kees Cook <kees@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 16, 2024 at 8:16=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> This is a potential patch for the future -- Ubuntu Oracular (future
> release) works today, but the Rust versioned releases are not backported
> (yet?). If Ubuntu ends up deciding to backport them, which would be
> amazing, or at least when they start to appear in an actual release,
> then we can apply this. Thanks William & Zixing!

An update on this: Ubuntu now provides the versioned `rustc-*`
packages in older LTSs (the ones with standard support), which is
great!

I can confirm I can build the latest kernel in 20.04 LTS (using a
newer LLVM), 22.04 LTS, 24.04 LTS and 24.10.

The `bindgen-*` versioned packages are not backported (yet?) to the
older LTSs, so users need to build `bindgen` manually in 20.04 LTS and
22.04 LTS. For 24.04 LTS and 24.10, it works with the package. I will
add a sentence about that and send the non-RFC patch.

Link: https://packages.ubuntu.com/search?keywords=3Drustc-1
Link: https://packages.ubuntu.com/search?keywords=3Dbindgen-0

Cheers,
Miguel
