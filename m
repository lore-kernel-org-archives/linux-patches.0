Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 071972040BD
	for <patches@lists.linux.dev>; Thu,  6 Mar 2025 12:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741265842; cv=none; b=QsppXwB2LclQMovS33ADEa0nFUtctUAGSn5/j7Exl6NYDq6zdIB84SjqN1aOgRQ06rfYk25Q7ccrQsddjMrAYHrXki34FCvV0shTVU+HJyP64OX4JvGkJwtdNn8tYtxYyAZU6qgNA+rNa7NLQjIVF5XGFZRvo/S7shTITZc2Clc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741265842; c=relaxed/simple;
	bh=E39Ml7fCBZbxfVHzjpdOttpEvi9Y8jkd/560+rZTYD0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KOJH+SfDGw6p3gPPLz5Ump5nrd7KpmzZfvNsf5i7QvucZMqKnRQf+iMWl5reeSCCcwQoHZev8xWry52d3jD9mHn0nh70h0eI/5M807+N8TOW6BYUZYyg11lXvYIO50i/ghtoOfrBT91ZWHxgA49713CXG2gppfrrHZn+EvOUQe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z9BV25cY; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z9BV25cY"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-2fe9fd5e7f8so150737a91.3
        for <patches@lists.linux.dev>; Thu, 06 Mar 2025 04:57:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741265840; x=1741870640; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E39Ml7fCBZbxfVHzjpdOttpEvi9Y8jkd/560+rZTYD0=;
        b=Z9BV25cY+AM7jJGGrZVtYNIBV9zQE+tR9/MDxEgLL2shKlmI269Jz6dYjrkm1X4BJN
         k7er9aK3tlgY0q7b3pqOE+K+jyttBtxFFJljVKqD8iGd8gTtDLyuAS4xJI8tP9/6MT6B
         tLUB0ih81zH0lLM9nWhlftXOw42nGN2E/3cjHFbB9M8KugNB/vgOJl1AaecViPp38OsL
         yxgliIIkEClJCn7FvcFo8GYYHSB49/UWNIgTH3CPTFPnQqGQl+BZcLd5twSYDtzuieV0
         Tycf1ma/6p7DA3/dlh4KPZd8A/JNIoZmrgT+klT0sA50IXTvUYasGj3icmjLT4cTJ+ne
         4FyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741265840; x=1741870640;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E39Ml7fCBZbxfVHzjpdOttpEvi9Y8jkd/560+rZTYD0=;
        b=VtvyjtIIHrlVKHpYTenoHLq4zSz2pqzvhjqUu6mHCZcPfmu3TtqCaWLIpnutyPcYSP
         GzYJ8pqazmoc228TBRAPj3giUaoKCxVm/EIGKuaFEnqUFElaCKFOymksebjWaKlJhpsI
         iGWazUGhSPs8iiz58wTpNLzVkC10iW2q07MP7qHuEbhisxs6GvarwzNsvvTWtk33PJRu
         WuV3n8roUz+Aq2IWAOWYiEMQzl6qNQJb8wLfoWHI2o7/WR2cXTq/dV1jTHYJdX5zu8He
         VxFzzUs8byGVZIozsYnYynALWJBtEi6t+sR0fIGII9D+z3C5nfuOVq7FXFP1hPFj7ZBX
         Fslw==
X-Forwarded-Encrypted: i=1; AJvYcCUgKqZ4gz7WHN363PhxqJBmlISUKfUi/TtxA1PFMbIvrlNuPC+Zjzzy8zptdHsSMPLpMiNVfHLq@lists.linux.dev
X-Gm-Message-State: AOJu0YydSWU4OYGMUt2W+mdZdlCrpVzTB2xzubX56W4zUpVQiaRsovBt
	5LvsO8h6Mg4k+aTpu9AVwzs60g4lzp4pUd2ZcH6QjBy2B204D+FKxwQLs5eEUisth7XchzCg2Le
	LFtQo/F/kleAWg1JdrNWAGF5rUo8=
X-Gm-Gg: ASbGncu17RvAeQJwpzG4nLVO3K+c0VBqzNuXsgXk9qS7HTKrOFNvJi9XLVM13Jinicg
	69BhCqMaKYbWpNe5+rK9+XE5Al7n+ByKJpyXq+SJfkLH6gH7+lKHEg7zElNqAUU5hIVAYNDIdW2
	reYp+axG+YiuE3XMCAnB4Jh1JK3Q==
X-Google-Smtp-Source: AGHT+IEWKk04PIz7Wk8c0F5vZKKvySTmpJETnfri4bCYCQcstfnihMhMTAiUwNPxtpeY7tThxygpdKPz6oh1oX3Y1Zk=
X-Received: by 2002:a17:90b:17d0:b0:2fb:f9de:9497 with SMTP id
 98e67ed59e1d1-2ff498223fdmr4702572a91.5.1741265840262; Thu, 06 Mar 2025
 04:57:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250210164245.282886-1-ojeda@kernel.org> <CAK7LNAQBFX5q6yyKBJoxMoD5d9SwdKm0c23J4+LpjwA1eh=bZw@mail.gmail.com>
 <CANiq72n=95jgJs17NFAkit5uzxqtO9xij9Um3ybd_RiMCpFrDQ@mail.gmail.com> <CAK7LNAQC5Q5EQjuvMEWS5NAs-pixj3b--rkCHZ=xGQDTHqBBFQ@mail.gmail.com>
In-Reply-To: <CAK7LNAQC5Q5EQjuvMEWS5NAs-pixj3b--rkCHZ=xGQDTHqBBFQ@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 6 Mar 2025 13:57:06 +0100
X-Gm-Features: AQ5f1JozzC7HXKLXrrD94nPS6o7fBCrwM6b7SXP64UvI5vEbi8ijBc_ec378rj0
Message-ID: <CANiq72nYUcGDmDG9Sx1AqgyXfkUWA4B5M3d5PexVfN7JB58Ryg@mail.gmail.com>
Subject: Re: [PATCH] kbuild: rust: add rustc-min-version support function
To: Masahiro Yamada <masahiroy@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Nathan Chancellor <nathan@kernel.org>, 
	Nicolas Schier <nicolas@fjasle.eu>, linux-kbuild@vger.kernel.org, linux-doc@vger.kernel.org, 
	moderated for non-subscribers <linux-arm-kernel@lists.infradead.org>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 6, 2025 at 12:37=E2=80=AFPM Masahiro Yamada <masahiroy@kernel.o=
rg> wrote:
>
> This has not been picked up by any one in linux-next.

Yeah, I didn't start yet, sorry.

> I applied this to linux-kbuild now. Thanks.

Thanks!

Cheers,
Miguel
