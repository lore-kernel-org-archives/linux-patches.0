Received: from mail-vs1-f45.google.com (mail-vs1-f45.google.com [209.85.217.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72D1A58AB0
	for <patches@lists.linux.dev>; Tue,  2 Apr 2024 09:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712051725; cv=none; b=FOhZiDQ67JjTjEPg9SBSmMKRfIoxkL6eWacgv7bxZJUPfXri62dood9jc8YGP8NbmOvIJWl4kVzo7/UIfTmN4V5Ik96JGh62PRNLcgm7Dt8RRkotg9p9zIpjwrZIsWox1pW16yF0Swk41k4CLWdeYIXuYnUGUd07KpFKVgFWLgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712051725; c=relaxed/simple;
	bh=J22cvATvZxVx1kfNpr32VC2EcIinbWlHC5PnuEWb4Ig=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IZmONvWjWeFncpkQp3OwIPH1NWwsok4OQFaM5G/i7CjQ54QwaY17GbGOujE11OW2R5kbb5yL6KfHFkpcKYCW+d2C8s1wM3H84hZ7jKSykzpEELecnUleRlgYO2ovIHuoLMRTIgtfOYY/D4+dMDz9oQkX+Pw0n+myinn/+xMQruU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=T8zCFNXj; arc=none smtp.client-ip=209.85.217.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="T8zCFNXj"
Received: by mail-vs1-f45.google.com with SMTP id ada2fe7eead31-47832f13a82so1645544137.1
        for <patches@lists.linux.dev>; Tue, 02 Apr 2024 02:55:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712051723; x=1712656523; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J22cvATvZxVx1kfNpr32VC2EcIinbWlHC5PnuEWb4Ig=;
        b=T8zCFNXjznSp4YCN7Ya9httqKvIWZ3OxRsHBqXzTZKaLtVluYys1goX45yaEcdtVsI
         btlk7dVaByJcu0BOeVwkJwU3oR9BXOzXs78Gs/WyOIT9Texcozs9NUeZh1OmPywRfTSE
         Q3/ynUsPr5XTKeiSqFfXaWkI/6benTkBaIQGlVuGkSUlH1rtms+WQkibth/vDb3JCarW
         weHcqjw/zwfVGGNATnvo4yFPaZzAD4Xw2HhbxqQ/cmgmpXnxjRszL9vFD41BmpvQgXV5
         GeQrIQTWoC3XHdHp8WRms3bJT7N1dPHpccupQZei/kltjjz3OS2H3TPbZlbEexVlHTY/
         ohrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712051723; x=1712656523;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J22cvATvZxVx1kfNpr32VC2EcIinbWlHC5PnuEWb4Ig=;
        b=oRi6AbRIhV2of2fKo3juTDPA4n+R2vHSDs7aqozljEdJe96yMkOpHPm01MpxxQ/SSN
         +ifloMCVTzY/iFqqY/Et7c7W/mtBVXCYlqIcGNbDjIRIGaty+6mwyC78iTkFs2ZWy3Nm
         7YJX7WU2TJCWApkwzIhoBLdHifsiuuc/h93vXJgTNDAKFwKMmlNS4rIl42jMRtRz5Ho+
         F4kUgA8LdOV/jmtDPNNsdNdl1UeHf7tNE489/jb5V/1i1KHkQKuBWDeKm9wk2r/EfxTl
         qzhgHw4KrP++fnWNWaUTbN0WG1etPhGY1xhU4gBEnO6c1b+AaJ5e9JfVZTWBdWNGEe5g
         VVlg==
X-Forwarded-Encrypted: i=1; AJvYcCUznMsLFFolBtVnthK4eaSyaDFuRr1zlfaBw/6vjnwwn27J8eNIcY/8LqZwIIW4iAP93m5QctmXVX0f8WdKXlYt/KDTt3EaaA==
X-Gm-Message-State: AOJu0YyxuMojWliE96TkaWf7B+JE42noJHFrcUvhdxrvZ0y/x8rgZmjb
	+73vVqGnJcPhNjhKVQvVHp7c1UNK3rXMekwKEA4hFaHNrRwayhwhrgfz8WveXKZhEwNBfzAtfTH
	M0vd2j8GzaG4bFi8s6rst18/5jaF7GUR6evE8
X-Google-Smtp-Source: AGHT+IEcu9bQPdWBbDR9srTAs9tC4rp1YEcz/A6uAognyfQwZDUdoacCnoOivbqDRFhPJKKxEQgRVosZhNrjILkSNkg=
X-Received: by 2002:a05:6102:b11:b0:478:8119:a040 with SMTP id
 b17-20020a0561020b1100b004788119a040mr5557763vst.14.1712051723373; Tue, 02
 Apr 2024 02:55:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240217002622.57322-1-ojeda@kernel.org>
In-Reply-To: <20240217002622.57322-1-ojeda@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Tue, 2 Apr 2024 11:55:12 +0200
Message-ID: <CAH5fLggsHHVsuXgzHF4eEpScDTp4pUwaq60tTi9CyL5JfuTFtQ@mail.gmail.com>
Subject: Re: [PATCH] kbuild: rust: use `-Zdebuginfo-compression`
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Masahiro Yamada <masahiroy@kernel.org>, linux-kbuild@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Feb 17, 2024 at 1:26=E2=80=AFAM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> Rust 1.74.0 introduced (unstable) support for the
> `-Zdebuginfo-compression` flag, thus use it.
>
> Link: https://github.com/rust-lang/rust/issues/120953
> Link: https://github.com/rust-lang/rust/pull/115358
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
