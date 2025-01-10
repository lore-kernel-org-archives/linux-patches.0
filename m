Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99995205513
	for <patches@lists.linux.dev>; Fri, 10 Jan 2025 10:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736505906; cv=none; b=d9j7rGf6WcmoUoVGgPHYZN2TxBhtAIXwgRfZtigC4p5D/liHtrL6CaI6FyNTaEVxCCT9fA5sjSAVi4ZO8ziYi4+r965csNdGzYpD8mrJtu6Lt7kwJ4f8g3L+ywtHyB6RPa0B5/VdoyaI/IzgxxHg9BAXJxFHtdt7/TtaFECM5ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736505906; c=relaxed/simple;
	bh=oo9bGb4bFrCx3uBpRyZM133GR4ua2TD5WYyaLAYD0ME=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=r36PfkjSBAlBvp4cGxiwTqD4gzLTHNEtmBN9KJPZg6eHbnT/0KbRegRrCGSGCDsgUyGAq9sz/zColS9yZUf9/3UJS4Zzwoy0lAzw06PtHc8EQ5nRYsq0nlwe7PvBO3qbOYznsW16omz25XvwlB+qvOwSuiSUYQlblZgRoUH1gn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MtRhcfw7; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MtRhcfw7"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-2efdaa02378so380997a91.1
        for <patches@lists.linux.dev>; Fri, 10 Jan 2025 02:45:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736505904; x=1737110704; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oo9bGb4bFrCx3uBpRyZM133GR4ua2TD5WYyaLAYD0ME=;
        b=MtRhcfw7mghmYhn3c+0uV2H+SYPJFoTOBVWNoJL+dYQac9j8pTPj/syD/QCzuUuaQr
         vPgYfupAuKKUCSLXYPHWQo0AhYaovpngmfKee3k4tHbWv4M/0zEI8PzGGdywN6ifsntk
         ZeY9JfTyRWCRzvFIi15DDpdBvM/WygXCWjM8oqT80UhgqTsQ2lKWVSFRGPhVYa9f6bkX
         d2bMtmhGD/F7HixRLKzyXlH6fYoNLCeZVN9Wa/pJy5lVOazXQJbV8QOMeB1d8DBM+ghe
         47h45mbXhtMB/yrdTPZjMlsndFMQDJ3zldSsWuDcE5OF3fO46AZdzSvr9cnlA8z4Cbi6
         W5eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736505904; x=1737110704;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oo9bGb4bFrCx3uBpRyZM133GR4ua2TD5WYyaLAYD0ME=;
        b=ToSM+AGtb5i7SDpkwnrjBXbPS30JpC+nFphMko+jfJuWZPp3z4mBmQ4QC8YMwvWffJ
         3w/P83w4jYwhuevJ5oHmUEHuHJBd3JSwIXTK/jboLQxv6CqZWuJHFODy/LlifPnaGGnG
         s/3yyftJ+73N/BdhwbJ76jjcl8GBzIK8e3eVyKIvt+kdPHfPaf8o3kWRBlxEwBXwT0hM
         UBw4/ny+NGYwD76nzjTf+DAouhxvYdfORIU88C6IpCAcxN2SCQ4zwF5nfsFc3KqxPPD/
         WZbc3plZUHJ7MNr0/1SmmH/V1T0Ui38BOT/erVgfstdnBaWeK6SNrA0HcoUkjHBtbTIK
         v2Vw==
X-Forwarded-Encrypted: i=1; AJvYcCV8bl7c4/kOnxKwaejmNHehJj9+pmimJRbj6AH3tjuWPbADqDKAEtBH0Q4snMY90DWzsWYNfYY2@lists.linux.dev
X-Gm-Message-State: AOJu0Yzzheu3phWRrZpX+fQZc9iUmteGAUK9nPkV4eH0YIIlFWms3owQ
	9+G71AS9ZQrNRMeZA+GqCEJuvTL4WKwSlmazX3BTSzKlQhCA2P4GL48ueAjNucbE8PNpMnVkdNH
	VVIuc/JEZZDKDYHFRpJdu8IzasfQ=
X-Gm-Gg: ASbGncsZGafV/BkkfJa+Yx0KNMlHc2Bs+hgTwie4KJvQxDzArj3833MG44QrAFc7714
	cPzpxDLxLB+7LeVpVYtUQ+VnE17J8s1YkPvkCBw==
X-Google-Smtp-Source: AGHT+IEbNZBuLmaRgBcsm8R3xQ2C1O267JEPoFSswVUc2c6LmXdzbOtsRBMHYlyDSMraiJjX/QPW1oCp1JhPbpPM0m4=
X-Received: by 2002:a17:90b:37c3:b0:2f2:f6e5:d28e with SMTP id
 98e67ed59e1d1-2f548f1c677mr5770456a91.3.1736505904016; Fri, 10 Jan 2025
 02:45:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241123180639.260191-1-ojeda@kernel.org>
In-Reply-To: <20241123180639.260191-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Fri, 10 Jan 2025 11:44:52 +0100
X-Gm-Features: AbW1kvZ-6wVsYLH3Z85aGjQeaQNh26yqboHEUAMw9amj89Cs-YdsVrsxZf1LQ34
Message-ID: <CANiq72nvfGOkVCH7sie5mtn7Y3jzV2W0fbJacF5W-r+XUHLn7w@mail.gmail.com>
Subject: Re: [PATCH] rust: kbuild: run Clippy for `rusttest` code
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 23, 2024 at 7:07=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> Running Clippy for `rusttest` code is useful to catch issues there too,
> even if the code is not as critical. In the future, this code may also
> run in kernelspace and could be copy-pasted. Thus it is useful to keep
> it under the same standards. For instance, it will now make us add
> `// SAFETY` comments.
>
> It also makes everything more consistent.
>
> Thus clean the few issues spotted by Clippy and start running it.
>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Applied to `rust-next` -- thanks!

Cheers,
Miguel
