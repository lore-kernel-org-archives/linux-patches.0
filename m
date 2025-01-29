Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 855631A3A95
	for <patches@lists.linux.dev>; Wed, 29 Jan 2025 22:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738188255; cv=none; b=eA2PMEqL9yI7fh+h7qzqnc8xGejXpMyPFsAEOqyj+z5+ePzHjBjp6B3LSx2kv/IhSUGrsaLjLJEeudIGeOkl6d6thtpJlJgAQsaogtpiJB5BV+HhNMW8/vPMI8HYmopEgLU4UmuJu/ZYu1lUybZYnSVTcZeWAhXCFxA8EC/4JWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738188255; c=relaxed/simple;
	bh=CjyPkktg+9QZr/kJmhaLKTTzwvdHZ31Jx8T23Ohai2Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V39yEFJmO4T5SYnQ9/DXdgpNADqwp5DT8BKzUI/aySAXSQNYnaVHjqEZv8u4WZVqKz0S9fYJv0FY9XdDvVkPCIXi3DkBAESO9LkECuAgYOVCBHkTszFAevLjMAqiBDHQgiF7uaY8GvczFeaz4ctxvPD4ISr9F6wBf1mVGpA/Xxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OnZ+Wq0w; arc=none smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OnZ+Wq0w"
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-7b6f0afda3fso23998185a.2
        for <patches@lists.linux.dev>; Wed, 29 Jan 2025 14:04:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738188252; x=1738793052; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1ldV1M6+Yu26kO2evXBO1Y0MEfQ9jNaRgIY5Fjf0wuk=;
        b=OnZ+Wq0wcOxDO/qz+YWGJOHrFfmCgyzgJ5dUNGb6+ilg4jv5IycFxTFozrTMx56YdZ
         FMY6GUFlHK2zzB/yqAM2b78TAkwBUo2foAzv+C6A/FU5v3U5YM8x8VvmXOlOvLQRRokY
         2f9D0nY9T6t3ZWxLnloVNP6ycXW82pG6njsbjnW/yVKdjVP3zKIWmjW8WM5QcHxgzZ6v
         rbH9jWAeaMclIeeky/1JkGs72mDX/uv4mNXZZDUz5jNiPyy7GZdTT7TlwYd8M/oBMJoW
         H2J+wvXJp4qxAOprYa/+1P9ekc3qfK2cTqRPH9NlNVsRCA2Ifw7fdNyjQMRsyzWKV+rO
         sFPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738188252; x=1738793052;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1ldV1M6+Yu26kO2evXBO1Y0MEfQ9jNaRgIY5Fjf0wuk=;
        b=v6jFa3fsWh7nQCzpNt/YJwMJ5L/279KItw3u46E4CF9txLpmssDC5p36qK88c+YgkK
         STDx0MqQNpKtZYk28wWw39ME0Q02Hdga5Zv60fDKVdb+kUf38+F2jqzr3y7eYI6EpVcQ
         7yWoaEGPUz6SAbx1ZI6Shnsmzv2t+78CXBONbj0IIKGMRhC+kSP5zPdMak5tIl5SqRwv
         6XA/sp4RTpNEP+TxdheWEjKwSDQhzsc4OLW0IC85XfcV8Zr459TLiWZ+3g23aDrwGZKQ
         +GLU2uKfNe2pyuNsbuuem6PatNjefaEPVZFxQZTVltRwvqm/td/s2SAhKECHGDotslK6
         2HZg==
X-Forwarded-Encrypted: i=1; AJvYcCVZcZqhzlJRdSWxb52agj0EIR/dC9UQbWjb3qw67EWvb/2UYrmgZFzF2Tev1Ys2/363+rUgbqt0@lists.linux.dev
X-Gm-Message-State: AOJu0YyuCj6yM55pm7uQzZNu4cYimzb67fYNKzQRjXIsN/2YoPuJb9MG
	sPY5xufHr2CN24kjUkx0/nys0m7ttWX6LJQBb/IupuZC3SayR9nG
X-Gm-Gg: ASbGncuXTJPhpVsYt7VqZbd50jN7d+tdli3Tt/5aRxFtumsPgx8E6ackyJvgCHrGjke
	E72NMkLtkJo3fgLliMdsUNnjbt9mTl/BhGEHapICezdbFkQV1+8MyLlEObe7fRRts9+zUfbG3wb
	R+k8LuzmMiwflCepGt/gKNakDMhWufGUqCFSfsgy45SsGl+YvXXYhTdeK2qyJTCNrYeBEjBOOXJ
	RhyrlwjwLttTAwiWfTcncCEHKq8eUlqHVOZa0m4cWf8f9U6FOdRQKpYlK5gFOvu7YOG/FhFU5C7
	3MgJnGq2EtT70we9DCXwnfxyByEojxm7SG3wJDDkfZ2St5nLnpoaeaUml8qZIhtqkPA8wYC5nDT
	Dv/QxBg==
X-Google-Smtp-Source: AGHT+IG28gwSOqZJ/rczsIoYvUoEGqCNoTQSTEuFInyy5WoU0+Pkfi9W0Xw4/R/wK/2w3aJEOkj5ww==
X-Received: by 2002:a05:620a:8082:b0:7b6:cb81:95d with SMTP id af79cd13be357-7bffcce5723mr812381985a.21.1738188252312;
        Wed, 29 Jan 2025 14:04:12 -0800 (PST)
Received: from fauth-a2-smtp.messagingengine.com (fauth-a2-smtp.messagingengine.com. [103.168.172.201])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c00a8d0713sm8456285a.42.2025.01.29.14.04.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jan 2025 14:04:11 -0800 (PST)
Received: from phl-compute-09.internal (phl-compute-09.phl.internal [10.202.2.49])
	by mailfauth.phl.internal (Postfix) with ESMTP id 6479A120006A;
	Wed, 29 Jan 2025 17:04:10 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-09.internal (MEProxy); Wed, 29 Jan 2025 17:04:10 -0500
X-ME-Sender: <xms:2qWaZ52qh04LgMIa5gnXpnqPucEubFpgUTwKJSk5VlTKPPe7X-ziLA>
    <xme:2qWaZwHPvgnD2PD2JvmsEKvWpCwvabD4G17XAewA4_uLledhn0GG2aOqUJDcAbiYg
    HQkCoxIRT6sOGtLzw>
X-ME-Received: <xmr:2qWaZ55hhT7uSSlV3XotdRzxdcYPz6lf1T3Pi-d63Ex7QbmWFkODIfLzGzRb>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgdegudeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnecujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvden
    ucfhrhhomhepuehoqhhunhcuhfgvnhhguceosghoqhhunhdrfhgvnhhgsehgmhgrihhlrd
    gtohhmqeenucggtffrrghtthgvrhhnpeevuefgjeeugfeuveeifeegjeetleffleegteek
    ueethfdvgfekgeffuefghfejffenucffohhmrghinheprhhushhtqdhfohhrqdhlihhnuh
    igrdgtohhmpdhkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgr
    rhgrmhepmhgrihhlfhhrohhmpegsohhquhhnodhmvghsmhhtphgruhhthhhpvghrshhonh
    grlhhithihqdeiledvgeehtdeigedqudejjeekheehhedvqdgsohhquhhnrdhfvghnghep
    pehgmhgrihhlrdgtohhmsehfihigmhgvrdhnrghmvgdpnhgspghrtghpthhtohepudefpd
    hmohguvgepshhmthhpohhuthdprhgtphhtthhopehojhgvuggrsehkvghrnhgvlhdrohhr
    ghdprhgtphhtthhopegrlhgvgidrghgrhihnohhrsehgmhgrihhlrdgtohhmpdhrtghpth
    htohepghgrrhihsehgrghrhihguhhordhnvghtpdhrtghpthhtohepsghjohhrnhefpghg
    hhesphhrohhtohhnmhgrihhlrdgtohhmpdhrtghpthhtohepsggvnhhnohdrlhhoshhsih
    hnsehprhhothhonhdrmhgvpdhrtghpthhtoheprgdrhhhinhgusghorhhgsehkvghrnhgv
    lhdrohhrghdprhgtphhtthhopegrlhhitggvrhihhhhlsehgohhoghhlvgdrtghomhdprh
    gtphhtthhopehtmhhgrhhoshhssehumhhitghhrdgvughupdhrtghpthhtohepuggrkhhr
    sehkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:2qWaZ23wCbtE3ygOFm1J9F9Fe-Pnv_xtDtDf8VOvB2dG7_NtORIVkg>
    <xmx:2qWaZ8EQ_feer8-XvMsjXtml61WluqV6i6TqlJKig50S2MiBv4EOww>
    <xmx:2qWaZ38koES_WMJC5df1XKm5ztOtQBw5EWTbwMhMZov_3fvwPXYMxA>
    <xmx:2qWaZ5k1q1LptLfq4GVwlk8zHd_3vB7PHG25oFIhSvXoOIaJUCdA6w>
    <xmx:2qWaZwEVyiRM7PDTiPqMs1uhdCyy7AorezVZDM-UAfZTIC39FsWkrJd_>
Feedback-ID: iad51458e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 29 Jan 2025 17:04:09 -0500 (EST)
Date: Wed, 29 Jan 2025 14:04:08 -0800
From: Boqun Feng <boqun.feng@gmail.com>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH] MAINTAINERS: add Danilo Krummrich as Rust reviewer
Message-ID: <Z5ql2B4IGWW_FuSf@tardis.local>
References: <20250129215948.135486-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250129215948.135486-1-ojeda@kernel.org>

On Wed, Jan 29, 2025 at 10:59:48PM +0100, Miguel Ojeda wrote:
> Danilo has been involved with the Rust for Linux project for a year now.
> He is primarily working on the Nova GPU driver [1][2].
> 
> In addition, he has been active in the mailing list and most recently
> submitted the Device / Driver PCI / Platform series.
> 
> He is also already a maintainer of `RUST [ALLOC]` as well as several
> other DRM-related entries.
> 
> His expertise developing Rust abstractions and APIs for one of the major
> users of Rust in the kernel will be very useful to have around in the
> future. Thus add him to the `RUST` entry as reviewer.
> 
> Cc: Danilo Krummrich <dakr@kernel.org>
> Link: https://rust-for-linux.com/nova-gpu-driver [1]
> Link: https://lore.kernel.org/dri-devel/Zfsj0_tb-0-tNrJy@cassiopeiae/ [2]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Acked-by: Boqun Feng <boqun.feng@gmail.com>

Welcome!

Regards,
Boqun

> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 0fa7c5728f1e..64ee11eac61c 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -20466,6 +20466,7 @@ R:	Benno Lossin <benno.lossin@proton.me>
>  R:	Andreas Hindborg <a.hindborg@kernel.org>
>  R:	Alice Ryhl <aliceryhl@google.com>
>  R:	Trevor Gross <tmgross@umich.edu>
> +R:	Danilo Krummrich <dakr@kernel.org>
>  L:	rust-for-linux@vger.kernel.org
>  S:	Supported
>  W:	https://rust-for-linux.com
> -- 
> 2.48.1
> 
