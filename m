Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3FF2224F0
	for <patches@lists.linux.dev>; Sun, 29 Sep 2024 04:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727584559; cv=none; b=aCR53JFUKRxrCr24Ron/Ud1Q57LIl5zcbukJHvrR+zkd1f7apH+69IoN4268DBVefeucV0/0lDO4Ss8ADp6SHs6Ry0iB/aYIa/zKaYZjdrlGvfjWu2UGEWGyeG4N2Wl0gV9tL705sj/+l/sSJvDd4IrMy4OaswkKW/o/KS3hGt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727584559; c=relaxed/simple;
	bh=Cw52eLb8pxcuWBn5qW3XHz+bqeyKJurQoZGsckqC9ZM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qWpvfQ8YcVE/tN7WaNHtznjorhxYSXrNGyQNM++6AUXT2AzaNXmaSdyB4701cb5A/M3krDh4aOQfA6SsH0uSA6cPtXPmZK+DhnXMAufA/f40ZNaYYUSlbKBB+ByGMIJMH4xUw34T9y1vLiaGC8g4rySRJLW+2hRS0ZEzgyzb2X4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=umich.edu; spf=pass smtp.mailfrom=umich.edu; dkim=pass (2048-bit key) header.d=umich.edu header.i=@umich.edu header.b=Ds4g6N+G; arc=none smtp.client-ip=209.85.128.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=umich.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=umich.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=umich.edu header.i=@umich.edu header.b="Ds4g6N+G"
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-6e232e260c2so26310397b3.0
        for <patches@lists.linux.dev>; Sat, 28 Sep 2024 21:35:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umich.edu; s=google-2016-06-03; t=1727584556; x=1728189356; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cw52eLb8pxcuWBn5qW3XHz+bqeyKJurQoZGsckqC9ZM=;
        b=Ds4g6N+Ghor1bA1/wKHj/3q4biZ1LdNAm4xnkW0OL0MsGorskwECy3mDspEdTwE+Ik
         BE1SxxvfteqLAner5lk0Og8omUcCl+yQT6jVzZ3Sfxdzj+GSmWPX8oQ4L3LjDXbP+Nbt
         EpS9xGwFpxGfSacb1IRt74Wn97w+OrqoD6GNI1zP3whMswbbX5GnpVBghO6WxDUnXoiF
         5tgdD42K1HbMkKD7h6XTXNzxYwT2xs0ZwfL775utI9SmHXflMM/4ZwBIUPOAO328S2uE
         L6boevcCf/AC33IEIq5juJOWTIFrupDIMDq6bfVNxEvr3GYOjB+w+kkBTf1R4MUR4tQ4
         dN2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727584556; x=1728189356;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Cw52eLb8pxcuWBn5qW3XHz+bqeyKJurQoZGsckqC9ZM=;
        b=F6KoF8SsfwQXhzGxICdjSVvXs6c+zL46PQfHYVwgJiH7a8hLEfBsald4KvSxNKbsa1
         gyBwiH7vGd496cChTfPwo3EBgQFy/HMjOF2UniEXYTxdxLHUFb7OienvWbYEO+xRF3QC
         w0d2lyxkq5sEfRhbnJTvKAUITN7KRSJlppMeDGye008vijz01UaKlkHALhZ0KijUY5mm
         fQVl88cXMO1X5btgxeL+2Vyy2kmrq5uO3fRdycZ/6VFRH0PL3jPyAd36i5xDcvG0yARC
         26XVw/EJoLqDdVCVcI4mjyR5+MTikKIofEsbE29YU/A4AIABGMl4P1gHDCACZVYqV29U
         ZoyQ==
X-Forwarded-Encrypted: i=1; AJvYcCV1S0yYZFQwF5tuYqzJEhPyA0zUnnPW5gc9Fcw89TGHms1RQRZL3QSGjvNRnhQ698jK5Ppd7PzS@lists.linux.dev
X-Gm-Message-State: AOJu0YwYgfMk/iDeRIj8oOsnuhdagxyvH0zNQL/G5E7ShrABcB2Ti51F
	QroHzygj7BSbJLG8QJzBsZXv0Q/p9Nf6eKNK+f1aprsKa3bjSC8dNJt38VhhGuZ0cFZ0mwSQ643
	xGmmP3M4YqYYw9YGDbnVInR7zMpsqNyA+CVm+0w==
X-Google-Smtp-Source: AGHT+IH3BpjQXLR+cTBvGGV0ZUgSzcTqoLWPzJwNjTW4/pMBS8HN6jUU4/gi/Li9YPYG6vdNFq7a8pH2JdBOD1J0HTg=
X-Received: by 2002:a05:690c:490d:b0:6e2:7dd:af61 with SMTP id
 00721157ae682-6e24754df9emr60630647b3.17.1727584556602; Sat, 28 Sep 2024
 21:35:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240904204347.168520-1-ojeda@kernel.org> <20240904204347.168520-7-ojeda@kernel.org>
In-Reply-To: <20240904204347.168520-7-ojeda@kernel.org>
From: Trevor Gross <tmgross@umich.edu>
Date: Sun, 29 Sep 2024 00:35:45 -0400
Message-ID: <CALNs47vuWxauvfTwfgGNdmDGFP8=ZUQvmtTw2SmFGi79ZW6CKA@mail.gmail.com>
Subject: Re: [PATCH 06/19] rust: enable `clippy::unnecessary_safety_doc` lint
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 4, 2024 at 4:45=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wrot=
e:
>
> In Rust 1.67.0, Clippy added the `unnecessary_safety_doc` lint [1],
> which is similar to `unnecessary_safety_comment`, but for `# Safety`
> sections, i.e. safety preconditions in the documentation.
>
> This is something that should not happen with our coding guidelines in
> mind. Thus enable the lint to have it machine-checked.
>
> Link: https://rust-lang.github.io/rust-clippy/master/index.html#/unnecess=
ary_safety_doc [1]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Trevor Gross <tmgross@umich.edu>
