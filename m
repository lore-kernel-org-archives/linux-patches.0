Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8F711CDA31
	for <patches@lists.linux.dev>; Tue,  1 Oct 2024 22:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727823521; cv=none; b=n01zkjt3Q54i5bk3avs6zr+L9d3FD6aOa4Fwvdu1M4rnLT1HWji9huGCYh7F6kWZy+oCwDqRn6OGQJyeID2UfwSci6mUU4wlLSypOg8+W97PRNFo89NsfkY5KIgDVvZQe25Q461nqDlqV3YmsMhcybdKXaNpaBu0Shy2vnbpO1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727823521; c=relaxed/simple;
	bh=GcCXpoXuLQ65zsvFzzvLaNncg0Knqr7CMFRJpjt6oO4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tv8C98bGiPRsHLL+UN1xhLZ9GV5ypwuZlTSgzuebRj02OcMVcbSGJ3RW30pZ77zk20K4lX6CVq2Y8IPaGBjRNywpGdBtqOuUCXdh3pz0MYai3XQBGCvjTw0pgwS5T3MgKCuyXKCbBVTLE+SkOTImM/zddL0XfFEEmUzTO/J6uvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O9HWMrV0; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O9HWMrV0"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2e0ad414718so1126960a91.2
        for <patches@lists.linux.dev>; Tue, 01 Oct 2024 15:58:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727823519; x=1728428319; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GcCXpoXuLQ65zsvFzzvLaNncg0Knqr7CMFRJpjt6oO4=;
        b=O9HWMrV0yVtZ7whzy2mDEJuuE5GGf3w5s00KJyMO8pVnNSzQptMX5kRWEVbMrZscoL
         meGWKYqDEO7xLQju1jHLWtxSEo4ZITMDfUd/S+ubqaFXKCXr5dM2ibrNRheuJ8qpWpNe
         WRP1s9DxTKnUnREBqepJWJ1wihLLWpLTwggO0QU9mKWj/5h3b/tYL0FMHUk+CW3j5XqS
         bQYh5yAZBFcw+R14KCVQeph3pwdnpMjaypVvP6WvRCjLFbMtOUsRWyhkdneKoCyLFRVI
         lYn71z76KXdCxv2CQ9BxcrptNYAt0g71JYDW6tZQPhThSfMClQjj9C0fH5JLY537flJS
         fbYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727823519; x=1728428319;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GcCXpoXuLQ65zsvFzzvLaNncg0Knqr7CMFRJpjt6oO4=;
        b=lThsnvJ7DSHDN2C8SEYToDTQFYIVhjOTwLEFR7VS1BwxfkSAJx/XVLHe8yHcc7L2wB
         iU31AUfFkififYGMUYLCofDdSTxhbCRVYZC7LC4JlCCTduykUk/H19gGoCWMBUThYOZC
         Zob5I8dcYp2vrRukA9Db+gpx6LcB/maluF5c/YO8T62xkn8crbYVbNz3MGWvrH2FcR67
         /U/xnrQqzGw7lD6ZVqNyzW+sgH4KriS5BrjSlzVIgBSb9kprBgp1VEv6q9eQAdlaarOK
         GPgZQZArjLddhKcek/Nwo2BxBNYK0nfjS83GjX/nX7xWrajvCfklOW+ORWX1oI0tJSzc
         CB3g==
X-Forwarded-Encrypted: i=1; AJvYcCW4Gwb1ZLk9gACmRvjRhgP6suoLoBX/dOmTy5TpmB9fdTANbuN2/kofVCoUXNcKkmahOu0HXQkh@lists.linux.dev
X-Gm-Message-State: AOJu0Yx/wJh0ejj6Wkc4OAFIEWPNScDNdHhH75COf2pBMOGWl4ojUi3J
	ayt2kmoSyBjxK5IVhGn48kd5hmBFz5CGfmatz+ZzFpor3vDavQCoUM1RZSJ4luD+v6Kbf2A80Zd
	Uu4J20jkqnJHD8mhpMMRVch4mehEeZdeDl23SKg==
X-Google-Smtp-Source: AGHT+IHpaFbsZOabANZ/CJzRes6xXXQciJO4D+GF2dnFUH6bN7daLXhvMWbeLXhJOcjuqRLGFQ7VvzUeXuMcEWXDeSI=
X-Received: by 2002:a05:6a20:a129:b0:1cf:2be2:6525 with SMTP id
 adf61e73a8af0-1d5e2d25ea7mr965934637.11.1727823519000; Tue, 01 Oct 2024
 15:58:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240925140600.275429-1-ojeda@kernel.org>
In-Reply-To: <20240925140600.275429-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 2 Oct 2024 00:58:26 +0200
Message-ID: <CANiq72mPN51iHAzEk-Bn59X+ZhzzsioLoVPD7nDJ3wbPpDa0Ug@mail.gmail.com>
Subject: Re: [PATCH] docs: rust: quick-start: add Ubuntu
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Zixing Liu <zixing.liu@canonical.com>, William Grant <wgrant@ubuntu.com>, 
	Kees Cook <kees@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 25, 2024 at 4:06=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> Ubuntu has changed their maintenance model for Rust toolchains and is
> now providing recent Rust releases in their releases, including both
> LTS and non-LTS (interim) releases.
>
> Therefore, add instructions to the Quick Start guide for Ubuntu, like
> it is done for the other distributions.
>
> Link: https://packages.ubuntu.com/search?keywords=3Drustc-1
> Link: https://packages.ubuntu.com/search?keywords=3Dbindgen-0
> Cc: Zixing Liu <zixing.liu@canonical.com>
> Cc: William Grant <wgrant@ubuntu.com>
> Reviewed-by: Kees Cook <kees@kernel.org>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Applied to `rust-next` -- thanks everyone!

Cheers,
Miguel
