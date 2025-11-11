Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C38A357730
	for <patches@lists.linux.dev>; Tue, 11 Nov 2025 15:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762873558; cv=none; b=GpmzQ21FwQO9oBcgJ59PhcHgkpwewRv5VJDRLFxY1xEEjRGC+vqj1hsMTz1Q9X0wzovFQlKzGmDCfwLZKWIGtchpn8nn6z5cnDbQWmHyqzen2GJiMkSsUfYEEJsZ4wpWCfegLW27d7+IBUtOJM+cem4tekq30xAJWqBAKWcooII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762873558; c=relaxed/simple;
	bh=SfMT/5nRjA3afLzv9Foi5iH+LBhxZGY4UrfDPe3Kods=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UzJdcGQQsSc3DTP6iw9gHnsLcbV5MaK/klS1jhsKH5Z8w72+9adosdTY+gEzbJqkA/8SOtuhDH58Di+Icii70xBjS7x16MToXoH+udu/50YJqtBTV7ERvgL7zYCEtyIcRnq+DD+U8R+QxSUMk3OBYcY96A5tBgfT+SsY9ixrMfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1nWUA7FH; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1nWUA7FH"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4773e108333so26873665e9.0
        for <patches@lists.linux.dev>; Tue, 11 Nov 2025 07:05:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762873555; x=1763478355; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SfMT/5nRjA3afLzv9Foi5iH+LBhxZGY4UrfDPe3Kods=;
        b=1nWUA7FHK1CMinO0d2RrTLUV7Vl0EZUEkxH1Nx10vTFMlEEf+pwoLJ/KJnTWGAI5NH
         fe8m0hwU+kkFEmfF5EKVk+DZkaDja8v5hCzuGK14eJbWQNh0xLxI0p6BeO0JY7M9g0EC
         rZbmo/7Nu+NbySMyfJKfApm+c0rHrSRit+xT9Q8GWUsR7FBpXilOIyws0p3h+gWbAzrt
         YYX1m8COeuDRTKveBWikCxFcfzq73TdLG7t49Fzm6/p4EH0AaCkGjKkRzW2NnaJMPVhr
         jV+dZ6n0iW6xQ/ksrs+NDPmNwRldjzGqyMHaK+LGHMO6IecoaH21Eeqhl/2mltg5Tp5W
         SgAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762873555; x=1763478355;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=SfMT/5nRjA3afLzv9Foi5iH+LBhxZGY4UrfDPe3Kods=;
        b=eztU8YGrQNyk69fQzcBJ5E2FBRpUe9a+N40ggj4vJXZfyx6uk9TOqSnaNDVA6hMdSy
         sbqSmbLkev/Ko2lLK5yeZfE63ATiDybvGfODxNZNYSp2jYNkg4yrogKOU5dSvOnGAMJA
         +lh/Fzq6Hjpwk69wJ+j5J372hYAXBkAJaqAEh0y9XGiaeYvOJzIfMnwb9CqWPJUkZRi4
         sSUktBH0NnFJ72Wln7GIcrR1bjoQ27hsrk/wpsna0bd47e/WWemczE3CIw6+bXWfUhHk
         q8m/znuyuTcgvF7SIVACa+n3RipjOndvHvKVtZp7IaL3Rt8AAz3DbVOyaQddiw1r7E7j
         XAOQ==
X-Forwarded-Encrypted: i=1; AJvYcCWxhtnUchpaImNOL/ixcOZzG1Vx3ED2yRI36h75anam2QPUvvRsRUv363bSDOf8Guh2D/xbCnxL@lists.linux.dev
X-Gm-Message-State: AOJu0YyXdY93bzTNTA3NyvbWaIoMWqqPzovSpuUfrp3zhImslmlu323N
	yrmm7AaTnlqaG+xHvN65JHu5tKBgG6lx3DT33rsNV5J+AUIgEYS/Yd6Wk+KXx3lvYhQLMZiHGuC
	iA0fLyKPObJJU+nf8Sw==
X-Google-Smtp-Source: AGHT+IGvgucKwyCN8EF+pU643WbqgIgijDo80ZsWN9AosRWSEy/CQyb/HN1/S31aszXHJHlV1eCqBbXhnvjyXGg=
X-Received: from wmlm3.prod.google.com ([2002:a7b:ca43:0:b0:477:554c:6842])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3b0a:b0:45d:d353:a491 with SMTP id 5b1f17b1804b1-4777322e253mr92021425e9.1.1762873554751;
 Tue, 11 Nov 2025 07:05:54 -0800 (PST)
Date: Tue, 11 Nov 2025 15:05:53 +0000
In-Reply-To: <CANiq72m4K+UZxodnKqdx3cowbYB+Mj_Z0gB63j=3jE+E-x+3UA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251110131913.1789896-1-ojeda@kernel.org> <aRH9Tjf0tszyQhKX@google.com>
 <CANiq72m4K+UZxodnKqdx3cowbYB+Mj_Z0gB63j=3jE+E-x+3UA@mail.gmail.com>
Message-ID: <aRNQ0dymO5GIBc3e@google.com>
Subject: Re: [PATCH v2] gendwarfksyms: Skip files with no exports
From: Alice Ryhl <aliceryhl@google.com>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Sami Tolvanen <samitolvanen@google.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, linux-modules@vger.kernel.org, 
	linux-kbuild@vger.kernel.org, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, stable@vger.kernel.org, 
	Haiyue Wang <haiyuewa@163.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 10, 2025 at 05:48:51PM +0100, Miguel Ojeda wrote:
> On Mon, Nov 10, 2025 at 3:57=E2=80=AFPM Alice Ryhl <aliceryhl@google.com>=
 wrote:
> >
> > Is gendwarfksyms actually present in 6.12 upstream? I know we have it i=
n
> > Android's 6.12 branch, but I thought we backported for Android only.
>=20
> No, you are right, this is just me being overeager. It should be:
>=20
> Cc: stable@vger.kernel.org # Needed in 6.17.y.
>=20
> It would only be needed in 6.12.y if someone actually backports the
> feature (which does rarely happen, so I guess someone could have found
> it useful since there is no Fixes tag, but hopefully people would grep
> the log in that case...).

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
