Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9B4C197A7F
	for <patches@lists.linux.dev>; Thu,  5 Sep 2024 08:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725523975; cv=none; b=X8uVR0DOGU8lEJ8pHYJ++gvE6SYLQj6w4VtjUP7RLyHFYgdX2gSesOY1iI3kSxVPXshoBIcajP62mdI8RDSWHrJC575tv6t7FcgdUHMos2w6wxDSnA7JJd4/cs9mRc5HppMmo1uLb95aIHBltAFtnE9BnyeqcPz1LFVyX42XtOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725523975; c=relaxed/simple;
	bh=EM5AYZn3xHS8ysks1h1PoSTJYxA67HpzaIoeDZpkynY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Iu+R5esuJ0ueMVmPq1xc6YJc0Q/TySz5rScCqaP9kYEIIoxSwe1ryCpf+cXkVdSxvfJDT1W48OASTVTHrzF78QPmz9Ex2KxPGRzMWx8M1qUM8y+tHIW4Y5gEClo5PIIklhWCQoRaQFnvMU9ZBRv9u+eYW074K0W7z6Hva8e8qAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=V4CcBNob; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="V4CcBNob"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-374d29ad870so253597f8f.3
        for <patches@lists.linux.dev>; Thu, 05 Sep 2024 01:12:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725523971; x=1726128771; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EM5AYZn3xHS8ysks1h1PoSTJYxA67HpzaIoeDZpkynY=;
        b=V4CcBNobLNICpsNbilfHaOnwkD0WM+NhTMZnoGMp94RuFK+nm02wA7MewWMU+ousIa
         rtS9B242/q72UUDyNSARC8oWfOJsG6afphNhFE4E0VCy/sebydHSZrFnOyotsKvUpMj+
         s+KuW1PqwVfCMq7hq7z9hCOqNoxOF7J3+JiqoKf8m9/ttY0OhheFAGAwNzOaOSae9Dpf
         8lkTaJp64tb5hDwmMcZr4+McM/Z7A/PpCdGovfp7Q4ymTfDrvJHq3FEgNIaY9q6TK6Vf
         kIpwJq60k5OhRhhmNNVBlG9KwF/N75clddqg0/IswSsobMPGxXwGpcEek+PX+KeGaLMI
         cVjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725523971; x=1726128771;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EM5AYZn3xHS8ysks1h1PoSTJYxA67HpzaIoeDZpkynY=;
        b=CWpy1fBK35La5jmNd1kP5Zk5fChCh5c1XISyUXwzCPLZhQhBNBdruof1wlBLqSw1/C
         DSOfjLWWycFlkNEVuYfaRxy9W+LNv9R4uQONJriYiRklO/9/la9Il2E9nTfnbPs4PjJ+
         1kofWi4ZbaDVCgX2qWerQY+mAXYBowTNOMhEQJZnFgwunBPeCjOpA0x/EuCJxDWH4T/z
         1LJHxijJyt1Lg/X2K6BUscwB+R03H+e+6DrxKKTFwdl+Tq0IOsmRrykb2s4EkW1h4Wvf
         gQVN4+umNvtwErulK9OUAasl5zcBalB0mrR5QJ5aTz+VNUc+H4npfgVEO+pYFKQrPeOP
         xGsA==
X-Forwarded-Encrypted: i=1; AJvYcCUp8yQ34kv/f0Mx3l+8aSDF3DnN5/dRWgr1jWAWT4gJeqcAdJaXD3QLL3DJUQh+E22QjdNWj9Jm@lists.linux.dev
X-Gm-Message-State: AOJu0YwbQpABTN6vhJsuHkhE8hNiX5hvKisCIGb684K0+Fv5NectSkYf
	OdZ8BxpJ/TS+K2+MfWp+3C5fFyrxZvNSa1/UMdIdKLk+7xH40fZ7dk7PPveI1BBRT6Ktras5f+V
	5Xd1UlL/P3rM/4+uNxSXU+JisseT8z24l4m3d
X-Google-Smtp-Source: AGHT+IHUJq5GDiaW5WkXtiY5x7TbnuRpJfJj9Rrctnr2ggXgTY3BHdUazeZIh/t5+B4zy9gdHlKeAYqs8BTvqcnvl7w=
X-Received: by 2002:a5d:4706:0:b0:371:8e8b:902c with SMTP id
 ffacd0b85a97d-374bf1c954fmr9377269f8f.38.1725523970885; Thu, 05 Sep 2024
 01:12:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240904204347.168520-1-ojeda@kernel.org> <20240904204347.168520-14-ojeda@kernel.org>
In-Reply-To: <20240904204347.168520-14-ojeda@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Thu, 5 Sep 2024 10:12:38 +0200
Message-ID: <CAH5fLghf+JUHJpPzL7yTXGxtRA0LK5xreXwzsSVfxCiT-mo20w@mail.gmail.com>
Subject: Re: [PATCH 13/19] rust: rbtree: fix `SAFETY` comments that should be
 `# Safety` sections
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
> The tag `SAFETY` is used for safety comments, i.e. `// SAFETY`, while a
> `Safety` section is used for safety preconditions in code documentation,
> i.e. `/// # Safety`.
>
> Fix the three instances recently added in `rbtree` that Clippy would
> have normally caught in a public item, so that we can enable checking
> of private items in the next commit.
>
> Fixes: 98c14e40e07a ("rust: rbtree: add cursor")
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
