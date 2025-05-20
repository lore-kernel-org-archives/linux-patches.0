Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0043A250C06
	for <patches@lists.linux.dev>; Tue, 20 May 2025 19:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747769833; cv=none; b=RUu3+hGH9hc5B4v5Tb/Waf9i+0dFSrcFNVMF/qoFD6oqkVojcWICVAkIpiJZQwva0UujGoFovh11PYDGs8I8pUK/b9SBmmLBZSmLpwrU4/Ta8vSq5FZTbmRKIYY1ZXNE9Y/F7rist7rwpoRgqFRUuSbYfEx4dvALyLr4dCylx6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747769833; c=relaxed/simple;
	bh=yJmrJvk+batnwnKet1/z0D18l948QTmCnCbwr2N/m5I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uhleKY+cyiWnMKUft1dpJv/XbKIT8PgOPwVKpdRn452kjCsl7LkBpxefyaVM6Z/1URVl1zddIyj4Ta6b6r2FzeY5o5tIe5xZzoQ+m1WvtfnOif13HTYQIeHiYi9087C45chphCXUkyrhFlDr36NnkPwAKBNST4CWq+X/+VvKevQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Rdn3ZDUb; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Rdn3ZDUb"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-b1276984386so604545a12.0
        for <patches@lists.linux.dev>; Tue, 20 May 2025 12:37:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747769831; x=1748374631; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yJmrJvk+batnwnKet1/z0D18l948QTmCnCbwr2N/m5I=;
        b=Rdn3ZDUboE4noyNyOxWMNx2uZKiHmT48uCl8tMCer6otuP4n4cnb2oJgAytXJVlNKB
         wENpgdtlZaF3fATnv4uAsQzCrqWgtvOXifPSTm4k8DnHTPStLvrIKEzy9fZilUfQ3GkV
         0zItrKKikPccXrhKcYQcxx+wdRyYMVkA3NFm7ZmykBWBCXHkJa3CPlPNyn24xhq4Nsp7
         zSEBHiLkgOdSccr9zj30OkBIzeZUVuPbqUBb54BwbtoK490iNmtjRLgPcTmcxF11FvNF
         tvs7Ms8KYn3FqZwyYt9+u4LEe3qw9ZPuyFpD4H9pJcnOsSfcFvOycddncQZARGPFvop/
         8j5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747769831; x=1748374631;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yJmrJvk+batnwnKet1/z0D18l948QTmCnCbwr2N/m5I=;
        b=TcVZnaEDVeT+N4B88YDLajbIbSNGtHlaY3RYKo+Z/byvbwfIkSbW6e3rrUVbmMNj9K
         YwAm896pht5ffwj62zL3llf6GYO4nLRcQgZDSFrxpJV96QmZ1Gwx+SQk9XZyZw75+ztz
         YRws3rnnwF/akks6fK2aa6ornpDVc2GLmWrn38soO2LhaFuhaICsHVQ2rbraZs2/wa+R
         HQfpbzhTInoOg3VHHbZ9ncZUXOJWyxTSt55/nRBwfasd9vdbZRLQgUyxBorXdbhXvtA3
         /Y0guYP3qg/rQRJBEHQBB+AQu7O8XDu4iIWqbqhH305FaNxz31S7sZSzqkZEpFPTncqL
         LJ1w==
X-Forwarded-Encrypted: i=1; AJvYcCUVGkJdB4d37LZlHA9fGI8m4VZeHVKssuS37mVSZWh5xU3P0Qdn/in5aT3cdGAiRSUWu4LdixBE@lists.linux.dev
X-Gm-Message-State: AOJu0Yx1DA1Hh7MMwsztE8fGabe43MwY2qBjbtEImSdwI+mWb3LhKgHb
	HpBvnl9w8vpYEPGKNpx5BLEhnSDno+KFA1+YU4LqE1/8DSH2/gUWiAEG5FtzCCckP6hmnlwWcLg
	ZoNWh5PAuR6CVgB2IXc7YNrSCy7Q+Qmo=
X-Gm-Gg: ASbGncsN2rhqH130WCUqCE2o8mvv2zEZZsmpx0VUkx4CcODp9C2w+95ra4ri1Ehn8QJ
	+Ld5iWLNSR+EuiuO/lBynWhM9l6RWInI6JaSlbzBKje0ZQGR32lDcTZdluQe8ts9uYKMIkfV+DV
	hlIWM2sdQltIf2aWRGYj9JnUN1IAahpnwL
X-Google-Smtp-Source: AGHT+IHRYWQO+o6MeHbMj6f06qEP8DvM7w1Xe2r2Fhyflg1I5VaCbhW3BSNMk/qJJgj1bw9CC+AcMMksSMpaZZLrGkA=
X-Received: by 2002:a17:903:1aa7:b0:224:1212:7da1 with SMTP id
 d9443c01a7336-231d454c962mr86733025ad.13.1747769831293; Tue, 20 May 2025
 12:37:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250520192034.889415-1-ojeda@kernel.org> <CAJ-ks9=4DJdbUBiy_45wWPviOs48NEK1DmeqWnDaFSpkoda_GQ@mail.gmail.com>
In-Reply-To: <CAJ-ks9=4DJdbUBiy_45wWPviOs48NEK1DmeqWnDaFSpkoda_GQ@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 20 May 2025 21:36:57 +0200
X-Gm-Features: AX0GCFv7GwY_uuzeDx4i5uB4OAE_8m-4VXTRgK6xXtbANDNefPefyVLnTkVFpw0
Message-ID: <CANiq72mZafMsLOnLHGTsn_2yfYy4xf=OrTVHR68EqAx+6OBdww@mail.gmail.com>
Subject: Re: [PATCH] rust: kbuild: rebuild if `.clippy.toml` changes
To: Tamir Duberstein <tamird@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Masahiro Yamada <masahiroy@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nicolas@fjasle.eu>, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 20, 2025 at 9:24=E2=80=AFPM Tamir Duberstein <tamird@gmail.com>=
 wrote:
>
> It is possible to do this only if CLIPPY=3D1?

I kept it simple on purpose, since we will not save much (changing
`.clippy.toml` is quite rare to begin with), but I can add a
conditional (likely in a variable). Not sure if it is worth it.

Cheers,
Miguel
