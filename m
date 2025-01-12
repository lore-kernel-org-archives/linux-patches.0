Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26BB11BEF7D
	for <patches@lists.linux.dev>; Sun, 12 Jan 2025 16:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736699771; cv=none; b=E4ubWcy4XJe4Z8KAK5IguFsOQKm3DrWO+6PBZL9dEluGwrEPwSZu5K1RaV8kHz8pTHhxX/lao1+mxFvhQeKASByJaWsdC3f8BYyzzRsehpB8tRfi8zJxXJKit5Ci/S3rYiAfQ0XwQuY6AMWeMWi50Bn5IsWQuO7rl7w4pUdQuxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736699771; c=relaxed/simple;
	bh=3JtN8UOnO3UzsJ4wD1F2Qadp0yRNWF8iW+v76Oc1WZg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hfX0hp/Uo2BqvMrD0bDiB8fkOcIgityQTZAFy/NVy3GKcQbKQoWI6NG3x7hPVqchNo59lqW7IPA4YKN/yQ2Vk9351dJ5CEjN3/zb64T/pe3JZwOZU1hwXdntF9guUu4AAFpAL1ta86e1zQqxrEcJck0KOl9p9rwsRDAiHpKndSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gompa.dev; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gompa.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-aa68b513abcso634448266b.0
        for <patches@lists.linux.dev>; Sun, 12 Jan 2025 08:36:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736699767; x=1737304567;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t2MDuB8AdvR6eck9De9E1R9rQFdV7/dz1RZGo3VxOfY=;
        b=EP3+5QVyjnkN8AMNbC7zXTLWzE88GFvX0AE+ynVqOpJLu2Dt+4tW4JSIS5+3FEjB5z
         4PA03mxRUTYIwIkkxsMTb2obJ+IQEe3Vuhp+MJCGLGb+YqSn3WUClIYJ414rFz49ByPE
         pgwO2BELIvaZkXNdoJdJ78TNWqlNs+mnSVpP+4p6AofxLFd4HGHs4GMjVkSXCF9r6c3y
         hBnrtR8evt1gwHSi7JotpIXC+zFic1L2PrCmuyn+4o3Q5Ul9zk096vV6Fh3XF6hnWAzP
         8lLnTXsdJ8hCPWLjuwRBCuzAYX6shJhFzo7oyOijUKtkypVe3OKTjxnkIxsLREI2n2cM
         rDFQ==
X-Forwarded-Encrypted: i=1; AJvYcCVBhtz+q0P4SfyU9mz1jpTcT2KFCVF4KvoorCz/2UmHjTiMpyCB6bjmTAn9SR7ZOkefMXaG6SHp@lists.linux.dev
X-Gm-Message-State: AOJu0YzX1fadv39VdKKrCVllg/BikgURLHzieLXJsh5ngymdrxq94nRD
	0XnUpyzTLrodignMlQtF8Wq38bwL0b4I7x00NsFtrRR/sUzS0n9Wj6r5bP+mY/c=
X-Gm-Gg: ASbGncssZJ9Q4HMOKZj7sZXncqzxFOcpyJK9H5a5HiWrVM5QHxn/zwl1vLKOabKdw3f
	Kp2PFrlnROjXBg43gULxjP6Fh40vPauFhxhQCSQEz+Qee5W90DfCSuXdFDev8hbRXRoSb/ureCn
	+US10u358H6ufYBsAWBhOd6+Df/FpePdpPYksb7iKSyQ44TuiexgeHF1I2/3FV6xi7L3bdGYP1k
	0r/ExkTmeD7c1IeqIG3oKbpPsUKhtunk9CgegrTiLFGiB52dXaMn5a4bd1U4s6ltU2nNio7aW0+
	6eW64Yjhp1k=
X-Google-Smtp-Source: AGHT+IGbI5LZidENj1+o0blq/HJ+dMlPQKw52PCYbV613u71Gtp2kHuffe1K7Z6TH9AsVC5NAmQSKw==
X-Received: by 2002:a17:907:6d01:b0:aa6:730c:acf with SMTP id a640c23a62f3a-ab2ab6fd01fmr1752470766b.13.1736699766661;
        Sun, 12 Jan 2025 08:36:06 -0800 (PST)
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com. [209.85.208.51])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d99008c366sm3922448a12.17.2025.01.12.08.36.06
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Jan 2025 08:36:06 -0800 (PST)
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5d932eac638so6790793a12.1
        for <patches@lists.linux.dev>; Sun, 12 Jan 2025 08:36:06 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCW7zEy1HJgo2bA2FvG9O6+3/NGOC8nznQoIIWCJ7WMsqk2KT7erGuG6z3t3Bo9Ix2xlWwYRBI+a@lists.linux.dev
X-Received: by 2002:a17:907:3f95:b0:aae:b259:ef6c with SMTP id
 a640c23a62f3a-ab2aacfbb7cmr1734963066b.0.1736699765990; Sun, 12 Jan 2025
 08:36:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250112152946.761150-1-ojeda@kernel.org> <20250112152946.761150-3-ojeda@kernel.org>
 <CAEg-Je81VAYecajUjYVJKBJUT+YqKemWsWEoWFgOcF=vtfPRPw@mail.gmail.com> <CANiq72kQOrvi5=1RUScEpov79RNzA3vna9KW6MoYmj8XJZhpQQ@mail.gmail.com>
In-Reply-To: <CANiq72kQOrvi5=1RUScEpov79RNzA3vna9KW6MoYmj8XJZhpQQ@mail.gmail.com>
From: Neal Gompa <neal@gompa.dev>
Date: Sun, 12 Jan 2025 11:35:29 -0500
X-Gmail-Original-Message-ID: <CAEg-Je9Cs54SkvhzbSq=2v2QYMo=mwUuGqFcs6cvi7nFgw6+Ug@mail.gmail.com>
X-Gm-Features: AbW1kvaGx_MSJ3IPf7cryJeRayddnsNQNkHSEUemH4CYPXyC2A6fwg7vKUuHKAs
Message-ID: <CAEg-Je9Cs54SkvhzbSq=2v2QYMo=mwUuGqFcs6cvi7nFgw6+Ug@mail.gmail.com>
Subject: Re: [PATCH 2/3] docs: submitting-patches: clarify difference between
 Acked-by and Reviewed-by
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Jonathan Corbet <corbet@lwn.net>, workflows@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, Sami Tolvanen <samitolvanen@google.com>, 
	Masahiro Yamada <masahiroy@kernel.org>, Luis Chamberlain <mcgrof@kernel.org>, 
	tech-board@groups.linuxfoundation.org, Steven Rostedt <rostedt@goodmis.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, 
	Shuah Khan <skhan@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, 
	"Darrick J. Wong" <djwong@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 12, 2025 at 11:31=E2=80=AFAM Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
>
> On Sun, Jan 12, 2025 at 4:51=E2=80=AFPM Neal Gompa <neal@gompa.dev> wrote=
:
> >
> > This doesn't make sense as a distinction. What defines "thoroughly"?
>
> It is a call, but when you give a Reviewed-by, it at least includes
> what the "Reviewer's statement of oversight" mentions, unlike an
> Acked-by.
>
> > To be honest, I think you should go the other way and become okay with
> > people sending Reviewed-by tags when people have looked over a patch
> > and consider it good to land.
>
> I am not sure what you mean. It is OK for people to send Reviewed-by
> tags. The original discussion was about Acked-by because that is the
> one that was usually used by maintainers only.
>
> If what you mean is that Reviewed-by should not require an actual
> review, then that is not the purpose of the tag. Please see the
> "Reviewer's statement of oversight" -- its first bullet says:
>
>      (a) I have carried out a technical review of this patch to
>          evaluate its appropriateness and readiness for inclusion into
>          the mainline kernel.
>

I've had my Reviewed-by tags silently ignored or deliberately stripped
because even though I've done a technical review, the maintainer does
not believe that I did. Therefore, what I am saying is that
maintainers seem to speciously decide whether an Acked-by or
Reviewed-by tag is appropriate or not *after* someone has sent it.

This is the fundamental problem I have right now. This decision is not
the maintainer's to make, it is the submitter's.


--=20
=E7=9C=9F=E5=AE=9F=E3=81=AF=E3=81=84=E3=81=A4=E3=82=82=E4=B8=80=E3=81=A4=EF=
=BC=81/ Always, there's only one truth!
