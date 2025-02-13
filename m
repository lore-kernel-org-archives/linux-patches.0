Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC24211478
	for <patches@lists.linux.dev>; Thu, 13 Feb 2025 12:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739449342; cv=none; b=F5ULbDxLP1sVoA78wo01MbmERsYFmAOv4ouC9znH11XxsRXpbBcK/w0xYrm04XrdmcV+UB2BT0emNbOP/2yxlQl61f8tKUgxUWSL6AdWzoFQG2Zb3/NI26cVLEENJjHVVWQn8q3YVq+ob8teGwu+HEm4HXdqLm9fzHv8edHGPV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739449342; c=relaxed/simple;
	bh=JhQ8USlPxenG52f+etBxdWz9DV+4IdlE1eKF2Q41L/8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=h0oKAclRW5hmsA1tV6i6USNOBIHXl99kicniig9QpwhFWgRDI1av91DQisEA6hnKxxKLHmE+Z4E62YudXa+gRBF1DM9RDBgbSBfI7Ti/hNhXqaR2VhATWrPaLn8+1j9E/c8iLw3wqAzTHiYtcweKJG3nNDTchmmdKSUFZGPhkOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AB9qi8Ss; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AB9qi8Ss"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2fa8c788c74so174228a91.2
        for <patches@lists.linux.dev>; Thu, 13 Feb 2025 04:22:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739449339; x=1740054139; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JhQ8USlPxenG52f+etBxdWz9DV+4IdlE1eKF2Q41L/8=;
        b=AB9qi8Ss9bEnW2Kw5e7cj3tpKLDIsKYcIiqr5j9pbZ9mndBT6CQA7UO1wumlRTCLLl
         nPA32nlLUvmFoLfISPEqeD91IdvCo5QJ/Y4jwXyezS1xcw+bmgPMp9jbuP47eH9xSSc7
         xXOGDbfXEiLS1calbkl8iV/7cQkFeehHHGcJOe2w963ABEMz24yMvK1UuICuPVvFcGxv
         Bwdy1+t0PaxemLDPvYMtonW6KcpnP2G8Tp73lbmxdcJGN275Cqe23j4sA8mKl1n5uJ5U
         UIMGIaCnD+3LB8UzlqwlywoMRolqOB+gnf0+72BRxeHknqC/RGfJDa1UXbOgtS0lYGoE
         HLPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739449339; x=1740054139;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JhQ8USlPxenG52f+etBxdWz9DV+4IdlE1eKF2Q41L/8=;
        b=EzNWf2HH+6oZoHxqNbKww63GTrdJPwAeks0E834d4NgJq0XxwIS9BuY038jpSeBOTJ
         lEYI23NvgIEkgS76cvdt2A7uXMncjx+Nqg364AwwDmurdarKi4xnkunDgZUPtJ8bnjHT
         Nk633j40mVWH1wmA0kEVpTq8K1IV3Yl43Xb6A3mgqF/ZM8S+ocG3ZpaVFSrFXXnxcK9r
         91odw/hMejc8dMajSkj/cB4/W4YrVV6F4Qm8M4TJJ2wAu1f5XrpYo3doG1qNO8cZJUcb
         JLmYGV7FTx6yPGfBkPjLJ5TugJJSFLg1YbK1cONQgpu+JJIeudjZneHIvJO2DPNmQX05
         rdVA==
X-Forwarded-Encrypted: i=1; AJvYcCWa63EwNFxwtgB5IHKWUmY2OwZowvVSoA/p4qcrx2cM2LpbHdI1/ydvFyLIYhmSUVWByaLX0cHW@lists.linux.dev
X-Gm-Message-State: AOJu0YxmPJinTpgarzamMbbhZt7IgvpWWSNcuDSDgnFWS7aMteIEoSh3
	4pfoSuRHO5d2Eyky0iY4Jp3udCgem5h5OUataS7pbdA8SuNAJQXVhQRWE7TrAf/h2d8S9weaDBP
	vx9zi3ydJexNyCISvRoWy9RQekQw=
X-Gm-Gg: ASbGncuw45hx25q/OyQK5TYWX/fwyL9odPBy9EEWm9BLqbckxkOk6xJu9+peOGfIzvO
	OwXsWAavaJPAeHiBwZnNx58NKjTBWMIpOMYAxaLUfOEIfs1IW5mbfJECOieAgUI81Hc3C9Yb2
X-Google-Smtp-Source: AGHT+IHmYvEzL9KGp/GiZCJityFb8+Au3r1Y0YDY9cYrjSKGnUmZw+tnh/sBiqD37rnyvyHdxym1Eq0TTuz5tYj63uE=
X-Received: by 2002:a17:90b:33cb:b0:2ea:853a:99e0 with SMTP id
 98e67ed59e1d1-2fbf5c75392mr4064811a91.5.1739449339042; Thu, 13 Feb 2025
 04:22:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250210163732.281786-1-ojeda@kernel.org> <20250211103333.GB8653@willie-the-truck>
In-Reply-To: <20250211103333.GB8653@willie-the-truck>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 13 Feb 2025 13:22:06 +0100
X-Gm-Features: AWEUYZnMSt2s3upFBai0wYaA0s4vfSFiHEc-syAvZrBIXeINByCQBVsZZ4yEXKc
Message-ID: <CANiq72=n++Hb1KX5fHCN=XayfPOxgayb=sDG4AvyEnDOZqAsNA@mail.gmail.com>
Subject: Re: [PATCH] arm64: rust: clean Rust 1.85.0 warning using softfloat target
To: Will Deacon <will@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, 
	moderated for non-subscribers <linux-arm-kernel@lists.infradead.org>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, stable@vger.kernel.org, 
	Matthew Maurer <mmaurer@google.com>, Ralf Jung <post@ralfj.de>, 
	Jubilee Young <workingjubilee@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 11, 2025 at 11:33=E2=80=AFAM Will Deacon <will@kernel.org> wrot=
e:
>
> Patch looks fine to me, but I'll wait for Matthew to confirm that it
> works for them. I'm also fine with adding the rustc-min-version helper
> at the same time, tbh -- it's not exactly rocket science, but it would
> need an Ack from Masahiro.

Thanks Will -- happy to take it through the Rust tree for if needed
with your Ack, I have to send a couple other bits anyway for -rc3.

And, yeah, I went back and forth on whether to do the helper directly... :)

Cheers,
Miguel
