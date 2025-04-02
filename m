Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 728D523AE70
	for <patches@lists.linux.dev>; Wed,  2 Apr 2025 13:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743602344; cv=none; b=rELUHzRN60tqTSU1ycD9/Hts4BV99jsZmnQI62mdAyYxJ871g1f23jfcl9sH9ZJwiboXOAji8sxwvdni6ZYvgs8HD8ypUdeigjeuIo4rTie49fIk171l3EPJziaU9Gfv6lZexkPxqNZXxPsdBxrRaIl00gugeY5a63sfY/OqVNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743602344; c=relaxed/simple;
	bh=vTMqK5JsGJkV3D9uwxiRrS81D76Lq1lchZmymzYuSgQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=p3Nhrm9QTTs9rnNUXnGwF8dNTM/k+FxvA1Y3/ifRl0P2XwAC0FtweGYvJnn3gmKv4OoIdRdGw1QAbkhJOd0aYcsLiVX5k+gCt7tgtW5OVVIusv2uJVn+wcYK6HBSmeuxX5r38TXwLiytkcrhOV7uuu7F5fPvLJVDDNcP9NbZ2j0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D7mdEBnU; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D7mdEBnU"
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-30db1bd3bddso64648551fa.3
        for <patches@lists.linux.dev>; Wed, 02 Apr 2025 06:59:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743602341; x=1744207141; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vTMqK5JsGJkV3D9uwxiRrS81D76Lq1lchZmymzYuSgQ=;
        b=D7mdEBnU4eaxWtdfrnsmPR49c0K3l97t2Nr+N3c4LDrceS6jINE/QHWT/FMXVhv0H2
         W3/axqrKecSBZxodgRgFUIrsEyW/tX29uoNHKIUExpRy/Nsrx+uaWKbZvadnBX/2QtgD
         Ej2hptFXwlyAUHpu3MkMl/MLuAA2Ajyy6XSCstUWkJbAFVblTqet4HZ2k5VKsplrCfPm
         mcezb202i7ns417yhIkOjuyOcg4JRpD3PTF0ZP/umAv3tKk8GyyrTSm4QYeST45CcEOK
         D0ZhaReWZbF95d5Vfdq1Ipi/7XXTqUje2HIUuS7OqTqc96BomOFLnTqQhOToz90ZInzw
         sTdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743602341; x=1744207141;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vTMqK5JsGJkV3D9uwxiRrS81D76Lq1lchZmymzYuSgQ=;
        b=kaodAx+Bey8fXf6zLBxso5c4QCn5dBztY+N5SssF3KvVWwWtfekrvCmR99g/1RlJxp
         zbVeuFvzZLVx4z0R7vxE1p3i8+jwB3IttH2MgITwi+F4qZ8IlYzBEy7LcgGXIKKXP9k6
         C9IZSb4lYjwlRCQQl4dDH80OXHRN3u0pAudbf7/0+lcm+culi2zuH2eMNYIUu0RK4x+x
         HA6U9CHM4S1kVoDQtlrKzHKSP5FtfZYOPBWh061TOBgo7unPXRYJU7aFT5zmmZa5ICZL
         NW8474LEdWALxYhQDKcT+yxRGdcFDJQkUB6BQY7VctBK14f35WM5UNA0s8mSb2J+RaMZ
         Pz7Q==
X-Forwarded-Encrypted: i=1; AJvYcCWlyHiiDnpn7kBDuUQE8lt1zR04ghi4JBuCaDSl0TE5UUs0vRbhdGvLbeJVH3gr+zJNhs7EIH/1@lists.linux.dev
X-Gm-Message-State: AOJu0YyBTcR+9LfN/lErYyATOhzLEiS8O5Pnz2xjgxKCwdaSl2k9dUaf
	eLKsFy0A1Zyl0XeVrFIWhYM0ETvDIFj1qtvh437aeog2UKh7mSrueUgDuDoWsFbbptend/2WiD+
	hfEN9GNQUoEYnJR0d61xypFzjN6Q=
X-Gm-Gg: ASbGncu0CDZB5j5ohFHY/FUHIp/QVnOPD/kAmW/9jhPtzHbCEOMnRiSQaiy9UokekwW
	arrJeJc6hYyDsajmAqQYGQ4/xvw5ytKhnmkvVmYbgfEFtuEE9dYMQusXY+kwLm9mn1UWvqSI0fc
	q76209vFOEMNpX7aXsGBjx4yfbGn7XMHUsUrD0Pr/6Ww==
X-Google-Smtp-Source: AGHT+IEoOP9OJacFp4ypS6GUG779N/1XqdaJI4YYpqIYC5vpdqMDP+fGMWlF4r2D8VUDYn6eHoqMl8exjta7+xc7RV0=
X-Received: by 2002:a05:651c:2203:b0:30c:3099:13d0 with SMTP id
 38308e7fff4ca-30de027899dmr64849571fa.21.1743602340379; Wed, 02 Apr 2025
 06:59:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250401221205.52381-1-ojeda@kernel.org> <D8VPGBN60E61.1Z48FQW6TL3A@proton.me>
 <CANiq72mdvnHvWbVNQbiXSRxd1xrF+A=v0RdJO74xeY3HyhRmcg@mail.gmail.com>
In-Reply-To: <CANiq72mdvnHvWbVNQbiXSRxd1xrF+A=v0RdJO74xeY3HyhRmcg@mail.gmail.com>
From: Tamir Duberstein <tamird@gmail.com>
Date: Wed, 2 Apr 2025 09:58:22 -0400
X-Gm-Features: AQ5f1Jq2gyAHyF-tCYUwI-tokOiFWHXkHJV1fpYwtQRaEhz50SkLmO1wNlDMOqA
Message-ID: <CAJ-ks9nAAcoJoFF+qNPbhsM32kOh9u+LGYUwFN_n9qqudB6YhA@mail.gmail.com>
Subject: Re: [PATCH] rust: clean Rust 1.86.0 new `clippy::needless_continue` cases
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Benno Lossin <benno.lossin@proton.me>, Miguel Ojeda <ojeda@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 2, 2025 at 7:15=E2=80=AFAM Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
>
> On Wed, Apr 2, 2025 at 1:53=E2=80=AFAM Benno Lossin <benno.lossin@proton.=
me> wrote:
> >
> > I'm not too sure about this change, if the loop is longer than one
> > screen, it makes a lot of sense to have a `continue` instead of `()`,
> > since one might not see that there is nothing after the `match`.
> >
> > I also think that an explicit `continue` is nicer from a expressability
> > standpoint. So I think we should keep them.
>
> Yeah, I feel similarly. It is sad because the lint did find other
> cases in the past that were useful.
>
> If nobody else cares about keeping this one enabled, then I will send
> the alternative patch. Hopefully we can re-enable it at some point in
> the future.

Rather than disabling globally, why not `#[expect]` these instances
with a reason?
