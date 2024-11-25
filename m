Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A560F185935
	for <patches@lists.linux.dev>; Mon, 25 Nov 2024 09:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732526155; cv=none; b=sV9/EosWUQ91eCJ/JMi0HXFGYfw7ynC/DmtjR5ZeSafUGYCjooqQGUB9tbRi9QL8IqJn9hq6j2bM4QWxXPsg6M6nXPnQ74/xXBUjH2EPXCeZrpy/zPxYz9W8KYessnsrdXWMm4FKaoj7Jqrci4eASblF/AgtQXUzecfQUBW8rsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732526155; c=relaxed/simple;
	bh=0ha3COx0DHOj8uxVj0+IXNOyCOzZMIKeCo7cSFiOZo0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WOjZ+biqMWfCtT5u2y5hygCAClvL23Bv2cqKc5kn24P1NyZbx+JA+LrYD2UXNBU87LTwvtz2mJT/agBa+wgMlA5O05smFZ/GblIzgpywUQq2gKX++YjOo/wyNJ0AwmYXFNYgRSnni0uU7nXfHq9/qLE66Tf02McACCDsHhGBy48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=owkRSgF7; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="owkRSgF7"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-382423e1f7aso2956899f8f.2
        for <patches@lists.linux.dev>; Mon, 25 Nov 2024 01:15:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732526152; x=1733130952; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0ha3COx0DHOj8uxVj0+IXNOyCOzZMIKeCo7cSFiOZo0=;
        b=owkRSgF7TpmZz9ETb/qBk8Da9PMk+JSmUomsDHGlUsaJiInmhicl74ggv0uOOYMuaN
         TIdkg9zrJtSKLHz1YC58lXEyws8TFpLhSZG6Rt49ajU24xHa1HhAq/jzv+Gb+2HaBryI
         zHE+ltRBJDn7IDnKrDLzw8tPdVlY4KZdGCwhu+qFcZ+WzZXUdcPEszEfjfPbYCLfBD5D
         vuBUkcFE3Q59+/7KqJPQvQiOw+dGXcOMnvHcGmraZ8CAkBMjAmMfYHgSZ+ugpPcXZLKD
         1JLkrivhBrpzxGKFXNYGNByh7UNpKZWODY/0CSvkEh3nTksKmyB11WqUEVJjuNoh53br
         A6mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732526152; x=1733130952;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0ha3COx0DHOj8uxVj0+IXNOyCOzZMIKeCo7cSFiOZo0=;
        b=GMSEiPJQxFo29EzZzHMyBcxfrCttFgJzEMzQZAQqQGUuSt54uKS/JdWGEfjajRurHg
         4/d/u44F4orE1lwLdQVrNMamvhpL5a26DZQ1Q0NSKLSSfRir1ynGUtvGOjJFaPZFXjvT
         6fZcc73w8JDrxiblH8/tweWxmHwVQomJlA5AbyEhj5exLwqt7E1gVc1JEczWm1/7fwHh
         nSsNIjm4hmxt8Y/cJwTVfEmGwyrjVOKSxPkXyO3wCldvC1hGfhdKIutP+JemI0dvDskz
         KuGL3aM4hzflPeczwY6ZuHulj8CnR5sHTGNcQ192rwUpjL2bzdJk7JerfnlxkcDArqB4
         gooA==
X-Forwarded-Encrypted: i=1; AJvYcCVNDS7k9upaaN2GHjMhX0Ig0O2K1f9vtjT70P3UP/aHSi5pDiwYBp4MbyptsC674CD9eqH8eAmd@lists.linux.dev
X-Gm-Message-State: AOJu0Yz31MOmrVnyNRWnke9KbwrkQZ0EPSYrlbyPwtP3YkLgWDQ9wH/G
	IuLKSGo78PSTzmMzzT2ZcJIjXAbCXglmGnxBE8ohRtP8lqZDAs64UvUJyQcw9qljXA6BvcFfYzn
	wEGoi3YQ0w2Duc/KHhJeTRhB4wggbNOpQKzL2
X-Gm-Gg: ASbGncuw+2OC1J+Wy7J7kSEygsJDAWPAIW6mj90l65BSbx9+BCGT3PRauIX0CtUikmg
	nyT0toJXlDu4oHBiLIpA09hfAPCdBY3tUUhmO3vZNnqKMCY2FR2jMQ8j3qvfPOw==
X-Google-Smtp-Source: AGHT+IH8NglVha/cRO2EUsWas5pT6+KPbdrlOa1Qfc0/+y2Ov2H+tjMFSpQ12N28tn+7P/9GBO4emIZVFBM59ocV130=
X-Received: by 2002:a05:6000:1fab:b0:382:4a15:6928 with SMTP id
 ffacd0b85a97d-38260b5715fmr10344321f8f.14.1732526152020; Mon, 25 Nov 2024
 01:15:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241123222849.350287-1-ojeda@kernel.org> <20241123222849.350287-3-ojeda@kernel.org>
In-Reply-To: <20241123222849.350287-3-ojeda@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Mon, 25 Nov 2024 10:15:39 +0100
Message-ID: <CAH5fLgjoC7=gBBnohf4GPLPrk+wpR7P5KMm25EAmTspdTjg=4g@mail.gmail.com>
Subject: Re: [PATCH 3/3] rust: add `build_error!` to the prelude
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, FUJITA Tomonori <fujita.tomonori@gmail.com>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Trevor Gross <tmgross@umich.edu>, 
	rust-for-linux@vger.kernel.org, netdev@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 23, 2024 at 11:29=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wr=
ote:
>
> The sibling `build_assert!` is already in the prelude, it makes sense
> that a "core"/"language" facility like this is part of the prelude and
> users should not be defining their own one (thus there should be no risk
> of future name collisions and we would want to be aware of them anyway).
>
> Thus add `build_error!` into the prelude.
>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
