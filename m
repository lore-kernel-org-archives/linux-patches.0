Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 288FA224F6
	for <patches@lists.linux.dev>; Sun, 29 Sep 2024 04:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727585308; cv=none; b=BbX6bOLcJuusj7b68D9RZZQSngeJzCrf8i6gLvJe6oarNTp9sQcagqHT8Y45WpoRRzN9mX9rVfWc3R6Tu7/pWIuC/7NRJwoHHrtjQFRNrgCnr7tf9ks2EsOAxfRAAYVyIXPa9uq+xHvzjxPcJRBl+94G5Ltcfnc8C+RoTduZioM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727585308; c=relaxed/simple;
	bh=CIZA0W2qEjnnGnJknm1V6/RmDT3YVjysHtUxWt9fnhA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VdGjivLMXnmW/MR/7uhktRQmD0V+H83WKUuq0NL7+rMKCDab0tJ1AT20hk6Sxkmkl8slg6mHCFW+iQ+IroQ4nP54oPpCozq+cDMzMyBu55nR7DcjUpHHnRjBGu3jZDbL/kSuPXy9JO+V/ermzrdOC4qaxOmisGR2BnpyS7yC0Dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=umich.edu; spf=pass smtp.mailfrom=umich.edu; dkim=pass (2048-bit key) header.d=umich.edu header.i=@umich.edu header.b=eGbe+gHl; arc=none smtp.client-ip=209.85.128.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=umich.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=umich.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=umich.edu header.i=@umich.edu header.b="eGbe+gHl"
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-6e20a8141c7so32004017b3.0
        for <patches@lists.linux.dev>; Sat, 28 Sep 2024 21:48:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umich.edu; s=google-2016-06-03; t=1727585304; x=1728190104; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CIZA0W2qEjnnGnJknm1V6/RmDT3YVjysHtUxWt9fnhA=;
        b=eGbe+gHl6e4eHu/9Cmy3A8FXssW+gX+n3TLNZDU1UhlOh2kul3HXbI6kCTZ+pmx4ty
         dR4rlMwSA2NeRcAeMnV5UCvHXnHD9/Zmo2KYMChjh75k43qpiTotZTybjaL1PNdKhk6W
         4L/U/atLnLkugqoK29kIGtGzV6h2zXg+0+kCM/XMFldL8a2R/K1M4B15/Cg1pqlv7XeJ
         b52N4DUcke3CPJiJKLBsBpUgwlhmx68zCxGW47q4Gq5NEeldb9259g3HLAUoTm2Ccukf
         h54OvOj+kt0xRODjNLOcgZYq6NhwoGeU4TWLNMR4+caDYJNWswyAM9LkBd0Limy2NDAw
         MXXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727585304; x=1728190104;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CIZA0W2qEjnnGnJknm1V6/RmDT3YVjysHtUxWt9fnhA=;
        b=vnrmoJf2iY3moq+Xm4QDA1hg62uzp+phCqmsIoPAM18GDAKwjxX4GAxwBnECdwXxKf
         xvjbpNwmNJn7Girn8Sodi2AhorllSlM8Lviy2yLB4IFohTUshFVacf049u6u9nenzgSs
         sv60Urif3LHBif00jYxdoRjrq+PPcNE64jXeIRPG8jcafF5sOmJTIWR2U9ZdCJ+I1GuQ
         Dqf+rVKAF27nN2eEjVaFgbK79PVdWGeP97ZPBO8Jq08f/ee8mx0aqDn5r0mUstP4Fbq6
         zvk/C4ur+kl5RFgl4TNAhk5m4udMMKNwvNMHEppvD3rQOuIlF9geM1ho6ldmTVx7wO65
         6bGw==
X-Forwarded-Encrypted: i=1; AJvYcCWiIqHbiToLCRwe9RHLcLqZTCEsTDVEfljthrXS0wPse1Ev+bG4czQd2YFG1LahQi465cvEHt/O@lists.linux.dev
X-Gm-Message-State: AOJu0YxAvD0HsmjQjnePt7U00en+aCgN2AfzvdXuqu8eFFtt0jCK9Ilg
	o2+Y8GJhYHn0v3bkhb5Qb7rRrQr3oDvArMg1S0Rit0qsEOURUI5QXiNcOnoZLwknp3SpZwk87Qm
	JxNYcG/YGC94y3mS2T9Ztg/ZsVm17mLEFvMJgvw==
X-Google-Smtp-Source: AGHT+IHGLO8uFKk01lj+pc7xi5cN1UQcwjFwWI2vcUjxYujvaZ74Wt6ytZjstIUhVrZVb5X2wsWMAZgBbiwyKHg0/l0=
X-Received: by 2002:a05:690c:112:b0:6dc:d556:aef7 with SMTP id
 00721157ae682-6e24dc9c77bmr42360427b3.41.1727585303663; Sat, 28 Sep 2024
 21:48:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240904204347.168520-1-ojeda@kernel.org> <20240904204347.168520-12-ojeda@kernel.org>
In-Reply-To: <20240904204347.168520-12-ojeda@kernel.org>
From: Trevor Gross <tmgross@umich.edu>
Date: Sun, 29 Sep 2024 00:48:12 -0400
Message-ID: <CALNs47uFsnrqetzZp58d_j4VO5y-LkiLejwp-NKAXQg7pPct7w@mail.gmail.com>
Subject: Re: [PATCH 11/19] rust: introduce `.clippy.toml`
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
> Some Clippy lints can be configured/tweaked. We will use these knobs to
> our advantage in later commits.
>
> This is done via a configuration file, `.clippy.toml` [1]. The file is
> currently unstable. This may be a problem in the future, but we can adapt
> as needed. In addition, we proposed adding Clippy to the Rust CI's RFL
> job [2], so we should be able to catch issues pre-merge.
>
> Thus introduce the file.
>
> Link: https://doc.rust-lang.org/clippy/configuration.html [1]
> Link: https://github.com/rust-lang/rust/pull/128928 [2]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Trevor Gross <tmgross@umich.edu>
