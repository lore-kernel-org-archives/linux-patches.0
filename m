Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7B1320ADF6
	for <patches@lists.linux.dev>; Fri, 10 Jan 2025 10:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736505923; cv=none; b=r8qTv2j8VYXK2fk4iF8JK79D85H3xglt3Tlk5xmrGwf0ojiA5m9KiZF9jhZRRhmDEgNWicYEWCKJdtpkHAmJAT7Rhpm7usPf5L19Ck3uCBgosIw1Mex4hYesY2T3S2RhrutXyP4I0Rn0I/+jqnXlhjoYdfszlp90HWX8r5VprYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736505923; c=relaxed/simple;
	bh=9kmYfii9RX2U7mMEGMR8zK90qGYxJcZFz6B28Hi5jJU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OYDOLJoUzXQ9QEQd+7axqSG/v4wK8u9bwqGS8PgjFP4s7l8kQ3sx555AXudjIokBEioyoopG07APFBY4TPhBh/ecmNISjtcNOkgDcbc0CD8vuYO6CVP8rn7fogVPjhzFKhHRs6DOGXjwU4ML9bLz13Z0PFDDJ39Wkg3strif52A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JrCUBFfL; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JrCUBFfL"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-2ee534d6800so389903a91.2
        for <patches@lists.linux.dev>; Fri, 10 Jan 2025 02:45:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736505921; x=1737110721; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QjFG9eoF5KoeJh58XhHidOIUaimWWCKxV+cQnJw0138=;
        b=JrCUBFfLM4+YCs7NPmVsgFil+rK4ZIBTSTAaprxz25JKzSxCe+VNsoY8Nbpe0JhDi6
         lw/p4LhY+/OwUmlfkzteFJBqD8GqtvRTI0WsK8WPvO7mAtSlgKeQjxFEShBpjVgUDSrC
         HcWqXgEwaUhtRTgWZe12KGI2gXEGuc9WvCpjxBVVbBkwpzT44myskanVeTI9k4c2louQ
         lUGB5oH5+z6BN8elF4XiIs03tTzkke8APoSiqECiRs9TKhVme/K5LEPGyWZp/7Iq0gW4
         b/vWwChutF29IDoOeZKRw9a8Uc0cerAJohdJ4MHLkV2P84DjuKnKE20s2+93NcRA7kAn
         50+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736505921; x=1737110721;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QjFG9eoF5KoeJh58XhHidOIUaimWWCKxV+cQnJw0138=;
        b=GhWJJX7t/XNTHplKFH7iGAZp4cHwHM9EGJ0suLO+QSuXpZ24rFxx6q79FaOs8iACWP
         zO6Tdp30lUFnnS+sAqOBxJZeJ7mNG4zCc369E7f5P9idcgUG1vrIRFF2WdOYt7pDZo1b
         2Zca4T/K6YKPhKQcpmjB61EQMXZwGeXBZVehwb4oAGFP9DTNp/egfUKIvB+vro5nVUix
         QMCwsdBnaFhX0ikmUX4AgiNFKNP0wTCgyVVgg2wyyXPLMTGG+jnsMMYopBvE+4viuEkN
         N3exh2nH78m0VevETqbF7QD41kGuk7kv2s/U4CqWzBPtU21VjJkOMjaZZj79e0sIzXYv
         uGFQ==
X-Forwarded-Encrypted: i=1; AJvYcCUAOOuHy/tsju5Xxp79pZU+RBFpqWdk1a2u2gDME+fv/tmoA5DPm4w4cAHs8V5ORXZ4YYjU5199@lists.linux.dev
X-Gm-Message-State: AOJu0YypwYysw6Gg8Od8KGPGauU3HMr9neQnSdNHLDqkZlm4nBWCgd/4
	ppLfYYWnq+wb//DEfAi9IXp4H/u1BAEZ2ECMs4vmr5UcC9+a/AFEKwxuYtSQUwGk8EYGwyYnajV
	qhlwhQkboZIOVnP20/6YLjZoRad8=
X-Gm-Gg: ASbGnctVXm3qqi+kdjGWi1lQC70/rTmx2gEBPZicOXbDQePlK72XbfbbEXnyJYpsT/R
	v4Dv8+IwBZ6fHJIuKrkVKvyGQdyM/LvTN+baIwg==
X-Google-Smtp-Source: AGHT+IGMqTSbQeiJP5ZxmSGgreQgKMlq5CZc1deiIvS0mo/5zzhBWsmj6KMc0f4dmwZgLHdcVVT0SKUHCIx5vu56FtM=
X-Received: by 2002:a17:90b:538f:b0:2ea:5e0c:2851 with SMTP id
 98e67ed59e1d1-2f548e3c0c8mr5826873a91.0.1736505921125; Fri, 10 Jan 2025
 02:45:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241123222849.350287-1-ojeda@kernel.org>
In-Reply-To: <20241123222849.350287-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Fri, 10 Jan 2025 11:45:09 +0100
X-Gm-Features: AbW1kvYKyt0J3KBBxnO0-hQyqaIGvxvx9voYhQxR0V5H00LzwkT1P9Fk3OFi2aw
Message-ID: <CANiq72=cYdFW-SM=G2ajqTscwpti5CB-eEc3fb3=tLy7ahg6oA@mail.gmail.com>
Subject: Re: [PATCH 1/3] rust: use the `build_error!` macro, not the hidden function
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, FUJITA Tomonori <fujita.tomonori@gmail.com>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Alice Ryhl <aliceryhl@google.com>, 
	Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, netdev@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 23, 2024 at 11:29=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wr=
ote:
>
> Code and some examples were using the function, rather than the macro. Th=
e
> macro is what is documented.
>
> Thus move users to the macro.
>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Applied series to `rust-next` -- thanks!

    [ Applied the change to the new miscdevice cases. - Miguel ]

    [ Applied the change to the new miscdevice cases. - Miguel ]

Cheers,
Miguel
