Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CE3222AE59
	for <patches@lists.linux.dev>; Tue,  8 Apr 2025 16:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744128995; cv=none; b=Gw1SS8BRN1tX8ZuxxP17V9CuwGWoI02ASSWebajMxE0doHjVxyRwVP/y+UC9Ky5z8S5bhWtxIxSQvRBfzLHO4wN/4U/u8yARfBqWGk5qYW/9vHZ5n1dtI72F2BsLFKMgcJYnj/0koAXxVzy3KUhF3v9EvaYeJ4XN44Zk1eH+cjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744128995; c=relaxed/simple;
	bh=orKI4QzESD9wMZ9qw0qgUjTGnwjhL4kJhX0jIVv3AW8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=p9KDkcftvKywS3hnZDKRmR+3SHCGP+6bi/TqGMlr8xghTK4n09HB4OUKmUCJ3q9t2k8EZNMDcEwD4ZBIav2BI6OQtDEEbmV5q9ngjMmZu9xarT9gordexZTbvbx0/MT/d3mLv8n5EOX3lZTlHb3qkpRz4VuHtCfmho97wm6DuOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZvYB8I25; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZvYB8I25"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-2ff67f44fcaso1071535a91.3
        for <patches@lists.linux.dev>; Tue, 08 Apr 2025 09:16:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744128994; x=1744733794; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=orKI4QzESD9wMZ9qw0qgUjTGnwjhL4kJhX0jIVv3AW8=;
        b=ZvYB8I25r8SvarUMfzfwwZKEVHr8Do3HTind5mWqZWJc5ssTKHLG48U6q4YqOMEJN9
         TSkxXIbWPBzLAfihbrXkIqOc7aKH0VW9utjUYNQYzxGgukPEEexeg+KCKUKihc5yMCFH
         LTYeaSUWGmthNFEXOb4l24ZeGgRsf3rL8mGezQ/aka0v06FD1hhU0IuGu/VVEv/cPCfB
         XeDGe0b25H2Kmvugj3Tgp3IMhZdT2eA0OA01ocM3+guph6ClFjaCZ3HLzwtk1rTDuoJh
         KAy4I0ev8YtenZcrBtrwoYdGM6fZehInYFiptNwJPfgWQIhTTkR7HNrbiVEjSPeDsQlI
         JKCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744128994; x=1744733794;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=orKI4QzESD9wMZ9qw0qgUjTGnwjhL4kJhX0jIVv3AW8=;
        b=f8S63WBCrXCe9BSFjLg7Vlyy7HB7tF13WMtzkdIqJVqQtzcV/LWzWAo3SL3ZGL07u0
         roVzzg+6fRVx34RqhvsTXalj4XmDa32lFrYCyJHYjU4/CJ+3B3Q4CuBQ9nKJg3gHj4pp
         sEeyJDJVS1BhPCd2B3N11t79oEf+MeZYK7usqhC5+fGCbBZ6rRLf2NJorzJc5Kor1JSe
         9dbBPZDTjTmf+CzZFRhMbBCtc2MRO4SsDDC8oKusQMHqOp9WoP/p/3EwWIuC3ZSEUMDH
         0E6C3yuC95TA9l9eK5az+9GnTuIaf+w1virywTlWiBRZGVy1Jpwn3rgTrqENSWY9hY7o
         niOw==
X-Forwarded-Encrypted: i=1; AJvYcCWVUdnnn7cnlOYTdRsfGNinMPkwF5aDK3SEZnsnrwr+12nF5feSK0iLhGiM2Db7T/+s3HuwNNsQ@lists.linux.dev
X-Gm-Message-State: AOJu0YxoHVN71xh5Ow0iD2tf0A3ac4PUltUT+4fi3RQOPzpOp+uJ88xd
	jJH9OmEIU4BDvm3Cr9g7rav++Bl8Q810T2yreRy+wEYy9K5BvsLGfQqRkX7hOzPg/siu//MagOG
	AKUxJhribmAOmUk3eAYZs1Nif3T4=
X-Gm-Gg: ASbGnctEgXkzRg2bJf9byThT/8XF9JkDdlsivyeBtTtECVsKpN+tR3WnHZGiRVGSk+Q
	dTrJNOg7oGHPwRWLiUB1hfmc2On3Qpj1gkauOgilngUJlq+fAKc4I53dlMfWAPjizZWP5B2q+dx
	ph/kxXe5QbK2OM0T2O+FtXk3flbw==
X-Google-Smtp-Source: AGHT+IG7GKgG8uZgOht0grHnJjUWE279jQAy3IeEDlgXFafHgHd+Rpu55uKmDwcd9TusFiye4aB0C1+lD4wymKWfH/A=
X-Received: by 2002:a17:90b:1648:b0:2ff:7b41:c3cf with SMTP id
 98e67ed59e1d1-306a4975f51mr8705504a91.4.1744128993599; Tue, 08 Apr 2025
 09:16:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250408104914.247897328@linuxfoundation.org> <c06b17f2-fc80-47a9-b108-8e53be3d4a76@leemhuis.info>
 <2025040857-disdain-reprocess-0891@gregkh> <5924f2d5-1004-4f7c-ac20-3cc7752e5452@heusel.eu>
In-Reply-To: <5924f2d5-1004-4f7c-ac20-3cc7752e5452@heusel.eu>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 8 Apr 2025 18:16:19 +0200
X-Gm-Features: ATxdqUEySsXlfEC3HRl1p0nHWAUIvYJVAkFIwh7FAcER7rJJwEaHGvlhX1UeRgQ
Message-ID: <CANiq72nYw+XkHfRZDvS0GceTunxZXqiec2GXeLbPXvPK9OiB8w@mail.gmail.com>
Subject: Re: [PATCH 6.14 000/731] 6.14.2-rc1 review
To: Christian Heusel <christian@heusel.eu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Thorsten Leemhuis <linux@leemhuis.info>, 
	stable@vger.kernel.org, patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, 
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	Miguel Ojeda <ojeda@kernel.org>, Justin Forbes <jforbes@fedoraproject.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 8, 2025 at 4:53=E2=80=AFPM Christian Heusel <christian@heusel.e=
u> wrote:
>
> Thanks for pointing this out, I was also missing the relevant
> dependencies in my build system for the rust parts in the kernel to
> actually be built .. IMO it could also hard-error when you specify
> "CONFIG_HAVE_RUST=3Dy" and the tools are missing =F0=9F=A4=94

I assume you mean `CONFIG_RUST=3Dy`, i.e. to remove
`CONFIG_RUST_IS_AVAILABLE` and simply request to build with Rust.

And, yeah, it would be simpler and it would prevent the issue of
Kconfig deciding to automatically disable it due to unmet
dependencies. We were asked to do it this way back then, but perhaps
the sentiment has changed now.

What you can do meanwhile is e.g. explicitly check that `CONFIG_RUST`
is `y` after the kernel configuration is saved.

Cheers,
Miguel
