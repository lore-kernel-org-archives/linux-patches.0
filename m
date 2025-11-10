Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C4EF307AC5
	for <patches@lists.linux.dev>; Mon, 10 Nov 2025 11:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762773016; cv=none; b=DJTayER/jFLrOtT8Bod6mgdhRPyWGho7M+ube0ePcGoKvUw2a1pZLjLW3QL8EulaGyr042UJrGLM+eRgo57bkPKPf0SFQibDgFo1C6rwfvwf2CPHcML3qwjdYw8hySFCdIh9Ce9lu3GdWAj/MfF32H78fJ18i0qgrQDk5O3c2Ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762773016; c=relaxed/simple;
	bh=qYod02zCx1H/VIglPSYtMCLBMHqDjGDF49aeweBgJ6E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hB/rcGugA7Ue0sz/u+iMZItZOXeABoOF2buGN7qrCrk4OP2pEAgKCvrpuLZp+m/uqqVbOO0sAaoVWEdkpw4mSi7AieyxBrlaqlvUe5gg/XiC7AfE1RB+pECa0Hgp1aXPz0/89udIsHV9eR0bvLoeh5G5F7ekMGtd/qtJ3RICPRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mEesHgZe; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mEesHgZe"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-b6a42604093so254121a12.3
        for <patches@lists.linux.dev>; Mon, 10 Nov 2025 03:10:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762773013; x=1763377813; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qYod02zCx1H/VIglPSYtMCLBMHqDjGDF49aeweBgJ6E=;
        b=mEesHgZeWNfy3U/o0rJLtJ8vqAtjaJrfbH2j6hSsNzDmEYICaqpzhz+QRX3lZOHGkc
         jEGna0172EpdNKX4X36UVWhBWTOcj4O64tv75NMQzlH6ktk5KDwkfZulQ+NBO3YFcr6Q
         usxILcjynIcBFcZJnTaBG92OB6JhcrUFGj9GvStcavW4D90iVRWIN3fCfttUHXq3LKDK
         m3+1nAq/7SARHBMGTljl5G7kphPB9vR+6d28g3Den/RMe5/c2+NxZrD+TrWy/mn7bzLY
         6Qk/6Kgkh3LRrkkODGm87Zzbu1FySy11nc7GmlhP0Mzyg88I6J727KDGFJZrZdeEeZUp
         EP4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762773013; x=1763377813;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qYod02zCx1H/VIglPSYtMCLBMHqDjGDF49aeweBgJ6E=;
        b=Js6WzB8eF1vycrIPlQchI71iajDMmOldXkIedxxt0T0HIX+iNHaw3W+yQHmr+fe4XI
         fAnpzZHA4B0hCCYuZ/NEOFftXkPUlL1DPjGao2ZLAkoPeDZftFOJCQd3xO6dtT4gGaEm
         OcI713wLtU0IznLjEImAZYjoM4xiN3mzzJDUA7C22fL6zZ30z7qp/EA8pifCnJFKv5bu
         0w2jjI+gLdvXGvtQOm4R+gogq8oWf285dGjRSriQ/9Tf7qko580pNDrj36ujlVRO2a9f
         1fEUS9T7fDu4ujbvUSrh90IJwIcSnD81qtjGhPSrnNgOWgbV5QHNpILInEVQMilozp+X
         TtVg==
X-Forwarded-Encrypted: i=1; AJvYcCUIlierOMzm35/dVykawkzIsf5o7uX7fnWMeAhOggiXzCXwRSOwjWAkcH+4/pKgIatSyQhcNlvp@lists.linux.dev
X-Gm-Message-State: AOJu0YxiH9iB4dxyxSn3O6W41olJ0TEz/qGDaTlb8oGlb7wE0CZnpqUa
	ARMzDF18wbDlbFmGJANCo09z6tWINaCbhw3CPvUPBv86hB8jo+Cl2D0MMUKKBlXBmAy5WtokLGb
	xhllpAuxtZA3r1YCbkqL6smueg7qfDVM=
X-Gm-Gg: ASbGncsR8jx32c4cezXYlxRGUbv05ohYffJHs2Cmfr8f0uzBooASqjKABzosdrr1bwL
	l9Kf2hYRSj2pPULRsn8O4jMXeBfaV1/yi0Wj7LoMJ2bn+0TuFvxG77lBKDpCJL6heOzY/nPoFTu
	fhKYkIQr2l4UnVcJhzpk1fPeLI3KOL21Ffduj7sbIHjOZp3jWrUPWMbRqWychihh1wNJ1+2+49V
	uvZEh70WXg3yrvlMwBffe5zA6VSnD1kNx4q6sOKDYMmm3kEBnS0fJH+1saUip/4Gokb5VljuROF
	pDP8hbf8v9c2MmBuI/s/zcovp3IC2PLBf7e3oq3bof9Czsrxx8iaNMLX7OX1aQrIJASdFCdM6sK
	7NuTPbqznk5gYZQ==
X-Google-Smtp-Source: AGHT+IGVXq7fcQEVvIh5RJVo4EGz3TaqkWRnWgnqaRHyeXV2fhzl5cAwdSbAJFL3N5gLtGPGFbMfA/d7S7FryVq/+Z4=
X-Received: by 2002:a17:902:ecc6:b0:267:8b4f:df1f with SMTP id
 d9443c01a7336-297e561612amr56745215ad.1.1762773013490; Mon, 10 Nov 2025
 03:10:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251110095025.1475896-1-ojeda@kernel.org> <20251110095025.1475896-2-ojeda@kernel.org>
 <aRG9VjsaCjsvAwUn@google.com>
In-Reply-To: <aRG9VjsaCjsvAwUn@google.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 10 Nov 2025 12:10:01 +0100
X-Gm-Features: AWmQ_bl715oPxt8H1J_mTcx-bHvv176_Uy8uXuVHipx3MICAaN0f0Hfn-QJfLWg
Message-ID: <CANiq72nQr8a2Qkt10rPGUgb6DciYQZCsLb-fg8S_ZV=0+Y+ZVg@mail.gmail.com>
Subject: Re: [PATCH 01/18] rust: condvar: avoid `pub` in example
To: Alice Ryhl <aliceryhl@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nicolas@fjasle.eu>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 10, 2025 at 11:24=E2=80=AFAM Alice Ryhl <aliceryhl@google.com> =
wrote:
>
> The unreachable_pub warning normally does not trigger for documentation
> tests since using `pub` in documentation tests is not wrong. So this
> sounds like a bug in our doc-test setup.

Yeah, we can allow the warning for doctests, that is easy.

In any case, this was needed for the future pin-init, not the current
one, so I should have probably removed it (we had a bigger branch with
the new pin-init).

Cheers,
Miguel
