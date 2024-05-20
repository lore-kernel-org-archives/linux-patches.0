Received: from mail-vs1-f47.google.com (mail-vs1-f47.google.com [209.85.217.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABD463FBA5
	for <patches@lists.linux.dev>; Mon, 20 May 2024 09:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716198271; cv=none; b=dQ/vsrgZjp0XcN6p4+C2AA553MWd7GSG1OR8Pbc6JcuyTFULbZvitH8sUFYujItouRM2g/pQl/+w15BXlM8FpAaG4K3qAFVXIG4249hsqjkS9yAXZksmbnoWxCWZ3BvIhPrzp/Nl/lqZertEmPomHK6USUU7sPwn1BIG7BrLrPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716198271; c=relaxed/simple;
	bh=9SQyahqkNTCE11p+YPTRBzNEGuv1mZ4mTj9rW50lNSY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=p2JgJbvhRlytvIjqxI7tuD9yP+B5ZfycpOts88qOJ/EAwtqmFX6lQHfAmC540+pms1QgxqIGmA+9M9W00hTZiajJuHWUdUN/lbq3/L+qd1FbXvsFh/hnnalO0ZGJbVhI70f6+w0eaDpyFTW1PTbsqdcO8nnUknX5V0sLzWES8jM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Nkiib5f7; arc=none smtp.client-ip=209.85.217.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Nkiib5f7"
Received: by mail-vs1-f47.google.com with SMTP id ada2fe7eead31-47f158ca5a7so375072137.1
        for <patches@lists.linux.dev>; Mon, 20 May 2024 02:44:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716198268; x=1716803068; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9SQyahqkNTCE11p+YPTRBzNEGuv1mZ4mTj9rW50lNSY=;
        b=Nkiib5f78tlD0JAvaAzDIRJ8RQlWaafOYP/C4SRs/aHRYdUgw3arKe1JsnW36z8P8R
         IKGhr1LaFBPcwHeUyriUQ2H7W8mmvFoj/THo52wuG5dkZCyqT/p/PCC3vEBfyYOep+M5
         uSYLlytI189KFbqg0FehGqueFaSlqY46S7YgUeGN5zgkrjDGdqCbfRpfhvjRA4kzfGXu
         oOserK1Jx2HJDYuFfL81XmVHgNR+WdxlOU0WxVsyDWKsD8jEBMaf/I352Yvc++hc/wMe
         QgNuVHMPjtH4WkJM0EeVTM47x3pCKd1odVfrxqf+KDSQpaoKpTLFNzcCaryBiaa/5L2/
         1XNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716198268; x=1716803068;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9SQyahqkNTCE11p+YPTRBzNEGuv1mZ4mTj9rW50lNSY=;
        b=cVBBhMHMfJk8mYEOqqMzoy8FjILCrEXdSMrEOJgAseOsbyCQCltpJuIoDKzvK0jmO6
         mMbH/QA+//Fk1Av58obDH/oGe8WRa9Ajtx0Rqr+iwCcNq2xURPnR+hz5QS/zVDbeuoRx
         tnugdsQW6jAqbwAlR2FlYvH5HkHPAqK6l5L6HiRkV7kr/KHvuzDxgLoxZtmyxTyzdtmD
         NMx4X6wOsajXwvCpH6NVjXeKLFq2dLmwtj78Jt85A6eApCj23glXELgDBBJFKD+xp3hc
         xeny9FFBmodXZvtCThJ6UA/lZbmcxwWsenqEI3zzsryt/dzs0PUhZeTjuDrSEuZimcA/
         90Uw==
X-Forwarded-Encrypted: i=1; AJvYcCUGncCq5dBoSlMIcUpJWVh7zNSHHpSpLn5WuX0cSFx6HOqJNuDCesIYyH1tnxKHAOgGSegFLRYJezMSkgMxVWFmes9d7IPafA==
X-Gm-Message-State: AOJu0YwqQ3fVYnQNLl1h/6cl48B8UqThdzxKutlHPNqrnpHAT2d6Ys3J
	ij+mC3TXxNCzJXA6sYAXa28yP1AUFJ2vVff8fs14ERODJl3PdrTJgrVonDwam/4qcpHGePv0WIZ
	VLC1ruhhjI+u95kZO/Z6sVGvKyOMLmXksKK/W
X-Google-Smtp-Source: AGHT+IHHXvr+M+34UawNAnnzqJygOBNlCpPhzSst4E67c+2hXFzQu8PTkPa+2afVxf4csgSkRirTEdacdSn42ZMv2C8=
X-Received: by 2002:a05:6102:d89:b0:47e:a214:8d02 with SMTP id
 ada2fe7eead31-48077cc45d3mr28209812137.0.1716198268543; Mon, 20 May 2024
 02:44:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240519211235.589325-1-ojeda@kernel.org> <20240519211235.589325-3-ojeda@kernel.org>
In-Reply-To: <20240519211235.589325-3-ojeda@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Mon, 20 May 2024 11:44:16 +0200
Message-ID: <CAH5fLgij=Wv0Fbd87piUrP9n-riQxM-4BUo26XDgKxuZEQEixQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] kbuild: rust: support `W=e` for Rust
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Nathan Chancellor <nathan@kernel.org>, 
	Nicolas Schier <nicolas@fjasle.eu>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	linux-kbuild@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, May 19, 2024 at 11:13=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wr=
ote:
>
> With `W=3De`, kernel C targets error out on warnings.
>
> Add support for the same feature for Rust code, but take the opportunity
> to apply it for every Rust target (i.e. not just kernel code), so that
> it behaves like having set `CONFIG_WERROR`.
>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
