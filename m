Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0687469959;
	Tue,  6 Aug 2024 17:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722965428; cv=none; b=DDh/gqR57Ut11L8LDAhPL0VxMtKucYc9xMpaqcwGKj+jCZUev6IfNDUD+2lvEIb7n5h3ZB+4IEd01Veiqclrm9kBuqskCMTRBMxz04+mVelb9CPFwZWBkrf73NZcewy6dd1eceUeMbHoD/BXO4V3xZ3N0kT7rukVGyo0Bdz5hgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722965428; c=relaxed/simple;
	bh=8uMPD3zyzXh627Xdxpdk+jJutWpw0ZxVSvB/RP6lvGI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qalDJTZl3BWwghQrjDzTIDwKTIApt7Rtd9s4rwK1sBtdi81jzgtZEd500HCuuHYp/1cDmYAS8+pdcvUXqQCrYkM15HNeLnM2s/WNS0y1CoizsdTAl5Iauqyul/aC1nNH0VCQtbO+R0BJVou5n35svm2o3qUi/X3PNmXhcEaKlUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YaeWs7bq; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YaeWs7bq"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-2cb63ceff6dso750093a91.1;
        Tue, 06 Aug 2024 10:30:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722965426; x=1723570226; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8uMPD3zyzXh627Xdxpdk+jJutWpw0ZxVSvB/RP6lvGI=;
        b=YaeWs7bq7uXCX/dQRfPCAMh646zbDTdFkZFWDDXUau7PMlR3EpUKTM9f3/Pvvint2E
         0R+KoyQerZHLYWlVOZ0zWRSoAMTKplzR+0fduWUt2nMa7LoeeOZyIJBhMW28hbeAzJx7
         0zcIpjx7vr+bFaQDpvYkDuEUD1zFFmZlk6ETAPmgJwah5fuKvT9u4BaoPvwwmSICcLPE
         fgJuEV2AweGj5BmYXbzV+mdPcostQAV3ZcN36OHd2uwxfzUDdbyHi5oWy9ES18bHgqVY
         0n4ztugIHx2W6fC5zYiO3oPFRWtt8jdqPBBcPNJvfXwKi43cQloCYuyduxaAat/hKiG7
         14XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722965426; x=1723570226;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8uMPD3zyzXh627Xdxpdk+jJutWpw0ZxVSvB/RP6lvGI=;
        b=gqiLF9E6WSb+fdzLW8z//nKBELaafF6VCJD6zZH6IkeBMVv1rDPu6UdW72Yjbew+rO
         vkhwvA/NKTmc38gIwiIEAz/WheuyH5JiJDGPxwSNIKolE5jCiGtD/F1jlsS8KYufF3i4
         aDuwMaJoLFqPwnng+pZjC1G3ofY5WhWNkcbYHHxcwvTpm/jv8NMB6iyN9/y3jBVGjaBX
         UESlpZGN2uwgsDOcotnuSH+RwdfCoD0eoAZU1xTMfP5OlkrMx9AdcfmtLxxtPr8Mob0T
         /VgJwXqzaLylaAvNX0up+2lx4okk7gR89u3g5ZkgjoljGB2u+aINomieWYCda5Pbwf8j
         JuVw==
X-Forwarded-Encrypted: i=1; AJvYcCXtg0YJvkmJGaNyhLOvmOJLcZnol01VkvfOpGO/dY+Uhlwl6CcjtpxzWt05Rz2Y/5s8h+fBneML0/j/HB4QYCd32zKrToN2Qm9xQKcz6KGscjLP3r6Wtu8RmrPw+ac=
X-Gm-Message-State: AOJu0YwODiKPUxQ8R4aOtNoh6A1AM2pT8yUBMH3g2W5YxaWCM6JQ6Tdx
	0mBjjP90L9lkvMAK/4mdmjG/vAeIuPinSmrDLVj+gXUKJO530aKUIw9iSkuwPCfCkLjdFPKqaT9
	WoDOweeqK4JN9qUKlvdvWV0/TY+8=
X-Google-Smtp-Source: AGHT+IHJzFMmWNei6mhNNEgab9Cqof5HphfyR3QdzgwsZesseYZbZxB75Yex+rd94LxIhiJQPDJRu6VSzz0hBq8kjHg=
X-Received: by 2002:a17:90a:fa11:b0:2c8:538d:95b7 with SMTP id
 98e67ed59e1d1-2cff9547cb3mr14293429a91.32.1722965426241; Tue, 06 Aug 2024
 10:30:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240806150619.192882-1-ojeda@kernel.org> <ZrJc9UE3xAV1ezdG@boqun-archlinux>
In-Reply-To: <ZrJc9UE3xAV1ezdG@boqun-archlinux>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 6 Aug 2024 19:30:13 +0200
Message-ID: <CANiq72kMXFXYkUnxU7dK6jhyCc=JK22zgdY6nZTLFbFe8b+4+w@mail.gmail.com>
Subject: Re: [PATCH] rust: add intrinsics to fix `-Os` builds
To: Boqun Feng <boqun.feng@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Wedson Almeida Filho <wedsonaf@gmail.com>, Nathan Chancellor <nathan@kernel.org>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	Nick Desaulniers <ndesaulniers@google.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, llvm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 6, 2024 at 7:28=E2=80=AFPM Boqun Feng <boqun.feng@gmail.com> wr=
ote:
>
> Put this one into rust-dev and confirm this could fix the issue with
> Rust 1.80. I also add a test with CONFIG_CC_OPTIMIZE_FOR_SIZE=3Dy in my
> rust-dev script, so we can catch the similar issues earlier.

+1, same on my side.

Cheers,
Miguel
